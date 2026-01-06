-- 1. Trigger pour la vue ALL_WORKERS_ELAPSED
CREATE OR ALTER TRIGGER TRG_ALL_WORKERS_ELAPSED
ON ALL_WORKERS_ELAPSED
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    -- INSERT: rediriger vers la table WORKERS
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO WORKERS (firstname, lastname, age, start_date)
        SELECT firstname, lastname, age, start_date
        FROM inserted;
    END
    -- UPDATE ou DELETE: lever une erreur
    ELSE
    BEGIN
        RAISERROR('Opération non autorisée sur cette vue', 16, 1);
    END
END;
GO

-- 2. Trigger pour auditer les nouveaux robots
CREATE OR ALTER TRIGGER TRG_ROBOTS_AUDIT
ON ROBOTS
AFTER INSERT
AS
BEGIN
    -- Créer la table AUDIT_ROBOT SEULEMENT si elle n'existe pas
    IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AUDIT_ROBOT')
    BEGIN
        CREATE TABLE AUDIT_ROBOT (
            audit_id INT IDENTITY(1,1) PRIMARY KEY,
            robot_id INT NOT NULL,
            date_ajout DATETIME DEFAULT GETDATE()
        );
    END
    
    -- Enregistrer chaque nouveau robot
    INSERT INTO AUDIT_ROBOT (robot_id)
    SELECT id FROM inserted;
END;
GO

-- 3. Trigger pour vérifier la cohérence avant modification via ROBOTS_FACTORIES
CREATE OR ALTER TRIGGER TRG_ROBOTS_FACTORIES_CHECK
ON ROBOTS_FACTORIES
INSTEAD OF INSERT, UPDATE, DELETE
AS
BEGIN
    DECLARE @nb_usines INT;
    DECLARE @nb_tables INT;
    
    -- Compter les usines
    SELECT @nb_usines = COUNT(*) FROM FACTORIES;
    
    -- Compter les tables WORKERS_FACTORY_<N>
    SELECT @nb_tables = COUNT(*)
    FROM INFORMATION_SCHEMA.TABLES
    WHERE TABLE_NAME LIKE 'WORKERS_FACTORY_%';
    
    -- Vérifier la cohérence
    IF @nb_usines != @nb_tables
    BEGIN
        RAISERROR('Nombre d''usines et de tables WORKERS_FACTORY_<N> incohérent', 16, 1);
    END
END;
GO

-- 4. Trigger pour calculer la durée de travail
CREATE OR ALTER TRIGGER TRG_WORKERS_CALCULATE_DUREE
ON WORKERS
AFTER UPDATE
AS
BEGIN
    -- Ajouter la colonne duree_jours SEULEMENT si elle n'existe pas
    IF NOT EXISTS (
        SELECT * FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_NAME = 'WORKERS' AND COLUMN_NAME = 'duree_jours'
    )
    BEGIN
        ALTER TABLE WORKERS ADD duree_jours INT NULL;
    END
    
    -- Calculer la durée pour les workers qui viennent d'avoir une date de fin
    UPDATE w
    SET duree_jours = DATEDIFF(DAY, w.start_date, i.end_date)
    FROM WORKERS w
    INNER JOIN inserted i ON w.id = i.id
    INNER JOIN deleted d ON w.id = d.id
    WHERE i.end_date IS NOT NULL AND d.end_date IS NULL;
END;
GO