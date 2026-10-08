<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://251">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">

	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		encoding="utf-8"
		indent="yes"
		method="html"
		omit-xml-declaration="no"
		version="1.0"
	media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<xsl:template match="shop">
		<xsl:variable name="group" select="group"/>

		<xsl:variable name="pageTitle">
			<xsl:choose>
				<xsl:when test="shop_filter_seo/node() and shop_filter_seo/h1 != ''">
					<xsl:value-of select="shop_filter_seo/h1"/>
				</xsl:when>
				<xsl:when test="$group = 0">
					<xsl:value-of select="name"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select=".//shop_group[@id=$group]/name" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="form_tag_url">
			<xsl:if test="count(tag) = 1">tag/<xsl:value-of select="tag/urlencode"/>/</xsl:if>
		</xsl:variable>

		<xsl:variable name="path">
			<xsl:choose>
				<xsl:when test="/shop//shop_group[@id=$group]/node()">
					<xsl:value-of select="/shop//shop_group[@id=$group]/url"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="/shop/url"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<section class="catalog-hero grid-blueprint">
			<div class="container">
				<div>
					<xsl:attribute name="class">
						<xsl:text>grid-blueprint__grid</xsl:text>
						<xsl:if test="not(contains(/shop/url, '/septiki/'))">
							<xsl:text> grid-blueprint__grid--single</xsl:text>
						</xsl:if>
					</xsl:attribute>
					<xsl:choose>
						<xsl:when test="$group = 0">
							<div class="grid-blueprint__content catalog-hero__content">
								<span class="badge"><xsl:choose><xsl:when test="/shop/@id = 6">Сервис септиков</xsl:when><xsl:otherwise>Инженерный каталог</xsl:otherwise></xsl:choose></span>

								<h1 class="catalog-hero__title">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($pageTitle)) &gt; 0">
											<xsl:value-of select="$pageTitle"/>
										</xsl:when>
										<xsl:otherwise>Септики для дома и дачи</xsl:otherwise>
									</xsl:choose>
								</h1>

								<p class="catalog-hero__text"><xsl:choose><xsl:when test="/shop/@id = 6">Выберите город обслуживания и оставьте заявку. Инженер уточнит модель септика, его состояние и необходимые работы.</xsl:when><xsl:otherwise>Подберите станцию по количеству проживающих, режиму использования и способу сброса. Вместо длинного списка моделей сразу показываем подходящие варианты и понятный следующий шаг.</xsl:otherwise></xsl:choose></p>

								<div class="stats-strip catalog-hero__stats" aria-label="Ключевые факты каталога">
									<div class="stats-strip__item">
										<strong><xsl:value-of select="total"/></strong>
										<span><xsl:choose><xsl:when test="/shop/@id = 6">районов обслуживания</xsl:when><xsl:otherwise>моделей в каталоге</xsl:otherwise></xsl:choose></span>
									</div>
									<div class="stats-strip__item">
										<strong><xsl:choose><xsl:when test="/shop/@id = 6">Сервис</xsl:when><xsl:otherwise>3 шага</xsl:otherwise></xsl:choose></strong>
										<span><xsl:choose><xsl:when test="/shop/@id = 6">обслуживание и ремонт</xsl:when><xsl:otherwise>до подходящей модели</xsl:otherwise></xsl:choose></span>
									</div>
									<div class="stats-strip__item">
										<strong><xsl:choose><xsl:when test="/shop/@id = 6">Смета</xsl:when><xsl:otherwise>1-2 дня</xsl:otherwise></xsl:choose></strong>
										<span><xsl:choose><xsl:when test="/shop/@id = 6">по вашей заявке</xsl:when><xsl:otherwise>типовой монтаж</xsl:otherwise></xsl:choose></span>
									</div>
								</div>

								<div class="hero-actions">
									<a class="btn btn--primary" href="#catalog-products"><xsl:choose><xsl:when test="/shop/@id = 6">Выбрать город обслуживания</xsl:when><xsl:otherwise>Смотреть подходящие модели</xsl:otherwise></xsl:choose></a>
									<button class="btn btn--secondary js-btn-callback" type="button"><xsl:choose><xsl:when test="/shop/@id = 6">Обсудить обслуживание</xsl:when><xsl:otherwise>Получить подбор инженера</xsl:otherwise></xsl:choose></button>
								</div>
							</div>
							<xsl:if test="contains(/shop/url, '/septiki/')">
								<aside class="grid-blueprint__aside">
									<form class="catalog-selector" action="{$path}" method="get">
										<input type="hidden" name="filter" value="1"/>

										<div class="catalog-selector__header">
											<span class="badge badge--outline">Подбор за 30 секунд</span>
											<h2 class="catalog-selector__title">Ответьте на 3 вопроса</h2>
											<p class="catalog-selector__text">Покажем модели, которые подходят под участок, без лишних технических терминов.</p>
										</div>

										<fieldset class="catalog-selector__group">
											<legend class="catalog-selector__legend">Сколько человек?</legend>
											<xsl:call-template name="peopleRangeOptions"/>
										</fieldset>

										<fieldset class="catalog-selector__group">
											<legend class="catalog-selector__legend">Как живете?</legend>
											<xsl:call-template name="exclusivePropertyOptions">
												<xsl:with-param name="radioName" select="'usage_type'"/>
												<xsl:with-param name="primaryName" select="'property_10'"/>
												<xsl:with-param name="primaryLabel" select="'Дача'"/>
												<xsl:with-param name="secondaryName" select="'property_11'"/>
												<xsl:with-param name="secondaryLabel" select="'Постоянно'"/>
												<xsl:with-param name="layoutClass" select="'catalog-selector__options catalog-selector__options--2'"/>
												<xsl:with-param name="showAny" select="0"/>
											</xsl:call-template>
										</fieldset>

										<fieldset class="catalog-selector__group">
											<legend class="catalog-selector__legend">Куда отводить воду?</legend>
											<xsl:call-template name="drainTypeOptions">
												<xsl:with-param name="showAny" select="0"/>
											</xsl:call-template>
										</fieldset>

										<button class="btn btn--primary btn--full" type="submit">Показать подходящие модели</button>
										<p class="catalog-selector__hint">Если ответ неизвестен, инженер уточнит его по адресу и уклону участка.</p>
									</form>
								</aside>
							</xsl:if>
						</xsl:when>

						<xsl:otherwise>
							<div class="grid-blueprint__content">
								<span class="badge">Каталог производителя</span>

								<h1 class="catalog-hero__title">
									<xsl:choose>
										<xsl:when test="string-length(normalize-space($pageTitle)) &gt; 0">
											<xsl:value-of select="$pageTitle"/>
										</xsl:when>
										<xsl:otherwise>
											<xsl:value-of select=".//shop_group[@id=$group]/name"/>
										</xsl:otherwise>
									</xsl:choose>
								</h1>

								<p class="section-title-block__desc">
									<xsl:text>Септики </xsl:text>
									<xsl:value-of select=".//shop_group[@id=$group]/name"/>
									<xsl:text> для дома и дачи с монтажом под ключ в Зеленограде и Московской области.</xsl:text>
								</p>
							</div>
						</xsl:otherwise>
					</xsl:choose>

				</div>
			</div>
		</section>

		<section class="catalog-scenario-bar">
			<div class="container">
				<select class="catalog-toolbar__sort" aria-label="Раздел каталога" onchange="if (this.value) window.location.href = this.value;">
					<option value="{/shop/url}">
						<xsl:if test="$group = 0 and count(tag) = 0 and count(shop_producer) = 0">
							<xsl:attribute name="selected">selected</xsl:attribute>
						</xsl:if>
						<xsl:text>Все модели</xsl:text>
					</option>

					<xsl:apply-templates select="/shop/catalog_groups/shop_group" mode="scenarioSelect"/>
				</select>

				<div class="catalog-tabs" aria-label="Быстрые сценарии выбора">
					<a href="{/shop/url}">
						<xsl:attribute name="class">
							<xsl:text>catalog-tab</xsl:text>
							<xsl:if test="$group = 0 and count(tag) = 0 and count(shop_producer) = 0"> catalog-tab--active</xsl:if>
						</xsl:attribute>
						<xsl:text>Все модели</xsl:text>
					</a>

					<!--xsl:apply-templates select=".//shop_group[parent_id=0]" mode="scenarioTabs"/-->
					<xsl:apply-templates select="/shop/catalog_groups/shop_group" mode="scenarioTabs"/>
				</div>
			</div>
		</section>

		<xsl:if test="count(tag)">
			<section class="section section--compact section--primary">
				<div class="container">
					<div class="catalog-advice">
						<div class="catalog-advice__body">
							<div class="catalog-advice__icon-box">#</div>
							<div>
								<div class="catalog-advice__title">Метка: <xsl:value-of select="tag/name"/></div>
								<xsl:if test="tag/description != ''">
									<div class="catalog-advice__desc">
										<xsl:value-of select="tag/description" disable-output-escaping="yes"/>
									</div>
								</xsl:if>
							</div>
						</div>
					</div>
				</div>
			</section>
		</xsl:if>

		<section class="section" id="catalog-products">
			<form class="section catalog-page-main" action="{$path}{$form_tag_url}" method="get">
				<input type="hidden" name="filter" value="1"/>
				<div class="container">
					<div>
						<xsl:attribute name="class">
							<xsl:text>catalog</xsl:text>
							<xsl:if test="not(contains(/shop/url, '/septiki/')) or not(count(/shop/shop_filter_seos/shop_filter_seo[active = 1]) &gt; 0)">
								<xsl:text> catalog--single</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:if test="@id = 1 and contains(/shop/url, '/septiki/')">
							<aside class="catalog__sidebar" aria-label="Фильтры каталога">
								<div class="catalog-filter">
									<div class="catalog-filter__header">
										<h2 class="catalog-filter__title">Подбор септика</h2>
										<a class="catalog-filter__reset" href="{$path}{$form_tag_url}">Сбросить</a>
									</div>

									<xsl:if test="count(/shop/shop_filter_seos/shop_filter_seo[active = 1]) &gt; 0">
										<nav class="catalog-seo-filter" aria-label="Популярные варианты подбора">
											<xsl:call-template name="seoSidebarGroup">
												<xsl:with-param name="title" select="'Количество человек'"/>
												<xsl:with-param name="modifier" select="'people'"/>
												<xsl:with-param name="items" select="/shop/shop_filter_seos/shop_filter_seo[active = 1 and shop_filter_seo_property/property_id = 6]"/>
											</xsl:call-template>
										</nav>
									</xsl:if>

<div class="catalog-filter__advanced-body">
<div class="catalog-filter__group">
<span class="catalog-filter__group-title">Режим проживания</span>
<div data-exclusive-filter="">
<input type="hidden" name="property_10" value="1" data-exclusive-filter-input="property_10"><xsl:if test="not(/shop/property_10 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if></input>
<input type="hidden" name="property_11" value="1" data-exclusive-filter-input="property_11"><xsl:if test="not(/shop/property_11 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if></input>
<select class="catalog-filter__select" aria-label="Режим проживания" data-exclusive-filter-select="">
<option value="">Любой</option>
<option value="property_10"><xsl:if test="/shop/property_10 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Для дачи</option>
<option value="property_11"><xsl:if test="/shop/property_11 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Для дома</option>
</select>
</div>
</div>
<div class="catalog-filter__group">
<span class="catalog-filter__group-title">Исполнение</span>
<div data-exclusive-filter="">
<input type="hidden" name="property_39" value="1" data-exclusive-filter-input="property_39"><xsl:if test="not(/shop/property_39 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if></input>
<input type="hidden" name="property_40" value="1" data-exclusive-filter-input="property_40"><xsl:if test="not(/shop/property_40 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if></input>
<select class="catalog-filter__select" aria-label="Исполнение" data-exclusive-filter-select="">
<option value="">Любое</option>
<option value="property_39"><xsl:if test="/shop/property_39 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Long</option>
<option value="property_40"><xsl:if test="/shop/property_40 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Миди</option>
</select>
</div>
</div>
  <div class="catalog-filter__group">
    <span class="catalog-filter__group-title">Цена, ₽</span>
    <div class="catalog-filter__price-grid">
      <input class="catalog-filter__input" name="price_from" type="number" min="0" step="1" placeholder="от" aria-label="Цена от, рублей">
        <xsl:if test="/shop/price_from &gt; 0"><xsl:attribute name="value"><xsl:value-of select="/shop/price_from"/></xsl:attribute></xsl:if>
      </input>
      <input class="catalog-filter__input" name="price_to" type="number" min="0" step="1" placeholder="до" aria-label="Цена до, рублей">
        <xsl:if test="/shop/price_to &gt; 0"><xsl:attribute name="value"><xsl:value-of select="/shop/price_to"/></xsl:attribute></xsl:if>
      </input>
    </div>
  </div>
  <xsl:apply-templates select="shop_item_properties//property[@id = 5 or @id = 4]" mode="catalogRangeFilter">
    <xsl:sort select="@id" data-type="number" order="descending"/>
  </xsl:apply-templates>
  <xsl:if test="count(shop_item_properties//property[@id = 2 or @id = 3])">
    <div class="catalog-filter__group">
      <span class="catalog-filter__group-title">Тип сброса</span>
      <div data-exclusive-filter="">
        <input type="hidden" name="property_3" value="1" data-exclusive-filter-input="property_3">
          <xsl:if test="not(/shop/property_3 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
        </input>
        <input type="hidden" name="property_2" value="1" data-exclusive-filter-input="property_2">
          <xsl:if test="not(/shop/property_2 != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
        </input>
        <select class="catalog-filter__select" aria-label="Тип сброса" data-exclusive-filter-select="">
          <option value="">Любой</option>
          <option value="property_3"><xsl:if test="/shop/property_3 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Самотечный</option>
          <option value="property_2"><xsl:if test="/shop/property_2 != ''"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>Принудительный</option>
        </select>
      </div>
    </div>
  </xsl:if>
  <button class="catalog-filter__submit" type="submit">Применить фильтры</button>
</div>

									<!-- Точная настройка временно отключена. Заменить false() на true() для возврата. -->
									<xsl:if test="false()">
										<details class="catalog-filter__advanced">
											<xsl:if test="not(count(/shop/shop_filter_seos/shop_filter_seo[active = 1]) &gt; 0) or /shop/filter = 1">
												<xsl:attribute name="open">open</xsl:attribute>
											</xsl:if>
											<summary class="catalog-filter__advanced-summary">Точная настройка</summary>
											<div class="catalog-filter__advanced-body">

												<xsl:if test="count(producers/shop_producer) &gt; 0">
													<div class="catalog-filter__group">
														<span class="catalog-filter__group-title">Производитель</span>
														<div class="catalog-filter__options">
															<xsl:apply-templates select="producers/shop_producer" mode="producerFilter"/>
														</div>
													</div>
												</xsl:if>

												<div class="catalog-filter__group">
													<span class="catalog-filter__group-title">Цена</span>
													<div class="catalog-filter__price-grid">
														<input class="catalog-filter__input" name="price_from" type="number" placeholder="от">
															<xsl:if test="/shop/price_from != 0">
																<xsl:attribute name="value"><xsl:value-of select="/shop/price_from"/></xsl:attribute>
															</xsl:if>
														</input>
														<input class="catalog-filter__input" name="price_to" type="number" placeholder="до">
															<xsl:if test="/shop/price_to != 0">
																<xsl:attribute name="value"><xsl:value-of select="/shop/price_to"/></xsl:attribute>
															</xsl:if>
														</input>
													</div>
												</div>

												<xsl:if test="count(shop_item_properties//property[@id = 6])">
													<div class="catalog-filter__group">
														<span class="catalog-filter__group-title">Количество человек</span>
														<xsl:call-template name="peopleRangeOptions">
															<xsl:with-param name="layoutClass" select="'catalog-filter__options'"/>
															<xsl:with-param name="showAny" select="1"/>
														</xsl:call-template>
													</div>
												</xsl:if>

												<xsl:if test="count(shop_item_properties//property[@id = 10 or @id = 11])">
													<div class="catalog-filter__group">
														<span class="catalog-filter__group-title">Режим эксплуатации</span>
														<xsl:call-template name="exclusivePropertyOptions">
															<xsl:with-param name="radioName" select="'usage_type'"/>
															<xsl:with-param name="primaryName" select="'property_10'"/>
															<xsl:with-param name="primaryLabel" select="'Для дачи'"/>
															<xsl:with-param name="secondaryName" select="'property_11'"/>
															<xsl:with-param name="secondaryLabel" select="'Для частного дома'"/>
															<xsl:with-param name="layoutClass" select="'catalog-filter__options'"/>
														</xsl:call-template>
													</div>
												</xsl:if>

												<xsl:if test="count(shop_item_properties//property[@id = 2 or @id = 3])">
													<div class="catalog-filter__group">
														<span class="catalog-filter__group-title">Тип сброса</span>
														<xsl:call-template name="drainTypeOptions">
															<xsl:with-param name="layoutClass" select="'catalog-filter__options'"/>
														</xsl:call-template>
													</div>
												</xsl:if>

												<xsl:if test="count(shop_item_properties//property[@id = 39 or @id = 40])">
													<div class="catalog-filter__group">
														<span class="catalog-filter__group-title">Исполнение</span>
														<xsl:call-template name="exclusivePropertyOptions">
															<xsl:with-param name="radioName" select="'body_type'"/>
															<xsl:with-param name="primaryName" select="'property_40'"/>
															<xsl:with-param name="primaryLabel" select="'Миди'"/>
															<xsl:with-param name="secondaryName" select="'property_39'"/>
															<xsl:with-param name="secondaryLabel" select="'Long'"/>
															<xsl:with-param name="anyLabel" select="'Любое'"/>
															<xsl:with-param name="layoutClass" select="'catalog-filter__options'"/>
														</xsl:call-template>
													</div>
												</xsl:if>

												<xsl:if test="count(shop_item_properties//property[filter != 0 and not(@id = 2 or @id = 3 or @id = 6 or @id = 10 or @id = 11 or @id = 39 or @id = 40)])">
													<xsl:apply-templates select="shop_item_properties//property[filter != 0 and not(@id = 2 or @id = 3 or @id = 6 or @id = 10 or @id = 11 or @id = 39 or @id = 40)]" mode="catalogFilter"/>
												</xsl:if>

												<button class="catalog-filter__submit" type="submit">Применить фильтры</button>
											</div>
										</details>
									</xsl:if>
								</div>
							</aside>
						</xsl:if>

						<div class="catalog__content">
							<div class="catalog-toolbar">
								<div>
									<h2 class="catalog-toolbar__title">
										<xsl:choose>
											<xsl:when test="$group != 0">
												<xsl:value-of select=".//shop_group[@id=$group]/name"/>
											</xsl:when>
											<xsl:when test="/shop/@id = 6">Обслуживание по городам</xsl:when>
											<xsl:when test="contains(/shop/url, '/kessony/')">Все модели кессонов</xsl:when>
											<xsl:when test="contains(/shop/url, '/pogreba/')">Все модели погребов</xsl:when>
											<xsl:otherwise>Все модели септиков</xsl:otherwise>
										</xsl:choose>
									</h2>
									<div class="catalog-toolbar__count">
										<xsl:text>Найдено </xsl:text>
										<xsl:value-of select="total"/>
										<xsl:text> </xsl:text>
										<xsl:choose>
											<xsl:when test="/shop/@id = 6">вариантов обслуживания</xsl:when><xsl:when test="total = 1">модель</xsl:when>
											<xsl:otherwise>моделей</xsl:otherwise>
										</xsl:choose>
									</div>
								</div>

								<select class="catalog-toolbar__sort" name="sorting" aria-label="Сортировка каталога" onchange="this.form.submit()">
									<option value="0">Сначала популярные</option>
									<option value="1">
										<xsl:if test="/shop/sorting = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										Сначала дешевле
									</option>
									<option value="2">
										<xsl:if test="/shop/sorting = 2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										Сначала дороже
									</option>
									<option value="3">
										<xsl:if test="/shop/sorting = 3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
										По названию
									</option>
								</select>
							</div>

							<div class="catalog__products">
								<xsl:apply-templates select="shop_item"/>
							</div>

							<xsl:if test="not(count(shop_item) &gt; 0)">
								<div class="catalog-empty">
									<div class="catalog-empty__title">Подходящие модели не найдены</div>
									<div class="catalog-empty__desc">Сбросьте фильтры или запросите подбор инженером.</div>
									<a class="catalog-empty__btn" href="{$path}{$form_tag_url}">Сбросить фильтры</a>
								</div>
							</xsl:if>

							<xsl:if test="total &gt; 0 and limit &gt; 0">
								<div class="catalog-pagination pagination">
									<xsl:call-template name="pagination"/>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</form>
		</section>

		<xsl:if test="count(/shop/comparing/shop_item) &gt; 0">
			<div class="compare-tray compare-tray--active">
				<div class="compare-tray__bar">
					<div class="compare-tray__info">
						<div class="compare-tray__icon-box">≡</div>
						<div>
							<span class="compare-tray__title">Выбрано моделей для сравнения</span>
							<span class="compare-tray__desc">Сравните характеристики и стоимость монтажа</span>
						</div>
					</div>

					<div class="compare-tray__list">
						<xsl:apply-templates select="/shop/comparing/shop_item" mode="compareTrayItem"/>
					</div>

					<div class="compare-tray__actions">
						<a class="compare-tray__btn-submit" href="{/shop/url}compare_items/">Сравнить характеристики</a>
					</div>
				</div>
			</div>
		</xsl:if>

		<!-- Existing Shop_Group.description, only on its first unfiltered catalog page. -->
		<xsl:if test="@id = 1 and group != 0 and (not(page) or page = 0) and not(tag) and not(shop_producer) and not(shop_filter_seo) and not(filter = 1)">
			<xsl:for-each select="(.//shop_group[@id = /shop/group])[1]">
				<xsl:if test="normalize-space(description) != ''">
					<section class="section area-text no-bg" data-seo-landing="catalog-group">
						<div class="container">
							<div class="legal-page__content" hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop_group" hostcms:type="wysiwyg">
								<xsl:value-of select="description" disable-output-escaping="yes"/>
							</div>
						</div>
					</section>
				</xsl:if>
			</xsl:for-each>
		</xsl:if>

		<!-- Native SEO-filter text, first page only (HostCMS SEO-filter documentation). -->
		<xsl:if test="@id = 1 and shop_filter_seo/node() and (not(page) or page = 0) and normalize-space(shop_filter_seo/text) != ''">
			<section class="section area-text no-bg" data-seo-landing="catalog-filter">
				<div class="container">
					<div class="legal-page__content">
						<xsl:value-of select="shop_filter_seo/text" disable-output-escaping="yes"/>
					</div>
				</div>
			</section>
		</xsl:if>

		<!-- Native shop description belongs only to the first unfiltered root page. -->
		<xsl:if test="landing_description = 1 and (@id = 1 or @id = 6) and group = 0 and (not(page) or page = 0) and not(tag) and not(shop_producer) and not(shop_filter_seo) and not(filter = 1) and normalize-space(description) != ''">
			<div hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop" hostcms:type="wysiwyg">
				<xsl:value-of select="description" disable-output-escaping="yes"/>
			</div>
		</xsl:if>

		<section class="catalog-advice-section">
			<div class="container">
				<div class="catalog-advice">
					<div class="catalog-advice__body">
						<div class="catalog-advice__icon-box">?</div>
						<div>
							<div class="catalog-advice__title">Не уверены, какой септик подойдёт?</div>
							<div class="catalog-advice__desc">Инженер подберёт модель под грунт, количество жильцов и тип сброса.</div>
						</div>
					</div>
					<button class="catalog-advice__btn js-open-modal" type="button">Получить подбор</button>
				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template name="seoSidebarGroup">
		<xsl:param name="title"/>
		<xsl:param name="modifier"/>
		<xsl:param name="items"/>

		<xsl:if test="count($items) &gt; 0">
			<div class="catalog-seo-filter__group catalog-seo-filter__group--{$modifier}">
				<span class="catalog-seo-filter__title"><xsl:value-of select="$title"/></span>
				<div class="catalog-seo-filter__links">
					<xsl:choose>
						<xsl:when test="$modifier = 'people'">
							<xsl:apply-templates select="$items" mode="seoSidebarLink">
								<xsl:sort select="number(shop_filter_seo_property[property_id = 6]/value)" data-type="number" order="ascending"/>
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="$items" mode="seoSidebarLink"/>
						</xsl:otherwise>
					</xsl:choose>
				</div>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_filter_seo" mode="seoSidebarLink">
		<xsl:variable name="currentLink" select="substring-before(concat(/shop/link, '?'), '?')"/>

		<a href="{url}#catalog-products">
			<xsl:attribute name="class">
				<xsl:text>catalog-seo-filter__link</xsl:text>
				<xsl:if test="/shop/shop_filter_seo/@id = @id or $currentLink = url">
					<xsl:text> catalog-seo-filter__link--active</xsl:text>
				</xsl:if>
			</xsl:attribute>
			<xsl:if test="/shop/shop_filter_seo/@id = @id or $currentLink = url">
				<xsl:attribute name="aria-current">page</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="shop_filter_seo_property/property_id = 6 and normalize-space(shop_filter_seo_property[property_id = 6]/value) != ''">
					<xsl:value-of select="shop_filter_seo_property[property_id = 6]/value"/>
				</xsl:when>
				<xsl:when test="shop_filter_seo_property/property_id = 10">Для дачи</xsl:when>
				<xsl:when test="shop_filter_seo_property/property_id = 11">Для дома</xsl:when>
				<xsl:when test="shop_filter_seo_property/property_id = 3">Самотечный</xsl:when>
				<xsl:when test="shop_filter_seo_property/property_id = 2">Принудительный</xsl:when>
				<xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template match="shop_item">
		<article class="catalog-card" itemscope="" itemtype="http://schema.org/Product">

			<div class="catalog-card__badges-row">
				<xsl:choose>
					<xsl:when test="property_value[tag_name='best']/value = 1">
						<span class="catalog-card__badge">Выбор инженеров</span>
					</xsl:when>
					<xsl:when test="property_value[tag_name='spec']/value = 1">
						<span class="catalog-card__badge">Новинка</span>
					</xsl:when>
					<xsl:when test="property_value[tag_name='sale']/value = 1">
						<span class="catalog-card__badge">Хит продаж</span>
					</xsl:when>
				</xsl:choose>
			</div>

			<div class="catalog-card__media">
				<xsl:choose>
					<xsl:when test="image_large != ''">
						<img class="catalog-card__img" src="{dir}{image_large}" decoding="async" loading="lazy" alt="{name}" />
						<meta itemprop="image" content="{dir}{image_large}" />
					</xsl:when>
					<xsl:otherwise>
						<img class="catalog-card__img" src="/images/no-image.png" alt="{name}" title="{name}" itemprop="image" decoding="async" loading="lazy"/>
					</xsl:otherwise>
				</xsl:choose>

				<xsl:if test="property_value[tag_name='men']/value != ''">
					<div class="catalog-card__capacity">
						<svg aria-hidden="true" fill="none" height="16" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewBox="0 0 24 24" width="16" xmlns="http://www.w3.org/2000/svg">
							<path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"></path>
							<path d="M16 3.128a4 4 0 0 1 0 7.744"></path>
							<path d="M22 21v-2a4 4 0 0 0-3-3.87"></path>
							<circle cx="9" cy="7" r="4"></circle>
						</svg>
						<span>до <xsl:value-of select="property_value[tag_name='men']/value"/> чел.</span>
					</div>
				</xsl:if>
			</div>

			<div class="catalog-card__body">
				<h3 class="catalog-card__title" itemprop="name">
					<xsl:value-of select="name"/>
				</h3>


				<xsl:if test="/shop/@id != 6"><div class="catalog-card__specs">
						<xsl:if test="property_value[tag_name='performance']/value != ''">
							<div class="catalog-card__spec-row">
								<span class="catalog-card__spec-label">Производительность:</span>
								<span class="catalog-card__spec-value">
									<xsl:value-of select="property_value[tag_name='performance']/value"/> л/сутки
								</span>
							</div>
						</xsl:if>

						<xsl:if test="property_value[tag_name='zalp']/value != '' and property_value[tag_name='zalp']/value != 0">
							<div class="catalog-card__spec-row">
								<span class="catalog-card__spec-label">Залповый сброс:</span>
								<span class="catalog-card__spec-value">
									<xsl:value-of select="property_value[tag_name='zalp']/value"/> л
								</span>
							</div>
						</xsl:if>

						<div class="catalog-card__spec-row">
							<span class="catalog-card__spec-label">Тип сброса:</span>
							<span class="catalog-card__spec-value">
								<xsl:choose>
									<xsl:when test="property_value[tag_name='nopr']/value = 1">Самотечный</xsl:when>
									<xsl:otherwise>Принудительный</xsl:otherwise>
								</xsl:choose>
							</span>
						</div>

						<div class="catalog-card__spec-row">
							<span class="catalog-card__spec-label">Очистка:</span>
							<span class="catalog-card__spec-value catalog-card__spec-value--highlight">до 98%</span>
						</div>
				</div></xsl:if>
			</div>

			<div class="catalog-card__footer">
				<div class="catalog-card__price-row">
					<span class="catalog-card__price-label">Цена от:</span>

					<div itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
						<xsl:choose>
							<xsl:when test="price = 0 or  price =''">
								<span class="catalog-card__price-actual">Под заказ</span>
							</xsl:when>

							<xsl:when test="discount != 0">
								<span class="catalog-card__price-original">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price + discount" />
									</xsl:apply-templates>
								</span>

								<span class="catalog-card__price-actual">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price" />
									</xsl:apply-templates>
								</span>

								<meta itemprop="price" content="{price}" />
								<meta itemprop="priceCurrency" content="RUB" />
								<link itemprop="availability" href="http://schema.org/InStock"/>
							</xsl:when>

							<xsl:otherwise>
								<span class="catalog-card__price-actual">
									<xsl:apply-templates select="/shop/shop_currency/code">
										<xsl:with-param name="value" select="price" />
									</xsl:apply-templates>
								</span>

								<meta itemprop="price" content="{price}" />
								<meta itemprop="priceCurrency" content="RUB" />
								<link itemprop="availability" href="http://schema.org/InStock"/>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>

				<div class="catalog-card__actions">
					<button class="btn btn--primary btn--full js-catalog-order" data-name="{name}" type="button"><xsl:attribute name="data-order-kind"><xsl:choose><xsl:when test="/shop/@id = 6">service</xsl:when><xsl:otherwise>installation</xsl:otherwise></xsl:choose></xsl:attribute>
						<xsl:choose><xsl:when test="/shop/@id = 6">Заказать обслуживание</xsl:when><xsl:otherwise>Заказать монтаж</xsl:otherwise></xsl:choose>
					</button>
					<a href="{url}" class="link link--muted link--center"><xsl:choose><xsl:when test="/shop/@id = 6">Подробнее об обслуживании</xsl:when><xsl:otherwise>Подробнее о модели</xsl:otherwise></xsl:choose></a>
				</div>
			</div>

		</article>
	</xsl:template>

	<xsl:template match="shop_group" mode="scenarioTabs">
		<a href="{url}">
			<xsl:attribute name="class">
				<xsl:text>catalog-tab</xsl:text>
				<xsl:if test="@id = /shop/group"> catalog-tab--active</xsl:if>
			</xsl:attribute>
			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

	<xsl:template match="shop_group" mode="scenarioSelect">
		<option value="{url}">
			<xsl:if test="@id = /shop/group">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of select="name"/>
		</option>
	</xsl:template>

	<xsl:template name="drainTypeOptions">
		<xsl:param name="layoutClass" select="'catalog-selector__options catalog-selector__options--3'"/>
		<xsl:param name="showAny" select="1"/>
		<xsl:call-template name="exclusivePropertyOptions">
			<xsl:with-param name="radioName" select="'drain_type'"/>
			<xsl:with-param name="primaryName" select="'property_3'"/>
			<xsl:with-param name="primaryLabel" select="'Самотечный'"/>
			<xsl:with-param name="secondaryName" select="'property_2'"/>
			<xsl:with-param name="secondaryLabel" select="'Принудительный'"/>
			<xsl:with-param name="layoutClass" select="$layoutClass"/>
			<xsl:with-param name="showAny" select="$showAny"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="exclusivePropertyOptions">
		<xsl:param name="radioName"/>
		<xsl:param name="primaryName"/>
		<xsl:param name="primaryLabel"/>
		<xsl:param name="secondaryName"/>
		<xsl:param name="secondaryLabel"/>
		<xsl:param name="anyLabel" select="'Любой'"/>
		<xsl:param name="layoutClass" select="'catalog-selector__options catalog-selector__options--3'"/>
		<xsl:param name="showAny" select="1"/>
		<xsl:variable name="primaryNode" select="/shop/*[name()=$primaryName]"/>
		<xsl:variable name="secondaryNode" select="/shop/*[name()=$secondaryName]"/>

		<div class="{$layoutClass}" data-exclusive-filter="" role="radiogroup">
			<input type="hidden" name="{$primaryName}" value="1" data-exclusive-filter-input="{$primaryName}">
				<xsl:if test="not($primaryNode != '')">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>
			<input type="hidden" name="{$secondaryName}" value="1" data-exclusive-filter-input="{$secondaryName}">
				<xsl:if test="not($secondaryNode != '')">
					<xsl:attribute name="disabled">disabled</xsl:attribute>
				</xsl:if>
			</input>

			<xsl:if test="$showAny = 1">
				<label class="catalog-selector__option">
					<input type="radio" name="{$radioName}" value="any" data-exclusive-filter-option="">
						<xsl:if test="not($primaryNode != '') and not($secondaryNode != '')">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</input>
					<span><xsl:value-of select="$anyLabel"/></span>
				</label>
			</xsl:if>
			<label class="catalog-selector__option">
				<input type="radio" name="{$radioName}" value="primary" data-exclusive-filter-option="{$primaryName}">
					<xsl:if test="$primaryNode != '' or ($showAny = 0 and not($secondaryNode != ''))">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<span><xsl:value-of select="$primaryLabel"/></span>
			</label>
			<label class="catalog-selector__option">
				<input type="radio" name="{$radioName}" value="secondary" data-exclusive-filter-option="{$secondaryName}">
					<xsl:if test="$secondaryNode != '' and not($primaryNode != '')">
						<xsl:attribute name="checked">checked</xsl:attribute>
					</xsl:if>
				</input>
				<span><xsl:value-of select="$secondaryLabel"/></span>
			</label>
		</div>
	</xsl:template>

	<xsl:template name="peopleRangeOptions">
		<xsl:param name="layoutClass" select="'catalog-selector__options'"/>
		<xsl:param name="showAny" select="0"/>
		<div class="{$layoutClass}" data-range-filter="" role="radiogroup" aria-label="Количество человек">
			<input type="hidden" name="property_6_from" data-range-filter-input="from" value="{/shop/property_6_from}">
				<xsl:if test="not(/shop/property_6_from != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
			</input>
			<input type="hidden" name="property_6_to" data-range-filter-input="to" value="{/shop/property_6_to}">
				<xsl:if test="not(/shop/property_6_to != '')"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
			</input>

			<xsl:if test="$showAny = 1">
				<label class="catalog-selector__option">
					<input type="radio" name="people_range" value="any" data-range-filter-option="" data-range-from="" data-range-to="">
						<xsl:if test="not(/shop/property_6_from != '') and not(/shop/property_6_to != '')"><xsl:attribute name="checked">checked</xsl:attribute></xsl:if>
					</input>
					<span>Любое</span>
				</label>
			</xsl:if>
			<xsl:call-template name="peopleRangeOption"><xsl:with-param name="from" select="'2'"/><xsl:with-param name="to" select="'3'"/><xsl:with-param name="label" select="'2-3'"/><xsl:with-param name="default" select="0"/></xsl:call-template>
			<xsl:call-template name="peopleRangeOption"><xsl:with-param name="from" select="'4'"/><xsl:with-param name="to" select="'5'"/><xsl:with-param name="label" select="'4-5'"/><xsl:with-param name="default" select="1 - $showAny"/></xsl:call-template>
			<xsl:call-template name="peopleRangeOption"><xsl:with-param name="from" select="'6'"/><xsl:with-param name="to" select="'8'"/><xsl:with-param name="label" select="'6-8'"/><xsl:with-param name="default" select="0"/></xsl:call-template>
			<xsl:call-template name="peopleRangeOption"><xsl:with-param name="from" select="'9'"/><xsl:with-param name="to" select="''"/><xsl:with-param name="label" select="'9+'"/><xsl:with-param name="default" select="0"/></xsl:call-template>
		</div>
	</xsl:template>

	<xsl:template name="peopleRangeOption">
		<xsl:param name="from"/>
		<xsl:param name="to"/>
		<xsl:param name="label"/>
		<xsl:param name="default" select="0"/>
		<label class="catalog-selector__option">
			<input type="radio" name="people_range" value="{$from}-{$to}" data-range-filter-option="" data-range-from="{$from}" data-range-to="{$to}">
				<xsl:if test="(/shop/property_6_from = $from and /shop/property_6_to = $to) or ($default = 1 and not(/shop/property_6_from != '') and not(/shop/property_6_to != ''))">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<span><xsl:value-of select="$label"/></span>
		</label>
	</xsl:template>

	<xsl:template match="producers/shop_producer" mode="producerFilter">
		<label class="catalog-filter__option">
			<input class="catalog-filter__checkbox" type="checkbox" name="producer_id" value="{@id}">
				<xsl:if test="/shop/shop_producer/@id = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<span><xsl:value-of select="name"/></span>
		</label>
	</xsl:template>


<!-- Native HostCMS numeric property ranges: existing properties 4 and 5. -->
<xsl:template match="property" mode="catalogRangeFilter">
  <xsl:variable name="from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
  <xsl:variable name="to">property_<xsl:value-of select="@id"/>_to</xsl:variable>
  <xsl:variable name="unit"><xsl:choose><xsl:when test="@id = 4">л/сутки</xsl:when><xsl:otherwise>л</xsl:otherwise></xsl:choose></xsl:variable>
  <div class="catalog-filter__group">
    <span class="catalog-filter__group-title"><xsl:value-of select="name"/>, <xsl:value-of select="$unit"/></span>
    <div class="catalog-filter__price-grid">
      <input class="catalog-filter__input" name="{$from}" type="number" min="0" step="any" placeholder="от" value="{/shop/*[name()=$from]}" aria-label="{name} от, {$unit}"/>
      <input class="catalog-filter__input" name="{$to}" type="number" min="0" step="any" placeholder="до" value="{/shop/*[name()=$to]}" aria-label="{name} до, {$unit}"/>
    </div>
  </div>
</xsl:template>

	<xsl:template match="property" mode="catalogFilter">
		<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
		<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
		<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

		<div class="catalog-filter__group">
			<span class="catalog-filter__group-title"><xsl:value-of select="name"/></span>

			<xsl:choose>
				<xsl:when test="filter = 1">
					<input class="catalog-filter__input" type="text" name="property_{@id}">
						<xsl:if test="/shop/*[name()=$nodename] != ''">
							<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
						</xsl:if>
					</input>
				</xsl:when>

				<xsl:when test="filter = 2">
					<select class="catalog-filter__select" name="property_{@id}">
						<option value="0">Все</option>
						<xsl:apply-templates select="list/list_item" mode="filterOption"/>
					</select>
				</xsl:when>

				<xsl:when test="filter = 3">
					<div class="catalog-filter__options">
						<label class="catalog-filter__option">
							<input class="catalog-filter__radio" type="radio" name="property_{@id}" value="0"/>
							<span>Любой вариант</span>
						</label>
						<xsl:apply-templates select="list/list_item" mode="filterRadio"/>
					</div>
				</xsl:when>

				<xsl:when test="filter = 4">
					<div class="catalog-filter__options">
						<xsl:apply-templates select="list/list_item" mode="filterCheckbox"/>
					</div>
				</xsl:when>

				<xsl:when test="filter = 5">
					<div class="catalog-filter__options">
						<label class="catalog-filter__option">
							<input class="catalog-filter__checkbox" type="checkbox" name="property_{@id}" id="property_{@id}">
								<xsl:if test="/shop/*[name()=$nodename] != ''">
									<xsl:attribute name="checked">checked</xsl:attribute>
								</xsl:if>
							</input>
							<span><xsl:value-of select="name"/></span>
						</label>
					</div>
				</xsl:when>

				<xsl:when test="filter = 6">
					<div class="catalog-filter__price-grid">
						<input class="catalog-filter__input" type="text" name="property_{@id}_from" placeholder="от" value="{/shop/*[name()=$nodename_from]}"/>
						<input class="catalog-filter__input" type="text" name="property_{@id}_to" placeholder="до" value="{/shop/*[name()=$nodename_to]}"/>
					</div>
				</xsl:when>

				<xsl:when test="filter = 7">
					<select class="catalog-filter__select" name="property_{@id}[]" multiple="multiple">
						<xsl:apply-templates select="list/list_item" mode="filterOption"/>
					</select>
				</xsl:when>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="list/list_item" mode="filterOption">
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<option value="{@id}">
			<xsl:if test="/shop/*[name()=$nodename] = @id">
				<xsl:attribute name="selected">selected</xsl:attribute>
			</xsl:if>
			<xsl:value-of disable-output-escaping="yes" select="value"/>
		</option>
	</xsl:template>

	<xsl:template match="list/list_item" mode="filterRadio">
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<label class="catalog-filter__option">
			<input class="catalog-filter__radio" type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<span><xsl:value-of disable-output-escaping="yes" select="value"/></span>
		</label>
	</xsl:template>

	<xsl:template match="list/list_item" mode="filterCheckbox">
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<label class="catalog-filter__option">
			<input class="catalog-filter__checkbox" type="checkbox" name="property_{../../@id}[]" value="{@id}" id="property_{../../@id}_{@id}">
				<xsl:if test="/shop/*[name()=$nodename] = @id">
					<xsl:attribute name="checked">checked</xsl:attribute>
				</xsl:if>
			</input>
			<span><xsl:value-of disable-output-escaping="yes" select="value"/></span>
		</label>
	</xsl:template>

	<xsl:template match="shop_item" mode="compareTrayItem">
		<div class="compare-tray__item">
			<span class="compare-tray__item-name"><xsl:value-of select="name"/></span>
			<button class="compare-tray__item-remove" onclick="return $.addCompare('{/shop/url}', {@id}, this)" type="button" aria-label="Удалить из сравнения">×</button>
		</div>
	</xsl:template>

	<xsl:template name="pagination">
		<xsl:variable name="count_pages" select="ceiling(total div limit)"/>
		<xsl:variable name="visible_pages" select="5"/>
		<xsl:variable name="real_visible_pages">
			<xsl:choose>
				<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="pre_count_page">
			<xsl:choose>
				<xsl:when test="page - (floor($real_visible_pages div 2)) &lt; 0">
					<xsl:value-of select="page"/>
				</xsl:when>
				<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
					<xsl:value-of select="$real_visible_pages - ($count_pages - page - 1) - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="floor($real_visible_pages div 2)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="post_count_page">
			<xsl:choose>
				<xsl:when test="0 &gt; page - (floor($real_visible_pages div 2) - 1)">
					<xsl:value-of select="$real_visible_pages - page - 1"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="i">
			<xsl:choose>
				<xsl:when test="page + 1 = $count_pages"><xsl:value-of select="page - $real_visible_pages + 1"/></xsl:when>
				<xsl:when test="page - $pre_count_page &gt; 0"><xsl:value-of select="page - $pre_count_page"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="for">
			<xsl:with-param name="limit" select="limit"/>
			<xsl:with-param name="page" select="page"/>
			<xsl:with-param name="items_count" select="total"/>
			<xsl:with-param name="i" select="$i"/>
			<xsl:with-param name="post_count_page" select="$post_count_page"/>
			<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
			<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="for">
		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="pre_count_page"/>
		<xsl:param name="post_count_page"/>
		<xsl:param name="i" select="0"/>
		<xsl:param name="items_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="ceiling($items_count div $limit)"/>

		<xsl:variable name="filter">
			<xsl:if test="/shop/filter_path/node() and /shop/filter_path != ''">
				<xsl:value-of select="/shop/filter_path"/>
			</xsl:if>
		</xsl:variable>

		<xsl:variable name="on_page">
			<xsl:if test="/shop/on_page/node() and /shop/on_page &gt; 0">
				<xsl:choose>
					<xsl:when test="/shop/filter_path/node()">&amp;</xsl:when>
					<xsl:otherwise>?</xsl:otherwise>
				</xsl:choose>
				<xsl:text>on_page=</xsl:text>
				<xsl:value-of select="/shop/on_page"/>
			</xsl:if>
		</xsl:variable>

		<xsl:if test="$items_count &gt; $limit and $i &lt; $n and $i &lt; ($page + $post_count_page + 1)">
			<xsl:variable name="group" select="/shop/group"/>
			<xsl:variable name="tag_path">
				<xsl:if test="count(/shop/tag) != 0">tag/<xsl:value-of select="/shop/tag/urlencode"/>/</xsl:if>
			</xsl:variable>

			<xsl:variable name="group_link">
				<xsl:choose>
					<xsl:when test="$group != 0"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:variable name="number_link">
				<xsl:if test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:if>
			</xsl:variable>

			<xsl:if test="$i != $page">
				<a href="{$group_link}{$filter}{$tag_path}{$number_link}{$on_page}" class="pagination__item">
					<xsl:value-of select="$i + 1"/>
				</a>
			</xsl:if>

			<xsl:if test="$i = $page">
				<span class="pagination__item pagination__item--active"><xsl:value-of select="$i + 1"/></span>
			</xsl:if>

			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="items_count" select="$items_count"/>
				<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
				<xsl:with-param name="post_count_page" select="$post_count_page"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="tag">
		<a href="{/shop/url}tag/{urlencode}/" class="tag">
			<xsl:value-of select="tag_name"/>
		</a>
		<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
	</xsl:template>
	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:value-of select="format-number($value, '### ### ###', 'my')" />
		<xsl:text> ₽</xsl:text>
	</xsl:template>
</xsl:stylesheet>