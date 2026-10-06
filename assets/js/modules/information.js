/** Combine the CMS's legacy service/price columns into one accessible table.
 * Inconsistent source columns remain untouched, preserving their content.
 */
export function initInformationTables(scope = document) {
  scope.querySelectorAll('.information-detail .tbl-row, .information-prices .tbl-row').forEach((container) => {
    if (container.hasAttribute('data-information-table')) return;
    const source = container.querySelector('.tbl > table');
    const slider = container.querySelector('.swiper-box .swiper-wrapper');
    if (!source || !slider || !source.tHead || source.tBodies.length !== 1) return;
    if (container.querySelectorAll('.tbl > table').length !== 1 || container.querySelectorAll('.swiper-box .swiper-wrapper').length !== 1) return;

    const rows = Array.from(source.tBodies[0].rows);
    const columns = Array.from(slider.children).filter((node) => node.classList.contains('swiper-slide'));
    if (!rows.length || !columns.length || source.tHead.rows.length !== 1) return;
    if (source.tHead.rows[0].cells.length !== 1 || rows.some((row) => row.cells.length !== 1)) return;

    const values = columns.map((column) => ({
      header: column.querySelector('.sw-tbl-head'),
      cells: Array.from(column.querySelectorAll('.sw-tbl-body > .sw-tr')),
    }));
    if (values.some((column) => !column.header || column.cells.length !== rows.length)) return;
    if (Array.from(source.querySelectorAll('[rowspan], [colspan]')).some((cell) => cell.rowSpan > 1 || cell.colSpan > 1)) return;

    const table = source.cloneNode(true);
    // IDs in rich cells stay unique after replacing the original.
    const heading = table.tHead.rows[0];
    const originalHeading = heading.cells[0];
    const firstHeading = document.createElement('th');
    firstHeading.scope = 'col';
    firstHeading.append(...Array.from(originalHeading.childNodes));
    originalHeading.replaceWith(firstHeading);
    values.forEach((column) => {
      const cell = document.createElement('th');
      cell.scope = 'col';
      cell.textContent = column.header.textContent.trim();
      heading.append(cell);
    });
    Array.from(table.tBodies[0].rows).forEach((row, index) => {
      const originalCell = row.cells[0];
      const label = document.createElement('th');
      label.scope = 'row';
      label.append(...Array.from(originalCell.childNodes));
      originalCell.replaceWith(label);
      values.forEach((column) => {
        const cell = document.createElement('td');
        cell.append(...Array.from(column.cells[index].cloneNode(true).childNodes));
        row.append(cell);
      });
    });
    const title = container.closest('.tbl-wrap')?.querySelector('h2');
    container.setAttribute('role', 'region');
    container.setAttribute('aria-label', title?.textContent.trim() || 'Стоимость услуг');
    container.tabIndex = 0;
    container.setAttribute('data-information-table', '');
    container.replaceChildren(table);
  });
}

/** Scope legacy CMS documents; catalog CTA copy follows its existing section. */
export function initInformationPages(scope = document) {
  const path = scope.defaultView?.location.pathname || '';
  const view = {'/politika-konfidencialnosti/': 'legal', '/map/': 'map', '/404/': 'error'}[path];
  if (view) scope.documentElement.setAttribute('data-information-view', view);
  const contexts = [
    ['/kessony/', 'Подберём кессон для вашей скважины', 'Поможем выбрать кессон и уточнить состав работ по установке.', 'Рассчитать кессон', ['Подбор кессона', 'Предварительную смету установки', 'Уточнение условий участка', 'Ответ по срокам и гарантии']],
    ['/pogreba/', 'Подберём погреб для вашего участка', 'Поможем выбрать погреб и уточнить условия доставки и установки.', 'Рассчитать погреб', ['Подбор погреба', 'Предварительную смету установки', 'Уточнение условий участка', 'Ответ по срокам и гарантии']],
    ['/obsluzhivanie-po-gorodam/', 'Обсудим обслуживание вашего септика', 'Уточним модель станции, её состояние и состав необходимых работ.', 'Обсудить обслуживание', ['Уточнение модели станции', 'Согласование состава работ', 'Расчёт стоимости обслуживания', 'Ответ по срокам выезда']],
  ];
  const context = contexts.find(([prefix]) => path.startsWith(prefix));
  const cta = scope.querySelector('main > .cta-section');
  if (!context || !cta) return;
  const [, title, description, button, benefits] = context;
  const setText = (selector, text) => { const node = cta.querySelector(selector); if (node) node.textContent = text; };
  setText('.cta-section__title', title);
  setText('.cta-section__desc', description);
  setText('.cta-card__title', path.startsWith('/obsluzhivanie-po-gorodam/') ? 'Обсудить обслуживание' : 'Получить расчёт');
  setText('.cta-card__subtitle', 'Оставьте телефон — инженер свяжется и уточнит детали заявки.');
  setText('button[type="submit"]', button);
  cta.querySelectorAll('.cta-section__gift-name').forEach((node, index) => {
    if (benefits[index]) node.textContent = benefits[index];
  });
}

/** Enhance the existing CMS quiz without changing its fields or POST endpoint. */
export function initInformationQuiz(scope = document) {
  scope.querySelectorAll('.area-quiz-new .form-quiz').forEach((form) => {
    if (form.hasAttribute('data-information-quiz')) return;
    const wrapper = form.querySelector('.sw-quiz .swiper-wrapper');
    if (!wrapper) return;
    const slides = Array.from(wrapper.children).filter((node) => node.classList.contains('swiper-slide'));
    const questions = slides.filter((slide) => slide.querySelector('.quiz-chk'));
    const result = slides.find((slide) => slide.querySelector('.quiz-form') && !slide.hasAttribute('data-key'));
    const consultation = slides.find((slide) => slide.getAttribute('data-key') === '3');
    if (!questions.length || !result) return;
    const steps = [...questions, result];
    let index = 0;
    let direct = false;
    const originalDisabled = new Map();
    const comments = new Map();
    const submitButtons = Array.from(form.querySelectorAll('button[type="submit"]'));
    const submitButton = submitButtons[0];
    submitButtons.slice(1).forEach((button) => button.remove());
    slides.forEach((slide) => {
      slide.querySelectorAll('.quiz-form input').forEach((input) => {
        originalDisabled.set(input, input.disabled);
        if (input.type !== 'hidden' && !input.getAttribute('aria-label')) {
          input.setAttribute('aria-label', input.placeholder || input.name);
        }
        if (input.name === 'comment') {
          comments.set(slide, input);
          input.removeAttribute('name');
        }
      });
      slide.querySelectorAll('.quiz-sbmts .num').forEach((label) => {
        if (label.textContent.trim() === 'УСПЕХ!') label.textContent = 'Контактные данные';
      });
      slide.querySelectorAll('.quiz-sbmts .prev, .quiz-sbmts a.next').forEach((control) => {
        const button = document.createElement('button');
        button.type = 'button';
        button.className = control.className;
        button.textContent = control.classList.contains('prev') ? 'Назад' : 'Далее';
        control.replaceWith(button);
      });
      const heading = slide.querySelector('.h-2');
      if (heading) heading.tabIndex = -1;
    });
    const error = document.createElement('p');
    error.className = 'form-message form-message--error';
    error.setAttribute('role', 'status');
    error.hidden = true;
    form.append(error);
    const summary = document.createElement('input');
    summary.type = 'hidden';
    summary.name = 'comment';
    form.append(summary);
    form.addEventListener('submit', () => {
      const active = direct && consultation ? consultation : steps[index];
      const lines = direct ? ['Запрос консультации'] : questions.map((step) => {
        const title = step.querySelector('.h-2')?.textContent.trim() || '';
        const answers = Array.from(step.querySelectorAll('.quiz-chk input:checked')).map((input) => input.value);
        return `${title}: ${answers.join(', ')}`;
      });
      const feedback = active.querySelector('input[name="feddback"]:checked');
      if (feedback) lines.push(`Способ связи: ${feedback.value}`);
      const comment = comments.get(active)?.value.trim();
      if (comment) lines.push(`Комментарий: ${comment}`);
      summary.value = lines.join('\n');
    });

    function show(focus = false) {
      const active = direct && consultation ? consultation : steps[index];
      const contact = active.querySelector('.quiz-form');
      if (contact && submitButton) contact.append(submitButton);
      if (submitButton) submitButton.disabled = !contact;
      slides.forEach((slide) => {
        slide.hidden = slide !== active;
        slide.querySelectorAll('.quiz-form input').forEach((input) => {
          input.disabled = slide !== active || originalDisabled.get(input);
        });
      });
      form.querySelectorAll('.quiz-sbmts button.prev').forEach((button) => {
        button.disabled = !direct && index === 0;
      });
      error.hidden = true;
      const discount = `${1000 + slides.indexOf(active) * 500} ₽`;
      form.querySelectorAll('.change_price24').forEach((node) => { node.textContent = discount; });
      form.querySelectorAll('.change_price_hidden24').forEach((input) => { input.value = discount; });
      if (focus) active.querySelector('.h-2')?.focus();
    }
    form.addEventListener('click', (event) => {
      const button = event.target.closest('.quiz-sbmts button');
      if (!button || !form.contains(button)) return;
      if (button.classList.contains('prev')) {
        if (direct) direct = false;
        else index = Math.max(0, index - 1);
      } else {
        const step = steps[index];
        if (step.querySelector('.quiz-chk') && !step.querySelector('.quiz-chk input:checked')) {
          error.textContent = 'Выберите вариант ответа, чтобы продолжить.';
          error.hidden = false;
          return;
        }
        index = Math.min(index + 1, steps.length - 1);
      }
      show(true);
    });
    form.closest('.quiz_parent')?.querySelectorAll('.clicked_question').forEach((link) => {
      link.addEventListener('click', () => {
        direct = link.getAttribute('data-key') === '3';
        index = 0;
        show(true);
      });
    });
    form.addEventListener('keydown', (event) => {
      if (event.key === 'Enter' && steps[index].querySelector('.quiz-chk') && !direct) {
        event.preventDefault();
        steps[index].querySelector('button.next')?.click();
      }
    });
    form.setAttribute('data-information-quiz', '');
    show();
  });
}


/** Present existing service HTML consistently; no CMS text, prices or forms are generated. */
export function initInformationSections(scope = document) {
  scope.querySelectorAll('.information-detail:not(.information-detail--article)').forEach((root, rootIndex) => {
    const content = root.querySelector('.information-detail__body') || root;
    if (content.hasAttribute('data-service-content')) return;
    const sections = Array.from(content.children).filter((node) => node.matches('.area-text, .area-paragraph, .area-why'));
    if (!sections.length) return;
    content.classList.add('information-service-content');
    content.setAttribute('data-service-content', '');
    sections.forEach((section) => section.setAttribute('data-service-section', ''));

    // Keep heading hierarchy and actual rich nodes, including links and editor IDs.
    sections.forEach((section) => section.querySelectorAll('.txt').forEach((text) => {
      const headings = Array.from(text.children).filter((node) => node.tagName === 'H2');
      if (headings.length > 1 && !text.querySelector('form')) {
        let block = null;
        Array.from(text.childNodes).forEach((node) => {
          if (node.nodeType === 1 && node.tagName === 'H2') {
            block = scope.createElement('section');
            block.className = 'information-content-block';
            text.insertBefore(block, node);
          }
          if (block) block.append(node);
        });
      }
      text.querySelectorAll('p').forEach((paragraph) => {
        const first = paragraph.firstElementChild;
        if (first?.tagName === 'STRONG' && paragraph.textContent.trim().startsWith(first.textContent.trim()) && first.textContent.trim().length > 0) {
          paragraph.classList.add('information-topic-card');
        }
      });
    }));

    content.querySelectorAll('.punkt-bl > img').forEach((image) => {
      const match = (image.getAttribute('src') || '').match(/\/Icons\/numbers\/(\d{1,2})\.svg(?:[?#].*)?$/i);
      if (!match) return;
      const number = match[1].padStart(2, '0');
      const card = image.parentElement;
      card.classList.add('process-card');
      const watermark = scope.createElement('span');
      watermark.className = 'process-card__number-bg';
      watermark.setAttribute('aria-hidden', 'true');
      watermark.textContent = number;
      const badge = scope.createElement('span');
      badge.className = 'process-card__step';
      badge.textContent = number;
      image.replaceWith(badge);
      card.prepend(watermark);
    });

    content.querySelectorAll('img').forEach((image) => {
      if (!image.closest('[data-service-section]')) return;
      if (image.closest('.punkt-bl, .why-info') || /\.(?:svg)(?:[?#].*)?$/i.test(image.getAttribute('src') || '')) return;
      image.classList.add('information-service-photo');
      image.loading = 'lazy';
      image.decoding = 'async';
    });
    content.querySelectorAll('.tbl-row[data-information-table] table').forEach((table) => {
      const headers = Array.from(table.tHead?.rows[0]?.cells || []).map((cell) => cell.textContent.trim());
      if (!headers.length || Array.from(table.tBodies).some((body) => Array.from(body.rows).some((row) => row.cells.length !== headers.length))) return;
      table.classList.add('information-price-table');
      table.setAttribute('role', 'table');
      Array.from(table.tBodies).forEach((body) => Array.from(body.rows).forEach((row) => {
        row.setAttribute('role', 'row');
        Array.from(row.cells).forEach((cell, index) => {
          cell.setAttribute('data-label', headers[index]);
          cell.setAttribute('role', cell.tagName === 'TH' ? 'rowheader' : 'cell');
          if (/цен|стоим/i.test(headers[index])) cell.classList.add('information-price-value');
        });
      }));
    });
    // Surface the existing price section near the start, rather than duplicating prices.
    const priceSection = sections.find((section) => section.querySelector('.tbl-wrap .information-price-table'));
    if (priceSection) {
      priceSection.classList.add('information-service-section--prices');
      content.insertBefore(priceSection, sections[0]);
    }
    const headings = Array.from(content.querySelectorAll('[data-service-section] h2, [data-service-section] .h-2')).filter((heading) => !heading.closest('form, table, .punkt-bl') && heading.textContent.trim());
    if (headings.length > 1) {
      const nav = scope.createElement('nav');
      nav.className = 'information-service-nav';
      nav.setAttribute('aria-label', 'Разделы услуги');
      const label = scope.createElement('p');
      label.textContent = 'На странице';
      nav.append(label);
      const list = scope.createElement('ul');
      headings.forEach((heading, index) => {
        if (!heading.id) {
          let id = `service-section-${rootIndex + 1}-${index + 1}`;
          while (scope.getElementById(id)) id += '-content';
          heading.id = id;
        }
        const item = scope.createElement('li');
        const link = scope.createElement('a');
        link.setAttribute('href', '#' + heading.id);
        link.textContent = heading.textContent.trim();
        item.append(link);
        list.append(item);
      });
      nav.append(list);
      const firstSection = Array.from(content.children).find((node) => node.hasAttribute('data-service-section'));
      const layout = scope.createElement('div');
      layout.className = 'information-service-layout';
      const panels = scope.createElement('div');
      panels.className = 'information-service-panels';
      content.insertBefore(layout, firstSection);
      layout.append(nav, panels);
      Array.from(content.children).filter((node) => node.hasAttribute('data-service-section')).forEach((section) => panels.append(section));
    }
  });
}
