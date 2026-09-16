CREATE DATABASE IF NOT EXISTS sales_analytics;
USE sales_analytics;

DROP TABLE IF EXISTS FactSales;
DROP TABLE IF EXISTS SalesTargets;
DROP TABLE IF EXISTS DimSalesperson;
DROP TABLE IF EXISTS DimProduct;
DROP TABLE IF EXISTS DimCustomer;
DROP TABLE IF EXISTS DimRegion;
DROP TABLE IF EXISTS DimDate;

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,
    Date DATE NOT NULL,
    Year INT,
    Quarter VARCHAR(2),
    MonthNo INT,
    Month VARCHAR(20),
    MonthShort VARCHAR(3),
    YearMonth VARCHAR(7),
    WeekNo INT,
    Day INT,
    DayName VARCHAR(15),
    IsWeekend BOOLEAN
);

CREATE TABLE DimRegion (
    RegionID VARCHAR(10) PRIMARY KEY,
    Region VARCHAR(30),
    City VARCHAR(50)
);

CREATE TABLE DimCustomer (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CustomerName VARCHAR(100),
    Segment VARCHAR(30),
    RegionID VARCHAR(10),
    JoinDate DATE,
    CustomerTier VARCHAR(20),
    FOREIGN KEY (RegionID) REFERENCES DimRegion(RegionID)
);

CREATE TABLE DimProduct (
    ProductID VARCHAR(10) PRIMARY KEY,
    ProductName VARCHAR(120),
    Category VARCHAR(50),
    SubCategory VARCHAR(50),
    UnitPrice DECIMAL(12,2),
    UnitCost DECIMAL(12,2)
);

CREATE TABLE DimSalesperson (
    SalespersonID VARCHAR(10) PRIMARY KEY,
    SalespersonName VARCHAR(100),
    RegionID VARCHAR(10),
    Channel VARCHAR(40),
    FOREIGN KEY (RegionID) REFERENCES DimRegion(RegionID)
);

CREATE TABLE FactSales (
    OrderID VARCHAR(20) PRIMARY KEY,
    OrderDate DATE,
    CustomerID VARCHAR(10),
    ProductID VARCHAR(10),
    SalespersonID VARCHAR(10),
    Quantity INT,
    UnitPrice DECIMAL(12,2),
    DiscountPct DECIMAL(8,4),
    GrossSales DECIMAL(14,2),
    DiscountAmount DECIMAL(14,2),
    NetSales DECIMAL(14,2),
    UnitCost DECIMAL(12,2),
    TotalCost DECIMAL(14,2),
    Profit DECIMAL(14,2),
    PaymentMethod VARCHAR(40),
    Channel VARCHAR(40),
    Status VARCHAR(20),
    ProfitMarginPct DECIMAL(8,4),
    FOREIGN KEY (CustomerID) REFERENCES DimCustomer(CustomerID),
    FOREIGN KEY (ProductID) REFERENCES DimProduct(ProductID),
    FOREIGN KEY (SalespersonID) REFERENCES DimSalesperson(SalespersonID)
);

CREATE TABLE SalesTargets (
    MonthStart DATE,
    SalespersonID VARCHAR(10),
    SalesTarget DECIMAL(14,2),
    PRIMARY KEY (MonthStart, SalespersonID),
    FOREIGN KEY (SalespersonID) REFERENCES DimSalesperson(SalespersonID)
);
