-- ============================================
-- VIEWS.SQL - Human Bot Database (SQL Server)
-- ============================================

/*
Vue 1 : ALL_WORKERS
- Travailleurs toujours en poste (end_date IS NULL)
- Conserver les valeurs NULL
- Trier par date d’arrivée décroissante
- Champs : lastname, firstname, age, start_date
*/

CREATE OR ALTER VIEW ALL_WORKERS
AS
SELECT
    lastname,
    firstname,
    age,
    start_date
FROM WORKERS_FACTORY_1
WHERE end_date IS NULL

UNION ALL

SELECT
    lastname,
    firstname,
    NULL AS age,
    start_date
FROM WORKERS_FACTORY_2
WHERE end_date IS NULL;
GO

/*
Vue 2 : ALL_WORKERS_ELAPSED
- Basée sur ALL_WORKERS
- Nombre de jours écoulés depuis l’arrivée
*/

CREATE OR ALTER VIEW ALL_WORKERS_ELAPSED
AS
SELECT
    lastname,
    firstname,
    DATEDIFF(DAY, start_date, GETDATE()) AS nb_days_elapsed
FROM ALL_WORKERS;
GO

/*
Vue 3 : BEST_SUPPLIERS
- Fournisseurs ayant livré plus de 1000 pièces
- Tri décroissant sur le nombre de pièces
*/

CREATE OR ALTER VIEW BEST_SUPPLIERS
AS
SELECT
    s.supplier_name AS supplier,
    SUM(sp.quantity_delivered) AS nb_parts
FROM SUPPLIERS s
JOIN SUPPLIER_PARTS sp ON s.supplier_id = sp.supplier_id
GROUP BY s.supplier_name
HAVING SUM(sp.quantity_delivered) > 1000;
GO

/*
Vue 4 : ROBOTS_FACTORIES
- Nombre de robots assemblés par usine
*/

CREATE OR ALTER VIEW ROBOTS_FACTORIES
AS
SELECT
    f.factory_name AS factory,
    COUNT(r.robot_id) AS nb_robots
FROM FACTORIES f
LEFT JOIN ROBOTS r ON f.factory_id = r.factory_id
GROUP BY f.factory_name;
GO

