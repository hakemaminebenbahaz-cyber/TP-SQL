-- ============================================
-- DATA.SQL - Human Bot Database (SQL Server)
-- ============================================

-- ============================================
-- INSERTION DES USINES
-- ============================================
INSERT INTO FACTORIES (factory_name, location) 
VALUES ('Usine Paris', 'Paris');

INSERT INTO FACTORIES (factory_name, location) 
VALUES ('Usine Caracas', 'Caracas');

-- ============================================
-- INSERTION DES TRAVAILLEURS - USINE 1 (Paris)
-- ============================================
INSERT INTO WORKERS_FACTORY_1 (lastname, firstname, age, start_date, end_date, factory_id)
VALUES ('Dupont', 'Jean', 35, '2020-01-15', NULL, 1);

INSERT INTO WORKERS_FACTORY_1 (lastname, firstname, age, start_date, end_date, factory_id)
VALUES ('Martin', 'Marie', 28, '2021-03-10', NULL, 1);

INSERT INTO WORKERS_FACTORY_1 (lastname, firstname, age, start_date, end_date, factory_id)
VALUES ('Bernard', 'Luc', 42, '2019-06-20', NULL, 1);

INSERT INTO WORKERS_FACTORY_1 (lastname, firstname, age, start_date, end_date, factory_id)
VALUES ('Petit', 'Sophie', 31, '2022-11-05', NULL, 1);

INSERT INTO WORKERS_FACTORY_1 (lastname, firstname, age, start_date, end_date, factory_id)
VALUES ('Durand', 'Pierre', 45, '2018-02-28', '2020-12-31', 1);

-- ============================================
-- INSERTION DES TRAVAILLEURS - USINE 2 (Caracas)
-- ============================================
INSERT INTO WORKERS_FACTORY_2 (lastname, firstname, start_date, end_date, factory_id)
VALUES ('Garcia', 'Carlos', '2021-05-12', NULL, 2);

INSERT INTO WORKERS_FACTORY_2 (lastname, firstname, start_date, end_date, factory_id)
VALUES ('Rodriguez', 'Maria', '2020-09-18', NULL, 2);

INSERT INTO WORKERS_FACTORY_2 (lastname, firstname, start_date, end_date, factory_id)
VALUES ('Lopez', 'Juan', '2022-01-20', NULL, 2);

INSERT INTO WORKERS_FACTORY_2 (lastname, firstname, start_date, end_date, factory_id)
VALUES ('Hernandez', 'Ana', '2019-07-15', NULL, 2);

-- ============================================
-- INSERTION DES FOURNISSEURS
-- ============================================
INSERT INTO SUPPLIERS (supplier_name)
VALUES ('TechParts Inc'), 
       ('RoboSupply Co'), 
       ('MechaComponents Ltd'), 
       ('ElectroWorld SA'), 
       ('AutomationParts GmbH');

-- ============================================
-- INSERTION DES PIÈCES DÉTACHÉES
-- ============================================
INSERT INTO SPARE_PARTS (part_name, part_description)
VALUES ('Moteur principal', 'Moteur électrique 500W'),
       ('Bras articulé gauche', 'Bras robotique avec 5 articulations'),
       ('Bras articulé droit', 'Bras robotique avec 5 articulations'),
       ('Tête avec capteurs', 'Tête avec caméra et capteurs audio'),
       ('Jambe gauche', 'Jambe avec système de stabilisation'),
       ('Jambe droite', 'Jambe avec système de stabilisation'),
       ('Processeur central', 'CPU haute performance pour IA'),
       ('Batterie', 'Batterie lithium 5000mAh'),
       ('Capteur de proximité', 'Capteur ultrason'),
       ('Module vocal', 'Synthèse vocale avancée');

-- ============================================
-- INSERTION DES PIÈCES FOURNIES PAR LES FOURNISSEURS
-- ============================================
INSERT INTO SUPPLIER_PARTS (supplier_id, part_id, quantity_delivered)
VALUES (1, 1, 500), (1, 7, 600), (1, 8, 400),
       (2, 2, 700), (2, 3, 700), (2, 4, 600),
       (3, 5, 900), (3, 6, 900),
       (4, 9, 600), (4, 10, 600),
       (5, 1, 400), (5, 9, 400);

-- ============================================
-- INSERTION DES ROBOTS
-- ============================================
INSERT INTO ROBOTS (model_name, factory_id)
VALUES ('HumanBot-X1', 1),
       ('HumanBot-X2', 1),
       ('HumanBot-Pro', 2),
       ('HumanBot-Lite', 2),
       ('HumanBot-Advanced', 1);

-- ============================================
-- INSERTION DES COMPOSITIONS DE ROBOTS
-- ============================================
-- HumanBot-X1 (6 pièces)
INSERT INTO ROBOT_PARTS (robot_id, part_id, quantity)
VALUES (1, 1, 1), (1, 2, 1), (1, 3, 1), (1, 4, 1), (1, 5, 1), (1, 6, 1);

-- HumanBot-X2 (8 pièces)
INSERT INTO ROBOT_PARTS (robot_id, part_id, quantity)
VALUES (2, 1, 1), (2, 2, 1), (2, 3, 1), (2, 4, 1), (2, 5, 1),
       (2, 6, 1), (2, 7, 1), (2, 8, 1);

-- HumanBot-Pro (5 pièces)
INSERT INTO ROBOT_PARTS (robot_id, part_id, quantity)
VALUES (3, 1, 1), (3, 4, 1), (3, 7, 1), (3, 8, 1), (3, 10, 1);

-- HumanBot-Lite (2 pièces)
INSERT INTO ROBOT_PARTS (robot_id, part_id, quantity)
VALUES (4, 1, 1), (4, 4, 1);

-- HumanBot-Advanced (7 pièces)
INSERT INTO ROBOT_PARTS (robot_id, part_id, quantity)
VALUES (5, 1, 1), (5, 2, 1), (5, 3, 1), (5, 4, 1), (5, 7, 1), (5, 9, 1), (5, 10, 1);

-- ============================================
-- INSERTION DES DONNÉES D'AUDIT (exemple)
-- ============================================
INSERT INTO AUDIT_ROBOT (robot_id)
VALUES (1), (2), (3), (4), (5);

-- ============================================
-- COMMIT DES DONNÉES
-- ============================================
-- SQL Server valide les INSERTS automatiquement ; aucun COMMIT nécessaire
