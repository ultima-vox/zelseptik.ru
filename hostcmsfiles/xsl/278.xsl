<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://55">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<xsl:variable name="n" select="number(3)"/>

	<xsl:template match="shop">

		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="group"/>





		<xsl:variable name="count">1</xsl:variable>
		<div class="reload_catalog " style="position: relative;">


			<div class="catalog-row fl-row regional-catalog-grid">
				<xsl:apply-templates select="shop_item" />
			</div>

		</div>

	</xsl:template>
	<!-- Шаблон для групп товара -->
	<xsl:template match="shop_item" mode="feachured">
		<xsl:if test="property_value[tag_name='pop']/value = 1">
			<xsl:for-each select="shop_item">
				<div class="shop_left_box wdt_100 mar_btm1">
					<h4>Рекомендуем: Септик <xsl:value-of select="name"/></h4>
					<div class="feature_pr_col"><img src="{dir}{image_large}" alt="{name}" />
						<!--xsl:choose>
						<xsl:when test="price = 0">
							<span class="feature_price_tag">
								<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
									Под заказ
							</a></span>

						</xsl:when>
						<xsl:when test="discount != 0">
							<span class="feature_price_tag">
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price" />
							</xsl:apply-templates></span>
							<span>	<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price + discount" />
							</xsl:apply-templates></span>
						</xsl:when>
						<xsl:otherwise>
							<span class="feature_price_tag">
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price" />
							</xsl:apply-templates></span>
						</xsl:otherwise>
					</xsl:choose-->
					<h5><a href="{url}" class="view-all hvr-bounce-to-right shop_add_cart">Посмотреть</a></h5>
				</div>
			</div>

		</xsl:for-each>
	</xsl:if>
</xsl:template>
<!-- Шаблон для товара -->
<xsl:template match="shop_item">
		<div class="col catalog__item"><article class="catalog-card" itemscope="" itemtype="http://schema.org/Product">

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
<xsl:when test="image_small != ''"><img class="catalog-card__img" src="{dir}{image_small}" alt="{name}" decoding="async" loading="lazy"/><meta itemprop="image" content="{dir}{image_small}"/></xsl:when>
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
					<a href="{url}"><xsl:value-of select="name"/></a>
				</h3>


				<div class="catalog-card__specs">
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

<div class="catalog-card__spec-row"><span class="catalog-card__spec-label">Модификация:</span><span class="catalog-card__spec-value"><xsl:choose><xsl:when test="property_value[tag_name='long']/value = 1">Лонг</xsl:when><xsl:when test="property_value[tag_name='midi']/value = 1">Миди</xsl:when><xsl:otherwise>Стандарт</xsl:otherwise></xsl:choose></span></div>
				</div>
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
					<button class="btn btn--primary btn--full js-catalog-order" data-name="{name}" type="button">
						Заказать монтаж
					</button>
					<a href="{url}" class="link link--muted link--center"><xsl:choose><xsl:when test="/shop/@id = 6">Подробнее об обслуживании</xsl:when><xsl:otherwise>Подробнее о модели</xsl:otherwise></xsl:choose></a>
				</div>
			</div>

		</article></div>
	</xsl:template>
<xsl:template match="shop_discount">
<xsl:value-of select="round(percent)"/>
</xsl:template>
<!-- Шаблон для групп товара -->
<xsl:template match="shop_group">

<xsl:for-each select=". | following-sibling::shop_group[position() &lt; $n]">
<div class="tabbing_col">
<h2 class="acc_trigger">
<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group"><xsl:value-of select="name"/></a><!--xsl:text> </xsl:text><span class="shop_count"><xsl:value-of select="items_total_count"/></span-->
</h2></div>
</xsl:for-each>

</xsl:template>

<xsl:template match="property">
<xsl:variable name="property_id" select="@id" />
<xsl:if test="/shop/shop_item/property_value[property_id = $property_id]/value/node() and /shop/shop_item/property_value[property_id = $property_id]/value != '' or /shop/shop_item/property_value[property_id = $property_id]/type != 2"> <div class="tabbing_col">

<h2 class="acc_trigger"><a href="#"><xsl:value-of disable-output-escaping="yes" select="name"/></a></h2>
<div class="acc_container">
<ul class="prd_cat_list">
<xsl:apply-templates select="/shop/shop_item/property_value[property_id = $property_id]" />
</ul>
</div>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="/shop/shop_item/property_value">
<xsl:variable name="property_id" select="property_id" />
<xsl:variable name="property" select="/shop/shop_item_properties//property[@id=$property_id]" />
<xsl:choose>
<xsl:when test="$property/type = 7">
<li><a href="#">- <input type="checkbox" disabled="disabled">
<xsl:if test="value = 1">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
</input></a></li>
</xsl:when>
<xsl:otherwise>
<li><a href="#">-  <xsl:value-of disable-output-escaping="yes" select="value"/></a></li>
</xsl:otherwise>
</xsl:choose>

</xsl:template>
<!-- Шаблон для фильтра по дополнительным свойствам -->
<xsl:template match="property" mode="propertyList">
<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

<div class="tabbing">

<xsl:if test="filter != 5">
<legend><xsl:value-of select="name"/><xsl:text> </xsl:text></legend>
</xsl:if>

<xsl:choose>
<!-- Отображаем поле ввода -->
<xsl:when test="filter = 1">
<br/>
<input type="text" name="property_{@id}">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
</xsl:when>
<!-- Отображаем список -->
<xsl:when test="filter = 2">
<br/>
<select name="property_{@id}">
<option value="0">...</option>
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
<!-- Отображаем переключатели -->
<xsl:when test="filter = 3">
<br/>
<div class="propertyInput">
<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
<label for="id_prop_radio_{@id}_0">&labelAnyOption;</label>
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажки -->
<xsl:when test="filter = 4">
<div class="propertyInput">
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажок -->
<xsl:when test="filter = 5">
<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
<label for="property_{@id}">
<xsl:value-of select="name"/><xsl:text> </xsl:text>
</label>
</xsl:when>

<!-- Отображение полей "от и до" -->
<xsl:when test="filter = 6">
<br/>
&labelFrom; <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> &labelTo; <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
</xsl:when>
<!-- Отображаем список с множественным выбором-->
<xsl:when test="filter = 7">
<br/>
<select name="property_{@id}[]" multiple="multiple">
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
</xsl:choose>
</div>
</xsl:template>


<xsl:template match="property" mode="propertyFilter">
<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

<div class="tabbing">

<xsl:if test="filter != 5">
<legend><xsl:value-of select="name"/><xsl:text> </xsl:text></legend>
</xsl:if>


<xsl:choose>
<!-- Отображаем поле ввода -->
<xsl:when test="filter = 1">
<br/>
<input type="text" name="property_{@id}">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
</xsl:when>
<!-- Отображаем список -->
<xsl:when test="filter = 2">
<br/>
<select name="property_{@id}">
<option value="0">...</option>
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
<!-- Отображаем переключатели -->
<xsl:when test="filter = 3">
<br/>
<div class="propertyInput">
<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
<label for="id_prop_radio_{@id}_0">&labelAnyOption;</label>
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажки -->
<xsl:when test="filter = 4">
<div class="propertyInput">
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажок -->
<xsl:when test="filter = 5">
<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
<label for="property_{@id}">
<xsl:value-of select="name"/><xsl:text> </xsl:text>
</label>
</xsl:when>

<!-- Отображение полей "от и до" -->
<xsl:when test="filter = 6">
<br/>
&labelFrom; <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> &labelTo; <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
</xsl:when>
<!-- Отображаем список с множественным выбором-->
<xsl:when test="filter = 7">
<br/>
<select name="property_{@id}[]" multiple="multiple">
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>

</xsl:choose>
</div>
</xsl:template>

<xsl:template match="list/list_item">
<xsl:if test="../../filter = 2">
<!-- Отображаем список -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<option value="{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
<xsl:value-of disable-output-escaping="yes" select="value"/>
</option>
</xsl:if>
<xsl:if test="../../filter = 3">
<!-- Отображаем переключатели -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<br/>
<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
</input>
<label for="id_property_{../../@id}_{@id}">
<xsl:value-of disable-output-escaping="yes" select="value"/>
</label>
</xsl:if>
<xsl:if test="../../filter = 4">
<!-- Отображаем флажки -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<br/>
<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
<label for="property_{../../@id}_{@id}">
<xsl:value-of disable-output-escaping="yes" select="value"/>
</label>
</input>
</xsl:if>
<xsl:if test="../../filter = 7">
<!-- Отображаем список -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<option value="{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="selected">
</xsl:attribute>
</xsl:if>
<xsl:value-of disable-output-escaping="yes" select="value"/>
</option>
</xsl:if>
</xsl:template>

<!-- Метки для товаров -->
<xsl:template match="tag">
<a href="{/shop/url}tag/{urlencode}/" class="tag">
<xsl:value-of select="tag_name"/>
</a>
<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
</xsl:template>
<xsl:template match="shop_currency/code">
<xsl:param name="value" />

<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

<xsl:choose>
<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'RUB'"> <xsl:value-of select="$spaced"/><xsl:text></xsl:text>₽ </xsl:when>
<xsl:when test=". = 'RUR'"> <xsl:value-of select="$spaced"/><xsl:text></xsl:text>₽ </xsl:when>
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