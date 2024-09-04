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

IF OBJECT_ID('category_customer') IS NULL
BEGIN
CREATE TABLE category_customer(
id INT PRIMARY KEY NOT NULL,
category_name VARCHAR(20) NOT NULL,
description_category VARCHAR(150) NOT NULL,
CONSTRAINT category_name CHECK(category_name IN('Frecuent','Not_frecuent','Loyal','Special_needs')))
CREATE NONCLUSTERED INDEX idx_category_name ON dbo.category_customer(category_name);
END

IF OBJECT_ID('customer') IS NULL
BEGIN
    CREATE TABLE customer (
        id INT PRIMARY KEY NOT NULL,
        first_name VARCHAR(25) NOT NULL,
        last_name VARCHAR(25) NOT NULL,
        id_passport INT NOT NULL,
        id_identity_card INT NOT NULL,
		id_category_customer INT NOT NULL,
        FOREIGN KEY(id_category_customer) REFERENCES category_customer(id),
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
        size INT NOT NULL,
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
        id INT PRIMARY KEY NOT NULL,
        weight_of_luggages DECIMAL(10,2) NOT NULL,
		amount_luggages INT NOT NULL,
        id_coupon INT ,
        FOREIGN KEY (id_coupon) REFERENCES coupon(id)
        ON DELETE SET NULL,
        CONSTRAINT amount_luggages CHECK(amount_luggages<=10),
        CONSTRAINT weight_of_luggages CHECK(weight_of_luggages <= 40.0)      
    );
END

IF OBJECT_ID('type_of_luggages')IS NULL
BEGIN
CREATE TABLE type_of_luggages(
id INT PRIMARY KEY NOT NULL,
name_type VARCHAR(20) NOT NULL,
description_type VARCHAR(100) DEFAULT 'No description',
tariff DECIMAL(10,2) NOT NULL,
CONSTRAINT name_type CHECK (name_type NOT LIKE '%[^A-Za-z ]%'),
CONSTRAINT description_type CHECK (description_type NOT LIKE '%[^A-Za-z ]%'));
END

IF OBJECT_ID('delivery_status') IS NULL
BEGIN
CREATE TABLE delivery_status(
  id INT PRIMARY KEY NOT NULL,
  type_status VARCHAR(15) NOT NULL,
  CONSTRAINT type_status CHECK (type_status IN('Pending','Delivered','lost'))
);
END

IF OBJECT_ID('luggage') IS NULL
BEGIN
CREATE TABLE luggage(
code VARCHAR(20) PRIMARY KEY NOT NULL,
dimensions VARCHAR(10)NOT NULL,
weight_luggage DECIMAL(10,2) NOT NULL,
id_pieces_of_luggage INT NOT NULL,
id_type_luggage INT NOT NULL,
id_delivery_status INT NOT NULL,
CONSTRAINT code CHECK(code NOT LIKE '%[^a-zA-Z0-9]%'),
CONSTRAINT weight_luggage CHECK(weight_luggage<=10.0),
FOREIGN KEY (id_delivery_status) REFERENCES delivery_status(id),
FOREIGN KEY (id_pieces_of_luggage) REFERENCES pieces_of_luggage(id),
FOREIGN KEY (id_type_luggage) REFERENCES type_of_luggages(id));
END

IF OBJECT_ID('status_booking') IS NULL
BEGIN
CREATE TABLE status_booking(
id INT PRIMARY KEY NOT NULL,
name_type VARCHAR(20),
CONSTRAINT name_type_status CHECK(name_type IN('Pending','Canceled','Confirmed','Cancelled'))
);
END

IF OBJECT_ID('payment_method') IS NULL
BEGIN
CREATE TABLE payment_method(
id INT PRIMARY KEY NOT NULL,
method VARCHAR(20),
CONSTRAINT method CHECK(method IN('Credit card','Cash','Other'))
);
END

IF OBJECT_ID('booking') IS NULL
BEGIN
CREATE TABLE booking(
id VARCHAR(10) PRIMARY KEY NOT NULL,
booking_date DATE DEFAULT (CAST(GETDATE() AS DATE)),
id_customer INT NOT NULL,
id_status_booking INT NOT NULL,
id_payment_method INT NOT NULL,
id_flight INT NOT NULL,
CONSTRAINT booking_date CHECK(booking_date >= '2000-01-01' AND booking_date <= CAST(GETDATE() AS DATE)),
FOREIGN KEY (id_status_booking) REFERENCES status_booking(id),
FOREIGN KEY (id_customer) REFERENCES customer(id),
FOREIGN KEY (id_payment_method) REFERENCES payment_method(id),
FOREIGN KEY (id_flight) REFERENCES flight(id),
);
END

IF OBJECT_ID('bill') IS NULL
BEGIN 
CREATE TABLE bill(
id INT PRIMARY KEY NOT NULL,
date_bill DATE NOT NULL,
amount_paid DECIMAL(10,2) NOT NULL,
id_booking VARCHAR(10)NOT NULL,
FOREIGN KEY (id_booking) REFERENCES booking(id),
CONSTRAINT date_bill CHECK(date_bill >= DATEADD(DAY, -2, CAST(GETDATE() AS DATE)) AND date_bill <= CAST(GETDATE() AS DATE)),
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
BEGIN TRANSACTION;
BEGIN TRY
INSERT INTO status_FT (id, description_status) VALUES
(1, 'aviable'),
(2, 'canceled')

INSERT INTO country (id, name_country) VALUES
(1, 'Brazil'),
(2, 'Argentina');

INSERT INTO city (id, name_city, id_country) VALUES
(1, 'São Paulo', 1),
(2, 'Buenos Aires', 2);

INSERT INTO gender (id, type_of_gender) VALUES
(1, 'Male'),
(2, 'Female');

INSERT INTO marital_status (id, marital_state) VALUES
(1, 'Single'),
(2, 'Married');

INSERT INTO professions (id, type_professions) VALUES
(1, 'Engineer'),
(2, 'Doctor');

INSERT INTO passport (number, nationality, issue_date, issuing_city) VALUES
(123456, 'Brazilian', '2023-01-01', 1),
(654321, 'Argentinian', '2023-02-01', 2);

INSERT INTO identity_card (number, birthdate, address_home, gender, marital_state, birth_place, professions) VALUES
(1001, '1990-05-15', '123 Main St', 1, 1, 1, 1),
(1002, '1985-09-20', '456 Elm St', 2, 2, 2, 2);

INSERT INTO category_customer (id, category_name, description_category) VALUES
(1, 'Frecuent', 'Frequent flyer'),
(2, 'Loyal', 'Loyal customer');

INSERT INTO customer (id, first_name, last_name, id_passport, id_identity_card, id_category_customer) VALUES
(1, 'John', 'Doe', 123456, 1001, 1),
(2, 'Jane', 'Smith', 654321, 1002, 2);


INSERT INTO frequent_flyer_card (ffc_number, milles, meal_code, customer_id) VALUES
(1, 5000, 'Vegetarian', 1),
(2, 3000, 'Standard', 2);

INSERT INTO distance (id, distance_range) VALUES
(1, 'Long'),
(2, 'VeryLong');

INSERT INTO modes (id, mode) VALUES
(1, 'Commercial'),
(2, 'Cargo');

INSERT INTO ticket (number, ticketing_code, id_customer, id_distance, id_modes, id_status) VALUES
(1, 'TK001', 1, 1, 1, 1),
(2, 'TK002', 2, 2, 2, 2);

INSERT INTO airport (id, name_airport, id_city) VALUES
('GRU', 'São Paulo International Airport', 1),
('EZE', 'Ezeiza International Airport', 2);

INSERT INTO plane_model (id, description_plane, graphic) VALUES
(1, 'Boeing 737', 0x123456),
(2, 'Airbus A320', 0xabcdef);

INSERT INTO seat (location_seat, size, id_plane_model, id_status) VALUES
('1A', 32, 1, 1),
('2B', 34, 2, 2);

INSERT INTO flight_number (id, departure_time, description_flight, type_flight, airline, id_airport, id_plane_model) VALUES
('FL001', '08:00:00', 'Morning Flight', 'Commercial', 'Airline A', 'GRU', 1),
('FL002', '20:00:00', 'Evening Flight', 'Military', 'Airline B', 'EZE', 2);

INSERT INTO flight (id, boarding_time, flight_date, gate, check_in_counter, id_flight_number, id_status) VALUES
(1, '07:30:00', '2024-04-10', 'G01', 'C01', 'FL001', 1),
(2, '19:30:00', '2024-04-11', 'G02', 'C02', 'FL002', 2);

INSERT INTO coupon (id, date_of_redemption, class, stand_by, meal_code, number_ticket) VALUES
(1, '2024-09-04', 'Economy', 0, 'Vegetarian', 1),
(2, '2024-09-04', 'Business', 1, 'Standard', 2);

INSERT INTO pieces_of_luggage (id, weight_of_luggages, amount_luggages, id_coupon) VALUES
(1, 23.50, 2, 1),
(2, 15.00, 1, 2);

INSERT INTO type_of_luggages (id, name_type, description_type, tariff) VALUES
(1, 'Carry on', 'Hand luggage', 50.00),
(2, 'Checked', 'Large suitcase', 100.00);

INSERT INTO delivery_status (id, type_status) VALUES
(1, 'Pending'),
(2, 'Delivered');

INSERT INTO luggage (code, dimensions, weight_luggage, id_pieces_of_luggage, id_type_luggage, id_delivery_status) VALUES
('LUG001', '55x40x20', 8.50, 1, 1, 1),
('LUG002', '70x50x30', 10.00, 2, 2, 2);

INSERT INTO status_booking (id, name_type) VALUES
(1, 'Pending'),
(2, 'Confirmed');

INSERT INTO payment_method (id, method) VALUES
(1, 'Credit card'),
(2, 'Cash');

INSERT INTO booking (id, booking_date, id_customer, id_status_booking, id_payment_method, id_flight) VALUES
('BK001', '2024-09-01', 1, 1, 1, 1),
('BK002', '2024-09-02', 2, 2, 2, 2);

INSERT INTO bill (id, date_bill, amount_paid, id_booking) VALUES
(1, '2024-09-04', 200.00, 'BK001'),
(2, '2024-09-04', 300.00, 'BK002');

INSERT INTO available_seat (id, id_flight, id_coupon, id_seat) VALUES
(1, 1, 1, '1A'),
(2, 2, 2, '2B');
    COMMIT;
END TRY
BEGIN CATCH
    ROLLBACK;
    THROW;
END CATCH;



/*COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
END CATCH;*/
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
