<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://6">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<!-- СписокУслугНаГлавной -->
	<xsl:decimal-format name="ru" decimal-separator="," grouping-separator=" "/>
	<xsl:template match="/">

		<div class="container">

			<xsl:value-of select="/informationsystem/description" disable-output-escaping="yes"/>

			<!-- Case Selection Tabs -->
			<div class="cases-section__tabs js-cases-tabs">
				<xsl:apply-templates select="/informationsystem/informationsystem_item" mode="button"/>
			</div>

			<div class="cases-section__content">
				<xsl:apply-templates select="/informationsystem/informationsystem_item"/>
			</div>

		</div>

	</xsl:template>


	<xsl:template match="informationsystem_item" mode="button">

		<button data-index="{@id}" type="button">
			<xsl:attribute name="class">
				<xsl:text>cases-section__tab js-case-tab</xsl:text>
				<xsl:if test="position() = 1"><xsl:text> cases-section__tab--active</xsl:text></xsl:if>
			</xsl:attribute>
			<xsl:value-of select="name"/>
		</button>

	</xsl:template>


	<xsl:template match="informationsystem_item">
		<div data-index="{@id}">
			<xsl:attribute name="class">
				<xsl:text>cases-section__card js-case-card</xsl:text>

				<xsl:if test="position() = 1">
					<xsl:text> cases-section__card--active</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<div class="cases-section__card-grid">
				<div class="cases-section__media">
					<div class="cases-section__img-box">
						<img alt="{name}" class="cases-section__img" decoding="async" loading="lazy" src="{dir}{image_large}" />
						<div class="cases-section__badge">Выполненный монтаж</div>
					</div>
					<div class="cases-section__specs">
						<div class="cases-section__spec-item"><span class="cases-section__spec-label">
								Локация:
								</span><span class="cases-section__spec-value">
								<xsl:if test="property_value[tag_name='location']/value !=''">
									<xsl:value-of select="property_value[tag_name='location']/value"/>
								</xsl:if>
							</span>
						</div>
						<div class="cases-section__spec-item"><span class="cases-section__spec-label">Станция:</span><span class="cases-section__spec-value">
								<xsl:if test="property_value[tag_name='station']/value !=''">
									<xsl:value-of select="property_value[tag_name='station']/value"/>
								</xsl:if>
								<xsl:choose>
									<xsl:when test="property_value[tag_name='nasos']/value !=''">
										<xsl:text> Принудительная</xsl:text>
									</xsl:when>
									<xsl:otherwise>
										<xsl:text> Самотечная</xsl:text>
									</xsl:otherwise>
								</xsl:choose>
						</span></div>

						<div class="cases-section__spec-item cases-section__spec-item--border-t"><span class="cases-section__spec-label">Грунт:</span>
							<span class="cases-section__spec-value">
								<xsl:if test="property_value[tag_name='soil']/value !=''">
									<xsl:value-of select="property_value[tag_name='soil']/value"/>
								</xsl:if>
							</span>
						</div>

						<div class="cases-section__spec-item cases-section__spec-item--border-t">
							<span class="cases-section__spec-label">Длительность:</span>
							<span class="cases-section__spec-value">
								<xsl:if test="property_value[tag_name='time']/value !=''">
									<xsl:value-of select="property_value[tag_name='time']/value"/>
							</xsl:if> часов</span>
						</div>
					</div>
				</div>

				<div class="cases-section__review">

					<xsl:if test="property_value[tag_name='time']/value !='' and property_value[tag_name='quote-text']/value">
						<div class="cases-section__quote-header">
							<span class="cases-section__quote-sign">“</span>
							<h3 class="cases-section__quote-title">
							Монтаж станции за <xsl:value-of select="property_value[tag_name='time']/value"/> часов</h3>
						</div>
						<div class="cases-section__quote-text"><xsl:value-of select="property_value[tag_name='quote-text']/value"/></div>
					</xsl:if>
					<xsl:if test="property_value[tag_name='client']/value !=''">
						<div class="cases-section__client">
							<div class="cases-section__avatar">
								<xsl:value-of select="substring(normalize-space(property_value[tag_name='client']/value),1,1)"/>
							</div>
							<div class="cases-section__client-info">
								<h4 class="cases-section__client-name">
									<xsl:value-of select="property_value[tag_name='client']/value"/>
								</h4>
							<span class="cases-section__client-status">Отзыв о выполненной работе</span></div>
						</div>
					</xsl:if>
					<xsl:if test="property_value[tag_name='price']/value !=''">
						<div class="cases-section__footer">
							<div class="cases-section__price-box"><span class="cases-section__price-label">Итоговая стоимость:</span>
								<span class="cases-section__price-value">
								<xsl:value-of select="format-number(property_value[tag_name='price']/value, '# ##0', 'ru')"/><xsl:text> ₽</xsl:text></span></div>
							<button type="button" class="cases-section__btn js-btn-case-cta" data-model="{property_value[tag_name='station']/value}">Рассчитать похожий монтаж</button>
						</div>
					</xsl:if>
				</div>

			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>
