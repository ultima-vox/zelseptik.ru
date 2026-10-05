# Semantic component layer

Semantic layer — второй уровень компонентов дизайн-системы ЗЕЛСЕПТИК после primitives.

В отличие от primitives, semantic components уже описывают понятные интерфейсные сущности: карточка преимущества, карточка процесса, карточка товара, FAQ-элемент, отзыв, контакт, статья.

При этом semantic components не должны быть привязаны к конкретной странице.

## Директория

```text
src/scss/design-system/semantic/
```

## Точка входа

```text
src/scss/design-system/semantic/_index.scss
```

## Состав

```text
_feature-card.scss
_process-card.scss
_catalog-card.scss
_calculator-card.scss
_faq-item.scss
_review-card.scss
_contact-card.scss
_article-card.scss
```

## Компоненты

### feature-card

Для преимуществ, сервисных фактов, контактов и информационных карточек.

```html
<article class="feature-card">
  <div class="feature-card__icon">...</div>
  <h3 class="feature-card__title">Гарантия 5 лет</h3>
  <p class="feature-card__text">Фиксируем условия в договоре.</p>
</article>
```

### process-card

Для этапов монтажа, доставки, сервиса и других процессов.

```html
<article class="process-card">
  <div class="process-card__number-bg">01</div>
  <div class="process-card__step">1</div>
  <h3 class="process-card__title">Выезд инженера</h3>
  <p class="process-card__text">Проверяем участок и условия монтажа.</p>
</article>
```

### catalog-card

Только для товарной карточки.

Запрещено использовать `catalog-card` для преимуществ, этапов, контактов, услуг и текстовых карточек.

```html
<article class="catalog-card" itemscope itemtype="https://schema.org/Product">
  <div class="catalog-card__badges-row">
    <span class="catalog-card__badge">Хит продаж</span>
  </div>
  <div class="catalog-card__media">
    <img class="catalog-card__img" src="..." alt="...">
    <span class="catalog-card__capacity">до 5 чел.</span>
  </div>
  <div class="catalog-card__body">
    <h3 class="catalog-card__title">Топас 5 Пр</h3>
    <p class="catalog-card__desc">Описание товара.</p>
  </div>
  <div class="catalog-card__footer">
    <span class="catalog-card__price-actual">142 500 ₽</span>
  </div>
</article>
```

### calculator-card

Для калькуляторов, подборщиков и интерактивных расчетных блоков.

### faq-item

Для вопросов и ответов, включая accordion-логику.

### review-card

Для отзывов и социальных доказательств.

### contact-card

Для адресов, телефонов, email, графика работы и других контактных фактов.

### article-card

Для новостей, статей и редакционных превью.

## Запрещено в semantic layer

Нельзя добавлять классы, привязанные к конкретной странице:

```scss
.home-feature-card {}
.delivery-process-card {}
.contacts-card-special {}
.catalog-page-card {}
```

Нельзя добавлять legacy selectors:

```scss
.hero-actions__btn-primary {}
.delivery-btn {}
.catalog-section__old-item {}
```

Для этого используется:

```text
src/scss/legacy/_aliases.scss
```

## Разрешенная зависимость

Semantic components могут использовать:

```text
Foundation tokens
Foundation mixins
Primitive class principles
```

Но не должны импортировать:

```text
pages/
patterns/
legacy/
```

## Подключение

Semantic layer подключен к внутреннему entrypoint:

```text
src/scss/design-system/_index.scss
```

Но пока не подключен к боевому `src/scss/main.scss`, чтобы не менять текущий сайт до этапа legacy mapping.
