export function initTabs() {
  document.querySelectorAll('.js-tabs').forEach((root) => {
    root.addEventListener('click', (event) => {
      const tab = event.target.closest('[data-tab-target]');
      if (!tab) return;
      const target = root.querySelector(tab.dataset.tabTarget);
      root.querySelectorAll('[data-tab-target]').forEach((el) => el.classList.remove('is-active'));
      root.querySelectorAll('[data-tab-panel]').forEach((el) => el.classList.remove('is-active'));
      tab.classList.add('is-active');
      target?.classList.add('is-active');
    });
  });
}
