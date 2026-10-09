<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://3">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">

	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	<!-- СписокЭлементовИнфосистемы -->

	<xsl:template match="/">
		<xsl:apply-templates select="/informationsystem | /shop"/>
	</xsl:template>

	<xsl:template name="geo-city">
<xsl:choose>
<xsl:when test="property_value[tag_name='city']/value != ''"><xsl:value-of select="property_value[tag_name='city']/value"/></xsl:when>
<xsl:when test="contains(name, 'Зеленоград')">Зеленоград</xsl:when>
<xsl:when test="contains(name, 'Москв')">Москва</xsl:when>
<xsl:when test="contains(name, 'Истр')">Истра</xsl:when>
<xsl:when test="contains(name, 'Химк')">Химки</xsl:when>
<xsl:when test="contains(name, 'Красногорск')">Красногорск</xsl:when>
<xsl:when test="contains(name, 'Солнечногорск')">Солнечногорск</xsl:when>
<xsl:when test="contains(name, 'Клин')">Клин</xsl:when>
<xsl:when test="contains(name, 'Звенигород')">Звенигород</xsl:when>
<xsl:when test="contains(name, 'Лобн')">Лобня</xsl:when>
<xsl:when test="contains(name, 'Дмитров')">Дмитров</xsl:when>
<xsl:when test="contains(name, 'Волоколамск')">Волоколамск</xsl:when>
<xsl:when test="contains(name, 'Корол')">Королёв</xsl:when>
<xsl:when test="contains(name, 'Долгопрудн')">Долгопрудный</xsl:when>
<xsl:when test="contains(name, ' в ')"><xsl:value-of select="substring-after(name, ' в ')"/></xsl:when>
<xsl:otherwise><xsl:value-of select="name"/></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:variable name="n" select="number(3)"/>

	<xsl:template name="strip-html">
		<xsl:param name="text"/>
		<xsl:choose>
			<xsl:when test="contains($text, '&lt;')">
				<xsl:value-of select="substring-before($text, '&lt;')"/>
				<xsl:variable name="afterOpen" select="substring-after($text, '&lt;')"/>
				<xsl:choose>
					<xsl:when test="contains($afterOpen, '&gt;')">
						<xsl:call-template name="strip-html">
							<xsl:with-param name="text" select="substring-after($afterOpen, '&gt;')"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$afterOpen"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="/informationsystem | /shop">

		<div class="container">

			<div class="section-title-block">
				<span class="section-title-block__tag">Рядом с вами</span>
				<h2 class="section-title-block__title">Районы обслуживания в Зеленограде и Московской области</h2>
				<p class="section-title-block__desc">Выберите населённый пункт, чтобы посмотреть направление работ и обсудить выезд специалиста.</p>
			</div>

			<div class="geography-section__grid">

				<div class="geography-section__list-box">
					<p class="geography-section__list-title">
						Выберите ваш населенный пункт:
					</p>
					<ul class="geography-section__list js-geography-list">
						<xsl:apply-templates select="informationsystem_item | shop_item" mode="geo-button"/>
					</ul>
				</div>

				<div class="geography-section__details-box js-geography-details-box">
					<xsl:apply-templates select="informationsystem_item | shop_item" mode="geo-panel"/>
					<div class="geography-map">
						<h3 class="geography-map__title">Карта района обслуживания</h3>
						<div class="geography-map__container">
							<div id="zelseptik-map" class="geography-map__iframe"></div>
							<div class="geography-map__legend">
								<div class="geography-map__legend-pulse"></div>
								<div>
									<span class="geography-map__legend-title">ЗЕЛСЕПТИК</span>
									<span class="geography-map__legend-desc">г. Зеленоград, ул. Летчицы Тарасовой, к. 2024</span>
								</div>
							</div>
						</div>
					</div>
				</div>

			</div>

		</div>

	</xsl:template>
	<xsl:template match="informationsystem_item | shop_item" mode="geo-button">
		<xsl:variable name="cleanDescription">
			<xsl:call-template name="strip-html">
				<xsl:with-param name="text" select="description"/>
			</xsl:call-template>
		</xsl:variable>

		<li class="geography-section__item" role="presentation">
			<button type="button">
				<xsl:attribute name="id">geo-tab-<xsl:value-of select="@id"/></xsl:attribute>
				<xsl:attribute name="aria-controls">geo-panel-<xsl:value-of select="@id"/></xsl:attribute>
				<xsl:attribute name="class">
					<xsl:text>geography-section__city-btn js-geo-btn js-geo-tab</xsl:text>
					<xsl:if test="position() = 1">
						<xsl:text> geography-section__city-btn--active</xsl:text>
					</xsl:if>
				</xsl:attribute>

				<xsl:attribute name="data-city">
					<xsl:call-template name="geo-city"/>
				</xsl:attribute>

				<div>
					<span class="geography-section__city-btn-name">
						<xsl:call-template name="geo-city"/>
					</span>

					<span class="geography-section__city-btn-districts">
						<xsl:value-of select="substring(normalize-space(string($cleanDescription)), 1, 50)"/>
						<xsl:if test="string-length(normalize-space(string($cleanDescription))) &gt; 50"><xsl:text>...</xsl:text></xsl:if>
					</span>
				</div>
			</button>
		</li>
	</xsl:template>

	<xsl:template match="informationsystem_item | shop_item" mode="geo-panel">
		<div>
			<xsl:attribute name="id">geo-panel-<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="aria-labelledby">geo-tab-<xsl:value-of select="@id"/></xsl:attribute>
			<xsl:attribute name="class">
				<xsl:text>geography-details js-geography-details js-geo-panel</xsl:text>
				<xsl:if test="position() = 1">
					<xsl:text> geography-details--active</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<xsl:attribute name="data-city">
				<xsl:call-template name="geo-city"/>
			</xsl:attribute>

			<div class="geography-details__header">
				<div class="geography-details__title-box">
					<h3 class="geography-details__title">
						<xsl:value-of select="name"/>
					</h3>

					<div class="geography-details__sub">
						<xsl:choose>
<xsl:when test="self::shop_item">
<p>Обслуживание и ремонт септика. Уточним модель станции, состояние оборудования и состав работ перед выездом.</p>
<a class="btn btn--secondary" href="{url}">Подробнее об обслуживании</a>
</xsl:when>
<xsl:otherwise><xsl:value-of select="description" disable-output-escaping="yes"/></xsl:otherwise>
</xsl:choose>
					</div>
				</div>
			</div>

			<div class="geography-details__advice">
				<h4 class="geography-details__advice-title">
					<xsl:text>Перед выездом уточним:</xsl:text>
				</h4>

				<p class="geography-details__advice-text">
					<xsl:text>Адрес, задачу, модель станции и доступ к участку. Необходимость осмотра определит специалист.</xsl:text>
				</p>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
