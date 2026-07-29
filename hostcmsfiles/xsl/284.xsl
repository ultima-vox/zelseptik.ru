<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://180">
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

	<xsl:template match="/">
		<xsl:apply-templates select="/shop"/>
	</xsl:template>

	<xsl:template match="/shop">
		<xsl:variable name="currentLink" select="substring-before(concat(link, '?'), '?')"/>
		<xsl:variable name="shopUrl" select="url"/>
		<xsl:variable name="shopUrlNoSlash" select="substring($shopUrl, 1, string-length($shopUrl) - 1)"/>

		<section class="catalog-selector-section" aria-label="Инженерный подбор септика">
			<div class="container">
				<div class="catalog-selector">

					<div class="catalog-selector__header">
						<span class="hero-offer__tag">Инженерный подбор</span>

						<h2 class="catalog-selector__title">
							Подберите септик за 30 секунд
						</h2>

						<p class="catalog-selector__text">
							Выберите сценарий — покажем модели, которые подходят под ваш участок.
						</p>
					</div>

					<div class="catalog-selector__grid">

						<xsl:if test="count(shop_filter_seos/shop_filter_seo[active = 1 and shop_filter_seo_property/property_id = 6])">
							<div class="catalog-selector__group">
								<div class="catalog-selector__group-title">Сколько человек?</div>
								<div class="catalog-selector__options">
									<xsl:apply-templates select="shop_filter_seos/shop_filter_seo[active = 1 and shop_filter_seo_property/property_id = 6]" mode="selectorOption"/>
								</div>
							</div>
						</xsl:if>

						<xsl:if test="count(shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 10 or shop_filter_seo_property/property_id = 11)])">
							<div class="catalog-selector__group">
								<div class="catalog-selector__group-title">Тип проживания</div>
								<div class="catalog-selector__options">
									<xsl:apply-templates select="shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 10 or shop_filter_seo_property/property_id = 11)]" mode="selectorOption"/>
								</div>
							</div>
						</xsl:if>

						<xsl:if test="count(shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 39 or shop_filter_seo_property/property_id = 40)])">
							<div class="catalog-selector__group">
								<div class="catalog-selector__group-title">Особенности участка</div>
								<div class="catalog-selector__options">
									<xsl:apply-templates select="shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 39 or shop_filter_seo_property/property_id = 40)]" mode="selectorOption"/>
								</div>
							</div>
						</xsl:if>

						<xsl:if test="count(shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 2 or shop_filter_seo_property/property_id = 3)])">
							<div class="catalog-selector__group">
								<div class="catalog-selector__group-title">Тип сброса</div>
								<div class="catalog-selector__options">
									<xsl:apply-templates select="shop_filter_seos/shop_filter_seo[active = 1 and (shop_filter_seo_property/property_id = 2 or shop_filter_seo_property/property_id = 3)]" mode="selectorOption"/>
								</div>
							</div>
						</xsl:if>

					</div>

					<div class="catalog-selector__footer">
						<a class="hero-actions__btn-primary" href="{$shopUrlNoSlash}#catalog-products">
							Показать все модели
						</a>

						<p class="catalog-selector__note">
							Если не знаете тип грунта — инженер уточнит это на консультации.
						</p>
					</div>

				</div>
			</div>
		</section>
	</xsl:template>

	<xsl:template match="shop_filter_seo" mode="selectorOption">
		<xsl:variable name="currentLink" select="substring-before(concat(/shop/link, '?'), '?')"/>
		<xsl:variable name="urlNoSlash" select="substring(url, 1, string-length(url) - 1)"/>

		<a href="{$urlNoSlash}#catalog-products">
			<xsl:attribute name="class">
				<xsl:text>match-badge</xsl:text>
				<xsl:if test="$currentLink = url">
					<xsl:text> match-badge--active</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<xsl:if test="$currentLink = url">
				<xsl:attribute name="aria-current">page</xsl:attribute>
			</xsl:if>

			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

</xsl:stylesheet>