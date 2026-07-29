function initExclusiveFilters() {
  document.querySelectorAll('[data-exclusive-filter]').forEach((group) => {
    const options = Array.from(group.querySelectorAll('[data-exclusive-filter-option]'));
    const inputs = Array.from(group.querySelectorAll('[data-exclusive-filter-input]'));

    if (!options.length || !inputs.length) return;

    const sync = (option) => {
      const activeName = option.dataset.exclusiveFilterOption || '';

      inputs.forEach((input) => {
        input.disabled = input.dataset.exclusiveFilterInput !== activeName;
      });
    };

    const search = new URLSearchParams(window.location.search);
    const activeInput = inputs.find((input) => search.has(input.name));
    const activeName = activeInput?.dataset.exclusiveFilterInput || '';
    const selected =
      options.find((option) => option.dataset.exclusiveFilterOption === activeName) ||
      options.find((option) => option.checked);

    if (selected) {
      selected.checked = true;
      sync(selected);
    }

    options.forEach((option) => {
      option.addEventListener('change', () => {
        if (option.checked) sync(option);
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

    const sync = (option) => {
      const from = option.dataset.rangeFrom || '';
      const to = option.dataset.rangeTo || '';

      fromInput.value = from;
      fromInput.disabled = !from;
      toInput.value = to;
      toInput.disabled = !to;
    };

    const search = new URLSearchParams(window.location.search);
    const currentFrom = search.get(fromInput.name) || '';
    const currentTo = search.get(toInput.name) || '';
    const selected =
      options.find(
        (option) =>
          option.dataset.rangeFrom === currentFrom && option.dataset.rangeTo === currentTo,
      ) || options.find((option) => option.checked);

    if (selected) {
      selected.checked = true;
      sync(selected);
    }

    options.forEach((option) => {
      option.addEventListener('change', () => {
        if (option.checked) sync(option);
      });
    });

    group.closest('form')?.addEventListener('submit', () => {
      options.forEach((option) => {
        option.disabled = true;
      });
    });
  });
}

function preserveFilterPagination() {
  const search = new URLSearchParams(window.location.search);

  if (!search.has('filter')) return;

  document.querySelectorAll('.catalog-pagination a').forEach((link) => {
    const url = new window.URL(link.href, window.location.origin);
    url.search = search.toString();
    link.href = `${url.pathname}${url.search}${url.hash}`;
  });
}

export function initCatalog() {
  initExclusiveFilters();
  initRangeFilters();
  preserveFilterPagination();
}
