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


			<div class="catalog-row fl-row">
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
	<!--xsl:choose>

	<xsl:when test="position() = 2 and /shop/@id != 6">
		<div class="col big" itemscope="" itemtype="https://schema.org/Product">
			<div class="cat-banner">
				<a href="{url}" class="img">
					<img itemprop="image" src="{dir}{image_large}" alt="{name}" loading="lazy" class="lazyload"/>
				</a>
				<div class="txt">
					<h3 class="h-3">
						<xsl:choose>
							<xsl:when test="/shop/@id = 1">
								<a href="{url}"><span itemprop="name">Септик <xsl:value-of select="name"/></span></a>
							</xsl:when>
							<xsl:when test="/shop/@id = 5">
								<a href="{url}"><span itemprop="name">Погреб <xsl:value-of select="name"/></span></a>
							</xsl:when>
							<xsl:otherwise><a href="{url}"><span itemprop="name"><xsl:value-of select="name"/></span></a></xsl:otherwise>
						</xsl:choose>
					</h3>
					<div class="bann-coment">
						<xsl:value-of select="description" disable-output-escaping="yes"/>
					</div>
					<div class="btns-row">
						<p><a class="btn" href="{url}">
								<span itemprop="offers" itemtype="https://schema.org/Offer" itemscope="">
									<xsl:choose>
										<xsl:when test="price = 0">
											Под заказ
										</xsl:when>
										<xsl:otherwise>
											Купить за
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price" />
											</xsl:apply-templates>
											<meta itemprop="price" content="{price}" />
											<meta itemprop="priceCurrency" content="RUB" />
											<link itemprop="availability" href="http://schema.org/InStock"/>
										</xsl:otherwise>
									</xsl:choose>
								</span>
						</a></p>
					</div>
				</div>
			</div>
		</div>
	</xsl:when>
	<xsl:otherwise>
		<div class="col catalog__item" itemscope="" itemtype="https://schema.org/Product">
			<div class="pr-small">
				<div class="img">
					<a href="{url}">
						<xsl:choose><xsl:when test="image_large != ''">
								<img itemprop="image" width="152" height="152" src="{dir}{image_large}" alt="{name}" loading="lazy" class="lazyload"/>
							</xsl:when>
							<xsl:otherwise>
								<img width="152" height="152" src="{dir}{image_small}" alt="{name}" loading="lazy" class="lazyload"/>
							</xsl:otherwise>
						</xsl:choose>
					</a>
					<xsl:if test="discount != 0">
						<div class="i-row"><span><xsl:apply-templates select="shop_discount"/>%</span></div>
					</xsl:if>
				</div>


				<div class="pr-body-row">
					<div class="pr-body-col">
						<div class="txt">
							<h3 class="h-5">
								<xsl:choose>
									<xsl:when test="/shop/@id = 1">
										<a href="{url}"><span itemprop="name">Септик <xsl:value-of select="name"/></span></a>
									</xsl:when>
									<xsl:when test="/shop/@id = 5">
										<a href="{url}"><span itemprop="name">Погреб <xsl:value-of select="name"/></span></a>
									</xsl:when>
									<xsl:otherwise><a href="{url}"><span itemprop="name"><xsl:value-of select="name"/></span></a></xsl:otherwise>
								</xsl:choose>
							</h3>
							<div class="mobile-bl">
								<div class="modific-sbm">Модификации <span class="ico"></span></div>
							</div>
							<ul itemprop="description">
								<li>Кол-во пользователей (до) – 2;</li>
								<li>Объем залпового сброса (л) – 120;</li>
								<li>Способ водоотведения – Самотеком;</li>
							</ul>
							<xsl:value-of select="description" disable-output-escaping="yes"/>
						</div>
						<div class="modific-bl">
							<xsl:if test="/shop/@id = 1">
								<h6 class="tabs-h">Модификация:
									<div class="i-btn">
										<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
											<path fill-rule="evenodd" clip-rule="evenodd" d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM11.258 5.95746C11.258 4.26376 9.72769 3.55566 8.17335 3.55566C6.69151 3.55566 5.33174 4.59967 5.33203 5.77774C5.33203 6.25793 5.69683 6.51022 6.12181 6.51022C6.66959 6.51022 6.83106 6.167 7.00373 5.79998C7.20215 5.37825 7.41534 4.92508 8.24642 4.92508C8.97545 4.92508 9.4116 5.30946 9.4116 5.95774C9.4116 6.51806 8.93076 6.88508 8.42657 7.26991C7.87095 7.69401 7.28699 8.13973 7.28699 8.88962C7.28699 9.274 7.54204 9.6941 8.06416 9.6941C8.63512 9.6941 8.74993 9.39477 8.87418 9.07082C8.92435 8.93999 8.97607 8.80516 9.05999 8.68439C9.1771 8.5143 9.42327 8.34091 9.71006 8.1389C10.3749 7.67065 11.258 7.04863 11.258 5.95746ZM9.1087 11.4592C9.1087 10.9178 8.6585 10.4739 8.11288 10.4739C7.5664 10.4739 7.11677 10.9181 7.11677 11.4592C7.11677 12.0012 7.5664 12.4446 8.11288 12.4446C8.65936 12.4446 9.1087 12.0006 9.1087 11.4592Z" fill="#009CD9" />
										</svg>
										<span>Пр — с принудительным выбросом стоков. Его устанавливают при высоких грунтовых водах или выбросе стоков в канаву. Стандарт/Миди/Лонг — различают по длине горловины. Миди и Лонг, удлиненные, нужны, если стоковая труба выходит глубже 60 см от уровня земли.</span>
									</div>
								</h6>
								<div class="tabs-row">
									<ul>
										<xsl:choose>
											<xsl:when test="property_value[tag_name='nopr']/value = 1">
												<li class="modification_load active">
													<span class="name">Самотечный</span>
												</li>
												<li class="modification_load">
													<span class="name">Принудительный</span>
												</li>
											</xsl:when>
											<xsl:otherwise>
												<li class="modification_load">
													<span class="name">Самотечный</span>
												</li>
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
												<li class="modification_load ">
													<span class="name">Стандарт</span>
												</li>
												<li class="modification_load active" >
													<span class="name">Лонг</span>
												</li>
											</xsl:when>
											<xsl:when test="property_value[tag_name='midi']/value = 1">
												<li class="modification_load ">
													<span class="name">Стандарт</span>
												</li>
												<li class="modification_load active" >
													<span class="name">Миди</span>
												</li>
											</xsl:when>
											<xsl:otherwise>
												<li class="modification_load  active">
													<span class="name">Стандарт</span>
												</li>
												<li class="modification_load" >
													<span class="name">Лонг</span>
												</li>
											</xsl:otherwise>
										</xsl:choose>
									</ul>
								<span class="line" style="width: 50%; left: 0%;"></span></div>
							</xsl:if>
						</div>
					</div>
					<div class="btns-row">
						<p><a class="btn" href="{url}">
								<span itemprop="offers" itemtype="https://schema.org/Offer" itemscope="">
									<xsl:choose>
										<xsl:when test="price = 0">
											Под заказ
										</xsl:when>
										<xsl:when test="discount != 0">
											<span class="old">
												<xsl:apply-templates select="/shop/shop_currency/code">
													<xsl:with-param name="value" select="price + discount" />
												</xsl:apply-templates>
											</span>
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price" />
											</xsl:apply-templates>
										</xsl:when>
										<xsl:otherwise>
											<xsl:apply-templates select="/shop/shop_currency/code">
												<xsl:with-param name="value" select="price" />
											</xsl:apply-templates>
											<meta itemprop="price" content="{price}" />
											<meta itemprop="priceCurrency" content="RUB" />
											<link itemprop="availability" href="http://schema.org/InStock"/>
										</xsl:otherwise>
									</xsl:choose>
								</span>
						</a></p>
					</div>
				</div>
			</div>
		</div>
	</xsl:otherwise>
</xsl:choose-->
<div class="col catalog__item" itemscope="" itemtype="https://schema.org/Product">
	<div class="pr-small">
		<div class="img">
			<a href="{url}">
				<xsl:choose><xsl:when test="image_large != ''">
						<img itemprop="image" width="152" height="152" src="{dir}{image_large}" alt="{name}" loading="lazy" class="lazyload"/>
					</xsl:when>
					<xsl:otherwise>
						<img width="152" height="152" src="{dir}{image_small}" alt="{name}" loading="lazy" class="lazyload"/>
					</xsl:otherwise>
				</xsl:choose>
			</a>
			<xsl:if test="discount != 0">
				<div class="i-row"><span><xsl:apply-templates select="shop_discount"/>%</span></div>
			</xsl:if>
		</div>


		<div class="pr-body-row">
			<div class="pr-body-col">
				<div class="txt">
					<h3 class="h-5">
						<xsl:choose>
							<xsl:when test="/shop/@id = 1">
								<a href="{url}"><span itemprop="name"><xsl:value-of select="name"/></span></a>
							</xsl:when>
							<xsl:when test="/shop/@id = 5">
								<a href="{url}"><span itemprop="name">Погреб <xsl:value-of select="name"/></span></a>
							</xsl:when>
							<xsl:otherwise><a href="{url}"><span itemprop="name"><xsl:value-of select="name"/></span></a></xsl:otherwise>
						</xsl:choose>
					</h3>
					<!--div class="mobile-bl">
					<div class="modific-sbm">Модификации <span class="ico"></span></div>
				</div-->
				<ul itemprop="description">
					<xsl:if test="property_value[tag_name='men']/value != ''">
						<li>Кол-во пользователей (до) – <xsl:value-of select="property_value[tag_name='men']/value"/>;</li>
					</xsl:if>
					<xsl:if test="property_value[tag_name='men']/value != ''">
						<li>Объем залпового сброса (л) – 120;</li>
					</xsl:if>
					<xsl:if test="property_value[tag_name='nopr']/value = 1">
						<li>Способ водоотведения – Самотеком;</li>
					</xsl:if>
					<xsl:if test="property_value[tag_name='pr']/value = 1">
						<li>Способ водоотведения – Принудительный;</li>
					</xsl:if>
				</ul>
				<!--xsl:value-of select="description" disable-output-escaping="yes"/-->
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
<div class="btns-row">
<p><a class="btn" href="{url}">
<span itemprop="offers" itemtype="https://schema.org/Offer" itemscope="">
	<xsl:choose>
		<xsl:when test="price = 0">
			Под заказ
		</xsl:when>
		<xsl:when test="discount != 0">
			<span class="old">
				<xsl:apply-templates select="/shop/shop_currency/code">
					<xsl:with-param name="value" select="price + discount" />
				</xsl:apply-templates>
			</span>
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="price" />
			</xsl:apply-templates>
			<meta itemprop="price" content="{price}" />
			<meta itemprop="priceCurrency" content="RUB" />
			<link itemprop="availability" href="http://schema.org/InStock"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="price" />
			</xsl:apply-templates>
			<meta itemprop="price" content="{price}" />
			<meta itemprop="priceCurrency" content="RUB" />
			<link itemprop="availability" href="http://schema.org/InStock"/>
		</xsl:otherwise>
	</xsl:choose>
</span>
</a></p>
</div>
</div>
</div>
</div>
<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->
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