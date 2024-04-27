create database dbms_deadline;
use dbms_deadline;

CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    Name VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    City VARCHAR(50) NOT NULL,
    Province VARCHAR(50) NOT NULL,
    PostalCode VARCHAR(10) NOT NULL
);


CREATE TABLE Products (
    ProductID INT AUTO_INCREMENT PRIMARY KEY,
    Product_Name VARCHAR(100) NOT NULL,
    Average_Price DECIMAL(10,2) NOT NULL CHECK (Average_Price > 0),
    Total_Quantity INT NOT NULL,
    Recent_date_of_expiry DATE NOT NULL
);


CREATE TABLE PlaceOrder (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,
    SupplierID INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)

);

CREATE TABLE Delivery_personals (
   License_number VARCHAR(10) NOT NULL PRIMARY KEY,
   FirstName VARCHAR(50) NOT NULL,
   LastName VARCHAR(50) NOT NULL,
   CityOfBirth VARCHAR(50) NOT NULL,
   Vehicle_number VARCHAR(10) NOT NULL
);

CREATE TABLE Customers (
  CustomerNumber INT PRIMARY KEY,
  Name VARCHAR(100) NOT NULL,
  AddressLine1 VARCHAR(100) NOT NULL, 
  AddressLine2 VARCHAR(100), 
  City varchar (100) NOT NULL, 
  StateProvince varchar (100) NOT NULL, 
  Country varchar (100) NOT NULL, 
  PostalCode varchar (20) NOT NULL,
  Login_password VARCHAR(10) NOT NULL,
  isBanned BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE Inventory (
    Inv_ID INT AUTO_INCREMENT,
    ProductID INT,
    Drug_Name VARCHAR(100) NOT NULL,
    Drug_Description VARCHAR(255),
    Quantity_on_Hand INT NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0),
    Supplier_ID INT,
    Recent_date_of_expiry DATE NOT NULL,
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    PRIMARY KEY (Inv_ID, Supplier_ID, ProductID)
);

CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Specialty VARCHAR(50),
    Age int not NULL
);


CREATE TABLE Prescription (
    Prescription_No INT AUTO_INCREMENT ,
    Date_of_Prescription DATETIME NOT NULL,
    Patient_ID INT NOT NULL,
    Doctor_ID INT NOT NULL,
    Drug_Name VARCHAR(255) NOT NULL,
    Dosage VARCHAR(255) NOT NULL,
    FOREIGN KEY (Patient_ID) REFERENCES Customers(CustomerNumber),
    FOREIGN KEY (Doctor_ID) REFERENCES Doctors(DoctorID),
    PRIMARY KEY (Prescription_No, Date_of_Prescription, Patient_ID, Doctor_ID)

);

CREATE TABLE Orders (
   OrderID INT AUTO_INCREMENT ,
    Prescription_ID INT,
    CustomerNumber INT ,
    Date_of_order DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ,
    FOREIGN KEY (Prescription_ID) REFERENCES Prescription(Prescription_No),
    FOREIGN KEY (CustomerNumber) REFERENCES Customers(CustomerNumber) ON DELETE CASCADE,
    PRIMARY KEY (OrderID, Prescription_ID, CustomerNumber, Date_of_order)
);

CREATE TABLE Ratings (
    Rating INT CHECK (Rating >= 1 AND Rating <= 5) NOT NULL ,
    OrderID INT,
    Supplier_ID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(SupplierID) ON DELETE CASCADE,
    PRIMARY KEY (Rating, OrderID, Supplier_ID)
);

CREATE TABLE Delivery_log(
    Delivery_log INT AUTO_INCREMENT,
    Supplier_ID INT,
    Delivery_personal VARCHAR(10),
    Date_of_shipment DATE,
    OrderID INT,
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID) ON DELETE CASCADE,
    FOREIGN KEY (Delivery_personal) REFERENCES Delivery_personals(License_number),
    FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(SupplierID),
    PRIMARY KEY (Delivery_log, OrderID)
);

CREATE table Login_History(
	CutomerNumberUsed int not null,
    foreign key (CutomerNumberUsed) references Customers(CustomerNumber) ,
    isSuccess bool ,
    DateTime_Attempt datetime not null default now()
);

-- Dummy entries for Suppliers
INSERT INTO Suppliers (SupplierID, Name, Address, City, Province, PostalCode)
VALUES
(1, 'Supplier A', '123 Main St', 'Metropolis', 'Metro', '12345'),
(2, 'Supplier B', '456 Elm St', 'Gotham', 'Goth', '23456'),
(3, 'Supplier C', '789 Pine St', 'Star City', 'Star', '34567'),
(4, 'Supplier D', '101 Oak St', 'Central City', 'Central', '45678'),
(5, 'Supplier E', '102 Maple St', 'National City', 'National', '56789'),
(6, 'Supplier F', '103 Ash St', 'Jump City', 'Jump', '67890'),
(7, 'Supplier G', '104 Birch St', 'Blüdhaven', 'Blud', '78901'),
(8, 'Supplier H', '105 Cedar St', 'Coast City', 'Coast', '89012'),
(9, 'Supplier I', '106 Dogwood St', 'Midway City', 'Midway', '90123'),
(10, 'Supplier J', '107 Fir St', 'Ivy Town', 'Ivy', '01234');

-- Dummy entries for Products
INSERT INTO Products (Product_Name, Average_Price, Total_Quantity, Recent_date_of_expiry)
VALUES
( 'Drug A', 10.99, 200, '2024-12-31'),
( 'Drug B', 20.99, 200, '2024-11-30'),
( 'Drug C', 30.99, 200,'2024-10-31'),
( 'Drug D', 40.99, 200,'2024-09-30'),
( 'Drug E', 50.99, 200,'2024-08-31'),
( 'Drug F', 60.99, 200,'2024-07-30'),
( 'Drug G', 70.99, 200,'2024-06-30'),
( 'Drug H', 80.99, 200,'2024-05-31'),
( 'Drug I', 90.99, 200,'2024-04-30'),
( 'Drug J', 100.99, 200,'2024-03-31');

-- Dummy entries for PlaceOrder
INSERT INTO PlaceOrder (OrderID, SupplierID)
VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10);

-- Dummy entries for Delivery_personals
INSERT INTO Delivery_personals (License_number, FirstName, LastName, CityOfBirth, Vehicle_number)
VALUES
('DL001', 'John', 'Doe', 'Metropolis', 'V001'),
('DL002', 'Jane', 'Doe', 'Gotham', 'V002'),
('DL003', 'Clark', 'Kent', 'Smallville', 'V003'),
('DL004', 'Bruce', 'Wayne', 'Gotham', 'V004'),
('DL005', 'Diana', 'Prince', 'Themyscira', 'V005'),
('DL006', 'Barry', 'Allen', 'Central City', 'V006'),
('DL007', 'Hal', 'Jordan', 'Coast City', 'V007'),
('DL008', 'Arthur', 'Curry', 'Atlantis', 'V008'),
('DL009', 'Victor', 'Stone', 'Detroit', 'V009'),
('DL010', 'Oliver', 'Queen', 'Star City', 'V010');

-- Dummy entries for Customers
INSERT INTO Customers (CustomerNumber, Name, AddressLine1, AddressLine2, City, StateProvince, Country, PostalCode, Login_password)
VALUES
(1, 'Customer 1', '123 Main St', '', 'Metropolis', 'Metro', 'USA', '12345', 'password1'),
(2, 'Customer 2', '456 Elm St', 'Apt 2', 'Gotham', 'Goth', 'USA', '23456', 'password2'),
(3, 'Customer 3', '789 Pine St', 'Suite 3', 'Star City', 'Star', 'USA', '34567', 'password3'),
(4, 'Customer 4', '101 Oak St', '', 'Central City', 'Central', 'USA', '45678', 'password4'),
(5, 'Customer 5', '102 Maple St', '', 'National City', 'National', 'USA', '56789', 'password5'),
(6, 'Customer 6', '103 Ash St', 'Apt 6', 'Jump City', 'Jump', 'USA', '67890', 'password6'),
(7, 'Customer 7', '104 Birch St', 'Suite 7', 'Blüdhaven', 'Blud', 'USA', '78901', 'password7'),
(8, 'Customer 8', '105 Cedar St', '', 'Coast City', 'Coast', 'USA', '89012', 'password8'),
(9, 'Customer 9', '106 Dogwood St', '', 'Midway City', 'Midway', 'USA', '90123' , 'password9'),
(10, 'Customer 10', '107 Fir St', 'Apt 10', 'Ivy Town', 'Ivy', 'USA', '01234', 'password10');

-- Dummy entries for Inventory
INSERT INTO Inventory (ProductID ,
    Drug_Name, Drug_Description ,
    Quantity_on_Hand, Price, Supplier_ID, Recent_date_of_expiry)
VALUES
(1, 'Drug A', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 100, 10.99, 1, '2024-12-31'),
(1, 'Drug A', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 120, 12.99, 2, '2024-12-31'),
(1, 'Drug A', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 130, 8.99, 3, '2024-12-31'),
(2, 'Drug B', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 200, 20.99, 2, '2024-11-30'),
(2, 'Drug B', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 200, 20.99, 9, '2024-11-30'),
(2, 'Drug B', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 200, 20.99, 6, '2024-11-30'),
(3, 'Drug C', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 300, 30.99, 3, '2024-10-31'),
(3, 'Drug C', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 300, 34.99, 1, '2024-10-31'),
(3, 'Drug C', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 300, 37.99, 4, '2024-10-31'),
(4, 'Drug D', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 400, 43.99, 4, '2024-09-30'),
(4, 'Drug D', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 400, 37.99, 2, '2024-09-30'),
(4, 'Drug D', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 400, 40.99, 3, '2024-09-30'),
(5, 'Drug E', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 500, 50.99, 5, '2024-08-31'),
(5, 'Drug E', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 500, 45.99, 6, '2024-08-31'),
(5, 'Drug E', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 500, 55.99, 7, '2024-08-31'),
(6, 'Drug F', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 600, 60.99, 6, '2024-07-30'),
(6, 'Drug F', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 600, 66.99, 7, '2024-07-30'),
(6, 'Drug F', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 600, 56.99, 8, '2024-07-30'),
(7, 'Drug G', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 700, 70.99, 7, '2024-06-30'),
(7, 'Drug G', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 700, 77.99, 5, '2024-06-30'),
(7, 'Drug G', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 700, 67.99, 9, '2024-06-30'),
(8, 'Drug H', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 800, 80.99, 8, '2024-05-31'),
(8, 'Drug H', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 800, 88.99, 1, '2024-05-31'),
(8, 'Drug H', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 800, 78.99, 10, '2024-05-31'),
(9, 'Drug I', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 900, 90.99, 9, '2024-04-30'),
(9, 'Drug I', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 900, 99.99, 10, '2024-04-30'),
(9, 'Drug I', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 900, 89.99, 2, '2024-04-30'),
(10, 'Drug J', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 1000, 100.99, 10, '2024-03-31'),
(10, 'Drug J', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 1000, 110.99, 1, '2024-03-31'),
(10, 'Drug J', "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", 1000, 90.99, 3, '2024-03-31');


-- Dummy entries for Doctors
INSERT INTO Doctors (DoctorID, FirstName, LastName, Specialty, Age)
VALUES
(1, 'Doctor A', 'Who', 'General', 35),
(2, 'Doctor B', 'Strange', 'Surgery', 40),
(3, 'Doctor C', 'House', 'Diagnostic', 45),
(4, 'Doctor D', 'Watson', 'General', 50),
(5, 'Doctor E', 'Octopus', 'Neurology', 55),
(6, 'Doctor F', 'Fate', 'Cardiology', 60),
(7, 'Doctor G', 'Holliday', 'Dentistry', 65),
(8, 'Doctor H', 'Banner', 'Radiology', 70),
(9, 'Doctor I', 'Xavier', 'Psychiatry', 75),
(10, 'Doctor J', 'Jekyll', 'Pharmacology', 80);

-- Dummy entries for Prescription
INSERT INTO Prescription (Prescription_No, Date_of_Prescription, Patient_ID, Doctor_ID, Drug_Name, Dosage)
VALUES
(1, '2023-01-01', 1, 1, 'Drug A', '2 pills daily'),
(2, '2023-02-01', 2, 2, 'Drug B', '1 pill daily'),
(3, '2023-03-01', 3, 3, 'Drug C', '3 pills daily'),
(4, '2023-04-01', 4, 4, 'Drug D', '2 pills daily'),
(5, '2023-05-01', 5, 5, 'Drug E', '1 pill daily'),
(6, '2023-06-01', 6, 6, 'Drug F', '3 pills daily'),
(7, '2023-07-01', 7, 7, 'Drug G', '2 pills daily'),
(8, '2023-08-01', 8, 8, 'Drug H', '1 pill daily'),
(9, '2023-09-01', 9, 9, 'Drug I', '3 pills daily'),
(10, '2023-10-01', 10, 10, 'Drug J', '2 pills daily');


-- Dummy entries for Orders
INSERT INTO Orders (OrderID, Prescription_ID, CustomerNumber)
VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5), (6, 6, 6), (7, 7, 7), (8, 8, 8), (9, 9, 9), (10, 10, 10);

-- Dummy entries for Ratings
INSERT INTO Ratings (Rating, OrderID, Supplier_ID)
VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5), (1, 6, 6), (2, 7, 7), (3, 8, 8), (4, 9, 9), (5, 10, 10);

-- Dummy entries for Delivery_log
INSERT INTO Delivery_log (Delivery_log, Supplier_ID, Delivery_personal, Date_of_shipment, OrderID)
VALUES
(1, 1, 'DL001', '2023-01-01', 1),
(2, 2, 'DL002', '2023-02-01', 2),
(3, 3, 'DL003', '2023-03-01', 3),
(4, 4, 'DL004', '2023-04-01', 4),
(5, 5, 'DL005', '2023-05-01', 5),
(6, 6, 'DL006', '2023-06-01', 6),
(7, 7, 'DL007', '2023-07-01', 7),
(8, 8, 'DL008', '2023-08-01', 8),
(9, 9, 'DL009', '2023-09-01', 9),
(10, 10, 'DL010', '2023-10-01', 10);
