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
		<section class="area-category no-bg">
			<div class="page-bl">

				<!-- Store parent id in a variable -->
				<xsl:variable name="group" select="group"/>
				<div class="txt">
					<h2 class="cities-title">Работаем по Московской области</h2>
				</div>


				<div class="quiz_parent">

					<div class="cities-content">
						<ul class="cities-list">
							<xsl:apply-templates select="informationsystem_item"/>
					</ul>	</div>

				</div>


			</div>
		</section>
	</xsl:template>

	<!-- Show property item -->
	<xsl:template match="property">
		<tr>
			<td style="padding: 5px" bgcolor="#eeeeee">
				<b><xsl:value-of select="name"/></b>
			</td>
			<td style="padding: 5px" bgcolor="#eeeeee">
				<xsl:choose>
					<xsl:when test="type = 1">
						<a href="{file_path}">&labelDownloadFile;</a>
					</xsl:when>
					<xsl:when test="type = 7">
						<xsl:choose>
							<xsl:when test="value = 1">
								<input type="checkbox" checked="" disabled="" />
							</xsl:when>
							<xsl:otherwise>
								<input type="checkbox" disabled="" />
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of disable-output-escaping="yes" select="value"/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	<!-- Breadcrumb -->
	<xsl:template match="informationsystem_group" mode="breadCrumbs">
		<xsl:variable name="parent_id" select="parent_id"/>

		<xsl:apply-templates select="//informationsystem_group[@id=$parent_id]" mode="breadCrumbs"/>

		<xsl:if test="parent_id=0">
			<li><a href="{/informationsystem/url}" hostcms:id="{/informationsystem/@id}" hostcms:field="name" hostcms:entity="informationsystem">
					<xsl:value-of select="/informationsystem/name"/>
			</a></li>
		</xsl:if>

		<!--span><xsl:text> → </xsl:text></span-->

		<li><a href="{url}" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="informationsystem_group">
				<span><xsl:value-of select="name"/></span>
		</a></li>
	</xsl:template>

	<!-- Subgroups Template -->
	<xsl:template match="informationsystem_group" mode="groups">

		<xsl:for-each select=". | following-sibling::informationsystem_group[position() &lt; $n]">
			<div class="col">
				<a class="category-bl" href="{url}">
					<span class="bg type2">
					<img src="{dir}{image_small}" alt="{name}"/></span>
					<h3 class="h-3">
						<span class="h-3_desktop"><xsl:value-of select="name"/></span>
						<span class="h-3_mobile"><xsl:value-of select="name"/></span>

				</h3></a>
			</div>
		</xsl:for-each>

	</xsl:template>

	<!-- informationsystem_item template -->
	<xsl:template match="informationsystem_item">
		<!-- Text representation of a date
			<div class="col">
				<a class="category-bl" href="{url}">
					<span class="bg type2">
					<img src="{dir}{image_small}" alt="{name}"/></span>
					<h3 class="h-3">
						<span class="h-3_desktop"><xsl:value-of select="name"/></span>
						<span class="h-3_mobile"><xsl:value-of select="name"/></span>

				</h3></a>
			</div>-->
			<li><a href="{url}"><xsl:value-of select="name"/></a></li>
		</xsl:template>

		<!-- Tags Template -->
		<xsl:template match="tag">
			<a href="{/informationsystem/url}tag/{urlencode}/" class="tag">
				<xsl:value-of select="name"/>
			</a>
		<xsl:if test="position() != last()"><xsl:text> / </xsl:text></xsl:if></xsl:template>

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

			<xsl:if test="$items_count &gt; $limit and ($page + $post_count_page + 1) &gt; $i">
				<!-- Store in the variable $group ID of the current group -->
				<xsl:variable name="group" select="/informationsystem/group"/>

				<!-- Tag Path -->
				<xsl:variable name="tag_path">
					<xsl:choose>
						<xsl:when test="count(/informationsystem/tag)">tag/<xsl:value-of select="/informationsystem/tag/urlencode"/>/</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Choose Group Path -->
				<xsl:variable name="group_link">
					<xsl:choose>
						<!-- If the group is not root -->
						<xsl:when test="$group != 0">
							<xsl:value-of select="/informationsystem//informationsystem_group[@id=$group]/url"/>
						</xsl:when>
						<xsl:otherwise><xsl:value-of select="/informationsystem/url"/></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- Set $link variable -->
				<xsl:variable name="number_link">
					<xsl:choose>
						<xsl:when test="$i != 0">page-<xsl:value-of select="$i + 1"/>/</xsl:when>
						<xsl:otherwise></xsl:otherwise>
					</xsl:choose>
				</xsl:variable>

				<!-- First pagination item -->
				<xsl:if test="$page - $pre_count_page &gt; 0 and $i = $start_page">
					<a href="{$group_link}{$tag_path}" class="page_link" style="text-decoration: none;">←</a>
				</xsl:if>

				<!-- Pagination item -->
				<xsl:if test="$i != $page">
					<xsl:if test="($page - $pre_count_page) &lt;= $i and $i &lt; $n">
						<!-- Pagination item -->
						<a href="{$group_link}{$number_link}{$tag_path}" class="page_link">
							<xsl:value-of select="$i + 1"/>
						</a>
					</xsl:if>

					<!-- Last pagination item -->
					<xsl:if test="$i+1 &gt;= ($page + $post_count_page + 1) and $n &gt; ($page + 1 + $post_count_page)">
						<!-- Last pagination item -->
						<a href="{$group_link}page-{$n}/{$tag_path}" class="page_link" style="text-decoration: none;">→</a>
					</xsl:if>
				</xsl:if>

				<!-- Ctrl+left link -->
				<xsl:if test="$page != 0 and $i = $page">
					<xsl:variable name="prev_number_link">
						<xsl:choose>
							<xsl:when test="$page &gt; 1">page-<xsl:value-of select="$i"/>/</xsl:when>
							<xsl:otherwise></xsl:otherwise>
						</xsl:choose>
					</xsl:variable>

					<a href="{$group_link}{$prev_number_link}{$tag_path}" id="id_prev"></a>
				</xsl:if>

				<!-- Ctrl+right link -->
				<xsl:if test="($n - 1) > $page and $i = $page">
					<a href="{$group_link}page-{$page+2}/{$tag_path}" id="id_next"></a>
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

		<!-- Declension of the numerals -->
		<xsl:template name="declension">

			<xsl:param name="number" select="number"/>

			<!-- Nominative case / Именительный падеж -->
			<xsl:variable name="nominative">
				<xsl:text>&labelNominative;</xsl:text>
			</xsl:variable>

			<!-- Genitive singular / Родительный падеж, единственное число -->
			<xsl:variable name="genitive_singular">
				<xsl:text>&labelGenitiveSingular;</xsl:text>
			</xsl:variable>


			<xsl:variable name="genitive_plural">
				<xsl:text>&labelGenitivePlural;</xsl:text>
			</xsl:variable>

			<xsl:variable name="last_digit">
				<xsl:value-of select="$number mod 10"/>
			</xsl:variable>

			<xsl:variable name="last_two_digits">
				<xsl:value-of select="$number mod 100"/>
			</xsl:variable>

			<xsl:choose>
				<xsl:when test="$last_digit = 1 and $last_two_digits != 11">
					<xsl:value-of select="$nominative"/>
				</xsl:when>
				<xsl:when test="$last_digit = 2 and $last_two_digits != 12
					or $last_digit = 3 and $last_two_digits != 13
					or $last_digit = 4 and $last_two_digits != 14">
					<xsl:value-of select="$genitive_singular"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$genitive_plural"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:template>
	</xsl:stylesheet>