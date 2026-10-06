# Blueprint hero and mobile menu verification — 2026-10-06

Installed only on isolated dev. Production and HostCMS database were not changed.

Source: 65df0ac39166d07c3ab8b25252c4d78a04cc57fd. Successful final deployment: https://github.com/ultima-vox/zelseptik.ru/actions/runs/37427607533.

- XSL 3 and 13 now place existing category H1 and breadcrumbs inside a blueprint hero, retaining the original information systems, groups, links and pagination. XSL 55 already provides shop category heroes.
- Hero background uses muted green paper (#123D35), 24px minor / 120px major grid, and grayscale inverted photographic blending below the grid. This is a photographic approximation, not a generated contour drawing.
- Green background headings are off-white; light product panels inherit dark text. Badges use dark green on light mint; outlined producer badges and slogans use muted mint.
- Mobile drawer JavaScript stages the transform across animation frames, transfers focus without scrolling after motion settles, retains the scroll lock through closing, and handles rapid reversals. Closed content is inert; reduced motion is supported.

Validation: 324 baseline checksums; XSL fixtures including root/group heroes and one H1; menu lifecycle and carousel checks; 13 backup/rollback tests. Live browser verified the category hero on /remont-septikov/, main badge and slogan, catalogue, and readable product specifications on /septiki/lotos/lotos-aerolotos-aero-3/. CSS and JS public bytes matched the first new source; final deployment readback passed.

Limitation: no physical mobile device or browser viewport emulation is available in this session, so menu animation on the user's phone is not yet verified. No lead forms were submitted.

Palette verification: live browser confirmed main hero and photograph backing #123D35, heading #F4F8F5, secondary text #D8E7DF, slogan #AED0BF, product badge #214B3F on #E5EFE9, and dark specifications in white cards. Calculated solid-color contrast: 11.2:1 heading, 9.4:1 secondary text, 7.2:1 slogan, 8.3:1 badge. Existing primary buttons remain #009966.
