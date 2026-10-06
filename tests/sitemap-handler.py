"""Exercise the actual handler in separate PHP processes (it intentionally exits)."""
from pathlib import Path
import subprocess,tempfile
root=Path(__file__).resolve().parents[1]
stub=r'''<?php
class Core_Session { static function close() {} }
class Core_Array { static function get($a,$k,$d=NULL) { return isset($a[$k]) ? $a[$k] : $d; } }
class Core_Page { public $libParams=array('createIndex'=>FALSE,'showInformationsystemGroups'=>TRUE,'showInformationsystemItems'=>TRUE,'showShopGroups'=>TRUE,'showShopItems'=>TRUE); static function instance(){static $p;return $p ?: $p=new self;} }
class TestSite { function getCurrentAlias(){return new stdClass;} function getByAlias($a){return $this;} }
class Core_Entity { static function factory($name){return new TestSite;} }
class Core { static $url=array('host'=>'dev.zelseptik.ru');static function moduleIsActive($name){return TRUE;} }
class Core_Sitemap {
    public $index;
    function __construct($site){}
    function createIndex($v){$this->index=$v;return $this;}
    function __call($method,$args){return $this;}
    function execute(){
        if (!$this->index) throw new Exception('stdout mode is broken');
        echo '<?xml version="1.0"?><sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9"><sitemap><loc>https://zelseptik.ru/hostcmsfiles/sitemap/test.xml</loc></sitemap></sitemapindex>';
        if (getenv('SEO_FAIL')) throw new Exception('cache failed after output');
        return $this;
    }
}
register_shutdown_function(function(){fwrite(STDERR,'STATUS:'.http_response_code());});
ob_start();
echo 'template output must be removed';
require $argv[1];
'''
import os
with tempfile.TemporaryDirectory() as tmp:
    f=Path(tmp)/'fixture.php';f.write_text(stub)
    for fail in ('','1'):
        env=dict(os.environ,SEO_FAIL=fail)
        r=subprocess.run(['php',str(f),str(root/'hostcmsfiles/lib/lib_29/lib_config_29.php')],env=env,text=True,capture_output=True,check=True)
        if fail:
            assert r.stdout=='Sitemap temporarily unavailable.',r.stdout
            assert 'STATUS:503' in r.stderr,r.stderr
        else:
            from xml.etree import ElementTree as ET
            assert ET.fromstring(r.stdout).tag.endswith('sitemapindex'),r.stdout
            assert 'Sitemap error' not in r.stdout
print('PASS: indexed XML success; failure discards partial XML and returns 503')
