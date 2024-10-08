use master;
IF @@TRANCOUNT > 0
    ROLLBACK TRANSACTION
IF EXISTS (SELECT * FROM sys.databases WHERE name = 'tickets_airport_advanced')
BEGIN 
    PRINT 'La base de datos ya existe, la eliminamos y la volvemos a crear';
	DROP DATABASE tickets_airport_advanced;
	CREATE DATABASE tickets_airport_advanced;
	PRINT 'Creación exitosa'
END 
ELSE 
BEGIN
    PRINT 'La base de datos no existe, Procediendo a crearla';
    CREATE DATABASE tickets_airport_advanced;
	PRINT 'Creación exitosa'
END;
GO

USE tickets_airport_advanced;
GO

BEGIN TRANSACTION;
BEGIN TRY
    IF OBJECT_ID('Customer_Type') IS NULL
    BEGIN
    CREATE TABLE Customer_Type (
    id BIGINT PRIMARY KEY,
    name_type NVARCHAR(100),
	NIT BIGINT
	);
	END

IF OBJECT_ID('Customer') IS NULL
BEGIN
    CREATE TABLE Customer (
    id BIGINT PRIMARY KEY,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    phone_number NVARCHAR(50),
    email NVARCHAR(100),
	customer_type_id BIGINT,
    FOREIGN KEY (customer_type_id) REFERENCES Customer_Type(id)
);
END

IF OBJECT_ID('Type_Person') IS NULL
BEGIN
    CREATE TABLE Type_Person (
    id BIGINT PRIMARY KEY,
    name_type NVARCHAR(100)
);
END

IF OBJECT_ID('Types_of_Luggages') IS NULL
BEGIN
    CREATE TABLE Types_of_Luggages(
    id BIGINT PRIMARY KEY,
    name_type NVARCHAR(100),
    description NVARCHAR(255),
	tariff INT
);
END

IF OBJECT_ID('Status_Ticket') IS NULL
BEGIN
    CREATE TABLE Status_Ticket (
    id BIGINT PRIMARY KEY,
    status_name NVARCHAR(100)
);
END

IF OBJECT_ID('Type_Flight') IS NULL
BEGIN
    CREATE TABLE Type_Flight (
    id BIGINT PRIMARY KEY,
    name_type NVARCHAR(100)
);
END

IF OBJECT_ID('Status_Flight') IS NULL
BEGIN
    CREATE TABLE Status_Flight(
    id BIGINT PRIMARY KEY,
    status_name NVARCHAR(100)
);
END

IF OBJECT_ID('Status_FT') IS NULL
BEGIN
    CREATE TABLE Status_FT(
    id BIGINT PRIMARY KEY,
    description_Status NVARCHAR(100)
);
END

IF OBJECT_ID('Compensation_Detail') IS NULL
BEGIN
    CREATE TABLE Compensation_Detail(
    id BIGINT PRIMARY KEY,
    compensation_type NVARCHAR(100),
	compensation_amount NVARCHAR(100),
	issue_by BIGINT,
	issue_date date,
	expiration_date date
);
END

IF OBJECT_ID('Gate_Status') IS NULL
BEGIN
    CREATE TABLE Gate_Status (
    id BIGINT PRIMARY KEY,
    status_name NVARCHAR(100)
);
END

IF OBJECT_ID('Currency') IS NULL
BEGIN
    CREATE TABLE Currency (
    id BIGINT PRIMARY KEY,
    name NVARCHAR(50),
    exchange_rate DECIMAL(10, 4)
);
END

IF OBJECT_ID('Booking_Status') IS NULL
BEGIN
    CREATE TABLE Booking_Status (
    id BIGINT PRIMARY KEY,
    name_status NVARCHAR(100)
);
END

IF OBJECT_ID('Ticket_Category') IS NULL
BEGIN
    CREATE TABLE Ticket_Category (
    id BIGINT PRIMARY KEY,
    category_name NVARCHAR(100)
);
END

IF OBJECT_ID('Penalty_Cancellation') IS NULL
BEGIN
    CREATE TABLE Penalty_Cancellation (
    id BIGINT PRIMARY KEY,
    cancellation_type NVARCHAR(100),
    amount BIGINT
);
END

IF OBJECT_ID('Category') IS NULL
BEGIN
    CREATE TABLE Category (
    id BIGINT PRIMARY KEY,
    category_name NVARCHAR(100),
    description_category NVARCHAR(255)
);
END

IF OBJECT_ID('Paymnet_Status') IS NULL
BEGIN
    CREATE TABLE Paymnet_Status (
    id BIGINT PRIMARY KEY,
    name_status NVARCHAR(100)
);
END

IF OBJECT_ID('Rol_Tripulante') IS NULL
BEGIN
    CREATE TABLE Rol_Tripulante (
    id BIGINT PRIMARY KEY,
    name_rol NVARCHAR(100)
);
END

IF OBJECT_ID('Type_Document') IS NULL
BEGIN
    CREATE TABLE Type_Document (
    id BIGINT PRIMARY KEY,
    name_document NVARCHAR(100)
);
END

IF OBJECT_ID('Category_Assignment') IS NULL
BEGIN
    CREATE TABLE Category_Assignment (
    id BIGINT PRIMARY KEY,
	assignment_date DATE,
    category_id BIGINT,
    customer_id BIGINT,
    FOREIGN KEY (category_id) REFERENCES Category(id),
    FOREIGN KEY (customer_id) REFERENCES Customer(id)
);
END

IF OBJECT_ID('Frequent_Flyer_Card') IS NULL
BEGIN
    CREATE TABLE Frequent_Flyer_Card (
    id BIGINT PRIMARY KEY,
	milles BIGINT,
    Meal_code BIGINT,
	customer_id BIGINT,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
);
END

IF OBJECT_ID('Gate_Assignment_Status') IS NULL
BEGIN
    CREATE TABLE Gate_Assignment_Status (
    id BIGINT PRIMARY KEY,
    date_Assignment date,
	Gate_Status_id BIGINT,
	FOREIGN KEY (Gate_Status_id) REFERENCES Gate_Status(id),
);
END

IF OBJECT_ID('Boarding_Pass') IS NULL
BEGIN
    CREATE TABLE Boarding_Pass (
    id BIGINT PRIMARY KEY,
    boarding_pass_date date,
    boarding_time DATETIME
);
END

IF OBJECT_ID('Check_In') IS NULL
BEGIN
    CREATE TABLE Check_In (
    id BIGINT PRIMARY KEY,
    check_in_time DATETIME,
	boarding_pass_id BIGINT,
	FOREIGN KEY (boarding_pass_id) REFERENCES Boarding_Pass(id)
);
END

IF OBJECT_ID('Request_Assistance') IS NULL
BEGIN
    CREATE TABLE Request_Assistance (
    id BIGINT PRIMARY KEY,
    request_date DATE,
    assistance_type NVARCHAR(100),
    description NVARCHAR(255),
    Status NVARCHAR(100),
	check_in_id BIGINT,
    FOREIGN KEY (check_in_id) REFERENCES Check_In(id)
);
END
IF OBJECT_ID('Airline') IS NULL
BEGIN
    CREATE TABLE Airline (
    id BIGINT PRIMARY KEY,
    name NVARCHAR(100),
    code_iata BIGINT
);
END

IF OBJECT_ID('Country') IS NULL
BEGIN
    CREATE TABLE Country (
    id BIGINT PRIMARY KEY,
    name NVARCHAR(100)
);
END

IF OBJECT_ID('City') IS NULL
BEGIN
    CREATE TABLE City (
    id BIGINT PRIMARY KEY,
    name NVARCHAR(100),
    country_id BIGINT,
    FOREIGN KEY (country_id) REFERENCES Country(id)
);
END

IF OBJECT_ID('Airport') IS NULL
BEGIN
    CREATE TABLE Airport (
    id BIGINT PRIMARY KEY,
    name_airport NVARCHAR(100),
	city_id BIGINT,
	FOREIGN KEY (city_id) REFERENCES City(id)
);
END

IF OBJECT_ID('Flight_Number') IS NULL
BEGIN
    CREATE TABLE Flight_Number (
    id BIGINT PRIMARY KEY,
    departure_time DATETIME,
    description_flight NVARCHAR(100),
    airport_start_id BIGINT,
	airport_goal_id BIGINT,
	airline_id	BIGINT,
	FOREIGN KEY (airline_id) REFERENCES Airline(id),
    FOREIGN KEY (airport_start_id) REFERENCES Airport(id),
	FOREIGN KEY (airport_goal_id) REFERENCES Airport(id)
);
END

IF OBJECT_ID('Flight') IS NULL
BEGIN
    CREATE TABLE Flight (
    id BIGINT PRIMARY KEY,
    boarding_time DATETIME,
    flight_date DATE,
    gate NVARCHAR(100),
	check_in_counter BIGINT,
	type_flight_id BIGINT,
	status_flight_id BIGINT,
	flight_number_id BIGINT,
	FOREIGN KEY (flight_number_id) REFERENCES Flight_Number(id),
	FOREIGN KEY (status_flight_id) REFERENCES Status_Flight(id),
    FOREIGN KEY (type_flight_id) REFERENCES Type_Flight(id)
);
END

IF OBJECT_ID('Plane_Model') IS NULL
BEGIN
    CREATE TABLE Plane_Model (
    id BIGINT PRIMARY KEY,
    description NVARCHAR(100),
    graphic NVARCHAR(100),
);
END

IF OBJECT_ID('Airplane') IS NULL
BEGIN
    CREATE TABLE Airplane (
    id BIGINT PRIMARY KEY,
    registration_number BIGINT,
	Status NVARCHAR(100),
	plane_model_id BIGINT,
	FOREIGN KEY (plane_model_id) REFERENCES Plane_Model(id)
);
END

IF OBJECT_ID('Stopovers') IS NULL
BEGIN
    CREATE TABLE Stopovers (
    id BIGINT PRIMARY KEY,
    stopover_order  NVARCHAR(255),
    stopover_arrival_time DATETIME,
	stopover_departure_time DATETIME,
	airline_id BIGINT,
	flight_number_id BIGINT,
	flight_id BIGINT,
	aiport_start_id BIGINT,
	aiport_goal_id BIGINT,
	FOREIGN KEY (flight_id) REFERENCES Flight(id),
	FOREIGN KEY (aiport_start_id) REFERENCES Airport(id),
	FOREIGN KEY (aiport_goal_id) REFERENCES Airport(id),
	FOREIGN KEY (flight_number_id) REFERENCES Flight_Number(id),
    FOREIGN KEY (airline_id) REFERENCES Airline(id)
);
END

IF OBJECT_ID('Booking') IS NULL
BEGIN
    CREATE TABLE Booking (
    id BIGINT PRIMARY KEY,
    booking_date DATE,
	customer_id BIGINT,
    booking_status_id BIGINT,
	flight_id BIGINT,
    FOREIGN KEY (customer_id) REFERENCES Customer(id),
	FOREIGN KEY (booking_status_id) REFERENCES Booking_Status(id),
	FOREIGN KEY (flight_id) REFERENCES Flight(id)
);
END

IF OBJECT_ID('Gate') IS NULL
BEGIN
    CREATE TABLE Gate (
    id BIGINT PRIMARY KEY,
    name NVARCHAR(100),
	location NVARCHAR(100),
    gate_assignment_status_id BIGINT,
    airport_id BIGINT,
	FOREIGN KEY (gate_assignment_status_id) REFERENCES Gate_Assignment_Status(id),
    FOREIGN KEY (airport_id) REFERENCES Airport(id)
);
END

IF OBJECT_ID('Gate_Assignment') IS NULL
BEGIN
    CREATE TABLE Gate_Assignment (
    id BIGINT PRIMARY KEY,
	assignment_date DATE,
	gate_id BIGINT,
    stopovers_id BIGINT,
    flight_id BIGINT,
	FOREIGN KEY (stopovers_id) REFERENCES Stopovers(id),
	FOREIGN KEY (flight_id) REFERENCES Flight(id),
    FOREIGN KEY (gate_id) REFERENCES Gate(id)
);
END

IF OBJECT_ID('Tripulante') IS NULL
BEGIN
    CREATE TABLE Tripulante (
    id BIGINT PRIMARY KEY,
    genero NVARCHAR(100),
	estado_civil NVARCHAR(100)
);
END

IF OBJECT_ID('Asingnacion_Tripulantes') IS NULL
BEGIN
    CREATE TABLE Asingnacion_Tripulantes (
    id BIGINT PRIMARY KEY,
    assignment_date date,
	rol_tripulante_id BIGINT,
	tripulante_id BIGINT,
	gate_assignment_id BIGINT,
	FOREIGN KEY (rol_tripulante_id) REFERENCES Rol_Tripulante(id),
	FOREIGN KEY (tripulante_id) REFERENCES Tripulante(id),
    FOREIGN KEY (gate_assignment_id) REFERENCES Gate_Assignment(id)
);
END

IF OBJECT_ID('Pasajero') IS NULL
BEGIN
    CREATE TABLE Pasajero (
    id BIGINT PRIMARY KEY,
    genero NVARCHAR(100),
	estado_civil NVARCHAR(100)
);
END

IF OBJECT_ID('Person') IS NULL
BEGIN
    CREATE TABLE Person (
    id BIGINT PRIMARY KEY,
    first_name NVARCHAR(100),
    last_name NVARCHAR(100),
    phone_number NVARCHAR(100),
	email NVARCHAR(100),
	type_person_id BIGINT,
	pasajero_id BIGINT,
	tripulante_id BIGINT,
	FOREIGN KEY (tripulante_id) REFERENCES Tripulante(id),
	FOREIGN KEY (type_person_id) REFERENCES Type_Person(id),
	FOREIGN KEY (pasajero_id) REFERENCES Pasajero(id)
);
END

IF OBJECT_ID('Document') IS NULL
BEGIN
    CREATE TABLE Document (
    id BIGINT PRIMARY KEY,
    issue_date DATE,
	due_date date,
    document_number BIGINT,
	type_document_id BIGINT,
	person_id BIGINT,
	country_id BIGINT,
	FOREIGN KEY (country_id) REFERENCES Country(id),
	FOREIGN KEY (person_id) REFERENCES Person(id),
	FOREIGN KEY (type_document_id) REFERENCES Type_Document(id),
);
END

IF OBJECT_ID('Document_Presentation') IS NULL
BEGIN
    CREATE TABLE Document_Presentation (
    id BIGINT PRIMARY KEY,
    presentation_date DATE,
	customer_id BIGINT,
	document_id BIGINT,
	booking_id BIGINT,
	FOREIGN KEY (booking_id) REFERENCES Booking(id),
	FOREIGN KEY (customer_id) REFERENCES Customer(id),
    FOREIGN KEY (document_id) REFERENCES Document(id)
);
END

IF OBJECT_ID('Credit_Card') IS NULL
BEGIN
    CREATE TABLE Credit_Card (
    id BIGINT PRIMARY KEY,
    card_number NVARCHAR(50),
    cardholder_name NVARCHAR(100),
    expiration_date DATE,
    cvv NVARCHAR(50)
);
END


IF OBJECT_ID('Transferencia_Bancaria') IS NULL
BEGIN
    CREATE TABLE Transferencia_Bancaria (
    id BIGINT PRIMARY KEY,
    account_number NVARCHAR(50),
    bank_numer BIGINT,
	iban BIGINT,
    swift_code NVARCHAR(50)
);
END

IF OBJECT_ID('Cash') IS NULL
BEGIN
    CREATE TABLE Cash (
    id BIGINT PRIMARY KEY
);
END

IF OBJECT_ID('Payment_Method') IS NULL
BEGIN
    CREATE TABLE Payment_Method (
    id BIGINT PRIMARY KEY,
    description NVARCHAR(255),
	credit_card_id BIGINT,
	transferencia_bancaria_id BIGINT,
	cash_id BIGINT,
	FOREIGN KEY (credit_card_id) REFERENCES Credit_Card(id),
	FOREIGN KEY (transferencia_bancaria_id) REFERENCES Transferencia_Bancaria(id),
	FOREIGN KEY (cash_id) REFERENCES Cash(id),
);
END

IF OBJECT_ID('Payment') IS NULL
BEGIN
    CREATE TABLE Payment(
    id BIGINT PRIMARY KEY,
    date_payment date,
	amount BIGINT,
	paymnent_status_id BIGINT,
	booking_id BIGINT,
	payment_method_id BIGINT,
	FOREIGN KEY (payment_method_id) REFERENCES Payment_Method(id),
	FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (paymnent_status_id) REFERENCES Paymnet_Status(id)
);
END

IF OBJECT_ID('Currency_Assignment') IS NULL
BEGIN
    CREATE TABLE Currency_Assignment(
    id BIGINT PRIMARY KEY,
    assignment_date date,
	currency_id BIGINT,
	payment_id BIGINT,
	FOREIGN KEY (payment_id) REFERENCES Payment(id),
    FOREIGN KEY (currency_id) REFERENCES Currency(id)
);
END

IF OBJECT_ID('Cancellation_Bookin') IS NULL
BEGIN
    CREATE TABLE Cancellation_Bookin (
    id BIGINT PRIMARY KEY,
    cancellation_date DATE,
    cancellation_reason NVARCHAR(255),
    penalty_cancellation_id BIGINT,
	booking_id BIGINT,
    FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (penalty_cancellation_id) REFERENCES Penalty_Cancellation(id)
);
END

IF OBJECT_ID('Ticket') IS NULL
BEGIN
    CREATE TABLE Ticket (
    id BIGINT PRIMARY KEY,
    number BIGINT,
    ticketing_code BIGINT,
    ticket_category_id BIGINT,
	check_in_id BIGINT,
	booking_id BIGINT,
	FOREIGN KEY (booking_id) REFERENCES Booking(id),
    FOREIGN KEY (ticket_category_id) REFERENCES Ticket_Category(id),
    FOREIGN KEY (check_in_id) REFERENCES Check_In (id)
);
END

IF OBJECT_ID('Status_Assignment') IS NULL
BEGIN
    CREATE TABLE Status_Assignment (
    id BIGINT PRIMARY KEY,
	assignment_date DATE,
    status_ticket_id BIGINT,
	ticket_id BIGINT,
    FOREIGN KEY (status_ticket_id) REFERENCES Status_Ticket(id),
    FOREIGN KEY (ticket_id) REFERENCES Ticket(id)
);
END

IF OBJECT_ID('Seat') IS NULL
BEGIN
    CREATE TABLE Seat (
    id BIGINT PRIMARY KEY,
    size NVARCHAR(255),
	number BIGINT,
	plane_id BIGINT,
    FOREIGN KEY (plane_id) REFERENCES Plane_Model(id)
);
END

IF OBJECT_ID('Coupon') IS NULL
BEGIN
    CREATE TABLE Coupon (
    id BIGINT PRIMARY KEY,
    date_of_redemption DATE,
    class NVARCHAR(100),
	stand_by NVARCHAR(100),
	meal_code BIGINT,
	ticket_id BIGINT,
	flight_id BIGINT,
	FOREIGN KEY (flight_id) REFERENCES flight(id),
	FOREIGN KEY (ticket_id) REFERENCES Ticket(id),
);
END

IF OBJECT_ID('Available_Seat') IS NULL
BEGIN
    CREATE TABLE Available_Seat(
    id BIGINT PRIMARY KEY,
	status_ft_id BIGINT,
	coupon_id BIGINT,
	flight_id BIGINT,
	seat_id BIGINT,
	FOREIGN KEY (seat_id) REFERENCES Seat (id),
	FOREIGN KEY (flight_id) REFERENCES Flight (id),
	FOREIGN KEY (coupon_id) REFERENCES Coupon (id),
    FOREIGN KEY (status_ft_id) REFERENCES Status_FT (id)
);
END

IF OBJECT_ID('Pieces_of_Luggage') IS NULL
BEGIN
    CREATE TABLE Pieces_of_Luggage (
    id BIGINT PRIMARY KEY,
    weight_of_pieces DECIMAL(5, 2),
    amount_luggages BIGINT,
    total_rate BIGINT,
	coupon_id BIGINT,
    FOREIGN KEY (coupon_id) REFERENCES Coupon (id)
);
END

IF OBJECT_ID('Check_In_Luggage') IS NULL
BEGIN
    CREATE TABLE Check_In_Luggage (
    id BIGINT PRIMARY KEY,
    checking_date DATE,
    status NVARCHAR(50),
	pieces_of_luggage_id BIGINT,
    FOREIGN KEY (pieces_of_luggage_id) REFERENCES Pieces_of_Luggage(id)
);
END

IF OBJECT_ID('Luggage') IS NULL
BEGIN
    CREATE TABLE Luggage (
    id BIGINT PRIMARY KEY,
    code_luggage INT,
	dimensions NVARCHAR(100),
    weight DECIMAL(5, 2),
	pieces_of_luggage_id BIGINT,   
    FOREIGN KEY (pieces_of_luggage_id) REFERENCES Pieces_of_Luggage(id)
);

END

IF OBJECT_ID('Flight_Cancellation') IS NULL
BEGIN
    CREATE TABLE Flight_Cancellation (
    id BIGINT PRIMARY KEY,
    cancellation_time DATETIME,
    cancellation_reason NVARCHAR(255),
    responsible_party NVARCHAR(255),
	flight_number BIGINT,
	compensation_detail BIGINT,
    FOREIGN KEY (flight_number) REFERENCES Flight_Number(id),
	FOREIGN KEY (compensation_detail) REFERENCES Compensation_Detail(id)
);
END



    PRINT 'Creación de tablas';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al crear tablas: ' + ERROR_MESSAGE();
END CATCH;
GO

CREATE PROCEDURE InsertRandomCountry
    @NumberOfRecords INT = 50 -- Ajusta según necesidad
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @MaxID INT;
    DECLARE @NameCountry VARCHAR(25);
    DECLARE @Countries TABLE (Name VARCHAR(25));

    -- Insertar una lista de países comunes
    INSERT INTO @Countries (Name)
    VALUES 
    ('Argentina'), ('Brasil'), ('Canadá'), ('Dinamarca'), ('España'),
    ('Francia'), ('Alemania'), ('Hungría'), ('India'), ('Japón'),
    ('México'), ('Noruega'), ('Perú'), ('Rusia'), ('Suecia'),
    ('Turquía'), ('Uruguay'), ('Venezuela'), ('China'), ('Estados Unidos');

    -- Obtener el máximo ID actual
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM country;

    WHILE @i <= @NumberOfRecords
    BEGIN
        -- Seleccionar un país aleatorio
        SELECT TOP 1 @NameCountry = Name FROM @Countries ORDER BY NEWID();

        -- Insertar el registro
        INSERT INTO country (id, name)
        VALUES (@MaxID + @i, @NameCountry);

        SET @i = @i + 1;
    END
END

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCountry;

    PRINT 'CORRECTO: InsertRandomCountry';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCountry: ' + ERROR_MESSAGE();
END CATCH;
GO


CREATE PROCEDURE InsertRandomCity
    @NumberOfRecords INT = 50 -- Ajusta según necesidad
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @MaxID INT;
    DECLARE @NameCity VARCHAR(25);
    DECLARE @RandomCountryID INT;
    DECLARE @Cities TABLE (Name VARCHAR(25));
	
    -- Insertar una lista de ciudades comunes
    INSERT INTO @Cities (Name)
    VALUES 
    ('Buenos Aires'), ('São Paulo'), ('Toronto'), ('Copenhague'), ('Madrid'),
    ('París'), ('Berlín'), ('Budapest'), ('Mumbai'), ('Tokio'),
    ('Ciudad de México'), ('Oslo'), ('Lima'), ('Moscú'), ('Estocolmo'),
    ('Estambul'), ('Montevideo'), ('Caracas'), ('Beijing'), ('Nueva York');

    -- Obtener el máximo ID actual
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM city;

    WHILE @i <= @NumberOfRecords
    BEGIN
        -- Seleccionar una ciudad aleatoria
        SELECT TOP 1 @NameCity = Name FROM @Cities ORDER BY NEWID();

        -- Seleccionar un país aleatorio existente
        SELECT TOP 1 @RandomCountryID = id FROM country ORDER BY NEWID();

        -- Insertar el registro
        INSERT INTO city (id, name, country_id)
        VALUES (@MaxID + @i, @NameCity, @RandomCountryID);

        SET @i = @i + 1;
    END
END

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCity

    PRINT 'CORRECTO: InsertRandomCity';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCity: ' + ERROR_MESSAGE();
END CATCH;

GO


CREATE PROCEDURE InsertRandomCustomerType
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameType NVARCHAR(100);
    DECLARE @RandomNIT BIGINT;
    DECLARE @MaxID BIGINT;

    -- Tablas temporales para tipos de clientes comunes en un aeropuerto
    DECLARE @NameTypes TABLE (NameType NVARCHAR(100));

    -- Insertar tipos de clientes comunes
    INSERT INTO @NameTypes (NameType)
    VALUES ('Passenger'), ('Airline Staff'), ('Vendor'), ('Maintenance Crew'), ('Security Personnel');

    -- Obtener el máximo ID actual
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM Customer_Type;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de cliente aleatorio
        SELECT TOP 1 @RandomNameType = NameType FROM @NameTypes ORDER BY NEWID();

        -- Generar un NIT aleatorio
        SET @RandomNIT = ABS(CHECKSUM(NEWID())) % 1000000000;

        -- Insertar el registro en la tabla
        INSERT INTO Customer_Type (id, name_type, NIT)
        VALUES (@MaxID + @i, @RandomNameType, @RandomNIT);

        SET @i = @i + 1;
    END
END
GO



BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCustomerType;

    PRINT 'CORRECTO: InsertRandomCustomerType';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCustomerType: ' + ERROR_MESSAGE();
END CATCH 


GO
CREATE PROCEDURE InsertRandomCustomers
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomFirstName NVARCHAR(100);
    DECLARE @RandomLastName NVARCHAR(100);
    DECLARE @RandomPhoneNumber NVARCHAR(50);
    DECLARE @RandomEmail NVARCHAR(100);
    DECLARE @RandomCustomerTypeID BIGINT;

    -- Tablas temporales para nombres y apellidos
    DECLARE @FirstNames TABLE (FirstName NVARCHAR(100));
    DECLARE @LastNames TABLE (LastName NVARCHAR(100));

    -- Insertar nombres comunes
    INSERT INTO @FirstNames (FirstName)
    VALUES ('John'), ('Jane'), ('Michael'), ('Emily'), ('David'), ('Sarah'), ('Chris'), ('Jessica');

    -- Insertar apellidos comunes
    INSERT INTO @LastNames (LastName)
    VALUES ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones'), ('Garcia'), ('Miller'), ('Davis');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre y apellido aleatorio
        SELECT TOP 1 @RandomFirstName = FirstName FROM @FirstNames ORDER BY NEWID();
        SELECT TOP 1 @RandomLastName = LastName FROM @LastNames ORDER BY NEWID();

        -- Generar un número de teléfono y correo electrónico aleatorio
        SET @RandomPhoneNumber = '555-' + CAST(ABS(CHECKSUM(NEWID())) % 10000 AS NVARCHAR(50));
        SET @RandomEmail = LOWER(@RandomFirstName) + '.' + LOWER(@RandomLastName) + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS NVARCHAR(100)) + '@example.com';
        SET @RandomCustomerTypeID = ABS(CHECKSUM(NEWID())) % 10 + 1; -- Asumiendo que tienes al menos 10 tipos de clientes

        -- Insertar el registro en la tabla
        INSERT INTO Customer (id, first_name, last_name, phone_number, email, customer_type_id)
        VALUES (@i, @RandomFirstName, @RandomLastName, @RandomPhoneNumber, @RandomEmail, @RandomCustomerTypeID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCustomers;

    PRINT 'CORRECTO: InsertRandomCustomers';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCustomers: ' + ERROR_MESSAGE();
END CATCH

GO	
CREATE PROCEDURE InsertRandomTypePerson
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameType NVARCHAR(100);

    -- Tablas temporales para tipos de personas comunes en un aeropuerto
    DECLARE @NameTypes TABLE (NameType NVARCHAR(100));

    -- Insertar tipos de personas comunes
    INSERT INTO @NameTypes (NameType)
    VALUES ('Passenger'), ('Pilot'), ('Crew Member'), ('Ground Staff'), ('Security Personnel');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de persona aleatorio
        SELECT TOP 1 @RandomNameType = NameType FROM @NameTypes ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Type_Person (id, name_type)
        VALUES (@i, @RandomNameType);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTypePerson;

    PRINT 'CORRECTO: InsertRandomTypePerson';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTypePerson: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTypesOfLuggages
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameType NVARCHAR(100);
    DECLARE @RandomDescription NVARCHAR(255);
    DECLARE @RandomTariff INT;

    -- Tablas temporales para tipos de equipajes comunes
    DECLARE @NameTypes TABLE (NameType NVARCHAR(100));
    DECLARE @Descriptions TABLE (Description NVARCHAR(255));

    -- Insertar tipos de equipajes comunes
    INSERT INTO @NameTypes (NameType)
    VALUES ('Carry-On'), ('Checked'), ('Oversized'), ('Fragile'), ('Sports Equipment');

    -- Insertar descripciones comunes
    INSERT INTO @Descriptions (Description)
    VALUES ('Small bag for cabin'), ('Large bag for hold'), ('Extra large item'), ('Handle with care'), ('Special sports gear');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de equipaje y descripción aleatoria
        SELECT TOP 1 @RandomNameType = NameType FROM @NameTypes ORDER BY NEWID();
        SELECT TOP 1 @RandomDescription = Description FROM @Descriptions ORDER BY NEWID();

        -- Generar una tarifa aleatoria
        SET @RandomTariff = ABS(CHECKSUM(NEWID())) % 100 + 10;

        -- Insertar el registro en la tabla
        INSERT INTO Types_of_Luggages (id, name_type, description, tariff)
        VALUES (@i, @RandomNameType, @RandomDescription, @RandomTariff);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTypesOfLuggages;

    PRINT 'CORRECTO: InsertRandomTypesOfLuggages';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTypesOfLuggages: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomStatusTicket
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomStatusName NVARCHAR(100);

    -- Tablas temporales para estados de tickets comunes
    DECLARE @StatusNames TABLE (StatusName NVARCHAR(100));

    -- Insertar estados de tickets comunes
    INSERT INTO @StatusNames (StatusName)
    VALUES ('Booked'), ('Checked-In'), ('Cancelled'), ('Boarded'), ('Completed');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un estado de ticket aleatorio
        SELECT TOP 1 @RandomStatusName = StatusName FROM @StatusNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Status_Ticket (id, status_name)
        VALUES (@i, @RandomStatusName);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomStatusTicket;

    PRINT 'CORRECTO: InsertRandomStatusTicket';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomStatusTicket: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTypeFlight
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameType NVARCHAR(100);

    -- Tablas temporales para tipos de vuelos comunes
    DECLARE @NameTypes TABLE (NameType NVARCHAR(100));

    -- Insertar tipos de vuelos comunes
    INSERT INTO @NameTypes (NameType)
    VALUES ('Domestic'), ('International'), ('Charter'), ('Cargo'), ('Private');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de vuelo aleatorio
        SELECT TOP 1 @RandomNameType = NameType FROM @NameTypes ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Type_Flight (id, name_type)
        VALUES (@i, @RandomNameType);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTypeFlight;

    PRINT 'CORRECTO: InsertRandomTypeFlight';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTypeFlight: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomStatusFlight
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomStatusName NVARCHAR(100);

    -- Tablas temporales para estados de vuelo comunes
    DECLARE @StatusNames TABLE (StatusName NVARCHAR(100));

    -- Insertar estados de vuelo comunes
    INSERT INTO @StatusNames (StatusName)
    VALUES ('Scheduled'), ('Delayed'), ('Cancelled'), ('Boarding'), ('Departed'), ('Arrived');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un estado de vuelo aleatorio
        SELECT TOP 1 @RandomStatusName = StatusName FROM @StatusNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Status_Flight (id, status_name)
        VALUES (@i, @RandomStatusName);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomStatusFlight;

    PRINT 'CORRECTO: InsertRandomStatusFlight';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomStatusFlight: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomStatusFT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDescriptionStatus NVARCHAR(100);

    -- Tablas temporales para descripciones de estado comunes
    DECLARE @DescriptionStatuses TABLE (DescriptionStatus NVARCHAR(100));

    -- Insertar descripciones de estado comunes
    INSERT INTO @DescriptionStatuses (DescriptionStatus)
    VALUES ('Available'), ('Cancelled'), ('Check-In'), ('Boarding'), ('In-Flight'), ('Landed');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar una descripción de estado aleatoria
        SELECT TOP 1 @RandomDescriptionStatus = DescriptionStatus FROM @DescriptionStatuses ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Status_FT (id, description_Status)
        VALUES (@i, @RandomDescriptionStatus);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomStatusFT;

    PRINT 'CORRECTO: InsertRandomStatusFT';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomStatusFT: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCompensationDetail
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCompensationType NVARCHAR(100);
    DECLARE @RandomCompensationAmount NVARCHAR(100);
    DECLARE @RandomIssueBy BIGINT;
    DECLARE @RandomIssueDate DATE;
    DECLARE @RandomExpirationDate DATE;

    -- Tablas temporales para tipos de compensación comunes
    DECLARE @CompensationTypes TABLE (CompensationType NVARCHAR(100));

    -- Insertar tipos de compensación comunes
    INSERT INTO @CompensationTypes (CompensationType)
    VALUES ('Refund'), ('Voucher'), ('Discount'), ('Upgrade'), ('Miles');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de compensación aleatorio
        SELECT TOP 1 @RandomCompensationType = CompensationType FROM @CompensationTypes ORDER BY NEWID();

        -- Generar una cantidad de compensación aleatoria
        SET @RandomCompensationAmount = CAST(ABS(CHECKSUM(NEWID())) % 1000 AS NVARCHAR(100)) + '.00';

        -- Generar un ID de emisor aleatorio
        SET @RandomIssueBy = ABS(CHECKSUM(NEWID())) % 100 + 1;

        -- Generar fechas aleatorias
        SET @RandomIssueDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());
        SET @RandomExpirationDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365 + 365, @RandomIssueDate);

        -- Insertar el registro en la tabla
        INSERT INTO Compensation_Detail (id, compensation_type, compensation_amount, issue_by, issue_date, expiration_date)
        VALUES (@i, @RandomCompensationType, @RandomCompensationAmount, @RandomIssueBy, @RandomIssueDate, @RandomExpirationDate);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCompensationDetail;

    PRINT 'CORRECTO: InsertRandomCompensationDetail';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCompensationDetail: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomGateStatus
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomStatusName NVARCHAR(100);

    -- Tablas temporales para estados de puerta comunes
    DECLARE @StatusNames TABLE (StatusName NVARCHAR(100));

    -- Insertar estados de puerta comunes
    INSERT INTO @StatusNames (StatusName)
    VALUES ('Open'), ('Closed'), ('Boarding'), ('Maintenance'), ('Delayed');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un estado de puerta aleatorio
        SELECT TOP 1 @RandomStatusName = StatusName FROM @StatusNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Gate_Status (id, status_name)
        VALUES (@i, @RandomStatusName);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomGateStatus;

    PRINT 'CORRECTO: InsertRandomGateStatus';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomGateStatus: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCurrency
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomName NVARCHAR(50);
    DECLARE @RandomExchangeRate DECIMAL(10, 4);

    -- Tablas temporales para nombres de monedas comunes
    DECLARE @CurrencyNames TABLE (Name NVARCHAR(50));

    -- Insertar nombres de monedas comunes
    INSERT INTO @CurrencyNames (Name)
    VALUES ('USD'), ('EUR'), ('JPY'), ('GBP'), ('AUD');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre de moneda aleatorio
        SELECT TOP 1 @RandomName = Name FROM @CurrencyNames ORDER BY NEWID();

        -- Generar una tasa de cambio aleatoria
        SET @RandomExchangeRate = CAST(ABS(CHECKSUM(NEWID())) % 10000 AS DECIMAL(10, 4)) / 100;

        -- Insertar el registro en la tabla
        INSERT INTO Currency (id, name, exchange_rate)
        VALUES (@i, @RandomName, @RandomExchangeRate);

        SET @i = @i + 1;
    END
END
GO



BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCurrency;

    PRINT 'CORRECTO: InsertRandomCurrency';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCurrency: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomBookingStatus
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameStatus NVARCHAR(100);

    -- Tablas temporales para estados de reserva comunes
    DECLARE @StatusNames TABLE (NameStatus NVARCHAR(100));

    -- Insertar estados de reserva comunes
    INSERT INTO @StatusNames (NameStatus)
    VALUES ('Confirmed'), ('Pending'), ('Cancelled'), ('Checked-In'), ('Completed');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un estado de reserva aleatorio
        SELECT TOP 1 @RandomNameStatus = NameStatus FROM @StatusNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Booking_Status (id, name_status)
        VALUES (@i, @RandomNameStatus);

        SET @i = @i + 1;
    END
END
GO



BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomBookingStatus;

    PRINT 'CORRECTO: InsertRandomBookingStatus';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomBookingStatus: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTicketCategory
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCategoryName NVARCHAR(100);

    -- Tablas temporales para categorías de tickets comunes
    DECLARE @CategoryNames TABLE (CategoryName NVARCHAR(100));

    -- Insertar categorías de tickets comunes
    INSERT INTO @CategoryNames (CategoryName)
    VALUES ('Economy'), ('Business'), ('First Class'), ('Premium Economy'), ('Standby');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar una categoría de ticket aleatoria
        SELECT TOP 1 @RandomCategoryName = CategoryName FROM @CategoryNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Ticket_Category (id, category_name)
        VALUES (@i, @RandomCategoryName);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTicketCategory;

    PRINT 'CORRECTO: InsertRandomTicketCategory';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTicketCategory: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPenaltyCancellation
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCancellationType NVARCHAR(100);
    DECLARE @RandomAmount BIGINT;

    -- Tablas temporales para tipos de cancelación comunes
    DECLARE @CancellationTypes TABLE (CancellationType NVARCHAR(100));

    -- Insertar tipos de cancelación comunes
    INSERT INTO @CancellationTypes (CancellationType)
    VALUES ('No Show'), ('Late Cancellation'), ('Change Fee'), ('Refund Fee'), ('Rebooking Fee');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de cancelación aleatoria
        SELECT TOP 1 @RandomCancellationType = CancellationType FROM @CancellationTypes ORDER BY NEWID();

        -- Generar una cantidad aleatoria
        SET @RandomAmount = ABS(CHECKSUM(NEWID())) % 500 + 50;

        -- Insertar el registro en la tabla
        INSERT INTO Penalty_Cancellation (id, cancellation_type, amount)
        VALUES (@i, @RandomCancellationType, @RandomAmount);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPenaltyCancellation;

    PRINT 'CORRECTO: InsertRandomPenaltyCancellation';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPenaltyCancellation: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCategory
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCategoryName NVARCHAR(100);
    DECLARE @RandomDescription NVARCHAR(255);

    -- Tablas temporales para categorías comunes
    DECLARE @CategoryNames TABLE (CategoryName NVARCHAR(100));
    DECLARE @Descriptions TABLE (Description NVARCHAR(255));

    -- Insertar categorías comunes
    INSERT INTO @CategoryNames (CategoryName)
    VALUES ('VIP'), ('Regular'), ('Discount'), ('Group'), ('Corporate');

    -- Insertar descripciones comunes
    INSERT INTO @Descriptions (Description)
    VALUES ('Very Important Person'), ('Standard category'), ('Discounted tickets'), ('Group booking'), ('Corporate clients');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar una categoría y descripción aleatoria
        SELECT TOP 1 @RandomCategoryName = CategoryName FROM @CategoryNames ORDER BY NEWID();
        SELECT TOP 1 @RandomDescription = Description FROM @Descriptions ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Category (id, category_name, description_category)
        VALUES (@i, @RandomCategoryName, @RandomDescription);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCategory;

    PRINT 'CORRECTO: InsertRandomCategory';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCategory: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPaymentStatus
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameStatus NVARCHAR(100);

    -- Tablas temporales para estados de pago comunes
    DECLARE @StatusNames TABLE (NameStatus NVARCHAR(100));

    -- Insertar estados de pago comunes
    INSERT INTO @StatusNames (NameStatus)
    VALUES ('Paid'), ('Pending'), ('Failed'), ('Refunded'), ('Cancelled');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un estado de pago aleatorio
        SELECT TOP 1 @RandomNameStatus = NameStatus FROM @StatusNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Paymnet_Status (id, name_status)
        VALUES (@i, @RandomNameStatus);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPaymentStatus;

    PRINT 'CORRECTO: InsertRandomPaymentStatus';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPaymentStatus: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomRolTripulante
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameRol NVARCHAR(100);

    -- Tablas temporales para roles de tripulantes comunes
    DECLARE @RolNames TABLE (NameRol NVARCHAR(100));

    -- Insertar roles de tripulantes comunes
    INSERT INTO @RolNames (NameRol)
    VALUES ('Pilot'), ('Co-Pilot'), ('Flight Attendant'), ('Engineer'), ('Ground Staff');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un rol de tripulante aleatorio
        SELECT TOP 1 @RandomNameRol = NameRol FROM @RolNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Rol_Tripulante (id, name_rol)
        VALUES (@i, @RandomNameRol);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomRolTripulante;

    PRINT 'CORRECTO: InsertRandomRolTripulante';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomRolTripulante: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTypeDocument
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameDocument NVARCHAR(100);

    -- Tablas temporales para tipos de documentos comunes
    DECLARE @DocumentNames TABLE (NameDocument NVARCHAR(100));

    -- Insertar tipos de documentos comunes
    INSERT INTO @DocumentNames (NameDocument)
    VALUES ('Passport'), ('ID Card'), ('Driver License'), ('Visa'), ('Boarding Pass');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tipo de documento aleatorio
        SELECT TOP 1 @RandomNameDocument = NameDocument FROM @DocumentNames ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Type_Document (id, name_document)
        VALUES (@i, @RandomNameDocument);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTypeDocument;

    PRINT 'CORRECTO: InsertRandomTypeDocument';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTypeDocument: ' + ERROR_MESSAGE();
END CATCH

GO


CREATE PROCEDURE InsertRandomCategoryAssignment
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAssignmentDate DATE;
    DECLARE @RandomCategoryID BIGINT;
    DECLARE @RandomCustomerID BIGINT;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomAssignmentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Generar IDs aleatorios para categoría y cliente
        SET @RandomCategoryID = ABS(CHECKSUM(NEWID())) % 50 + 1;
        SET @RandomCustomerID = ABS(CHECKSUM(NEWID())) % 50 + 1;

        -- Insertar el registro en la tabla
        INSERT INTO Category_Assignment (id, assignment_date, category_id, customer_id)
        VALUES (@i, @RandomAssignmentDate, @RandomCategoryID, @RandomCustomerID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCategoryAssignment;

    PRINT 'CORRECTO: InsertRandomCategoryAssignment';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCategoryAssignment: ' + ERROR_MESSAGE();
END CATCH

GO

CREATE PROCEDURE InsertRandomFrequentFlyerCard
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomMiles BIGINT;
    DECLARE @RandomMealCode BIGINT;
    DECLARE @RandomCustomerID BIGINT;

    -- Obtener todos los IDs de clientes válidos
    DECLARE @CustomerIDs TABLE (CustomerID BIGINT);
    INSERT INTO @CustomerIDs (CustomerID)
    SELECT id FROM Customer;

    WHILE @i <= 50
    BEGIN
        -- Generar millas y código de comida aleatorios
        SET @RandomMiles = ABS(CHECKSUM(NEWID())) % 100000 + 1000;
        SET @RandomMealCode = ABS(CHECKSUM(NEWID())) % 10 + 1;

        -- Seleccionar un ID de cliente aleatorio de los IDs válidos
        SELECT TOP 1 @RandomCustomerID = CustomerID FROM @CustomerIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Frequent_Flyer_Card (id, milles, Meal_code, customer_id)
        VALUES (@i, @RandomMiles, @RandomMealCode, @RandomCustomerID);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomFrequentFlyerCard;

    PRINT 'CORRECTO: InsertRandomFrequentFlyerCard';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomFrequentFlyerCard: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomGateAssignmentStatus
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDateAssignment DATE;
    DECLARE @RandomGateStatusID BIGINT;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomDateAssignment = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Generar un ID de estado de puerta aleatorio
        SET @RandomGateStatusID = ABS(CHECKSUM(NEWID())) % 50 + 1;

        -- Insertar el registro en la tabla
        INSERT INTO Gate_Assignment_Status (id, date_Assignment, Gate_Status_id)
        VALUES (@i, @RandomDateAssignment, @RandomGateStatusID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomGateAssignmentStatus;

    PRINT 'CORRECTO: InsertRandomGateAssignmentStatus';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomGateAssignmentStatus: ' + ERROR_MESSAGE();
END CATCH

GO

CREATE PROCEDURE InsertRandomBoardingPass
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomBoardingPassDate DATETIME;
    DECLARE @RandomBoardingTime DATETIME;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha y hora de pase de abordar aleatoria
        SET @RandomBoardingPassDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());
        SET @RandomBoardingTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, @RandomBoardingPassDate);

        -- Insertar el registro en la tabla
        INSERT INTO Boarding_Pass (id, boarding_pass_date, boarding_time)
        VALUES (@i, @RandomBoardingPassDate, @RandomBoardingTime);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomBoardingPass;

    PRINT 'CORRECTO: InsertRandomBoardingPass';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomBoardingPass: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCheckIn
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCheckInTime DATETIME;
    DECLARE @RandomBoardingPassID BIGINT;

    -- Obtener todos los IDs de pases de abordar válidos
    DECLARE @BoardingPassIDs TABLE (BoardingPassID BIGINT);
    INSERT INTO @BoardingPassIDs (BoardingPassID)
    SELECT id FROM Boarding_Pass;

    WHILE @i <= 50
    BEGIN
        -- Generar una hora de check-in aleatoria
        SET @RandomCheckInTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, GETDATE());

        -- Seleccionar un ID de pase de abordar aleatorio de los IDs válidos
        SELECT TOP 1 @RandomBoardingPassID = BoardingPassID FROM @BoardingPassIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Check_In (id, check_in_time, boarding_pass_id)
        VALUES (@i, @RandomCheckInTime, @RandomBoardingPassID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCheckIn;

    PRINT 'CORRECTO: InsertRandomCheckIn';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCheckIn: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomRequestAssistance
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomRequestDate DATE;
    DECLARE @RandomAssistanceType NVARCHAR(100);
    DECLARE @RandomDescription NVARCHAR(255);
    DECLARE @RandomStatus NVARCHAR(100);
    DECLARE @RandomCheckInID BIGINT;

    -- Tablas temporales para tipos de asistencia y estados comunes
    DECLARE @AssistanceTypes TABLE (AssistanceType NVARCHAR(100));
    DECLARE @Statuses TABLE (Status NVARCHAR(100));

    -- Insertar tipos de asistencia comunes
    INSERT INTO @AssistanceTypes (AssistanceType)
    VALUES ('Wheelchair'), ('Medical'), ('Language Assistance'), ('Special Meal'), ('Other');

    -- Insertar estados comunes
    INSERT INTO @Statuses (Status)
    VALUES ('Requested'), ('In Progress'), ('Completed'), ('Cancelled');

    -- Obtener todos los IDs de check-in válidos
    DECLARE @CheckInIDs TABLE (CheckInID BIGINT);
    INSERT INTO @CheckInIDs (CheckInID)
    SELECT id FROM Check_In;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de solicitud aleatoria
        SET @RandomRequestDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar un tipo de asistencia y estado aleatorio
        SELECT TOP 1 @RandomAssistanceType = AssistanceType FROM @AssistanceTypes ORDER BY NEWID();
        SELECT TOP 1 @RandomStatus = Status FROM @Statuses ORDER BY NEWID();

        -- Generar una descripción aleatoria
        SET @RandomDescription = 'Description ' + CAST(@i AS NVARCHAR(255));

        -- Seleccionar un ID de check-in aleatorio de los IDs válidos
        SELECT TOP 1 @RandomCheckInID = CheckInID FROM @CheckInIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Request_Assistance (id, request_date, assistance_type, description, Status, check_in_id)
        VALUES (@i, @RandomRequestDate, @RandomAssistanceType, @RandomDescription, @RandomStatus, @RandomCheckInID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomRequestAssistance;

    PRINT 'CORRECTO: InsertRandomRequestAssistance';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomRequestAssistance: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomAirline
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomName NVARCHAR(100);
    DECLARE @RandomCodeIATA BIGINT;

    -- Tablas temporales para nombres de aerolíneas comunes
    DECLARE @AirlineNames TABLE (Name NVARCHAR(100));

    -- Insertar nombres de aerolíneas comunes
    INSERT INTO @AirlineNames (Name)
    VALUES ('American Airlines'), ('Delta Air Lines'), ('United Airlines'), ('Southwest Airlines'), ('JetBlue Airways');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre de aerolínea aleatorio
        SELECT TOP 1 @RandomName = Name FROM @AirlineNames ORDER BY NEWID();

        -- Generar un código IATA aleatorio
        SET @RandomCodeIATA = ABS(CHECKSUM(NEWID())) % 1000;

        -- Insertar el registro en la tabla
        INSERT INTO Airline (id, name, code_iata)
        VALUES (@i, @RandomName, @RandomCodeIATA);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomAirline;

    PRINT 'CORRECTO: InsertRandomAirline';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomAirline: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomAirport
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNameAirport NVARCHAR(100);
    DECLARE @RandomCityID BIGINT;

    -- Tablas temporales para nombres de aeropuertos comunes
    DECLARE @AirportNames TABLE (NameAirport NVARCHAR(100));

    -- Insertar nombres de aeropuertos comunes
    INSERT INTO @AirportNames (NameAirport)
    VALUES ('John F. Kennedy International Airport'), ('Los Angeles International Airport'), ('Chicago Hare International Airport'), ('Dallas/Fort Worth International Airport'), ('Denver International Airport');

 
    DECLARE @CityIDs TABLE (CityID BIGINT);
    INSERT INTO @CityIDs (CityID)
    SELECT id FROM City;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre de aeropuerto aleatorio
        SELECT TOP 1 @RandomNameAirport = NameAirport FROM @AirportNames ORDER BY NEWID();

        -- Seleccionar un ID de ciudad aleatorio de los IDs válidos
        SELECT TOP 1 @RandomCityID = CityID FROM @CityIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Airport (id, name_airport, city_id)
        VALUES (@i, @RandomNameAirport, @RandomCityID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomAirport;

    PRINT 'CORRECTO: InsertRandomAirport';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomAirport: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomFlightNumber
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDepartureTime DATETIME;
    DECLARE @RandomDescriptionFlight NVARCHAR(100);
    DECLARE @RandomAirportStartID BIGINT;
    DECLARE @RandomAirportGoalID BIGINT;
    DECLARE @RandomAirlineID BIGINT;

    -- Tablas temporales para descripciones de vuelos comunes
    DECLARE @FlightDescriptions TABLE (DescriptionFlight NVARCHAR(100));

    -- Insertar descripciones de vuelos comunes
    INSERT INTO @FlightDescriptions (DescriptionFlight)
    VALUES ('Flight to New York'), ('Flight to Los Angeles'), ('Flight to Chicago'), ('Flight to Dallas'), ('Flight to Denver');

    -- Obtener todos los IDs de aeropuertos y aerolíneas válidos
    DECLARE @AirportIDs TABLE (AirportID BIGINT);
    DECLARE @AirlineIDs TABLE (AirlineID BIGINT);
    INSERT INTO @AirportIDs (AirportID)
    SELECT id FROM Airport;
    INSERT INTO @AirlineIDs (AirlineID)
    SELECT id FROM Airline;

    WHILE @i <= 50
    BEGIN
        -- Generar una hora de salida aleatoria
        SET @RandomDepartureTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, GETDATE());

        -- Seleccionar una descripción de vuelo aleatoria
        SELECT TOP 1 @RandomDescriptionFlight = DescriptionFlight FROM @FlightDescriptions ORDER BY NEWID();

        -- Seleccionar IDs de aeropuertos y aerolíneas aleatorios de los IDs válidos
        SELECT TOP 1 @RandomAirportStartID = AirportID FROM @AirportIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomAirportGoalID = AirportID FROM @AirportIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomAirlineID = AirlineID FROM @AirlineIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Flight_Number (id, departure_time, description_flight, airport_start_id, airport_goal_id, airline_id)
        VALUES (@i, @RandomDepartureTime, @RandomDescriptionFlight, @RandomAirportStartID, @RandomAirportGoalID, @RandomAirlineID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomFlightNumber;

    PRINT 'CORRECTO: InsertRandomFlightNumber';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomFlightNumber: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomFlight
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomBoardingTime DATETIME;
    DECLARE @RandomFlightDate DATE;
    DECLARE @RandomGate NVARCHAR(100);
    DECLARE @RandomCheckInCounter BIGINT;
    DECLARE @RandomTypeFlightID BIGINT;
    DECLARE @RandomStatusFlightID BIGINT;
    DECLARE @RandomFlightNumberID BIGINT;

    -- Tablas temporales para nombres de puertas comunes
    DECLARE @GateNames TABLE (Gate NVARCHAR(100));

    -- Insertar nombres de puertas comunes
    INSERT INTO @GateNames (Gate)
    VALUES ('A1'), ('B2'), ('C3'), ('D4'), ('E5');

    -- Obtener todos los IDs de vuelos, tipos de vuelo y estados de vuelo válidos
    DECLARE @FlightNumberIDs TABLE (FlightNumberID BIGINT);
    DECLARE @TypeFlightIDs TABLE (TypeFlightID BIGINT);
    DECLARE @StatusFlightIDs TABLE (StatusFlightID BIGINT);
    INSERT INTO @FlightNumberIDs (FlightNumberID)
    SELECT id FROM Flight_Number;
    INSERT INTO @TypeFlightIDs (TypeFlightID)
    SELECT id FROM Type_Flight;
    INSERT INTO @StatusFlightIDs (StatusFlightID)
    SELECT id FROM Status_Flight;

    WHILE @i <= 50
    BEGIN
        -- Generar una hora de embarque y fecha de vuelo aleatorias
        SET @RandomBoardingTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, GETDATE());
        SET @RandomFlightDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar un nombre de puerta aleatorio
        SELECT TOP 1 @RandomGate = Gate FROM @GateNames ORDER BY NEWID();

        -- Generar un número de mostrador de check-in aleatorio
        SET @RandomCheckInCounter = ABS(CHECKSUM(NEWID())) % 100 + 1;

        -- Seleccionar IDs de vuelo, tipo de vuelo y estado de vuelo aleatorios de los IDs válidos
        SELECT TOP 1 @RandomFlightNumberID = FlightNumberID FROM @FlightNumberIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomTypeFlightID = TypeFlightID FROM @TypeFlightIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomStatusFlightID = StatusFlightID FROM @StatusFlightIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Flight (id, boarding_time, flight_date, gate, check_in_counter, type_flight_id, status_flight_id, flight_number_id)
        VALUES (@i, @RandomBoardingTime, @RandomFlightDate, @RandomGate, @RandomCheckInCounter, @RandomTypeFlightID, @RandomStatusFlightID, @RandomFlightNumberID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomFlight;

    PRINT 'CORRECTO: InsertRandomFlight';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomFlight: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPlaneModel
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDescription NVARCHAR(100);
    DECLARE @RandomGraphic NVARCHAR(100);

    -- Tablas temporales para descripciones y gráficos comunes de modelos de avión
    DECLARE @PlaneModelDescriptions TABLE (Description NVARCHAR(100), Graphic NVARCHAR(100));

    -- Insertar descripciones y gráficos comunes
    INSERT INTO @PlaneModelDescriptions (Description, Graphic)
    VALUES ('Boeing 737', '737.png'), ('Airbus A320', 'A320.png'), ('Boeing 787', '787.png'), ('Airbus A380', 'A380.png'), ('Embraer E190', 'E190.png');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar una descripción y gráfico aleatorio
        SELECT TOP 1 @RandomDescription = Description, @RandomGraphic = Graphic FROM @PlaneModelDescriptions ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Plane_Model (id, description, graphic)
        VALUES (@i, @RandomDescription, @RandomGraphic);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPlaneModel;

    PRINT 'CORRECTO: InsertRandomPlaneModel';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPlaneModel: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomAirplane
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomRegistrationNumber BIGINT;
    DECLARE @RandomStatus NVARCHAR(100);
    DECLARE @RandomPlaneModelID BIGINT;

    -- Tablas temporales para estados comunes de aviones
    DECLARE @AirplaneStatuses TABLE (Status NVARCHAR(100));

    -- Insertar estados comunes
    INSERT INTO @AirplaneStatuses (Status)
    VALUES ('Active'), ('Maintenance'), ('Retired'), ('Stored');

    -- Obtener todos los IDs de modelos de avión válidos
    DECLARE @PlaneModelIDs TABLE (PlaneModelID BIGINT);
    INSERT INTO @PlaneModelIDs (PlaneModelID)
    SELECT id FROM Plane_Model;

    WHILE @i <= 50
    BEGIN
        -- Generar un número de registro aleatorio
        SET @RandomRegistrationNumber = ABS(CHECKSUM(NEWID())) % 100000 + 1000;

        -- Seleccionar un estado aleatorio
        SELECT TOP 1 @RandomStatus = Status FROM @AirplaneStatuses ORDER BY NEWID();

        -- Seleccionar un ID de modelo de avión aleatorio de los IDs válidos
        SELECT TOP 1 @RandomPlaneModelID = PlaneModelID FROM @PlaneModelIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Airplane (id, registration_number, Status, plane_model_id)
        VALUES (@i, @RandomRegistrationNumber, @RandomStatus, @RandomPlaneModelID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomAirplane;

    PRINT 'CORRECTO: InsertRandomAirplane';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomAirplane: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomStopovers
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomStopoverOrder NVARCHAR(255);
    DECLARE @RandomStopoverArrivalTime DATETIME;
    DECLARE @RandomStopoverDepartureTime DATETIME;
    DECLARE @RandomAirlineID BIGINT;
    DECLARE @RandomFlightNumberID BIGINT;
    DECLARE @RandomFlightID BIGINT;
    DECLARE @RandomAirportStartID BIGINT;
    DECLARE @RandomAirportGoalID BIGINT;

    -- Tablas temporales para órdenes de escala comunes
    DECLARE @StopoverOrders TABLE (StopoverOrder NVARCHAR(255));

    -- Insertar órdenes de escala comunes
    INSERT INTO @StopoverOrders (StopoverOrder)
    VALUES ('First Stop'), ('Second Stop'), ('Third Stop'), ('Fourth Stop'), ('Final Stop');

    -- Obtener todos los IDs válidos de aerolíneas, vuelos, números de vuelo y aeropuertos
    DECLARE @AirlineIDs TABLE (AirlineID BIGINT);
    DECLARE @FlightNumberIDs TABLE (FlightNumberID BIGINT);
    DECLARE @FlightIDs TABLE (FlightID BIGINT);
    DECLARE @AirportIDs TABLE (AirportID BIGINT);
    INSERT INTO @AirlineIDs (AirlineID)
    SELECT id FROM Airline;
    INSERT INTO @FlightNumberIDs (FlightNumberID)
    SELECT id FROM Flight_Number;
    INSERT INTO @FlightIDs (FlightID)
    SELECT id FROM Flight;
    INSERT INTO @AirportIDs (AirportID)
    SELECT id FROM Airport;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar una orden de escala aleatoria
        SELECT TOP 1 @RandomStopoverOrder = StopoverOrder FROM @StopoverOrders ORDER BY NEWID();

        -- Generar tiempos de llegada y salida aleatorios
        SET @RandomStopoverArrivalTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, GETDATE());
        SET @RandomStopoverDepartureTime = DATEADD(MINUTE, ABS(CHECKSUM(NEWID())) % 1440, @RandomStopoverArrivalTime);

        -- Seleccionar IDs aleatorios de aerolíneas, vuelos, números de vuelo y aeropuertos
        SELECT TOP 1 @RandomAirlineID = AirlineID FROM @AirlineIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomFlightNumberID = FlightNumberID FROM @FlightNumberIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomFlightID = FlightID FROM @FlightIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomAirportStartID = AirportID FROM @AirportIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomAirportGoalID = AirportID FROM @AirportIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Stopovers (id, stopover_order, stopover_arrival_time, stopover_departure_time, airline_id, flight_number_id, flight_id, aiport_start_id, aiport_goal_id)
        VALUES (@i, @RandomStopoverOrder, @RandomStopoverArrivalTime, @RandomStopoverDepartureTime, @RandomAirlineID, @RandomFlightNumberID, @RandomFlightID, @RandomAirportStartID, @RandomAirportGoalID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomStopovers;

    PRINT 'CORRECTO: InsertRandomStopovers';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomStopovers: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomBooking
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomBookingDate DATE;
    DECLARE @RandomCustomerID BIGINT;
    DECLARE @RandomBookingStatusID BIGINT;
    DECLARE @RandomFlightID BIGINT;

    -- Obtener todos los IDs válidos de clientes, estados de reserva y vuelos
    DECLARE @CustomerIDs TABLE (CustomerID BIGINT);
    DECLARE @BookingStatusIDs TABLE (BookingStatusID BIGINT);
    DECLARE @FlightIDs TABLE (FlightID BIGINT);
    INSERT INTO @CustomerIDs (CustomerID)
    SELECT id FROM Customer;
    INSERT INTO @BookingStatusIDs (BookingStatusID)
    SELECT id FROM Booking_Status;
    INSERT INTO @FlightIDs (FlightID)
    SELECT id FROM Flight;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de reserva aleatoria
        SET @RandomBookingDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de clientes, estados de reserva y vuelos
        SELECT TOP 1 @RandomCustomerID = CustomerID FROM @CustomerIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomBookingStatusID = BookingStatusID FROM @BookingStatusIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomFlightID = FlightID FROM @FlightIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Booking (id, booking_date, customer_id, booking_status_id, flight_id)
        VALUES (@i, @RandomBookingDate, @RandomCustomerID, @RandomBookingStatusID, @RandomFlightID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomBooking;

    PRINT 'CORRECTO: InsertRandomBooking';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomBooking: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomGate
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomName NVARCHAR(100);
    DECLARE @RandomLocation NVARCHAR(100);
    DECLARE @RandomGateAssignmentStatusID BIGINT;
    DECLARE @RandomAirportID BIGINT;

    -- Tablas temporales para nombres y ubicaciones comunes de puertas
    DECLARE @GateNames TABLE (Name NVARCHAR(100));
    DECLARE @GateLocations TABLE (Location NVARCHAR(100));

    -- Insertar nombres y ubicaciones comunes
    INSERT INTO @GateNames (Name)
    VALUES ('Gate A1'), ('Gate B2'), ('Gate C3'), ('Gate D4'), ('Gate E5');
    INSERT INTO @GateLocations (Location)
    VALUES ('North Terminal'), ('South Terminal'), ('East Terminal'), ('West Terminal'), ('Central Terminal');

    -- Obtener todos los IDs válidos de estados de asignación de puertas y aeropuertos
    DECLARE @GateAssignmentStatusIDs TABLE (GateAssignmentStatusID BIGINT);
    DECLARE @AirportIDs TABLE (AirportID BIGINT);
    INSERT INTO @GateAssignmentStatusIDs (GateAssignmentStatusID)
    SELECT id FROM Gate_Assignment_Status;
    INSERT INTO @AirportIDs (AirportID)
    SELECT id FROM Airport;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre y ubicación aleatoria
        SELECT TOP 1 @RandomName = Name FROM @GateNames ORDER BY NEWID();
        SELECT TOP 1 @RandomLocation = Location FROM @GateLocations ORDER BY NEWID();

        -- Seleccionar IDs aleatorios de estados de asignación de puertas y aeropuertos
        SELECT TOP 1 @RandomGateAssignmentStatusID = GateAssignmentStatusID FROM @GateAssignmentStatusIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomAirportID = AirportID FROM @AirportIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Gate (id, name, location, gate_assignment_status_id, airport_id)
        VALUES (@i, @RandomName, @RandomLocation, @RandomGateAssignmentStatusID, @RandomAirportID);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomGate;

    PRINT 'CORRECTO: InsertRandomGate';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomGate: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomGateAssignment
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAssignmentDate DATE;
    DECLARE @RandomGateID BIGINT;
    DECLARE @RandomStopoversID BIGINT;
    DECLARE @RandomFlightID BIGINT;

    -- Obtener todos los IDs válidos de puertas, escalas y vuelos
    DECLARE @GateIDs TABLE (GateID BIGINT);
    DECLARE @StopoversIDs TABLE (StopoversID BIGINT);
    DECLARE @FlightIDs TABLE (FlightID BIGINT);
    INSERT INTO @GateIDs (GateID)
    SELECT id FROM Gate;
    INSERT INTO @StopoversIDs (StopoversID)
    SELECT id FROM Stopovers;
    INSERT INTO @FlightIDs (FlightID)
    SELECT id FROM Flight;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomAssignmentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de puertas, escalas y vuelos
        SELECT TOP 1 @RandomGateID = GateID FROM @GateIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomStopoversID = StopoversID FROM @StopoversIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomFlightID = FlightID FROM @FlightIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Gate_Assignment (id, assignment_date, gate_id, stopovers_id, flight_id)
        VALUES (@i, @RandomAssignmentDate, @RandomGateID, @RandomStopoversID, @RandomFlightID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomGateAssignment;

    PRINT 'CORRECTO: InsertRandomGateAssignment';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomGateAssignment: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomAsingnacionTripulantes
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAssignmentDate DATE;
    DECLARE @RandomRolTripulanteID BIGINT;
    DECLARE @RandomTripulanteID BIGINT;
    DECLARE @RandomGateAssignmentID BIGINT;

    -- Obtener todos los IDs válidos de roles de tripulantes, tripulantes y asignaciones de puertas
    DECLARE @RolTripulanteIDs TABLE (RolTripulanteID BIGINT);
    DECLARE @TripulanteIDs TABLE (TripulanteID BIGINT);
    DECLARE @GateAssignmentIDs TABLE (GateAssignmentID BIGINT);
    INSERT INTO @RolTripulanteIDs (RolTripulanteID)
    SELECT id FROM Rol_Tripulante;
    INSERT INTO @TripulanteIDs (TripulanteID)
    SELECT id FROM Tripulante;
    INSERT INTO @GateAssignmentIDs (GateAssignmentID)
    SELECT id FROM Gate_Assignment;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomAssignmentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de roles de tripulantes, tripulantes y asignaciones de puertas
        SELECT TOP 1 @RandomRolTripulanteID = RolTripulanteID FROM @RolTripulanteIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomTripulanteID = TripulanteID FROM @TripulanteIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomGateAssignmentID = GateAssignmentID FROM @GateAssignmentIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Asingnacion_Tripulantes (id, assignment_date, rol_tripulante_id, tripulante_id, gate_assignment_id)
        VALUES (@i, @RandomAssignmentDate, @RandomRolTripulanteID, @RandomTripulanteID, @RandomGateAssignmentID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomAsingnacionTripulantes;

    PRINT 'CORRECTO: InsertRandomAsingnacionTripulantes';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomAsingnacionTripulantes: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPasajero
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomGenero NVARCHAR(100);
    DECLARE @RandomEstadoCivil NVARCHAR(100);

    -- Tablas temporales para géneros y estados civiles comunes
    DECLARE @Generos TABLE (Genero NVARCHAR(100));
    DECLARE @EstadosCiviles TABLE (EstadoCivil NVARCHAR(100));

    -- Insertar géneros y estados civiles comunes
    INSERT INTO @Generos (Genero)
    VALUES ('Masculino'), ('Femenino'), ('Otro');
    INSERT INTO @EstadosCiviles (EstadoCivil)
    VALUES ('Soltero'), ('Casado'), ('Divorciado'), ('Viudo');

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un género y estado civil aleatorio
        SELECT TOP 1 @RandomGenero = Genero FROM @Generos ORDER BY NEWID();
        SELECT TOP 1 @RandomEstadoCivil = EstadoCivil FROM @EstadosCiviles ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Pasajero (id, genero, estado_civil)
        VALUES (@i, @RandomGenero, @RandomEstadoCivil);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPasajero;

    PRINT 'CORRECTO: InsertRandomPasajero';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPasajero: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPerson
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomFirstName NVARCHAR(100);
    DECLARE @RandomLastName NVARCHAR(100);
    DECLARE @RandomPhoneNumber NVARCHAR(100);
    DECLARE @RandomEmail NVARCHAR(100);
    DECLARE @RandomTypePersonID BIGINT;
    DECLARE @RandomPasajeroID BIGINT;
    DECLARE @RandomTripulanteID BIGINT;

    -- Tablas temporales para nombres y apellidos comunes
    DECLARE @FirstNames TABLE (FirstName NVARCHAR(100));
    DECLARE @LastNames TABLE (LastName NVARCHAR(100));

    -- Insertar nombres y apellidos comunes
    INSERT INTO @FirstNames (FirstName)
    VALUES ('John'), ('Jane'), ('Michael'), ('Emily'), ('David');
    INSERT INTO @LastNames (LastName)
    VALUES ('Smith'), ('Johnson'), ('Williams'), ('Brown'), ('Jones');

    -- Obtener todos los IDs válidos de tipos de persona, pasajeros y tripulantes
    DECLARE @TypePersonIDs TABLE (TypePersonID BIGINT);
    DECLARE @PasajeroIDs TABLE (PasajeroID BIGINT);
    DECLARE @TripulanteIDs TABLE (TripulanteID BIGINT);
    INSERT INTO @TypePersonIDs (TypePersonID)
    SELECT id FROM Type_Person;
    INSERT INTO @PasajeroIDs (PasajeroID)
    SELECT id FROM Pasajero;
    INSERT INTO @TripulanteIDs (TripulanteID)
    SELECT id FROM Tripulante;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un nombre y apellido aleatorio
        SELECT TOP 1 @RandomFirstName = FirstName FROM @FirstNames ORDER BY NEWID();
        SELECT TOP 1 @RandomLastName = LastName FROM @LastNames ORDER BY NEWID();

        -- Generar un número de teléfono y correo electrónico aleatorio
        SET @RandomPhoneNumber = CAST(ABS(CHECKSUM(NEWID())) % 1000000000 AS NVARCHAR(100));
        SET @RandomEmail = LOWER(@RandomFirstName + '.' + @RandomLastName + '@example.com');

        -- Seleccionar IDs aleatorios de tipos de persona, pasajeros y tripulantes
        SELECT TOP 1 @RandomTypePersonID = TypePersonID FROM @TypePersonIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomPasajeroID = PasajeroID FROM @PasajeroIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomTripulanteID = TripulanteID FROM @TripulanteIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Person (id, first_name, last_name, phone_number, email, type_person_id, pasajero_id, tripulante_id)
        VALUES (@i, @RandomFirstName, @RandomLastName, @RandomPhoneNumber, @RandomEmail, @RandomTypePersonID, @RandomPasajeroID, @RandomTripulanteID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPerson;

    PRINT 'CORRECTO: InsertRandomPerson';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPerson: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomDocument
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomIssueDate DATE;
    DECLARE @RandomDueDate DATE;
    DECLARE @RandomDocumentNumber BIGINT;
    DECLARE @RandomTypeDocumentID BIGINT;
    DECLARE @RandomPersonID BIGINT;
    DECLARE @RandomCountryID BIGINT;

    -- Obtener todos los IDs válidos de tipos de documento, personas y países
    DECLARE @TypeDocumentIDs TABLE (TypeDocumentID BIGINT);
    DECLARE @PersonIDs TABLE (PersonID BIGINT);
    DECLARE @CountryIDs TABLE (CountryID BIGINT);
    INSERT INTO @TypeDocumentIDs (TypeDocumentID)
    SELECT id FROM Type_Document;
    INSERT INTO @PersonIDs (PersonID)
    SELECT id FROM Person;
    INSERT INTO @CountryIDs (CountryID)
    SELECT id FROM Country;

    WHILE @i <= 50
    BEGIN
        -- Generar fechas de emisión y vencimiento aleatorias
        SET @RandomIssueDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());
        SET @RandomDueDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, @RandomIssueDate);

        -- Generar un número de documento aleatorio
        SET @RandomDocumentNumber = ABS(CHECKSUM(NEWID())) % 1000000000;

        -- Seleccionar IDs aleatorios de tipos de documento, personas y países
        SELECT TOP 1 @RandomTypeDocumentID = TypeDocumentID FROM @TypeDocumentIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomPersonID = PersonID FROM @PersonIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomCountryID = CountryID FROM @CountryIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Document (id, issue_date, due_date, document_number, type_document_id, person_id, country_id)
        VALUES (@i, @RandomIssueDate, @RandomDueDate, @RandomDocumentNumber, @RandomTypeDocumentID, @RandomPersonID, @RandomCountryID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomDocument;

    PRINT 'CORRECTO: InsertRandomDocument';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomDocument: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomDocumentPresentation
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomPresentationDate DATE;
    DECLARE @RandomCustomerID BIGINT;
    DECLARE @RandomDocumentID BIGINT;
    DECLARE @RandomBookingID BIGINT;

    -- Obtener todos los IDs válidos de clientes, documentos y reservas
    DECLARE @CustomerIDs TABLE (CustomerID BIGINT);
    DECLARE @DocumentIDs TABLE (DocumentID BIGINT);
    DECLARE @BookingIDs TABLE (BookingID BIGINT);
    INSERT INTO @CustomerIDs (CustomerID)
    SELECT id FROM Customer;
    INSERT INTO @DocumentIDs (DocumentID)
    SELECT id FROM Document;
    INSERT INTO @BookingIDs (BookingID)
    SELECT id FROM Booking;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de presentación aleatoria
        SET @RandomPresentationDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de clientes, documentos y reservas
        SELECT TOP 1 @RandomCustomerID = CustomerID FROM @CustomerIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomDocumentID = DocumentID FROM @DocumentIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomBookingID = BookingID FROM @BookingIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Document_Presentation (id, presentation_date, customer_id, document_id, booking_id)
        VALUES (@i, @RandomPresentationDate, @RandomCustomerID, @RandomDocumentID, @RandomBookingID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomDocumentPresentation;

    PRINT 'CORRECTO: InsertRandomDocumentPresentation';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomDocumentPresentation: ' + ERROR_MESSAGE();
END CATCH

GO 
CREATE PROCEDURE InsertRandomCreditCard
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCardNumber NVARCHAR(50);
    DECLARE @RandomCardholderName NVARCHAR(100);
    DECLARE @RandomExpirationDate DATE;
    DECLARE @RandomCVV NVARCHAR(50);

    WHILE @i <= 50
    BEGIN
        -- Generar datos aleatorios para la tarjeta de crédito
        SET @RandomCardNumber = CAST(ABS(CHECKSUM(NEWID())) % 10000000000000000 AS NVARCHAR(50));
        SET @RandomCardholderName = 'Cardholder ' + CAST(@i AS NVARCHAR(100));
        SET @RandomExpirationDate = DATEADD(MONTH, ABS(CHECKSUM(NEWID())) % 60, GETDATE());
        SET @RandomCVV = CAST(ABS(CHECKSUM(NEWID())) % 1000 AS NVARCHAR(50));

        -- Insertar el registro en la tabla
        INSERT INTO Credit_Card (id, card_number, cardholder_name, expiration_date, cvv)
        VALUES (@i, @RandomCardNumber, @RandomCardholderName, @RandomExpirationDate, @RandomCVV);

        SET @i = @i + 1;
    END
END
GO 

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCreditCard;

    PRINT 'CORRECTO: InsertRandomCreditCard';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCreditCard: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTransferenciaBancaria
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAccountNumber NVARCHAR(50);
    DECLARE @RandomBankNumber BIGINT;
    DECLARE @RandomIBAN BIGINT;
    DECLARE @RandomSwiftCode NVARCHAR(50);

    WHILE @i <= 50
    BEGIN
        -- Generar datos aleatorios para la transferencia bancaria
        SET @RandomAccountNumber = CAST(ABS(CHECKSUM(NEWID())) % 10000000000000000 AS NVARCHAR(50));
        SET @RandomBankNumber = ABS(CHECKSUM(NEWID())) % 100000;
        SET @RandomIBAN = ABS(CHECKSUM(NEWID())) % 10000000000000000;
        SET @RandomSwiftCode = 'SWIFT' + CAST(ABS(CHECKSUM(NEWID())) % 1000 AS NVARCHAR(50));

        -- Insertar el registro en la tabla
        INSERT INTO Transferencia_Bancaria (id, account_number, bank_numer, iban, swift_code)
        VALUES (@i, @RandomAccountNumber, @RandomBankNumber, @RandomIBAN, @RandomSwiftCode);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTransferenciaBancaria;

    PRINT 'CORRECTO: InsertRandomTransferenciaBancaria';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTransferenciaBancaria: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCash
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;

    WHILE @i <= 50
    BEGIN
        -- Insertar el registro en la tabla
        INSERT INTO Cash (id)
        VALUES (@i);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCash;

    PRINT 'CORRECTO: InsertRandomCash';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCash: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomPaymentMethod
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDescription NVARCHAR(255);
    DECLARE @RandomCreditCardID BIGINT;
    DECLARE @RandomTransferenciaBancariaID BIGINT;
    DECLARE @RandomCashID BIGINT;

    -- Obtener todos los IDs válidos de tarjetas de crédito, transferencias bancarias y efectivo
    DECLARE @CreditCardIDs TABLE (CreditCardID BIGINT);
    DECLARE @TransferenciaBancariaIDs TABLE (TransferenciaBancariaID BIGINT);
    DECLARE @CashIDs TABLE (CashID BIGINT);
    INSERT INTO @CreditCardIDs (CreditCardID)
    SELECT id FROM Credit_Card;
    INSERT INTO @TransferenciaBancariaIDs (TransferenciaBancariaID)
    SELECT id FROM Transferencia_Bancaria;
    INSERT INTO @CashIDs (CashID)
    SELECT id FROM Cash;

    WHILE @i <= 50
    BEGIN
        -- Generar una descripción aleatoria
        SET @RandomDescription = 'Payment Method ' + CAST(@i AS NVARCHAR(255));

        -- Seleccionar IDs aleatorios de tarjetas de crédito, transferencias bancarias y efectivo
        SELECT TOP 1 @RandomCreditCardID = CreditCardID FROM @CreditCardIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomTransferenciaBancariaID = TransferenciaBancariaID FROM @TransferenciaBancariaIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomCashID = CashID FROM @CashIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Payment_Method (id, description, credit_card_id, transferencia_bancaria_id, cash_id)
        VALUES (@i, @RandomDescription, @RandomCreditCardID, @RandomTransferenciaBancariaID, @RandomCashID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomPaymentMethod;

    PRINT 'CORRECTO: InsertRandomPaymentMethod';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPaymentMethod: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCurrencyAssignment
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAssignmentDate DATE;
    DECLARE @RandomCurrencyID BIGINT;
    DECLARE @RandomPaymentID BIGINT;

    -- Obtener todos los IDs válidos de monedas y pagos
    DECLARE @CurrencyIDs TABLE (CurrencyID BIGINT);
    DECLARE @PaymentIDs TABLE (PaymentID BIGINT);
    INSERT INTO @CurrencyIDs (CurrencyID)
    SELECT id FROM Currency;
    INSERT INTO @PaymentIDs (PaymentID)
    SELECT id FROM Payment;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomAssignmentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de monedas y pagos
        SELECT TOP 1 @RandomCurrencyID = CurrencyID FROM @CurrencyIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomPaymentID = PaymentID FROM @PaymentIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Currency_Assignment (id, assignment_date, currency_id, payment_id)
        VALUES (@i, @RandomAssignmentDate, @RandomCurrencyID, @RandomPaymentID);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCurrencyAssignment;

    PRINT 'CORRECTO: InsertRandomCurrencyAssignment';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCurrencyAssignment: ' + ERROR_MESSAGE();
END CATCH

GO 

CREATE PROCEDURE InsertRandomCancellationBookin
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomCancellationDate DATE;
    DECLARE @RandomCancellationReason NVARCHAR(255);
    DECLARE @RandomPenaltyCancellationID BIGINT;
    DECLARE @RandomBookingID BIGINT;
    DECLARE @MaxID BIGINT;

    -- Obtener el valor máximo actual de la clave primaria
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM Cancellation_Bookin;

    -- Tablas temporales para razones de cancelación comunes
    DECLARE @CancellationReasons TABLE (CancellationReason NVARCHAR(255));
    INSERT INTO @CancellationReasons (CancellationReason)
    VALUES ('Weather issues'), ('Personal reasons'), ('Technical problems'), ('Schedule changes');

    -- Obtener todos los IDs válidos de penalizaciones de cancelación y reservas
    DECLARE @PenaltyCancellationIDs TABLE (PenaltyCancellationID BIGINT);
    DECLARE @BookingIDs TABLE (BookingID BIGINT);
    INSERT INTO @PenaltyCancellationIDs (PenaltyCancellationID)
    SELECT id FROM Penalty_Cancellation;
    INSERT INTO @BookingIDs (BookingID)
    SELECT id FROM Booking;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de cancelación aleatoria
        SET @RandomCancellationDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar una razón de cancelación aleatoria
        SELECT TOP 1 @RandomCancellationReason = CancellationReason FROM @CancellationReasons ORDER BY NEWID();

        -- Seleccionar IDs aleatorios de penalizaciones de cancelación y reservas
        SELECT TOP 1 @RandomPenaltyCancellationID = PenaltyCancellationID FROM @PenaltyCancellationIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomBookingID = BookingID FROM @BookingIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla con un ID único
        INSERT INTO Cancellation_Bookin (id, cancellation_date, cancellation_reason, penalty_cancellation_id, booking_id)
        VALUES (@MaxID + @i, @RandomCancellationDate, @RandomCancellationReason, @RandomPenaltyCancellationID, @RandomBookingID);

        SET @i = @i + 1;
    END
END
GO



BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomCancellationBookin;

    PRINT 'CORRECTO: InsertRandomCancellationBookin';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCancellationBookin: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomTicket
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomNumber BIGINT;
    DECLARE @RandomTicketingCode BIGINT;
    DECLARE @RandomTicketCategoryID BIGINT;
    DECLARE @RandomCheckInID BIGINT;
    DECLARE @RandomBookingID BIGINT;

    -- Obtener todos los IDs válidos de categorías de tickets, check-ins y reservas
    DECLARE @TicketCategoryIDs TABLE (TicketCategoryID BIGINT);
    DECLARE @CheckInIDs TABLE (CheckInID BIGINT);
    DECLARE @BookingIDs TABLE (BookingID BIGINT);
    INSERT INTO @TicketCategoryIDs (TicketCategoryID)
    SELECT id FROM Ticket_Category;
    INSERT INTO @CheckInIDs (CheckInID)
    SELECT id FROM Check_In;
    INSERT INTO @BookingIDs (BookingID)
    SELECT id FROM Booking;

    WHILE @i <= 50
    BEGIN
        -- Generar un número de ticket y código de ticketing aleatorios
        SET @RandomNumber = ABS(CHECKSUM(NEWID())) % 1000000000;
        SET @RandomTicketingCode = ABS(CHECKSUM(NEWID())) % 1000000;

        -- Seleccionar IDs aleatorios de categorías de tickets, check-ins y reservas
        SELECT TOP 1 @RandomTicketCategoryID = TicketCategoryID FROM @TicketCategoryIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomCheckInID = CheckInID FROM @CheckInIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomBookingID = BookingID FROM @BookingIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla
        INSERT INTO Ticket (id, number, ticketing_code, ticket_category_id, check_in_id, booking_id)
        VALUES (@i, @RandomNumber, @RandomTicketingCode, @RandomTicketCategoryID, @RandomCheckInID, @RandomBookingID);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomTicket;

    PRINT 'CORRECTO: InsertRandomTicket';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomTicket: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomStatusAssignment
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomAssignmentDate DATE;
    DECLARE @RandomStatusTicketID BIGINT;
    DECLARE @RandomTicketID BIGINT;
    DECLARE @MaxID BIGINT;

    -- Obtener el valor máximo actual de la clave primaria
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM Status_Assignment;

    -- Obtener todos los IDs válidos de estados de ticket y tickets
    DECLARE @StatusTicketIDs TABLE (StatusTicketID BIGINT);
    DECLARE @TicketIDs TABLE (TicketID BIGINT);
    INSERT INTO @StatusTicketIDs (StatusTicketID)
    SELECT id FROM Status_Ticket;
    INSERT INTO @TicketIDs (TicketID)
    SELECT id FROM Ticket;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de asignación aleatoria
        SET @RandomAssignmentDate = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar IDs aleatorios de estados de ticket y tickets
        SELECT TOP 1 @RandomStatusTicketID = StatusTicketID FROM @StatusTicketIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomTicketID = TicketID FROM @TicketIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla con un ID único
        INSERT INTO Status_Assignment (id, assignment_date, status_ticket_id, ticket_id)
        VALUES (@MaxID + @i, @RandomAssignmentDate, @RandomStatusTicketID, @RandomTicketID);

        SET @i = @i + 1;
    END
END
GO


BEGIN TRANSACTION;

BEGIN TRY
    EXEC InsertRandomStatusAssignment;

    PRINT 'CORRECTO: InsertRandomStatusAssignment';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomStatusAssignment: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomSeat
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomSize NVARCHAR(255);
    DECLARE @RandomNumber BIGINT;
    DECLARE @RandomPlaneID BIGINT;
    DECLARE @MaxID BIGINT;

    -- Obtener el valor máximo actual de la clave primaria
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM Seat;

    -- Tablas temporales para tamaños comunes de asientos
    DECLARE @SeatSizes TABLE (Size NVARCHAR(255));
    INSERT INTO @SeatSizes (Size)
    VALUES ('Small'), ('Medium'), ('Large');

    -- Obtener todos los IDs válidos de modelos de avión
    DECLARE @PlaneIDs TABLE (PlaneID BIGINT);
    INSERT INTO @PlaneIDs (PlaneID)
    SELECT id FROM Plane_Model;

    WHILE @i <= 50
    BEGIN
        -- Seleccionar un tamaño de asiento aleatorio
        SELECT TOP 1 @RandomSize = Size FROM @SeatSizes ORDER BY NEWID();

        -- Generar un número de asiento aleatorio
        SET @RandomNumber = ABS(CHECKSUM(NEWID())) % 100 + 1;

        -- Seleccionar un ID de modelo de avión aleatorio
        SELECT TOP 1 @RandomPlaneID = PlaneID FROM @PlaneIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla con un ID único
        INSERT INTO Seat (id, size, number, plane_id)
        VALUES (@MaxID + @i, @RandomSize, @RandomNumber, @RandomPlaneID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomSeat;

    PRINT 'CORRECTO: InsertRandomSeat';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomSeat: ' + ERROR_MESSAGE();
END CATCH

GO
CREATE PROCEDURE InsertRandomCoupon
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @i INT = 1;
    DECLARE @RandomDateOfRedemption DATE;
    DECLARE @RandomClass NVARCHAR(100);
    DECLARE @RandomStandBy NVARCHAR(100);
    DECLARE @RandomMealCode BIGINT;
    DECLARE @RandomTicketID BIGINT;
    DECLARE @RandomFlightID BIGINT;
    DECLARE @MaxID BIGINT;

    -- Obtener el valor máximo actual de la clave primaria
    SELECT @MaxID = ISNULL(MAX(id), 0) FROM Coupon;

    -- Tablas temporales para clases y estados de stand-by comunes
    DECLARE @Classes TABLE (Class NVARCHAR(100));
    DECLARE @StandBys TABLE (StandBy NVARCHAR(100));
    INSERT INTO @Classes (Class)
    VALUES ('Economy'), ('Business'), ('First Class');
    INSERT INTO @StandBys (StandBy)
    VALUES ('Yes'), ('No');

    -- Obtener todos los IDs válidos de tickets y vuelos
    DECLARE @TicketIDs TABLE (TicketID BIGINT);
    DECLARE @FlightIDs TABLE (FlightID BIGINT);
    INSERT INTO @TicketIDs (TicketID)
    SELECT id FROM Ticket;
    INSERT INTO @FlightIDs (FlightID)
    SELECT id FROM Flight;

    WHILE @i <= 50
    BEGIN
        -- Generar una fecha de redención aleatoria
        SET @RandomDateOfRedemption = DATEADD(DAY, ABS(CHECKSUM(NEWID())) % 365, GETDATE());

        -- Seleccionar una clase y estado de stand-by aleatorio
        SELECT TOP 1 @RandomClass = Class FROM @Classes ORDER BY NEWID();
        SELECT TOP 1 @RandomStandBy = StandBy FROM @StandBys ORDER BY NEWID();

        -- Generar un código de comida aleatorio
        SET @RandomMealCode = ABS(CHECKSUM(NEWID())) % 1000;

        -- Seleccionar IDs aleatorios de tickets y vuelos
        SELECT TOP 1 @RandomTicketID = TicketID FROM @TicketIDs ORDER BY NEWID();
        SELECT TOP 1 @RandomFlightID = FlightID FROM @FlightIDs ORDER BY NEWID();

        -- Insertar el registro en la tabla con un ID único
        INSERT INTO Coupon (id, date_of_redemption, class, stand_by, meal_code, ticket_id, flight_id)
        VALUES (@MaxID + @i, @RandomDateOfRedemption, @RandomClass, @RandomStandBy, @RandomMealCode, @RandomTicketID, @RandomFlightID);

        SET @i = @i + 1;
    END
END
GO

BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomCoupon;

    PRINT 'CORRECTO: InsertRandomCoupon';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCoupon: ' + ERROR_MESSAGE();
END CATCH
GO


-- Procedimiento para insertar datos en Available_Seat
CREATE PROCEDURE InsertRandomAvailableSeat 
AS
BEGIN
    DECLARE @id BIGINT = (SELECT ISNULL(MAX(id), 0) + 1 FROM Available_Seat);
    DECLARE @status_ft_id BIGINT = (SELECT TOP 1 id FROM Status_FT ORDER BY NEWID());
    DECLARE @coupon_id BIGINT = (SELECT TOP 1 id FROM Coupon ORDER BY NEWID());
    DECLARE @flight_id BIGINT = (SELECT TOP 1 id FROM Flight ORDER BY NEWID());
    DECLARE @seat_id BIGINT = (SELECT TOP 1 id FROM Seat ORDER BY NEWID());

    INSERT INTO Available_Seat (id, status_ft_id, coupon_id, flight_id, seat_id)
    VALUES (@id, @status_ft_id, @coupon_id, @flight_id, @seat_id);
END;

GO
BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomAvailableSeat;

    PRINT 'CORRECTO: InsertRandomAvailableSeat';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomAvailableSeat: ' + ERROR_MESSAGE();
END CATCH

GO
-- Procedimiento para insertar datos en Pieces_of_Luggage 

CREATE PROCEDURE InsertRandomPiecesOfLuggage 
AS
BEGIN
    DECLARE @id BIGINT = (SELECT ISNULL(MAX(id), 0) + 1 FROM Pieces_of_Luggage);
    DECLARE @weight_of_pieces DECIMAL(5, 2) = ROUND(RAND() * 50, 2);
    DECLARE @amount_luggages BIGINT = ROUND(RAND() * 5, 0);
    DECLARE @total_rate BIGINT = ROUND(RAND() * 1000, 0);
    DECLARE @coupon_id BIGINT = (SELECT TOP 1 id FROM Coupon ORDER BY NEWID());

    INSERT INTO Pieces_of_Luggage (id, weight_of_pieces, amount_luggages, total_rate, coupon_id)
    VALUES (@id, @weight_of_pieces, @amount_luggages, @total_rate, @coupon_id);
END;

GO

BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomPiecesOfLuggage;

    PRINT 'CORRECTO: InsertRandomPiecesOfLuggage';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomPiecesOfLuggage: ' + ERROR_MESSAGE();
END CATCH
GO

-- Procedimiento para insertar datos en Check_In_Luggage
CREATE PROCEDURE InsertRandomCheckInLuggage
AS
BEGIN
    DECLARE @id BIGINT = (SELECT ISNULL(MAX(id), 0) + 1 FROM Check_In_Luggage);
    DECLARE @checking_date DATE = DATEADD(DAY, -ROUND(RAND() * 365, 0), GETDATE());
    DECLARE @status NVARCHAR(50) = 'Checked';
    DECLARE @pieces_of_luggage_id BIGINT = (SELECT TOP 1 id FROM Pieces_of_Luggage ORDER BY NEWID());

    INSERT INTO Check_In_Luggage (id, checking_date, status, pieces_of_luggage_id)
    VALUES (@id, @checking_date, @status, @pieces_of_luggage_id);
END;


GO
BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomCheckInLuggage;

    PRINT 'CORRECTO: InsertRandomCheckInLuggage';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomCheckInLuggage: ' + ERROR_MESSAGE();
END CATCH
GO

-- Procedimiento para insertar datos en Luggage
CREATE PROCEDURE InsertRandomLuggage
AS
BEGIN
    DECLARE @id BIGINT = (SELECT ISNULL(MAX(id), 0) + 1 FROM Luggage);
    DECLARE @code_luggage INT = ROUND(RAND() * 10000, 0);
    DECLARE @dimensions NVARCHAR(100) = '50x40x20';
    DECLARE @weight DECIMAL(5, 2) = ROUND(RAND() * 30, 2);
    DECLARE @pieces_of_luggage_id BIGINT = (SELECT TOP 1 id FROM Pieces_of_Luggage ORDER BY NEWID());

    INSERT INTO Luggage (id, code_luggage, dimensions, weight, pieces_of_luggage_id)
    VALUES (@id, @code_luggage, @dimensions, @weight, @pieces_of_luggage_id);
END;

GO

BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomLuggage;

    PRINT 'CORRECTO: InsertRandomLuggage';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomLuggage: ' + ERROR_MESSAGE();
END CATCH
GO

-- Procedimiento para insertar datos en Flight_Cancellation
CREATE PROCEDURE InsertRandomFlightCancellation
AS
BEGIN
    DECLARE @cancellation_time DATETIME = DATEADD(HOUR, -ROUND(RAND() * 1000, 0), GETDATE());
    DECLARE @cancellation_reason NVARCHAR(255) = 'Weather';
    DECLARE @responsible_party NVARCHAR(255) = 'Airline';
    DECLARE @flight_number BIGINT = (SELECT TOP 1 id FROM Flight_Number ORDER BY NEWID());
    DECLARE @compensation_detail BIGINT = (SELECT TOP 1 id FROM Compensation_Detail ORDER BY NEWID());

    INSERT INTO Flight_Cancellation (cancellation_time, cancellation_reason, responsible_party, flight_number, compensation_detail)
    VALUES (@cancellation_time, @cancellation_reason, @responsible_party, @flight_number, @compensation_detail);
END;

BEGIN TRANSACTION

BEGIN TRY
    EXEC InsertRandomFlightCancellation;

    PRINT 'CORRECTO: InsertRandomFlightCancellation';
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT 'Error al ejecutar los procedimientos InsertRandomFlightCancellation: ' + ERROR_MESSAGE();
END CATCH
GO
