<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://83">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
	encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml" />
	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>
	<!-- МагазинПрайс -->
	<xsl:template match="/shop">
		<!--xsl:apply-templates select="/shop/shop_item[shop_group_id = 0]"/-->

		<xsl:apply-templates select="//shop_group" mode="table">
			<xsl:sort select="@id" data-type="number" order="ascending"/>
		</xsl:apply-templates>


		<xsl:if test="total &gt; 0 and limit &gt; 0">
			<xsl:variable name="count_pages" select="ceiling(total div limit)"/>
			<xsl:variable name="visible_pages" select="5"/>
			<xsl:variable name="real_visible_pages"><xsl:choose>
					<xsl:when test="$count_pages &lt; $visible_pages"><xsl:value-of select="$count_pages"/></xsl:when>
					<xsl:otherwise><xsl:value-of select="$visible_pages"/></xsl:otherwise>
			</xsl:choose></xsl:variable>

			<!-- Links before current -->
			<xsl:variable name="pre_count_page"><xsl:choose>
					<xsl:when test="page - (floor($real_visible_pages div 2)) &lt; 0">
						<xsl:value-of select="page"/>
					</xsl:when>
					<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
						<xsl:value-of select="$real_visible_pages - ($count_pages - page - 1) - 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:choose>
							<xsl:when test="round($real_visible_pages div 2) = $real_visible_pages div 2">
								<xsl:value-of select="floor($real_visible_pages div 2) - 1"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="floor($real_visible_pages div 2)"/>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<!-- Links after current -->
			<xsl:variable name="post_count_page"><xsl:choose>
					<xsl:when test="0 &gt; page - (floor($real_visible_pages div 2) - 1)">
						<xsl:value-of select="$real_visible_pages - page - 1"/>
					</xsl:when>
					<xsl:when test="($count_pages - page - 1) &lt; floor($real_visible_pages div 2)">
						<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$real_visible_pages - $pre_count_page - 1"/>
					</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<xsl:variable name="i"><xsl:choose>
					<xsl:when test="page + 1 = $count_pages"><xsl:value-of select="page - $real_visible_pages + 1"/></xsl:when>
					<xsl:when test="page - $pre_count_page &gt; 0"><xsl:value-of select="page - $pre_count_page"/></xsl:when>
					<xsl:otherwise>0</xsl:otherwise>
			</xsl:choose></xsl:variable>

			<p>
				<xsl:call-template name="for">
					<xsl:with-param name="limit" select="limit"/>
					<xsl:with-param name="page" select="page"/>
					<xsl:with-param name="items_count" select="total"/>
					<xsl:with-param name="i" select="$i"/>
					<xsl:with-param name="post_count_page" select="$post_count_page"/>
					<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
					<xsl:with-param name="visible_pages" select="$real_visible_pages"/>
				</xsl:call-template>
			</p>
			<div style="clear: both"></div>
		</xsl:if>

		<script>
			<xsl:comment>
				<xsl:text disable-output-escaping="yes">
					<![CDATA[document.addEventListener ( "DOMContentLoaded", () => {var swiper=new Swiper ('#swiper-price. swiper',{slidesPerView:'auto',spaceBetween:0,centeredSlides:false,loop:false,scrollbar:{el:'#swiper-price. swiper-scrollbar',draggable:true,},});});]]>
				</xsl:text>
			</xsl:comment>
		</script>
	</xsl:template>

	<xsl:template match="shop_group">
		<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:if test="count(/shop/shop_item[shop_group_id=$id])">
			<tr class="total">
				<td colspan="2">
					<xsl:value-of select="name"/>
				</td>
			</tr>
			<xsl:apply-templates select="/shop/shop_item[shop_group_id = $id]"/>
		</xsl:if>
	</xsl:template>

	<xsl:template match="shop_group" mode="table">
		<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
		<div class="tbl-wrap">


			<xsl:if test="count(/shop/shop_item[shop_group_id=$id])">
				<h2 class="h-2">Цена септиков <xsl:value-of select="name"/></h2>
				<div class="tbl-row">
					<div class="tbl">
						<table>
							<thead>
								<tr>
									<td>&labelShopItemName;</td>
								</tr>
							</thead>
							<tbody>
								<xsl:apply-templates select="/shop/shop_item[shop_group_id = $id]" mode="name"/>
							</tbody>
						</table>
					</div>


					<div class="swiper-box" id="swiper-price">
						<div class="swiper swiper-container-initialized swiper-container-horizontal">
							<div class="swiper-wrapper">


								<div class="swiper-slide swiper-slide-active" style="width: 100%;">
									<div class="sw-tbl-head" style="min-height: 40px;">&labelShopItemPrice;</div>
									<div class="sw-tbl-body">
										<!--xsl:value-of select="name"/-->

										<xsl:apply-templates select="/shop/shop_item[shop_group_id = $id]" mode="price" />
									</div>
								</div>

							</div>
						</div>
						<span class="swiper-notification" aria-live="assertive" aria-atomic="true"></span>
						<div class="sw-btns-bl">
							<div class="swiper-scrollbar" style="display: none;"><div class="swiper-scrollbar-drag" style="transform: translate3d(0px, 0px, 0px); transition-duration: 0ms; width: 0px;"></div></div>
						</div>
				</div></div>
			</xsl:if>
		</div>
	</xsl:template>
	<xsl:template match="shop_item">
		<tr>
			<td>
				<a href="{url}"><xsl:value-of select="name"/></a>
			</td>
			<td>
				<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of select="currency"/>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="shop_item" mode="name">
		<tr>
			<td>
				<div class="h-4"><a href="{url}"><xsl:value-of select="name"/></a></div>
			</td>
		</tr>
	</xsl:template>
	<xsl:template match="shop_item" mode="price">
		<div class="sw-tr" style="min-height: 40px;">
			<xsl:apply-templates select="/shop/shop_currency/code">
				<xsl:with-param name="value" select="price" />
			</xsl:apply-templates>
		<!--xsl:value-of select="price"/><xsl:text> </xsl:text>₽<xsl:value-of select="currency"/--></div>

	</xsl:template>
	<!-- Pagination -->
	<xsl:template name="for">

		<xsl:param name="limit"/>
		<xsl:param name="page"/>
		<xsl:param name="pre_count_page"/>
		<xsl:param name="post_count_page"/>
		<xsl:param name="i" select="0"/>
		<xsl:param name="items_count"/>
		<xsl:param name="visible_pages"/>

		<xsl:variable name="n" select="ceiling($items_count div $limit)"/>

		<xsl:variable name="start_page"><xsl:choose>
				<xsl:when test="$page + 1 = $n"><xsl:value-of select="$page - $visible_pages + 1"/></xsl:when>
				<xsl:when test="$page - $pre_count_page &gt; 0"><xsl:value-of select="$page - $pre_count_page"/></xsl:when>
				<xsl:otherwise>0</xsl:otherwise>
		</xsl:choose></xsl:variable>

		<xsl:if test="$i = $start_page and $page != 0">
			<span class="ctrl">
				← Ctrl
			</span>
		</xsl:if>

		<xsl:if test="$i = ($page + $post_count_page + 1) and $n != ($page+1)">
			<span class="ctrl">
				Ctrl →
			</span>
		</xsl:if>

		<!-- Filter String -->
		<xsl:variable name="filter"><xsl:if test="/shop/filter/node()">?filter=1&amp;sorting=<xsl:value-of select="/shop/sorting"/>&amp;price_from=<xsl:value-of select="/shop/price_from"/>&amp;price_to=<xsl:value-of select="/shop/price_to"/><xsl:for-each select="/shop/*"><xsl:if test="starts-with(name(), 'property_')">&amp;<xsl:value-of select="name()"/>=<xsl:value-of select="."/></xsl:if></xsl:for-each></xsl:if></xsl:variable>

		<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">
			<!-- Store in the variable $group ID of the current group -->
			<xsl:variable name="group" select="/shop/group"/>

			<!-- Tag Path -->
			<xsl:variable name="tag_path"><xsl:if test="count(/shop/tag) != 0">tag/<xsl:value-of select="/shop/tag/urlencode"/>/</xsl:if></xsl:variable>

			<!-- Compare Product Path -->
			<xsl:variable name="shop_producer_path"><xsl:if test="count(/shop/shop_producer)">producer-<xsl:value-of select="/shop/shop_producer/@id"/>/</xsl:if></xsl:variable>

			<!-- Choose Group Path -->
			<xsl:variable name="group_link"><xsl:choose><xsl:when test="$group != 0"><xsl:value-of select="/shop//shop_group[@id=$group]/url"/></xsl:when><xsl:otherwise><xsl:value-of select="/shop/url"/>price/</xsl:otherwise></xsl:choose></xsl:variable>

			<!-- Set $link variable -->
			<xsl:variable name="number_link"><xsl:if test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:if></xsl:variable>

			<!-- First pagination item -->
			<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
				<a href="{$group_link}{$tag_path}{$shop_producer_path}{$filter}" class="page_link" style="text-decoration: none;">←</a>
			</xsl:if>

			<!-- Pagination item -->
			<xsl:if test="$i != $page">
				<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
					<!-- Pagination item -->
					<a href="{$group_link}{$number_link}{$tag_path}{$shop_producer_path}{$filter}" class="page_link">
						<xsl:value-of select="$i + 1"/>
					</a>
				</xsl:if>

				<!-- Last pagination item -->
				<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
					<!-- Last pagination item -->
					<a href="{$group_link}page-{$n}/{$tag_path}{$shop_producer_path}{$filter}" class="page_link" style="text-decoration: none;">→</a>
				</xsl:if>
			</xsl:if>

			<!-- Ctrl+left link -->
			<xsl:if test="$page != 0 and $i = $page"><xsl:variable name="prev_number_link"><xsl:if test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:if></xsl:variable><a href="{$group_link}{$prev_number_link}{$tag_path}{$shop_producer_path}{$filter}" id="id_prev"></a></xsl:if>

			<!-- Ctrl+right link -->
			<xsl:if test="($n - 1) > $page and $i = $page">
				<a href="{$group_link}page-{$page+2}/{$tag_path}{$shop_producer_path}{$filter}" id="id_next"></a>
			</xsl:if>

			<!-- Current pagination item -->
			<xsl:if test="$i = $page">
				<span class="current">
					<xsl:value-of select="$i+1"/>
				</span>
			</xsl:if>

			<!-- Recursive Template -->
			<xsl:call-template name="for">
				<xsl:with-param name="i" select="$i + 1"/>
				<xsl:with-param name="limit" select="$limit"/>
				<xsl:with-param name="page" select="$page"/>
				<xsl:with-param name="items_count" select="$items_count"/>
				<xsl:with-param name="pre_count_page" select="$pre_count_page"/>
				<xsl:with-param name="post_count_page" select="$post_count_page"/>
				<xsl:with-param name="visible_pages" select="$visible_pages"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	<xsl:template match="shop_currency/code">
		<xsl:param name="value" />

		<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

		<xsl:choose>
			<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'RUB'"> <xsl:value-of select="$spaced"/><xsl:text> </xsl:text>₽</xsl:when>
			<xsl:when test=". = 'RUR'"> <xsl:value-of select="$spaced"/><xsl:text> </xsl:text>₽</xsl:when>
			<xsl:when test=". = 'AUD'">AU$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'CNY'"><xsl:value-of select="$spaced"/>元</xsl:when>
			<xsl:when test=". = 'JPY'"><xsl:value-of select="$spaced"/>¥</xsl:when>
			<xsl:when test=". = 'KRW'"><xsl:value-of select="$spaced"/>₩</xsl:when>
			<xsl:when test=". = 'PHP'"><xsl:value-of select="$spaced"/>₱</xsl:when>
			<xsl:when test=". = 'THB'"><xsl:value-of select="$spaced"/>฿</xsl:when>
			<xsl:when test=". = 'BRL'">R$<xsl:value-of select="$spaced"/></xsl:when>
			<xsl:when test=". = 'INR'"><xsl:value-of select="$spaced"/><i class="fa fa-inr"></i></xsl:when>
			<xsl:when test=". = 'TRY'"><xsl:value-of select="$spaced"/><i class="fa fa-try"></i></xsl:when>
			<xsl:when test=". = 'ILS'"><xsl:value-of select="$spaced"/><i class="fa fa-ils"></i></xsl:when>
			<xsl:otherwise><xsl:value-of select="$spaced"/> <xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>