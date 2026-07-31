<?php

if (PHP_SAPI !== 'cli')
{
	fwrite(STDERR, "CLI only.\n");
	exit(1);
}

$aOptions = getopt('', array('root:', 'output:', 'ids:', 'manifest:'));
$sRoot = isset($aOptions['root']) ? realpath($aOptions['root']) : FALSE;
$sOutput = isset($aOptions['output']) ? $aOptions['output'] : FALSE;
$sManifest = isset($aOptions['manifest']) ? $aOptions['manifest'] : FALSE;
$aAllowedDocumentIds = array(5, 6, 7, 17, 19, 31, 33, 34, 36, 37, 38);
$aDocumentIds = array_values(array_unique(array_filter(array_map('intval', explode(',', strval($aOptions['ids'] ?? ''))))));

function zs_export_fail($sMessage)
{
	fwrite(STDERR, $sMessage . "\n");
	exit(1);
}

if (!$sRoot || !is_file($sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php'))
{
	zs_export_fail('Invalid --root.');
}

if (!$sOutput || (!is_dir($sOutput) && !mkdir($sOutput, 0750, TRUE)))
{
	zs_export_fail('Invalid --output.');
}

if (!$aDocumentIds || array_diff($aDocumentIds, $aAllowedDocumentIds))
{
	zs_export_fail('Invalid --ids. Allowed: ' . implode(',', $aAllowedDocumentIds));
}

require_once $sRoot . DIRECTORY_SEPARATOR . 'bootstrap.php';

$aManifest = array();

foreach ($aDocumentIds as $iDocumentId)
{
	$oDocument = Core_Entity::factory('Document');
	$oDocument->find($iDocumentId);

	if (!$oDocument->loaded())
	{
		zs_export_fail("Document {$iDocumentId} not found.");
	}

	$sContent = strval($oDocument->text);
	$sFile = rtrim($sOutput, DIRECTORY_SEPARATOR) . DIRECTORY_SEPARATOR . $iDocumentId . '.html';

	if (file_put_contents($sFile, $sContent) === FALSE)
	{
		zs_export_fail("Cannot write {$sFile}.");
	}

	$aManifest[] = array(
		'id' => $iDocumentId,
		'name' => $oDocument->name,
		'sha256' => hash('sha256', $sContent)
	);

	printf("%d exported\n", $iDocumentId);
}

if ($sManifest && file_put_contents($sManifest, json_encode($aManifest, JSON_UNESCAPED_UNICODE | JSON_PRETTY_PRINT)) === FALSE)
{
	zs_export_fail('Cannot write --manifest.');
}

echo "Export complete.\n";
