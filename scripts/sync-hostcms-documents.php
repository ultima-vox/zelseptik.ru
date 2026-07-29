<?php

if (PHP_SAPI !== 'cli')
{
	fwrite(STDERR, "CLI only.\n");
	exit(1);
}

$aOptions = getopt('', array('root:', 'source:', 'backup:', 'apply'));
$sRoot = isset($aOptions['root']) ? realpath($aOptions['root']) : FALSE;
$sSource = isset($aOptions['source']) ? realpath($aOptions['source']) : FALSE;
$sBackup = isset($aOptions['backup']) ? $aOptions['backup'] : FALSE;
$bApply = array_key_exists('apply', $aOptions);
$aDocumentIds = array(5, 6, 7, 37, 38);

if (!$sRoot || !is_file($sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php'))
{
	fwrite(STDERR, "Invalid --root.\n");
	exit(1);
}

if (!$sSource || !is_dir($sSource))
{
	fwrite(STDERR, "Invalid --source.\n");
	exit(1);
}

if ($bApply && (!$sBackup || (!is_dir($sBackup) && !mkdir($sBackup, 0750, TRUE))))
{
	fwrite(STDERR, "Cannot create --backup directory.\n");
	exit(1);
}

require_once $sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php';

$aManifest = array();

foreach ($aDocumentIds as $iDocumentId)
{
	$sFile = $sSource . DIRECTORY_SEPARATOR . $iDocumentId . '.html';

	if (!is_file($sFile))
	{
		fwrite(STDERR, "Missing source: {$sFile}\n");
		exit(1);
	}

	$oDocument = Core_Entity::factory('Document');
	$oDocument->find($iDocumentId);

	if (!$oDocument->loaded())
	{
		fwrite(STDERR, "Document {$iDocumentId} not found.\n");
		exit(1);
	}

	$sCurrent = strval($oDocument->text);
	$sNext = trim(file_get_contents($sFile));
	$bChanged = trim($sCurrent) !== $sNext;

	$aManifest[] = array(
		'id' => $iDocumentId,
		'name' => $oDocument->name,
		'changed' => $bChanged,
		'before_sha256' => hash('sha256', $sCurrent),
		'after_sha256' => hash('sha256', $sNext)
	);

	printf("%d %s %s\n", $iDocumentId, $bChanged ? 'changed' : 'same', $bApply ? 'apply' : 'dry-run');

	if ($bApply && $bChanged)
	{
		file_put_contents($sBackup . DIRECTORY_SEPARATOR . $iDocumentId . '.html', $sCurrent);
		$oDocument->text = $sNext;
		$oDocument->datetime = Core_Date::timestamp2sql(time());
		$oDocument->save();
	}
}

if ($bApply)
{
	file_put_contents(
		$sBackup . DIRECTORY_SEPARATOR . 'manifest.json',
		json_encode($aManifest, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)
	);
}

echo $bApply ? "Applied.\n" : "Dry-run complete.\n";
