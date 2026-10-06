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
    slides.forEach((slide) => {
      slide.querySelectorAll('.quiz-form input').forEach((input) => {
        originalDisabled.set(input, input.disabled);
        if (input.type !== 'hidden' && !input.getAttribute('aria-label')) {
          input.setAttribute('aria-label', input.placeholder || input.name);
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

    function show(focus = false) {
      const active = direct && consultation ? consultation : steps[index];
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
