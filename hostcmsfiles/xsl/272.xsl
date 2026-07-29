<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://230">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">


		<xsl:apply-templates select="/shop"/>

	</xsl:template>

	<xsl:variable name="n" select="number(10)"/>
	<xsl:variable name="current_group_id" select="/shop/current_group_id"/>
	<xsl:template match="/shop">
		<!--xsl:value-of select="current_group_id"  disable-output-escaping="yes"/-->
		<xsl:choose>
			<xsl:when test="current_group_id = 0">
				<xsl:value-of select="description"  disable-output-escaping="yes"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="shop_group"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="shop_group">

		<xsl:value-of select="current_group_id"  disable-output-escaping="yes"/>
		<xsl:if test="$current_group_id = @id">
			<xsl:value-of select="description"  disable-output-escaping="yes"/>
			<xsl:if test="property_value[tag_name='seo-desc']/value !=''">
				<xsl:value-of select="property_value[tag_name='seo-desc']/value"  disable-output-escaping="yes"/>
			</xsl:if>
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