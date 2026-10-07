import { initAccordions } from './modules/accordion.js';
import { initTabs } from './modules/tabs.js';
import { initModals } from './modules/modal.js';
import { initDropdowns } from './modules/dropdown.js?v=20261007-1';
import { initForms } from './modules/form.js';
import { initCatalog } from './modules/catalog.js';
import { initCalculator } from './modules/calculator.js';

import { initInformationTables, initInformationQuiz, initInformationPages, initInformationSections } from './modules/information.js?v=20261007-4';

initInformationPages();
initInformationTables();
initInformationSections();
initInformationQuiz();
initAccordions();
initTabs();
initModals();
initDropdowns();
initForms();
initCatalog();
initCalculator();
