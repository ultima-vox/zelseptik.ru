(function () {
  'use strict';

  const $ = (selector, scope) => (scope || document).querySelector(selector);
  const $$ = (selector, scope) => Array.from((scope || document).querySelectorAll(selector));

  function scrollToId(id) {
    const target = document.getElementById(id);
    if (!target) return;

    const header = $('.site-header');
    const offset = header ? header.offsetHeight + 12 : 0;
    const top = target.getBoundingClientRect().top + window.scrollY - offset;

    window.scrollTo({ top, behavior: 'smooth' });
  }

  function initStickyHeader() {
    const header = $('.site-header');
    if (!header) return;

    function update() {
      header.classList.toggle('is-scrolled', window.scrollY > 10);
    }

    update();
    window.addEventListener('scroll', update, { passive: true });
  }

  function initMobileMenu() {
    const burger = $('.js-burger');
    const drawer = $('.js-mobile-drawer');
    const dialog = $('.mobile-drawer__dialog', drawer);
    const closeBtn = $('.js-mobile-drawer-close');
    const backdrop = $('.js-mobile-drawer-backdrop');
    let lastFocused = null;

    if (!burger || !drawer) return;

    let isOpen = false;
    let finishTimer = null;
    let frame = null;
    let savedOverflow = '';
    let savedPadding = '';
    drawer.inert = true;

    function focusWithoutScroll(element) {
      if (element && typeof element.focus === 'function') element.focus({ preventScroll: true });
    }

    function settle() {
      window.clearTimeout(finishTimer);
      finishTimer = null;
      drawer.classList.remove('mobile-drawer--moving');
      if (isOpen) {
        focusWithoutScroll(closeBtn);
      } else {
        document.body.style.overflow = savedOverflow;
        document.body.style.paddingRight = savedPadding;
      }
    }

    function waitForMotion() {
      window.clearTimeout(finishTimer);
      const reduced = window.matchMedia && window.matchMedia('(prefers-reduced-motion: reduce)').matches;
      finishTimer = window.setTimeout(settle, reduced ? 0 : 300);
    }

    function open() {
      if (isOpen) return;
      // A reversal retains the original lock; do not overwrite saved styles.
      if (finishTimer === null) {
        lastFocused = document.activeElement;
        savedOverflow = document.body.style.overflow;
        savedPadding = document.body.style.paddingRight;
        const scrollbar = Math.max(0, window.innerWidth - document.documentElement.clientWidth);
        if (scrollbar) document.body.style.paddingRight = (parseFloat(window.getComputedStyle(document.body).paddingRight) + scrollbar) + 'px';
      }
      isOpen = true;
      window.clearTimeout(finishTimer);
      if (frame !== null) window.cancelAnimationFrame(frame);
      drawer.inert = false;
      drawer.setAttribute('aria-hidden', 'false');
      burger.setAttribute('aria-expanded', 'true');
      document.body.style.overflow = 'hidden';
      drawer.classList.add('mobile-drawer--moving');
      // Promote the panel before its transform changes; never scroll to an offscreen control.
      frame = window.requestAnimationFrame(function () {
        frame = window.requestAnimationFrame(function () {
          frame = null;
          if (!isOpen) return;
          drawer.classList.add('mobile-drawer--open');
          waitForMotion();
        });
      });
    }

    function close() {
      if (!isOpen) return;
      isOpen = false;
      if (frame !== null) window.cancelAnimationFrame(frame);
      frame = null;
      focusWithoutScroll(lastFocused);
      drawer.inert = true;
      drawer.setAttribute('aria-hidden', 'true');
      burger.setAttribute('aria-expanded', 'false');
      drawer.classList.add('mobile-drawer--moving');
      drawer.classList.remove('mobile-drawer--open');
      // Keep the background stationary for the entire closing transition.
      waitForMotion();
    }

    if (dialog) dialog.addEventListener('transitionend', function (event) {
      if (event.target === dialog && event.propertyName === 'transform' && frame === null) settle();
    });

    burger.addEventListener('click', open);
    if (closeBtn) closeBtn.addEventListener('click', close);
    if (backdrop) backdrop.addEventListener('click', close);

    $$('a', drawer).forEach(function (link) {
      link.addEventListener('click', close);
    });

    document.addEventListener('keydown', function (event) {
      if (!drawer.classList.contains('mobile-drawer--open')) return;

      if (event.key === 'Escape') {
        close();
        return;
      }

      if (event.key !== 'Tab' || !dialog) return;

      const focusable = $$('a[href], button:not([disabled]), summary, input:not([disabled]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])', dialog)
        .filter(function (element) {
          return element.offsetParent !== null;
        });

      if (!focusable.length) return;

      const first = focusable[0];
      const last = focusable[focusable.length - 1];

      if (event.shiftKey && document.activeElement === first) {
        event.preventDefault();
        focusWithoutScroll(last);
      } else if (!event.shiftKey && document.activeElement === last) {
        event.preventDefault();
        focusWithoutScroll(first);
      }
    });
  }

  function initSmoothNavigation() {
    $$('a[href^="#"]').forEach(function (link) {
      link.addEventListener('click', function (event) {
        const id = (link.getAttribute('href') || '').slice(1);
        if (!id || !document.getElementById(id)) return;

        event.preventDefault();
        scrollToId(id);
      });
    });
  }

  function initCalculator() {
    const calc = $('.calculator-card');
    if (!calc) return;

    const data = {
      '1': {
        recommended: 'ТОПАС 4 / АСТРА 4',
        equipmentCost: 87900,
        installCost: 28000,
        turnkeyCost: 115900,
        volume: '0.8 м³/сут',
        desc: 'Прекрасный выбор для дачного дома или небольшой семьи. Быстрая копка за 8 часов.'
      },
      '2': {
        recommended: 'АСТРА 5 / ТОПАС 5',
        equipmentCost: 99900,
        installCost: 32000,
        turnkeyCost: 131900,
        volume: '1.0 м³/сут',
        desc: 'Идеальный баланс для постоянного проживания стандартной семьи. Лидер продаж!'
      },
      '3': {
        recommended: 'ТОПАС 8 / АСТРА 8',
        equipmentCost: 134900,
        installCost: 38000,
        turnkeyCost: 172900,
        volume: '1.6 м³/сут',
        desc: 'Для просторных коттеджей с 2 санузлами, ванной и стиральной машиной.'
      },
      '4': {
        recommended: 'ТОПАС 10 / KOLO VESI 12',
        equipmentCost: 198000,
        installCost: 45000,
        turnkeyCost: 243000,
        volume: '2.5 м³/сут',
        desc: 'Усиленная инженерная станция для больших усадеб, гостевых домов или дуплексов.'
      }
    };

    function formatRub(value) {
      return new Intl.NumberFormat('ru-RU').format(value) + ' ₽';
    }

    function setText(selector, value) {
      const el = $(selector, calc);
      if (el) el.textContent = value;
    }

    function update(value, activeButton) {
      const item = data[value];
      if (!item) return;

      $$('.js-calc-option', calc).forEach(function (button) {
        const active = button === activeButton;
        button.classList.toggle('calculator-card__btn-option--active', active);
        button.setAttribute('aria-pressed', active ? 'true' : 'false');
      });

      setText('.js-calc-rec', item.recommended);
      setText('.js-calc-volume', item.volume);
      setText('.js-calc-equipment', formatRub(item.equipmentCost));
      setText('.js-calc-install', formatRub(item.installCost));
      setText('.js-calc-original', formatRub(Math.round(item.turnkeyCost * 1.25)));
      setText('.js-calc-turnkey', formatRub(item.turnkeyCost));

      const tip = $('.js-calc-tip', calc);
      if (tip) {
        tip.innerHTML =
          '<span class="icon icon-lightbulb" aria-hidden="true"></span> <strong>Совет инженера:</strong> ' +
          item.desc;
      }
    }

    $$('.js-calc-option', calc).forEach(function (button) {
      button.addEventListener('click', function () {
        update(button.getAttribute('data-value'), button);
      });
    });

    const activeButton =
      $('.js-calc-option.calculator-card__btn-option--active', calc) ||
      $('.js-calc-option', calc);

    if (activeButton) {
      update(activeButton.getAttribute('data-value'), activeButton);
    }
  }

  function initCatalog() {
    const section = $('#catalog');
    if (!section) return;

    const track = $('.js-catalog-track', section);
    const prevBtn = $('.js-catalog-prev', section);
    const nextBtn = $('.js-catalog-next', section);
    const indicator = $('.js-catalog-indicator', section);
    const countEl = $('.js-catalog-count', section);

    if (!track) return;

    const allSlides = $$('.js-catalog-slide', track);
    if (!allSlides.length) return;

    const maxSlides = 12;
    const slides = allSlides.slice(0, maxSlides);

    let page = 0;

    allSlides.forEach(function (slide, index) {
      slide.style.display = index < maxSlides ? '' : 'none';
    });

    function getCardsPerPage() {
      return window.innerWidth < 768 ? 1 : (window.innerWidth < 1024 ? 2 : 4);
    }

    function getTotalPages() {
      return Math.max(1, Math.ceil(slides.length / getCardsPerPage()));
    }

    function applyLayout() {
  const perPage = getCardsPerPage();
  const gap = 24;
  const basis = 'calc((100% - ' + (gap * (perPage - 1)) + 'px) / ' + perPage + ')';

  track.style.display = 'flex';
  track.style.gap = gap + 'px';
  track.style.overflowX = 'auto';
  track.style.scrollSnapType = 'x mandatory';
  track.style.scrollBehavior = 'smooth';
  track.style.webkitOverflowScrolling = 'touch';
  track.style.scrollbarWidth = 'none';

  slides.forEach(function (slide) {
    slide.style.flex = '0 0 ' + basis;
    slide.style.maxWidth = basis;
    slide.style.scrollSnapAlign = 'start';
    slide.style.boxSizing = 'border-box';
  });
}

    function updateControls() {
      const totalPages = getTotalPages();

      if (page > totalPages - 1) {
        page = totalPages - 1;
      }

      if (indicator) {
        indicator.textContent = (page + 1) + ' / ' + totalPages;
      }

      if (countEl) {
        countEl.textContent = String(slides.length);
      }

      if (prevBtn) {
        prevBtn.disabled = totalPages <= 1;
      }

      if (nextBtn) {
        nextBtn.disabled = totalPages <= 1;
      }
    }

    function scrollToPage(nextPage) {
  const totalPages = getTotalPages();
  const perPage = getCardsPerPage();

  page = ((nextPage % totalPages) + totalPages) % totalPages;

  track.scrollTo({
    left: page * ((slides[0].offsetWidth || track.clientWidth) + 24) * perPage,
    behavior: 'smooth'
  });

  updateControls();
}

    if (prevBtn) {
      prevBtn.addEventListener('click', function () {
        scrollToPage(page - 1);
      });
    }

    if (nextBtn) {
      nextBtn.addEventListener('click', function () {
        scrollToPage(page + 1);
      });
    }

    track.addEventListener('scroll', function () {
      const perPage = getCardsPerPage();
      const firstSlide = slides[0];
      if (!firstSlide) return;

      const slideWidth = firstSlide.offsetWidth || 1;
      const newPage = Math.round(track.scrollLeft / ((slideWidth + 24) * perPage));

      if (newPage !== page) {
        page = Math.max(0, Math.min(newPage, getTotalPages() - 1));
        updateControls();
      }
    }, { passive: true });

    window.addEventListener('resize', function () {
      applyLayout();
      scrollToPage(page);
    });

    applyLayout();
    updateControls();
    scrollToPage(0);
  }

  function initSoilAdvisor() {
    const section = $('#soil-advisor');
    if (!section) return;

    const tabs = $$('.js-soil-tabs .soil-section__tab', section);
    const panels = $$('.js-soil-content', section);

    if (!tabs.length || !panels.length) return;

    function activate(soilId) {
      if (!soilId) return;

      tabs.forEach(function (tab) {
        const active = tab.getAttribute('data-soil') === soilId;

        tab.classList.toggle('soil-section__tab--active', active);
        tab.setAttribute('aria-selected', active ? 'true' : 'false');
        tab.setAttribute('tabindex', active ? '0' : '-1');
      });

      panels.forEach(function (panel) {
        const active = panel.getAttribute('data-soil') === soilId;

        panel.classList.toggle('soil-section__details-content--active', active);
        panel.hidden = !active;
      });
    }

    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        activate(tab.getAttribute('data-soil'));
      });

      tab.addEventListener('keydown', function (event) {
        if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;

        event.preventDefault();

        const currentIndex = tabs.indexOf(tab);
        let nextIndex = currentIndex;

        if (event.key === 'ArrowRight') nextIndex = (currentIndex + 1) % tabs.length;
        if (event.key === 'ArrowLeft') nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
        if (event.key === 'Home') nextIndex = 0;
        if (event.key === 'End') nextIndex = tabs.length - 1;

        const nextTab = tabs[nextIndex];
        activate(nextTab.getAttribute('data-soil'));
        nextTab.focus();
      });
    });

    const activeTab =
      $('.soil-section__tab--active', section) ||
      tabs[0];

    if (activeTab) {
      activate(activeTab.getAttribute('data-soil'));
    }
  }

  function initCases() {
    const section = $('#cases');
    if (!section) return;

    section.classList.add('cases-section--enhanced');

    const tabs = $$('.js-case-tab', section);
    const cards = $$('.js-case-card', section);

    if (!tabs.length || !cards.length) return;

    const tabList = $('.js-cases-tabs', section);
    if (tabList) {
      tabList.setAttribute('role', 'tablist');
      tabList.setAttribute('aria-label', 'Примеры выполненных работ');
    }

    tabs.forEach(function (tab) {
      const index = tab.getAttribute('data-index');
      tab.setAttribute('role', 'tab');
      tab.id = 'case-tab-' + index;
      tab.setAttribute('aria-controls', 'case-panel-' + index);
    });

    cards.forEach(function (card) {
      const index = card.getAttribute('data-index');
      card.setAttribute('role', 'tabpanel');
      card.id = 'case-panel-' + index;
      card.setAttribute('aria-labelledby', 'case-tab-' + index);
    });

    function activate(index) {
      if (!index) return;

      tabs.forEach(function (tab) {
        const active = tab.getAttribute('data-index') === index;

        tab.classList.toggle('cases-section__tab--active', active);
        tab.setAttribute('aria-selected', active ? 'true' : 'false');
        tab.setAttribute('tabindex', active ? '0' : '-1');
      });

      cards.forEach(function (card) {
        const active = card.getAttribute('data-index') === index;

        card.classList.toggle('cases-section__card--active', active);
        card.hidden = !active;
      });
    }

    tabs.forEach(function (tab) {
      tab.addEventListener('click', function () {
        activate(tab.getAttribute('data-index'));
      });

      tab.addEventListener('keydown', function (event) {
        if (!['ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;

        event.preventDefault();

        const currentIndex = tabs.indexOf(tab);
        let nextIndex = currentIndex;

        if (event.key === 'ArrowRight') nextIndex = (currentIndex + 1) % tabs.length;
        if (event.key === 'ArrowLeft') nextIndex = (currentIndex - 1 + tabs.length) % tabs.length;
        if (event.key === 'Home') nextIndex = 0;
        if (event.key === 'End') nextIndex = tabs.length - 1;

        activate(tabs[nextIndex].getAttribute('data-index'));
        tabs[nextIndex].focus();
      });
    });

    const activeTab =
      $('.js-case-tab.cases-section__tab--active', section) ||
      tabs[0];

    if (activeTab) {
      activate(activeTab.getAttribute('data-index'));
    }
  }

function initModal() {
  const callbackModal = $('.js-modal-callback');
  const leadModal = $('.js-lead-modal');
  let modalReturnFocus = null;

  function setInput(modal, name, value) {
    if (!modal) return;

    const input = modal.querySelector('[name="' + name + '"]');
    if (input) input.value = value || '';
  }

  function setTitle(modal, title) {
    if (!modal) return;

    const titleEl = $('.js-modal-title-text', modal);
    if (titleEl && title) titleEl.textContent = title;

    setInput(modal, 'form_type', title || 'Заявка');
  }

  function setContext(modal, html) {
    if (!modal) return;

    const box = modal.querySelector('.js-modal-rec-box');
    if (!box) return;

    if (html) {
      box.innerHTML = html;
      box.classList.remove('hidden');
    } else {
      box.innerHTML = '';
      box.classList.add('hidden');
    }
  }

  function openModal(modal, title, options) {
    if (!modal) return;

    options = options || {};

    setTitle(modal, title);
    setInput(modal, 'model', options.model || '');
    setInput(modal, 'comment', options.comment || '');

    if (options.contextHtml !== undefined) {
      setContext(modal, options.contextHtml);
    }

    modalReturnFocus = document.activeElement;
    modal.classList.add('modal--open');
    modal.classList.remove('hidden');
    modal.setAttribute('aria-hidden', 'false');
    document.body.classList.add('vanilla-scroll-lock');

    window.requestAnimationFrame(function () {
      const focusTarget = modal.querySelector('input:not([type="hidden"]), select, textarea') ||
        modal.querySelector('button, a[href]');
      if (focusTarget) focusTarget.focus();
    });
  }

  function closeModal(modal) {
    if (!modal || !modal.classList.contains('modal--open')) return;

    modal.classList.remove('modal--open');
    modal.classList.add('hidden');
    modal.setAttribute('aria-hidden', 'true');
    document.body.classList.remove('vanilla-scroll-lock');

    if (modalReturnFocus && typeof modalReturnFocus.focus === 'function') {
      modalReturnFocus.focus();
    }

    modalReturnFocus = null;
  }

  document.addEventListener('click', function (event) {
    const closeTrigger = event.target.closest('.js-modal-close');
    const backdrop = event.target.closest('.js-modal-backdrop');

    if (closeTrigger) {
      event.preventDefault();
      closeModal(closeTrigger.closest('.modal'));
      return;
    }

    if (backdrop && event.target === backdrop) {
      closeModal(backdrop.closest('.modal'));
      return;
    }

    const callbackTrigger = event.target.closest('.js-btn-callback');
    const catalogTrigger = event.target.closest('.js-catalog-order');
    const estimateTrigger = event.target.closest('.js-btn-estimate');
    const caseTrigger = event.target.closest('.js-btn-case-cta');

    if (callbackTrigger) {
      event.preventDefault();

      openModal(
        callbackModal,
        callbackTrigger.getAttribute('data-title') || 'Обратный звонок'
      );

      return;
    }

    if (catalogTrigger) {
      event.preventDefault();

const catalogData = getCatalogCardData(catalogTrigger);
const title = catalogData.model
  ? 'Заказать монтаж: ' + catalogData.model
  : 'Заказать монтаж';

openModal(leadModal, title, {
  model: catalogData.model,
  comment:
    'Заявка из каталога. ' +
    'Модель: ' + catalogData.model + '. ' +
    'Проживающих: ' + catalogData.capacity + '. ' +
    'Цена от: ' + catalogData.price + '.',
  contextHtml: buildCatalogContextHtml(catalogData)
});
    }

    if (estimateTrigger) {
      event.preventDefault();

      const calculatorModel = $('.js-calc-rec');
      const calculatorTotal = $('.js-calc-turnkey');
      const model = calculatorModel ? calculatorModel.textContent.trim() : '';
      const total = calculatorTotal ? calculatorTotal.textContent.trim() : '';

      openModal(
        leadModal,
        estimateTrigger.getAttribute('data-title') || 'Получить расчет стоимости',
        {
          model: model,
          comment:
            'Предварительный расчёт с главной страницы. ' +
            'Модель: ' + (model || 'уточняется') + '. ' +
            'Итого под ключ: ' + (total || 'после осмотра') + '.',
          contextHtml: buildCalculatorContextHtml()
        }
      );

      return;
    }

    if (caseTrigger) {
      event.preventDefault();

      const caseData = getCaseData(caseTrigger);
      const title = 'Смета аналогично ' + caseData.model;

      openModal(leadModal, title, {
        model: caseData.model,
        comment:
          'Заявка на аналогичный монтаж. ' +
          'Станция: ' + caseData.model + '. ' +
          'Локация: ' + caseData.location + '. ' +
          'Грунт: ' + caseData.soil + '. ' +
          'Длительность: ' + caseData.duration + '. ' +
          'Стоимость: ' + caseData.price + '.',
        contextHtml: buildCaseContextHtml(caseData)
      });

      return;
    }
  });

  document.addEventListener('keydown', function (event) {
    const openModalElement = document.querySelector('.modal.modal--open');
    if (!openModalElement) return;

    if (event.key === 'Tab') {
      const focusable = Array.from(openModalElement.querySelectorAll(
        'a[href], button:not([disabled]), input:not([disabled]):not([type="hidden"]), select:not([disabled]), textarea:not([disabled]), [tabindex]:not([tabindex="-1"])'
      ));

      if (focusable.length) {
        const first = focusable[0];
        const last = focusable[focusable.length - 1];

        if (event.shiftKey && document.activeElement === first) {
          event.preventDefault();
          focusWithoutScroll(last);
        } else if (!event.shiftKey && document.activeElement === last) {
          event.preventDefault();
          focusWithoutScroll(first);
        }
      }

      return;
    }

    if (event.key !== 'Escape') return;

    closeModal(openModalElement);
  });
}

function initStaticActions() {
  document.addEventListener('click', function (event) {
    const catalog = event.target.closest('.js-hero-catalog-btn');
    const soil = event.target.closest('.js-hero-soil-btn');

    if (catalog) {
      event.preventDefault();
      scrollToId('catalog');
      return;
    }

    if (soil) {
      event.preventDefault();
      scrollToId('soil-advisor');
    }
  });
}

function getCaseData(button) {
  const card = button.closest('.js-case-card');

  if (!card) {
    return {
      model: button.getAttribute('data-model') || 'аналогичный монтаж',
      location: '',
      soil: '',
      duration: '',
      price: ''
    };
  }

  function getSpecValue(labelText) {
    const items = card.querySelectorAll('.cases-section__spec-item');

    for (const item of items) {
      const label = item.querySelector('.cases-section__spec-label');
      const value = item.querySelector('.cases-section__spec-value');

      if (!label || !value) continue;

      if (label.textContent.replace(/\s+/g, ' ').trim().includes(labelText)) {
        return value.textContent.replace(/\s+/g, ' ').trim();
      }
    }

    return '';
  }

  const priceEl = card.querySelector('.cases-section__price-value');

  return {
    model: getSpecValue('Станция') || button.getAttribute('data-model') || 'аналогичный монтаж',
    location: getSpecValue('Локация'),
    soil: getSpecValue('Грунт'),
    duration: getSpecValue('Длительность'),
    price: priceEl ? priceEl.textContent.replace(/\s+/g, ' ').trim() : ''
  };
}

function buildCaseContextHtml(caseData) {
  return `
    <div class="modal__rec-row">
      <span class="modal__rec-label">Станция:</span>
      <span class="modal__rec-val">${caseData.model || 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Локация:</span>
      <span class="modal__rec-val">${caseData.location || 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Грунт:</span>
      <span class="modal__rec-val">${caseData.soil || 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Длительность:</span>
      <span class="modal__rec-val">${caseData.duration || '1 день'}</span>
    </div>
    <div class="modal__rec-divider"></div>
    <div class="modal__rec-total-row">
      <span class="modal__rec-label">Итоговая стоимость:</span>
      <span class="modal__rec-total-val">${caseData.price || 'после замера'}</span>
    </div>
  `;
}

function buildCalculatorContextHtml() {
  const rec = $('.js-calc-rec');
  const volume = $('.js-calc-volume');
  const equipment = $('.js-calc-equipment');
  const install = $('.js-calc-install');
  const total = $('.js-calc-turnkey');

  return `
    <div class="modal__rec-row">
      <span class="modal__rec-label">Рекомендуемая станция:</span>
      <span class="modal__rec-val">${rec ? rec.textContent.trim() : 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Производительность:</span>
      <span class="modal__rec-val">${volume ? volume.textContent.trim() : 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Оборудование:</span>
      <span class="modal__rec-val">${equipment ? equipment.textContent.trim() : 'уточняется'}</span>
    </div>
    <div class="modal__rec-row">
      <span class="modal__rec-label">Монтаж:</span>
      <span class="modal__rec-val">${install ? install.textContent.trim() : 'уточняется'}</span>
    </div>
    <div class="modal__rec-divider"></div>
    <div class="modal__rec-total-row">
      <span class="modal__rec-label">Итого под ключ:</span>
      <span class="modal__rec-total-val">${total ? total.textContent.trim() : 'после замера'}</span>
    </div>
  `;
}
function buildCatalogContextHtml(data) {
  const rows = [];

  if (data.model) {
    rows.push(`
      <div class="modal__rec-row">
        <span class="modal__rec-label">Модель:</span>
        <span class="modal__rec-val">${data.model}</span>
      </div>
    `);
  }

  if (data.capacity) {
    rows.push(`
      <div class="modal__rec-row">
        <span class="modal__rec-label">Проживающих:</span>
        <span class="modal__rec-val">${data.capacity}</span>
      </div>
    `);
  }

  data.specs.forEach(function (spec) {
    rows.push(`
      <div class="modal__rec-row">
        <span class="modal__rec-label">${spec.label}</span>
        <span class="modal__rec-val">${spec.value}</span>
      </div>
    `);
  });

  if (data.price) {
    rows.push(`
      <div class="modal__rec-divider"></div>
      <div class="modal__rec-total-row">
        <span class="modal__rec-label">Цена от:</span>
        <span class="modal__rec-total-val">${data.price}</span>
      </div>
    `);
  }

  return rows.join('');
}
function fillEstimateModalFromCase(caseData) {
  const modal = document.querySelector('.js-modal-estimate');
  if (!modal) return;

  const titleEl = modal.querySelector('.js-modal-title-text');
  const box = modal.querySelector('.js-modal-rec-box');

  if (titleEl) {
    titleEl.textContent = 'Смета аналогично ' + caseData.model;
  }

  if (box) {
    box.innerHTML = `
      <div class="modal__rec-row">
        <span class="modal__rec-label">Станция:</span>
        <span class="modal__rec-val">${caseData.model}</span>
      </div>

      <div class="modal__rec-row">
        <span class="modal__rec-label">Локация:</span>
        <span class="modal__rec-val">${caseData.location || 'уточняется'}</span>
      </div>

      <div class="modal__rec-row">
        <span class="modal__rec-label">Грунт:</span>
        <span class="modal__rec-val">${caseData.soil || 'уточняется после выезда'}</span>
      </div>

      <div class="modal__rec-row">
        <span class="modal__rec-label">Длительность:</span>
        <span class="modal__rec-val">${caseData.duration || '1 день'}</span>
      </div>

      <div class="modal__rec-divider"></div>

      <div class="modal__rec-total-row">
        <span class="modal__rec-label">Итоговая стоимость:</span>
        <span class="modal__rec-total-val">${caseData.price || 'после замера'}</span>
      </div>
    `;
  }

  const hiddenModel = modal.querySelector('input[name="model"]');
  if (hiddenModel) {
    hiddenModel.value = caseData.model;
  }

  const hiddenComment = modal.querySelector('input[name="comment"], textarea[name="comment"]');
  if (hiddenComment) {
    hiddenComment.value =
      'Заявка на аналогичный монтаж. ' +
      'Станция: ' + caseData.model + '. ' +
      'Локация: ' + caseData.location + '. ' +
      'Грунт: ' + caseData.soil + '. ' +
      'Длительность: ' + caseData.duration + '. ' +
      'Стоимость: ' + caseData.price + '.';
  }
}
function getCatalogCardData(button) {
  const card = button.closest('.catalog-card');

  if (!card) {
    return {
      model: button.getAttribute('data-name') || '',
      capacity: '',
      price: '',
      specs: []
    };
  }

  const modelEl = card.querySelector('.catalog-card__title');
  const capacityEl = card.querySelector('.catalog-card__capacity span');
  const priceEl = card.querySelector('.catalog-card__price-actual');
  const specRows = card.querySelectorAll('.catalog-card__spec-row');

  const specs = Array.from(specRows).map(function (row) {
    const label = row.querySelector('.catalog-card__spec-label');
    const value = row.querySelector('.catalog-card__spec-value');

    return {
      label: label ? label.textContent.replace(/\s+/g, ' ').trim() : '',
      value: value ? value.textContent.replace(/\s+/g, ' ').trim() : ''
    };
  }).filter(function (item) {
    return item.label && item.value;
  });

  return {
    model:
      button.getAttribute('data-name') ||
      (modelEl ? modelEl.textContent.replace(/\s+/g, ' ').trim() : ''),
    capacity: capacityEl ? capacityEl.textContent.replace(/\s+/g, ' ').trim() : '',
    price: priceEl ? priceEl.textContent.replace(/\s+/g, ' ').trim() : '',
    specs: specs
  };
}
function initAjaxForms() {
  const siteKey = '6LeGBsogAAAAACm0d6v7meUZwgPegL4J7V2CvsVD';

  function waitForRecaptcha(callback, attempts) {
    attempts = attempts || 0;

    if (window.grecaptcha && typeof grecaptcha.ready === 'function') {
      callback();
      return;
    }

    if (attempts > 50) {
      console.warn('reCAPTCHA не загрузилась');
      return;
    }

    setTimeout(function () {
      waitForRecaptcha(callback, attempts + 1);
    }, 200);
  }

  function setToken(form, token) {
    let input = form.querySelector('input[name="g-recaptcha-response"]');

    if (!input) {
      input = document.createElement('input');
      input.type = 'hidden';
      input.name = 'g-recaptcha-response';
      form.prepend(input);
    }

    input.value = token;
  }

  function setLeadAction(form) {
    let input = form.querySelector('input[name="_zs_action"]');

    if (!input) {
      input = document.createElement('input');
      input.type = 'hidden';
      input.name = '_zs_action';
      form.prepend(input);
    }

    input.value = 'lead';
  }

  function showFormMessage(form, message, success) {
    let box = form.querySelector('.js-form-message');

    if (!box) {
      box = document.createElement('div');
      box.className = 'form-message js-form-message';
      form.appendChild(box);
    }

    box.textContent = message;
    box.classList.toggle('form-message--success', success);
    box.classList.toggle('form-message--error', !success);
  }

  waitForRecaptcha(function () {
    document
      .querySelectorAll('form[data-lead-form], form.js-modal-form, form.js-cta-form, form[data-ajax-form]')
      .forEach(function (form) {
      form.addEventListener('submit', function (event) {
        event.preventDefault();
        setLeadAction(form);

        const submitBtn = form.querySelector('[type="submit"]');
        const originalText = submitBtn ? submitBtn.textContent : '';

        if (submitBtn) {
          submitBtn.disabled = true;
          submitBtn.textContent = 'Отправляем...';
        }

        grecaptcha.ready(function () {
          grecaptcha.execute(siteKey, { action: 'submit' }).then(function (token) {
            setToken(form, token);

            fetch(form.getAttribute('action') || window.location.href, {
              method: 'POST',
              body: new FormData(form),
              headers: {
                'X-Requested-With': 'XMLHttpRequest'
              }
            })
              .then(function (response) {
                return response.json();
              })
              .then(function (data) {
                if (data.status === true || data.result === 'success') {
                  showFormMessage(form, 'Заявка отправлена. Мы скоро свяжемся с вами.', true);
                  form.reset();
                } else {
                  const message = data.message === 'invalid_phone'
                    ? 'Проверьте номер телефона.'
                    : 'Ошибка отправки. Попробуйте ещё раз.';

                  showFormMessage(form, message, false);
                }
              })
              .catch(function () {
                showFormMessage(form, 'Ошибка соединения. Попробуйте позже.', false);
              })
              .finally(function () {
                if (submitBtn) {
                  submitBtn.disabled = false;
                  submitBtn.textContent = originalText;
                }
              });
          });
        });
      });
    });
  });
}


function initGiftsSelector() {
  const giftButtons = document.querySelectorAll('.js-gift-opt');

  if (!giftButtons.length) return;

  const labelEl = document.querySelector('.js-selected-bonus-label');
  const modalSelect = document.querySelector('.js-modal-select-bonus');
  const hiddenInputs = document.querySelectorAll(
    'input[name="bonus"], .js-selected-bonus-input'
  );

  function setBonus(button) {
    const bonus = button.getAttribute('data-label') || button.textContent.trim();

    giftButtons.forEach(function (item) {
      const active = item === button;

      item.classList.toggle('cta-section__gift-btn--active', active);
      item.setAttribute('aria-pressed', active ? 'true' : 'false');
    });

    if (labelEl) {
      labelEl.textContent = bonus;
    }

    if (modalSelect) {
      modalSelect.value = bonus;
    }

    hiddenInputs.forEach(function (input) {
      input.value = bonus;
    });
  }

  giftButtons.forEach(function (button) {
    button.addEventListener('click', function () {
      setBonus(button);
    });
  });

  const activeButton =
    document.querySelector('.js-gift-opt.cta-section__gift-btn--active') ||
    giftButtons[0];

  setBonus(activeButton);
}

function initExclusiveFilters() {
  document.querySelectorAll('[data-exclusive-filter]').forEach(function (group) {
    const options = Array.from(group.querySelectorAll('[data-exclusive-filter-option]'));
    const filterInputs = Array.from(group.querySelectorAll('[data-exclusive-filter-input]'));

    if (!options.length || !filterInputs.length) return;

    function syncFilter(option) {
      const activeParameter = option.dataset.exclusiveFilterOption || '';

      filterInputs.forEach(function (input) {
        input.disabled = input.dataset.exclusiveFilterInput !== activeParameter;
      });
    }

    const searchParams = new URLSearchParams(window.location.search);
    const activeInput = filterInputs.find(function (input) {
      return searchParams.has(input.name);
    });
    const activeParameter = activeInput ? activeInput.dataset.exclusiveFilterInput : '';
    const checkedOption = options.find(function (option) {
      return option.dataset.exclusiveFilterOption === activeParameter;
    }) || options.find(function (option) {
      return option.checked;
    });

    if (checkedOption) {
      checkedOption.checked = true;
      syncFilter(checkedOption);
    }

    options.forEach(function (option) {
      option.addEventListener('change', function () {
        if (option.checked) syncFilter(option);
      });
    });

    const form = group.closest('form');
    if (form) {
      form.addEventListener('submit', function () {
        options.forEach(function (option) {
          option.disabled = true;
        });
      });
    }
  });
}

function initRangeFilters() {
  document.querySelectorAll('[data-range-filter]').forEach(function (group) {
    const options = Array.from(group.querySelectorAll('[data-range-filter-option]'));
    const fromInput = group.querySelector('[data-range-filter-input="from"]');
    const toInput = group.querySelector('[data-range-filter-input="to"]');

    if (!options.length || !fromInput || !toInput) return;

    function syncFilter(option) {
      const from = option.dataset.rangeFrom || '';
      const to = option.dataset.rangeTo || '';

      fromInput.value = from;
      fromInput.disabled = !from;
      toInput.value = to;
      toInput.disabled = !to;
    }

    const searchParams = new URLSearchParams(window.location.search);
    const currentFrom = searchParams.get(fromInput.name) || '';
    const currentTo = searchParams.get(toInput.name) || '';
    const checkedOption = options.find(function (option) {
      return option.dataset.rangeFrom === currentFrom && option.dataset.rangeTo === currentTo;
    }) || options.find(function (option) {
      return option.checked;
    });

    if (checkedOption) {
      checkedOption.checked = true;
      syncFilter(checkedOption);
    }

    options.forEach(function (option) {
      option.addEventListener('change', function () {
        if (option.checked) syncFilter(option);
      });
    });

    const form = group.closest('form');
    if (form) {
      form.addEventListener('submit', function () {
        options.forEach(function (option) {
          option.disabled = true;
        });
      });
    }
  });
}

function initFaqAccordion() {
  const container = document.querySelector('.js-faq-accordion');
  if (!container) return;

  const items = Array.from(container.querySelectorAll('.js-faq-item'));
  if (!items.length) return;

  function closeItem(item) {
    const header = item.querySelector('.js-faq-header');
    const content = item.querySelector('.faq-item__content');

    item.classList.remove('faq-item--open');

    if (header) {
      header.setAttribute('aria-expanded', 'false');
    }

    if (content) {
      content.style.maxHeight = '0';
      content.style.opacity = '0';
      content.hidden = true;
    }
  }

  function openItem(item) {
    const header = item.querySelector('.js-faq-header');
    const content = item.querySelector('.faq-item__content');

    item.classList.add('faq-item--open');

    if (header) {
      header.setAttribute('aria-expanded', 'true');
    }

    if (content) {
      content.hidden = false;
      content.style.maxHeight = content.scrollHeight + 'px';
      content.style.opacity = '1';
    }
  }

  function activate(targetItem) {
    const isOpen = targetItem.classList.contains('faq-item--open');

    items.forEach(function (item) {
      closeItem(item);
    });

    if (!isOpen) {
      openItem(targetItem);
    }
  }

  items.forEach(function (item, index) {
    const header = item.querySelector('.js-faq-header');
    const content = item.querySelector('.faq-item__content');

    if (!header || !content) return;

    header.setAttribute('type', 'button');

    if (!header.hasAttribute('data-index')) {
      header.setAttribute('data-index', String(index));
    }

    if (item.classList.contains('faq-item--open')) {
      openItem(item);
    } else {
      closeItem(item);
    }

    header.addEventListener('click', function () {
      activate(item);
    });
  });
}
  function init() {
    initStickyHeader();
    initMobileMenu();
    initSmoothNavigation();
    initCalculator();
    initCatalog();
    initSoilAdvisor();
    initCases();
    initModal();
    initStaticActions();
    initAjaxForms();
    initGiftsSelector();
    initExclusiveFilters();
    initRangeFilters();
    initFaqAccordion();
  }
  
  document.querySelectorAll('input[type="tel"]').forEach((input) => {
    const formatPhone = (value) => {
        const numbers = value.replace(/\D/g, '');

        let digits = numbers;

        if (digits.startsWith('8')) {
            digits = '7' + digits.slice(1);
        }

        if (!digits.startsWith('7')) {
            digits = '7' + digits;
        }

        digits = digits.substring(0, 11);

        let result = '+7';

        if (digits.length > 1) {
            result += ' (' + digits.substring(1, 4);
        }

        if (digits.length >= 5) {
            result += ') ' + digits.substring(4, 7);
        }

        if (digits.length >= 8) {
            result += '-' + digits.substring(7, 9);
        }

        if (digits.length >= 10) {
            result += '-' + digits.substring(9, 11);
        }

        return result;
    };

    input.addEventListener('focus', () => {
        if (!input.value) {
            input.value = '+7';
        }
    });

    input.addEventListener('input', () => {
        input.value = formatPhone(input.value);
    });

    input.addEventListener('blur', () => {
        if (input.value === '+7') {
            input.value = '';
        }
    });

    input.addEventListener('paste', (e) => {
        e.preventDefault();
        input.value = formatPhone(
            (e.clipboardData || window.clipboardData).getData('text')
        );
    });

    input.addEventListener('keydown', (e) => {
        if (
            input.selectionStart <= 2 &&
            (e.key === 'Backspace' || e.key === 'Delete')
        ) {
            e.preventDefault();
        }
    });
});

document.querySelectorAll('form').forEach((form) => {
    form.addEventListener('submit', (e) => {
        const phone = form.querySelector('input[type="tel"]');

        if (!phone) {
            return;
        }

        const digits = phone.value.replace(/\D/g, '');

        if (digits.length !== 11 || digits[0] !== '7') {
            e.preventDefault();
            phone.focus();
            phone.setCustomValidity('Введите корректный номер телефона.');
            phone.reportValidity();
        } else {
            phone.setCustomValidity('');
        }
    });
});
  
document.addEventListener('click', function (event) {
  const thumb = event.target.closest('.media-strip__item');

  if (!thumb) {
    return;
  }

  const mediaStrip = thumb.closest('.media-strip');
  const mediaRoot = mediaStrip ? mediaStrip.parentElement : null;
  const mediaCard = mediaRoot ? mediaRoot.querySelector('.media-card') : null;
  const mainLink = mediaCard ? mediaCard.querySelector('.media-card__link') : null;
  const mainImage = mediaCard ? mediaCard.querySelector('img') : null;
  const thumbImage = thumb.querySelector('img');

  if (!mediaStrip || !mediaCard || !mainLink || !mainImage || !thumbImage) {
    return;
  }

  event.preventDefault();

  mainLink.href = thumb.href;
  mainImage.src = thumb.href;
  mainImage.alt = thumbImage.alt || mainImage.alt;

  mediaStrip
    .querySelectorAll('.media-strip__item[aria-current="true"]')
    .forEach(function (item) {
      item.removeAttribute('aria-current');
    });

  thumb.setAttribute('aria-current', 'true');
});
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
  
  /* YANDEX MAPS */
  const YMAPS_API_KEY = '6c6c6163-4626-4999-8d2b-68492bbb570f';

  let map = null;
  let mapLoadPromise = null;
  let mapCreatePromise = null;
  let pendingCity = 'Зеленоград';

  const geoCache = {
    'Зеленоград': [37.1906, 55.9862],
    'Москва': [37.6176, 55.7558],
    'Истра': [36.8687, 55.9142],
    'Солнечногорск': [36.9838, 56.1851],
    'Химки': [37.4445, 55.8892],
    'Клин': [36.7287, 56.3333],
    'Волоколамск': [35.9586, 56.0357],
    'Звенигород': [36.8590, 55.7340],
    'Красногорск': [37.3187, 55.8311],
    'Долгопрудный': [37.5103, 55.9386]
  };

  function getCityZoom(city) {
    return city === 'Зеленоград' ? 7 : 9;
  }

  function loadMapScript() {
    if (window.ymaps3) {
      return Promise.resolve(window.ymaps3.ready).then(function () {
        return window.ymaps3;
      });
    }
    if (mapLoadPromise) return mapLoadPromise;

    mapLoadPromise = new Promise(function (resolve, reject) {
      const script = document.createElement('script');

      script.src = 'https://api-maps.yandex.ru/v3/?apikey=' +
        encodeURIComponent(YMAPS_API_KEY) +
        '&lang=ru_RU';

      script.onload = async function () {
        try {
          await window.ymaps3.ready;
          resolve(window.ymaps3);
        } catch (error) {
          mapLoadPromise = null;
          reject(error);
        }
      };

      script.onerror = function () {
        mapLoadPromise = null;
        reject(new Error('Yandex Maps API load failed'));
      };

      document.head.appendChild(script);
    });

    return mapLoadPromise;
  }

  async function createMap() {
    const mapContainer = document.getElementById('zelseptik-map');
    if (!mapContainer || map) return map;
    if (mapCreatePromise) return mapCreatePromise;

    mapCreatePromise = (async function () {
      try {
        const mapsApi = await loadMapScript();
        const { YMap, YMapDefaultSchemeLayer } = mapsApi;

        map = new YMap(
          mapContainer,
          {
            location: {
              center: geoCache[pendingCity],
              zoom: getCityZoom(pendingCity)
            },
            behaviors: []
          },
          [new YMapDefaultSchemeLayer({})]
        );

        return map;
      } catch (error) {
        mapContainer.textContent = 'Карта временно недоступна. Адрес и район выезда уточнит специалист.';
        mapContainer.classList.add('geography-map__iframe--fallback');
        return null;
      } finally {
        mapCreatePromise = null;
      }
    })();

    return mapCreatePromise;
  }

  async function setMapLocation(city) {
    if (!geoCache[city]) return;

    pendingCity = city;

    if (!map) {
      await createMap();
    }

    if (!map) return;

    map.update({
      location: {
        center: geoCache[city],
        zoom: getCityZoom(city),
        duration: 400
      }
    });
  }

  function initGeoButtons() {
    const section = document.getElementById('geography');
    if (!section) return;

    section.classList.add('geography-section--enhanced');

    const buttons = Array.from(section.querySelectorAll('.js-geo-btn, .js-geo-tab'));
    const panels = Array.from(section.querySelectorAll('.js-geo-panel'));
    const tabList = section.querySelector('.js-geography-list');

    if (tabList) {
      tabList.setAttribute('role', 'tablist');
      tabList.setAttribute('aria-label', 'Населённые пункты');
    }

    buttons.forEach(function (button) {
      button.setAttribute('role', 'tab');
    });

    panels.forEach(function (panel) {
      panel.setAttribute('role', 'tabpanel');
    });

    function activate(button) {
      const city = button.getAttribute('data-city');
      if (!city) return;

      buttons.forEach(function (item) {
        const active = item === button;

        item.classList.toggle('geography-section__city-btn--active', active);
        item.setAttribute('aria-selected', active ? 'true' : 'false');
        item.setAttribute('tabindex', active ? '0' : '-1');
      });

      panels.forEach(function (panel) {
        const active = panel.getAttribute('data-city') === city;

        panel.classList.toggle('geography-details--active', active);
        panel.hidden = !active;
      });

      setMapLocation(city);
    }

    buttons.forEach(function (button) {
      button.addEventListener('click', function () {
        activate(button);
      });

      button.addEventListener('keydown', function (event) {
        if (!['ArrowUp', 'ArrowDown', 'ArrowLeft', 'ArrowRight', 'Home', 'End'].includes(event.key)) return;

        event.preventDefault();

        const currentIndex = buttons.indexOf(button);
        let nextIndex = currentIndex;

        if (event.key === 'ArrowDown') nextIndex = (currentIndex + 1) % buttons.length;
        if (event.key === 'ArrowUp') nextIndex = (currentIndex - 1 + buttons.length) % buttons.length;
        if (event.key === 'ArrowRight') nextIndex = (currentIndex + 1) % buttons.length;
        if (event.key === 'ArrowLeft') nextIndex = (currentIndex - 1 + buttons.length) % buttons.length;
        if (event.key === 'Home') nextIndex = 0;
        if (event.key === 'End') nextIndex = buttons.length - 1;

        activate(buttons[nextIndex]);
        buttons[nextIndex].focus();
      });
    });
  }

  function initLazyMap() {
    const mapContainer = document.getElementById('zelseptik-map');
    if (!mapContainer) return;

    const observer = new IntersectionObserver(function (entries) {
      if (!entries[0].isIntersecting) return;

      createMap();
      observer.disconnect();
    }, {
      rootMargin: '200px'
    });

    observer.observe(mapContainer);
  }
  document.addEventListener('DOMContentLoaded', function () {
    initGeoButtons();
    initLazyMap();
  });
})();
