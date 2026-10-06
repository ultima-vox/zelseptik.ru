<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM "lang://55">
<xsl:stylesheet version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:hostcms="http://www.hostcms.ru/"
	exclude-result-prefixes="hostcms">
	<xsl:output xmlns="http://www.w3.org/TR/xhtml1/strict" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" encoding="utf-8" indent="yes" method="html" omit-xml-declaration="no" version="1.0" media-type="text/xml"/>

	<xsl:decimal-format name="my" decimal-separator="," grouping-separator=" "/>

	<xsl:template match="/">
		<xsl:apply-templates select="shop"/>
	</xsl:template>

	<xsl:variable name="n" select="number(25)"/>

	<xsl:template match="shop">
		<!-- Store parent id in a variable -->
		<xsl:variable name="group" select="group"/>
		<xsl:variable name="count">1</xsl:variable>

		<div class="section area-quiz-new no-bg">
			<div class="page-bl">
				<div class="quiz_parent">
					<div class="area-quiz no-bg quiz-hide-bl">
						<div class="txt">
							<div class="h-2">Где необходимо установить септик?</div>
							<p>Воспользуйтесь этой формой для подбора, чтобы мы могли помочь Вам с выбором. Займёт минуты 3, отвечаем в течение часа.</p>
						</div>
						<div class="quiz-row fl-row quiz-row-m-p">
							<div class="col">
								<a style="display:block;" class="quiz-box other_quiz quiz-btn clicked_question" href="#quiz_main" data-key="0">
									<div class="proc-row "> <span class="line" style="width:25%;"></span> <span class="name">25%</span> </div>
									<div class="q-img"><img loading="lazy" src="/assets/images/quiz/dacha.webp" alt="Дача или баня" /></div>
									<label>
									<input type="radio" value="0" name="quiz_question"/> <span class="lbl">На даче или около бани</span> </label>
								</a>
							</div>
							<div class="col">
								<a style="display:block;" class="quiz-box other_quiz quiz-btn clicked_question" href="#quiz_main"  data-key="1" >
									<div class="proc-row grn"> <span class="line" style="width:36%;"></span> <span class="name">36%</span> </div>
									<div class="q-img"><img loading="lazy" src="/assets/images/quiz/kottege.webp" alt="В доме"/></div>
									<label>
									<input type="radio" value="1" name="quiz_question"/> <span class="lbl">Около дома/коттеджа</span> </label>
								</a>
							</div>
							<div class="col">
								<a style="display:block;" class="quiz-box other_quiz quiz-btn clicked_question" href="#quiz_main"  data-key="2">
									<div class="proc-row dgrn"> <span class="line" style="width:18%;"></span> <span class="name">18%</span> </div>
									<div class="q-img"><img loading="lazy" src="/assets/images/quiz/gostinica.webp" alt="Решение для бизнеса" /></div>
									<label>
									<input type="radio" value="2" name="quiz_question"/> <span class="lbl">Для решений бизнеса (АЗС, ТЦ, Гостиница и пр.)</span> </label>
								</a>
							</div>
							<div class="col">
								<a style="display:block;" class="quiz-box other_quiz quiz-btn clicked_question" href="#quiz_main" data-key="3">
									<div class="proc-row "> <span class="line" style="width:21%;"></span> <span class="name">21%</span> </div>
									<div class="q-img"><img loading="lazy" src="/assets/images/quiz/specialist.webp" alt="Консультация специалиста" /></div>
									<label>
									<input type="radio" value="3" name="quiz_question"/> <span class="lbl">Консультация специалиста</span> </label>
								</a>
							</div>
						</div>
						<div class="txt">
							<div class="quiz-inf grn">Самый популярный ответ</div>
						</div>
					</div>
					<!--xsl:if test="count(tag) = 0 and shop_item and count(.//shop_group[parent_id=$group]) &gt; 0">
					<div class="area-products no-bg quiz-hide-bl" id="pr-slider48">
						<xsl:apply-templates select=".//shop_group[parent_id=$group][position() mod $n = 1]" mode="groups"/>
					</div>
				</xsl:if-->


				<div class="area-quiz no-bg quiz-show-bl" id="quiz_main">
					<!--div class="title-wrap">
					<div class="title-bl fl-row">
						<div class="col">
							<div class="h-2">Калькулятор септика:
							</div>
						</div>
						<div class="desktop-bl col">
							<a class="h-link" href="/septiki/">В ПОЛНЫЙ КАТАЛОГ
								<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
									<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698" stroke-width="1.4">
									</path>
								</svg>
							</a>
						</div>
					</div>
				</div-->
				<div class="quiz_overlay">
					<form class="quiz-slider form-quiz" id="form_quiz" method="post" action="./" enctype="multipart/form-data">
						<div class="swiper-box sw-quiz" id="sw-quiz24">
							<div class="swiper swiper-container-horizontal swiper-container-autoheight">
								<div class="swiper-wrapper">
									<div class="swiper-slide swiper-slide-active">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="h-2">На сколько человек будем подбирать септик или ЛОС?
												</div>
												<p>Рассчитаем производительность станции
												</p>
												<div class="quiz-chk fl-row">
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="1-6"/>
															<span class="lbl">1-6
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="7-9"/>
															<span class="lbl">7-9
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="10-15"/>
															<span class="lbl">10-15
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="16-50"/>
															<span class="lbl">16-50
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="50+"/>
															<span class="lbl">50+
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="count" type="radio" value="Другое"/>
															<span class="lbl">Другое
															</span>
														</label>
													</div>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:17%;">
													</span>
												</div>
												<div class="q-txt">
													<strong class="num">ВОПРОС 1 ИЗ 6
													</strong>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg> НАЗАД
														</span>
														<a class="next" href="#">
															ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#009CD9" stroke-width="1.4">
																</path>
															</svg>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide swiper-slide-next">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="h-2">Пользоваться планируете сезонно или полный год?
												</div>
												<p>Расскажем как пользоваться станцией в зависимости от ответа
												</p>
												<div class="quiz-chk fl-row">
													<div class="col">
														<label>
															<input class="next_slide" name="period" type="radio" value="Круглогодично"/>
															<span class="lbl">Круглогодично
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="period" type="radio" value="Сезонно (зима)"/>
															<span class="lbl">Зимой
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="period" type="radio" value="Сезонно (лето)"/>
															<span class="lbl">Летом
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="period" type="radio" value="Периодически в течение всего года"/>
															<span class="lbl">Периодически в течение всего года
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="period" type="radio" value="Другое"/>
															<span class="lbl">Другое
															</span>
														</label>
													</div>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:34%;">
													</span>
												</div>
												<div class="q-txt">
													<strong class="num">ВОПРОС 2 ИЗ 6
													</strong>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg> НАЗАД
														</span>
														<a class="next" href="#">
															ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#009CD9" stroke-width="1.4">
																</path>
															</svg>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="h-2">Какой уровень грунтовых вод на Вашем участке?
												</div>
												<p>Слой почвы с водой
												</p>
												<div class="quiz-chk fl-row">
													<div class="col">
														<label>
															<input class="next_slide" name="level" type="radio" value="Выше 1 метра"/>
															<span class="lbl">Выше 1 метра
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="level" type="radio" value="1-2 метра"/>
															<span class="lbl">1-2 метра
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="level" type="radio" value="Ниже 2-х метров"/>
															<span class="lbl">Ниже 2-х метров
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="level" type="radio" value="Я не знаю"/>
															<span class="lbl">Я не знаю
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input class="next_slide" name="level" type="radio" value="Другое"/>
															<span class="lbl">Другое
															</span>
														</label>
													</div>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:50%;">
													</span>
												</div>
												<div class="q-txt">
													<strong class="num">ВОПРОС 3 ИЗ 6
													</strong>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg> НАЗАД
														</span>
														<a class="next" href="#">
															ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#009CD9" stroke-width="1.4">
																</path>
															</svg>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="h-2">Какие точки сброса воды у Вас есть и будут?
												</div>
												<p>Рассчитаем залповый сброс станции
												</p>
												<div class="quiz-chk fl-row">
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Ванна"/>
															<span class="lbl">Ванна
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Раковина"/>
															<span class="lbl">Раковина
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Биде"/>
															<span class="lbl">Биде
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Джакузи"/>
															<span class="lbl">Джакузи
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Душ"/>
															<span class="lbl">Душ
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Унитаз"/>
															<span class="lbl">Унитаз
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Стиральная машина"/>
															<span class="lbl">Стиральная машина
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Посудомоечная машина"/>
															<span class="lbl">Посудомоечная машина
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="sbros[]" type="checkbox" value="Другое"/>
															<span class="lbl">Другое
															</span>
														</label>
													</div>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:67%;">
													</span>
												</div>
												<div class="q-txt">
													<strong class="num">ВОПРОС 4 ИЗ 6
													</strong>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg> НАЗАД
														</span>
														<a class="next" href="#">
															ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#009CD9" stroke-width="1.4">
																</path>
															</svg>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="h-2">У Вас есть какие-либо предпочтения по модели?
												</div>
												<p>Расскажем плюсы и минусы
												</p>
												<div class="quiz-chk fl-row">
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="АСТРА"/>
															<span class="lbl">АСТРА
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="ТОПАС"/>
															<span class="lbl">ТОПАС
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="ТОПАС-С"/>
															<span class="lbl">ТОПАС-С
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="БИО-С"/>
															<span class="lbl">БИО-С
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="ТОПОЛЬ"/>
															<span class="lbl">ТОПОЛЬ
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="БИОДЕКА"/>
															<span class="lbl">БИОДЕКА
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="Мне без разницы"/>
															<span class="lbl">Мне без разницы
															</span>
														</label>
													</div>
													<div class="col">
														<label>
															<input name="model[]" type="checkbox" value="Другое"/>
															<span class="lbl">Другое
															</span>
														</label>
													</div>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:84%;">
													</span>
												</div>
												<div class="q-txt">
													<strong class="num">ВОПРОС 5 ИЗ 6
													</strong>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg> НАЗАД
														</span>
														<a class="next" href="#">
															ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#009CD9" stroke-width="1.4">
																</path>
															</svg>
														</a>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="center">
													<div class="h-2">Супер! Уже начинаем считать
													</div>
													<p>Оставьте контакты и выберите удобный способ для обратной связи. Звонить не будем, если не выберете пункт "телефон"
													</p>
												</div>
												<div class="quiz-form">
													<div class="inp-bl">
														<input name="name" type="text" required="" value="" placeholder="Имя"/>
													</div>
													<div class="inp-bl">
														<input class="phone_mask" minlength="15" name="phone" type="tel" value="" placeholder="Телефон"/>
													</div>
													<div class="inp-bl">
														<input name="email" type="email" value="" placeholder="E-mail"/>
													</div>
													<div class="inp-bl">
														<input name="comment" type="text" value="" placeholder="Комментарий"/>
													</div>
													<div class="rd-row">
														<label>
															<input type="radio" value="Viber" name="feddback"/>
															<span class="lbl">Viber
															</span>
														</label>
														<label>
															<input type="radio" value="Whatsapp" name="feddback"/>
															<span class="lbl">Whatsapp
															</span>
														</label>
														<label>
															<input type="radio" value="Telegram" name="feddback"/>
															<span class="lbl">Telegram
															</span>
														</label>
														<label>
															<input type="radio" value="Звонок" name="feddback"/>
															<span class="lbl">Звонок
															</span>
														</label>
														<label>
															<input type="radio" value="E-mail" name="feddback"/>
															<span class="lbl">E-mail
															</span>
														</label>
													</div>
													<input type="hidden" class="link_source" name="link" value="{url}"/>
													<button class="btn" type="submit" name="form_quiz" value="Отправить">Отправить
													</button>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:100%;">
													</span>
												</div>
												<div class="q-txt">
													<span class="num">УСПЕХ!
													</span>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg>НАЗАД
														</span>
														<span class="next">ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg>
														</span>
													</div>
												</div>
											</div>
										</div>
									</div>
									<div class="swiper-slide" data-key="3">
										<div class="quiz-bl">
											<div class="quiz-farea">
												<div class="center">
													<div class="h-2">Все расскажем</div>
													<p>Оставьте контакты и выберите удобный способ для связи. Звонить не будем, если не выберете пункт "телефон"</p>
												</div>
												<div class="quiz-form">
													<div class="inp-bl">
														<input name="name" type="text" required="" value="" placeholder="Имя"/>
													</div>
													<div class="inp-bl">
														<input class="phone_mask" minlength="15" name="phone" type="tel" value="" placeholder="Телефон"/>
													</div>
													<div class="inp-bl">
														<input name="email" type="email" value="" placeholder="E-mail"/>
													</div>
													<div class="inp-bl">
														<input name="comment" type="text" value="" placeholder="Комментарий"/>
													</div>
													<div class="rd-row">
														<label>
															<input type="radio" value="Viber" name="feddback"/>
															<span class="lbl">Viber
															</span>
														</label>
														<label>
															<input type="radio" value="Whatsapp" name="feddback"/>
															<span class="lbl">Whatsapp
															</span>
														</label>
														<label>
															<input type="radio" value="Telegram" name="feddback"/>
															<span class="lbl">Telegram
															</span>
														</label>
														<label>
															<input type="radio" value="Звонок" name="feddback"/>
															<span class="lbl">Звонок
															</span>
														</label>
														<label>
															<input type="radio" value="E-mail" name="feddback"/>
															<span class="lbl">E-mail
															</span>
														</label>
													</div>
													<input type="hidden" class="link_source" name="link" value="{url}"/>
													<button class="btn" type="submit" name="form_quiz" value="Отправить">Отправить
													</button>
												</div>
											</div>
											<div class="quiz-sbmts">
												<div class="line">
													<span style="width:100%;">
													</span>
												</div>
												<div class="q-txt">
													<span class="num">УСПЕХ!
													</span>
													<div>
														<span class="prev">
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.82782 6.82843L0.999396 4L3.82782 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg>НАЗАД
														</span>
														<span class="next">ДАЛЕЕ
															<svg width="7" height="8" viewBox="0 0 7 8" fill="none" xmlns="http://www.w3.org/2000/svg">
																<path d="M3.17608 6.82843L6.00451 4L3.17608 1.17157" stroke="#E4E9EC" stroke-width="1.4">
																</path>
															</svg>
														</span>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								<span class="swiper-notification" aria-live="assertive" aria-atomic="true">
								</span>
							</div>
							<div class="sw-btns-bl">
								<div class="swiper-button prev swiper-button-disabled" tabindex="0" role="button" aria-label="Previous slide" aria-disabled="true">
								</div>
								<div class="swiper-button next" tabindex="0" role="button" aria-label="Next slide" aria-disabled="false">
								</div>
							</div>
						</div>
						<div class="quiz-discount">
							<div class="d-border">
								<div>
									<input type="hidden" class="change_price_hidden24" name="discount" value="1000 ₽"/>
									<strong>Ваша скидка:
										<span class="change_price24">1000 ₽
										</span>
									</strong>
									<p>Увеличиваем скидку с каждым ответом, чтобы было веселее!
									</p>
								</div>
							</div>
						</div>

						<script>
							<xsl:comment>
								<xsl:text disable-output-escaping="yes">
<![CDATA[
		document.addEventListener("DOMContentLoaded", () => {
		const swiper_quiz24 = new Swiper('#sw-quiz24 .swiper', {
			slidesPerView: 1, spaceBetween: 0, centeredSlides: false, loop: false, autoHeight: true,allowTouchMove:false,
			navigation: {
				nextEl: '#sw-quiz24 .swiper-button.next',
				prevEl: '#sw-quiz24 .swiper-button.prev',
			},
			on: {
				init: function () {
					let totalSlides = $('#sw-quiz24 .swiper-slide:not(.swiper-slide-duplicate)').length;
					if(totalSlides == 1){
						$('.quiz-slider').addClass('result');
					}
				},
				slideChange: function () {
					let price = 1000;
					if(swiper_quiz24.activeIndex > 0){
						price = 1000 + (swiper_quiz24.activeIndex * 500)
					}
					if(swiper_quiz24.activeIndex == (swiper_quiz24.slides.length-1)){
						$('.quiz-slider').addClass('result');
					}else{
						$('.quiz-slider').removeClass('result');
					}
					$('.change_price24').text(price + ' ₽');
					$('.change_price_hidden24').val(price + ' ₽');

				},
			},
		});


		$('#sw-quiz24').on('click','.next_slide', function (){
			swiper_quiz24.slideNext();
		});

		$.fn.setCursorPosition = function (pos) {
			if ($(this).get(0).setSelectionRange && $(this).val().replace(/\D/g, '').length != 11) {
				$(this).get(0).setSelectionRange(pos, pos);
			}
		};

		$.mask.definitions['N'] = '[/0-6|9/]';

		$(".phone_mask").click(function () {
			$(this).setCursorPosition(2);
		}).mask("+7 N99 999-99-99");
        });
									]]>
								</xsl:text>
							</xsl:comment>
						</script>

					</form>
					<div class="quiz_thanks" style="display: none;">
						<div class="quiz-finish">
							<div class="bl">
								<div class="q-title">
									<div class="h-2">Спасибо!
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

		</div>
	</div>
</div>

</xsl:template>

<xsl:template match="shop_group" mode="groups">
<xsl:variable name="id" select="@id" />
<div class="title-wrap">
	<div class="title-bl fl-row">
		<div class="col">
			<h2 class="h-2">Септики<xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="name"/>:</h2>
			<div class="sw-btns-bl">
				<div class="swiper-button prev"></div>
				<div class="swiper-button next"></div>
			</div>
		</div>
		<div class="desktop-bl col">
			<a class="h-link" href="{url}">
				В ПОЛНЫЙ КАТАЛОГ
				<svg width="7" height="8" viewBox="0 0 7 8" fill="none"
					xmlns="http://www.w3.org/2000/svg">
					<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698" stroke="#009CD9"
					stroke-width="1.4"/>
				</svg>
			</a>
		</div>


	</div>
</div>
<div class="pr-row fl-row">
	<div class="col col-main">
		<div class="swiper-box sw-prod" id="swiper-prod48">
			<div class="swiper">
				<div class="swiper-wrapper">
					<xsl:apply-templates select="/shop/shop_item[shop_group_id = $id]"/>
				</div>
			</div>
		</div>
		<div class="mobile-bl">
			<div class="title-wrap">
				<div class="title-bl fl-row fright">
					<div class="col">
						<a class="h-link" href="{url}">
							В ПОЛНЫЙ КАТАЛОГ
							<svg width="7" height="8" viewBox="0 0 7 8" fill="none"
								xmlns="http://www.w3.org/2000/svg">
								<path d="M2.82843 6.65655L5.65685 3.82812L2.82843 0.999698"
								stroke="#009CD9" stroke-width="1.4"/>
							</svg>
						</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<div class="col col-info">
		<div class="ab-info">
			<div class="txt">
				<h3 class="h-3">Не знаете какой септик вам нужен?</h3>
				<p>Компания ЗелСептик может помочь!</p>
				<a class="btn brd wht  quiz-btn" href="#quiz-main"
				data-id="24">ПОДОБРАТЬ СЕПТИК</a>
			</div>
		</div>
	</div>
</div>
</xsl:template>
<!-- Шаблон для групп товара -->
<xsl:template match="shop_group">
<div class="col">
	<div class="txt">
		<h2 class="h-2">Если вы решили купить септик, рассмотрите все варианты</h2>
		<div class="select-bl" style="z-index: 5">
			<div class="title"> <span><i>септики</i><xsl:value-of select="name"/></span> </div>
			<!--ul>
			<xsl:for-each select=". | following-sibling::shop_group">
				<li><span class="reload_product" data-id="shop_group_{@id}"><i>септики</i> <xsl:value-of select="name"/></span></li><xsl:text> </xsl:text><span class="shop_count"><xsl:value-of select="items_total_count"/></span>
			</xsl:for-each>
		</ul-->
	</div>
	<xsl:value-of disable-output-escaping="yes" select="description"/>
</div>
</div>
<div class="col">
<div class="img"><img src="{dir}{image_large}" alt="{name}" class="lazyload" loading="lazy" /></div>
</div>
</xsl:template>
<xsl:template match="shop_item" mode="feachured">
<xsl:if test="property_value[tag_name='pop']/value = 1">
<xsl:for-each select="shop_item">

	<div class="swiper-slide">
		<div class="pr-small">
			<h4>Рекомендуем: Септик <xsl:value-of select="name"/></h4>
			<div class="feature_pr_col"><img data-src="{dir}{image_large}" alt="{name}" class="lazyload" loading="lazy" />
				<!--xsl:choose>
				<xsl:when test="price = 0">
					<span class="feature_price_tag">
						<a href="#" data-toggle="modal" data-target="#productModal" data-description="{name}" onclick="lalal(this);">
							Под заказ
					</a></span>

				</xsl:when>
				<xsl:when test="discount != 0">
					<span class="feature_price_tag">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
					</xsl:apply-templates></span>
					<span>	<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price + discount" />
					</xsl:apply-templates></span>
				</xsl:when>
				<xsl:otherwise>
					<span class="feature_price_tag">
						<xsl:apply-templates select="/shop/shop_currency/code">
							<xsl:with-param name="value" select="price" />
					</xsl:apply-templates></span>
				</xsl:otherwise>
			</xsl:choose-->
			<h5><a href="{url}" class="view-all hvr-bounce-to-right shop_add_cart">Посмотреть</a></h5>
		</div>
	</div>
</div>
</xsl:for-each>
</xsl:if>
</xsl:template>
<!-- Шаблон для товара -->
<xsl:template match="shop_item">

<!--xsl:for-each select=". | following-sibling::shop_item"> 	</xsl:for-each-->
<div class="swiper-slide" itemscope="" itemtype="http://schema.org/Product">
<div class="pr-small">
<div class="img">
	<a href="{url}">
		<xsl:choose>
			<xsl:when test="image_large != ''">
				<img data-src="{dir}{image_large}" height="152" class="lazyload" loading="lazy"  alt="{name}"/>
				<meta  itemprop="image" content="{dir}{image_large}" />
				<!--img src="{dir}{image_large}" alt="{name}" class="zoom_img_effect"  title="{name}"/-->
			</xsl:when>
			<xsl:otherwise>
				<img src="/images/no-image.png" alt="{name}"  title="{name}" itemprop="image" class="lazyload" loading="lazy" />
			</xsl:otherwise>
		</xsl:choose>
	</a>
	<xsl:if test="discount != 0">
		<div class="i-row"><span><xsl:apply-templates select="shop_discount"/>%</span>
		</div>
	</xsl:if>
</div>

<div class="pr-body-row">
	<div class="pr-body-col">
		<div class="txt">
			<h3 class="h-5"  itemprop="name" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item">
				<a href="{url}"><xsl:value-of select="name"/></a>
			</h3>
			<!--div class="mobile-bl">
			<div class="modific-sbm">Модификации <span class="ico"></span></div>
		</div-->
		<!--xsl:value-of disable-output-escaping="yes" select="substring(description, 0, 50)"/-->
		<div itemprop="description"><xsl:value-of disable-output-escaping="yes" select="description"/></div>
	</div>
	<div class="mobile-bl"></div>
	<div class="modific-bl">
		<h6 class="tabs-h">Модификация:
			<span class="i-btn">
				<svg width="16" height="16" viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg">
					<path fill-rule="evenodd" clip-rule="evenodd" d="M8 16C12.4183 16 16 12.4183 16 8C16 3.58172 12.4183 0 8 0C3.58172 0 0 3.58172 0 8C0 12.4183 3.58172 16 8 16ZM11.258 5.95746C11.258 4.26376 9.72769 3.55566 8.17335 3.55566C6.69151 3.55566 5.33174 4.59967 5.33203 5.77774C5.33203 6.25793 5.69683 6.51022 6.12181 6.51022C6.66959 6.51022 6.83106 6.167 7.00373 5.79998C7.20215 5.37825 7.41534 4.92508 8.24642 4.92508C8.97545 4.92508 9.4116 5.30946 9.4116 5.95774C9.4116 6.51806 8.93076 6.88508 8.42657 7.26991C7.87095 7.69401 7.28699 8.13973 7.28699 8.88962C7.28699 9.274 7.54204 9.6941 8.06416 9.6941C8.63512 9.6941 8.74993 9.39477 8.87418 9.07082C8.92435 8.93999 8.97607 8.80516 9.05999 8.68439C9.1771 8.5143 9.42327 8.34091 9.71006 8.1389C10.3749 7.67065 11.258 7.04863 11.258 5.95746ZM9.1087 11.4592C9.1087 10.9178 8.6585 10.4739 8.11288 10.4739C7.5664 10.4739 7.11677 10.9181 7.11677 11.4592C7.11677 12.0012 7.5664 12.4446 8.11288 12.4446C8.65936 12.4446 9.1087 12.0006 9.1087 11.4592Z" fill="#009CD9" />
				</svg>
				<span>Пр — с принудительным выбросом стоков. Его устанавливают при высоких грунтовых водах или выбросе стоков в канаву. Стандарт/Миди/Лонг — различают по длине горловины. Миди и Лонг, удлиненные, нужны, если стоковая труба выходит глубже 60 см от уровня земли.</span>
			</span>
		</h6>
		<div class="tabs-row">
			<ul>
				<xsl:choose>
					<xsl:when test="property_value[tag_name='nopr']/value =1">
						<li class="modification_load active">
							<span class="name">Самотечный</span>
						</li>
					</xsl:when>
					<xsl:otherwise>
						<li class="modification_load active">
							<span class="name">Принудительный</span>
						</li>
					</xsl:otherwise>
				</xsl:choose>


			</ul>
		<span class="line"></span></div>
		<div class="tabs-row">
			<ul>
				<xsl:choose>
					<xsl:when test="property_value[tag_name='long']/value = 1">
						<!--li class="modification_load ">
						<span class="name">Стандарт</span>
					</li-->
					<li class="modification_load active" >
						<span class="name">Лонг</span>
					</li>
				</xsl:when>
				<xsl:when test="property_value[tag_name='midi']/value = 1">
					<!--li class="modification_load ">
					<span class="name">Стандарт</span>
				</li-->
				<li class="modification_load active" >
					<span class="name">Миди</span>
				</li>
			</xsl:when>
			<xsl:otherwise>
				<li class="modification_load  active">
					<span class="name">Стандарт</span>
				</li>
				<!--li class="modification_load" >
				<span class="name">Лонг</span>
			</li-->
</xsl:otherwise></xsl:choose>		</ul>
<span class="line"></span></div>
</div>

</div>
<div class="btns-row">
<xsl:choose>
<xsl:when test="price = 0">
<p>	<a href="{url}" class="btn">
		Под заказ
	</a>
</p>
<!--p>
<span class="btn grn pls"
	onclick="cart.add('56',1,this);"><img
		width="22" height="22"
		src="/templates/template1/images/icon-pls.svg"
	alt="{name}"/>
</span>
</p-->
</xsl:when>
<xsl:when test="discount != 0">
<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
<a class="btn" href="{url}">
	<span class="old">
		<xsl:apply-templates select="/shop/shop_currency/code">
			<xsl:with-param name="value" select="price + discount" />
		</xsl:apply-templates>
		</span><xsl:apply-templates select="/shop/shop_currency/code">
		<xsl:with-param name="value" select="price" />
	</xsl:apply-templates>
</a>
<meta itemprop="price" content="{price + discount}" />
<meta itemprop="currency" content="RUB" />
<link itemprop="availability" href="http://schema.org/InStock"/>
</p>
<!--p>
<span class="btn grn pls"
onclick="cart.add('56',1,this);"><img
	width="22" height="22"
	src="/templates/template1/images/icon-pls.svg"
alt="{name}" />
</span>
</p-->
</xsl:when>
<xsl:otherwise>
<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
<a class="btn" href="{url}">
<xsl:apply-templates select="/shop/shop_currency/code">
	<xsl:with-param name="value" select="price" />
</xsl:apply-templates></a>
<meta itemprop="price" content="{price}" />
<meta itemprop="priceCurrency" content="RUB" />
<link itemprop="availability" href="http://schema.org/InStock"/>
</p>
<!--p>
<span class="btn grn pls"
onclick="cart.add('56',1,this);"><img
width="22" height="22"
src="/templates/template1/images/icon-pls.svg"
alt="{name}" />
</span>
</p-->
</xsl:otherwise>
</xsl:choose>
</div>
</div>
<!--<a href="{url}"  title="Купить септик {name}" class="view-all hvr-bounce-to-right shop_add_cart">Купить</a>>
<a href="#" data-toggle="modal" data-target="#productModal{@id}" data-description="{name}" onclick="lalal(this);" title="быстрый заказ" class="view-all hvr-bounce-to-right shop_add_cart">быстрый заказ</a-->
</div>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->

</xsl:template>
<xsl:template match="shop_item" mode="group">

<!--xsl:for-each select=". | following-sibling::shop_item"> 	</xsl:for-each-->
<div class="swiper-slide" itemscope="" itemtype="http://schema.org/Product">
<div class="pr-small">
<div class="img">
<a href="{url}">
<xsl:choose>
<xsl:when test="image_large != ''">
<img data-src="{dir}{image_large}" height="152" class="lazyload" loading="lazy"  alt="{name}" itemprop="image"/>
<!--img src="{dir}{image_large}" alt="{name}" class="zoom_img_effect"  title="{name}"/-->
</xsl:when>
<xsl:otherwise>
<img src="/images/no-image.png" alt="{name}" class="lazyload" loading="lazy"   title="{name}" itemprop="image"/>
</xsl:otherwise>
</xsl:choose>
</a>
<xsl:if test="discount != 0">
<div class="i-row">
<span><xsl:apply-templates select="shop_discount"/>%</span>
</div>
</xsl:if>
</div>

<div class="pr-body-row">
<div class="pr-body-col">
<div class="txt">
<h3 class="h-5"  itemprop="name" hostcms:id="{@id}" hostcms:field="name" hostcms:entity="shop_item"><a
href="{url}"><xsl:value-of select="name"/></a>
</h3>
<div class="mobile-bl">
<div class="modific-sbm">Модификации <span class="ico"></span></div>
</div>
<!--xsl:value-of disable-output-escaping="yes" select="substring(description, 0, 50)"/-->
<div itemprop="description"><xsl:value-of disable-output-escaping="yes" select="description"/></div>
</div>
</div>
<div class="btns-row">
<xsl:choose>
<xsl:when test="price = 0">
<p>	<a href="{url}" class="btn">
Под заказ
</a>
</p>
<!--p>
<span class="btn grn pls"
onclick="cart.add('56',1,this);"><img
width="22" height="22"
src="/templates/template1/images/icon-pls.svg"
alt="{name}"/>
</span>
</p-->
</xsl:when>
<xsl:when test="discount != 0">
<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
<a class="btn" href="{url}">
<span class="old">
<xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price" />
</xsl:apply-templates></span>
<xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price + discount" />
</xsl:apply-templates>
</a></p>
<meta itemprop="price" content="{price + discount}" />
<meta itemprop="currency" content="RUB" />
<link itemprop="availability" href="http://schema.org/InStock"/>

<!--p>
<span class="btn grn pls"
onclick="cart.add('56',1,this);"><img
width="22" height="22"
src="/templates/template1/images/icon-pls.svg"
alt="{name}" />
</span>
</p-->
</xsl:when>
<xsl:otherwise>
<p itemprop="offers" itemscope="" itemtype="http://schema.org/Offer">
<a class="btn" href="{url}">
<xsl:apply-templates select="/shop/shop_currency/code">
<xsl:with-param name="value" select="price" />
</xsl:apply-templates></a></p>
<meta itemprop="price" content="{price}" />
<meta itemprop="priceCurrency" content="RUB" />
<link itemprop="availability" href="http://schema.org/InStock"/>
<!--p>
<span class="btn grn pls"
onclick="cart.add('56',1,this);"><img
width="22" height="22"
src="/templates/template1/images/icon-pls.svg"
alt="{name}" />
</span>
</p-->
</xsl:otherwise>
</xsl:choose>
</div>
</div>
<!--<a href="{url}"  title="Купить септик {name}" class="view-all hvr-bounce-to-right shop_add_cart">Купить</a>>
<a href="#" data-toggle="modal" data-target="#productModal{@id}" data-description="{name}" onclick="lalal(this);" title="быстрый заказ" class="view-all hvr-bounce-to-right shop_add_cart">быстрый заказ</a-->
</div>
</div>

<!--xsl:if test="position() mod 3 = 0 and position() != last()">
<span class="table_row"></span>
</xsl:if-->

</xsl:template>

<xsl:template match="modifications/shop_item" mode="paramList">
<li class="modification_load " data-id="{@id}">
<span class="name">Самотеком</span>
</li>
<!--option value="{@id}" data-price="{price} {/shop/shop_currency/name}">
<xsl:value-of select="name"/><xsl:text> — </xsl:text><xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="/shop/shop_currency/name"/>
</option-->
</xsl:template>
<xsl:template match="modifications/shop_item">
<li>
<!-- Название модификации -->
<a href="{url}"><xsl:value-of select="name"/></a>,
<!-- Цена модификации -->
<xsl:value-of select="price"/><xsl:text> </xsl:text><xsl:value-of disable-output-escaping="yes" select="currency"/>
</li>
</xsl:template>
<xsl:template match="property">
<xsl:variable name="property_id" select="@id" />
<xsl:if test="/shop/shop_item/property_value[property_id = $property_id]/value/node() and /shop/shop_item/property_value[property_id = $property_id]/value != '' or /shop/shop_item/property_value[property_id = $property_id]/type != 2"> <div class="tabbing_col">

<h2 class="acc_trigger"><a href="#"><xsl:value-of disable-output-escaping="yes" select="name"/></a></h2>
<div class="acc_container">
<ul class="prd_cat_list">
<xsl:apply-templates select="/shop/shop_item/property_value[property_id = $property_id]" />
</ul>
</div>
</div>
</xsl:if>
</xsl:template>

<xsl:template match="/shop/shop_item/property_value">
<xsl:variable name="property_id" select="property_id" />
<xsl:variable name="property" select="/shop/shop_item_properties//property[@id=$property_id]" />
<xsl:choose>
<xsl:when test="$property/type = 7">
<li><a href="#">- <input type="checkbox" disabled="disabled">
<xsl:if test="value = 1">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
</input></a></li>
</xsl:when>
<xsl:otherwise>
<li><a href="#">-  <xsl:value-of disable-output-escaping="yes" select="value"/></a></li>
</xsl:otherwise>
</xsl:choose>

</xsl:template>
<!-- Шаблон для фильтра по дополнительным свойствам -->
<xsl:template match="property" mode="propertyList">
<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

<div class="tabbing">

<xsl:if test="filter != 5">
<legend><xsl:value-of select="name"/><xsl:text> </xsl:text></legend>
</xsl:if>

<xsl:choose>
<!-- Отображаем поле ввода -->
<xsl:when test="filter = 1">
<br/>
<input type="text" name="property_{@id}">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
</xsl:when>
<!-- Отображаем список -->
<xsl:when test="filter = 2">
<br/>
<select name="property_{@id}">
<option value="0">...</option>
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
<!-- Отображаем переключатели -->
<xsl:when test="filter = 3">
<br/>
<div class="propertyInput">
<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
<label for="id_prop_radio_{@id}_0">&labelAnyOption;</label>
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажки -->
<xsl:when test="filter = 4">
<div class="propertyInput">
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажок -->
<xsl:when test="filter = 5">
<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
<label for="property_{@id}">
<xsl:value-of select="name"/><xsl:text> </xsl:text>
</label>
</xsl:when>

<!-- Отображение полей "от и до" -->
<xsl:when test="filter = 6">
<br/>
&labelFrom; <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> &labelTo; <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
</xsl:when>
<!-- Отображаем список с множественным выбором-->
<xsl:when test="filter = 7">
<br/>
<select name="property_{@id}[]" multiple="multiple">
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
</xsl:choose>
</div>
</xsl:template>


<xsl:template match="property" mode="propertyFilter">
<xsl:variable name="nodename">property_<xsl:value-of select="@id"/></xsl:variable>
<xsl:variable name="nodename_from">property_<xsl:value-of select="@id"/>_from</xsl:variable>
<xsl:variable name="nodename_to">property_<xsl:value-of select="@id"/>_to</xsl:variable>

<div class="tabbing">

<xsl:if test="filter != 5">
<legend><xsl:value-of select="name"/><xsl:text> </xsl:text></legend>
</xsl:if>


<xsl:choose>
<!-- Отображаем поле ввода -->
<xsl:when test="filter = 1">
<br/>
<input type="text" name="property_{@id}">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="value"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
</xsl:when>
<!-- Отображаем список -->
<xsl:when test="filter = 2">
<br/>
<select name="property_{@id}">
<option value="0">...</option>
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>
<!-- Отображаем переключатели -->
<xsl:when test="filter = 3">
<br/>
<div class="propertyInput">
<input type="radio" name="property_{@id}" value="0" id="id_prop_radio_{@id}_0"></input>
<label for="id_prop_radio_{@id}_0">&labelAnyOption;</label>
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажки -->
<xsl:when test="filter = 4">
<div class="propertyInput">
<xsl:apply-templates select="list/list_item"/>
</div>
</xsl:when>
<!-- Отображаем флажок -->
<xsl:when test="filter = 5">
<input type="checkbox" name="property_{@id}" id="property_{@id}" style="padding-top:4px">
<xsl:if test="/shop/*[name()=$nodename] != ''">
<xsl:attribute name="checked"><xsl:value-of select="/shop/*[name()=$nodename]"/></xsl:attribute>
</xsl:if>
</input>
<label for="property_{@id}">
<xsl:value-of select="name"/><xsl:text> </xsl:text>
</label>
</xsl:when>

<!-- Отображение полей "от и до" -->
<xsl:when test="filter = 6">
<br/>
&labelFrom; <input type="text" name="property_{@id}_from" size="2" value="{/shop/*[name()=$nodename_from]}"/> &labelTo; <input type="text" name="property_{@id}_to" size="2" value="{/shop/*[name()=$nodename_to]}"/>
</xsl:when>
<!-- Отображаем список с множественным выбором-->
<xsl:when test="filter = 7">
<br/>
<select name="property_{@id}[]" multiple="multiple">
<xsl:apply-templates select="list/list_item"/>
</select>
</xsl:when>

</xsl:choose>
</div>
</xsl:template>

<xsl:template match="list/list_item">
<xsl:if test="../../filter = 2">
<!-- Отображаем список -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<option value="{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
<xsl:value-of disable-output-escaping="yes" select="value"/>
</option>
</xsl:if>
<xsl:if test="../../filter = 3">
<!-- Отображаем переключатели -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<br/>
<input type="radio" name="property_{../../@id}" value="{@id}" id="id_property_{../../@id}_{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
</input>
<label for="id_property_{../../@id}_{@id}">
<xsl:value-of disable-output-escaping="yes" select="value"/>
</label>
</xsl:if>
<xsl:if test="../../filter = 4">
<!-- Отображаем флажки -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<br/>
<input type="checkbox" value="{@id}" name="property_{../../@id}[]" id="property_{../../@id}_{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="checked">checked</xsl:attribute>
</xsl:if>
<label for="property_{../../@id}_{@id}">
<xsl:value-of disable-output-escaping="yes" select="value"/>
</label>
</input>
</xsl:if>
<xsl:if test="../../filter = 7">
<!-- Отображаем список -->
<xsl:variable name="nodename">property_<xsl:value-of select="../../@id"/></xsl:variable>
<option value="{@id}">
<xsl:if test="/shop/*[name()=$nodename] = @id">
<xsl:attribute name="selected">
</xsl:attribute>
</xsl:if>
<xsl:value-of disable-output-escaping="yes" select="value"/>
</option>
</xsl:if>
</xsl:template>

<!-- Метки для товаров -->
<xsl:template match="tag">
<a href="{/shop/url}tag/{urlencode}/" class="tag">
<xsl:value-of select="tag_name"/>
</a>
<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>
</xsl:template>
<xsl:template match="shop_discount">
<xsl:value-of select="round(percent)"/>
</xsl:template>
<xsl:template match="shop_currency/code">
<xsl:param name="value" />

<xsl:variable name="spaced" select="format-number($value, '# ###', 'my')" />

<xsl:choose>
<xsl:when test=". = 'USD'">$<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'EUR'">€<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'GBP'">£<xsl:value-of select="$spaced"/></xsl:when>
<xsl:when test=". = 'RUB'"> <xsl:value-of select="$spaced"/> ₽</xsl:when>
<xsl:when test=". = 'RUR'"> <xsl:value-of select="$spaced"/> ₽</xsl:when>
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