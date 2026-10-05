<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://4">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">

	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ВыводЕдиницыИнформационнойСистемы  -->

	<xsl:template match="/">
		<xsl:apply-templates select="/informationsystem"/>
	</xsl:template>
	<xsl:template match="/informationsystem">
        <div class="information-detail page-legacy-content">
            <section class="section hero-section grid-blueprint">
                <div class="container">
                    <nav class="breadcrumbs" aria-label="Хлебные крошки">
                        <ol class="breadcrumbs__list">
                            <li><a href="/">Главная</a></li>
                            <xsl:choose>
                                <xsl:when test="group != 0">
                                    <xsl:apply-templates select=".//informationsystem_group[@id=current()/group]" mode="breadCrumbs"/>
                                </xsl:when>
                                <xsl:otherwise><li><a href="{url}"><xsl:value-of select="name"/></a></li></xsl:otherwise>
                            </xsl:choose>
                            <li><span aria-current="page"><xsl:value-of select="informationsystem_item/name"/></span></li>
                        </ol>
                    </nav>
                    <div class="grid-blueprint__grid">
                        <div class="grid-blueprint__content">
                            <h1 class="hero-offer__title" hostcms:id="{informationsystem_item/@id}" hostcms:field="name" hostcms:entity="informationsystem_item">
                                <xsl:choose>
                                    <xsl:when test="informationsystem_item/property_value[tag_name='seo-h1']/value != ''"><xsl:value-of select="informationsystem_item/property_value[tag_name='seo-h1']/value"/></xsl:when>
                                    <xsl:otherwise><xsl:value-of select="informationsystem_item/name"/></xsl:otherwise>
                                </xsl:choose>
                            </h1>
                            <div class="hero-offer__subtitle"><xsl:value-of select="informationsystem_item/description" disable-output-escaping="yes"/></div>
                            <xsl:if test="informationsystem_item/property_value[tag_name='main-inf']/value != ''">
                                <ul class="information-detail__benefits">
                                    <xsl:for-each select="informationsystem_item/property_value[tag_name='main-inf'][position() &lt; 4]"><li><xsl:value-of select="value"/></li></xsl:for-each>
                                </ul>
                            </xsl:if>
                            <xsl:if test="informationsystem_item/image_large != '' or informationsystem_item/image_small != ''">
                                <img class="information-detail__image" alt="{informationsystem_item/name}">
                                    <xsl:attribute name="src"><xsl:value-of select="informationsystem_item/dir"/><xsl:choose><xsl:when test="informationsystem_item/image_large != ''"><xsl:value-of select="informationsystem_item/image_large"/></xsl:when><xsl:otherwise><xsl:value-of select="informationsystem_item/image_small"/></xsl:otherwise></xsl:choose></xsl:attribute>
                                </img>
                            </xsl:if>
                        </div>
                        <aside class="grid-blueprint__aside" aria-label="Консультация по услуге">
                            <div class="cta-card">
                                <div class="cta-card__header">
                                    <h2 class="cta-card__title">Обсудить услугу с инженером</h2>
                                    <p class="cta-card__subtitle">Оставьте телефон — уточним условия участка и состав работ.</p>
                                </div>
                                <form class="site-form cta-card__form form-submit" method="post" data-lead-form="">
                                    <input type="hidden" name="_zs_action" value="lead"/>
                                    <input type="hidden" name="form_type" value="Консультация: {informationsystem_item/name}"/>
                                    <input type="hidden" name="link" value="{informationsystem_item/name}"/>
                                    <input type="hidden" name="city_service" value="1"/>
                                    <input type="hidden" name="g-recaptcha-response"/>
                                    <div class="cta-card__input-group">
                                        <label class="cta-card__label" for="service-name-{informationsystem_item/@id}">Ваше имя</label>
                                        <input class="cta-card__input" id="service-name-{informationsystem_item/@id}" name="name" type="text" autocomplete="name" placeholder="Как к вам обращаться"/>
                                    </div>
                                    <div class="cta-card__input-group">
                                        <label class="cta-card__label" for="service-phone-{informationsystem_item/@id}">Номер телефона <span>*</span></label>
                                        <input class="cta-card__input phone_mask" id="service-phone-{informationsystem_item/@id}" name="phone" type="tel" inputmode="tel" autocomplete="tel" placeholder="+7 (___) ___-__-__" maxlength="18" required=""/>
                                    </div>
                                    <button class="cta-card__submit" type="submit">Получить консультацию</button>
                                    <div class="form-message js-form-message" role="status" aria-live="polite"></div>
                                </form>
                                <p class="cta-card__disclaimer">Нажимая кнопку, вы соглашаетесь на обработку персональных данных.</p>
                            </div>
                        </aside>
                    </div>
                </div>
            </section>
            <div class="information-detail__body container">
                <xsl:apply-templates select="informationsystem_item"/>
            </div>
        </div>
    </xsl:template>

	<xsl:template match="/informationsystem/informationsystem_item">
		<!-- Content_Section Start>
		<xsl:if test="/informationsystem/informationsystem_item/property_value[tag_name='service-order']/value !=''">
			<xsl:value-of select="/informationsystem/informationsystem_item/property_value[tag_name='service-order']/value" disable-output-escaping="yes"/>
		</xsl:if-->
		<!-- Store parent id in a variable -->
		<!-- <xsl:variable name="group" select="informationsystem_group_id"/> -->
		<!-- Image
			<xsl:if test="image_large != ''">
				<div class="col col-img"><p>
						<xsl:choose>
							<xsl:when test="image_large!=''">
								<img loading="lazy" src="{dir}{image_large}" alt="{name}"/>
							</xsl:when>
							<xsl:otherwise>
								<img loading="lazy" src="{dir}{image_small}" alt="{name}"/>
							</xsl:otherwise>
						</xsl:choose>
				</p></div>
			</xsl:if> -->


			<!-- Breadcrumbs -->
			<!-- <xsl:apply-templates select="//informationsystem_group[@id=$group]" mode="breadCrumbs"/> -->

			<!-- Show Message -->
			<xsl:if test="/informationsystem/message/node()">
				<xsl:value-of disable-output-escaping="yes" select="/informationsystem/message"/>
			</xsl:if>

			<xsl:choose>
				<xsl:when test="parts_count > 1">
					<xsl:value-of disable-output-escaping="yes" select="text"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of disable-output-escaping="yes" select="text"/>

				</xsl:otherwise>
			</xsl:choose>

			<!--ul class="blog_icon_list"-->

			<!-- Average Grade -->
			<!--xsl:if test="comments_average_grade/node() and comments_average_grade != 0">
			<span>
				<xsl:call-template name="show_average_grade">
					<xsl:with-param name="grade" select="comments_average_grade"/>
					<xsl:with-param name="const_grade" select="5"/>
				</xsl:call-template>
			</span>
		</xsl:if-->

		<!-- Processing of the selected tag -->
		<!--xsl:if test="count(tag)">
		<li class="blog-lawn_icon"><xsl:apply-templates select="tag"/></li>
	</xsl:if>

	<xsl:if test="count(siteuser) &gt; 0">
		<li class="blog-user_icon"> <a href="/users/info/{siteuser/path}/"><xsl:value-of select="siteuser/login"/></a></li>
	</xsl:if-->

	<!--xsl:if test="rate/node()">
	<span id="informationsystem_item_id_{@id}" class="thumbs">
		<xsl:choose>
			<xsl:when test="/informationsystem/siteuser_id > 0">
				<xsl:choose>
					<xsl:when test="vote/value = 1">
						<xsl:attribute name="class">thumbs up</xsl:attribute>
					</xsl:when>
					<xsl:when test="vote/value = -1">
						<xsl:attribute name="class">thumbs down</xsl:attribute>
					</xsl:when>
				</xsl:choose>
				<span id="informationsystem_item_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
				<span class="inner_thumbs">
					<a onclick="return $.sendVote({@id}, 1, 'informationsystem_item')" href="{/informationsystem/url}?id={@id}&amp;vote=1&amp;entity_type=informationsystem_item" alt="&labelLike;"></a>
					<span class="rate" id="informationsystem_item_rate_{@id}"><xsl:value-of select="rate" /></span>
					<a onclick="return $.sendVote({@id}, 0, 'informationsystem_item')" href="{/informationsystem/url}?id={@id}&amp;vote=0&amp;entity_type=informationsystem_item" alt="&labelDislike;"></a>
				</span>
				<span id="informationsystem_item_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:attribute name="class">thumbs inactive</xsl:attribute>
				<span id="informationsystem_item_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
				<span class="inner_thumbs">
					<a alt="&labelLike;"></a>
					<span class="rate" id="informationsystem_item_rate_{@id}"><xsl:value-of select="rate" /></span>
					<a alt="&labelDislike;"></a>
				</span>
				<span id="informationsystem_item_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
			</xsl:otherwise>
		</xsl:choose>
	</span>
</xsl:if-->

<!-- Date
	<img src="/images/calendar.png" /> <xsl:value-of select="date"/>, <span hostcms:id="{@id}" hostcms:field="showed" hostcms:entity="informationsystem_item"><xsl:value-of select="showed"/></span>
	<xsl:text> </xsl:text>
	<xsl:call-template name="declension">
		<xsl:with-param name="number" select="showed"/>
	</xsl:call-template><xsl:text>. </xsl:text>-->
	<!--/ul-->


	<!-- Links 1-2-3 to the parts of the document -->
	<xsl:if test="parts_count &gt; 1">
		<div class="read_more">&labelReadMore;</div>

		<xsl:call-template name="for">
			<xsl:with-param name="limit">1</xsl:with-param>
			<xsl:with-param name="page" select="/informationsystem/part"/>
			<xsl:with-param name="link" select="/informationsystem/informationsystem_item/url"/>
			<xsl:with-param name="items_count" select="parts_count"/>
			<xsl:with-param name="visible_pages">6</xsl:with-param>
			<xsl:with-param name="prefix">part</xsl:with-param>
		</xsl:call-template>

		<div style="clear: both"></div>
	</xsl:if>

	<!--xsl:if test="count(property_value[value != '' or file != '' or shop_item/node() or informationsystem_item/node()])">
	<p class="h2">&labelAttributes;</p>
	<table border="0" class="news_properties">
		<xsl:apply-templates select="property_value[value != '' or file != '' or shop_item/node() or informationsystem_item/node()]"/>
	</table>
</xsl:if-->


<xsl:if test="/informationsystem/show_comments/node() and /informationsystem/show_comments = 1">

	<!-- Show Reviews -->
	<xsl:if test="count(comment)">
		<p class="h1"><a name="comments"></a>&labelReviews;</p>
		<xsl:apply-templates select="comment"/>
	</xsl:if>
</xsl:if>

<!-- If allowed to display add comment form,
	1 - Only authorized
	2 - All
	-->
	<xsl:if test="/informationsystem/show_add_comments/node() and ((/informationsystem/show_add_comments = 1 and /informationsystem/siteuser_id &gt; 0)  or /informationsystem/show_add_comments = 2)">

		<p class="button" onclick="$('.comment_reply').hide('slow');$('#AddComment').toggle('slow')">
			&labelAddReview;
		</p>

		<div id="AddComment" class="comment_reply">
			<xsl:call-template name="AddCommentForm"></xsl:call-template>
		</div>
	</xsl:if>

</xsl:template>

<!-- Tag Template -->
<xsl:template match="tag">
	<a href="{/informationsystem/url}tag/{urlencode}/" class="tag">
		<xsl:value-of select="name"/>
	</a>
	<xsl:if test="position() != last()"><xsl:text> / </xsl:text></xsl:if>
</xsl:template>
<!-- Breadcrumb -->
<xsl:template match="informationsystem_group" mode="breadCrumbs">
	<xsl:variable name="parent_id" select="parent_id"/>

	<xsl:apply-templates select="//informationsystem_group[@id=$parent_id]" mode="breadCrumbs"/>

	<xsl:if test="parent_id=0">
		<li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem">

			<a itemprop="item"  href="{/informationsystem/url}" hostcms:id="{/informationsystem/@id}" hostcms:field="name" hostcms:entity="informationsystem">
				<span itemprop="name"><xsl:value-of select="/informationsystem/name"/></span>
				<meta itemprop="position" content="2" />
		</a></li>
	</xsl:if>

	<!--span><xsl:text> → </xsl:text></span-->
	<li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem">
		<a itemprop="item"  href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="informationsystem_group">
			<span itemprop="name">	<xsl:value-of select="name"/></span>
		</a><meta itemprop="position" content="position()+1" />
	</li>
</xsl:template>
<!-- Star Rating -->
<xsl:template name="show_average_grade">
	<xsl:param name="grade" select="0"/>
	<xsl:param name="const_grade" select="0"/>

	<!-- To avoid loops -->
	<xsl:variable name="current_grade" select="$grade * 1"/>

	<xsl:choose>
		<!-- If a value is an integer -->
		<xsl:when test="floor($current_grade) = $current_grade and not($const_grade &gt; ceiling($current_grade))">

			<xsl:if test="$current_grade - 1 &gt; 0">
				<xsl:call-template name="show_average_grade">
					<xsl:with-param name="grade" select="$current_grade - 1"/>
					<xsl:with-param name="const_grade" select="$const_grade - 1"/>
				</xsl:call-template>
			</xsl:if>

			<xsl:if test="$current_grade != 0">
				<img src="/images/star-full.png"/>
			</xsl:if>
		</xsl:when>
		<xsl:when test="$current_grade != 0 and not($const_grade &gt; ceiling($current_grade))">

			<xsl:if test="$current_grade - 0.5 &gt; 0">
				<xsl:call-template name="show_average_grade">
					<xsl:with-param name="grade" select="$current_grade - 0.5"/>
					<xsl:with-param name="const_grade" select="$const_grade - 1"/>
				</xsl:call-template>
			</xsl:if>

			<img src="/images/star-half.png"/>
		</xsl:when>

		<!-- Show the gray stars until the current position does not reach the value increased to an integer -->
		<xsl:otherwise>
			<xsl:call-template name="show_average_grade">
				<xsl:with-param name="grade" select="$current_grade"/>
				<xsl:with-param name="const_grade" select="$const_grade - 1"/>
			</xsl:call-template>
			<img src="/images/star-empty.png"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- Breadcrumb -->
<xsl:template match="informationsystem_group" mode="breadCrumbs">
	<xsl:variable name="parent_id" select="parent_id"/>

	<!-- Call recursively parent group -->
	<xsl:apply-templates select="//informationsystem_group[@id=$parent_id]" mode="breadCrumbs"/>

	<xsl:if test="parent_id=0">
		<a href="{/informationsystem/url}">
			<xsl:value-of select="/informationsystem/name"/>
		</a>
	</xsl:if>

	<span><xsl:text> → </xsl:text></span>

	<a href="{url}">
		<xsl:value-of select="name"/>
	</a>
</xsl:template>

<!-- Review template -->
<xsl:template match="comment">
	<!-- Text or subject is not empty -->
	<xsl:if test="text != '' or subject != ''">
		<a name="comment{@id}"></a>
		<div class="comment" id="comment{@id}">
			<xsl:if test="subject != ''">
				<div class="subject" hostcms:id="{@id}" hostcms:field="subject" hostcms:entity="comment"><xsl:value-of select="subject"/></div>
			</xsl:if>

			<div hostcms:id="{@id}" hostcms:field="text" hostcms:entity="comment" hostcms:type="wysiwyg"><xsl:value-of select="text" disable-output-escaping="yes"/></div>

			<p class="tags">
				<!-- Grade -->
				<xsl:if test="grade != 0">
					<span><xsl:call-template name="show_average_grade">
							<xsl:with-param name="grade" select="grade"/>
							<xsl:with-param name="const_grade" select="5"/>
					</xsl:call-template></span>
				</xsl:if>

				<img src="/images/user.png" />
				<xsl:choose>
					<!-- Review was added an authorized user -->
					<xsl:when test="count(siteuser) &gt; 0">
						<span><a href="/users/info/{siteuser/path}/"><xsl:value-of select="siteuser/login"/></a></span>
					</xsl:when>
					<!-- Review was added an unauthorized user -->
					<xsl:otherwise>
						<span><xsl:value-of select="author" /></span>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="rate/node()">
					<span id="comment_id_{@id}" class="thumbs">
						<xsl:choose>
							<xsl:when test="/informationsystem/siteuser_id > 0">
								<xsl:choose>
									<xsl:when test="vote/value = 1">
										<xsl:attribute name="class">thumbs up</xsl:attribute>
									</xsl:when>
									<xsl:when test="vote/value = -1">
										<xsl:attribute name="class">thumbs down</xsl:attribute>
									</xsl:when>
								</xsl:choose>
								<span id="comment_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
								<span class="inner_thumbs">
									<a onclick="return $.sendVote({@id}, 1, 'comment')" href="{/informationsystem/url}?id={@id}&amp;vote=1&amp;entity_type=comment" alt="&labelLike;"></a>
									<span class="rate" id="comment_rate_{@id}"><xsl:value-of select="rate" /></span>
									<a onclick="return $.sendVote({@id}, 0, 'comment')" href="{/informationsystem/url}?id={@id}&amp;vote=0&amp;entity_type=comment" alt="&labelDislike;"></a>
								</span>
								<span id="comment_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
							</xsl:when>
							<xsl:otherwise>
								<xsl:attribute name="class">thumbs inactive</xsl:attribute>
								<span id="comment_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
								<sp…6449 tokens truncated…0443пам с первым экраном. Старые классы
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
