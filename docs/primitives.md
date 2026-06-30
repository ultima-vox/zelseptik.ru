# Primitive layer

Primitive layer — первый уровень компонентов дизайн-системы ЗЕЛСЕПТИК после Foundation.

Примитивы не знают о страницах, товарах, доставке, hero-блоках, каталоге или других бизнес-сущностях.

## Директория

```text
src/scss/design-system/primitives/
```

## Точка входа

```text
src/scss/design-system/primitives/_index.scss
```

## Состав

```text
_button.scss
_badge.scss
_card.scss
_surface.scss
_field.scss
_input.scss
_icon.scss
_link.scss
```

## Назначение файлов

### button

Нейтральная кнопка действия.

```html
<a class="btn btn--primary" href="#">Оставить заявку</a>
<button class="btn btn--secondary" type="button">Подробнее</button>
```

Основные модификаторы:

```text
.btn--primary
.btn--secondary
.btn--dark
.btn--accent
.btn--ghost
.btn--sm
.btn--lg
.btn--full
.btn--icon
```

### badge

Нейтральный бейдж, тег или статус.

```html
<span class="badge">Новинка</span>
<span class="badge badge--info">Информация</span>
```

Основные модификаторы:

```text
.badge--dark
.badge--outline
.badge--success
.badge--warning
.badge--error
.badge--info
```

### card

Нейтральный контейнер карточки.

```html
<article class="card card--interactive">
  <div class="card__body">
    <h3 class="card__title">Заголовок</h3>
    <p class="card__text">Описание.</p>
  </div>
</article>
```

Семантические карточки типа `catalog-card`, `feature-card`, `process-card` должны строиться поверх `card`, но не наоборот.

### surface

Нейтральный фон/поверхность.

```html
<section class="surface surface--muted surface--rounded">
  ...
</section>
```

### field / input

Базовая структура форм.

```html
<label class="field">
  <span class="field__label">Телефон</span>
  <input class="input" type="tel" placeholder="+7 ...">
  <span class="field__hint">Перезвоним в рабочее время</span>
</label>
```

### icon

Размеры SVG-иконок и контейнеры.

```html
<span class="icon icon--sm">...</span>
<span class="icon-box">...</span>
```

### link

Нейтральная ссылка.

```html
<a class="link link--standalone" href="#">Подробнее</a>
```

## Запрещено в primitives

Нельзя добавлять селекторы с привязкой к странице или бизнес-сущности:

```scss
.hero-button {}
.catalog-badge {}
.delivery-card {}
.contacts-link {}
.product-input {}
```

Нельзя обращаться к legacy-классам:

```scss
.hero-actions__btn-primary {}
.delivery-btn {}
.catalog-card__btn-order {}
```

Для этого существует слой:

```text
src/scss/legacy/_aliases.scss
```

## Разрешено

Только нейтральные классы:

```scss
.btn {}
.badge {}
.card {}
.surface {}
.field {}
.input {}
.icon {}
.link {}
```

## Подключение к боевому сайту

Primitive layer пока не подключается напрямую к `src/scss/main.scss`.

Сначала система стабилизируется в изолированной директории:

```text
src/scss/design-system/
```

После проверки primitives можно подключать их в `main.scss` и маппить старые классы через legacy aliases.
