<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:exsl="http://exslt.org/common"
	extension-element-prefixes="exsl">

	<xsl:output method="xml"
		doctype-public="XSLT-compat"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		omit-xml-declaration="yes"
		encoding="UTF-8"
	indent="yes"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/site">
		<nav class="breadcrumbs-section container" aria-label="Хлебные крошки">
			<ul class="breadcrumbs" itemscope="" itemtype="https://schema.org/BreadcrumbList">

				<xsl:call-template name="breadcrumb-li">
					<xsl:with-param name="name" select="'Главная'"/>
					<xsl:with-param name="link" select="'/'"/>
					<xsl:with-param name="position" select="1"/>
				</xsl:call-template>

				<xsl:apply-templates select="structure[@id]" mode="breadcrumbs">
					<xsl:with-param name="position" select="2"/>
				</xsl:apply-templates>

			</ul>
		</nav>
	</xsl:template>

	<xsl:template match="structure" mode="breadcrumbs">
		<xsl:param name="position"/>

		<xsl:variable name="link">
			<xsl:choose>
				<xsl:when test="link != ''">
					<xsl:value-of select="link"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="url"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="isCurrent">
			<xsl:choose>
				<xsl:when test="not(structure[@id]) and not(informationsystem_group | shop_group | informationsystem_item | shop_item)">1</xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="breadcrumb-li">
			<xsl:with-param name="name" select="name"/>
			<xsl:with-param name="link" select="$link"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="current" select="$isCurrent"/>
		</xsl:call-template>

		<xsl:apply-templates select="structure[@id][link/node() or url/node()]" mode="breadcrumbs">
			<xsl:with-param name="position" select="$position + 1"/>
		</xsl:apply-templates>

		<xsl:apply-templates select="informationsystem_group | shop_group | informationsystem_item | shop_item" mode="breadcrumbs-extra">
			<xsl:with-param name="position" select="$position + 1"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="informationsystem_group | shop_group | informationsystem_item | shop_item" mode="breadcrumbs-extra">
		<xsl:param name="position"/>

		<xsl:variable name="link">
			<xsl:choose>
				<xsl:when test="link != ''">
					<xsl:value-of select="link"/>
				</xsl:when>
				<xsl:when test="url != ''">
					<xsl:value-of select="url"/>
				</xsl:when>
				<xsl:otherwise>#</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:call-template name="breadcrumb-li">
			<xsl:with-param name="name" select="name"/>
			<xsl:with-param name="link" select="$link"/>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="current" select="1"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="breadcrumb-li">
		<xsl:param name="name"/>
		<xsl:param name="link"/>
		<xsl:param name="position"/>
		<xsl:param name="current" select="0"/>

		<li itemscope="" itemprop="itemListElement" itemtype="https://schema.org/ListItem">
			<xsl:choose>
				<xsl:when test="$current = 1">
					<span itemprop="name" aria-current="page">
						<xsl:value-of select="$name"/>
					</span>

					<meta itemprop="item" content="{$link}"/>
				</xsl:when>

				<xsl:otherwise>
					<a href="{$link}" itemprop="item" title="{$name}">
						<span itemprop="name">
							<xsl:value-of select="$name"/>
						</span>
					</a>
				</xsl:otherwise>
			</xsl:choose>

			<meta itemprop="position" content="{$position}"/>
		</li>
	</xsl:template>

</xsl:stylesheet>