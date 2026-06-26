export function initAccordions() {
  document.querySelectorAll('.js-accordion').forEach((root) => {
    root.addEventListener('click', (event) => {
      const trigger = event.target.closest('.js-accordion-trigger');
      if (!trigger) return;
      const item = trigger.closest('.js-accordion-item');
      item?.classList.toggle('is-open');
    });
  });
}
