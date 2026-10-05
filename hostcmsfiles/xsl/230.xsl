<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://230">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<aside class="catalog__sidebar" aria-label="Фильтры каталога">
			<xsl:apply-templates select="/shop"/>
		</aside>
	</xsl:template>

	<xsl:variable name="n" select="number(10)"/>

	<xsl:template match="/shop">

		<xsl:variable name="group" select="group"/>

		<xsl:variable name="parent_id" select="//shop_group[@id = $group]/parent_id" />

		<xsl:if test="count(//shop_group)">
			<div class="filter-group">
				<h4 class="filter-group__title">Все модели</h4>
				<div class="catalog-tabs" aria-label="Быстрые сценарии выбора">
					<xsl:choose>
						<xsl:when test="$group = 0">

							<a class="catalog-tab" href="{/shop/url}">Все септики</a>

						</xsl:when>
						<xsl:otherwise>

							<a href="{/shop/url}" class="catalog-tab">Все септики</a>

						</xsl:otherwise>
					</xsl:choose>
					<xsl:apply-templates select="//shop_group"/>
				</div>
			</div>
		</xsl:if>


		<div class="box mfilter-box mfilter-box-1 mfilter-column_right mfilter-direction-ltr" id="mfilter-box-1">
			<div class="box-content mfilter-content">
				<div class="filter-mobile__top">
					<div class="filter-mobile__title">
						Фильтры
					</div>
					<button class="filter-mobile__close close-popup" type="button"></button>
				</div>
				<script>
					<xsl:comment>
						<xsl:text disable-output-escaping="yes">
								<![CDATA[
								document.addEventListener("DOMContentLoaded", () => {
								MegaFilter.prototype.beforeRequest = function() {
								var self = this;
								};
								
								MegaFilter.prototype.beforeRender = function( htmlResponse, htmlContent, json ) {
								var self = this;
								};
								
								MegaFilter.prototype.afterRender = function( htmlResponse, htmlContent, json ) {
								var self = this;
								tabsRow();
								};
								var swiper2 = new Swiper('#sw-art-nav .swiper', {
								slidesPerView: 'auto',
								spaceBetween: 0,
								centeredSlides: false,
								loop: false,
								});
								function applyFilter()
								{
								var jForm = $('.filter').closest('form'),
								path = jForm.attr('action'),
								producerOption = jForm.find('select[name = producer_id] option:selected'),
								sortingOption = jForm.find('select[name = sorting] option:selected'),
								priceFrom = jForm.find('input[name = price_from]').val(),
								priceTo = jForm.find('input[name = price_to]').val(),
								priceFromOriginal = jForm.find('input[name = price_from_original]').val(),
								priceToOriginal = jForm.find('input[name = price_to_original]').val();
								
								if (parseInt(producerOption.attr('value')))
								{
								path += producerOption.data('producer') + '/';
								}
								
								if (typeof priceFrom !== 'undefined' && typeof priceTo !== 'undefined'
								&& (priceFrom !== priceFromOriginal || priceTo !== priceToOriginal)
								)
								{
								path += 'price-' + priceFrom + '-' + priceTo + '/';
								}
								
								var inputs = jForm.find('*[data-property]'),
								tag_name;
								
								$.each(inputs, function (index, value) {
								var type = this.type || this.tagName.toLowerCase(),
								jObject = $(this),
								value = null,
								setValue = false;
								
								if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_to') !== -1)
								{
								return;
								}
								
								switch (type)
								{
								case 'checkbox':
								case 'radio':
								value = +jObject.is(':checked');
								setValue = type != 'checkbox' ? true : jObject.attr('name').indexOf('[]') !== -1;
								break;
								case 'option':
								value = +jObject.is(':selected');
								setValue = true;
								break;
								case 'text':
								value = jObject.val();
								setValue = true;
								break;
								}
								
								if (value && jObject.data('property') !== tag_name)
								{
								tag_name = jObject.data('property');
								
								if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_from') !== -1)
								{
								path += '';
								}
								else
								{
								path += tag_name + '/';
								}
								}
								
								if (setValue && value)
								{
								if (typeof jObject.attr('name') !== 'undefined' && jObject.attr('name').indexOf('_from') !== -1)
								{
								path += tag_name + '-' + jObject.val() + '-' + jObject.next().val() + '/';
								}
								else
								{
								path += typeof jObject.data('value') !== 'undefined'
								? jObject.data('value') + '/'
								: value + '/';
								}
								}
								});
								
								if (parseInt(sortingOption.attr('value')))
								{
								path += '?sorting=' + sortingOption.val();
								}
								
								// console.log(path);
								
								window.location.href = path;
								}
								
								function fastFilter(form)
								{
								this._timerId = false;
								this._form = form;
								
								this.filterChanged = function(obj) {
								if (this._timerId)
								{
								clearTimeout(this._timerId);
								}
								
								var $this = this;
								
								this._timerId = setTimeout(function() {
								$this._loadJson(obj);
								}, 1500);
								
								return this;
								}
								
								this._loadJson = function(obj) {
								var data = this._serializeObject();
								
								$.loadingScreen('show');
								
								$.ajax({
								url: './',
								type: "POST",
								data: data,
								dataType: 'json',
								success: function (result) {
								$.loadingScreen('hide');
								
								if (typeof result.count !== 'undefined')
								{
								var jParent = obj.parents('fieldset').length
								? obj.parents('fieldset')
								: obj.parent();
								
								$('.popup-filter').remove();
								
								jParent.css('position', 'relative');
				jParent.append('<div class="popup-filter"><div>Найдено: ' + result.count + '</div><br/><div><button class="button" onclick="applyFilter(); return false;">Применить</button></div></div>');
								
								setTimeout(function() {
								$('.popup-filter').remove();
								}, 5000);
								}
								}
								});
								}
								
								this._serializeObject = function () {
								var o = {fast_filter: 1};
								var a = this._form.serializeArray();
								$.each(a, function () {
								if (o[this.name] !== undefined) {
								if (!o[this.name].push) {
								o[this.name] = [o[this.name]];
								}
								o[this.name].push(this.value || '');
								} else {
								o[this.name] = this.value || '';
								}
								});
								
								return o;
								};
								}
								
								$(function() {
								var jForm = $('.filter').closest('form');
								mainFastFilter = new fastFilter(jForm);
								
								$(':input:not(:hidden):not(button)').on('change', function(){
								mainFastFilter.filterChanged($(this));
								});
								
								$('.filter-color').on('click', function(){
								var bg = $(this).css('background-color');
								
								$('.filter-color').each(function (index, value) {
								$(this).removeClass('active');
								});
								
								$(this).addClass('active');
								
								$('.color-input').remove();
								
								var property_id = $(this).data('id'),
								list_item_id = $(this).data('item-id');
								
								$(this).append('<input type="hidden" class="color-input" id="property_' + property_id + '_' + list_item_id +'" name="property_' + property_id + '" data-property="' + $(this).data('property') + '" data-value="' + $(this).data('value') + '" value="' + list_item_id + '"/>');
								
								mainFastFilter.filterChanged($(this));
								});
								
								jForm.on('submit', function(e) {
								e.preventDefault();
								
								applyFilter();
								});
								});
								});
							]]>
						</xsl:text>
					</xsl:comment>
				</script>
				<!-- Store parent id in a variable -->


				<xsl:variable name="path">
					<xsl:choose>
						<xsl:when test="/shop//shop_group[@id=$group]/node()"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when>
						<xsl:otherwise><xsl:value-of select="/shop/url"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- дополнение пути для action, если выбрана метка -->
				<xsl:variable name="form_tag_url"><xsl:if test="count(tag) = 1">tag/<xsl:value-of select="tag/urlencode"/>/</xsl:if></xsl:variable>

				<form method="get" action="{$path}{$form_tag_url}">
					<ul>

						<!--li class="mfilter-filter-item mfilter-select mfilter-attribute mfilter-attributes">
						<div class="mfilter-heading">
							<div class="mfilter-heading-content">
								<div class="mfilter-heading-text">
								<span>Сортировка</span></div>
								<i class="mfilter-head-icon"></i>
							</div>
						</div>
						<div class="mfilter-content-opts">
							<div class="mfilter-opts-container">
								<div class="mfilter-content-wrapper">
									<div class="mfilter-options">
										<div class="mfilter-options-container">
											<div class="mfilter-tb">
												<label class="select" for="slct">
													<select class="shop_select" id="slct" required="required" name="sorting" onchange="$(this).parents('form:first').submit()">
														<option value="" disabled="disabled" selected="selected">&labelSorting;</option>
														<option value="1">
															<xsl:if test="sorting = 1"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
															&labelSorting1;
														</option>
														<option value="2">
															<xsl:if test="sorting = 2"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
															&labelSorting2;
														</option>
														<option value="3">
															<xsl:if test="sorting = 3"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
															&labelSorting3;
														</option>
													</select>
												</label>

											</div>
										</div>
									</div>
								</div>

								<div class="mfilter-clearfix"></div>
							</div>

							<div class="mfilter-clearfix"></div>
						</div>
					</li-->


					<li
						data-type="price"
						data-base-type="price"
						data-id="price"
						data-seo-name="price"
						data-inline-horizontal="0"
						data-display-live-filter="0"
						data-display-list-of-items="-1"
						class="mfilter-filter-item mfilter-price mfilter-price">
						<div class="mfilter-heading">
							<div class="mfilter-heading-content">
								<div class="mfilter-heading-text">
									<span>Цена</span>

								</div>
								<i class="mfilter-head-icon"></i>
							</div>
						</div>

						<div class="mfilter-content-opts">
							<div class="mfilter-opts-container">
								<div class="mfilter-content-wrapper">
									<div class="mfilter-options">
										<div class="mfilter-option mfilter-price">
											<div style="display: none;">
												<div class="mfilter-price-inputs" style="display: none;">

													<input
														id="mfilter-opts-price-min"
														type="text"
														name="price_from"
														class="form-control"
														value=""
													/>
													₽													-
													<input
														id="mfilter-opts-price-max"
														type="text"
														name="price_to"
														class="form-control"
														value=""
													/>
													₽
												</div>
											</div>
											<div class="mfilter-price-slider">
												<div id="mfilter-price-slider">
													<span id="custom-handle1" class="ui-slider-handle ui-slider-handle1"><span></span></span>
													<span id="custom-handle2" class="ui-slider-handle ui-slider-handle2"><span></span></span>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="mfilter-clearfix"></div>
							</div>

							<div class="mfilter-clearfix"></div>
						</div>
					</li>

					<li class="mfilter-filter-item mfilter-select mfilter-attribute mfilter-attributes">
						<div class="mfilter-heading">
							<div class="mfilter-heading-content">
								<div class="mfilter-heading-text">
								<span>Производитель</span></div>
								<i class="mfilter-head-icon"></i>
							</div>
						</div>
						<div class="mfilter-content-opts">
							<div class="mfilter-opts-container">
								<div class="mfilter-content-wrapper">
									<div class="mfilter-options">
										<div class="mfilter-options-container">
											<div class="mfilter-tb">
												<label class="select" for="producer_id">
													<select class="shop_select" id="producer_id" required="required" name="producer_id">
														<option value="" disabled="disabled" selected="selected">Выбрать производителя</option>
														<xsl:apply-templates select="/shop/producers/shop_producer" />
													</select>
												</label><!-- SVG Sprites-->

											</div>
										</div>
									</div>
								</div>

								<div class="mfilter-clearfix"></div>
							</div>

							<div class="mfilter-clearfix"></div>
						</div>
					</li>

					<!-- Фильтр по дополнительным свойствам товара:
						<xsl:if test="count(shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 7 or type = 11)])">
							<li class="mfilter-filter-item mfilter-attribute mfilter-attributes">
								<xsl:apply-templates select="shop_item_properties//property[filter != 0 and (type = 0 or type = 1 or type = 3 or type = 7 or type = 11)]" mode="propertyList" />

							</li>
						</xsl:if>-->

						<xsl:if test="/shop/on_page/node() and /shop/on_page &gt; 0">
							<div class="tabbing_col">
								<input type="hidden" name="on_page" value="{/shop/on_page}" />
							</div>
						</xsl:if>
					</ul>
					<!-- <input name="filter" class="button" value="Применить" type="submit"/> -->
					<button class="btn">Применить</button>


				</form>
			</div>
		</div>

		<script type="text/javascript">
			var $pmin = <xsl:value-of select="/shop/min_price"/>;
			var $pmax = <xsl:value-of select="/shop/max_price"/>;
			<xsl:text disable-output-escaping="yes">
				document.addEventListener("DOMContentLoaded", () => {
			</xsl:text>
			MegaFilterLang.text_display = 'Показать';
			MegaFilterLang.text_list	= 'Список';
			MegaFilterLang.text_grid	= 'Сетка';
			MegaFilterLang.text_select	= 'Выберите...';

			jQuery().ready(function(){
			jQuery('#mfilter-box-1').each(function(){
			var _t = jQuery(this).addClass('init'),
			_p = { };

			MegaFilterINSTANCES.push((new MegaFilter()).init( _t, {
			'idx'					: '1',
			'contentSelector'		: '.reload_catalog',
			'refreshResults'		: 'using_button',
			'refreshDelay'			: 1000,
			'autoScroll'			: false,

			'priceMin'				: $pmin,
			'priceMax'				: $pmax,
			'mijoshop'				: false,
			'joo_cart'				: false,
			'showNumberOfProducts'	: true,
			'calculateNumberOfProducts' : true,
			'addPixelsFromTop'		: 0,
			'displayListOfItems'	: {
			'type'				: 'button_more',
			'limit_of_items'	: 10,
			'maxHeight'			: 155,
			'textMore'			: 'Показать ещё (%s)',
			'textLess'			: 'Скрыть',
			'standardScroll'	: false				},
			'smp'					: {
			'isInstalled'			: false,
			'disableConvertUrls'	: false				},
			'params'					: _p,
			'inStockDefaultSelected'	: false,
			'inStockStatus'				: '7',
			'showLoaderOverResults'		: false,
			'showLoaderOverFilter'		: false,
			'hideInactiveValues'		: true,
			'manualInit'				: false,
			'homePageAJAX'				: false,
			'homePageContentSelector'	: '#content',
			'ajaxPagination'			: false,
			'text'						: {
			'loading'		: 'Загрузка...',
			'go_to_top'		: 'Перейти к началу',
			'init_filter'	: 'Поиск с фильтрацией',
			'initializing'	: 'Инициализация...'
			},
			'color' : {
			'loader_over_results' : '#ffffff',
			'loader_over_filter' : '#ffffff'
			},
			'direction'				: 'ltr',
			'seo' : {
			'enabled'	: false,
			'alias'		: ''
			},
			'displayAlwaysAsWidget'		: false,
			'displaySelectedFilters'	: false,
			'isMobile' : false,
			'widgetWithSwipe' : true,
			'data' : {
			'category_id' : 82				}
			}));
			});
			});
			});
		</script>

	</xsl:template>
	<xsl:template match="property">
		<xsl:variable name="property_id" select="@id" />
		<xsl:if test="/shop/shop_item/property_value[property_id = $property_id]/value/node() and /shop/shop_item/property_value[property_id = $property_id]/value != '' or /shop/shop_item/property_value[property_id = $property_id]/type != 2">
			<xsl:value-of disable-output-escaping="yes" select="name"/>
		</xsl:if>
	</xsl:template>
	<xsl:template match="shop_group">
		<xsl:variable name="current_group_id" select="/shop/current_group_id"/>

		<!--xsl:for-each select=". | following-sibling::shop_group[position() &lt; $n]">
		<xsl:variable name="current_group_id" select="current_group_id"/>
		<xsl:variable name="id" select="@id" />
		<div class="swiper-slide">
			<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group" title="{name}">
				<xsl:if test="$current_group_id = @id">
					<xsl:attribute name="class">active</xsl:attribute>
		</xsl:if> <xsl:value-of select="name"/><xsl:value-of select="$current_group_id"/></a></div>
	</xsl:for-each-->

	<a href="{url}" class="catalog-tab"><xsl:if test="$current_group_id = @id">
		<xsl:attribute name="class">active</xsl:attribute></xsl:if>
	<xsl:value-of select="name" /></a>

</xsl:template>
<!-- Шаблон для фильтра по дополнительным свойствам -->
<xsl:template match="property" mode="propertyList">
	<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
	<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
	<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>


	<!-- Не флажок -->
	<xsl:if test="filter != 5">
		<div class="mfilter-heading">
			<div class="mfilter-heading-content">
				<div class="mfilter-heading-text">
				<span><xsl:value-of select="name"/></span></div>
				<i class="mfilter-head-icon"></i>
			</div>
		</div>
	</xsl:if>

	<xsl:choose>
		<!-- Отображаем поле ввода -->
		<xsl:when test="filter = 1">
			<div class="tabbing_col">
				<span class="shop_filter1">
					<input type="text" name="property_{@id}" data-property="{tag_name}">
						<xsl:if test="/shop/*[name()=$nodename] != ''">
							<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
						</xsl:if>
			</input></span></div>
		</xsl:when>
		<!-- Отображаем список -->
		<xsl:when test="filter = 2">
			<div class="tabbing_col">
				<select class="shop_select" name="property_{@id}">
					<option value="0">...</option>
					<xsl:apply-templates select="list/list_item"/>
			</select></div>
		</xsl:when>
		<!-- Отображаем переключатели -->
		<xsl:when test="filter = 3">

			<div class="tabbing_col">
				<span class="shop_filter1">
					<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
					<label for="id_prop_radio_{@id}_0">&labelAny;</label>
				<xsl:apply-templates select="list/list_item"/></span>
			</div>
		</xsl:when>
		<!-- Отображаем флажки -->
		<xsl:when test="filter = 4">
			<div class="tabbing_col">
				<span class="shop_filter1">
					<xsl:apply-templates select="list/list_item"/>
				</span>
			</div>
			<div style="display:none; text-align: center;">
				...
			</div>
		</xsl:when>
		<!-- Отображаем флажок -->
		<xsl:when test="filter = 5">
			<div class="tabbing_col">
				<span class="shop_filter1">
					<input type="checkbox" name="property_{@id}" id="property_{@id}" value="1" style="padding-top:4px" data-property="{tag_name}">
						<xsl:if test="/shop/*[name()=$nodename] != ''">
							<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
						</xsl:if>
					</input>
					<label for="property_{@id}">
						<xsl:value-of select="name"/><xsl:text> </xsl:text>
			</label></span></div>
		</xsl:when>
		<!-- Отображение полей "от и до" -->
		<xsl:when test="filter = 6">
			<div class="tabbing_col">
				<span class="shop_filter1">
					<xsl:text>&labelFrom; </xsl:text>
					<input name="property_{@id}_from" size="5" type="text" value="{min}" data-property="{tag_name}">
						<xsl:if test="/shop/*[name()=$nodename_from] != 0">
							<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_from]"/></xsl:attribute>
						</xsl:if>
					</input>

					<xsl:text>&labelTo; </xsl:text>
					<input name="property_{@id}_to" size="5" type="text" value="{max}" data-property="{tag_name}">
						<xsl:if test="/shop/*[name()=$nodename_to] != 0">
							<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename_to]"/></xsl:attribute>
						</xsl:if>
					</input>

					<input name="property_{@id}_from_original" value="{min}" hidden="hidden" />
					<input name="property_{@id}_to_original" value="{max}" hidden="hidden" />
				</span>
			</div>
		</xsl:when>
		<!-- Отображаем список с множественным выбором-->
		<xsl:when test="filter = 7">
			<div class="tabbing_col">

				<select class="shop_select" name="property_{@id}[]" multiple="multiple">
					<xsl:apply-templates select="list/list_item"/>
				</select>
			</div>
		</xsl:when>
	</xsl:choose>




</xsl:template>

<xsl:template match="list/list_item">
	<xsl:variable name="list_item_id" select="@id"/>

	<xsl:variable name="value">
		<xsl:choose>
			<xsl:when test="/shop/filter_mode = 1 and path != ''">
				<xsl:value-of select="path" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="value" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<xsl:if test="../../filter = 2">
		<!-- Отображаем список -->
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<option value="{@id}" data-property="{../../tag_name}" data-value="{$value}">
			<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
			<xsl:value-of select="value"/>

			<xsl:if test="../../filter_counts/count[@id = $list_item_id]/node()">
				<xsl:text> (</xsl:text><xsl:value-of select="../../filter_counts/count[@id = $list_item_id]"/><xsl:text>)</xsl:text>
			</xsl:if>
		</option>
	</xsl:if>
	<xsl:if test="../../filter = 3">
		<!-- Отображаем переключатели -->
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<br/>
		<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}" data-property="{../../tag_name}" data-value="{$value}">
			<xsl:if test="/shop/*[name()=$nodename] = @id">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<label for="id_property_{../../@id}_{@id}">
				<xsl:value-of select="value"/>

				<xsl:if test="../../filter_counts/count[@id = $list_item_id]/node()">
					<xsl:text> (</xsl:text><xsl:value-of select="../../filter_counts/count[@id = $list_item_id]"/><xsl:text>)</xsl:text>
				</xsl:if>
			</label>
		</input>
	</xsl:if>
	<xsl:if test="../../filter = 4">
		<!-- Отображаем флажки -->
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}" data-property="{../../tag_name}" data-value="{$value}">
			<xsl:if test="/shop/*[name()=$nodename] = @id">
				<xsl:attribute name="checked">checked</xsl:attribute>
			</xsl:if>
			<label for="property_{../../@id}_{@id}">
				<xsl:value-of select="value"/>

				<xsl:if test="../../filter_counts/count[@id = $list_item_id]/node()">
					<xsl:text> (</xsl:text><xsl:value-of select="../../filter_counts/count[@id = $list_item_id]"/><xsl:text>)</xsl:text>
				</xsl:if>
			</label>
		</input>
		<br/>
	</xsl:if>
	<xsl:if test="../../filter = 7">
		<!-- Отображаем список -->
		<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
		<option value="{@id}" data-property="{../../tag_name}" data-value="{$value}">
			<xsl:if test="/shop/*[name()=$nodename] = @id">
				<xsl:attribute name="selected">
				</xsl:attribute>
			</xsl:if>
			<xsl:value-of disable-output-escaping="yes" select="value"/>

			<xsl:if test="../../filter_counts/count[@id = $list_item_id]/node()">
				<xsl:text> (</xsl:text><xsl:value-of select="../../filter_counts/count[@id = $list_item_id]"/><xsl:text>)</xsl:text>
			</xsl:if>
		</option>
	</xsl:if>
</xsl:template>

<xsl:template match="shop_producer">
	<xsl:variable name="name">
		<xsl:choose>
			<xsl:when test="/shop/filter_mode = 0">
				<xsl:value-of select="name" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="path" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<option value="{@id}" data-producer="{$name}">
		<xsl:if test="/shop/producer_id = @id">
			<xsl:attribute name="selected">selected</xsl:attribute>
		</xsl:if>

		<xsl:value-of select="name"/>

		<xsl:if test="count/node()">
			<xsl:text> (</xsl:text><xsl:value-of select="count"/><xsl:text>)</xsl:text>
		</xsl:if>
	</option>
</xsl:template>
</xsl:stylesheet>