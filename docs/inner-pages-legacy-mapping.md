# Inner pages legacy mapping

Добавлен файл:

```text
src/scss/legacy/_inner-pages.scss
```

Назначение — вынести повторяющиеся legacy aliases для внутренних страниц:

```text
/dostavka/
/promotion/
/about/
/contacts/
```

## Ограничение проверки

Внешний web-fetch по страницам dev-сайта вернул `Cache miss`, поэтому прямой DOM этих страниц не был доступен через инструмент.

Дополнительно проверены SCSS-страницы в репозитории:

```text
src/scss/pages/_about.scss
src/scss/pages/_contacts.scss
src/scss/pages/_delivery.scss
```

Они сейчас являются заглушками:

```scss
/* Page-specific overrides only. Prefer components and patterns. */
```

Поэтому повторяющиеся сущности не добавлялись в `pages/*`, а вынесены в legacy mapping.

## Что покрыто

### Inner hero

Общие классы:

```scss
.inner-hero
.page-hero
.delivery-hero
.promotion-hero
.about-hero
.contacts-hero
contact-hero
```

Их элементы:

```scss
__grid
__content
__title
__text
__actions
```

Маппятся на hero pattern.

### Inner sections

Общие классы:

```scss
.inner-section
.page-section
.delivery-section
.promotion-section
.about-section
.contacts-section
contact-section
```

Их элементы:

```scss
__header
__title
__text
```

Маппятся на section / section-header pattern.

### Promotion / offers / gifts

Покрыты повторяющиеся карточки:

```scss
.promotion-card
.promo-card
.offer-card
.gift-card
.discount-card
.promotion-item
.promo-item
.offer-item
.gift-item
.discount-item
```

И элементы:

```scss
__title
__text
__price
__actions
__btn
```

### CTA gift grid

Дополнительно учтена уже используемая сущность CTA Gift Grid:

```scss
.cta-section__gift-btn
.cta-section__gift-card
.cta-section__gift-item
```

Плюс promotion-варианты:

```scss
.promotion-gift-btn
.promotion-gift-card
.promotion-gift-item
```

### About / company / documents / stats

Покрыты карточки:

```scss
.about-card
.company-card
.team-card
.document-card
.cert-card
.license-card
.stats-card
.stat-card
```

И item-варианты:

```scss
.about-item
.company-item
team-item
document-item
cert-item
license-item
stats-item
stat-item
```

Также добавлены aliases для:

```scss
__title
__text
__value
__label
__link
```

### Contacts

Покрыты карточки:

```scss
.contacts-card
.contact-info-card
.address-card
.phone-card
.email-card
.schedule-card
.requisites-card
.map-card
```

И элементы:

```scss
__icon
__body
__title
__text
__link
```

Также добавлен map-wrapper:

```scss
.contacts-map
.contact-map
.map-section__map
.contacts-section__map
```

### Inner grids

Покрыты сетки:

```scss
.inner-grid
page-grid
promotion-grid
promo-grid
offer-grid
gift-grid
discount-grid
about-grid
company-grid
team-grid
documents-grid
certs-grid
licenses-grid
stats-grid
contacts-info-grid
contacts-cards-grid
requisites-grid
```

С модификаторами:

```scss
--compact
--3
--4
```

## Подключение

Файл создан, но автоматическая попытка добавить строку в `main.scss` была заблокирована инструментом записи.

Нужно добавить вручную после основного legacy aliases:

```scss
@use 'legacy/aliases';
@use 'legacy/inner-pages';
```

Пока строка не добавлена, файл находится в репозитории, но не участвует в сборке.
