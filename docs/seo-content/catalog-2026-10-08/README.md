# Каталог септиков: SEO, 08.10.2026

Объём: корневая страница /septiki/ и 13 существующих групп магазина 1. Карточки 196 товаров и отдельные SEO-фильтры в этот пакет не входят.

В существующих группах HostCMS обновлены description, seo_title, seo_description. Корневое описание дополнено ссылками на бренды, подборки для дома и дачи и доставку. Из title корня удалена устаревающая фиксированная цена; сохранена штатная подстановка номера страницы. Также обновлены seo_title и seo_description существующего узла структуры 5: пагинация использует его метаданные как запасной вариант. URL и сущности не менялись.

XSL 55 выводит описание текущей группы один раз под товарами, только на первой странице без фильтра, метки и производителя. Использованы существующие классы section, container, legal-page__content и data-seo-landing. CSS не менялся. Источником шаблона была актуальная версия dev, проверенная перед изменением. Изменения сохранены через штатную админку HostCMS.

Оригинальные поля и XSL: docs/archive/seo-catalog-before-2026-10-08. Результаты HTTP-проверок: verification-live.json. Production не изменялся.

## Перенос содержимого

Деплой XSL не переносит тексты, хранящиеся в БД. Для переноса через MySQL подготовлен tools/seo/generate-catalog-content-sql.py. Нужен свежий JSON-экспорт именно целевой базы:

- `groups`: массив ровно 13 записей; поля id, shop_id, deleted, path, description, seo_title, seo_description;
- `structure`: узел структуры id=5; поля id, deleted, path, seo_title, seo_description;
- `shop`: запись магазина id=1; поля id, deleted, description, seo_root_title_template, seo_root_description_template.

Идентификаторы и пути перечислены в manifest.json. Значения полей должны сохранять NULL, пустую строку и полный HTML без преобразования. Перед переносом проверить соответствие ID целевой базе и резервную копию. Текущий экспорт dev из архивных UI-полей не заменяет экспорт production.

`python3 tools/seo/generate-catalog-content-sql.py --export /private/current-catalog.json --output /private/catalog-migration`

Генератор создаёт apply.sql и обратный rollback.sql. Оба по умолчанию завершаются ROLLBACK, ничего не выполняют сами. UPDATE ограничен магазином, ID, путём, deleted и точным предыдущим содержимым всех меняемых полей. При любом changed_rows != 1 откатить всю транзакцию; COMMIT допустим только после проверки всех 15 строк. SQL на production не запускался.

## Официальная документация интеграции

- https://www.hostcms.ru/documentation/modules/shop/group/add/
- https://www.hostcms.ru/documentation/modules/shop/shop-seo-templates/
- https://www.hostcms.ru/documentation/modules/shop/frontend/show-groups/
- https://www.hostcms.ru/documentation/modules/structure/add/

## Следующие задачи каталога

Отдельно проверить товарные данные и страницы SEO-фильтров. При осмотре каталога замечены подозрительные значения у ТОПАС 10 Лонг: «до 3 чел.» и «1 л/сутки», а также различия способа сброса у близких исполнений. Эти данные не исправлялись без проверки паспортов конкретных моделей. Нельзя распространять ошибочные карточные характеристики на новые тексты.
