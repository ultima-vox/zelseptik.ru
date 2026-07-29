# ЗЕЛСЕПТИК — frontend

Исходники фронтенда сайта на HostCMS. Структура репозитория повторяет боевые
пути, чтобы файл на диске и файл на сайте всегда совпадали один к одному.

## Структура

```text
assets/css/core/       CSS сайта — подключается как /assets/css/core/*.css
templates/template1/   JS сайта — подключается как /templates/template1/script.js
blocks/                Готовая разметка новых секций под вставку в HostCMS
snippets/              Правки <head> и JSON-LD
```

## Порядок подключения CSS

Порядок значим — каскад рассчитан именно на него.

```html
<link rel="stylesheet" href="/assets/css/core/tokens.css">
<link rel="stylesheet" href="/assets/css/core/base.css">
<link rel="stylesheet" href="/assets/css/core/typography.css">
<link rel="stylesheet" href="/assets/css/core/layout.css">
<link rel="stylesheet" href="/assets/css/core/components.css">
<link rel="stylesheet" href="/assets/css/core/header.css">
<link rel="stylesheet" href="/assets/css/core/hero.css">
<link rel="stylesheet" href="/assets/css/core/trust.css">
<link rel="stylesheet" href="/assets/css/core/catalog.css">
<link rel="stylesheet" href="/assets/css/core/media.css">
<link rel="stylesheet" href="/assets/css/core/comparison.css">
<link rel="stylesheet" href="/assets/css/core/home-sections.css">
<link rel="stylesheet" href="/assets/css/core/blocks.css">
<link rel="stylesheet" href="/assets/css/core/faq.css">
<link rel="stylesheet" href="/assets/css/core/cta.css">
<link rel="stylesheet" href="/assets/css/core/modal.css">
<link rel="stylesheet" href="/assets/css/core/footer.css">
<link rel="stylesheet" href="/assets/css/core/animation.css">
<script defer src="/templates/template1/script.js"></script>
```

`blocks.css` — новый файл, на сайте пока не подключён. Нужен для секций из
`blocks/`.

## Как обновлять

Единственный источник правды — файлы в этом репозитории. Правки делаются
здесь и выкладываются на сайт, а не наоборот. Если файл поправили напрямую
на сервере, его нужно вернуть в репозиторий, иначе следующая выкладка
затрёт изменение.

```bash
npm install
npm run lint          # stylelint по CSS + eslint по JS
npm run lint:fix
npm run format
```

## Правила вёрстки

1. Не переименовывать существующие классы без необходимости.
2. Новые секции собирать из существующих компонентов `components.css`.
3. Шапка секции — `section-title-block` (`__tag`, `__title`, `__desc`).
4. `catalog-card` — только для товаров.
5. Информационные карточки — `feature-card`, этапы — `process-card`.
6. Кнопки — `btn` с модификаторами, свои не заводить.
7. JS-хуки — только через `js-*` или `data-*`, стилизовать их нельзя.
8. Модалки открываются классами `js-btn-callback` и `js-btn-estimate`,
   заголовок задаётся атрибутом `data-title`.
9. Цвета, отступы, радиусы, тени — только через токены из `tokens.css`.
10. Название компании всегда: ЗЕЛСЕПТИК.

## Известные расхождения с сайтом

- `comparison.css` (панель `compare-tray`, 244 строки) подключён на всех
  страницах, но разметки под него нет нигде и JS его не использует.
  Либо доделать функцию сравнения, либо снять файл с подключения.
- `media.css` нужен только карточке товара, но грузится на всех страницах.
- Пустые файлы `templates/template1/style.css`, `templates/template2/style.css`
  и `templates/template2/script.js` (0 байт) подключены в шаблоне —
  три лишних запроса на каждой странице.
- `npm run lint` проходит, но оставляет 18 предупреждений о реальном состоянии
  боевого кода: 16 дублирующихся селекторов в `catalog.css` (правила
  переопределяют сами себя) и 2 неиспользуемые сущности в `script.js`
  (`perPage`, `fillEstimateModalFromCase`). Чистить отдельной задачей, чтобы
  не смешивать с синхронизацией.
