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
		<div class="h-2">Вопросы, которые часто задают</div>
		<div class="swiper-box sw-questions" id="swiper-que">
			<div class="swiper">
				<div class="swiper-wrapper">
					<xsl:apply-templates select="informationsystem_item"/>
				</div>
			</div>
			<div class="sw-btns-bl">
				<div class="swiper-button prev"></div>
				<!--div class="swiper-pagination"></div-->
			<div class="swiper-button next"></div>
		</div>
		
	</div>
	
</xsl:template>

<!-- informationsystem_item template -->
<xsl:template match="informationsystem_item">
	<div class="swiper-slide">
		<div class="quest-bl">
			<div class="q-head">
			<div class="h-3"><xsl:value-of select="name"/></div><span class="q-btn"></span>
			</div>
			<div class="q-body">
				<xsl:value-of disable-output-escaping="yes" select="description"/>
			</div>
		</div>
	</div>
</xsl:template>

</xsl:stylesheet>