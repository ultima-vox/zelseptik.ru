# Foundation layer

Foundation — нижний уровень дизайн-системы ЗЕЛСЕПТИК. Он не должен зависеть от страниц, бизнес-сущностей и текущего HTML сайта.

## Назначение

Foundation задает единый источник правды для:

- цветов;
- типографики;
- отступов;
- радиусов;
- теней;
- контейнеров;
- z-index;
- анимаций;
- базовых SCSS-миксинов;
- compatibility aliases для старых переменных.

## Файлы

```text
src/scss/abstracts/_tokens.scss
src/scss/abstracts/_mixins.scss
```

## Правило зависимости

Foundation не импортирует компоненты, страницы, паттерны и legacy-слой.

Допустимое направление зависимостей:

```text
Foundation → Primitives → Semantic Components → Patterns → Pages → Legacy aliases
```

Запрещено:

```text
Foundation → catalog-card
Foundation → hero-section
Foundation → delivery-card
Foundation → page-specific selector
```

## Токены

Все значения цветов, шрифтов, отступов, радиусов, теней, контейнеров и motion должны браться только из `src/scss/abstracts/_tokens.scss`.

Новые компоненты не должны использовать произвольные значения, если уже существует подходящий токен.

Плохо:

```scss
.card {
  border-radius: 17px;
  color: #15803d;
}
```

Хорошо:

```scss
.card {
  border-radius: var(--radius-xl);
  color: var(--color-primary-hover);
}
```

## Цвета

Основной бренд-цвет:

```scss
--color-primary: #23a455;
```

Для зеленых акцентов использовать только:

```scss
--color-primary
--color-primary-hover
--color-primary-dark
--color-primary-deep
--color-primary-soft
--color-primary-soft-strong
```

Для служебных состояний использовать:

```scss
--color-success
--color-warning
--color-error
--color-info
```

## Поверхности

Основные фоновые токены:

```scss
--color-bg-page
--color-bg-base
--color-bg-muted
--color-bg-disabled
--color-bg-dark
--color-surface
```

`--color-surface` является алиасом на `--color-bg-base` и нужен для совместимости с документацией и ранними макетами.

## Типографика

Шрифты:

```scss
--font-family-base: Inter
--font-family-heading: Unbounded
--font-family-logo: Onest
```

Правило:

- `Inter` — интерфейс, основной текст, формы, меню;
- `Unbounded` — заголовки и сильные CTA-акценты;
- `Onest` — логотип и брендовая подпись.

## Compatibility layer

В `_tokens.scss` сохранены старые переменные:

```scss
--font-logo
--font-heading
--font-sans
--color-brand-green-50
--color-brand-green-100
--color-brand-green-600
--color-brand-green-700
--color-brand-green-800
--color-brand-green-950
--color-brand-accent-blue
--color-graphite
--color-navy
--color-slate
--color-light-bg
--color-white
--color-border
--shadow-glow-emerald
```

Они нужны, чтобы старый CSS и текущий HTML не сломались при переходе на новую систему.

Новые компоненты должны использовать новые токены, а не compatibility aliases.

## Миксины

Файл `src/scss/abstracts/_mixins.scss` содержит только нейтральные строительные миксины:

```scss
focus-ring
interactive-transition
button-base
button-primary
button-secondary
button-dark
button-accent
card-base
card-interactive
visually-hidden
text-truncate
line-clamp
```

Миксины не должны содержать названия страниц или бизнес-сущностей.

Запрещено:

```scss
@mixin delivery-card {}
@mixin catalog-product-card {}
@mixin hero-green-button {}
```

Разрешено:

```scss
@mixin card-base {}
@mixin button-primary {}
```

## Следующий уровень

После Foundation собирается Primitive layer:

```text
.btn
.badge
.card
.input
.field
.surface
.icon
.link
```

Только после этого старые классы подключаются через `legacy/_aliases.scss`.
