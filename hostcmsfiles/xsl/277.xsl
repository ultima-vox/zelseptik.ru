<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>



	<xsl:template match="shop_item" mode="septik">
		<xsl:variable name="group" select="group"/>
		<section class="area-text bg pr-about-text">
			<div class="page-bl">
				<div class="text">
					<xsl:choose>
						<xsl:when test="/shop/@id = 1">
							<h2 class="h-2">Септик <xsl:value-of select="name"/></h2>
						</xsl:when>
						<xsl:when test="/shop/@id = 3">
							<h2 class="h-2">Кессон <xsl:value-of select="name"/></h2>
						</xsl:when>
						<xsl:when test="/shop/@id = 5">
							<h2 class="h-2">Погреб <xsl:value-of select="name"/></h2>
						</xsl:when>
					</xsl:choose>
					<div class="fl-row">
						<div class="col">
							<xsl:if test="description != ''">
								<div hostcms:id="{@id}" hostcms:field="description" hostcms:entity="shop_item" hostcms:type="wysiwyg" class="txt"><xsl:value-of disable-output-escaping="yes" select="description" /></div>
							</xsl:if>
							<!-- Текст товара -->
							<xsl:if test="text != ''">
								<div hostcms:id="{@id}" hostcms:field="text" hostcms:entity="shop_item" hostcms:type="wysiwyg" class="txt"><xsl:value-of disable-output-escaping="yes" select="text"/></div>
							</xsl:if>
						</div>
						<div class="col">
							<h2 class="strong">Характеристики</h2>
							<ul class="specific-tbl">
								<xsl:if test="$group != 0">
									<li>
										<strong>Категория</strong><span><a href="{//shop_group[@id=$group]/url}"><xsl:value-of select="//shop_group[@id=$group]/name"/></a>
										</span>
								</li></xsl:if>
								<xsl:if test="weight != 0">
									<li>
										<strong>Вес</strong><span><xsl:value-of select="format-number(weight, '#####0', 'my')"/> <xsl:text> </xsl:text><xsl:value-of select="/shop/shop_measure/name"/></span>
									</li>
								</xsl:if>
								<xsl:if test="length != 0 or width != 0 or height != 0">
									<li>
										<strong>Габариты:</strong><span><xsl:value-of select="format-number(length, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:text>x</xsl:text><xsl:text> </xsl:text><xsl:value-of select="format-number(width, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:text>x</xsl:text><xsl:text> </xsl:text><xsl:value-of select="format-number(height, '#####0', 'my')" /><xsl:text> </xsl:text><xsl:value-of select="/shop/size_measure/name" /></span>

								</li></xsl:if>
								<xsl:if test="property_value[tag_name='men']/value !=''">
									<li><strong>Количество пользователей (до)</strong><span><xsl:value-of select="property_value[tag_name='men']/value" /> чел.</span></li>
								</xsl:if>
								<xsl:if test="/shop/@id = 1 or /shop/@id = 6">
									<xsl:choose>
										<xsl:when test="property_value[tag_name='long']/value = 1 ">
											<li><strong>Длина горловины септика</strong><span>Удлиненная горловина</span></li>
										</xsl:when>
										<xsl:otherwise>
											<li><strong>Длина горловины септика</strong><span>Стандартная горловина</span></li>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
								<xsl:if test="property_value[tag_name='zalp']/value !='' or property_value[tag_name='zalp']/value !='0'">
									<li><strong>Объём
									залпового сброса</strong><span><xsl:value-of select="property_value[tag_name='zalp']/value" /> л</span></li>
								</xsl:if>
								<xsl:if test="property_value[tag_name='performance']/value !=''">
									<li><strong>Производительность</strong><span><xsl:value-of select="property_value[tag_name='performance']/value" /> л/сутки</span></li>
								</xsl:if>
								<xsl:if test="property_value[tag_name='pr']/value = 1 or property_value[tag_name='nopr']/value = 1">
									<li><strong>Водоотведение</strong><span>
											<xsl:choose>
												<xsl:when test="property_value[tag_name='pr']/value = 1">
													Принудительный
												</xsl:when>
												<xsl:otherwise>
												Самотечный</xsl:otherwise>
								</xsl:choose></span></li></xsl:if>
								<xsl:if test="shop_producer/node()">
									<li>
										<strong>Производитель</strong><span><xsl:value-of disable-output-escaping="yes" select="shop_producer/name"/></span>
									</li>
								</xsl:if>
								<xsl:if test="property_value[tag_name='dacha']/value = 1 or property_value[tag_name='dom']/value = 1">
									<li><strong>Назначение</strong><span>
											<xsl:choose>
												<xsl:when test="property_value[tag_name='dacha']/value = 1">

													Для дачи

												</xsl:when>
												<xsl:otherwise>Для загородного дома</xsl:otherwise>
									</xsl:choose></span></li>
								</xsl:if>
							</ul>
							<xsl:if test="//shop_group[@id=$group]/property_value[tag_name='group-preim']/value !=''">
								<div id="tab6default" class="tab">
									<xsl:value-of disable-output-escaping="yes" select="//shop_group[@id=$group]/property_value[tag_name='group-preim']/value"/>
								</div>
							</xsl:if>
						</div>
					</div>
				</div>
			</div>
		</section>
		<xsl:if test="shop_tabs/node()">
			<section class="area-text no-bg pr-about-text">
				<xsl:apply-templates select="shop_tabs/shop_tab"/>
			</section>
		</xsl:if>
		<section class="area-text bg pr-about-text">
			<div class="page-bl">
				<div class="text-inf-row fl-row">
					<div class="col">
						<div class="text-inf">
							<img src="/assets/images/Icons/icon-24-7.svg" alt="Материал" class="lazyload" loading="lazy" />
							<h3 class="h-3">Материал</h3>
							<p>Септики из полипропилена, который не подвержен гниению и коррозии, а также какой- либо деформации.</p>
						</div>
					</div>
					<div class="col">
						<div class="text-inf">
							<img src="/assets/images/Icons/icon-24-7.svg" alt="Автономность" class="lazyload" loading="lazy" />
							<h3 class="h-3">Автономность</h3>
							<p>Септик <xsl:value-of select="name"/> не требует добавок и присадок — полностью автономная станция.</p>
						</div>
					</div>
					<div class="col">
						<div class="text-inf">
							<img src="/assets/images/Icons/icon-24-7.svg" alt="Обслуживание" class="lazyload" loading="lazy" />
							<h3 class="h-3">Обслуживание</h3>
							<p>Септик <xsl:value-of select="name"/> не требует откачки ассенизационной машиной.</p>
						</div>
					</div>
				</div>
			</div>
		</section>
		<section class="area-paragraph bg">
			<div class="page-bl">
				<div class="fl-row">
					<div class="col">
						<div class="punkt-bl">
							<img src="/assets/images/point1.svg" alt="Доставка" class="lazyload" loading="lazy" />
							<h2 class="h-2">Доставка</h2>
							<p>Стоимость доставки по Москве и области &#8212; 4000 ₽;<br />При заказе монтажа септика у нас. доставка &#8212; бесплатно. </p>
							<blockquote class="blk-bl red">
								<h4 class="h-4">Важно!</h4>
								<p>Цены актуальны при доставке в рамках Московской области. Для расчета доставки в другие регионы, обращайтесь, пожалуйста, к Вашему менеджеру.</p>
							</blockquote>
						<p>Для связи с менеджером воспользуйтесь <a href="/contacts/">любым удобным способом</a>.</p>					</div>
					</div>
					<div class="col">
						<div class="punkt-bl">
							<img src="/assets/images/point1.svg" alt="Цена септика под ключ" class="lazyload" loading="lazy"  />
							<h2 class="h-2">Цена септика под ключ</h2>
							<p>Стоимость монтажа под ключ <xsl:value-of select="name"/> &#8212; примерно
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price + 25000" />
								</xsl:apply-templates>.</p><p>
								<xsl:apply-templates select="/shop/shop_currency/code">
									<xsl:with-param name="value" select="price" />
							</xsl:apply-templates> (за сам септик) + 25 000 ₽ (примерная стоимость монтажа)</p>
							<ul>
								<li>Мы говорим "примерно", потому что монтаж под ключ - это комплекс работ.<br />Кому-то будет достаточно минимального комплекса, а у кого-то будут необходимы дополнительные работы. Поэтому мы называем примерную цену.</li>
								<li>Важно заметить, что цена рассчитана по средней планке и вполне может быть ниже.</li>
							</ul>
						<!--p><a class="btn w-btn">ЗАКАЗАТЬ СЕПТИК</a></p-->					</div>
					</div>
				</div>
			</div>
		</section>
		<section class="area-why no-bg why-pr type2">
			<div class="page-bl">
				<div class="box-bl">
					<div class="fl-row fcenter">
						<div class="col">
							<h2 class="h-2">Установка септика под ключ происходит в 4 этапа</h2>
							<ul class="great-num">
								<li>
									<span class="num">01</span>
									<p>Связываемся с Вами, обсуждаем, готовим выгодное предложение</p>
								</li>
								<li>
									<span class="num">02</span>
									<p>К Вам приезжает наш специалист для замеров, осмотра фронта работ, заключения договора и выбора даты монтажа</p>
								</li>
								<li>
									<span class="num">03</span>
									<p>Приезжаем в выбранную дату, доставляем оборудование и осуществляем монтаж и запуск станции</p>
								</li>
								<li>
									<span class="num">04</span>
									<p>Рассчитываемся с вами в день монтажа за работы и оборуждование.</p>
								</li>
							</ul>
						</div>
						<div class="col col-img">
							<div class="why-row">
								<div class="row-wrap">
									<div class="row-bl">
										<div class="s-row">
											<p><img src="/assets/images/banners/montage1.jpg" alt="Монтаж септика" class="lazyload" loading="lazy" /></p>
											<p><img src="/assets/images/banners/montage2.jpg" alt="Монтаж септика" class="lazyload" loading="lazy" /></p>
										</div>
										<div class="s-row">
											<p><img src="/assets/images/banners/montage3.jpg" alt="Монтаж септика" class="lazyload" loading="lazy" /></p>
											<p><img src="/assets/images/banners/montage4.jpg" alt="Монтаж септика" class="lazyload" loading="lazy" /></p>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</section>
	</xsl:template>
	<xsl:template match="shop_item" mode="kessony"><div class="section area-why bg why-home">
			<div class="page-bl">
				<div class="box-bl">
					<div class="fl-row fcenter">
						<div class="col">
							<div class="h-2">Вся установка кессона под ключ производится в 4 простых этапа:</div>
							<ul class="great-num">
								<li>
									<span class="num">01</span>
									<p>Связываемся с Вами, обсуждаем Ваш случай и готовим коммерческое предложение</p>
								</li>
								<li>
									<span class="num">02</span>
									<p>К Вам выезжает наш специалист для контрольных замеров, осмотра фронта работ, заключения договора и выбора даты монтажа</p>
								</li>
								<li>
									<span class="num">03</span>
									<p>В выбранную дату к Вам приезжает наша монтажная бригада, доставляется оборудование и осуществляется монтаж и подключение</p>
								</li>
								<li>
									<span class="num">04</span>
									<p>В день монтажа мы рассчитываемся с Вами за все работы и всю предоставленную Вам продукцию</p>
								</li>
							</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="section area-text no-bg">
			<div class="page-bl">
				<form class="form-bl form-submit" method="post" enctype="multipart/form-data">
					<div class="h-2">Свяжитесь с нами для консультации</div>
					<p>Оставьте номер и мы с вами свяжемся для бесплатной консультации</p>
					<div class="fl-row">
						<div class="col">
							<input type="text" name="name" autocomplete="off" placeholder="Ваше имя" />
						</div>
						<div class="col">
							<input class="phone_mask" type="tel" minlength="15" name="phone" required="" autocomplete="off" placeholder="Ваш телефон" />
							<input type="hidden" name="service" value="{name}" />
						</div>
						<div class="col">
							<input class="btn" type="submit" value="ПОЛУЧИТЬ КОНСУЛЬТАЦИЮ" name="form_service"/>
						</div>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="shop_item" mode="pogreb"></xsl:template>
	<xsl:template match="shop_item" mode="block6">
		<div class="section area-paragraph no-bg">
			<div class="page-bl punkt-fl-row">
				<h2 class="h-2">Что входит в обслуживание</h2>
				<div class="fl-row">
					<div class="col">
						<div class="punkt-bl" >
							<img  loading="lazy" src="/assets/images/point1.svg" alt="{name}" title="{name}" />
							<div class="h-3">Что входит</div>
							<ul>
								<li>Диагностика всех режимов работы станции очистки;</li>
								<li>Удаление иласоднастанции (посредством стандартногоилидренажного насоса);</li>
								<li>Чистка отсеков, фильтров, форсунок, насосов, биореактора идругих элементов;</li>
								<li>Ликвидация неразложившихся фракций (жировые отложения);</li>
								<li>Устранение засоров;</li>
								<li>Промывка камер;</li>
								<li>Наполнение камер водой;</li>
								<li>Проверка работоспособности устройства;</li>
								<li>Запуск бактерий (при необходимости);</li>
								<li>Замена деталей (при необходимости);</li>
								<li>Консервация устройства (при необходимости);</li>
								<li>Рекомендации поэксплуатации</li>
						</ul>					</div>
					</div>
					<div class="col">
						<div class="punkt-bl" >
							<img  loading="lazy" src="/assets/images/point1.svg" alt="{name}" title="{name}" />
							<div class="h-3">Сколько это стоит?</div>
							<p>Все зависит от того, какая именно услуга вам потребуется: стоимость обслуживания септиков ТОПАС или ТОПАС-С, к примеру, складывается из модели септика и того, что необходимо заменить. Сотрудники компании моментально устранят дефекты корпуса, заменят воздушные фильтры компрессоров, заменят сломанные детали оригинальными запчастями от производителей, прочистят форсунки.</p>
							<p>При соблюдении правил эксплуатации, обслуживание септика обходится недорого.</p>
							<blockquote class="blk-bl red">
								<h4 class="h-4">Важно!</h4>
								<p>В стоимость обслуживания не входят услуги ассенизаторской машины (если это потребуется)</p>
						</blockquote>					</div>
					</div>

				</div>
				<div class="fl-row">
					<div class="col">
						<div class="punkt-bl" >
							<img  loading="lazy" src="/assets/images/point1.svg" alt="{name}" title="{name}" />
							<div class="h-3">Причины неисправности</div>
							<p>Чаще всего причиной плохой работы септика являются следующие факторы:</p>
							<ul>
								<li>Затопление грунтовыми водами. Особенно актуально это весной, в момент таяния снега: станция погружается под воду, что может привести к неисправности электромеханических деталей;</li>
								<li>Затопление сточными водами &#8212; при длительном отсутствии обслуживания, стоки поднимаются выше предельного уровня, объема станции не хватает для дальнейшего накопления стоков и станция тонет.</li>
								<li>Засорение аэролифта, возникающее при сбрасывании неорганических отходов в канализацию. Почуяли неприятный запах, говорящий о застое воды? Вызывайте специалистов на обслуживание;</li>
								<li>Неисправность воздушного компрессора. Мембраны подвержены быстрому износу и подлежат замене раз в три года во время обслуживания компрессора.</li>
								<li>Неисправность дренажного насоса. Возможно сгорели катушки или не сработал поплавковый датчик.</li>
							</ul>
							<blockquote class="blk-bl yellow">
								<h4 class="h-4">Обратите внимание</h4>
								<p>Сотрудничество с нами гарантирует своевременное устранение неполадок и бесперебойную работу устройства.</p>
						</blockquote>			</div>
					</div>
					<div class="col">
						<div class="punkt-bl" >
							<img  loading="lazy" src="/assets/images/point1.svg" alt="{name}" title="{name}" />
							<div class="h-3">Почему мы?</div>
							<p>Трудно найти компанию, которая относилась бы так же ответственно к обслуживанию септиков, как мы.</p>
							<p>Сотрудничество с нами обладает рядом достоинств:</p>
							<ul>
								<li>Оперативность. Приедем сразу после звонка, в удобное для вас время;</li>
								<li >Низкие цены;</li>
								<li>Высокое качество;</li>
								<li>Без ассенизаторской машины;</li>
								<li>Консервация септиков;</li>
								<li>Многолетний опыт работы;</li>
								<li>Профессиональная команда;</li>
								<li>Консультации по эксплуатации;</li>
								<li>Запчасти от официальных производителей;</li>
								<li>Сотни положительных отзывов от наших клиентов;</li>
								<li>Разовый выезд или контракт на постоянной основе.</li>
							</ul>
							<blockquote class="blk-bl green">
								<h4 class="h-4">Остались вопросы?</h4>
								<p>Задайте их менеджеру: он проконсультирует вас и оформит заявку на<strong> обслуживание септиков Топас, Юнилос Астра, Тополь, БИО-С</strong>. Звоните прямо сейчас &#8212; наши сотрудники готовы выехать к вам в любую минуту в любую точку Москвы и Московской области. Наша компания находится в Зеленограде и мы можем приехать для ремонта септика или проведения работ по обслуживанию в кратчайшие сроки.</p>
						</blockquote>			</div>
					</div>
				</div>
			</div>
		</div>
		<div class="section area-text bg">
			<div class="page-bl">
				<form class="form-bl form-submit" method="post" enctype="multipart/form-data">
					<div class="h-2">Свяжитесь с нами для консультации</div>
					<p>Оставьте номер и мы с вами свяжемся для бесплатной консультации</p>
					<div class="fl-row">
						<div class="col">
							<input type="text" name="name" autocomplete="off" placeholder="Ваше имя" />
						</div>
						<div class="col">
							<input class="phone_mask" type="tel" minlength="15" name="phone" required="" autocomplete="off" placeholder="Ваш телефон" />
							<input type="hidden" name="service" value="{name}" />
						</div>
						<div class="col">
							<input class="btn" type="submit" value="ПОЛУЧИТЬ КОНСУЛЬТАЦИЮ" name="form_service"/>
						</div>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="shop_item" mode="service">

		<div class="section area-text bg">
			<div class="page-bl">
				<form class="form-bl form-submit" method="post" enctype="multipart/form-data">
					<div class="h-2">Свяжитесь с нами для консультации</div>
					<p>Оставьте номер и мы с вами свяжемся для бесплатной консультации</p>
					<div class="fl-row">
						<div class="col">
							<input type="text" name="name" autocomplete="off" placeholder="Ваше имя" />
						</div>
						<div class="col">
							<input class="phone_mask" type="tel" minlength="15" name="phone" required="" autocomplete="off" placeholder="Ваш телефон" />
						</div>
						<div class="col">
							<input class="btn" type="submit" value="ПОЛУЧИТЬ КОНСУЛЬТАЦИЮ" />
						</div>
					</div>
				</form>
			</div>
		</div>
	</xsl:template>
	<xsl:template match="shop_tab">
		<div class="page-bl">
			<div class="txt">
				<xsl:value-of select="caption" />


				<xsl:value-of disable-output-escaping="yes" select="text" />

			</div>
		</div>
	</xsl:template>
</xsl:stylesheet>