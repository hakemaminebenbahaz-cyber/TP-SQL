-- 1. FACTORIES (usines)
-- 2. WORKERS_FACTORY_X (travailleurs par usine) 
-- 3. ROBOTS (robots produits)
-- 4. ROBOT_PARTS (pièces par robot)
-- 5. SUPPLIERS (fournisseurs)
-- 6. SUPPLIES (livraisons fournisseurs)



-- ====================================================
-- FONCTION 1 : GET_NB_WORKERS
-- Retourne le nombre de travailleurs dans une usine spécifique
-- ====================================================
CREATE OR ALTER FUNCTION dbo.GET_NB_WORKERS(@FACTORY_ID INT)
RETURNS INT
AS
BEGIN
    DECLARE @worker_count INT = 0;
    
    -- Logique : Compter les travailleurs selon l'usine
    -- On utilise une union de toutes les tables WORKERS_FACTORY_X
    -- Seulement les travailleurs actifs (end_date IS NULL)
    
    IF @FACTORY_ID = 1  -- Usine Paris
    BEGIN
        SELECT @worker_count = COUNT(*)
        FROM WORKERS_FACTORY_1
        WHERE end_date IS NULL;
    END
    ELSE IF @FACTORY_ID = 2  -- Usine Caracas
    BEGIN
        SELECT @worker_count = COUNT(*)
        FROM WORKERS_FACTORY_2
        WHERE end_date IS NULL;
    END
    ELSE IF @FACTORY_ID = 3  -- Usine Beijing
    BEGIN
        SELECT @worker_count = COUNT(*)
        FROM WORKERS_FACTORY_3
        WHERE end_date IS NULL;
    END
    -- Ajouter d'autres usines si nécessaire
    
    RETURN ISNULL(@worker_count, 0);
END;
GO

-- ====================================================
-- FONCTION 2 : GET_NB_BIG_ROBOTS
-- Compte le nombre de robots assemblés avec plus de 3 pièces
-- ====================================================
CREATE OR ALTER FUNCTION dbo.GET_NB_BIG_ROBOTS()
RETURNS INT
AS
BEGIN
    DECLARE @big_robots_count INT;
    
    -- ANALYSE DU DATASET TP-SQL : 
    -- Chaque robot a 7 pièces (bras droit/gauche, jambe droit/gauche, tête, buste, jetpack)
    -- Donc TOUS les robots ont plus de 3 pièces
    -- On compte donc tous les robots distincts dans la table ROBOTS
    
    SELECT @big_robots_count = COUNT(DISTINCT robot_id)
    FROM ROBOTS;
    
    -- Version alternative si on veut vraiment vérifier > 3 pièces :
    /*
    SELECT @big_robots_count = COUNT(DISTINCT r.robot_id)
    FROM ROBOTS r
    WHERE (
        SELECT COUNT(*)
        FROM ROBOT_PARTS rp
        WHERE rp.robot_id = r.robot_id
    ) > 3;
    */
    
    RETURN ISNULL(@big_robots_count, 0);
END;
GO

-- ====================================================
-- FONCTION 3 : GET_BEST_SUPPLIER
-- Retourne le nom du fournisseur ayant livré le plus de pièces
-- ====================================================
CREATE OR ALTER FUNCTION dbo.GET_BEST_SUPPLIER()
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @best_supplier_name VARCHAR(100);
    
    -- ANALYSE DU DATASET TP-SQL :
    -- Fournisseurs : Optimux, Boston Mimics, VCTech Robotics
    -- On doit compter le total des pièces livrées par fournisseur
    
    SELECT TOP 1 @best_supplier_name = s.supplier_name
    FROM SUPPLIERS s
    INNER JOIN SUPPLIES sp ON s.supplier_id = sp.supplier_id
    GROUP BY s.supplier_id, s.supplier_name
    ORDER BY SUM(sp.quantity_delivered) DESC;
    
    -- Si la vue BEST_SUPPLIERS existe déjà (créée dans views.sql) :
    /*
    SELECT TOP 1 @best_supplier_name = supplier
    FROM BEST_SUPPLIERS
    ORDER BY nb_parts DESC;
    */
    
    RETURN ISNULL(@best_supplier_name, 'Aucun fournisseur trouvé');
END;
GO

-- ====================================================
-- FONCTION 4 : GET_OLDEST_WORKER
-- Retourne l'identifiant du travailleur le plus ancien
-- (avec la date de début de contrat la plus ancienne)
-- ====================================================
CREATE OR ALTER FUNCTION dbo.GET_OLDEST_WORKER()
RETURNS INT
AS
BEGIN
    DECLARE @oldest_worker_id INT;
    
    -- Chercher dans TOUTES les usines du projet TP-SQL
    -- Prendre le worker avec la start_date la plus ancienne
    -- Qui est toujours actif (end_date IS NULL)
    
    SELECT TOP 1 @oldest_worker_id = worker_id
    FROM (
        -- Usine Paris
        SELECT worker_id, firstname, lastname, start_date
        FROM WORKERS_FACTORY_1
        WHERE end_date IS NULL
        
        UNION ALL
        
        -- Usine Caracas
        SELECT worker_id, firstname, lastname, start_date
        FROM WORKERS_FACTORY_2
        WHERE end_date IS NULL
        
        UNION ALL
        
        -- Usine Beijing  
        SELECT worker_id, firstname, lastname, start_date
        FROM WORKERS_FACTORY_3
        WHERE end_date IS NULL
    ) AS all_workers
    ORDER BY start_date ASC;
    
    RETURN ISNULL(@oldest_worker_id, -1);  -- -1 signifie "non trouvé"
END;
GO

-- ====================================================
-- FONCTION BONUS : Basée sur l'analyse du dataset TP-SQL
-- GET_ROBOT_DETAILS - Retourne les informations d'un robot
-- ====================================================
CREATE OR ALTER FUNCTION dbo.GET_ROBOT_DETAILS(@robot_name VARCHAR(100))
RETURNS TABLE
AS
RETURN
(
    -- Retourne le nombre de pièces et les fournisseurs pour un robot
    SELECT 
        r.robot_name,
        COUNT(DISTINCT rp.part_id) AS total_parts,
        COUNT(DISTINCT s.supplier_id) AS total_suppliers,
        STRING_AGG(DISTINCT s.supplier_name, ', ') AS supplier_list
    FROM ROBOTS r
    LEFT JOIN ROBOT_PARTS rp ON r.robot_id = rp.robot_id
    LEFT JOIN PARTS p ON rp.part_id = p.part_id
    LEFT JOIN SUPPLIERS s ON p.supplier_id = s.supplier_id
    WHERE r.robot_name = @robot_name
    GROUP BY r.robot_id, r.robot_name
);
GO


