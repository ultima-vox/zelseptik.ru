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
