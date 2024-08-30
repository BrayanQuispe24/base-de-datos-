use master;
-- Verifica si la base de datos ya existe
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'Airport')
BEGIN 
    PRINT 'La base de datos ya existe';
END 
ELSE 
BEGIN
    PRINT 'La base de datos no existe, Procediendo a crearla';
    CREATE DATABASE Airport;
END;

GO
-- Cambia al contexto de la base de datos Airport
USE Airport;
GO
-- Crea las tablas
BEGIN TRANSACTION;
BEGIN TRY
    IF OBJECT_ID('status_FT') IS NULL
    BEGIN
    CREATE TABLE status_FT(
        id INT PRIMARY KEY NOT NULL,
        description_status VARCHAR(15),
        CONSTRAINT description_status CHECK(description_status IN ('aviable','canceled','check-in'))
    );
END

IF OBJECT_ID('country') IS NULL
BEGIN
    CREATE TABLE country (
        id INT PRIMARY KEY NOT NULL,
        name_country VARCHAR(50) NOT NULL,
        CONSTRAINT name_country CHECK (LEN(name_country) <= 25)
    );
    CREATE NONCLUSTERED INDEX idx_name_country ON dbo.country(name_country);
END

IF OBJECT_ID('city') IS NULL
BEGIN
    CREATE TABLE city (
        id INT PRIMARY KEY NOT NULL,
        name_city VARCHAR(50) NOT NULL,
        id_country INT,
        FOREIGN KEY (id_country) REFERENCES country(id)
        ON UPDATE CASCADE,
        CONSTRAINT name_city CHECK (LEN(name_city) <= 25)
    );
    CREATE NONCLUSTERED INDEX idx_name_city ON dbo.city(name_city);
END

IF OBJECT_ID('gender') IS NULL
BEGIN
    CREATE TABLE gender(
        id INT PRIMARY KEY NOT NULL,
        type_of_gender VARCHAR(20) NOT NULL,
        CONSTRAINT type_of_gender CHECK(type_of_gender IN('Male','Female','Other'))
    );
    CREATE NONCLUSTERED INDEX idx_type_of_gender ON dbo.gender(type_of_gender);
END

IF OBJECT_ID('marital_status') IS NULL
BEGIN
    CREATE TABLE marital_status(
        id INT PRIMARY KEY NOT NULL,
        marital_state VARCHAR(20) NOT NULL,
        CONSTRAINT marital_state CHECK(marital_state IN('Single','Married','Divorced','Widowed'))
    );
    CREATE NONCLUSTERED INDEX idx_marital_state ON dbo.marital_status(marital_state);
END

IF OBJECT_ID('professions') IS NULL
BEGIN
    CREATE TABLE professions(
        id INT PRIMARY KEY NOT NULL,
        type_professions VARCHAR(50) DEFAULT 'Without_profession',
        CONSTRAINT type_professions CHECK(LEN(type_professions) <= 30)
    );
    CREATE NONCLUSTERED INDEX idx_type_professions ON dbo.professions(type_professions);
END

IF OBJECT_ID('passport') IS NULL
BEGIN
    CREATE TABLE passport (
        number INT PRIMARY KEY NOT NULL,
        nationality VARCHAR(20) NOT NULL,
        issue_date DATE NOT NULL,
        issuing_city INT ,
        FOREIGN KEY(issuing_city) REFERENCES city(id)
        ON DELETE SET NULL,
        CONSTRAINT issue_date CHECK (issue_date >= '1930-01-01' AND issue_date <= CAST(GETDATE() AS DATE))
    );
END

IF OBJECT_ID('identity_card') IS NULL
BEGIN
    CREATE TABLE identity_card (
        number INT PRIMARY KEY NOT NULL,
        birthdate DATE NOT NULL,
        address_home VARCHAR(100) NOT NULL,
        gender INT NOT NULL,
        marital_state INT ,
        birth_place INT ,
        professions INT NOT NULL,
        FOREIGN KEY(gender) REFERENCES gender(id)
        ON UPDATE CASCADE,
        FOREIGN KEY(professions) REFERENCES professions(id)
        ON UPDATE CASCADE,
        FOREIGN KEY(birth_place) REFERENCES city(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        FOREIGN KEY(marital_state) REFERENCES marital_status(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        CONSTRAINT birthdate CHECK (birthdate >= '1930-01-01' AND birthdate <= CAST(GETDATE() AS DATE))
    );
END

IF OBJECT_ID('professions_identity_card') IS NULL
BEGIN
    CREATE TABLE professions_identity_card(
        id_profession INT NOT NULL,
        id_identity_card INT NOT NULL,
        PRIMARY KEY(id_profession, id_identity_card),
        FOREIGN KEY(id_profession) REFERENCES professions(id),
        FOREIGN KEY(id_identity_card) REFERENCES identity_card(number)
    );
END

IF OBJECT_ID('customer') IS NULL
BEGIN
    CREATE TABLE customer (
        id INT PRIMARY KEY NOT NULL,
        first_name VARCHAR(25) NOT NULL,
        last_name VARCHAR(25) NOT NULL,
        id_passport INT NOT NULL,
        id_identity_card INT NOT NULL,
        FOREIGN KEY(id_passport) REFERENCES passport(number),
        FOREIGN KEY(id_identity_card) REFERENCES identity_card(number),
        CONSTRAINT first_name CHECK(first_name NOT LIKE '%[^A-Za-z ]%'),
        CONSTRAINT last_name CHECK(last_name NOT LIKE '%[^A-Za-z ]%')
    );
    CREATE NONCLUSTERED INDEX idx_customer ON dbo.customer(first_name, last_name);
END

IF OBJECT_ID('frequent_flyer_card') IS NULL
BEGIN
    CREATE TABLE frequent_flyer_card (
        ffc_number INT PRIMARY KEY NOT NULL,
        milles INT NOT NULL,
        meal_code VARCHAR(50) DEFAULT 'Default',
        customer_id INT ,
        FOREIGN KEY (customer_id) REFERENCES customer(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        CONSTRAINT milles CHECK(milles >= 100),
        CONSTRAINT meal_code CHECK (meal_code NOT LIKE '%[^A-Za-z ]%')
    );
END

IF OBJECT_ID('distance') IS NULL
BEGIN
    CREATE TABLE distance (
        id INT PRIMARY KEY NOT NULL,
        distance_range VARCHAR(20) NOT NULL,
        CONSTRAINT distance_range CHECK (distance_range NOT LIKE '%[^a-zA-Z0-9]%')
    );
    CREATE NONCLUSTERED INDEX idx_distance_range ON dbo.distance(distance_range);
END

IF OBJECT_ID('modes') IS NULL
BEGIN
    CREATE TABLE modes (
        id INT PRIMARY KEY NOT NULL,
        mode VARCHAR(20) NOT NULL,
        CONSTRAINT mode_type CHECK(mode IN('Commercial', 'Cargo', 'business', 'Military', 'Rescue and emergency')),
        CONSTRAINT mode_format CHECK(mode NOT LIKE '%[^a-zA-Z0-9 ]%')
    );
    CREATE NONCLUSTERED INDEX idx_mode ON dbo.modes(mode);
END

IF OBJECT_ID('ticket') IS NULL
BEGIN
    CREATE TABLE ticket (
        number INT PRIMARY KEY NOT NULL,
        ticketing_code VARCHAR(15) NOT NULL,
        id_customer INT ,
        id_distance INT NOT NULL,
        id_modes INT NOT NULL,
        id_status INT,
        FOREIGN KEY (id_status) REFERENCES status_FT(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        FOREIGN KEY (id_customer) REFERENCES customer(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        FOREIGN KEY (id_distance) REFERENCES distance(id)
        ON UPDATE CASCADE,
        FOREIGN KEY (id_modes) REFERENCES modes(id)
        ON UPDATE CASCADE,
        CONSTRAINT ticketing_code CHECK(ticketing_code NOT LIKE '% %')
    );
    CREATE NONCLUSTERED INDEX idx_ticketing_code ON dbo.ticket(ticketing_code);
END

IF OBJECT_ID('airport') IS NULL
BEGIN
    CREATE TABLE airport (
        id VARCHAR(5) PRIMARY KEY NOT NULL,
        name_airport VARCHAR(160) NOT NULL,
        id_city INT ,
        FOREIGN KEY (id_city) REFERENCES city(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        CONSTRAINT name_airport CHECK(name_airport NOT LIKE '%[^a-zA-Z0-9 ]%')
    );
    CREATE NONCLUSTERED INDEX idx_name_airport ON dbo.airport(name_airport);
END

IF OBJECT_ID('plane_model') IS NULL
BEGIN
    CREATE TABLE plane_model (
        id INT PRIMARY KEY NOT NULL,
        description_plane VARCHAR(100) NOT NULL,
        graphic VARBINARY(MAX) NOT NULL,
        CONSTRAINT description_plane CHECK(description_plane NOT LIKE '%[^a-zA-Z0-9 ]%')
    );
END

IF OBJECT_ID('seat') IS NULL
BEGIN
    CREATE TABLE seat (
        location_seat VARCHAR(4) PRIMARY KEY NOT NULL,
        size INT DEFAULT 32,
        id_plane_model INT ,
        id_status INT,
        FOREIGN KEY (id_status) REFERENCES status_FT(id)
        ON DELETE SET NULL,
        FOREIGN KEY (id_plane_model) REFERENCES plane_model(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        CONSTRAINT size CHECK(size >= 32 AND size <= 52),
        CONSTRAINT location_seat CHECK(location_seat NOT LIKE '%[^a-zA-Z0-9 ]%')
    );
    CREATE NONCLUSTERED INDEX idx_size ON dbo.seat(size);
END

IF OBJECT_ID('flight_number') IS NULL
BEGIN
    CREATE TABLE flight_number (
        id VARCHAR(10) PRIMARY KEY NOT NULL,
        departure_time TIME NOT NULL,
        description_flight VARCHAR(100) NOT NULL,
        type_flight VARCHAR(20) NOT NULL,
        airline VARCHAR(30) NOT NULL,
        id_airport VARCHAR(5),
        id_plane_model INT ,
        FOREIGN KEY (id_airport) REFERENCES airport(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        FOREIGN KEY (id_plane_model) REFERENCES plane_model(id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        CONSTRAINT type_flight CHECK(type_flight IN('Commercial','business','Military')),
        CONSTRAINT description_flight CHECK(description_flight NOT LIKE '')
    );
END

IF OBJECT_ID('flight') IS NULL
BEGIN
    CREATE TABLE flight (
        id INT PRIMARY KEY NOT NULL,
        boarding_time TIME NOT NULL,
        flight_date DATE NOT NULL,
        gate VARCHAR(5) NOT NULL,
        check_in_counter VARCHAR(10) NOT NULL,
        id_flight_number VARCHAR(10) NOT NULL,
        id_status INT,
        FOREIGN KEY (id_flight_number) REFERENCES flight_number(id)
        ON UPDATE CASCADE,
        FOREIGN KEY (id_status) REFERENCES status_FT(id)
        ON UPDATE CASCADE,
        CONSTRAINT flight_date CHECK(flight_date >= '2000-01-01' AND flight_date <= CAST(GETDATE() AS DATE)),
        CONSTRAINT gate CHECK(gate NOT LIKE '%[^a-zA-Z0-9]%')
    );
    CREATE NONCLUSTERED INDEX idx_flight_date ON dbo.flight(flight_date, boarding_time);
END

IF OBJECT_ID('coupon') IS NULL
BEGIN
    CREATE TABLE coupon (
        id INT PRIMARY KEY NOT NULL,
        date_of_redemption DATE DEFAULT GETDATE(),
        class VARCHAR(20) NOT NULL,
        stand_by INT NOT NULL,
        meal_code VARCHAR(50) DEFAULT 'Default',
        number_ticket INT NOT NULL,
        FOREIGN KEY (number_ticket) REFERENCES ticket(number)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
        CONSTRAINT date_of_redemption CHECK(date_of_redemption = CAST(GETDATE() AS DATE))
    );
END

IF OBJECT_ID('pieces_of_luggage') IS NULL
BEGIN
    CREATE TABLE pieces_of_luggage (
        number VARCHAR(20) PRIMARY KEY NOT NULL,
        weight_of_luggage DECIMAL(10,2) NOT NULL,
        id_coupon INT ,
        FOREIGN KEY (id_coupon) REFERENCES coupon(id)
        ON DELETE SET NULL,
        CONSTRAINT weight_of_luggage CHECK(weight_of_luggage <= 40.0),
        CONSTRAINT number CHECK(number NOT LIKE '%[^a-zA-Z0-9]%')
    );
END

IF OBJECT_ID('available_seat') IS NULL
BEGIN
    CREATE TABLE available_seat (
        id INT PRIMARY KEY NOT NULL,
        id_flight INT ,
        id_coupon INT ,
        id_seat VARCHAR(4) ,
        FOREIGN KEY (id_flight) REFERENCES flight(id),
        FOREIGN KEY (id_coupon) REFERENCES coupon(id),
        FOREIGN KEY (id_seat) REFERENCES seat(location_seat)
    );
END

    PRINT 'Operación exitosa';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al crear tablas: ' + ERROR_MESSAGE();
END CATCH;
GO
BEGIN TRANSACTION
BEGIN TRY
-- Insertar datos en la tabla status_FT
INSERT INTO status_FT (id, description_status) VALUES
(1, 'aviable'),
(2, 'canceled'),
(3, 'check-in');

-- Insertar datos en la tabla country
INSERT INTO country (id, name_country) VALUES
(1, 'Brazil'),
(2, 'USA'),
(3, 'Germany'),
(4, 'Japan'),
(5, 'France');

-- Insertar datos en la tabla city
INSERT INTO city (id, name_city, id_country) VALUES
(1, 'São Paulo', 1),
(2, 'New York', 2),
(3, 'Berlin', 3),
(4, 'Tokyo', 4),
(5, 'Paris', 5);

-- Insertar datos en la tabla gender
INSERT INTO gender (id, type_of_gender) VALUES
(1, 'Male'),
(2, 'Female'),
(3, 'Other');

-- Insertar datos en la tabla marital_status
INSERT INTO marital_status (id, marital_state) VALUES
(1, 'Single'),
(2, 'Married'),
(3, 'Divorced'),
(4, 'Widowed');

-- Insertar datos en la tabla professions
INSERT INTO professions (id, type_professions) VALUES
(1, 'Engineer'),
(2, 'Doctor'),
(3, 'Artist'),
(4, 'Teacher'),
(5, 'Nurse');

-- Insertar datos en la tabla passport
INSERT INTO passport (number, nationality, issue_date, issuing_city) VALUES
(1001, 'Brazilian', '2020-01-15', 1),
(1002, 'American', '2019-03-22', 2),
(1003, 'German', '2021-07-30', 3),
(1004, 'Japanese', '2018-11-05', 4),
(1005, 'French', '2022-06-12', 5);

-- Insertar datos en la tabla identity_card
INSERT INTO identity_card (number, birthdate, address_home, gender, marital_state, birth_place, professions) VALUES
(2001, '1985-02-20', '123 Main St, São Paulo', 1, 1, 1, 1),
(2002, '1990-09-15', '456 Elm St, New York', 2, 2, 2, 2),
(2003, '1982-06-10', '789 Maple St, Berlin', 3, 3, 3, 3),
(2004, '1975-04-05', '101 Pine St, Tokyo', 1, 4, 4, 4),
(2005, '1988-12-25', '202 Oak St, Paris', 2, 1, 5, 5);

-- Insertar datos en la tabla professions_identity_card
INSERT INTO professions_identity_card (id_profession, id_identity_card) VALUES
(1, 2001),
(2, 2002),
(3, 2003),
(4, 2004),
(5, 2005);

-- Insertar datos en la tabla customer
INSERT INTO customer (id, first_name, last_name, id_passport, id_identity_card) VALUES
(1, 'John', 'Doe', 1001, 2001),
(2, 'Jane', 'Smith', 1002, 2002),
(3, 'Alice', 'Johnson', 1003, 2003),
(4, 'Bob', 'Brown', 1004, 2004),
(5, 'Charlie', 'Davis', 1005, 2005);

-- Insertar datos en la tabla frequent_flyer_card
INSERT INTO frequent_flyer_card (ffc_number, milles, meal_code, customer_id) VALUES
(3001, 5000, 'Vegetarian', 1),
(3002, 3000, 'Non Vegetarian', 2),
(3003, 7000, 'Vegan', 3),
(3004, 2000, 'Gluten Free', 4),
(3005, 10000, 'Kosher', 5);

-- Insertar datos en la tabla distance
INSERT INTO distance (id, distance_range) VALUES
(1, 'Short'),
(2, 'Medium'),
(3, 'Long');

-- Insertar datos en la tabla modes
INSERT INTO modes (id, mode) VALUES
(1, 'Commercial'),
(2, 'Cargo'),
(3, 'Business'),
(4, 'Military'),
(5, 'Rescue and emergency');

-- Insertar datos en la tabla ticket
INSERT INTO ticket (number, ticketing_code, id_customer, id_distance, id_modes, id_status) VALUES
(4001, 'TK1001', 1, 1, 1, 1),
(4002, 'TK1002', 2, 2, 2, 2),
(4003, 'TK1003', 3, 3, 3, 3),
(4004, 'TK1004', 4, 1, 4, 1),
(4005, 'TK1005', 5, 2, 5, 2);

-- Insertar datos en la tabla airport
INSERT INTO airport (id, name_airport, id_city) VALUES
('A001', 'São Paulo Airport', 1),
('A002', 'New York Airport', 2),
('A003', 'Berlin Airport', 3),
('A004', 'Tokyo Airport', 4),
('A005', 'Paris Airport', 5);

-- Insertar datos en la tabla plane_model
INSERT INTO plane_model (id, description_plane, graphic) VALUES
(1, 'Boeing 737', 0x00),
(2, 'Airbus A320', 0x00),
(3, 'Boeing 777', 0x00),
(4, 'Airbus A380', 0x00),
(5, 'Boeing 787', 0x00);

-- Insertar datos en la tabla seat
INSERT INTO seat (location_seat, size, id_plane_model, id_status) VALUES
('1A', 32, 1, 1),
('1B', 32, 1, 1),
('2A', 32, 2, 2),
('2B', 32, 2, 2),
('3A', 32, 3, 3);

-- Insertar datos en la tabla flight_number
INSERT INTO flight_number (id, departure_time, description_flight, type_flight, airline, id_airport, id_plane_model) VALUES
('FN001', '08:00:00', 'Flight to New York', 'Commercial', 'Delta', 'A001', 1),
('FN002', '09:00:00', 'Flight to Berlin', 'Commercial', 'Lufthansa', 'A002', 2),
('FN003', '10:00:00', 'Flight to Tokyo', 'Commercial', 'Japan Airlines', 'A003', 3),
('FN004', '11:00:00', 'Flight to Paris', 'Commercial', 'Air France', 'A004', 4),
('FN005', '12:00:00', 'Flight to São Paulo', 'Commercial', 'CargoAir', 'A005', 5);

-- Insertar datos en la tabla flight
INSERT INTO flight (id,boarding_time, flight_date, gate, check_in_counter, id_flight_number, id_status) VALUES
(1,'07:30:00', '2024-08-01', 'A1', 'C01', 'FN001', 1),
(2,'08:30:00', '2024-08-02', 'B1', 'C02', 'FN002', 2),
(3,'09:30:00', '2024-08-03', 'C1', 'C03', 'FN003', 3),
(4,'10:30:00', '2024-08-04', 'D1', 'C04', 'FN004', 1),
(5,'11:30:00', '2024-08-05', 'E1', 'C05', 'FN005', 2);

-- Insertar datos en la tabla coupon
INSERT INTO coupon (id, date_of_redemption, class, stand_by, meal_code, number_ticket) VALUES
(1, '2024-08-30', 'Economy', 0, 'Vegetarian', 4001),
(2, '2024-08-30', 'Business', 1, 'Non-Vegetarian', 4002),
(3, '2024-08-30', 'Economy', 0, 'Vegan', 4003),
(4, '2024-08-30', 'First', 1, 'Gluten-Free', 4004),
(5, '2024-08-30', 'Economy', 0, 'Kosher', 4005);

-- Insertar datos en la tabla pieces_of_luggage
INSERT INTO pieces_of_luggage (number, weight_of_luggage, id_coupon) VALUES
('LUG001', 25.00, 1),
('LUG002', 30.50, 2),
('LUG003', 20.75, 3),
('LUG004', 15.00, 4),
('LUG005', 22.60, 5);

-- Insertar datos en la tabla available_seat
INSERT INTO available_seat (id, id_flight, id_coupon, id_seat) VALUES
(1, 1, 1, '1A'),
(2, 2, 2, '1B'),
(3, 3, 3, '2A'),
(4, 4, 4, '2B'),
(5, 5, 5, '3A');

COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
END CATCH;
/*
SELECT 
    t.name AS TableName,
    i.name AS IndexName,
    i.type_desc AS IndexType
FROM 
    sys.indexes AS i
    INNER JOIN sys.tables AS t ON i.object_id = t.object_id
WHERE 
    t.is_ms_shipped = 0
ORDER BY 
    t.name, i.name;*/
