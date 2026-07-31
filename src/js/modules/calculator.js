function formatRubles(value) {
  return `${new Intl.NumberFormat('ru-RU').format(value)} ₽`;
}

function setText(card, selector, value) {
  const element = card.querySelector(selector);

  if (element) element.textContent = value;
}

export function initCalculator() {
  document.querySelectorAll('[data-calculator-card]').forEach((card) => {
    const options = Array.from(card.querySelectorAll('[data-calculator-option]'));
    const installPrice = Number(card.dataset.installPrice || 0);

    if (!options.length) return;

    const update = (option) => {
      const equipmentPrice = Number(option.dataset.equipmentPrice || 0);

      options.forEach((item) => {
        const active = item === option;
        item.classList.toggle('calculator-card__option--active', active);
        item.setAttribute('aria-pressed', active ? 'true' : 'false');
      });

      setText(card, '[data-calculator-model]', option.dataset.modelName || 'Уточняется');
      setText(card, '[data-calculator-performance]', option.dataset.performance || 'Уточняется');
      setText(card, '[data-calculator-equipment]', formatRubles(equipmentPrice));
      setText(card, '[data-calculator-install]', formatRubles(installPrice));
      setText(card, '[data-calculator-total]', formatRubles(equipmentPrice + installPrice));
      setText(card, '[data-calculator-tip]', option.dataset.tip || 'Инженер проверит расчёт после осмотра участка.');
    };

    options.forEach((option) => {
      option.addEventListener('click', () => update(option));
    });

    update(options.find((option) => option.getAttribute('aria-pressed') === 'true') || options[0]);
  });
}
