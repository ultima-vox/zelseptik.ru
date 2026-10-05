<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://285">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output encoding="utf-8" indent="yes" method="html" omit-xml-declaration="yes"/>

	<xsl:variable name="current_structure_id" select="/site/current_structure_id"/>

	<xsl:template match="/site">
		<xsl:for-each select="structure[show=1]">
			<xsl:apply-templates select="."/>
			<xsl:if test="/site/catalog_menu/root_structure_id = @id and count(/site/services_menu/section) &gt; 0">
				<xsl:apply-templates select="/site/services_menu" mode="mobile-item"/>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="structure">
		<xsl:variable name="link"><xsl:call-template name="get-link"/></xsl:variable>
		<xsl:variable name="is_catalog" select="/site/catalog_menu/root_structure_id = @id"/>
		<xsl:variable name="has_children" select="count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0"/>
		<xsl:variable name="is_active" select="$current_structure_id = @id or count(.//structure[@id=$current_structure_id]) = 1"/>

		<li>
			<xsl:attribute name="class">
				<xsl:text>mobile-nav__item</xsl:text>
				<xsl:if test="$is_active"><xsl:text> mobile-nav__item--active</xsl:text></xsl:if>
			</xsl:attribute>
			<xsl:choose>
				<xsl:when test="$is_catalog">
					<details class="mobile-nav__group">
						<summary class="mobile-nav__summary"><xsl:value-of select="/site/catalog_menu/title"/></summary>
						<div class="mobile-nav__panel">
							<p class="mobile-nav__label">Оборудование</p>
							<xsl:apply-templates select="/site/catalog_menu/shop" mode="mobile-shop"/>
							<xsl:if test="count(shop_group[show=1]) &gt; 0">
								<p class="mobile-nav__label">Бренды септиков</p>
								<div class="mobile-nav__links"><xsl:apply-templates select="shop_group[show=1]" mode="mobile-link"/></div>
							</xsl:if>
						</div>
					</details>
				</xsl:when>
				<xsl:when test="$has_children">
					<details class="mobile-nav__group">
						<summary class="mobile-nav__summary"><xsl:value-of select="name"/></summary>
						<div class="mobile-nav__panel mobile-nav__links">
							<xsl:apply-templates select="structure[show=1] | informationsystem_group[show=1] | informationsystem_item[show=1] | shop_group[show=1]" mode="mobile-link"/>
						</div>
					</details>
				</xsl:when>
				<xsl:otherwise>
					<a class="mobile-nav__link" href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure"><xsl:value-of select="name"/></a>
				</xsl:otherwise>
			</xsl:choose>
		</li>
	</xsl:template>

	<xsl:template match="services_menu" mode="mobile-item">
		<li class="mobile-nav__item">
			<details class="mobile-nav__group">
				<summary class="mobile-nav__summary"><xsl:value-of select="title"/></summary>
				<div class="mobile-nav__panel"><xsl:apply-templates select="section" mode="mobile-services"/></div>
			</details>
		</li>
	</xsl:template>

	<xsl:template match="section" mode="mobile-services">
		<div class="mobile-nav__section">
			<p class="mobile-nav__label"><xsl:value-of select="name"/></p>
			<div class="mobile-nav__links">
				<xsl:choose>
					<xsl:when test="count(item) &gt; 0"><xsl:apply-templates select="item" mode="mobile-service-link"/></xsl:when>
					<xsl:otherwise><a class="mobile-nav__sub-link" href="{link}"><xsl:value-of select="name"/></a></xsl:otherwise>
				</xsl:choose>
			</div>
		</div>
	</xsl:template>

	<xsl:template match="item" mode="mobile-service-link"><a class="mobile-nav__sub-link" href="{link}"><xsl:value-of select="name"/></a></xsl:template>

	<xsl:template match="shop" mode="mobile-shop">
		<a class="mobile-nav__shop-link" href="{link}">
			<span><xsl:value-of select="name"/></span>
			<xsl:if test="hint != ''"><small><xsl:value-of select="hint"/></small></xsl:if>
		</a>
	</xsl:template>

	<xsl:template match="structure | informationsystem_group | shop_group" mode="mobile-link">
		<xsl:variable name="link"><xsl:call-template name="get-link"/></xsl:variable>
		<a class="mobile-nav__sub-link" href="{$link}" title="{name}"><xsl:value-of select="name"/></a>
	</xsl:template>

	<xsl:template match="informationsystem_item" mode="mobile-link">
		<xsl:variable name="link"><xsl:call-template name="get-link"/></xsl:variable>
		<a class="mobile-nav__sub-link" href="{$link}" title="{name}">
			<xsl:choose>
				<xsl:when test="property_value[tag_name='city']/value != ''"><xsl:value-of select="property_value[tag_name='city']/value"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template name="get-link">
		<xsl:choose>
			<xsl:when test="type = 3 and url != ''"><xsl:value-of disable-output-escaping="yes" select="url"/></xsl:when>
			<xsl:when test="url != ''"><xsl:value-of disable-output-escaping="yes" select="url"/></xsl:when>
			<xsl:otherwise><xsl:value-of disable-output-escaping="yes" select="link"/></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
