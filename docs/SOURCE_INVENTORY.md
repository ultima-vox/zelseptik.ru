# Источники и решение по репозиториям

Срез GitHub на 28.09.2026. Пользователь сообщил в тот же день о переносе файлов с dev на production. Ссылки ведут на исходные ветки; степень совпадения Git, production и dev ещё не проверена.

| Репозиторий | Проверенный состав | Решение |
| --- | --- | --- |
| [zelseptik.ru](https://github.com/ultima-vox/zelseptik.ru) | В `main`: 147 записей дерева, SCSS/JS workspace, `core` CSS и документация. В [`codex/hostcms-baseline-homepage`](https://github.com/ultima-vox/zelseptik.ru/tree/codex/hostcms-baseline-homepage): 228 записей, XSL, шаблоны, снимки документов HostCMS и порядок деплоя. | **Основной репозиторий**. Рабочий baseline — указанная ветка до переноса в `main`. |
| [Full-Design-System](https://github.com/ultima-vox/Full-Design-System) | Демо дизайн-системы в `zelseptik-ds/`, CSS, отдельные XSL и шаблоны, много `tmp/`, локальных копий и submodule `zelseptik-production`. | Справочный источник для дизайн-решений и сверки уникальных файлов. Не деплоить его целиком. |
| [zelseptik](https://github.com/ultima-vox/zelseptik) | Git-репозиторий пуст на момент проверки. | Не использовать как источник сайта. Не удалять и не архивировать без отдельного решения владельца. |

## Что уже есть в основном репозитории

- Дизайн-система: `docs/foundation.md`, `primitives.md`, `semantic-components.md`, `patterns.md`, `component-map.md`, `legacy-mapping.md`, `inner-pages-legacy-mapping.md`.
- В HostCMS baseline: `docs/hostcms-deployment.md`, `hostcmsfiles/README.md`, `hostcmsfiles/xsl/`, `hostcmsfiles/documents/manifest.json`, `templates/template1/`, `templates/template2/`, scripts экспорта и контролируемой синхронизации документов.
- Небезопасно считать снимки документов обычными статическими файлами: документы живут в БД HostCMS, а `manifest.json` содержит ID и дату экспорта.
- Есть открытый [PR #3](https://github.com/ultima-vox/zelseptik.ru/pull/3) на `main` по реорганизации SCSS. Не копировать его изменения автоматически поверх HostCMS baseline; отдельно сравнить CSS-слои и сборку.

## Что полезно взять из Full-Design-System

| Источник | Польза | Перед интеграцией |
| --- | --- | --- |
| [`zelseptik-ds/index.html`](https://github.com/ultima-vox/Full-Design-System/blob/main/zelseptik-ds/index.html), `assets/css/core/`, `styles.css` | Витрина и примеры компонентов: навигация, каталог, товар, формы, CTA. | Сопоставить с текущими `src/scss/`, `core/` и фактической разметкой HostCMS. Не подключать второй параллельный CSS entrypoint. |
| [`docs/components/nav-pills.md`](https://github.com/ultima-vox/Full-Design-System/blob/main/zelseptik-ds/docs/components/nav-pills.md) | Навигация по брендам/разделам; отделена от trust bar. | Проверить классы в актуальной SCSS и XSL 55. |
| [`docs/components/product-pattern.md`](https://github.com/ultima-vox/Full-Design-System/blob/main/zelseptik-ds/docs/components/product-pattern.md) | Компоновка страницы товара и связь с карточкой покупки. | Примерные цена, сроки и названия свойств в этом файле не являются данными сайта. Указанный `product.css` отсутствует в дереве `main` Full-Design-System; сверить перед применением. |
| `zelseptik-ds/templates/template5/template.htm` | Снимок шаблона каталога, которого нет в HostCMS baseline основной ветки. | Проверить идентичность установленному шаблону и необходимость импорта. |
| `zelseptik-ds/hostcmsfiles/xsl/55.xsl`, `56.xsl`, `templates/template1/template.htm` | Исторические версии HostCMS. | SHA отличается от соответствующих файлов HostCMS baseline основного репозитория. Не заменять без построчного diff и проверки на dev. |

`hostcmsfiles/xsl/2.xsl` и корневой `script.js` в этих двух снимках имеют одинаковые blob SHA; их повторно переносить не нужно. Материалы в `zelseptik-ds/tmp/` и `.tmp-*` — архив/черновики, не источник production. Репозиторий Full-Design-System сам описывает своё назначение как витрину дизайн-системы.

## Расхождения, которые надо разрешить проверкой

1. Старые материалы предлагают собственный CSS entrypoint `styles.css`, основной HostCMS baseline собирает `dist/css/style.min.css`. Проверить реально подключённые CSS на dev и оставить один проверенный путь.
2. Документация Full-Design-System называет CSS и XSL актуальными, но их SHA для каталога, товара и `template1` отличаются от HostCMS baseline. Истину определяют свежие копии production и dev, их diff с Git и проверка функциональности.
3. README дизайн-системы утверждает роль `Shop` и `Informationsystem`; до правок подтвердить их настройки, ID, свойства и версию в админке и на сервере.
4. PR #3 меняет архитектуру SCSS и lockfile; проверить конфликт с baseline до слияния.

Не нужно переносить все исторические файлы в основной репозиторий: для работы достаточно ссылок на источники, трассировки решений и выборочного импорта после сверки. Это исключает ещё одну расходящуюся копию шаблонов.
