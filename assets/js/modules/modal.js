export function initModals() {
  document.addEventListener('click', (event) => {
    const open = event.target.closest('[data-modal-open]');
    const close = event.target.closest('[data-modal-close]');
    if (open) document.querySelector(open.dataset.modalOpen)?.classList.add('is-open');
    if (close) close.closest('.modal')?.classList.remove('is-open');
  });
}
