# ЗЕЛСЕПТИК Frontend Workspace

Design System v2 и deploy-source для сайта ЗЕЛСЕПТИК на HostCMS.

## Быстрый старт

```powershell
npm install
npm run build
npm run lint
```

Сборка создаёт:

```text
dist/css/style.min.css
dist/css/critical.min.css
dist/css/runtime.css
dist/js/app.js
dist/js/modules/*
dist/js/utils/*
```

Для разработки SCSS:

```powershell
npm run dev
```

## Структура

```text
src/scss/                 исходники Design System v2
core/                     точный baseline активного CSS на dev
src/js/                   модульный frontend JS
hostcmsfiles/xsl/         рабочие XSL-шаблоны HostCMS
templates/template1/      основной HostCMS-шаблон и runtime JS
templates/template2/      шаблон главной страницы
script.js                 текущий корневой runtime JS HostCMS
docs/                     правила компонентов и интеграции
```

Файлы HostCMS импортированы с `dev.zelseptik.ru` как baseline. Сначала изменения делаются и проверяются в Git. На dev загружается только проверенный diff.

## Правила

1. Не переименовывать существующие классы без необходимости.
2. Новые страницы собирать из универсальных компонентов.
3. `catalog-card` использовать только для товаров.
4. Информационные карточки собирать через `feature-card`.
5. Этапы собирать через `process-card`.
6. Общий CTA собирать через `cta`.
7. JS-хуки задавать через `js-*` или `data-*`.
8. Название компании всегда писать `ЗЕЛСЕПТИК`.
9. Слоган компании: `Чистота без компромиссов`.
10. Компонент из `design-system/` не переопределять в `components/` или `patterns/`; совместимость держать в `legacy/`.
11. Медиазапросы писать через `min-width`/`max-width`, без range-синтаксиса.
12. Не добавлять неподтверждённые цены, гарантии, сроки, отзывы и счётчики.

Подробности интеграции: [docs/hostcms-deployment.md](docs/hostcms-deployment.md).
