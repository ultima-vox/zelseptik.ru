/** Combine the CMS's legacy service/price columns into one accessible table.
 * Inconsistent source columns remain untouched, preserving their content.
 */
export function initInformationTables(scope = document) {
  scope.querySelectorAll('.information-detail .tbl-row').forEach((container) => {
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
