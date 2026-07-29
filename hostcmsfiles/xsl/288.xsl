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

		<xsl:value-of disable-output-escaping="yes" select="description"/>

		<div class="faq-section__accordion js-faq-accordion">
			<xsl:apply-templates select="informationsystem_item"/>
		</div>

	</xsl:template>

	<xsl:template match="informationsystem_item">
		<div>
			<xsl:attribute name="class">
				<xsl:text>faq-item js-faq-item</xsl:text>
				<xsl:if test="position() = 1">
					<xsl:text> faq-item--open</xsl:text>
				</xsl:if>
			</xsl:attribute>

			<button class="faq-item__header js-faq-header" type="button">
				<xsl:attribute name="data-index">
					<xsl:value-of select="position() - 1"/>
				</xsl:attribute>

				<xsl:attribute name="aria-expanded">
					<xsl:choose>
						<xsl:when test="position() = 1">true</xsl:when>
						<xsl:otherwise>false</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>

				<span class="faq-item__question">
					<xsl:value-of select="name"/>
				</span>

				<span class="faq-item__icon">▼</span>
			</button>

			<div class="faq-item__content">
				<xsl:if test="position() = 1">
					<xsl:attribute name="style">max-height: 400px; opacity: 1;</xsl:attribute>
				</xsl:if>

				<div class="faq-item__content-inner">
					<div class="faq-item__answer">
						<xsl:value-of disable-output-escaping="yes" select="description"/>
					</div>

					<div class="faq-item__author">
						<div class="faq-item__author-avatar">Р</div>

						<span class="faq-item__author-info">
							<xsl:text>Ответил: </xsl:text>
							<strong>Роман Б.</strong>
							<xsl:text>, шеф-монтажник «ЗЕЛСЕПТИК»</xsl:text>
						</span>
					</div>
				</div>
			</div>
		</div>
	</xsl:template>

</xsl:stylesheet>