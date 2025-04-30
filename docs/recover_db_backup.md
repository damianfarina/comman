# DB Restore

1. Remove the records from the tables needed
    ```
    DELETE FROM formula_elements;
    DELETE FROM formula_items;
    DELETE FROM formulas;
    DELETE FROM making_order_formula_items;
    DELETE FROM making_order_formulas;
    DELETE FROM making_order_items;
    DELETE FROM making_orders;
    DELETE FROM products;
    ```
1. Copy the db dump file to the server

    `scp commanapp_db.backup user@commanapp.dev:`

1. SSH into the server and copy the dump file to the commanapp_db container

    `docker cp commanapp_db.backup commanapp-db:/tmp`

1. Log into the docker container

    `docker exec -it commanapp-db bash`

1. Restore the tables needed

    `pg_restore --data-only --table=formula_elements --table=formula_items --table=formulas --table=making_order_formula_items --table=making_order_formulas --table=making_order_items --table=making_orders --table=products -U comman -d comman_production /tmp/commanapp_db.backup`

1. Update sequences to point to the next available id

    ```
    SELECT setval(pg_get_serial_sequence('"formula_elements"', 'id'), MAX(id)) FROM formula_elements;
    SELECT setval(pg_get_serial_sequence('"formula_items"', 'id'), MAX(id)) FROM formula_items;
    SELECT setval(pg_get_serial_sequence('"formulas"', 'id'), MAX(id)) FROM formulas;
    SELECT setval(pg_get_serial_sequence('"making_order_formula_items"', 'id'), MAX(id)) FROM making_order_formula_items;
    SELECT setval(pg_get_serial_sequence('"making_order_formulas"', 'id'), MAX(id)) FROM making_order_formulas;
    SELECT setval(pg_get_serial_sequence('"making_order_items"', 'id'), MAX(id)) FROM making_order_items;
    SELECT setval(pg_get_serial_sequence('"making_orders"', 'id'), MAX(id)) FROM making_orders;
    SELECT setval(pg_get_serial_sequence('"products"', 'id'), MAX(id)) FROM products;
    ```
