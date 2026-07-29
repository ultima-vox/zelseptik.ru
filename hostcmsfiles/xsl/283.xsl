<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://230">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>
	<xsl:variable name="n" select="number(10)"/>
	<xsl:variable name="current_group_id" select="/shop/current_group_id"/>

	<xsl:template match="shop">
		<xsl:variable name="seo-h1" select="/shop/seo-h1"/>
		<xsl:variable name="group" select="group"/>



		<!--xsl:value-of select="current_group_id"  disable-output-escaping="yes"/-->
		<xsl:choose>
			<xsl:when test="shop_filter_seo/h1 != ''">
				<h1 class="hero-offer__title"><xsl:value-of select="shop_filter_seo/h1" disable-output-escaping="yes"/></h1>
			</xsl:when>
			<xsl:when test="$current_group_id = 0">
				<xsl:value-of select="$seo-h1" disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="shop_group"/>
			</xsl:otherwise>
		</xsl:choose>

	</xsl:template>
	<xsl:template match="shop_group">

		<xsl:value-of select="current_group_id"  disable-output-escaping="yes"/>
		<xsl:if test="$current_group_id = @id">
			<xsl:if test="property_value[tag_name='seo-h1']/value !=''">
				<h1 class="h-2"><xsl:value-of select="property_value[tag_name='seo-h1']/value"  disable-output-escaping="yes"/></h1>
			</xsl:if>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_group" mode="breadCrumbs">

		<xsl:value-of select="current_group_id"  disable-output-escaping="yes"/>
		<xsl:if test="$current_group_id = @id">
			<li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem">
				<span itemprop="name">	<xsl:value-of select="name"/></span>
				<meta itemprop="item" content="{url}" />
			<meta itemprop="position" content="3"/></li>

		</xsl:if>

		<!--xsl:for-each select=". | following-sibling::shop_group[position() &lt; $n]">
		<xsl:variable name="current_group_id" select="current_group_id"/>
		<xsl:variable name="id" select="@id" />
		<div class="swiper-slide">
			<a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_group" title="{name}">
				<xsl:if test="$current_group_id = @id">
					<xsl:attribute name="class">active</xsl:attribute>
		</xsl:if> <xsl:value-of select="name"/><xsl:value-of select="$current_group_id"/></a></div>
	</xsl:for-each-->

</xsl:template>

</xsl:stylesheet>