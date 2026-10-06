# Remaining UI changes — 2026-10-06

Dev only. Production and the HostCMS database are not changed.

- Regional information detail 280: approved green blueprint hero, original CMS H1/description/photo and callback link.
- Regional listing 279: category hero; existing city/tag links remain.
- Existing shop listing 278: approved catalog-card structure, original model URL/image/price/discount and actual modification properties. Existing catalog item wrappers remain for filtering.
- Shop detail 56: shop 6 service labels; other shops keep equipment labels.
- Shared information module: styles real HostCMS 404 documents at their requested URL; converts the existing catalog section heading to H2 when a regional page hero provides H1.
- Original 278 bytes archived; baseline manifest verifies their hash.

Integration source: official HostCMS documentation only:
https://www.hostcms.ru/documentation/step-by-step/templates/show-shop/
Existing XML fields and XSL slots are used; no new shop or information system.

Validation: rendered XSL fixtures, original checksums, prices/links/lead forms, DOM node preservation, true-error isolation and repeated initialization. FTP deployment preserves drift detection, encrypted backup, readback and rollback; 278 is the only addition to the fixed allowlist (18 paths total).

Mobile layout uses 3/2/1 catalog columns. Physical device animation verification remains outside the available browser capabilities. No live lead form is submitted.

Live review follow-up: regional container width and sidebar alignment are fixed. Regional price columns now use the existing semantic table normalizer; FAQ uses the approved FAQ classes and native details, retaining original answers and form nodes. All 24 regional paths returned 200 and 270 approved cards; 204 same-model prices matched the previous audit by URL, 66 dynamically selected cards had no same-model reference in that sample. Source DB was not edited.

SEO baseline started (read only): both production and dev sitemap.xml fail strict XML parsing because content follows the root element. Dev remains noindex,nofollow; production samples remain index,follow. Regional catalog has a client-side H1-to-H2 correction; move this to server output during SEO work. No SEO configuration changed in this UI deployment.
