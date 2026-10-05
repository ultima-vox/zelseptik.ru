# ЗЕЛСЕПТИК Frontend Workspace

Production-ready workspace для Design System v2.

## Windows setup

```powershell
npm install
npm run dev
```

SCSS компилируется из:

```text
src/scss/main.scss
```

в:

```text
dist/css/app.css
```

Для продакшена:

```powershell
npm run build
```

Подключение в HostCMS:

```html
<link rel="stylesheet" href="/dist/css/app.css">
<script type="module" src="/dist/js/app.js" defer></script>
```

## Правила

1. Не переименовывать существующие классы без необходимости.
2. Новые страницы собирать из универсальных компонентов.
3. `catalog-card` используется только для товаров.
4. Информационные карточки — `feature-card`.
5. Этапы — `process-card`.
6. CTA на всём сайте — только `cta`.
7. JS-хуки — только через `js-*` или `data-*`.
8. Название компании всегда: ЗЕЛСЕПТИК.
