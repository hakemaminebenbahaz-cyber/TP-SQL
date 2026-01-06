-- ============================================
-- SCHEMA.SQL - Human Bot Database (SQL Server)
-- ============================================

-- Suppression des tables si elles existent (ordre inverse des dépendances)
DROP TABLE IF EXISTS AUDIT_ROBOT;
DROP TABLE IF EXISTS ROBOT_PARTS;
DROP TABLE IF EXISTS SUPPLIER_PARTS;
DROP TABLE IF EXISTS ROBOTS;
DROP TABLE IF EXISTS SPARE_PARTS;
DROP TABLE IF EXISTS SUPPLIERS;
DROP TABLE IF EXISTS WORKERS_FACTORY_2;
DROP TABLE IF EXISTS WORKERS_FACTORY_1;
DROP TABLE IF EXISTS FACTORIES;

-- ============================================
-- CRÉATION DES TABLES
-- ============================================

-- Table des usines
CREATE TABLE FACTORIES (
    factory_id INT IDENTITY(1,1) PRIMARY KEY,
    factory_name VARCHAR(100) NOT NULL,
    location VARCHAR(100)
);
GO

-- Table des travailleurs - Usine 1 (avec âge)
CREATE TABLE WORKERS_FACTORY_1 (
    worker_id INT IDENTITY(1,1) PRIMARY KEY,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    age INT NULL CHECK (age IS NULL OR (age >= 18 AND age <= 100)),
    start_date DATE NOT NULL,
    end_date DATE NULL,
    factory_id INT NOT NULL,
    days_worked INT NULL,
    CONSTRAINT fk_workers_f1_factory FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id),
    CONSTRAINT chk_dates_f1 CHECK (end_date IS NULL OR end_date > start_date)
);
GO

-- Table des travailleurs - Usine 2 (sans âge)
CREATE TABLE WORKERS_FACTORY_2 (
    worker_id INT IDENTITY(1,1) PRIMARY KEY,
    lastname VARCHAR(100) NOT NULL,
    firstname VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    factory_id INT NOT NULL,
    days_worked INT NULL,
    CONSTRAINT fk_workers_f2_factory FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id),
    CONSTRAINT chk_dates_f2 CHECK (end_date IS NULL OR end_date > start_date)
);
GO

-- Table des fournisseurs
CREATE TABLE SUPPLIERS (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL UNIQUE
);
GO

-- Table des pièces détachées
CREATE TABLE SPARE_PARTS (
    part_id INT IDENTITY(1,1) PRIMARY KEY,
    part_name VARCHAR(100) NOT NULL,
    part_description VARCHAR(255)
);
GO

-- Table des robots
CREATE TABLE ROBOTS (
    robot_id INT IDENTITY(1,1) PRIMARY KEY,
    model_name VARCHAR(50) NOT NULL UNIQUE,
    factory_id INT NULL,
    CONSTRAINT fk_robots_factory FOREIGN KEY (factory_id) REFERENCES FACTORIES(factory_id)
);
GO

-- Table de composition des robots (many-to-many)
CREATE TABLE ROBOT_PARTS (
    robot_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
    PRIMARY KEY (robot_id, part_id),
    CONSTRAINT fk_robot_parts_robot FOREIGN KEY (robot_id) REFERENCES ROBOTS(robot_id),
    CONSTRAINT fk_robot_parts_part FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id)
);
GO

-- Table des pièces fournies par les fournisseurs (many-to-many)
CREATE TABLE SUPPLIER_PARTS (
    supplier_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity_delivered INT NOT NULL DEFAULT 0 CHECK (quantity_delivered >= 0),
    PRIMARY KEY (supplier_id, part_id),
    CONSTRAINT fk_supplier_parts_supplier FOREIGN KEY (supplier_id) REFERENCES SUPPLIERS(supplier_id),
    CONSTRAINT fk_supplier_parts_part FOREIGN KEY (part_id) REFERENCES SPARE_PARTS(part_id)
);
GO

-- Table d'audit pour les robots
CREATE TABLE AUDIT_ROBOT (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    robot_id INT NOT NULL,
    creation_date DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT fk_audit_robot FOREIGN KEY (robot_id) REFERENCES ROBOTS(robot_id)
);
GO

-- ============================================
-- CRÉATION DES INDEX
-- ============================================

CREATE INDEX idx_workers_f1_dates ON WORKERS_FACTORY_1(start_date, end_date);
CREATE INDEX idx_workers_f2_dates ON WORKERS_FACTORY_2(start_date, end_date);

CREATE INDEX idx_robots_factory ON ROBOTS(factory_id);

CREATE INDEX idx_supplier_parts_supplier ON SUPPLIER_PARTS(supplier_id);
CREATE INDEX idx_supplier_parts_part ON SUPPLIER_PARTS(part_id);

CREATE INDEX idx_robot_parts_robot ON ROBOT_PARTS(robot_id);
CREATE INDEX idx_robot_parts_part ON ROBOT_PARTS(part_id);

-- ============================================
-- FIN DU SCHEMA
-- ============================================
