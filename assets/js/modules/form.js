export function initForms() {
  document.querySelectorAll('.js-form').forEach((form) => {
    form.addEventListener('submit', () => {
      form.classList.add('is-submitting');
    });
  });
}
