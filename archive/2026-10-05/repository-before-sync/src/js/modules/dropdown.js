export function initDropdowns() {
  document.querySelectorAll('.js-dropdown').forEach((root) => {
    root.addEventListener('click', (event) => {
      const trigger = event.target.closest('.js-dropdown-trigger');
      if (!trigger) return;
      root.classList.toggle('is-open');
    });
  });
}
