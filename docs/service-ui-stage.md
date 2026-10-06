# Первый этап UI: услуги

## Результат

Список услуг использует текущие карточки и токены производственного CSS. Убраны
повторяющиеся названия для разных экранов; фотографии загружаются отложенно,
карточка без фото не создаёт запрос к пустому изображению. Заголовок группы — H1.
Вывод подгрупп ограничен выбранным родителем: каждый выбранный элемент выводится
один раз, соседняя группа другого родителя не попадает в карточки.

Первый экран XSL 4 использует готовые `grid-blueprint`, `hero-offer__title`,
`hero-offer__subtitle`, `cta-card` и контейнер утверждённой страницы доставки.
Заголовок, описание, фотография и преимущества берутся из существующей инфосистемы.
Текст элемента, сообщения, комментарии и остальная часть XSL сохранены.
После проверки dev содержимое элемента помещено в существующий `container`,
совпадающий по ширине и боковым отступам с первым экраном. Старые классы
`area-text`, `page-bl`, `txt`, `punkt-fl-row`, `fl-row`, `col`, `punkt-bl` сохранены.
Блок этапов использует одну колонку на мобильном экране, две от 768 px и четыре
от 1024 px; подписи и изображения поступают из прежнего HTML инфосистемы.
Абзацы и списки ограничены существующим `--container-narrow`, таблицы сохраняют
доступную ширину контейнера. Общие стили сайта не переопределяются.
Первый экран применяется ко всем разделам с общим XSL 4, включая статьи; XSL 280
городов в этом этапе не изменяется.

Форма имеет видимые подписи, автозаполнение, телефонный тип поля и область результата.
Она использует существующий `data-lead-form` и обработчик в макете 1:
`_zs_action=lead`, reCAPTCHA, `form_type` с названием услуги, `link` и прежнее поле
`city_service`. Никакой новый обработчик или API не создаётся. Обещание обратного
звонка за 15 минут заменено нейтральным пояснением без нового обещания сроков.

Старый блок цены состоит из таблицы названий и независимых колонок Swiper.
Модуль `information.js` объединяет их в таблицу с заголовками столбцов и строк;
цены и ссылки берёт из текущей HTML-разметки CMS. На узком экране прокручивается
только таблица. Если количество строк не совпадает, отсутствует заголовок или
есть объединённые ячейки, источник остаётся целым. Без JS остаётся исходный блок.
Некорректные и повторные вызовы `new Swiper('#swiper-price. swiper', ...)` убраны.

В макете 3 исправлено присваивание `$iItem = 157`: квиз вызывается только при
`$iItem === 157` (существующий элемент «Подбор септиков»), переменные инициализированы.
Текущий runtime CSS скрывает `.area-quiz-new`, поэтому видимый квиз на странице
подбора этим исправлением не восстанавливается. UX самого подбора — отдельная задача.

## Изменения для переноса

| Файл | Существующая запись / назначение |
| --- | --- |
| `hostcmsfiles/xsl/13.xsl` | XSL 13 «СписокУслуг» |
| `hostcmsfiles/xsl/4.xsl` | XSL 4 «ВыводЕдиницыИнформационнойСистемы» |
| `templates/template3/template.htm` | Макет 3, условие квиза |
| `templates/template3/script.js` | Макет 3, удаление некорректного инициализатора |
| `templates/template1/template.htm` | Макет 1, подключение дополнительного CSS через `css()` перед `showCss()` |
| `assets/css/information-pages.css` | Только адаптация инфосистем и фокус карточок; производственные bundles сохранены |
| `assets/js/modules/information.js`, `assets/js/app.js` | Обработка существующей таблицы, импорт в текущий модуль приложения |

ID, контроллеры, магазины, инфосистемы и свойства не заменяются. Для подключения
CSS использован [официальный способ HostCMS](https://www.hostcms.ru/documentation/step-by-step/templates/template/).
Оригиналы изменённых исходников сохранены в `archive/2026-10-05/ui-baseline/` и
учтены в `docs/ui-originals.json`. Это источник для отката; архив на сервер не переносить.

## Проверено

- `python scripts/verify-baseline.py`: оригиналы и действующие неизменённые CSS/JS.
- `python scripts/check-information-ui.py` (lxml): XML/XSL-преобразование, H1,
  фильтрация групп, пагинация, ссылки, сохранение CMS-текста, хлебные крошки,
  резервные заголовки и изображения, поля формы.
- `node --input-type=module --check` для изменённых JS.
- `tests/information-tables.cjs` (jsdom): соответствие цены строке услуги,
  сохранение ссылок и ID, семантика, повторная инициализация, неполные данные,
  отсутствие изменений за пределами `.information-detail`.
- Проверена аналогичная таблица из публичного текста элемента 187 в бекапе.

Для запуска DOM-теста установите jsdom в отдельный временный каталог:

```sh
npm install --prefix /tmp/zelseptik-ui-check --no-audit --no-fund jsdom
NODE_PATH=/tmp/zelseptik-ui-check/node_modules node tests/information-tables.cjs
```

## Проверка на dev и оставшаяся приёмка

Первый этап из коммита `61f15b82affa6ace7bf67c4ad48b86894a50ab97` установлен
на изолированный dev. Успешный запуск Actions: `37320029965`, восемь файлов
сверены после загрузки, сохранена зашифрованная резервная копия.
Макет 1 на dev сохранён целиком: в фактическую версию добавлено только подключение
CSS, поэтому её хеш отличается от экспортированной версии в этой ветке.

На странице `/montazh-septika/montazh-septika-topas/` браузер подтвердил новый
первый экран, форму и преобразованную таблицу: 6 строк, 8 заголовочных ячеек.
Проверка выявила отсутствие контейнера у старого содержимого и сетки этапов;
описанное выше исправление подготовлено отдельно и ещё требует установки.
Заявки не отправлялись. Мобильная визуальная приёмка не выполнена.

После установки исправления проверить на dev:

1. `/services/`, подбор, одна обычная услуга, монтаж/обслуживание/ремонт и статья,
   использующие XSL 4; случаи с группой и без фото.
2. Ширины 375, 768, 1024, 1440 px: переносы H1, форма, изображение, контент,
   горизонтальная прокрутка внутри таблицы и отсутствие прокрутки всей страницы.
3. Реальную отправку тестовой заявки: услуга в письме, валидация, reCAPTCHA,
   успешный и ошибочный результат. В этой среде заявки не отправлялись.
4. Шесть утверждённых страниц после добавления CSS и JS: новый CSS ограничен
   отдельными селекторами, а модуль таблиц — `.information-detail`, но сравнение
   скриншотов ещё требуется.
5. Перенести только перечисленные изменения через обычный процесс работы с CMS,
   проверить сброс её кеша и версионирование ресурсов; не разворачивать экспорт целиком.

Этот этап не считается завершением унификации всего сайта и не опубликован на production.

## Shared rich service content — 2026-10-06

The common information module enhances existing `.area-text`, `.area-paragraph` and `.area-why` sections on information detail pages and regional service pages. Articles are excluded. Existing class names remain; content nodes, photos, prices, links and forms are preserved. Known legacy number SVGs use the existing `process-card__step` and `process-card__number-bg` components. Section navigation uses existing headings; the original price section moves near the beginning without duplication. Valid normalized tables retain semantic headers and expose real column labels on mobile cards; malformed tables keep the existing scroll fallback. Rules are visible together rather than hidden in a slider.

Validation: section regression test covers 8 numbers, source node preservation, prices/labels, heading anchors, article isolation and idempotence. Baseline (324 checksums), information XSL, price-table and quiz checks passed. No live forms submitted. Mobile CSS is implemented but physical phone verification remains outstanding. Pages lacking these legacy section wrappers need separate inspection; this change does not claim every service page has been visually checked.
