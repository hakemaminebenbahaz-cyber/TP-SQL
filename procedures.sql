-- PROCEDURES.SQL 

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- 1) SEED_DATA_WORKERS(@NB_WORKERS, @FACTORY_ID)
--    Crée NB_WORKERS travailleurs dans la table WORKERS_FACTORY_<N> correspondant à l’usine fournie en paramètre.

CREATE OR ALTER PROCEDURE dbo.SEED_DATA_WORKERS
    @NB_WORKERS INT,
    @FACTORY_ID INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @start DATE;
    DECLARE @newId INT;

    WHILE @i <= @NB_WORKERS
    BEGIN
        SET @start = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % DATEDIFF(DAY, '2065-01-01', '2070-01-01'), '2065-01-01');

        IF @FACTORY_ID = 1
        BEGIN
            INSERT INTO dbo.WORKERS_FACTORY_1(lastname, firstname, age, start_date, end_date, factory_id)
            VALUES ('tmp', 'tmp', 18 + (ABS(CHECKSUM(NEWID())) % 48), @start, NULL, @FACTORY_ID);
            SET @newId = SCOPE_IDENTITY();
            UPDATE dbo.WORKERS_FACTORY_1
            SET firstname = CONCAT('worker_f_', @newId),
                lastname  = CONCAT('worker_l_', @newId)
            WHERE worker_id = @newId;
        END
        ELSE IF @FACTORY_ID = 2
        BEGIN
            INSERT INTO dbo.WORKERS_FACTORY_2(lastname, firstname, start_date, end_date, factory_id)
            VALUES ('tmp', 'tmp', @start, NULL, @FACTORY_ID);
            SET @newId = SCOPE_IDENTITY();
            UPDATE dbo.WORKERS_FACTORY_2
            SET firstname = CONCAT('worker_f_', @newId),
                lastname  = CONCAT('worker_l_', @newId)
            WHERE worker_id = @newId;
        END
        ELSE
        BEGIN
            RAISERROR('Unsupported FACTORY_ID. Create WORKERS_FACTORY_<N> table for this factory first.', 16, 1);
            RETURN;
        END

        SET @i += 1;
    END
END;
GO

-- 2) ADD_NEW_ROBOT(@MODEL_NAME)
--    Crée un nouveau robot et l’affecte à l’usine ayant assemblé le plus petit nombre de robots, en se basant sur la vue ROBOTS_FACTORIES.

CREATE OR ALTER PROCEDURE dbo.ADD_NEW_ROBOT
    @MODEL_NAME VARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @factory_id INT;

--    Sélectionner l’usine ayant actuellement le plus faible nombre de robots
    SELECT TOP(1) @factory_id = rf.factory_id
    FROM dbo.ROBOTS_FACTORIES rf
    WHERE rf.factory_id IS NOT NULL
    GROUP BY rf.factory_id
    ORDER BY MAX(rf.nb_robots) ASC, rf.factory_id ASC;

    IF @factory_id IS NULL
        SET @factory_id = (SELECT TOP(1) factory_id FROM dbo.FACTORIES ORDER BY factory_id ASC);

    INSERT INTO dbo.ROBOTS(model_name, factory_id)
    VALUES (@MODEL_NAME, @factory_id);
END;
GO

-- 3) SEED_DATA_SPARE_PARTS(@NB_SPARE_PARTS)
--    Crée le nombre de pièces détachées indiqué en paramètre.
CREATE OR ALTER PROCEDURE dbo.SEED_DATA_SPARE_PARTS
    @NB_SPARE_PARTS INT
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @i INT = 1;
    DECLARE @newId INT;

    WHILE @i <= @NB_SPARE_PARTS
    BEGIN
        INSERT INTO dbo.SPARE_PARTS(part_name, part_description)
        VALUES ('tmp', NULL);
        SET @newId = SCOPE_IDENTITY();
        UPDATE dbo.SPARE_PARTS
        SET part_name = CONCAT('spare_part_', @newId)
        WHERE part_id = @newId;

        SET @i += 1;
    END
END;
GO