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

	<xsl:variable name="n" select="number(25)"/>

	<xsl:template match="shop">
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="group"/>
		<xsl:variable name="count">1</xsl:variable>

		<xsl:if test="not(/shop/ajax/node())">
			<!--SCRIPT type="text/javascript">
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
                <![CDATA[
				 document.addEventListener("DOMContentLoaded",() => {
                    $(function() {
                        $(window).scroll(function() {
                            if($(window).scrollTop() + $(window).height() >= $(document).height() - 100) {
                                $('span.reload_product')
                                    .click()
                                    .prop('onclick', null)
                                    .off('click');
                            }
                        });
                    });
                     
					});
					]]>
				</xsl:text>
			</xsl:comment>
		</SCRIPT-->
	</xsl:if>
	<div class="container">

		<xsl:value-of disable-output-escaping="yes" select="description"/>

		<div class="catalog-controls">
			<div class="catalog-controls__status">
			<span class="catalog-controls__shown">Показано моделей: <span class="js-catalog-count">12</span></span><span class="catalog-controls__tip">* Листайте кнопками или свайпом пальца</span></div>
			<div class="catalog-controls__btns">
				<button type="button" aria-label="Предыдущий экран" class="catalog-controls__arrow js-catalog-prev">
					<svg aria-hidden="true" class="lucide lucide-chevron-left w-4 h-4" fill="none" height="24" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewbox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
						<path d="m15 18-6-6 6-6"></path>
					</svg>
				</button>
				<span class="catalog-controls__indicator js-catalog-indicator">1<!-- --> / <!-- -->3</span>
				<button type="button" aria-label="Следующий экран" class="catalog-controls__arrow js-catalog-next">
					<svg aria-hidden="true" class="lucide lucide-chevron-right w-4 h-4" fill="none" height="24" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" viewbox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg">
						<path d="m9 18 6-6-6-6"></path>
					</svg>
				</button>
			</div>
		</div>
		<xsl:if test="count(tag) = 0 and shop_item and count(.//shop_group[parent_id=$group]) &gt; 0">
			<div class="catalog-carousel">
				<div class="catalog-carousel__track js-catalog-track" style="overflow-x: auto; scrollbar-width: none; scroll-snap-type: x mandatory; -webkit-overflow-scrolling: touch;">
					<xsl:apply-templates select=".//shop_group[parent_id=$group][position() mod $n = 1]" mode="groups"/>
				</div>
			</div>
		</xsl:if>
		<!-- Catalog advice callout -->
		<div class="catalog-advice">
			<div class="catalog-advice__body">
				<div class="catalog-advice__icon-box">
					<span>❓</span>
				</div>
				<div>
					<h4 class="catalog-advice__title">Не определились с выбором септика?</h4>
					<p class="catalog-advice__desc">
						Каждый участок в Московской области уникален. Закажите бесплатный выезд инженера для анализа грунта и точного подбора!
					</p>
				</div>
			</div>
			<button type="button" class="catalog-advice__btn js-btn-callback" data-title="Консультация инженера">
				Обсудить задачу с инженером
			</button>
		</div>
	</div>
</xsl:template>
<xsl:template match="shop_group" mode="seo-desc">

	<xsl:choose>
		<xsl:when test="property_value[tag_name='index-seo-desc']/value != ''">
			<xsl:value-of disable-output-escaping="yes" select="property_value[tag_name='index-seo-desc']/value"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of disable-output-escaping="yes" select="description"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:template>
<xsl:template match="shop_group" mode="groups">
	<xsl:variable name="id" select="@id" />
	<xsl:apply-templates select="/shop/shop_item[shop_group_id = $id]"/>

</xsl:template>
<!-- Шаблон для групп товара -->
<xsl:template match="shop_group">
	<div class="col">
		<div class="txt">
			<h2 class="h-2">Если вы решили купить септик, рассмотрите все варианты</h2>
			<div class="select-bl" style="z-index: 5">
				<div class="title"> <span><i>септики</i><xsl:value-of select="name"/></span> </div>
				<!--ul>
				<xsl:for-each select=". | following-sibling::shop_group">
					<li><span class="reload_product" data-id="shop_group_{@id}"><i>септики</i> <xsl:value-of select="name"/></span></li><xsl:text> </xsl:text><span class="shop_count"><xsl:value-of select="items_total_count"/></span>
				</xsl:for-each>
			</ul-->
		</div>
		<xsl:value-of disable-output-escaping="yes" select="description"/>
	</div>
</div>
<div class="col">
	<div class="img"><img src="{dir}{image_large}" alt="{name}" class="lazyload" loading="lazy" /></div>
</div>
</xsl:template>
<xsl:template match="shop_item" mode="feachured">
<xsl:if test="property_value[tag_name='pop']/value = 1">
	<xsl:for-each select="shop_item">

		<div class="swiper-slide">
			<div class="pr-small">
				<h4>Рекомендуем: Септик <xsl:value-of select="name"/></h4>
				<div class="feature_pr_col"><img data-src="{dir}{image_large}" alt="{name}" class="lazyload" loading="lazy" />
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
	</div>
</xsl:for-each>
</xsl:if>
</xsl:template>
<!-- Шаблон для товара -->
<xsl:template match="shop_item">

<!--xsl:for-each select=". | following-sibling::shop_item"> 	</xsl:for-each-->
<div class="catalog-carousel__slide js-catalog-slide" data-category="дачи" style="scroll-snap-align: start;" itemscope="" itemtype="http://schema.org/Product">
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
				<img src="{dir}{image_large}" decoding="async" loading="lazy" alt="{name}" />
				<meta itemprop="image" content="{dir}{image_large}" />
			</xsl:when>
			<xsl:otherwise>
				<img src="/images/no-image.png" alt="{name}" title="{name}" itemprop="image" decoding="async" loading="lazy"/>
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

			<div class="catalog-card__spec-row">
				<span class="catalog-card__spec-label">Очистка:</span>
				<span class="catalog-card__spec-value catalog-card__spec-value--highlight">до 98%</span>
			</div>
		</div>
	</div>

	<div class="catalog-card__footer">
		<div class="catalog-card__price-row">
			<span class="catalog-card__price-label">Цена от:</span>

			<div itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
				<xsl:choose>
					<xsl:when test="price = 0">
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
			<button class="catalog-card__btn-order js-catalog-order" data-name="{name}" type="button"><xsl:attribute name="data-order-kind"><xsl:choose><xsl:when test="/shop/@id = 6">service</xsl:when><xsl:otherwise>installation</xsl:otherwise></xsl:choose></xsl:attribute>
				<xsl:choose><xsl:when test="/shop/@id = 6">Заказать обслуживание</xsl:when><xsl:otherwise>Заказать монтаж</xsl:otherwise></xsl:choose>
			</button>
			<a href="{url}" class="link link--muted link--center">Подробнее о модели</a>
		</div>
	</div>

</article>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->

</xsl:template>
<xsl:template match="shop_item" mode="group">




<!--xsl:for-each select=". | following-sibling::shop_item"> 	</xsl:for-each-->
<div class="swiper-slide" itemscope="" itemtype="http://schema.org/Product">
<div class="pr-small">
<div class="img">
	<a href="{url}">
		<xsl:choose>
			<xsl:when test="image_large != ''">
				<img data-src="{dir}{image_large}" height="152" class="lazyload" loading="lazy"  alt="{name}" itemprop="image"/>
				<!--img src="{dir}{image_large}" alt="{name}" class="zoom_img_effect"  title="{name}"/-->
			</xsl:when>
			<xsl:otherwise>
				<img src="/images/no-image.png" alt="{name}" class="lazyload" loading="lazy"   title="{name}" itemprop="image"/>
			</xsl:otherwise>
		</xsl:choose>
	</a>
	<xsl:if test="discount != 0">
		<div class="i-row">
			<span><xsl:apply-templates select="shop_discount"/>%</span>
		</div>
	</xsl:if>
</div>

<div class="pr-body-row">
	<div class="pr-body-col">
		<div class="txt">
			<h3 class="h-5"  itemprop="name" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><a
				href="{url}"><xsl:value-of select="name"/></a>
			</h3>
			<div class="mobile-bl">
				<div class="modific-sbm">Модификации <span class="ico"></span></div>
			</div>
			<!--xsl:value-of disable-output-escaping="yes" select="substring(description, 0, 50)"/-->
			<div class="description" itemprop="description"><xsl:value-of disable-output-escaping="yes" select="description"/></div>
		</div>
	</div>
	<div class="btns-row">
		<xsl:choose>
			<xsl:when test="price = 0">
				<p>	<a href="{url}" class="btn">
						Под заказ
					</a>
				</p>
				<!--p>
				<span class="btn grn pls"
					onclick="cart.add('56',1,this);"><img
						width="22" height="22"
						src="/templates/template1/images/icon-pls.svg"
					alt="{name}"/>
				</span>
			</p-->
		</xsl:when>
		<xsl:when test="discount != 0">
			<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
				<a class="btn" href="{url}">
					<span class="old">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
					</xsl:apply-templates></span>
					<xsl:apply-templates select="/shop/shop_currency/code">
						<xsl:with-param name="value" select="price + discount" />
					</xsl:apply-templates>
			</a></p>
			<meta itemprop="price" content="{price + discount}" />
			<meta itemprop="currency" content="RUB" />
			<link itemprop="availability" href="http://schema.org/InStock"/>

			<!--p>
			<span class="btn grn pls"
				onclick="cart.add('56',1,this);"><img
					width="22" height="22"
					src="/templates/template1/images/icon-pls.svg"
				alt="{name}" />
			</span>
		</p-->
	</xsl:when>
	<xsl:otherwise>
		<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
			<a class="btn" href="{url}">
				<xsl:apply-templates select="/shop/shop_currency/code">
					<xsl:with-param name="value" select="price" />
		</xsl:apply-templates></a></p>
		<meta itemprop="price" content="{price}" />
		<meta itemprop="priceCurrency" content="RUB" />
		<link itemprop="availability" href="http://schema.org/InStock"/>
		<!--p>
		<span class="btn grn pls"
			onclick="cart.add('56',1,this);"><img
				width="22" height="22"
				src="/templates/template1/images/icon-pls.svg"
			alt="{name}" />
		</span>
	</p-->
</xsl:otherwise>
</xsl:choose>
</div>
</div>
<!--<a href="{url}"  title="Купить септик {name}" class="view-all hvr-bounce-to-right shop_add_cart">Купить</a>>
<a href="#" data-toggle="modal" data-target="#productModal{@id}" data-description="{name}" onclick="lalal(this);" title="быстрый заказ" class="view-all hvr-bounce-to-right shop_add_cart">быстрый заказ</a-->
</div>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->

</xsl:template>

<xsl:template match="modifications/shop_item" mode="paramList">
<li class="modification_load " data-id="{@id}">
<span class="name">Самотеком</span>
</li>
<!--option value="{@id}" data-price="{price} {/shop/shop_currency/name}">
<xsl:value-of select="name"/><xsl:text> — </xsl:text><xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/shop/shop_currency/name"/>
</option-->
</xsl:template>
<xsl:template match="modifications/shop_item">
<li>
<!-- Название модификации -->
<a href="{url}"><xsl:value-of select="name"/></a>,
<!-- Цена модификации -->
<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/>
</li>
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
<label for="id_prop_radio_{@id}_0">Любое</label>
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
от <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> до <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
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
<label for="id_prop_radio_{@id}_0">Любое</label>
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
от <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> до <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
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
<xsl:template match="shop_discount">
<xsl:value-of select="round(percent)"/>
</xsl:template>
<xsl:template match="shop_currency/code">
<xsl:param name="value" />

<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

<xsl:choose>
<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'RUB'"> <xsl:value-of select="$spaced"/> ₽</xsl:when>
<xsl:when test=". = 'RUR'"> <xsl:value-of select="$spaced"/> ₽</xsl:when>
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
