export function initDropdowns() {
  initStyledSelects();
  document.querySelectorAll('.js-dropdown').forEach((root) => {
    root.addEventListener('click', (event) => {
      const trigger = event.target.closest('.js-dropdown-trigger');
      if (!trigger) return;
      root.classList.toggle('is-open');
    });
  });
}

function initStyledSelects() {
  let sequence = 0;
  let current = null;
  const closeCurrent = () => { if (current) current(); };
  document.addEventListener('pointerdown', event => {
    if (!event.target.closest('.ds-select')) closeCurrent();
  });
  document.querySelectorAll('select:not([multiple])').forEach(select => {
    if (select.size > 1 || select.closest('.ds-select')) return;
    const id = `ds-select-${++sequence}`;
    const wrapper = document.createElement('div');
    wrapper.className = 'ds-select';
    const trigger = document.createElement('button');
    trigger.type = 'button';
    trigger.className = 'ds-select__trigger';
    trigger.setAttribute('role', 'combobox');
    trigger.setAttribute('aria-haspopup', 'listbox');
    trigger.setAttribute('aria-expanded', 'false');
    trigger.setAttribute('aria-controls', id);
    const labels = Array.from(select.labels || []);
    if (labels.length) {
      labels.forEach((label, i) => { if (!label.id) label.id = `${id}-label-${i}`; });
      trigger.setAttribute('aria-labelledby', labels.map(label => label.id).join(' '));
    } else trigger.setAttribute('aria-label', select.getAttribute('aria-label') || select.name || 'Выберите вариант');
    const list = document.createElement('div');
    list.id = id;
    list.className = 'ds-select__list';
    list.setAttribute('role', 'listbox');
    list.setAttribute('aria-label', trigger.getAttribute('aria-label') || labels.map(label => label.textContent.trim()).join(' '));
    list.hidden = true;
    select.before(wrapper);
    wrapper.append(select, trigger, list);
    select.classList.add('ds-select__native');
    select.tabIndex = -1;
    select.setAttribute('aria-hidden', 'true');
    let items = [];
    let active = -1;
    let search = '';
    let searchTimer;
    const close = () => {
      list.hidden = true;
      trigger.setAttribute('aria-expanded', 'false');
      trigger.removeAttribute('aria-activedescendant');
      wrapper.classList.remove('ds-select--open');
      if (current === close) current = null;
    };
    const sync = () => {
      trigger.textContent = select.selectedOptions[0]?.textContent || 'Выберите вариант';
      trigger.disabled = select.matches(':disabled');
      if (trigger.disabled) close();
    };
    const highlight = index => {
      active = index;
      items.forEach((item, i) => item.node.classList.toggle('is-active', i === active));
      if (items[active]) {
        trigger.setAttribute('aria-activedescendant', items[active].node.id);
        items[active].node.scrollIntoView({ block: 'nearest' });
      }
    };
    const choose = index => {
      if (!items[index]) return;
      select.selectedIndex = items[index].index;
      sync(); close(); trigger.focus({ preventScroll: true });
      select.dispatchEvent(new Event('input', { bubbles: true }));
      select.dispatchEvent(new Event('change', { bubbles: true }));
    };
    const open = () => {
      if (select.matches(':disabled')) return;
      closeCurrent(); sync(); list.replaceChildren(); items = [];
      Array.from(select.options).forEach((option, index) => {
        const group = option.closest('optgroup');
        if (option.hidden || option.disabled || group?.disabled || group?.hidden) return;
        const node = document.createElement('div');
        node.className = 'ds-select__option';
        node.id = `${id}-option-${index}`;
        node.setAttribute('role', 'option');
        node.setAttribute('aria-selected', String(option.selected));
        node.textContent = option.textContent;
        const position = items.length;
        node.addEventListener('click', () => choose(position));
        items.push({ node, index }); list.append(node);
      });
      if (!items.length) return;
      list.hidden = false;
      trigger.setAttribute('aria-expanded', 'true');
      wrapper.classList.add('ds-select--open');
      wrapper.classList.remove('ds-select--up');
      const bounds = list.getBoundingClientRect();
      if (bounds.bottom > window.innerHeight && trigger.getBoundingClientRect().top > bounds.height) wrapper.classList.add('ds-select--up');
      current = close;
      highlight(Math.max(0, items.findIndex(item => item.index === select.selectedIndex)));
    };
    list.addEventListener('pointerdown', event => event.preventDefault());
    trigger.addEventListener('click', () => list.hidden ? open() : close());
    trigger.addEventListener('keydown', event => {
      if (event.key === 'Escape' && !list.hidden) { event.preventDefault(); event.stopPropagation(); close(); return; }
      if (event.key === 'Tab') { close(); return; }
      if (['ArrowDown', 'ArrowUp', 'Home', 'End'].includes(event.key)) {
        event.preventDefault();
        if (list.hidden) { open(); return; }
        const next = event.key === 'Home' ? 0 : event.key === 'End' ? items.length - 1 : Math.min(items.length - 1, Math.max(0, active + (event.key === 'ArrowDown' ? 1 : -1)));
        highlight(next); return;
      }
      if (event.key === 'Enter' || event.key === ' ') {
        event.preventDefault(); list.hidden ? open() : choose(active); return;
      }
      if (event.key.length === 1 && !event.ctrlKey && !event.metaKey && !event.altKey) {
        event.preventDefault(); if (list.hidden) open();
        search += event.key.toLocaleLowerCase(); clearTimeout(searchTimer);
        searchTimer = setTimeout(() => { search = ''; }, 650);
        const index = items.findIndex(item => item.node.textContent.trim().toLocaleLowerCase().startsWith(search));
        if (index !== -1) highlight(index);
      }
    });
    trigger.addEventListener('blur', event => { if (!wrapper.contains(event.relatedTarget)) close(); });
    select.addEventListener('change', sync);
    select.addEventListener('focus', () => trigger.focus({ preventScroll: true }));
    select.addEventListener('invalid', () => trigger.setAttribute('aria-invalid', 'true'));
    select.addEventListener('input', () => trigger.removeAttribute('aria-invalid'));
    labels.forEach(label => label.addEventListener('click', event => { event.preventDefault(); trigger.focus(); }));
    select.form?.addEventListener('reset', () => { close(); setTimeout(sync, 0); });
    new MutationObserver(() => { sync(); if (!list.hidden) close(); }).observe(select, { subtree: true, childList: true, attributes: true });
    const modal = select.closest('.modal');
    if (modal) new MutationObserver(() => { close(); sync(); }).observe(modal, { attributes: true, attributeFilter: ['class'] });
    sync();
  });
}
