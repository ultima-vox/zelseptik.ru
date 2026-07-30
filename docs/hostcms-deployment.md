# HostCMS: source of truth и deploy

## Source of truth

Git-репозиторий хранит редактируемые версии активных файлов:

| Локальный путь | Путь на dev |
| --- | --- |
| `hostcmsfiles/xsl/*.xsl` | `/hostcmsfiles/xsl/*.xsl` |
| `templates/template*/template.htm` | `/templates/template*/template.htm` |
| `templates/template*/script.js` | `/templates/template*/script.js` |
| `templates/template*/style.css` | `/templates/template*/style.css` |
| `script.js` | `/script.js` |
| `dist/css/runtime.min.css` | `/assets/css/runtime.min.css` |
| `dist/css/app.min.css` | `/assets/css/app.min.css` |
| `dist/js/` | `/assets/js/` |

XSL `55` отвечает за каталог и штатные GET-параметры фильтра HostCMS. Его бизнес-логику нельзя заменять клиентской фильтрацией.

`core/*.css` хранит точный runtime baseline dev в фактическом порядке подключения. `npm run build` объединяет и сжимает его в `dist/css/runtime.min.css`. `dist/css/app.min.css` содержит новую ДС. Два слоя разделены, пока все HostCMS-классы не мигрированы.

`hostcmsfiles/documents/*.html` — snapshot документов из БД. Эти файлы не копируются
на сервер напрямую. Импорт документа требует backup текущей строки, сверки ID и отдельного smoke-test.

Для документов главной используется CLI-скрипт `scripts/sync-hostcms-documents.php`.
Сначала запускать без `--apply`, затем с `--apply` и отдельным `--backup`:

```bash
php scripts/sync-hostcms-documents.php \
  --root=/var/www/zelseptik/data/www/dev.zelseptik.ru \
  --source=/path/to/documents \
  --ids=36 \
  --manifest=/path/to/preflight.json

php scripts/sync-hostcms-documents.php \
  --root=/var/www/zelseptik/data/www/dev.zelseptik.ru \
  --source=/path/to/documents \
  --ids=36 \
  --expected=/path/to/preflight.json \
  --backup=/path/to/backup \
  --environment=dev.zelseptik.ru \
  --apply
```

Скрипт ограничен документами `5, 6, 7, 19, 33, 34, 36, 37, 38`, сохраняет исходный HTML и
SHA-256 manifest до изменения БД.

Rollback документа выполняется тем же двухшаговым процессом: использовать HTML-файл
из backup как `--source`, создать новый preflight manifest, затем применить его в новый
backup-каталог. Скрипт не нормализует HTML и восстанавливает backup побайтово. После
rollback сверить SHA-256 с `before_sha256` исходного manifest.

## Порядок изменения

1. Получить свежую серверную копию и сравнить SHA-256 с Git.
2. Внести изменение в отдельной ветке.
3. Запустить `npm run build` и `npm run lint`.
4. Проверить HTML/XSL, формы, фильтры, пагинацию и адаптивность на dev.
5. Загружать только изменённые файлы. Перед заменой создать timestamped backup на сервере.
6. После smoke-test сверить серверные SHA-256 с локальными.

## Запреты

- Не хранить SSH-пароли и секреты HostCMS в Git.
- Не редактировать dev как единственный источник изменений.
- Не загружать локальный файл поверх сервера при несовпавшем baseline.
- Не отключать серверные обработчики форм, reCAPTCHA и фильтров без равноценной замены.

## Секреты

`templates/template1/template.htm` читает закрытый ключ reCAPTCHA из переменной окружения `ZS_RECAPTCHA_SECRET`. Ключ должен быть задан в PHP-FPM/Apache-конфигурации до загрузки шаблона. Публичный site key остаётся в клиентском JS.
