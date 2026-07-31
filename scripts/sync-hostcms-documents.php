<?php

if (PHP_SAPI !== 'cli')
{
	fwrite(STDERR, "CLI only.\n");
	exit(1);
}

$aOptions = getopt('', array(
	'root:',
	'source:',
	'ids:',
	'manifest:',
	'expected:',
	'backup:',
	'environment:',
	'apply'
));
$sRoot = isset($aOptions['root']) ? realpath($aOptions['root']) : FALSE;
$sSource = isset($aOptions['source']) ? realpath($aOptions['source']) : FALSE;
$sManifest = isset($aOptions['manifest']) ? $aOptions['manifest'] : FALSE;
$sExpected = isset($aOptions['expected']) ? realpath($aOptions['expected']) : FALSE;
$sBackup = isset($aOptions['backup']) ? $aOptions['backup'] : FALSE;
$sEnvironment = isset($aOptions['environment']) ? trim($aOptions['environment']) : '';
$bApply = array_key_exists('apply', $aOptions);
$aAllowedDocumentIds = array(5, 6, 7, 17, 19, 31, 33, 34, 36, 37, 38);
$aDocumentIds = array_values(array_unique(array_filter(array_map('intval', explode(',', strval($aOptions['ids'] ?? ''))))));

function zs_sync_fail($sMessage)
{
	fwrite(STDERR, $sMessage . "\n");
	exit(1);
}

if (!$sRoot || !is_file($sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php'))
{
	zs_sync_fail('Invalid --root.');
}

if (!$sSource || !is_dir($sSource))
{
	zs_sync_fail('Invalid --source.');
}

if (!$aDocumentIds || array_diff($aDocumentIds, $aAllowedDocumentIds))
{
	zs_sync_fail('Invalid --ids. Allowed: ' . implode(',', $aAllowedDocumentIds));
}

if ($bApply && !in_array($sEnvironment, array('dev.zelseptik.ru', 'zelseptik.ru'), TRUE))
{
	zs_sync_fail('Apply requires an allowed --environment.');
}

if ($bApply && $sRoot !== realpath('/var/www/zelseptik/data/www/' . $sEnvironment))
{
	zs_sync_fail('Apply root does not match --environment.');
}

if ($bApply && (!$sExpected || !is_file($sExpected)))
{
	zs_sync_fail('Apply requires --expected dry-run manifest.');
}

if ($bApply && (!$sBackup || file_exists($sBackup)))
{
	zs_sync_fail('Apply requires a new --backup directory.');
}

require_once $sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php';

$aExpectedById = array();

if ($bApply)
{
	$aExpectedRows = json_decode(file_get_contents($sExpected), TRUE);

	if (!is_array($aExpectedRows))
	{
		zs_sync_fail('Invalid --expected manifest.');
	}

	foreach ($aExpectedRows as $aExpectedRow)
	{
		$aExpectedById[intval($aExpectedRow['id'] ?? 0)] = $aExpectedRow;
	}
}

$aRows = array();

foreach ($aDocumentIds as $iDocumentId)
{
	$sFile = $sSource . DIRECTORY_SEPARATOR . $iDocumentId . '.html';

	if (!is_file($sFile))
	{
		zs_sync_fail("Missing source: {$sFile}");
	}

	$oDocument = Core_Entity::factory('Document');
	$oDocument->find($iDocumentId);

	if (!$oDocument->loaded())
	{
		zs_sync_fail("Document {$iDocumentId} not found.");
	}

	$sCurrent = strval($oDocument->text);
	$sSourceContent = file_get_contents($sFile);

	if ($sSourceContent === FALSE)
	{
		zs_sync_fail("Cannot read source: {$sFile}");
	}

	$sNext = $sSourceContent;
	$sBeforeHash = hash('sha256', $sCurrent);
	$sAfterHash = hash('sha256', $sNext);

	if ($bApply)
	{
		$aExpectedRow = $aExpectedById[$iDocumentId] ?? array();

		if (($aExpectedRow['before_sha256'] ?? '') !== $sBeforeHash || ($aExpectedRow['after_sha256'] ?? '') !== $sAfterHash)
		{
			zs_sync_fail("Document {$iDocumentId} changed after dry-run.");
		}
	}

	$aRows[] = array(
		'id' => $iDocumentId,
		'name' => $oDocument->name,
		'document' => $oDocument,
		'current' => $sCurrent,
		'next' => $sNext,
		'changed' => $sCurrent !== $sNext,
		'before_sha256' => $sBeforeHash,
		'after_sha256' => $sAfterHash
	);
}

$aPublicManifest = array_map(function ($aRow) {
	unset($aRow['document'], $aRow['current'], $aRow['next']);
	return $aRow;
}, $aRows);

if (!$bApply)
{
	foreach ($aRows as $aRow)
	{
		printf("%d %s dry-run\n", $aRow['id'], $aRow['changed'] ? 'changed' : 'same');
	}

	if ($sManifest && file_put_contents($sManifest, json_encode($aPublicManifest, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) === FALSE)
	{
		zs_sync_fail('Cannot write --manifest.');
	}

	echo "Dry-run complete.\n";
	exit(0);
}

if (!mkdir($sBackup, 0750, TRUE))
{
	zs_sync_fail('Cannot create --backup directory.');
}

foreach ($aRows as $aRow)
{
	$sBackupFile = $sBackup . DIRECTORY_SEPARATOR . $aRow['id'] . '.html';
	$iWritten = file_put_contents($sBackupFile, $aRow['current']);

	if ($iWritten === FALSE || hash_file('sha256', $sBackupFile) !== $aRow['before_sha256'])
	{
		zs_sync_fail("Backup verification failed for document {$aRow['id']}.");
	}
}

$sBackupManifest = $sBackup . DIRECTORY_SEPARATOR . 'manifest.json';

if (file_put_contents($sBackupManifest, json_encode($aPublicManifest, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) === FALSE)
{
	zs_sync_fail('Cannot write backup manifest.');
}

$oDatabase = Core_DataBase::instance();
$oDatabase->begin();

try
{
	foreach ($aRows as $aRow)
	{
		$iDocumentId = intval($aRow['id']);
		$aLockedRow = $oDatabase
			->setQueryType(0)
			->query("SELECT `text` FROM `documents` WHERE `id` = {$iDocumentId} FOR UPDATE")
			->asAssoc()
			->current();

		if (!is_array($aLockedRow) || hash('sha256', strval($aLockedRow['text'])) !== $aRow['before_sha256'])
		{
			throw new RuntimeException("Document {$iDocumentId} changed before apply.");
		}

		if (!$aRow['changed'])
		{
			continue;
		}

		$oDocument = $aRow['document'];
		$oDocument->text = $aRow['next'];
		$oDocument->datetime = Core_Date::timestamp2sql(time());
		$oDocument->save();

		$aSavedRow = $oDatabase
			->setQueryType(0)
			->query("SELECT `text` FROM `documents` WHERE `id` = {$iDocumentId}")
			->asAssoc()
			->current();

		if (!is_array($aSavedRow) || hash('sha256', strval($aSavedRow['text'])) !== $aRow['after_sha256'])
		{
			throw new RuntimeException("Document {$iDocumentId} verification failed.");
		}
	}

	$oDatabase->commit();
}
catch (Throwable $oException)
{
	$oDatabase->rollback();
	zs_sync_fail('Transaction rolled back: ' . $oException->getMessage());
}

foreach ($aRows as $aRow)
{
	printf("%d %s apply\n", $aRow['id'], $aRow['changed'] ? 'changed' : 'same');
}

echo "Applied.\n";
