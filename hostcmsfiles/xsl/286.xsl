<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://3">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">

	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>
	<!-- СписокЭлементовИнфосистемы -->

	<xsl:template match="/">
		<xsl:apply-templates select="/informationsystem"/>
	</xsl:template>

	<xsl:variable name="n" select="number(3)"/>

	<xsl:template match="/informationsystem">

		<div class="container">

			<xsl:value-of select="description" disable-output-escaping="yes"/>

			<div class="geography-section__grid">

				<div class="geography-section__list-box">
					<h4 class="geography-section__list-title">
						Выберите ваш населенный пункт:
					</h4>
					<ul class="geography-section__list js-geography-list">
						<xsl:apply-templates select="informationsystem_item" mode="geo-button"/>
					</ul>
				</div>

				<div class="geography-section__details-box js-geography-details-box">
					<xsl:apply-templates select="informationsystem_item" mode="geo-panel"/>
				</div>

			</div>

		</div>

	</xsl:template>
	<xsl:template match="informationsystem_item" mode="geo-button">
		<li class="geography-section__item">
			<button type="button">
				<xsl:attribute name="class">
					<xsl:text>geography-section__city-btn js-geo-btn js-geo-tab</xsl:text>
					<xsl:if test="position() = 1">
						<xsl:text> geography-section__city-btn--active</xsl:text>
					</xsl:if>
				</xsl:attribute>

				<xsl:attribute name="data-city">
					<xsl:choose>
						<xsl:when test="property_value[tag_name='city']/value != ''">
							<xsl:value-of select="property_value[tag_name='city']/value"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="name" />
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

				<div>
					<span class="geography-section__city-btn-name">
						<xsl:choose>
							<xsl:when test="property_value[tag_name='city']/value != ''">
								<xsl:value-of select="property_value[tag_name='city']/value"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="name"/>
							</xsl:otherwise>
						</xsl:choose>
					</span>

					<span class="geography-section__city-btn-districts">
						<xsl:value-of select="substring(normalize-space(description), 1, 50)" disable-output-escaping="yes"/><xsl:text>...</xsl:text>
					</span>
				</div>

				<div class="geography-section__city-btn-badge-box">
					<span class="geography-section__city-btn-badge">
						<xsl:choose>
							<xsl:when test="position() = 1">
								<xsl:text>100 км</xsl:text>
							</xsl:when>
							<xsl:otherwise>
								<xsl:text>50 км</xsl:text>
							</xsl:otherwise>
						</xsl:choose>
					</span>
				</div>
			</button>
		</li>
	</xsl:template>

	<xsl:template match="informationsystem_item" mode="geo-panel">
		<div>
			<xsl:attribute name="class">
				<xsl:text>geography-details js-geography-details js-geo-panel</xsl:text>
				<xsl:if test="position() = 1">
					<xsl:text> geography-details--active</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<xsl:attribute name="data-city">
				<xsl:choose>
					<xsl:when test="property_value[tag_name='city']/value != ''">
						<xsl:value-of select="property_value[tag_name='city']/value"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="name"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>

			<div class="geography-details__header">
				<div class="geography-details__title-box">
					<h3 class="geography-details__title">
						<xsl:value-of select="name"/>
					</h3>

					<p class="geography-details__sub">
						<xsl:value-of select="description" disable-output-escaping="yes"/>
					</p>
				</div>

				<span class="geography-details__badge">
					<xsl:text>Сдано объектов: 142</xsl:text>
				</span>
			</div>

			<div class="geography-details__advice">
				<h5 class="geography-details__advice-title">
					<xsl:text>Совет инженера:</xsl:text>
				</h5>

				<p class="geography-details__advice-text">
					<xsl:text>Рекомендуется бесплатный выезд инженера для оценки грунта, уровня грунтовых вод и точки сброса очищенной воды.</xsl:text>
				</p>
			</div>

			<div class="geography-map">
				<h4 class="geography-map__title">
					<xsl:text>Карта района обслуживания:</xsl:text>
				</h4>

				<div class="geography-map__container">
					<xsl:if test="position() = 1">
						<div id="zelseptik-map" class="geography-map__iframe"></div>
					</xsl:if>

					<div class="geography-map__overlay">
						<div>
							<xsl:attribute name="class">
								<xsl:text>geography-map__circle </xsl:text>
								<xsl:choose>
									<xsl:when test="position() = 1">
										<xsl:text>geography-map__circle--100km</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text>geography-map__circle--50km</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
							</xsl:attribute>

							<span class="geography-map__circle-label">
								<xsl:text>Радиус обслуживания </xsl:text>

							</span>
						</div>
					</div>

					<div class="geography-map__legend">
						<div class="geography-map__legend-pulse"></div>
						<div>
							<span class="geography-map__legend-title">Склад и офис ЗелСептик</span>
							<span class="geography-map__legend-desc">г. Зеленоград, ул. Летчицы Тарасовой, к. 2024</span>
						</div>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>