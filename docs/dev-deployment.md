# Deploy to isolated dev

`Deploy dev UI` is a manual workflow. Its only destination is the user's confirmed
isolated dev FTP account: 92.63.102.79:21, zelseptik, root /. It uses the existing
repository secret `DEV_FTP_PASSWORD`. No production credentials are accepted.

The source is pinned to reviewed content-layout commit
`9f2c67284445a153c4228d21113a0739e4b4f680` (PR #14), based on the content
container follow-up (PR #12) and first UI stage (PR #6). No other repository files, archive exports or database rows are deployed.
The eight paths are explicitly listed in `scripts/deploy-dev-ui.py`.

Run Actions → Deploy dev UI → Run workflow. `inspect` reads current file hashes
without writes. `deploy` performs the same checks, backs up the actual current dev
files, then uploads the stage. Any source drift aborts; there is no force option.
Already deployed files are accepted. Exact previous-stage hashes for information-pages.css (initial and content-layout
versions) and XSL 4 are accepted for this update; unknown edits abort.
After the successful initial deployment, only these two UI files need replacing. Absence of a required directory aborts.

Read-only run 37314881595 found the current main template differs from the original
backup (SHA-256 696f886b5d2b140a58e5a04609ea5b5992a14734686b9cbb722fa6eb8979de8a).
For this exact version, the workflow preserves all current bytes and inserts only
the information-pages.css call immediately before the single active chained
showCss() call. Other existing CSS calls are preserved; commented examples are
excluded. It does not overwrite the main template from the older repository.
A changed hash or missing/ambiguous anchor aborts. The narrowly patched form is
recognized on subsequent runs; no force option is added.

Before any replacement a gzip tar backup is encrypted with OpenSSL AES-256-CBC,
PBKDF2-HMAC-SHA256, 200000 iterations, a random salt, using the FTP password at the
time of deployment. Decryption is checked locally; the encrypted backup is uploaded
under `.ui-deploy-backups/` and downloaded again for byte verification. The dedicated
folder is created by this FTP account, rather than reusing an older staging backup
folder that may have a different owner. If creation or writing is forbidden, the
workflow stops without replacing site files and reports the FTP permission reply.
It never changes server ownership or permissions. Its path and
SHA-256 appear in the run log. Plaintext source backups are never uploaded or logged.
Keep that password for recovery even if the FTP password later changes. CBC provides
confidentiality, not authenticated encryption; retain the logged ciphertext hash.

An upload failure triggers a best-effort rollback of attempted replacements. If the
connection is lost, automatic rollback may fail. FTP replacements are sequential,
not an atomic transaction, and a page request during an upload may see a partial
file. Each upload is read back and verified. Do not edit these files concurrently.
The existing FTP service transmits credentials and files without TLS.

To recover manually, download the exact encrypted backup named in the run log via
FTP. Check its SHA-256 against the log, then on a trusted machine run:

```sh
openssl enc -d -aes-256-cbc -pbkdf2 -iter 200000 -md sha256 \
  -in service-ui-BACKUP-ID.tar.gz.enc -out service-ui-backup.tar.gz
```

OpenSSL prompts for the original deployment password. Extract the backup privately.
Restore its listed files to the corresponding existing paths on dev. `manifest.json`
records absent files; remove a newly deployed file only if that manifest marks its
original absent. Do not place the plaintext backup in the website root or repository.

HostCMS integration preserves existing template IDs 1/3 and XSL IDs 4/13, information
systems and shops. File-backed template paths are documented by HostCMS:
https://www.hostcms.ru/documentation/modules/template/template/
https://www.hostcms.ru/documentation/modules/xsl/
The site's `templates/template3/script.js` is an existing custom resource; it is not
claimed to be the standard HostCMS JavaScript tab file (`javascript.js`). Production
styles and CMS metadata are not changed. No undocumented CMS API is invoked.

A successful FTP upload is not browser or CMS acceptance. Check services, a service
detail, a shared-XSL article, montage/service/repair and the six approved pages at
375/768/1024/1440 px. Confirm asset loading and actual existing form processing.
CMS/OPcache may retain previous output; the workflow does not invent a cache-clearing
API or purge cache folders. If the page still uses old code, use the existing CMS
administration/server process to diagnose it. Root cleanup is a separate operation;
this workflow does not move or delete unrelated files.

## Verified initial deployment

Run 37320029965 on 2026-10-05 successfully uploaded and verified all eight files.
Backup: `.ui-deploy-backups/service-ui-a8206fa8fc2e482ebc34c81c378b9fad.tar.gz.enc`,
SHA-256 `eb13027c65d5820370bdce6c903653d0577c8397f87fa503b44aa484a82ac451`.
The dev main template after the narrow CSS insertion has SHA-256
`75c23f701730c078768fad3095da3cedbdec932994736ec439772b91b4073b26`.
Browser inspection confirmed the service hero and transformed price table; the
container and step-grid follow-up still awaits deployment and visual acceptance.

## Delivery hero CSS follow-up

Current dev DOM confirms runtime CSS overrides grid--2 with repeat(2, 1fr).
NBSP-linked headings expand intrinsic track widths, producing unequal cards.
The existing delivery aside label scopes a CSS override: minmax(0, 1fr) tracks,
token-based card padding/title size, top alignment, stacked main columns below
1280px and equal columns above. Card grid: one column below 768px, two above.
The CSS is loaded after runtime through the existing information-pages.css call.
No CMS documents, entities, URLs, global grid rules or templates are edited.
Parent-grid scoping uses :has(); check the supported modern browsers during QA.
This follow-up is prepared, not yet visually accepted or deployed. Run the latest
main workflow once the previous queued deployment finishes. If the content-layout
follow-up is already installed, only CSS is uploaded; otherwise XSL 4 is also updated.
