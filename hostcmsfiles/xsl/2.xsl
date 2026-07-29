<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://2">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- ВерхнееМеню -->

	<xsl:variable name="current_structure_id" select="/site/current_structure_id"/>

	<xsl:template match="/site">
		<ul class="nav-menu__list js-nav-menu-list" itemprop="about" itemscope="" itemtype="http://schema.org/ItemList">
			<xsl:for-each select="structure[show=1]">
				<xsl:apply-templates select="." />
				<xsl:if test="/site/catalog_menu/root_structure_id = @id and count(/site/services_menu/section) &gt; 0">
					<xsl:apply-templates select="/site/services_menu" mode="nav-item" />
				</xsl:if>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template match="structure">
		<xsl:variable name="link">
			<xsl:call-template name="get-link"/>
		</xsl:variable>
		<xsl:variable name="is_catalog" select="/site/catalog_menu/root_structure_id = @id"/>
		<xsl:variable name="has_children" select="count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0"/>
		<xsl:variable name="has_column_groups" select="count(structure[show=1][count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0]) &gt; 0"/>
		<xsl:variable name="is_active" select="$current_structure_id = @id or count(.//structure[@id=$current_structure_id]) = 1"/>

		<li itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem">
			<xsl:attribute name="class">
				<xsl:text>nav-menu__item</xsl:text>
				<xsl:if test="$is_active">
					<xsl:text> nav-menu__item--active</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<xsl:choose>
				<xsl:when test="$is_catalog">
					<button type="button" class="nav-menu__link js-nav-link nav-menu__trigger" data-section="{name}">
						<xsl:value-of select="/site/catalog_menu/title"/>
					</button>
				</xsl:when>
				<xsl:otherwise>
					<a href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="structure" itemprop="url" data-section="{name}">
						<xsl:attribute name="class">
							<xsl:text>nav-menu__link js-nav-link</xsl:text>
							<xsl:if test="$has_children">
								<xsl:text> nav-menu__trigger</xsl:text>
							</xsl:if>
							<xsl:if test="$is_active">
								<xsl:text> nav-menu__link--active</xsl:text>
							</xsl:if>
						</xsl:attribute>
						<xsl:value-of select="name"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>

			<xsl:if test="$has_children or $is_catalog">
				<div class="mega-menu">
					<div class="mega-menu__grid">
						<xsl:choose>
							<xsl:when test="$is_catalog">
								<div class="mega-menu__column">
									<p class="mega-menu__title">Оборудование</p>
									<xsl:apply-templates select="/site/catalog_menu/shop" mode="catalog-shop" />
								</div>
								<xsl:call-template name="default-mega-columns"/>
							</xsl:when>
							<xsl:when test="$has_column_groups">
								<xsl:apply-templates select="structure[show=1][count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0]" mode="mega-column" />
								<xsl:apply-templates select="structure[show=1][not(count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0)]" mode="mega-flat-column" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:call-template name="default-mega-columns"/>
							</xsl:otherwise>
						</xsl:choose>
						<xsl:call-template name="mega-featured"/>
					</div>
				</div>
			</xsl:if>

			<meta itemprop="name" content="{name}" />
		</li>
	</xsl:template>

	<xsl:template match="services_menu" mode="nav-item">
		<li class="nav-menu__item nav-menu__item--services" itemprop="itemListElement" itemscope="" itemtype="http://schema.org/ListItem">
			<button type="button" class="nav-menu__link js-nav-link nav-menu__trigger" data-section="{title}">
				<xsl:value-of select="title"/>
			</button>
			<div class="mega-menu">
				<div class="mega-menu__grid">
					<xsl:apply-templates select="section" mode="services-section" />
					<xsl:call-template name="mega-featured"/>
				</div>
			</div>
			<meta itemprop="name" content="{title}" />
		</li>
	</xsl:template>

	<xsl:template match="section" mode="services-section">
		<div class="mega-menu__column">
			<p class="mega-menu__title">
				<xsl:value-of select="name"/>
			</p>
			<xsl:choose>
				<xsl:when test="count(item) &gt; 0">
					<xsl:apply-templates select="item" mode="services-item" />
				</xsl:when>
				<xsl:otherwise>
					<a class="mega-menu__link" href="{link}">
						<xsl:value-of select="name"/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>

	<xsl:template match="item" mode="services-item">
		<a class="mega-menu__link" href="{link}">
			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

	<xsl:template match="shop" mode="catalog-shop">
		<a class="mega-menu__link" href="{link}">
			<xsl:value-of select="name"/>
			<xsl:if test="hint != ''">
				<span>
					<xsl:value-of select="hint"/>
				</span>
			</xsl:if>
		</a>
	</xsl:template>

	<xsl:template match="structure" mode="mega-column">
		<div class="mega-menu__column">
			<p class="mega-menu__title">
				<xsl:value-of select="name"/>
			</p>
			<xsl:apply-templates select="structure[show=1]" mode="mega" />
			<xsl:apply-templates select="informationsystem_group[show=1]" mode="mega" />
			<xsl:apply-templates select="shop_group[show=1]" mode="mega" />
			<xsl:apply-templates select="informationsystem_item[show=1]" mode="mega" />
		</div>
	</xsl:template>

	<xsl:template match="structure" mode="mega-flat-column">
		<xsl:if test="position() = 1">
			<div class="mega-menu__column">
				<p class="mega-menu__title">Разделы</p>
				<xsl:apply-templates select="../structure[show=1][not(count(structure[show=1]) + count(informationsystem_item[show=1]) + count(informationsystem_group[show=1]) + count(shop_group[show=1]) &gt; 0)]" mode="mega" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="default-mega-columns">
		<xsl:if test="count(structure[show=1]) &gt; 0">
			<div class="mega-menu__column">
				<p class="mega-menu__title">Разделы</p>
				<xsl:apply-templates select="structure[show=1]" mode="mega" />
			</div>
		</xsl:if>
		<xsl:if test="count(informationsystem_group[show=1]) &gt; 0">
			<div class="mega-menu__column">
				<p class="mega-menu__title">Темы</p>
				<xsl:apply-templates select="informationsystem_group[show=1]" mode="mega" />
			</div>
		</xsl:if>
		<xsl:if test="count(shop_group[show=1]) &gt; 0">
			<xsl:choose>
				<xsl:when test="count(shop_group[show=1]) &gt; 8">
					<div class="mega-menu__column">
						<p class="mega-menu__title">Каталог</p>
						<xsl:apply-templates select="shop_group[show=1][position() &lt;= ceiling(count(../shop_group[show=1]) div 2)]" mode="mega" />
					</div>
					<div class="mega-menu__column">
						<p class="mega-menu__title">Бренды</p>
						<xsl:apply-templates select="shop_group[show=1][position() &gt; ceiling(count(../shop_group[show=1]) div 2)]" mode="mega" />
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="mega-menu__column">
						<p class="mega-menu__title">Каталог</p>
						<xsl:apply-templates select="shop_group[show=1]" mode="mega" />
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:if>
		<xsl:if test="count(informationsystem_item[show=1]) &gt; 0">
			<div class="mega-menu__column">
				<p class="mega-menu__title">Материалы</p>
				<xsl:apply-templates select="informationsystem_item[show=1]" mode="mega" />
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="mega-featured">
		<div class="mega-menu__featured">
			<div>
				<p class="mega-menu__title">Подбор</p>
				<h3>Не знаете модель?</h3>
				<p>Ответьте на несколько вопросов, и инженер подскажет подходящее решение.</p>
			</div>
			<a class="btn btn-primary btn--sm" href="/septiki/#catalog-picker">Подобрать</a>
		</div>
	</xsl:template>

	<xsl:template match="structure | informationsystem_group | shop_group" mode="mega">
		<xsl:variable name="link">
			<xsl:call-template name="get-link"/>
		</xsl:variable>
		<a class="mega-menu__link" href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name">
			<xsl:value-of select="name"/>
		</a>
	</xsl:template>

	<xsl:template match="informationsystem_item" mode="mega">
		<xsl:variable name="link">
			<xsl:call-template name="get-link"/>
		</xsl:variable>
		<a class="mega-menu__link" href="{$link}" title="{name}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="informationsystem_item">
			<xsl:choose>
				<xsl:when test="property_value[tag_name='city']/value != ''">
					<xsl:value-of select="property_value[tag_name='city']/value"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="name"/>
				</xsl:otherwise>
			</xsl:choose>
		</a>
	</xsl:template>

	<xsl:template name="get-link">
		<xsl:choose>
			<xsl:when test="type = 3 and url != ''">
				<xsl:value-of disable-output-escaping="yes" select="url"/>
			</xsl:when>
			<xsl:when test="url != ''">
				<xsl:value-of disable-output-escaping="yes" select="url"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of disable-output-escaping="yes" select="link"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
