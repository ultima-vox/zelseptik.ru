# ЗЕЛСЕПТИК Frontend Workspace

Production-ready workspace для Design System v2.

## Setup

```powershell
npm install
npm run dev
```

## Команды

| Команда | Что делает |
| --- | --- |
| `npm run dev` | Watch-сборка SCSS в `dist/css/app.css` с source map |
| `npm run build` | Продакшен-сборка в `dist/css/app.min.css` (compressed) |
| `npm run build:dev` | Разовая expanded-сборка в `dist/css/app.css` |
| `npm run lint` | `stylelint` по SCSS + `eslint` по JS |
| `npm run lint:fix` | То же с автоисправлением |
| `npm run format` | `prettier` по всему проекту |
| `npm run clean` | Удаляет собранный CSS |

`dist/` не хранится в git — собирается локально и на деплое.

## Подключение в HostCMS

```html
<link rel="stylesheet" href="/dist/css/app.min.css">
```

JS-бандл `dist/js/app.js` пока не собирается: модули в `src/js/` — заглушки,
сборщика для них нет. Подключать `<script src="/dist/js/app.js">` рано.

## Структура SCSS

Порядок загрузки в `src/scss/main.scss` = порядок каскада. Менять нельзя без
проверки сайта.

```text
abstracts/      токены и миксины (foundation)
base/           reset, типографика, rich content
layouts/        контейнеры, секции, сетки страниц
design-system/  primitives -> semantic -> patterns
components/     только то, чего нет в design-system
patterns/       только то, чего нет в design-system
pages/          пострановые оверрайды
legacy/         маппинг текущей вёрстки HostCMS, всегда последним
```

Каждый слой подключается через свой `_index.scss`. Это нужно, чтобы файлы с
одинаковым именем в разных слоях (`patterns/product`, `pages/product`) не
конфликтовали по namespace у `@use`.

## Правила

1. Не переименовывать существующие классы без необходимости.
2. Новые страницы собирать из универсальных компонентов.
3. `catalog-card` используется только для товаров.
4. Информационные карточки — `feature-card`.
5. Этапы — `process-card`.
6. CTA на всём сайте — только `cta`.
7. JS-хуки — только через `js-*` или `data-*`.
8. Название компании всегда: ЗЕЛСЕПТИК.
9. Компонент, который уже есть в `design-system/`, не переопределять в
   `components/` или `patterns/` — только в `legacy/` и только как маппинг.
10. Медиазапросы — префиксным синтаксисом (`min-width`), не range (`width >=`):
    range не поддерживается Safari до 16.4 и ломает вёрстку целиком.
