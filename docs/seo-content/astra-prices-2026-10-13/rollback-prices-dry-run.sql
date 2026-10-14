-- DEV ONLY. Prepared from public snapshot of 2026-10-13; NOT executed.
-- Require fresh DB backup/export, InnoDB table, matching schema and vendor price recheck.
-- Review discounts, special prices and actual configuration in native HostCMS first.
-- Expected changed_rows = 1 for each of 10 items. Any mismatch: ROLLBACK.
-- Final ROLLBACK is intentional. Never apply this file blindly.
SET NAMES utf8mb4;
START TRANSACTION;
SELECT id, shop_id, shop_group_id, modification_id, name, path, price, deleted FROM shop_items WHERE id IN (174, 176, 177, 178, 183, 179, 180, 184, 181, 182) ORDER BY id FOR UPDATE;
-- Астра 3: 140500 -> 120000 RUB
UPDATE shop_items SET price = 120000 WHERE id = 174 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d33' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b02033' USING utf8mb4) AND price = 140500;
SELECT 174 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 5: 172300 -> 145000 RUB
UPDATE shop_items SET price = 145000 WHERE id = 176 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d35' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b02035' USING utf8mb4) AND price = 172300;
SELECT 176 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 5 Миди: 174500 -> 148000 RUB
UPDATE shop_items SET price = 148000 WHERE id = 177 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d352d6d696469' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b0203520d09cd0b8d0b4d0b8' USING utf8mb4) AND price = 174500;
SELECT 177 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 5 Лонг: 206900 -> 167000 RUB
UPDATE shop_items SET price = 167000 WHERE id = 178 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d352d6c6f6e67' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b0203520d09bd0bed0bdd0b3' USING utf8mb4) AND price = 206900;
SELECT 178 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 8: 203000 -> 176000 RUB
UPDATE shop_items SET price = 176000 WHERE id = 183 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d38' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b02038' USING utf8mb4) AND price = 203000;
SELECT 183 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 8 Миди: 206300 -> 179000 RUB
UPDATE shop_items SET price = 179000 WHERE id = 179 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d382d6d696469' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b0203820d09cd0b8d0b4d0b8' USING utf8mb4) AND price = 206300;
SELECT 179 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 8 Long: 245900 -> 204000 RUB
UPDATE shop_items SET price = 204000 WHERE id = 180 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d382d6c6f6e67' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b02038204c6f6e67' USING utf8mb4) AND price = 245900;
SELECT 180 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 10: 276500 -> 231000 RUB
UPDATE shop_items SET price = 231000 WHERE id = 184 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d3130' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b0203130' USING utf8mb4) AND price = 276500;
SELECT 184 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 10 Миди: 279700 -> 234000 RUB
UPDATE shop_items SET price = 234000 WHERE id = 181 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d31302d6d696469' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b020313020d09cd0b8d0b4d0b8' USING utf8mb4) AND price = 279700;
SELECT 181 AS item_id, ROW_COUNT() AS changed_rows;
-- Астра 10 Лонг: 322200 -> 260000 RUB
UPDATE shop_items SET price = 260000 WHERE id = 182 AND shop_id = 1 AND shop_group_id = 13 AND modification_id = 0 AND deleted = 0 AND BINARY path = BINARY CONVERT(X'61737472612d31302d6c6f6e67' USING utf8mb4) AND BINARY name = BINARY CONVERT(X'd090d181d182d180d0b020313020d09bd0bed0bdd0b3' USING utf8mb4) AND price = 322200;
SELECT 182 AS item_id, ROW_COUNT() AS changed_rows;
SELECT id, name, price FROM shop_items WHERE id IN (174, 176, 177, 178, 183, 179, 180, 184, 181, 182) ORDER BY id;
-- Dry run: all writes are reverted. Decide COMMIT only after all checks.
ROLLBACK;
