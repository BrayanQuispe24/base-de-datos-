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
	 IF OBJECT_ID('country') IS NULL
	 BEGIN 
	 CREATE TABLE country (
     id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
     name VARCHAR(50) NOT NULL,
     );
	 CREATE NONCLUSTERED INDEX idx_name_country ON dbo.country(name);
	END
	
-----------------------------------------------------------------      
	IF OBJECT_ID('city') IS NULL
	BEGIN 
	CREATE TABLE city (
     id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
     name_city VARCHAR(50) NOT NULL,
     id_country INT NOT NULL,
     FOREIGN KEY (id_country) REFERENCES country(id)
     );
	 CREATE NONCLUSTERED INDEX idx_name_city ON dbo.city(name_city);
	END
	
-----------------------------------------------------------------      
    IF OBJECT_ID('gender') IS NULL
	BEGIN 
	CREATE TABLE gender(
	 id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
     type_of_gender VARCHAR(20) NOT NULL,
     CONSTRAINT type_of_gender CHECK(type_of_gender IN('Male','Female','Other'))
	);
	CREATE NONCLUSTERED INDEX idx_type_of_gender ON dbo.gender(type_of_gender);
	END
	
-----------------------------------------------------------------  	
    IF OBJECT_ID('marital_status') IS NULL
	BEGIN 
	 CREATE TABLE marital_status(
	 id  INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	 marital_state VARCHAR(20) NOT NULL ,
	 CONSTRAINT  marital_state CHECK(marital_state IN('Single','Married','Divorced','Widowed'))
	 );
	 CREATE NONCLUSTERED INDEX idx_marital_state  ON dbo.marital_status(marital_state);
	END
	
-----------------------------------------------------------------  	
	IF OBJECT_ID('professions') IS NULL
	BEGIN 
	 CREATE TABLE professions(
	 id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
	 type_professions VARCHAR(50) DEFAULT 'Without_profession' ,
	 );
	 CREATE NONCLUSTERED INDEX idx_type_professions ON dbo.professions(type_professions);
	END
	
-----------------------------------------------------------------  	
    IF OBJECT_ID('passport') IS NULL
	BEGIN 
	CREATE TABLE passport (
      number INT PRIMARY KEY NOT NULL,
      nationality VARCHAR(20) NOT NULL,
      issue_date DATE NOT NULL,
      issuing_city INT NOT NULL,
	  FOREIGN KEY(issuing_city) REFERENCES city(id),
	  CONSTRAINT  issue_date CHECK (issue_date>='1930-01-01')
      );
	END
-----------------------------------------------------------------      
    IF OBJECT_ID('identity_card') IS NULL
	BEGIN 
	  CREATE TABLE identity_card (
       number INT PRIMARY KEY NOT NULL,
       birthdate DATE NOT NULL,
	   CONSTRAINT  birthdate CHECK (birthdate>='1930-01-01'),
       address_home VARCHAR(100) NOT NULL,
	   gender INT NOT NULL,
	   marital_state INT NOT NULL,
       birth_place INT NOT NULL,
	   professions INT NOT NULL,
	   FOREIGN KEY(gender) REFERENCES gender(id),
	   FOREIGN KEY(professions) REFERENCES professions(id),
	   FOREIGN KEY(birth_place) REFERENCES city(id),
	   FOREIGN KEY(marital_state) REFERENCES marital_status(id)
       );
	END
-----------------------------------------------------------------      
	IF OBJECT_ID('professions_identity_card') IS NULL
	BEGIN 
	   CREATE TABLE professions_identity_card(
	   id_profession INT NOT NULL,
	   id_identity_card INT NOT NULL,
	   PRIMARY KEY(id_profession,id_identity_card),
	   FOREIGN KEY(id_profession) REFERENCES professions(id),
	   FOREIGN KEY(id_identity_card) REFERENCES identity_card(number) 
	   );
	END

-----------------------------------------------------------------  	    
    IF OBJECT_ID('customer') IS NULL
	BEGIN 
	 CREATE TABLE customer (
       id INT PRIMARY KEY NOT NULL,
       first_name VARCHAR(25) NOT NULL,
	   last_name VARCHAR(25) NOT NULL,
       id_passport INT NOT NULL, 
       id_identity_card INT NOT NULL,
       FOREIGN KEY(id_passport) REFERENCES passport(number),
       FOREIGN KEY(id_identity_card) REFERENCES identity_card(number)
      );
	  CREATE NONCLUSTERED INDEX  idx_costomer ON dbo.customer(first_name,last_name);
	END
	
-----------------------------------------------------------------      
	IF OBJECT_ID('frequent_flyer_card') IS NULL
	BEGIN 
	  CREATE TABLE frequent_flyer_card (
      ffc_number INT PRIMARY KEY NOT NULL,
      milles INT NOT NULL,
      meal_code VARCHAR(50) DEFAULT 'Default',
      customer_id INT NOT NULL,
      FOREIGN KEY (customer_id) REFERENCES customer(id)
      );
	END
-----------------------------------------------------------------     
	IF OBJECT_ID('distance') IS NULL
	BEGIN 
	  CREATE TABLE distance (
      id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
      distance_range VARCHAR(20) NOT NULL
      );
	  CREATE NONCLUSTERED INDEX  idx_distance_range ON dbo.distance(distance_range);
	END
	
-----------------------------------------------------------------  	   
	IF OBJECT_ID('modes') IS NULL
	  BEGIN 
	  CREATE TABLE modes (
      id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
      mode VARCHAR(20) NOT NULL,
      CONSTRAINT mode CHECK(mode IN('Commercial','Cargo ','business','Military','Rescue and emergency'))
      );
	  CREATE NONCLUSTERED INDEX  idx_mode ON dbo.modes(mode);
	END
-----------------------------------------------------------------      
	IF OBJECT_ID('ticket') IS NULL
	BEGIN 
	  CREATE TABLE ticket (
      number INT PRIMARY KEY NOT NULL,
      ticketing_code VARCHAR(15) NOT NULL,
      id_customer INT NOT NULL,
	  id_distance INT NOT NULL,
      id_modes INT NOT NULL,
      FOREIGN KEY (id_customer) REFERENCES customer(id),
	  FOREIGN KEY (id_distance) REFERENCES distance(id),
      FOREIGN KEY (id_modes) REFERENCES modes(id)
      );
	  CREATE NONCLUSTERED INDEX idx_ticketing_code ON dbo.ticket(ticketing_code);
	END
-----------------------------------------------------------------      
	IF OBJECT_ID('airport') IS NULL
	BEGIN
	  CREATE TABLE airport (
      id VARCHAR(5) PRIMARY KEY NOT NULL,
      name_airport VARCHAR(160) NOT NULL,
      id_city INT NOT NULL,
      FOREIGN KEY (id_city) REFERENCES city(id)
      );
	  CREATE NONCLUSTERED INDEX idx_name_airport ON dbo.airport(name_airport);
	END
	
-----------------------------------------------------------------      
	IF OBJECT_ID('plane_model') IS NULL
	  BEGIN
	  CREATE TABLE plane_model (
      id INT PRIMARY KEY NOT NULL,
      description VARCHAR(100) NOT NULL,
      graphic VARBINARY(MAX) NOT NULL,
      );
	END
-----------------------------------------------------------------  
	IF OBJECT_ID('seat') IS NULL
	  BEGIN
	  CREATE TABLE seat (
      location_seat VARCHAR(4) PRIMARY KEY NOT NULL,
      size INT DEFAULT 32,
      id_plane_model INT NOT NULL,
      FOREIGN KEY (id_plane_model) REFERENCES plane_model(id)
      );
	END
-----------------------------------------------------------------      
    IF OBJECT_ID('flight_number') IS NULL
	BEGIN 
	  CREATE TABLE flight_number (
      id VARCHAR(10) PRIMARY KEY NOT NULL,
      departure_time  TIME  NOT NULL,
      description_flight VARCHAR(100) NOT NULL,
      type_flight VARCHAR(20) NOT NULL,
	  CONSTRAINT type_flight CHECK(type_flight IN('Commercial','business','Military')),
      airline VARCHAR(30) NOT NULL,
      id_airport VARCHAR(5) NOT NULL,
      id_plane_model INT NOT NULL,
      FOREIGN KEY (id_airport) REFERENCES airport(id),
      FOREIGN KEY (id_plane_model) REFERENCES plane_model(id)
      );
	END
-----------------------------------------------------------------  
	IF OBJECT_ID('flight') IS NULL
	BEGIN
	  CREATE TABLE flight (
      id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
      boarding_time TIME NOT NULL,
      flight_date DATE NOT NULL,
      CONSTRAINT flight_date CHECK(flight_date >= '2000-01-01'),
      gate VARCHAR(5) NOT NULL,
      check_in_counter VARCHAR(10) NOT NULL,
      id_flight_number VARCHAR(10) NOT NULL,
      FOREIGN KEY (id_flight_number) REFERENCES flight_number(id)
      );
	  CREATE NONCLUSTERED INDEX idx_flight_date ON dbo.flight(flight_date,boarding_time);
	END
	
-----------------------------------------------------------------  
	IF OBJECT_ID('coupon') IS NULL
	BEGIN 
	  CREATE TABLE coupon (
      id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
      date_of_redemption SMALLDATETIME DEFAULT GETDATE(),
      class VARCHAR(20) NOT NULL,
      stand_by INT NOT NULL,
      meal_code VARCHAR(50) DEFAULT 'Default',
      number_ticket INT NOT NULL,
      FOREIGN KEY (number_ticket) REFERENCES ticket(number)
      );
	END
-----------------------------------------------------------------    
    IF OBJECT_ID('pieces_of_luggage') IS NULL
	BEGIN
	CREATE TABLE pieces_of_luggage (
        number VARCHAR(20) PRIMARY KEY NOT NULL,
        weight_of_luggage DECIMAL(10,2) NOT NULL,
		CONSTRAINT weight_of_luggage CHECK(weight_of_luggage<=40.0),
        id_coupon INT NOT NULL,
        FOREIGN KEY (id_coupon) REFERENCES coupon(id)
    );
	END
------------------------------------------------------------------    
	IF OBJECT_ID('available_seat') IS NULL
	BEGIN 
	 CREATE TABLE available_seat (
        id INT PRIMARY KEY NOT NULL IDENTITY(1,1),
        id_flight INT NOT NULL,
        id_coupon INT NOT NULL,
        id_seat VARCHAR(4) NOT NULL,
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
-- Inserta datos en las tablas
BEGIN TRANSACTION;
BEGIN TRY
    -- Insertar registros en la tabla country
INSERT INTO dbo.country (name) VALUES
('USA'),
('Brazil'),
('Canada');

-- Insertar registros en la tabla city
INSERT INTO dbo.city (name_city, id_country) VALUES
('New York', 1),
('São Paulo', 2),
('Toronto', 3);

-- Insertar registros en la tabla gender
INSERT INTO dbo.gender (type_of_gender) VALUES
('Male'),
('Female'),
('Other');

-- Insertar registros en la tabla marital_status
INSERT INTO dbo.marital_status (marital_state) VALUES
('Single'),
('Married'),
('Divorced'),
('Widowed');

-- Insertar registros en la tabla professions
INSERT INTO dbo.professions (type_professions) VALUES
('Engineer'),
('Doctor'),
('Teacher'),
('Without_profession');

-- Insertar registros en la tabla passport
INSERT INTO dbo.passport (number, nationality, issue_date, issuing_city) VALUES
(123456789, 'USA', '2020-01-15', 1),
(987654321, 'Brazil', '2019-11-23', 2);

-- Insertar registros en la tabla identity_card
INSERT INTO dbo.identity_card (number, birthdate, address_home, gender, marital_state, birth_place, professions) VALUES
(111223344, '1985-05-12', '123 Main St, New York', 1, 1, 1, 1),
(222334455, '1990-07-30', '456 Elm St, São Paulo', 2, 2, 2, 2);

-- Insertar registros en la tabla professions_identity_card
INSERT INTO dbo.professions_identity_card (id_profession, id_identity_card) VALUES
(1, 111223344),
(2, 222334455);

-- Insertar registros en la tabla customer
INSERT INTO dbo.customer (id, first_name, last_name, id_passport, id_identity_card) VALUES
(1, 'John', 'Doe', 123456789, 111223344),
(2, 'Maria', 'Silva', 987654321, 222334455);

-- Insertar registros en la tabla frequent_flyer_card
INSERT INTO dbo.frequent_flyer_card (ffc_number, milles, meal_code, customer_id) VALUES
(1, 5000, 'Vegetarian', 1),
(2, 3000, 'Non-Vegetarian', 2);

-- Insertar registros en la tabla distance
INSERT INTO dbo.distance (distance_range) VALUES
('Short'),
('Medium'),
('Long');

-- Insertar registros en la tabla modes
INSERT INTO dbo.modes (mode) VALUES
('Commercial'),
('Cargo'),
('Business'),
('Military'),
('Rescue and emergency');

-- Insertar registros en la tabla ticket
INSERT INTO dbo.ticket (number, ticketing_code, id_customer, id_distance, id_modes) VALUES
(1001, 'A12345', 1, 1, 1),
(1002, 'B67890', 2, 2, 2);

-- Insertar registros en la tabla airport
INSERT INTO dbo.airport (id, name_airport, id_city) VALUES
('JFK', 'John F. Kennedy International Airport', 1),
('GRU', 'São Paulo/Guarulhos – Governor André Franco Montoro International Airport', 2);

-- Insertar registros en la tabla plane_model
INSERT INTO dbo.plane_model (id, description, graphic) VALUES
(1, 'Boeing 747', 0x00),
(2, 'Airbus A320', 0x01);

-- Insertar registros en la tabla seat
INSERT INTO dbo.seat (location_seat, size, id_plane_model) VALUES
('1A', 32, 1),
('1B', 32, 2);

-- Insertar registros en la tabla flight_number
INSERT INTO dbo.flight_number (id, departure_time, description_flight, type_flight, airline, id_airport, id_plane_model) VALUES
('AA123', '10:00:00', 'New York to Los Angeles', 'Commercial', 'American Airlines', 'JFK', 1),
('UA456', '14:00:00', 'São Paulo to Toronto', 'Commercial', 'United Airlines', 'GRU', 2);

-- Insertar registros en la tabla flight
INSERT INTO dbo.flight (boarding_time, flight_date, gate, check_in_counter, id_flight_number) VALUES
('09:30:00', '2024-09-01', 'A1', '1A', 'AA123'),
('13:30:00', '2024-09-02', 'B2', '2B', 'UA456');

-- Insertar registros en la tabla coupon
INSERT INTO dbo.coupon (class, stand_by, meal_code, number_ticket) VALUES
('Economy', 1, 'Vegetarian', 1001),
('Business', 0, 'Non-Vegetarian', 1002);

-- Insertar registros en la tabla pieces_of_luggage
INSERT INTO dbo.pieces_of_luggage (number, weight_of_luggage, id_coupon) VALUES
('LUG001', 23.50, 1),
('LUG002', 30.00, 2);

-- Insertar registros en la tabla available_seat
INSERT INTO dbo.available_seat (id_flight, id_coupon, id_seat) VALUES
(1, 1, '1A'),
(2, 2, '1B');
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
