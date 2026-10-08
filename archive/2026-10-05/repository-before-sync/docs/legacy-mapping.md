# Legacy mapping

Legacy layer связывает текущий HTML сайта с новой дизайн-системой.

Файл:

```text
src/scss/legacy/_aliases.scss
```

## Источники анализа

Проверены доступные страницы dev-сайта:

```text
https://dev.zelseptik.ru/
https://dev.zelseptik.ru/septiki/
```

Страницы доставки и контактов через внешний web-fetch вернули ошибку, поэтому в mapping добавлены только те повторяющиеся сущности, которые подтверждены главной, каталогом и уже существующими классами репозитория.

## Подтвержденные повторяющиеся сущности

### Общая шапка и мобильное меню

На главной и каталоге повторяются:

- верхняя строка с регионом и временем работы;
- логотип;
- главное меню;
- телефон;
- кнопка обратного звонка;
- мобильное меню.

### Hero / первый экран

На главной используется первый экран с:

- бейджем компании;
- слоганом;
- H1;
- текстом;
- списком преимуществ;
- CTA-кнопками;
- калькулятором справа.

На странице каталога используется более компактный hero/intro с H1, брендовой подписью и ссылками-фильтрами.

### Calculator / подборщик

На главной повторяется структура:

- заголовок калькулятора;
- бейдж;
- варианты выбора;
- строки расчета;
- итоговая цена;
- CTA.

### Catalog card

На главной и в каталоге повторяется товарная карточка:

- бейдж;
- изображение;
- вместимость `до N чел.`;
- название;
- описание;
- характеристики;
- цена;
- кнопка заказа;
- ссылка подробнее / вторичное действие.

`catalog-card` используется только для товаров.

### Filter / selector

На странице каталога есть:

- фильтры;
- селекты сортировки;
- чекбоксы/опции;
- кнопка применения;
- сброс фильтров.

### CTA / advice

На главной и в каталоге есть повторяющиеся призывные блоки:

- совет инженера;
- вызов инженера бесплатно;
- помощь с выбором;
- CTA-кнопка.

### Cards

Повторяющиеся карточки сведены к semantic logic:

```text
feature-card
process-card
catalog-card
contact-card
article-card
review-card
```

### Grids

Повторяющиеся сетки сведены к:

```text
content-grid
catalog-grid
faq-list
contact-grid
```

## Что добавлено в mapping

### Buttons

Legacy selectors маппятся на button primitive:

```scss
.hero-actions__btn-primary
.delivery-btn
.catalog-card__btn-order
.catalog-filter__submit
.catalog-products-more__btn
.catalog-selector__submit
.catalog-advice__btn
.calculator-card__submit
.site-form__submit
.modal-form__submit
.cta-section__submit
.cta-section__btn
.callback-btn
```

### Badges

Legacy selectors маппятся на badge primitive:

```scss
.hero-offer__tag
.delivery-badge
.catalog-card__badge
.section-title-block__tag
.calculator-card__badge
.catalog-filter__badge
.catalog-selector__badge
.soil-advisor__badge
.cta-section__badge
.trust-section__badge
premium-slogan
```

### Section headers

Повторяющиеся заголовки секций маппятся на section-header pattern:

```scss
.section-title-block
.delivery-section__header
.catalog-section__header
.soil-advisor__header
.trust-section__header
.faq-section__header
.cta-section__header
```

### Hero

Старые hero-классы маппятся на hero pattern:

```scss
.hero-section
.hero-section__grid
.hero__inner
.hero-offer
.hero-panel
.hero-offer__title
.hero-panel__title
hero-actions
```

### Catalog card

Старые варианты карточки товара маппятся на product-only catalog-card:

```scss
.catalog-card
.catalog-card__media
.catalog-card__media-zone
.catalog-card__capacity
.catalog-card__people-badge
.catalog-card__price
.catalog-card__price-actual
```

### Forms

Формы маппятся на field/input primitive:

```scss
.site-form__field
.modal-form__field
.calculator-card__group
.catalog-filter__field
catalog-selector__field
```

## Ограничения

Legacy mapping не должен становиться местом разработки новой дизайн-системы.

Запрещено:

```scss
.new-component {}
.new-page-section {}
```

Разрешено только связывать существующий HTML с готовыми уровнями:

```text
Foundation
Primitive
Semantic
Patterns
```

## Следующий шаг

После проверки mapping нужно:

1. Подключить `src/scss/design-system/_index.scss` в `src/scss/main.scss` перед legacy.
2. Запустить сборку SCSS.
3. Проверить главную и каталог визуально.
4. Затем переносить повторяющиеся старые классы из `core/*.css` в design-system слои или legacy aliases.
