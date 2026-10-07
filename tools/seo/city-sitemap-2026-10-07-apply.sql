-- DEV ONLY. Changes already applied via existing HostCMS attributes form.
-- Verify live InnoDB/schema and back up selected rows. Default: ROLLBACK.
START TRANSACTION;
SELECT id, informationsystem_id, path, closed FROM informationsystem_items WHERE informationsystem_id = 4 AND id BETWEEN 174 AND 186 FOR UPDATE;
UPDATE informationsystem_items SET closed = 1 WHERE id = 174 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-zelenograde';
UPDATE informationsystem_items SET closed = 1 WHERE id = 175 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-istre';
UPDATE informationsystem_items SET closed = 1 WHERE id = 176 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-ximkax';
UPDATE informationsystem_items SET closed = 1 WHERE id = 177 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-krasnogorske';
UPDATE informationsystem_items SET closed = 1 WHERE id = 178 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-solnechnogorske';
UPDATE informationsystem_items SET closed = 1 WHERE id = 179 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-klinu';
UPDATE informationsystem_items SET closed = 1 WHERE id = 180 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-zvenigorode';
UPDATE informationsystem_items SET closed = 1 WHERE id = 181 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-lobne';
UPDATE informationsystem_items SET closed = 1 WHERE id = 182 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-dmitrove';
UPDATE informationsystem_items SET closed = 1 WHERE id = 183 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-volokolamske';
UPDATE informationsystem_items SET closed = 1 WHERE id = 184 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-korolyove';
UPDATE informationsystem_items SET closed = 1 WHERE id = 185 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'servisnoe-obsluzhivanie-septikov-v-dolgoprudnom';
UPDATE informationsystem_items SET closed = 1 WHERE id = 186 AND informationsystem_id = 4 AND deleted = 0 AND closed = 0 AND BINARY path = BINARY 'obsluzhivanie-septikov-v-moskve';
-- Replace with COMMIT only after checking selected rows.
ROLLBACK;
