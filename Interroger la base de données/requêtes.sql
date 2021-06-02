/*Cas GESCOM les requêtes*/
/*Q1. Afficher dans l'ordre alphabétique et sur une seule colonne, les noms et prénoms des employés qui ont des enfants. Présenter d'abord ceux qui en ont le plus.*/
SELECT CONCAT(emp_firstname, emp_lastname) AS employé ,MAX(emp_children) AS nb_enfants FROM employees
GROUP BY employé
ORDER BY  nb_enfants DESC
LIMIT 5

/*Q2. Y-a-t-il des clients étrangers ? Afficher leur nom, prénom et pays de résidence./*/
SELECT cus_lastname, cus_firstname, cus_countries_id FROM customers
WHERE cus_countries_id !='fr'

/*Q3. Afficher par ordre alphabétique les villes de résidence des clients ainsi que le code (ou le nom) du pays.*/
SELECT cus_city,cus_zipcode, cus_countries_id FROM customers
ORDER BY cus_city ASC
LIMIT 5

/*Q4. Afficher le nom des clients dont les fiches ont été modifiées*/
SELECT cus_lastname, cus_update_date FROM customers
WHERE cus_update_date

/*Q5. La commerciale Coco Merce veut consulter la fiche d'un client, mais la seule chose dont elle se souvienne est qu'il habite une ville genre 'divos'. Pouvez-vous l'aider ?/*/
SELECT cus_lastname, cus_lastname, cus_city FROM customers
WHERE cus_city LIKE '%divos%'

/*Q6. Quel est le produit dont le prix de vente est le moins cher ? Afficher le prix, l'id et le nom du produit.*/
SELECT pro_id,pro_name, pro_price FROM products
WHERE pro_price
IN (SELECT MIN(pro_price) FROM products)

/*Q7. Lister les produits qui n'ont jamais été vendus*/
SELECT pro_id, pro_ref, pro_name
FROM products
WHERE pro_id NOT IN 
(SELECT DISTINCT(ode_pro_id) FROM orders_details)

/*Q8. Afficher les produits commandés par Madame Pikatchien.*/
SELECT pro_id, pro_ref, pro_color, pro_name, cus_id, cus_lastname, ord_id, ode_id FROM products 
JOIN orders_details ON orders_details.ode_pro_id=products.pro_id
JOIN orders ON orders_details.ode_ord_id=orders.ord_id
JOIN customers ON orders.ord_cus_id=customers.cus_id
WHERE cus_lastname ='Pikatchien'

/*Q9. Afficher le catalogue des produits par catégorie, le nom des produits et de la catégorie doivent être affichés.*/
SELECT cat_id, cat_name, pro_name FROM products
JOIN categories ON products.pro_cat_id=categories.cat_id
ORDER BY cat_name ASC

/*Q10. Afficher l'organigramme du magasin de Compiègne Afficher le nom et prénom des employés, classés par ordre alphabétique, ainsi que celui de leur supérieur hiérarchique (et éventuellement leurs postes respectifs, si vous y parvenez).*/
SELECT CONCAT(a.emp_lastname, a.emp_firstname) AS employé, CONCAT(b.emp_lastname, b.emp_firstname) AS superior
FROM employees AS a
RIGHT OUTER JOIN employees as b ON a.emp_superior_id = b.emp_id
WHERE a.emp_sho_id IN 
(SELECT shops.sho_id  FROM shops
WHERE shops.sho_city LIKE 'Compiegne')
ORDER BY employé ASC 

/*Fonctions d'agrégation*/

/*Q11. Quel produit a été vendu avec la remise la plus élevée ? Afficherle numéro et le nom du produit, le numéro de commande, le numéro de ligne de commande, et le montant de la remise.*/
SELECT pro_id , CONCAT(pro_name, pro_ref) AS produit, ode_id, ode_ord_id FROM products
JOIN orders_details ON products.pro_id=orders_details.ode_pro_id
ORDER BY ode_discount DESC
LIMIT 1

/*2eme meth*/
SELECT pro_id , CONCAT(pro_name,' ', pro_ref) AS produit, ode_id, ode_ord_id FROM products
JOIN orders_details ON products.pro_id=orders_details.ode_pro_id
WHERE ode_discount IN 
(SELECT MAX(ode_discount) FROM orders_details)
/*Q12. Combien y-a-t-il de clients canadiens ? Afficher dans une colonne intitulée 'Nb clients Canada'*/
SELECT COUNT(cus_countries_id) AS "Nb clients canada" FROM customers
where cus_countries_id LIKE '%ca%'
/*-----------*/
SELECT COUNT(cus_countries_id) AS "Nb clients canada" FROM customers
where cus_countries_id='ca'

/*Q13. Afficher le détail des commandes de 2020.*/
SELECT ode_id, ode_unit_price, ode_discount, ode_quantity,ode_ord_id, ord_order_date FROM orders
INNER JOIN orders_details ON orders_details.ode_ord_id=orders.ord_id
WHERE YEAR(ord_order_date)=2020
ORDER BY ode_ord_id ASC
LIMIT 5

/*Q14. Afficher les coordonnées des fournisseurs pour lesquels des commandes ont été passées.*/
SELECT * FROM suppliers
JOIN products ON suppliers.sup_id=products.pro_sup_id
JOIN orders_details ON orders_details.ode_pro_id=products.pro_id
WHERE ode_pro_id!=0
GROUP BY sup_name

/*Q15. Quel est le chiffre d'affaires de 2020 ?*/
SELECT ROUND(SUM((ode_unit_price * ode_quantity)-(((ode_unit_price * ode_quantity)/ 100) * ode_discount)), 2) AS "Chiffre d'affaire"
FROM orders_details
JOIN orders ON orders_details.ode_ord_id = orders.ord_id
WHERE YEAR(ord_order_date) = 2020;

/*Q16. Lister le total de chaque commande par total décroissant. Afficher le numéro de commande, la date, le total et le nom du client).*/
SELECT ord_id, cus_lastname, ord_order_date, ode_quantity,(ode_quantity * ode_unit_price) AS Total
FROM orders_details
JOIN orders ON orders_details.ode_ord_id = orders.ord_id
JOIN customers ON orders.ord_cus_id = customers.cus_id
ORDER BY Total DESC
LIMIT 10;

/*Q17. Quel est le montant du panier moyen ?*/
SELECT AVG(total) AS 'Moyenne Panier' 
FROM (SELECT SUM(ode_quantity * (ode_unit_price - ( (ode_unit_price * ode_discount) / 100) )) AS total
FROM orders_details
GROUP BY ode_ord_id) AS MT;

/*Q18. La version 2020 du produit barb004 s'appelle désormais Camper et, bonne nouvelle, son prix subit une baisse de 10%. Mettre à jour la fiche de ce produit.*/
UPDATE products
SET pro_ref='camper',
pro_price = pro_price - (100*0.10)
WHERE pro_id= 12

/*Q19. L'inflation en France l'année dernière a été de 1,1%. Appliquer cette augmentation à la gamme de parasols.*/
UPDATE products
JOIN categories ON products.pro_cat_id = categories.cat_id
SET pro_price = pro_price * 1.011
WHERE cat_name LIKE "parasols"

/*Q20. Supprimer les produits non vendus de la catégorie "Tondeuses électriques". Vous devez utiliser une sous-requête sans indiquer de valeurs de clés.*/
DELETE FROM categories
WHERE cat_id  IN
(SELECT DISTINCT(pro_cat_id) FROM products WHERE cat_name='tondeuse electrique')
