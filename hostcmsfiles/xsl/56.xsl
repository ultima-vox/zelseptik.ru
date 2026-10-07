<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://56">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- МагазинТовар -->
	<xsl:include href="import://277"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/shop">

		<xsl:choose>
			<xsl:when test="@id = 1">
				<xsl:apply-templates select="shop_item"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="shop_item"/>
			</xsl:otherwise>
		</xsl:choose>
	<!-- <xsl:if test="@id = 1"><xsl:apply-templates select="shop_item" mode="septik"/></xsl:if>
	<xsl:if test="@id = 5"><xsl:apply-templates select="shop_item" mode="pogreb"/></xsl:if>
	<xsl:if test="@id = 3"><xsl:apply-templates select="shop_item" mode="kessony"/></xsl:if>
	<xsl:if test="@id = 6"><xsl:apply-templates select="shop_item" mode="block6"/></xsl:if>
	Есть просмотренные товары -->
	<xsl:if test="viewed/shop_item">

		<!--section class="section area-quiz-new no-bg">
		<div class="page-bl">
			<div class="quiz_parent">
				<div class="area-products no-bg quiz-hide-bl" id="pr-slider2">
					<div class="title-wrap">
						<div class="title-bl fl-row">
							<div class="col">
								<h2 class="h-3">Просмотреные:</h2>
								<div class="sw-btns-bl">
									<div class="swiper-button prev"></div>
									<div class="swiper-button next"></div>
								</div>
							</div>
							<div class="desktop-bl col">
								<a class="h-link" href="{/shop/url}">ПЕРЕЙТИ В КАТАЛОГ
									<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698" stroke="#7abf18" stroke-width="1.4"/>
									</svg>
								</a>
							</div>
						</div>
					</div>
					<div class="pr-row fl-row">
						<div class="col col-main">
							- Выводим товары магазина
							<div class="swiper-box sw-prod" id="swiper-prod1">
								<div class="swiper">
									<div class="swiper-wrapper">
										<xsl:apply-templates select="viewed/shop_item[position() &lt; 6]" mode="view"/>

									</div>
								</div>
							</div>
							<script><xsl:text disable-output-escaping="yes">
									document.addEventListener("DOMContentLoaded", () => {
									var swiper = new Swiper('#pr-slider2 .swiper', {
									slidesPerView: 1, spaceBetween: 0, centeredSlides: false, loop: false,
									navigation: {
									nextEl: '#pr-slider2 .swiper-button.next',
									prevEl: '#pr-slider2 .swiper-button.prev',
									},
									breakpoints: {
									720: {slidesPerView: 2, spaceBetween: 0,},
									1300: {slidesPerView: 3, spaceBetween: 0,},
									},
									});
								});</xsl:text>
							</script>
							<div class="mobile-bl">
								<div class="title-wrap">
									<div class="title-bl fl-row fright">
										<div class="col">
											<a class="h-link" href="{/shop/shop_group/url}">ПЕРЕЙТИ В КАТАЛОГ
												<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
													<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698" stroke="#7abf18"
													stroke-width="1.4"/>
												</svg>
											</a>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="col col-info">
							<div class="ab-info">
								<div class="txt">
									<h3 class="h-3">Не знаете какой септик вам нужен?</h3>
									<p>Мы можем Вам помочь!</p>
									<a class="btn brd wht" href="/contacts/">Подобрать</a>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="area-quiz no-bg quiz-show-bl" id="quiz-product">
					<div class="title-wrap">
						<div class="title-bl fl-row">
							<div class="col">
								<h2 class="h-3">Похожие варианты:</h2>
							</div>
							<div class="desktop-bl col">
								<a class="h-link" href="{/shop/url}">ПЕРЕЙТИ В КАТАЛОГ
									<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698" stroke="#7abf18" stroke-width="1.4"/>
									</svg>
								</a>
							</div>
						</div>
					</div>
					<div class="quiz_overlay">
					</div>
				</div>
			</div>
		</div>
	</section-->
</xsl:if>
</xsl:template>


<xsl:template match="shop_item" >
<xsl:variable name="shop_id" select="/shop/@id"/>
<div class="product-page" itemscope="" itemtype="https://schema.org/Product">
<section class="hero-section grid-blueprint">
	<div class="container">
		<div class="hero-section__grid">
			<xsl:if test="/shop/message/node()">
				<xsl:value-of disable-output-escaping="yes" select="/shop/message"/>
			</xsl:if>
			<div class="hero-offer">
				<div class="product-summary__badges">
					<span class="badge"><xsl:choose><xsl:when test="$shop_id = 6">Сервис септиков</xsl:when><xsl:otherwise>Монтаж под ключ</xsl:otherwise></xsl:choose></span>
					<xsl:if test="shop_producer/name != ''">
						<span class="badge badge--outline">
							<xsl:value-of select="shop_producer/name"/>
						</span>
					</xsl:if>
				</div>
				<div class="hero-offer__title-block">
					<div class="premium-slogan"><xsl:choose><xsl:when test="$shop_id = 6">Плановое обслуживание и ремонт</xsl:when><xsl:otherwise>Инженерный подбор и монтаж</xsl:otherwise></xsl:choose></div>
					<h1 class="hero-offer__title hero-offer__title-2xl" itemprop="name" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item">
						<xsl:if test="$shop_id = 1"><xsl:text>Септик </xsl:text></xsl:if>
						<xsl:value-of select="name"/>
					</h1>
				</div>
				<xsl:if test="$shop_id = 1">
					<p class="hero-offer__subtitle">
						<xsl:text>Автономная канализация для дома или дачи</xsl:text>
						<xsl:if test="property_value[tag_name='men']/value != ''">
							<xsl:text> до </xsl:text>
							<xsl:value-of select="property_value[tag_name='men']/value"/>
							<xsl:text> человек</xsl:text>
						</xsl:if>
						<xsl:text> с подбором, доставкой и монтажом в Зеленограде и Московской области.</xsl:text>
					</p>
				</xsl:if>
				<div class="media-card">
					<xsl:choose>
						<xsl:when test="image_large != ''">
							<xsl:choose><xsl:when test="$shop_id = 6"><img class="media-card__content" itemprop="image" src="{dir}{image_large}" alt="{name}" loading="eager" decoding="async"/></xsl:when><xsl:otherwise><a class="media-card__link" href="{dir}{image_large}" data-fancybox="images">
								<img class="media-card__content" itemprop="image" src="{dir}{image_large}" alt="{name}" loading="eager" decoding="async"/>
							</a></xsl:otherwise></xsl:choose>
						</xsl:when>
						<xsl:otherwise>
							<img class="media-card__content" itemprop="image" src="/images/no-image.png" alt="{name}" loading="eager" decoding="async"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>

				<xsl:if test="$shop_id != 6 and (image_small != '' or count(property_value[tag_name='pic'][file != '']))">
					<div class="media-strip">
						<div class="media-strip__list">
							<xsl:if test="image_small != ''">
								<a class="media-strip__item" href="{dir}{image_large}" data-fancybox="images" aria-current="true">
									<img class="media-strip__thumb" src="{dir}{image_small}" alt="{name}" loading="lazy"/>
								</a>
							</xsl:if>

							<xsl:for-each select="property_value[tag_name='pic'][file != '']">
								<a class="media-strip__item" href="{../dir}{file}" data-fancybox="images">
									<img class="media-strip__thumb" src="{../dir}{file}" alt="{/shop/shop_item/name}" loading="lazy"/>
								</a>
							</xsl:for-each>
						</div>
					</div>
				</xsl:if>

			</div>

			<div class="hero-calculator-wrapper">
				<article class="catalog-card" itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
					<div class="catalog-card__body">
						<div class="catalog-card__price">
							<span class="catalog-card__price-label"><xsl:choose><xsl:when test="$shop_id = 6">Стоимость обслуживания от</xsl:when><xsl:otherwise>Цена оборудования от</xsl:otherwise></xsl:choose></span>

							<div class="catalog-card__price-row">
								<xsl:choose>
									<xsl:when test="price = 0">
										<strong class="catalog-card__price-actual">Под заказ</strong>
									</xsl:when>

									<xsl:when test="discount != 0">
										<span class="catalog-card__price-original">
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price + discount"/>
											</xsl:apply-templates>
										</span>
										<strong class="catalog-card__price-actual">
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price"/>
											</xsl:apply-templates>
										</strong>
									</xsl:when>

									<xsl:otherwise>
										<strong class="catalog-card__price-actual">
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price"/>
											</xsl:apply-templates>
										</strong>
									</xsl:otherwise>
								</xsl:choose>
							</div>

							<xsl:if test="price != 0">
								<meta itemprop="price" content="{price}"/>
								<meta itemprop="priceCurrency" content="RUB"/>
								<link itemprop="availability" href="https://schema.org/InStock"/>
							</xsl:if>
						</div>
						<xsl:if test="$shop_id = 1">
							<div class="catalog-card__specs">
								<xsl:if test="property_value[tag_name='men']/value != ''">
									<div class="catalog-card__spec">
										<span>Проживающих</span>
										<strong>до <xsl:value-of select="property_value[tag_name='men']/value"/> чел.</strong>
									</div>
								</xsl:if>

								<xsl:if test="property_value[tag_name='performance']/value != ''">
									<div class="catalog-card__spec">
										<span>Производительность</span>
										<strong><xsl:value-of select="property_value[tag_name='performance']/value"/> л/сутки</strong>
									</div>
								</xsl:if>

								<xsl:if test="property_value[tag_name='zalp']/value != '' and property_value[tag_name='zalp']/value != 0">
									<div class="catalog-card__spec">
										<span>Залповый сброс</span>
										<strong><xsl:value-of select="property_value[tag_name='zalp']/value"/> л</strong>
									</div>
								</xsl:if>

								<div class="catalog-card__spec">
									<span>Водоотведение</span>
									<strong>
										<xsl:choose>
											<xsl:when test="property_value[tag_name='pr']/value = 1">Принудительный</xsl:when>
											<xsl:otherwise>Самотечный</xsl:otherwise>
										</xsl:choose>
									</strong>
								</div>

								<div class="catalog-card__spec">
									<span>Горловина</span>
									<strong>
										<xsl:choose>
											<xsl:when test="property_value[tag_name='long']/value = 1">Удлиненная</xsl:when>
											<xsl:when test="property_value[tag_name='midi']/value = 1">Миди</xsl:when>
											<xsl:otherwise>Стандартная</xsl:otherwise>
										</xsl:choose>
									</strong>
								</div>

								<xsl:if test="shop_producer/node()">
									<div class="catalog-card__spec">
										<span>Производитель</span>
										<strong><xsl:value-of select="shop_producer/name"/></strong>
									</div>
								</xsl:if>

								<xsl:if test="weight != '' and weight != 0">
									<div class="catalog-card__spec">
										<span>Вес</span>
										<strong>
											<xsl:value-of select="format-number(weight, '#####0', 'my')"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="/shop/shop_measure/name"/>
										</strong>
									</div>
								</xsl:if>

								<xsl:if test="length != 0 or width != 0 or height != 0">
									<div class="catalog-card__spec">
										<span>Габариты</span>
										<strong>
											<xsl:value-of select="format-number(length, '#####0', 'my')"/>
											<xsl:text> × </xsl:text>
											<xsl:value-of select="format-number(width, '#####0', 'my')"/>
											<xsl:text> × </xsl:text>
											<xsl:value-of select="format-number(height, '#####0', 'my')"/>
											<xsl:text> </xsl:text>
											<xsl:value-of select="/shop/size_measure/name"/>
										</strong>
									</div>
								</xsl:if>
							</div>
						</xsl:if>
						<div class="catalog-card__actions">
							<button class="btn btn--primary btn--full js-catalog-order" type="button" data-name="{name}"><xsl:attribute name="data-order-kind"><xsl:choose><xsl:when test="/shop/@id = 6">service</xsl:when><xsl:otherwise>installation</xsl:otherwise></xsl:choose></xsl:attribute>
								Получить смету
							</button>
							<a class="btn btn--secondary btn--full" href="/contacts/">Обсудить с инженером</a>
						</div>
					</div>
				</article>
			</div>
		</div>
	</div>
</section>

<xsl:if test="description != '' or count(associated/shop_item) &gt; 0 or count(modifications/shop_item) &gt; 0">
	<section class="section section--white" id="description">
		<div class="container">
			<header class="section-header">
				<span class="badge">Информация</span>
				<h2 class="section-header__title"><xsl:choose><xsl:when test="/shop/@id = 6">Об услуге</xsl:when><xsl:otherwise>О модели <xsl:value-of select="name"/></xsl:otherwise></xsl:choose></h2>
			</header>

			<div class="info-split">
				<xsl:if test="description != ''">
					<article class="info-panel">
						<span class="badge">Основная информация</span>
						<h2 class="info-panel__title">Описание <xsl:value-of select="name"/></h2>
						<div class="info-panel__text" itemprop="description" hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop_item" hostcms:type="wysiwyg">
							<xsl:value-of select="description" disable-output-escaping="yes"/>
						</div>
					</article>
				</xsl:if>

				<xsl:if test="count(associated/shop_item) &gt; 0 or count(modifications/shop_item) &gt; 0">
					<article class="info-panel info-panel--soft">
						<span class="badge">Дополнительно</span>
						<h2 class="info-panel__title">Модификации <xsl:value-of select="name"/></h2>
						<p class="info-panel__text">Выберите исполнение станции по типу сброса и глубине подключения.</p>

						<div class="nav-pills">
							<div class="nav-pills__list">
								<xsl:apply-templates select="associated/shop_item" mode="product-modification-link"/>
								<xsl:apply-templates select="modifications/shop_item" mode="product-modification-link"/>
								<a class="nav-pills__item nav-pills__item--active" href="{url}" aria-current="page">
									<xsl:value-of select="name"/>
								</a>
							</div>
						</div>
					</article>
				</xsl:if>
			</div>
		</div>
	</section>
</xsl:if>
<xsl:if test="$shop_id = 1">
	<section class="cta-section" id="mounting">
		<div class="container">
			<div class="cta-section__grid">
				<div class="cta-section__info">
					<span class="cta-section__tag">Монтаж</span>
					<h2 class="cta-section__title">Что входит в установку септика</h2>
					<p class="cta-section__desc">Доставка, монтаж, подключение и запуск станции на участке.</p>

					<div class="cta-section__gifts-grid">
						<div class="cta-section__gift-btn">
							<span class="cta-section__gift-icon"></span>
							<span class="cta-section__gift-name">Выезд инженера на участок</span>
						</div>
						<div class="cta-section__gift-btn">
							<span class="cta-section__gift-icon"></span>
							<span class="cta-section__gift-name">Доставка станции и комплектующих</span>
						</div>
						<div class="cta-section__gift-btn">
							<span class="cta-section__gift-icon"></span>
							<span class="cta-section__gift-name">Монтаж, подключение и запуск</span>
						</div>
						<div class="cta-section__gift-btn">
							<span class="cta-section__gift-icon"></span>
							<span class="cta-section__gift-name">Инструктаж по эксплуатации</span>
						</div>
					</div>
				</div>

				<div class="cta-form-wrapper">
					<div class="cta-card">
						<div class="cta-card__header">
							<h3 class="cta-card__title">Получить смету</h3>
							<p class="cta-card__subtitle">Инженер уточнит грунт, глубину трубы и способ отвода воды.</p>
						</div>

						<div class="cta-card__form">
							<button class="btn btn--primary btn--full js-catalog-order" type="button" data-name="{name}"><xsl:attribute name="data-order-kind"><xsl:choose><xsl:when test="/shop/@id = 6">service</xsl:when><xsl:otherwise>installation</xsl:otherwise></xsl:choose></xsl:attribute>
								Рассчитать монтаж
							</button>
							<a class="btn btn--secondary btn--full" href="/contacts/">Обсудить с инженером</a>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>
</xsl:if>
</div>
</xsl:template>

<xsl:template match="associated/shop_item | modifications/shop_item" mode="product-modification-link">
<a class="nav-pills__item" href="{url}"><xsl:value-of select="name"/></a>
</xsl:template>

<xsl:template match="shop_item" mode="product-septik-v2">
<xsl:variable name="group" select="/shop/group"/>
<section class="area-pr-about no-bg">
	<div class="page-bl">
		<div class="txt">
			<ol class="breadcrumbs__list">
				<li><a href="/">
						Главная
				</a></li>
				<xsl:if test="$group = 0">
					<li><a href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop">
							<xsl:value-of select="/shop/name"/>
					</a></li>
				</xsl:if>
				<xsl:apply-templates select="/shop//shop_group[@id=$group]" mode="breadCrumbs"/>
				<!-- Если модификация, выводим в пути родительский товар -->
				<xsl:if test="shop_item/node()">
					<li>
						<a href="{shop_item/url}">
							<xsl:if test="/shop/@id = 1">Септик <xsl:text> </xsl:text></xsl:if>
							<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
					</a></li>
				</xsl:if>
				<li><a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><xsl:if test="/shop/@id = 1">Септик <xsl:text> </xsl:text></xsl:if><xsl:value-of select="name"/></a></li>
			</ol>
		</div>

		<div class="pr-about pr-about-product" itemscope="" itemtype="http://schema.org/Product">
			<div class="mobile-bl">
				<div class="pr-ab-head">
					<div class="col">
						<p class="h-3" itemprop="name">Септик <xsl:value-of select="name"/></p>
					</div>
					<div class="col">
						<div class="btn btn-price btn-load">
							<xsl:choose>
								<xsl:when test="price = 0">
									<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
										Под заказ
									</a>

								</xsl:when>
								<xsl:when test="discount != 0">
									<span class="old"><xsl:apply-templates select="/shop/shop_currency/code">
											<xsl:with-param name="value" select="price + discount" />
									</xsl:apply-templates> </span>
									<span class="new"><xsl:apply-templates select="/shop/shop_currency/code">
											<xsl:with-param name="value" select="price" />
									</xsl:apply-templates> </span>
								</xsl:when>
								<xsl:otherwise>
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price" />
									</xsl:apply-templates>
								</xsl:otherwise>
							</xsl:choose>
						</div>
					</div>
				</div>
			</div>
			<!-- Изображение для товара, если есть -->
			<div class="pr-gallery-wrap">
				<div class="swiper-box" id="swiper-for">
					<div class="swiper">
						<div class="swiper-wrapper">
							<xsl:if test="image_large != ''">
								<div class="swiper-slide">
									<a href="{dir}{image_large}" data-fancybox="images">
										<source srcset="{dir}{image_large}" media="(min-width: 500px)"/>
										<img itemprop="image" src="{dir}{image_large}" alt="{name}" class="lazyload" loading="lazy" />
									</a>
								</div>
							</xsl:if>
							<xsl:for-each select="property_value[tag_name='pic'][file !='']">
								<div class="swiper-slide">
									<a href="{../dir}{file}" class="lightbox-image" title="{/shop/shop_item/name}" data-fancybox="images">
										<source srcset="{dir}{image_large}" media="(min-width: 500px)" />
										<img itemprop="image" data-src="{../dir}{file}" src="{../dir}{file}" loading="lazy" alt="{/shop/shop_item/name}" class="lazyload" />
									</a>

								</div>
							</xsl:for-each>

						</div>
					</div>
				</div>
				<div class="swiper-box" id="swiper-nav">
					<div class="swiper">
						<div class="swiper-wrapper">
							<xsl:if test="image_small != ''">
								<div class="swiper-slide">
									<div class="photo-s"><span><img itemprop="image" src="{dir}{image_small}" alt="{name}" class="lazyload" loading="lazy" /></span></div>
								</div>
							</xsl:if>
							<xsl:for-each select="property_value[tag_name='pic'][file !='']">
								<div class="swiper-slide">
									<div class="photo-s"><span>
											<img data-src="{../dir}{file}" src="{../dir}{file}" load="lazy"  alt="{/shop/shop_item/name}" itemprop="image"  class="lazyload" />
										</span>
									</div>
								</div>
							</xsl:for-each>
						</div>
					</div>
					<div class="sw-btns-bl">
						<div class="swiper-button prev"></div>
						<div class="swiper-button next"></div>
					</div>
				</div>
			</div>
			<div class="pr-info-wrap">
				<!--h1 hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item" class="black-color mar_btm18">Купить септик <span class="lytgreen-head"><xsl:value-of select="name"/> <xsl:choose>
						<xsl:when test="property_value[tag_name='dacha']/value = 1">
							<span class="prd_star_img">
								<strong>для дачи</strong>
							</span>

						</xsl:when>
						<xsl:if test="property_value[tag_name='pr']/value = 1 and property_value[tag_name='nopr']/value = 0  and property_value[tag_name='pr']/value = 0">
							<xsl:otherwise>

								<span class="prd_star_img"><strong>для загородного дома</strong>
								</span>
							</xsl:otherwise>
						</xsl:choose>
				</span></h1-->
				<div class="desktop-bl">
					<div class="pr-ab-head">
						<div class="col">
							<xsl:choose>
								<xsl:when test="/shop/@id = 1">
									<h1 hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item" class="h-2">Купить септик<xsl:text> </xsl:text><xsl:value-of select="name"/><xsl:text> </xsl:text>
									</h1>

								</xsl:when>
								<xsl:when test="/shop/@id = 3 or /shop/@id = 5">
									<h1 hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item" class="h-2">Купить<xsl:text> </xsl:text><xsl:value-of select="name"/><xsl:text> </xsl:text>
									</h1>

								</xsl:when>
								<xsl:otherwise>
									<h1 hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item" class="h-2"><xsl:value-of select="name"/></h1>

								</xsl:otherwise>
							</xsl:choose>
						</div>

					</div>
				</div>
				<!-- Store parent id in a variable -->
				<xsl:if test="count(associated/shop_item) &gt; 0">
					<div class="modific-bl open">
						<div class="modific-head">
							<div class="tabs-h">Модификации:
								<div class="i-btn">
									<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path fill-rule="evenodd" clip-rule="evenodd"
											d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM11.258 5.95746C11.258 4.26376 9.72769 3.55566 8.17335 3.55566C6.69151 3.55566 5.33174 4.59967 5.33203 5.77774C5.33203 6.25793 5.69683 6.51022 6.12181 6.51022C6.66959 6.51022 6.83106 6.167 7.00373 5.79998C7.20215 5.37825 7.41534 4.92508 8.24642 4.92508C8.97545 4.92508 9.4116 5.30946 9.4116 5.95774C9.4116 6.51806 8.93076 6.88508 8.42657 7.26991C7.87095 7.69401 7.28699 8.13973 7.28699 8.88962C7.28699 9.274 7.54204 9.6941 8.06416 9.6941C8.63512 9.6941 8.74993 9.39477 8.87418 9.07082C8.92435 8.93999 8.97607 8.80516 9.05999 8.68439C9.1771 8.5143 9.42327 8.34091 9.71006 8.1389C10.3749 7.67065 11.258 7.04863 11.258 5.95746ZM9.1087 11.4592C9.1087 10.9178 8.6585 10.4739 8.11288 10.4739C7.5664 10.4739 7.11677 10.9181 7.11677 11.4592C7.11677 12.0012 7.5664 12.4446 8.11288 12.4446C8.65936 12.4446 9.1087 12.0006 9.1087 11.4592Z"
										fill="#7abf18"/>
									</svg>
									<span>Пр — с принудительным выбросом стоков. Его устанавливают при высоких грунтовых водах или выбросе стоков в канаву. Стандарт/Миди/Лонг — различают по длине горловины. Миди и Лонг, удлиненные, нужны, если стоковая труба выходит глубже 60 см от уровня земли.</span>
								</div>
							</div>
							<span class="sbm"></span>
						</div>
						<div class="modific-body" >
							<div class="fl-row">
								<div class="col">
									<ul>
										<xsl:apply-templates select="associated/shop_item"/>
										<li><a href="{url}">
												<strong><xsl:value-of select="name"/></strong>
										</a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>



				<xsl:if test="count(modifications/shop_item) &gt; 0">
					<div class="modific-bl open">
						<div class="modific-head">
							<div class="tabs-h">Модификации:
								<div class="i-btn">
									<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
										<path fill-rule="evenodd" clip-rule="evenodd"
											d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM11.258 5.95746C11.258 4.26376 9.72769 3.55566 8.17335 3.55566C6.69151 3.55566 5.33174 4.59967 5.33203 5.77774C5.33203 6.25793 5.69683 6.51022 6.12181 6.51022C6.66959 6.51022 6.83106 6.167 7.00373 5.79998C7.20215 5.37825 7.41534 4.92508 8.24642 4.92508C8.97545 4.92508 9.4116 5.30946 9.4116 5.95774C9.4116 6.51806 8.93076 6.88508 8.42657 7.26991C7.87095 7.69401 7.28699 8.13973 7.28699 8.88962C7.28699 9.274 7.54204 9.6941 8.06416 9.6941C8.63512 9.6941 8.74993 9.39477 8.87418 9.07082C8.92435 8.93999 8.97607 8.80516 9.05999 8.68439C9.1771 8.5143 9.42327 8.34091 9.71006 8.1389C10.3749 7.67065 11.258 7.04863 11.258 5.95746ZM9.1087 11.4592C9.1087 10.9178 8.6585 10.4739 8.11288 10.4739C7.5664 10.4739 7.11677 10.9181 7.11677 11.4592C7.11677 12.0012 7.5664 12.4446 8.11288 12.4446C8.65936 12.4446 9.1087 12.0006 9.1087 11.4592Z"
										fill="#7abf18"/>
									</svg>
									<span>Пр — с принудительным выбросом стоков. Его устанавливают при высоких грунтовых водах или выбросе стоков в канаву. Стандарт/Миди/Лонг — различают по длине горловины. Миди и Лонг, удлиненные, нужны, если стоковая труба выходит глубже 60 см от уровня земли.</span>
								</div>
							</div>
							<span class="sbm"></span>
						</div>
						<div class="modific-body" >
							<div class="fl-row">
								<div class="col">
									<ul>
										<xsl:apply-templates select="modifications/shop_item"/>
										<li><a href="{url}">
												<strong><xsl:value-of select="name"/></strong>
										</a></li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</xsl:if>
				<!--p>
				<xsl:if test="$group = 0">
					<a href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop">
						<xsl:value-of select="/shop/name"/>
					</a>
				</xsl:if-->

				<!-- Breadcrumbs -->
				<!--xsl:apply-templates select="/shop//shop_group[@id=$group]" mode="breadCrumbs"/-->

				<!-- Если модификация, выводим в пути родительский товар -->
				<!--xsl:if test="shop_item/node()">
				<span><xsl:text> → </xsl:text></span>
				<a href="{shop_item/url}">
					<xsl:value-of disable-output-escaping="yes" select="shop_item/name"/>
				</a>
			</xsl:if>

			<span><xsl:text> → </xsl:text></span>

			<b><a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><xsl:value-of select="name"/></a></b>
		</p-->

		<!-- Show Message -->
		<xsl:if test="/shop/message/node()">
			<xsl:value-of disable-output-escaping="yes" select="/shop/message"/>
		</xsl:if>

		<ul class="specific-tbl" itemprop="description">
			<xsl:if test="weight !='' and weight != 0 ">
				<li>
					<strong>Вес</strong><span><xsl:value-of select="format-number(weight, '#####0', 'my')"/> <xsl:text> </xsl:text><xsl:value-of select="/shop/shop_measure/name"/></span>
				</li>
			</xsl:if>
			<xsl:if test="(length != '' or width !='' or height != '') and (length != 0 or width !=0 or height != 0)">
				<li>
					<strong>Габариты:</strong><span><xsl:value-of select="format-number(length, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:text>x</xsl:text><xsl:text> </xsl:text><xsl:value-of select="format-number(width, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:text>x</xsl:text><xsl:text> </xsl:text><xsl:value-of select="format-number(height, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:value-of select="/shop/size_measure/name" /></span>

			</li></xsl:if>
			<xsl:if test="property_value[tag_name='men']/value !=''">
				<li><strong>Количество пользователей (до)</strong><span><xsl:value-of select="property_value[tag_name='men']/value" /> чел.</span></li>
			</xsl:if>
			<xsl:if test="/shop/@id = 1 or /shop/@id = 6">
				<xsl:choose>
					<xsl:when test="property_value[tag_name='long']/value = 1 ">
						<li><strong>Длина горловины септика</strong><span>Удлиненная горловина</span></li>
					</xsl:when>
					<xsl:otherwise>
						<li><strong>Длина горловины септика</strong><span>Стандартная горловина</span></li>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="property_value[tag_name='zalp']/value !='' or property_value[tag_name='zalp']/value !='0'">
				<li><strong>Объём
				залпового сброса</strong><span><xsl:value-of select="property_value[tag_name='zalp']/value" /> л</span></li>
			</xsl:if>
			<xsl:if test="property_value[tag_name='performance']/value !=''">
				<li><strong>Производительность</strong><span><xsl:value-of select="property_value[tag_name='performance']/value" /> л/сутки</span></li>
			</xsl:if>
			<xsl:if test="property_value[tag_name='pr']/value = 1 or property_value[tag_name='nopr']/value = 1">
				<li><strong>Водоотведение</strong><span>
						<xsl:choose>
							<xsl:when test="property_value[tag_name='pr']/value = 1">
								Принудительный
							</xsl:when>
							<xsl:otherwise>Самотечный</xsl:otherwise>
			</xsl:choose></span></li></xsl:if>
			<xsl:if test="shop_producer/node()">
				<li>
					<strong>Производитель</strong><span><xsl:value-of disable-output-escaping="yes" select="shop_producer/name"/></span>
				</li>
			</xsl:if>

			<!--li>
			<span>Категория:  <a href="{//shop_group[@id=$group]/url}"><xsl:value-of select="//shop_group[@id=$group]/name"/></a>
			</span>
		</li-->
		<xsl:if test="property_value[tag_name='dacha']/value = 1 or property_value[tag_name='dom']/value = 1">
			<li><strong>Назначение</strong><span>
					<xsl:choose>
						<xsl:when test="property_value[tag_name='dacha']/value = 1">

							Для дачи

						</xsl:when>
						<xsl:otherwise>Для загородного дома</xsl:otherwise>
		</xsl:choose></span></li></xsl:if>
	</ul>
	<div class="pr-prices-row" itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
		<div class="pr-prices btn-load">
			<xsl:choose>
				<xsl:when test="price = 0">
					<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
						Под заказ
					</a>

				</xsl:when>
				<xsl:when test="discount != 0">
					<span class="new"><xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
					</xsl:apply-templates> </span>
					<span class="old"><xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price + discount" />
					</xsl:apply-templates> </span>
					<meta itemprop="price" content="{price}" />
					<meta itemprop="priceCurrency" content="RUB" />
					<link itemprop="availability" href="https://schema.org/InStock" />
				</xsl:when>
				<xsl:otherwise>
					<span class="new">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
					</xsl:apply-templates> </span>
					<meta itemprop="price" content="{price}" />
					<meta itemprop="priceCurrency" content="RUB" />
					<link itemprop="availability" href="https://schema.org/InStock" />
				</xsl:otherwise>
			</xsl:choose>
		</div>


	</div>
	<div class="pr-extra">
		<div class="fl-row">
			<xsl:if test="/shop/@id = 1 or /shop/@id = 3 or /shop/@id = 5">
				<div class="col">
					<span class="icon"><img  src="/assets/images/extra-01.svg" alt="рассрочка" class="lazyload" loading="lazy" /></span>
					<p>Доступен <br/>в рассрочку</p>
				</div>
				<div class="col">
					<span class="icon"><img src="/assets/images/extra-02.svg" alt="кредит" class="lazyload" loading="lazy" /></span>
					<p>Можно купить <br/>в кредит</p>
				</div>
			</xsl:if>
			<div class="col">
				<span class="icon"><img src="/assets/images/extra-03.svg" alt="без предоплат" class="lazyload" loading="lazy" /></span>
				<p>Без <br/>предоплат</p>
			</div>
		</div>
	</div>
	<!--<hr class="lytgreen-head"/>
	Описание товара
	<xsl:if test="description != ''">
		<xsl:value-of disable-output-escaping="yes" select="description" />
	</xsl:if>-->

	<!-- Цена товара
		<xsl:if test="price != 0">
			<div class="prd_detail_price">
				<span class="price_txt">Цена :</span>
				<xsl:choose>
					<xsl:when test="price = 0">
						<span class="price_no">	<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
								Под заказ
						</a></span>

					</xsl:when>
					<xsl:when test="discount != 0">
						<span class="price_no">			<xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="price" />
						</xsl:apply-templates></span>
						<span><xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="price + discount" />
						</xsl:apply-templates></span>
					</xsl:when>
					<xsl:otherwise>
						<span class="price_no"><xsl:apply-templates select="/shop/shop_currency/code">
								<xsl:with-param name="value" select="price" />
						</xsl:apply-templates></span>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
		Cкидки
		<xsl:if test="count(shop_discount)">
			<xsl:apply-templates select="shop_discount"/>
		</xsl:if>
		-->
		<!--xsl:if test="marking != ''">
		<div class="shop_property">&labelMarking; <span hostcms:id="{@id}" hostcms:field="marking" hostcms:entity="shop_item"><xsl:value-of select="marking"/></span></div>
	</xsl:if>

	<xsl:if test="shop_producer/node()">
		<div class="shop_property">&labelProducer; <span><xsl:value-of select="shop_producer/name"/></span></div>
	</xsl:if
	<a href="#" data-toggle="modal" data-target="#productModal{@id}" data-description="{name}" onclick="lalal(this);" title="быстрый заказ" class="view-all hvr-bounce-to-right shop_add_cart add_cart_second_btn">купить</a>-->
	<div class="pr-sbmts fl-row desktop">
		<div class="col">
			<p><a class="btn w-btn" data-toggle="modal" data-target="#productModal{@id}" title="быстрый заказ" data-description="{name}" >ОФОРМИТЬ ЗАКАЗ</a></p>
			<!--p> <span class="btn grn pls" onclick="cart.add('460',1,this);"><img
					width="22" height="22"
					src="/assets/images/icon-pls.svg"
					alt="">
				</span>
			</p-->
		</div>
		<div class="col">
			<p><a class="btn brd w-btn" href="/contacts/">ОБСУДИТЬ С НАМИ</a></p>
		</div>
	</div>
	<div class="pr-sbmts fl-row tablet">
		<div class="col">
			<p><a class="btn w-btn" data-toggle="modal" data-target="#productModal{@id}" title="быстрый заказ" data-description="{name}">
			ОФОРМИТЬ ЗАКАЗ</a></p>
			<!--p><span class="btn grn pls" onclick="cart.add('460',1,this);"><img
					width="22" height="22"
					src="../catalog/view/theme/sewera/images/icon-pls.svg"
					alt="">
			</span></p-->
		</div>
		<div class="col">
			<p><a class="btn brd w-btn"  href="/contacts/">обсудить с нами</a></p>
		</div>
	</div>
</div>
</div>
<!-- Quick View Modal Start
<div class="modal fade andro_quick-view-modal" id="productModal{@id}" role="dialog" aria-hidden="true">
	<div class="modal-dialog modal-lg modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-body">

				<div class="close-btn close-dark close" data-dismiss="modal">

					<button title="Закрыть (Esc)" type="button" class="close-btn">×</button>
				</div>

				<div class="container-fluid">
					<div class="row">
						<div class="col-md-5">
							<img src="/assets/files/call.jpg" alt="Заказ по телефону" />
						</div>
						<div class="col-md-7">

							<div class="andro_product-single-content">
								<h3 class="mailform"> Заказать септик <xsl:value-of disable-output-escaping="yes" select="shop_item/name" /> по телефону </h3>
								<form name="mailform2" id="mailform2" method="post" enctype="multipart/form-data"  class="andro_product-atc-form">
									<div class="form-group">
										<input type="text" class="form-control leave_form" name="name" id="name" placeholder="Ваше имя" required="required"/>
									</div>
									<div class="form-group">
										<input type="tel" name="email" id="email" class="form-control leave_form" placeholder="Ваш телефон" required="required"/>
									</div>
									<div class="form-group">
										<input type="text" name="subject" id="subject" class="form-control leave_form" placeholder="Септик {name}" value="{name}" disabled="disabled"/>
									</div>
									<div class="form-group">
										<textarea name="textarea" id="textarea" class="form-control leave_form" placeholder="Комментарий к заказу"></textarea>
									</div>
									<input id="check" name="check" type="hidden" value=""/>
									<div class="error2"></div>
									<input type="submit" value="Отправить" onClick="document.getElementById('check').value = 'nospam'; ym(53623984,'reachGoal','goal');" class="btn submit_now mr_30" name="submit_form" />
								</form>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
Quick View Modal End
<div class="txt">
	<xsl:value-of select="text" disable-output-escaping="yes"/>
</div>-->
</div>
</section>

</xsl:template>
<!-- Шаблон для товара просмотренные -->
<xsl:template match="shop_item" mode="view">
<div class="swiper-slide">
<div class="pr-small">
<div class="img">
	<a href="{url}">
		<xsl:choose>
			<xsl:when test="image_large != ''">
				<img itemprop="image" src="{dir}{image_large}" width="152" height="152" alt="{name}" class="lazyload" loading="lazy" title="{name}"/>
			</xsl:when>
			<xsl:otherwise>
				<img itemprop="image" src="/images/no-image.png" alt="{name}" title="{name}" class="lazyload" loading="lazy" />
			</xsl:otherwise>
		</xsl:choose>
	</a>
</div>
<div class="pr-body-row">
	<div class="pr-body-col">
		<div class="txt">
			<div class="h-5" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><a href="{url}"><xsl:value-of select="name"/></a></div>
			<xsl:value-of select="description" disable-output-escaping="yes"/>
			<!--xsl:choose>
			<xsl:when test="price = 0">
				<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
					Под заказ
				</a>

			</xsl:when>
			<xsl:when test="discount != 0">
				<span class="prd_price wdt_100">			<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="price" />
				</xsl:apply-templates></span>
				<span>	<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="price + discount" />
				</xsl:apply-templates></span>
			</xsl:when>
			<xsl:otherwise>
				<span class="prd_price wdt_100"><xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="price" />
				</xsl:apply-templates></span>
			</xsl:otherwise>
		</xsl:choose-->
	</div>
	<div class="modific-bl">
		<xsl:if test="/shop/@id = 1">
			<h6 class="tabs-h">Модификация:
				<span class="i-btn">
					<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
						<path fill-rule="evenodd" clip-rule="evenodd" d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM11.258 5.95746C11.258 4.26376 9.72769 3.55566 8.17335 3.55566C6.69151 3.55566 5.33174 4.59967 5.33203 5.77774C5.33203 6.25793 5.69683 6.51022 6.12181 6.51022C6.66959 6.51022 6.83106 6.167 7.00373 5.79998C7.20215 5.37825 7.41534 4.92508 8.24642 4.92508C8.97545 4.92508 9.4116 5.30946 9.4116 5.95774C9.4116 6.51806 8.93076 6.88508 8.42657 7.26991C7.87095 7.69401 7.28699 8.13973 7.28699 8.88962C7.28699 9.274 7.54204 9.6941 8.06416 9.6941C8.63512 9.6941 8.74993 9.39477 8.87418 9.07082C8.92435 8.93999 8.97607 8.80516 9.05999 8.68439C9.1771 8.5143 9.42327 8.34091 9.71006 8.1389C10.3749 7.67065 11.258 7.04863 11.258 5.95746ZM9.1087 11.4592C9.1087 10.9178 8.6585 10.4739 8.11288 10.4739C7.5664 10.4739 7.11677 10.9181 7.11677 11.4592C7.11677 12.0012 7.5664 12.4446 8.11288 12.4446C8.65936 12.4446 9.1087 12.0006 9.1087 11.4592Z" fill="#009CD9" />
					</svg>
					<span>Пр — с принудительным выбросом стоков. Его устанавливают при высоких грунтовых водах или выбросе стоков в канаву. Стандарт/Миди/Лонг — различают по длине горловины. Миди и Лонг, удлиненные, нужны, если стоковая труба выходит глубже 60 см от уровня земли.</span>
				</span>
			</h6>
			<div class="tabs-row">
				<ul>
					<xsl:choose>
						<xsl:when test="property_value[tag_name='nopr']/value = 1">
							<li class="modification_load active">
								<span class="name">Самотечный</span>
							</li>
							<!--li class="modification_load">
							<span class="name">Принудительный</span>
						</li-->
					</xsl:when>
					<xsl:otherwise>
						<!--li class="modification_load">
						<span class="name">Самотечный</span>
					</li-->
					<li class="modification_load active">
						<span class="name">Принудительный</span>
					</li>
				</xsl:otherwise>
			</xsl:choose>


		</ul>
	<span class="line"></span></div>
</xsl:if>
<xsl:if test="/shop/@id = 1 or /shop/@id = 6">
	<div class="tabs-row">
		<ul>
			<xsl:choose>
				<xsl:when test="property_value[tag_name='long']/value = 1">
					<!--li class="modification_load ">
					<span class="name">Стандарт</span>
				</li-->
				<li class="modification_load active" >
					<span class="name">Лонг</span>
				</li>
			</xsl:when>
			<xsl:when test="property_value[tag_name='midi']/value = 1">
				<!--li class="modification_load ">
				<span class="name">Стандарт</span>
			</li-->
			<li class="modification_load active" >
				<span class="name">Миди</span>
			</li>
		</xsl:when>
		<xsl:otherwise>
			<li class="modification_load  active">
				<span class="name">Стандарт</span>
			</li>
			<!--li class="modification_load" >
			<span class="name">Лонг</span>
		</li-->
	</xsl:otherwise>
</xsl:choose>
</ul>
<span class="line" style="width: 50%; left: 0%;"></span></div>
</xsl:if>
</div>
</div>
</div>
<div class="btns-row">
<p><a href="{url}" class="btn"><xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price" />
</xsl:apply-templates></a></p>
</div>
</div>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->
</xsl:template>
<xsl:template match="associated/shop_item" mode="view">
<div class="swiper-slide">
<div class="pr-small">
<div class="img">
<a href="{url}">
<xsl:choose>
<xsl:when test="image_large != ''">
<img itemprop="image" src="{dir}{image_large}" width="152" height="152" alt="{name}" class="lazyload" loading="lazy" title="{name}"/>
</xsl:when>
<xsl:otherwise>
<img itemprop="image" src="/images/no-image.png" alt="{name}" title="{name}" class="lazyload" loading="lazy" />
</xsl:otherwise>
</xsl:choose>
</a>
</div>
<h6 hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><xsl:value-of select="name"/></h6>
<xsl:choose>
<xsl:when test="price = 0">
<span class="prd_price wdt_100">	<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
Под заказ
</a></span>

</xsl:when>
<xsl:when test="discount != 0">
<span class="prd_price wdt_100">			<xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price" />
</xsl:apply-templates></span>
<span>	<xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price + discount" />
</xsl:apply-templates></span>
</xsl:when>
<xsl:otherwise>
<span class="prd_price wdt_100"><xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price" />
</xsl:apply-templates></span>
</xsl:otherwise>
</xsl:choose>


<a href="{url}" class="view-all hvr-bounce-to-right shop_add_cart">посмотреть</a>
</div>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->
</xsl:template>
<!-- Show property item -->
<xsl:template match="property_value">
<xsl:if test="value/node() and value != '' or file/node() and file != ''">
<div class="shop_property">
<xsl:variable name="property_id" select="property_id" />
<xsl:variable name="property" select="/shop/shop_item_properties//property[@id=$property_id]" />

<xsl:value-of select="$property/name"/><xsl:text>: </xsl:text>
<span><xsl:choose>
<xsl:when test="$property/type = 2">
<a href="{../dir}{file}" target="_blank"><xsl:value-of select="file_name"/></a>
</xsl:when>
<xsl:when test="$property/type = 5">
<a href="{informationsystem_item/url}"><xsl:value-of select="informationsystem_item/name"/></a>
</xsl:when>
<xsl:when test="$property/type = 7">
<input type="checkbox" disabled="disabled">
<xsl:if test="value = 1">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
</input>
</xsl:when>
<xsl:when test="$property/type = 12">
<a href="{shop_item/url}"><xsl:value-of select="shop_item/name"/></a>
</xsl:when>
<xsl:otherwise>
<xsl:value-of disable-output-escaping="yes" select="value"/>
<!-- Единица измерения свойства -->
<xsl:if test="$property/shop_measure/node()">
<xsl:text> </xsl:text><xsl:value-of select="$property/shop_measure/name"/>
</xsl:if>
</xsl:otherwise>
</xsl:choose></span>
</div>
</xsl:if>
</xsl:template>

<!-- Tag Template -->
<xsl:template match="tag">
<li>
<a href="{/shop/url}tag/{urlencode}/" class="tag">
<xsl:value-of select="name"/>
</a></li>
<xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
</xsl:template>

<!-- Шаблон для модификаций -->
<xsl:template match="modifications/shop_item">
<li>
<!-- Название модификации -->
<a href="{url}"><xsl:value-of select="name"/></a>
<!--,
Цена модификации
<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/>-->
</li>
</xsl:template>

<!-- Шаблон для сопутствующих товаров -->
<xsl:template match="associated/shop_item">
<li>
<!-- Название сопутствующего товара -->
<a href="{url}"><xsl:value-of select="name"/></a>
<!-- Цена сопутствующего товара
<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/>-->
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

<!-- Шаблон для вывода звездочек (оценки) -->
<xsl:template name="for">
<xsl:param name="i" select="0"/>
<xsl:param name="n"/>

<input type="radio" name="shop_grade" value="{$i}" id="id_shop_grade_{$i}">
<xsl:if test="/shop/shop_grade = $i">
<xsl:attribute name="checked"></xsl:attribute>
</xsl:if>
</input><xsl:text> </xsl:text>
<label for="id_shop_grade_{$i}">
<xsl:call-template name="show_average_grade">
<xsl:with-param name="grade" select="$i"/>
<xsl:with-param name="const_grade" select="5"/>
</xsl:call-template>
</label>
<br/>
<xsl:if test="$n &gt; $i and $n &gt; 1">
<xsl:call-template name="for">
<xsl:with-param name="i" select="$i + 1"/>
<xsl:with-param name="n" select="$n"/>
</xsl:call-template>
</xsl:if>
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
<xsl:when test="/shop/siteuser_id > 0">
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
<a onclick="return $.sendVote({@id}, 1, 'comment')" href="{/shop/url}?id={@id}&amp;vote=1&amp;entity_type=comment" alt="&labelLike;"></a>
<span class="rate" id="comment_rate_{@id}"><xsl:value-of select="rate" /></span>
<a onclick="return $.sendVote({@id}, 0, 'comment')" href="{/shop/url}?id={@id}&amp;vote=0&amp;entity_type=comment" alt="&labelDislike;"></a>
</span>
<span id="comment_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
</xsl:when>
<xsl:otherwise>
<xsl:attribute name="class">thumbs inactive</xsl:attribute>
<span id="comment_likes_{@id}"><xsl:value-of select="rate/@likes" /></span>
<span class="inner_thumbs">
<a alt="&labelLike;"></a>
<span class="rate" id="comment_rate_{@id}"><xsl:value-of select="rate" /></span>
<a alt="&labelDislike;"></a>
</span>
<span id="comment_dislikes_{@id}"><xsl:value-of select="rate/@dislikes" /></span>
</xsl:otherwise>
</xsl:choose>
</span>
</xsl:if>

<img src="/images/calendar.png" /> <span><xsl:value-of select="datetime"/></span>

<xsl:if test="/shop/show_add_comments/node()
and ((/shop/show_add_comments = 1 and /shop/siteuser_id > 0)
or /shop/show_add_comments = 2)">
<span class="red" onclick="$('.comment_reply').hide('slow');$('#cr_{@id}').toggle('slow')">&labelReply;</span></xsl:if>

<span class="red"><a href="{/shop/shop_item/url}#comment{@id}" title="&labelCommentLink;">#</a></span>
</p>
</div>

<!-- Only for authorized users -->
<xsl:if test="/shop/show_add_comments/node() and ((/shop/show_add_comments = 1 and /shop/siteuser_id > 0) or /shop/show_add_comments = 2)">
<div class="comment_reply" id="cr_{@id}">
<xsl:call-template name="AddCommentForm">
<xsl:with-param name="id" select="@id"/>
</xsl:call-template>
</div>
</xsl:if>

<!-- Child Reviews -->
<xsl:if test="count(comment)">
<div class="comment_sub">
<xsl:apply-templates select="comment"/>
</div>
</xsl:if>
</xsl:if>
</xsl:template>

<!-- AddCommentForm Template -->
<xsl:template name="AddCommentForm">
<xsl:param name="id" select="0"/>


<xsl:variable name="subject">
<xsl:if test="/shop/comment/parent_id/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
<xsl:value-of select="/shop/comment/subject"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="email">
<xsl:if test="/shop/comment/email/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
<xsl:value-of select="/shop/comment/email"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="phone">
<xsl:if test="/shop/comment/phone/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
<xsl:value-of select="/shop/comment/phone"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="text">
<xsl:if test="/shop/comment/text/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
<xsl:value-of select="/shop/comment/text"/>
</xsl:if>
</xsl:variable>
<xsl:variable name="name">
<xsl:if test="/shop/comment/author/node() and /shop/comment/parent_id/node() and /shop/comment/parent_id= $id">
<xsl:value-of select="/shop/comment/author"/>
</xsl:if>
</xsl:variable>

<div class="comment">

<form action="{/shop/shop_item/url}" name="comment_form_0{$id}" method="post">
<!-- Only for unauthorized users -->
<xsl:if test="/shop/siteuser_id = 0">

<div class="row">
<div class="caption">&labelName;</div>
<div class="field">
<input type="text" size="70" name="author" value="{$name}"/>
</div>
</div>

<div class="row">
<div class="caption">&labelEmail;</div>
<div class="field">
<input id="email{$id}" type="text" size="70" name="email" value="{$email}" />
<div id="error_email{$id}"></div>
</div>
</div>

<div class="row">
<div class="caption">&labelPhone;</div>
<div class="field">
<input type="text" size="70" name="phone" value="{$phone}"/>
</div>
</div>
</xsl:if>

<div class="row">
<div class="caption">&labelSubject;</div>
<div class="field">
<input type="text" size="70" name="subject" value="{$subject}"/>
</div>
</div>

<div class="row">
<div class="caption">&labelReview;</div>
<div class="field">
<textarea name="text" cols="68" rows="5" class="mceEditor"><xsl:value-of select="$text"/></textarea>
</div>
</div>

<!-- Внешние параметры -->
<xsl:if test="count(/shop/comment_properties/property[type != 10])">
<xsl:apply-templates select="/shop/comment_properties/property[type != 10]"/>
</xsl:if>

<div class="row">
<div class="caption">&labelGrade;</div>
<div class="field stars">
<select name="grade">
<option value="1">Poor</option>
<option value="2">Fair</option>
<option value="3">Average</option>
<option value="4">Good</option>
<option value="5">Excellent</option>
</select>
</div>
</div>

<!-- Showing captcha -->
<xsl:if test="//captcha_id != 0 and /shop/siteuser_id = 0">
<div class="row">
<div class="caption"></div>
<div class="field">
<img id="comment_{$id}" class="captcha" src="/captcha.php?id={//captcha_id}{$id}&amp;height=30&amp;width=100" title="&labelCaptchaId;" name="captcha"/>

<div class="captcha">
<img src="/images/refresh.png" /> <span onclick="$('#comment_{$id}').updateCaptcha('{//captcha_id}{$id}', 30); return false">&labelUpdateCaptcha;</span>
</div>
</div>
</div>

<div class="row">
<div class="caption">
&labelCaptchaId;<sup><font color="red">*</font></sup>
</div>
<div class="field">
<input type="hidden" name="captcha_id" value="{//captcha_id}{$id}"/>
<input type="text" name="captcha" size="15"/>
</div>
</div>
</xsl:if>

<xsl:if test="$id != 0">
<input type="hidden" name="parent_id" value="{$id}"/>
</xsl:if>

<div class="row">
<div class="caption"></div>
<div class="field">
<input id="submit_email{$id}" type="submit" name="add_comment" value="&labelPublish;" class="button" />
</div>
</div>
</form>
</div>
</xsl:template>

<!-- Внешние свойства -->
<xsl:template match="comment_properties/property">
<xsl:if test="type != 10">
<xsl:variable name="name">property_<xsl:value-of select="@id" /></xsl:variable>
<xsl:variable name="value"></xsl:variable>

<!-- form-group или checkbox -->
<xsl:choose>
<!-- Флажок -->
<xsl:when test="type = 7">
<div class="checkbox">
<label>
<input type="checkbox" name="{$name}" class="property-row"/>
<xsl:value-of select="name" />
</label>
</div>
</xsl:when>
<!-- Остальные поля -->
<xsl:otherwise>
<div class="row">
<div class="caption"><xsl:value-of select="name" /></div>
<div class="field">
<div class="input-group full-width">
<xsl:choose>
<!-- Отображаем поле ввода -->
<xsl:when test="type = 0 or type = 1">
<input type="text" name="{$name}" value="" class="form-control property-row" />
</xsl:when>
<!-- Отображаем файл -->
<xsl:when test="type = 2">
<label for="file-upload-{position()}" class="custom-file-upload form-control">
	<input id="file-upload-{position()}" class="property-row" type="file" name="{$name}"/>
</label>
</xsl:when>
<!-- Отображаем список -->
<xsl:when test="type = 3">
<select name="{$name}" class="form-control property-row">
	<option value="0">...</option>
	<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
<!-- Большое текстовое поле, Визуальный редактор -->
<xsl:when test="type = 4 or type = 6">
<textarea name="{$name}" class="form-control property-row"></textarea>
</xsl:when>
</xsl:choose>
</div>
</div>
</div>
</xsl:otherwise>
</xsl:choose>
</xsl:if>
</xsl:template>

<xsl:template match="list/list_item">
<!-- Отображаем список -->
<xsl:variable name="id" select="../../@id" />
<option value="{@id}">
<xsl:if test="/comment/property_value[property_id=$id]/value = value"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
<xsl:value-of disable-output-escaping="yes" select="value"/>
</option>
</xsl:template>

<!-- Шаблон для скидки -->
<xsl:template match="shop_discount">
<div class="shop_discount">
<xsl:value-of select="name"/><xsl:text> </xsl:text>
<span>
<xsl:choose>
<xsl:when test="type = 0">
<xsl:value-of select="percent"/>%
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="amount"/><xsl:text> </xsl:text><xsl:value-of select="/shop/shop_currency/sign"/>
</xsl:otherwise>
</xsl:choose>
</span>
</div>
</xsl:template>

<!-- Шаблон выводит хлебные крошки -->
<xsl:template match="shop_group" mode="breadCrumbs">
<xsl:variable name="parent_id" select="parent_id"/>

<!-- Call recursively parent group -->
<xsl:apply-templates select="ancestor::shop_group[@id=$parent_id]" mode="breadCrumbs"/>

<xsl:if test="parent_id=0">
<li itemscope="" itemprop="itemListElement" itemtype="https://schema.org/ListItem">
<a href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop" itemprop="item" title="{name}">
<span itemprop="name"><xsl:value-of select="/shop/name"/></span>
</a>
<meta itemprop="position" content="{position()}" />
</li>
</xsl:if>
<xsl:if test="parent_id=0">
<li itemscope="" itemprop="itemListElement" itemtype="https://schema.org/ListItem">
<a href="{/shop/url}" hostcms:id="{/shop/@id}" hostcms:field="name" hostcms:entity="shop" itemprop="item" title="{name}">
<span itemprop="name"><xsl:value-of select="/shop/name"/></span>
</a>
<meta itemprop="position" content="{position()}" />
</li>
</xsl:if>

<!--span><xsl:text> → </xsl:text></span-->

<li><a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group">
<xsl:value-of select="name"/>
</a></li>
</xsl:template>

<!-- Declension of the numerals -->
<xsl:template name="declension">

<xsl:param name="number" select="number"/>

<!-- Nominative case / Именительный падеж -->
<xsl:variable name="nominative"><xsl:text>&labelNominative;</xsl:text></xsl:variable>

<!-- Genitive singular / Родительный падеж, единственное число -->
<xsl:variable name="genitive_singular"><xsl:text>&labelGenitiveSingular;</xsl:text></xsl:variable>

<xsl:variable name="genitive_plural"><xsl:text>&labelGenitivePlural;</xsl:text></xsl:variable>
<xsl:variable name="last_digit"><xsl:value-of select="$number mod 10"/></xsl:variable>
<xsl:variable name="last_two_digits"><xsl:value-of select="$number mod 100"/></xsl:variable>

<xsl:choose>
<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
<xsl:value-of select="$nominative"/>
</xsl:when>
<xsl:when test="$last_digit = 2 and $last_two_digits != 12
or $last_digit = 3 and $last_two_digits != 13
or $last_digit = 4 and $last_two_digits != 14">
<xsl:value-of select="$genitive_singular"/>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$genitive_plural"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="shop_currency/code">
<xsl:param name="value" />

<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

<xsl:choose>
<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'RUB'"> <xsl:value-of select="$spaced"/><xsl:text> </xsl:text>₽</xsl:when>
<xsl:when test=". = 'RUR'"> <xsl:value-of select="$spaced"/><xsl:text> </xsl:text>₽</xsl:when>
<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
