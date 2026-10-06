"""Read-only dev FTP inspection. No configs, customer data or raw logs are printed."""
import ftplib, hashlib, io, json, os, re
ftp = ftplib.FTP(timeout=30)
ftp.connect("92.63.102.79", 21)
ftp.login("zelseptik", os.environ["DEV_FTP_PASSWORD"])
ftp.set_pasv(True)
def read(path):
    buffer = io.BytesIO()
    def collect(data):
        if buffer.tell() + len(data) > 4000000: raise RuntimeError("size limit")
        buffer.write(data)
    ftp.retrbinary("RETR " + path, collect)
    return buffer.getvalue()
for path in ["/modules/core", "/hostcmsfiles"]:
    ftp.cwd(path)
    names=ftp.nlst()
    print("inventory", path, [n for n in names if re.search(r"sitemap|log|cache", n, re.I)])
for path in ["/modules/core/sitemap.php", "/hostcmsfiles/lib/lib_29/lib_config_29.php", "/templates/template13/template.htm"]:
    data=read(path)
    print("file", path, "sha256",hashlib.sha256(data).hexdigest(),"bytes",len(data))
    s=data.decode("utf-8",errors="replace")
    if path.endswith("sitemap.php"):
        lines=s.splitlines()
        starts=[i for i,l in enumerate(lines) if re.search(r"function (execute|_close|_getIndexFilePath|_getSitemapDir|createSitemapDir)",l)]
        for start in starts:
            end=next((i for i in range(start+1,len(lines)) if re.search(r"function \w+",lines[i])), min(len(lines),start+240))
            print("method",start+1,lines[start].strip())
            for i in range(start+1,end):
                l=lines[i]
                calls=re.findall(r"(?:[A-Za-z_]+::|->)?[A-Za-z_]\w*(?=\s*\()",l)
                if calls: print("calls",i+1,calls)
                if True:
                    print("structure",i+1,re.sub(r"(['\"])(.*?)(?<!\\)\1","'literal'",l).strip())
        print("exceptions", [(i+1,re.findall(r"new ([A-Za-z_]+)",l)) for i,l in enumerate(lines) if "throw " in l])
    elif path.endswith("template.htm"):
        print("catalog_heading",s.count('<h1 class="h-2">Каталог продукции:</h1>'))
ftp.cwd('/hostcmsfiles/logs')
print('log_inventory',ftp.nlst()[-10:])
ftp.quit()
