<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://288">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">

	<xsl:output
		xmlns="http://www.w3.org/TR/xhtml1/strict"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		encoding="utf-8"
		indent="yes"
		method="html"
		omit-xml-declaration="no"
		version="1.0"
	media-type="text/xml"/>

	<xsl:template match="/">
		<div class="container">
			<xsl:apply-templates select="/informationsystem"/>
		</div>
	</xsl:template>

	<xsl:template match="/informationsystem">

		<xsl:if test="message/node()">
			<div id="message">
				<xsl:value-of disable-output-escaping="yes" select="message"/>
			</div>
		</xsl:if>

		<xsl:if test="error/node()">
			<div id="error">
				<xsl:value-of select="error"/>
			</div>
		</xsl:if>

		<div class="section-title-block">
			<span class="section-title-block__tag">Часто задаваемые вопросы</span>
			<h2 class="section-title-block__title">Коротко о заказе и монтаже</h2>
			<p class="section-title-block__desc">Условия по конкретному участку, модели и адресу специалист подтвердит при расчёте.</p>
		</div>

		<div class="faq-section__accordion">
			<xsl:apply-templates select="informationsystem_item"/>
		</div>

	</xsl:template>

	<xsl:template match="informationsystem_item">
		<details class="faq-item">
			<xsl:if test="position() = 1"><xsl:attribute name="open">open</xsl:attribute></xsl:if>

			<summary class="faq-item__header">

				<span class="faq-item__question">
					<xsl:value-of select="name"/>
				</span>

				<span class="faq-item__icon" aria-hidden="true">▼</span>
			</summary>

			<div class="faq-item__content">
				<div class="faq-item__content-inner">
					<div class="faq-item__answer">
						<xsl:choose>
							<xsl:when test="@id = 168">
								<p>Доступные способы и порядок оплаты указываются в договоре или счёте. Менеджер подтвердит условия для выбранного оборудования и работ.</p>
							</xsl:when>
							<xsl:when test="@id = 169">
								<p>Стоимость и срок доставки зависят от адреса, модели станции и состава заказа. Расчёт логистики выполняется по этим данным.</p>
							</xsl:when>
							<xsl:when test="@id = 170">
								<p>Гарантийные условия зависят от производителя оборудования и состава выполненных работ. Конкретные сроки фиксируются в договоре и передаваемых документах.</p>
							</xsl:when>
							<xsl:when test="@id = 171">
								<p>Для высокого уровня грунтовых вод подбирают герметичную станцию и подходящий способ отвода очищенной воды. Решение уточняют по условиям участка.</p>
							</xsl:when>
							<xsl:when test="@id = 172">
								<p>Состав монтажа зависит от модели станции, глубины подводящей трубы, грунта, уровня воды и способа отвода. Плановая смета формируется по результатам расчёта.</p>
							</xsl:when>
							<xsl:when test="@id = 173">
								<p>Учитываем число жителей, режим проживания, залповый сброс, грунт, уровень воды и точку отвода. После этого сравниваем подходящие модели и состав монтажа.</p>
							</xsl:when>
							<xsl:otherwise>
								<p>Условия по конкретному участку и оборудованию специалист уточнит при расчёте.</p>
							</xsl:otherwise>
						</xsl:choose>
					</div>
				</div>
			</div>
		</details>
	</xsl:template>

</xsl:stylesheet>
