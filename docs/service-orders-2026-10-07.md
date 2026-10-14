# Service order context

Existing Shop 6 orders now pass `data-order-kind="service"` from XSL 55, 56, 176 and 278 into the existing lead modal. Other shops retain installation context. Service modal titles, subtitles and comments identify maintenance, the context label is “Услуга”, and equipment characteristics are excluded. Existing service/repair select option is selected; equipment/install options are hidden and disabled. Opening an installation or general estimate restores the relevant choices.

XSL 56 keeps the main Shop 6 hero image static and omits its gallery thumbnails. Equipment galleries are unchanged.

Verified on isolated dev: 13 city service cards, Moscow detail and quote modal, installation modal in the Odintsovo regional catalog. No test leads submitted. Render tests cover both shop contexts in all four XSL templates; HostCMS translations use placeholders only in the offline test resolver. Production untouched.
