/*Création de dexu utilisateurs*/

CREATE USER 'market1'@'127.0.0.1' IDENTIFIED BY 'market1';
CREATE USER 'market2'@'127.0.0.1' IDENTIFIED BY 'market2';



/* /* creation du role */
CREATE ROLE 'gescommarket'@'127.0.0.1';

/* ajout des privileges au role*/
GRANT select, insert, delete, update 
ON gescom_afpa.categories 
TO 'gescommarket'@'127.0.0.1';

GRANT select, insert, delete, update 
ON gescom_afpa.products
TO 'gescommarket'@'127.0.0.1';

/* creation du role */
CREATE ROLE 'gescommarketview'@'127.0.0.1';


/* ajout des privileges au role */
GRANT select
ON gescom_afpa.customers 
TO 'gescommarketview'@'127.0.0.1';

GRANT select
ON gescom_afpa.orders 
TO 'gescommarketview'@'127.0.0.1';

GRANT select
ON  gescom_afpa.orders_details
TO 'gescommarketview'@'127.0.0.1';

/*ajout des roles*/

GRANT 'gescommarket'@'127.0.0.1'
TO 'com1'@'127.0.0.1', 'com2'@'127.0.0.1';  

GRANT 'gescommarketview'@'127.0.0.1'
TO 'com1'@'127.0.0.1', 'com2'@'127.0.0.1';  

