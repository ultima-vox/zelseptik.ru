document.addEventListener('DOMContentLoaded', () => {
  initTabs();
  initAccordion();
  initFaq();
  initGeography();
  initCtaGiftSelectors();
  initSelectMenus();
  initExclusiveFilters();
  initRangeFilters();
  initCatalogFilterPagination();
  initModal();
  initDemoForms();
});

function initTabs() {
  document.querySelectorAll('[data-tabs]').forEach((tabs) => {
    const tabButtons = tabs.querySelectorAll('[data-tab]');
    const panels = tabs.querySelectorAll('[data-tab-panel]');

    tabButtons.forEach((button) => {
      button.addEventListener('click', () => {
        const target = button.dataset.tab;

        tabButtons.forEach((item) => {
          const isActive = item === button;
          item.classList.toggle('is-active', isActive);
          item.setAttribute('aria-selected', String(isActive));
        });

        panels.forEach((panel) => {
          panel.classList.toggle('is-active', panel.dataset.tabPanel === target);
        });
      });
    });
  });
}

function initAccordion() {
  document.querySelectorAll('[data-accordion]').forEach((accordion) => {
    accordion.querySelectorAll('.ds-accordion__trigger').forEach((trigger) => {
      trigger.addEventListener('click', () => {
        const panel = trigger.nextElementSibling;
        const willOpen = trigger.getAttribute('aria-expanded') !== 'true';

        trigger.setAttribute('aria-expanded', String(willOpen));

        if (panel) {
          panel.hidden = !willOpen;
        }
      });
    });
  });
}

function initFaq() {
  document.querySelectorAll('.faq-section__accordion').forEach((accordion) => {
    accordion.querySelectorAll('.faq-item__header').forEach((button) => {
      const item = button.closest('.faq-item');
      const icon = button.querySelector('.faq-item__icon');

      if (item) {
        const isOpen = item.classList.contains('faq-item--open');
        button.setAttribute('aria-expanded', String(isOpen));

        if (icon) {
          icon.textContent = isOpen ? '-' : '+';
        }
      }

      button.addEventListener('click', () => {
        const currentItem = button.closest('.faq-item');
        if (!currentItem) return;

        const willOpen = !currentItem.classList.contains('faq-item--open');
        currentItem.classList.toggle('faq-item--open', willOpen);
        button.setAttribute('aria-expanded', String(willOpen));

        if (icon) {
          icon.textContent = willOpen ? '-' : '+';
        }
      });
    });
  });
}

function initGeography() {
  document.querySelectorAll('[data-geography]').forEach((section) => {
    const buttons = section.querySelectorAll('[data-geography-target]');
    const panels = section.querySelectorAll('[data-geography-panel]');

    buttons.forEach((button) => {
      button.addEventListener('click', () => {
        const target = button.dataset.geographyTarget;
        if (!target) return;

        buttons.forEach((item) => {
          item.classList.toggle('geography-section__city-btn--active', item === button);
        });

        panels.forEach((panel) => {
          panel.classList.toggle('geography-details--active', panel.dataset.geographyPanel === target);
        });
      });
    });
  });
}

function initCtaGiftSelectors() {
  document.querySelectorAll('[data-cta-section]').forEach((section) => {
    const giftButtons = section.querySelectorAll('[data-cta-gift]');
    const selectedBonus = section.querySelector('[data-cta-selected-bonus]');

    giftButtons.forEach((button) => {
      button.addEventListener('click', () => {
        giftButtons.forEach((item) => {
          const isActive = item === button;
          item.classList.toggle('cta-section__gift-btn--active', isActive);
          item.setAttribute('aria-pressed', String(isActive));
        });

        if (selectedBonus) {
          selectedBonus.textContent = button.dataset.ctaGift || button.textContent.trim();
        }
      });
    });
  });
}

function initSelectMenus() {
  const menus = document.querySelectorAll('[data-select-menu]');

  menus.forEach((menu) => {
    const button = menu.querySelector('.select-menu__button');
    const value = menu.querySelector('[data-select-menu-value]');
    const options = menu.querySelectorAll('[data-select-menu-option]');

    if (!button || !value) return;

    button.addEventListener('click', () => {
      const willOpen = !menu.classList.contains('is-open');
      closeSelectMenus(menus);
      menu.classList.toggle('is-open', willOpen);
      button.setAttribute('aria-expanded', String(willOpen));
    });

    options.forEach((option) => {
      option.addEventListener('click', () => {
        value.textContent = option.textContent.trim();

        options.forEach((item) => {
          const isSelected = item === option;
          item.classList.toggle('is-selected', isSelected);
          item.setAttribute('aria-selected', String(isSelected));
        });

        menu.classList.remove('is-open');
        button.setAttribute('aria-expanded', 'false');
      });
    });
  });

  document.addEventListener('click', (event) => {
    if (event.target.closest('[data-select-menu]')) return;
    closeSelectMenus(menus);
  });

  document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
      closeSelectMenus(menus);
    }
  });
}

function closeSelectMenus(menus) {
  menus.forEach((menu) => {
    menu.classList.remove('is-open');
    menu.querySelector('.select-menu__button')?.setAttribute('aria-expanded', 'false');
  });
}

function initExclusiveFilters() {
  document.querySelectorAll('[data-exclusive-filter]').forEach((group) => {
    const options = Array.from(group.querySelectorAll('[data-exclusive-filter-option]'));
    const filterInputs = Array.from(group.querySelectorAll('[data-exclusive-filter-input]'));

    if (!options.length || !filterInputs.length) return;

    const syncFilter = (option) => {
      const activeParameter = option.dataset.exclusiveFilterOption || '';

      filterInputs.forEach((input) => {
        input.disabled = input.dataset.exclusiveFilterInput !== activeParameter;
      });
    };

    const searchParams = new URLSearchParams(window.location.search);
    const activeInput = filterInputs.find((input) => searchParams.has(input.name));
    const activeParameter = activeInput?.dataset.exclusiveFilterInput || '';
    const checkedOption = options.find((option) => (
      option.dataset.exclusiveFilterOption === activeParameter
    )) || options.find((option) => option.checked);

    if (checkedOption) {
      checkedOption.checked = true;
      syncFilter(checkedOption);
    }

    options.forEach((option) => {
      option.addEventListener('change', () => {
        if (option.checked) syncFilter(option);
      });
    });

    group.closest('form')?.addEventListener('submit', () => {
      options.forEach((option) => {
        option.disabled = true;
      });
    });
  });
}

function initRangeFilters() {
  document.querySelectorAll('[data-range-filter]').forEach((group) => {
    const options = Array.from(group.querySelectorAll('[data-range-filter-option]'));
    const fromInput = group.querySelector('[data-range-filter-input="from"]');
    const toInput = group.querySelector('[data-range-filter-input="to"]');

    if (!options.length || !fromInput || !toInput) return;

    const syncFilter = (option) => {
      const from = option.dataset.rangeFrom || '';
      const to = option.dataset.rangeTo || '';

      fromInput.value = from;
      fromInput.disabled = !from;
      toInput.value = to;
      toInput.disabled = !to;
    };

    const searchParams = new URLSearchParams(window.location.search);
    const currentFrom = searchParams.get(fromInput.name) || '';
    const currentTo = searchParams.get(toInput.name) || '';
    const checkedOption = options.find((option) => (
      option.dataset.rangeFrom === currentFrom && option.dataset.rangeTo === currentTo
    )) || options.find((option) => option.checked);

    if (checkedOption) {
      checkedOption.checked = true;
      syncFilter(checkedOption);
    }

    options.forEach((option) => {
      option.addEventListener('change', () => {
        if (option.checked) syncFilter(option);
      });
    });

    group.closest('form')?.addEventListener('submit', () => {
      options.forEach((option) => {
        option.disabled = true;
      });
    });
  });
}

function initCatalogFilterPagination() {
  const searchParams = new URLSearchParams(window.location.search);
  if (!searchParams.has('filter')) return;

  document.querySelectorAll('.catalog-pagination a').forEach((link) => {
    const url = new URL(link.href, window.location.origin);
    url.search = searchParams.toString();
    link.href = `${url.pathname}${url.search}${url.hash}`;
  });
}

function initModal() {
  const openButtons = document.querySelectorAll('[data-modal-open]');
  const closeButtons = document.querySelectorAll('[data-modal-close]');

  openButtons.forEach((button) => {
    button.addEventListener('click', () => {
      const modal = document.querySelector(`[data-modal="${button.dataset.modalOpen}"]`);
      if (!modal) return;

      modal.hidden = false;
      document.body.style.overflow = 'hidden';
      modal.querySelector('.ds-modal__close')?.focus();
    });
  });

  closeButtons.forEach((button) => {
    button.addEventListener('click', () => closeModal(button.closest('[data-modal]')));
  });

  document.addEventListener('keydown', (event) => {
    if (event.key !== 'Escape') return;
    document.querySelectorAll('[data-modal]:not([hidden])').forEach(closeModal);
  });
}

function closeModal(modal) {
  if (!modal) return;

  modal.hidden = true;
  document.body.style.overflow = '';
}

function initDemoForms() {
  document.querySelectorAll('.site-form').forEach((form) => {
    form.addEventListener('submit', (event) => {
      event.preventDefault();

      const button = form.querySelector('button[type="submit"]');
      if (!button) return;

      const originalText = button.textContent;
      button.textContent = 'Заявка принята';
      button.disabled = true;

      window.setTimeout(() => {
        button.textContent = originalText;
        button.disabled = false;
      }, 1800);
    });
  });
}
