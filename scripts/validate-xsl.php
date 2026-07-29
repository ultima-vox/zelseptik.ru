<?php

if (PHP_SAPI !== 'cli' || $argc < 2)
{
	fwrite(STDERR, "Usage: php validate-xsl.php FILE...\n");
	exit(1);
}

libxml_use_internal_errors(TRUE);
$bValid = TRUE;

foreach (array_slice($argv, 1) as $sFile)
{
	$sXml = file_get_contents($sFile);
	$sXml = preg_replace('/^\xEF\xBB\xBF/', '', $sXml);
	$sXml = preg_replace('/<!DOCTYPE\s+[^>]+>/i', '', $sXml, 1);
	$oDocument = new DOMDocument();
	$bLoaded = $oDocument->loadXML($sXml, LIBXML_NONET);

	if (!$bLoaded)
	{
		$bValid = FALSE;
		fwrite(STDERR, $sFile . ": invalid\n");

		foreach (libxml_get_errors() as $oError)
		{
			fwrite(STDERR, trim($oError->message) . " at line {$oError->line}\n");
		}
	}
	else
	{
		echo $sFile . ": valid\n";
	}

	libxml_clear_errors();
}

exit($bValid ? 0 : 1);
