# Patterns layer

Patterns layer — уровень page-independent композиций дизайн-системы ЗЕЛСЕПТИК.

Patterns собираются из primitives и semantic components, но не должны содержать legacy selectors и не должны быть привязаны к конкретной странице.

## Директория

```text
src/scss/design-system/patterns/
```

## Точка входа

```text
src/scss/design-system/patterns/_index.scss
```

## Состав

```text
_section-header.scss
_hero.scss
_cta.scss
_catalog-grid.scss
_faq-list.scss
_contact-grid.scss
_content-grid.scss
```

## Компоненты

### section-header

Универсальный заголовок секции.

```html
<header class="section-header">
  <span class="badge">Каталог</span>
  <h2 class="section-header__title">Популярные септики</h2>
  <p class="section-header__text">Подберём систему под дом, грунт и уровень воды.</p>
</header>
```

### hero

Нейтральная hero-композиция первого экрана.

```html
<section class="hero hero--blueprint">
  <div class="container">
    <div class="hero__grid">
      <div class="hero__content">
        <span class="hero__eyebrow badge">ЗЕЛСЕПТИК</span>
        <h1 class="hero__title">Септики под ключ</h1>
        <p class="hero__text">Инженерный подбор, монтаж и обслуживание.</p>
        <div class="hero__actions">
          <a class="btn btn--primary" href="#">Рассчитать стоимость</a>
        </div>
      </div>
      <aside class="hero__aside">...</aside>
    </div>
  </div>
</section>
```

### cta

Универсальный конверсионный блок.

```html
<section class="cta">
  <div class="container">
    <div class="cta__box">
      <div class="cta__grid">
        <div>
          <span class="badge badge--dark">Консультация</span>
          <h2 class="cta__title">Подберём септик под участок</h2>
          <p class="cta__text">Без переплаты и ошибок по грунту.</p>
        </div>
        <div class="cta__actions">
          <a class="btn btn--accent btn--full" href="#">Позвонить</a>
        </div>
      </div>
    </div>
  </div>
</section>
```

### catalog-grid

Сетка товарных карточек.

```html
<div class="catalog-grid catalog-grid--wide">
  <article class="catalog-grid__item catalog-card">...</article>
</div>
```

### content-grid

Общая сетка для карточек преимуществ, этапов, статей и отзывов.

```html
<div class="content-grid content-grid--3">
  <article class="content-grid__item feature-card">...</article>
</div>
```

### faq-list

Вертикальная композиция FAQ.

```html
<div class="faq-list">
  <div class="faq-list__item faq-item">...</div>
</div>
```

### contact-grid

Сетка контактов и офисных фактов.

```html
<div class="contact-grid contact-grid--wide">
  <article class="contact-grid__item contact-card">...</article>
</div>
```

## Запрещено в patterns

Нельзя добавлять legacy-классы:

```scss
.hero-section {}
.catalog-section {}
.delivery-section {}
.contacts-page {}
```

Нельзя добавлять селекторы конкретных страниц:

```scss
.home-hero {}
.catalog-page-grid {}
.delivery-cta {}
```

Для старых классов используется только legacy layer:

```text
src/scss/legacy/_aliases.scss
```

## Подключение

Patterns layer подключен к внутреннему entrypoint:

```text
src/scss/design-system/_index.scss
```

Но пока не подключен к боевому:

```text
src/scss/main.scss
```

Это сделано намеренно, чтобы не менять текущий сайт до этапа legacy mapping.
