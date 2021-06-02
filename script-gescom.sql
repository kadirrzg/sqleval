DROP DATABASE IF EXISTS gescom;
CREATE DATABASE gescom;
USE gescom;


CREATE TABLE posts(
   pos_id INT,
   pos_libelle VARCHAR(50),
   PRIMARY KEY(pos_id)
);

CREATE TABLE departements(
   dep_id INT,
   dep_name VARCHAR(50),
   PRIMARY KEY(dep_id)
);

CREATE TABLE shops(
   sho_id INT,
   sho_name VARCHAR(26),
   sho_adrdress VARCHAR(100),
   sho_zipcode VARCHAR(5),
   sho_city VARCHAR(26),
   PRIMARY KEY(sho_id)
);

CREATE TABLE countries(
   cou_id VARCHAR(2),
   cou_name VARCHAR(45),
   PRIMARY KEY(cou_id)
);

CREATE TABLE orders(
   ord_id INT,
   ord_order_date DATE,
   ord_payment_date DATE NOT NULL,
   ord_ship_date DATE,
   ord_reception_date DATE,
   ord_status VARCHAR(25),
   ord_cus_id INT NOT NULL,
   PRIMARY KEY(ord_id),
   UNIQUE(ord_cus_id)
);

CREATE TABLE orders_details(
   ode_id INT,
   ode_unit_price DECIMAL(7,2) NOT NULL,
   ode_discount DECIMAL(4,2) NOT NULL,
   ode_quantity INT NOT NULL,
   ode_ord_id INT NOT NULL,
   ode_pro_id INT NOT NULL,
   PRIMARY KEY(ode_id),
   UNIQUE(ode_unit_price),
   UNIQUE(ode_discount),
   UNIQUE(ode_quantity),
   UNIQUE(ode_ord_id),
   UNIQUE(ode_pro_id)
);

CREATE TABLE suppliers(
   sup_id INT,
   sup_name VARCHAR(50),
   sup_city VARCHAR(50),
   sup_countries_id VARCHAR(2),
   sup_address VARCHAR(150),
   sup_zipcode VARCHAR(5),
   sup_contact VARCHAR(100),
   sup_phone VARCHAR(100),
   sup_mail VARCHAR(75),
   cou_id VARCHAR(2) NOT NULL,
   PRIMARY KEY(sup_id),
   FOREIGN KEY(cou_id) REFERENCES countries(cou_id)
);

CREATE TABLE products(
   pro_id INT,
   pro_cat_id INT NOT NULL,
   pro_price DECIMAL(7,2) NOT NULL,
   pro_ref VARCHAR(8),
   pro_ean VARCHAR(13),
   pro_stock INT NOT NULL,
   pro_stock_alert INT NOT NULL,
   pro_color VARCHAR(30),
   pro_name VARCHAR(50),
   peo_desc VARCHAR(255),
   pro_publish INT NOT NULL,
   pro_suo_id INT NOT NULL,
   pro_add_date DATETIME,
   pro_update_date DATETIME,
   pro_picture VARCHAR(50),
   sup_id INT NOT NULL,
   PRIMARY KEY(pro_id),
   UNIQUE(pro_cat_id),
   UNIQUE(pro_price),
   UNIQUE(pro_stock),
   UNIQUE(pro_stock_alert),
   UNIQUE(pro_publish),
   UNIQUE(pro_suo_id),
   FOREIGN KEY(sup_id) REFERENCES suppliers(sup_id)
);

CREATE TABLE categories(
   cat_id INT,
   cat_name VARCHAR(50),
   cat_parent_id INT NOT NULL,
   PRIMARY KEY(cat_id),
   UNIQUE(cat_parent_id)
);

CREATE TABLE employees(
   emp_id VARCHAR(50),
   emp_superior_id VARCHAR(50),
   emp_pos_id VARCHAR(50) NOT NULL,
   emp_lastname VARCHAR(50),
   emp_firstname VARCHAR(50),
   emp_address VARCHAR(150),
   emp_zipcode VARCHAR(5),
   emp_city VARCHAR(50),
   emp_mail VARCHAR(255),
   emp_phone VARCHAR(10),
   emp_salary DECIMAL(8,2),
   emp_enter_date DATE,
   emp_gender VARCHAR(1),
   emp_children INT NOT NULL,
   emp_sho_id INT NOT NULL,
   emp_dep_id INT NOT NULL,
   sho_id INT NOT NULL,
   dep_id INT NOT NULL,
   pos_id INT NOT NULL,
   PRIMARY KEY(emp_id),
   UNIQUE(emp_pos_id),
   UNIQUE(emp_children),
   UNIQUE(emp_sho_id),
   UNIQUE(emp_dep_id),
   FOREIGN KEY(sho_id) REFERENCES shops(sho_id),
   FOREIGN KEY(dep_id) REFERENCES departements(dep_id),
   FOREIGN KEY(pos_id) REFERENCES posts(pos_id)
);

CREATE TABLE customers(
   cus_id INT,
   cus_lastname VARCHAR(50),
   cus_firstname VARCHAR(50),
   cus_adrdress VARCHAR(150),
   cus_zipcode VARCHAR(5),
   cus_city VARCHAR(50),
   cus_countris_id VARCHAR(2),
   cus_mail VARCHAR(255),
   cus_phone VARCHAR(10),
   cus_password VARCHAR(60),
   cus_add_date DATETIME,
   cus_update_date DATETIME,
   cou_id VARCHAR(2) NOT NULL,
   PRIMARY KEY(cus_id),
   FOREIGN KEY(cou_id) REFERENCES countries(cou_id)
);

CREATE TABLE appartenir(
   pro_id INT,
   cat_id INT,
   PRIMARY KEY(pro_id, cat_id),
   FOREIGN KEY(pro_id) REFERENCES products(pro_id),
   FOREIGN KEY(cat_id) REFERENCES categories(cat_id)
);

CREATE TABLE concerner(
   ode_id INT,
   pro_id INT,
   PRIMARY KEY(ode_id, pro_id),
   FOREIGN KEY(ode_id) REFERENCES orders_details(ode_id),
   FOREIGN KEY(pro_id) REFERENCES products(pro_id)
);

CREATE TABLE commander(
   cus_id INT,
   ord_id INT,
   PRIMARY KEY(cus_id, ord_id),
   FOREIGN KEY(cus_id) REFERENCES customers(cus_id),
   FOREIGN KEY(ord_id) REFERENCES orders(ord_id)
);

CREATE TABLE contenir(
   ord_id INT,
   ode_id INT,
   PRIMARY KEY(ord_id, ode_id),
   FOREIGN KEY(ord_id) REFERENCES orders(ord_id),
   FOREIGN KEY(ode_id) REFERENCES orders_details(ode_id)
);
