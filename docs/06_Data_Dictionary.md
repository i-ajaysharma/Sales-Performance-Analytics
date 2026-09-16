
# Data Dictionary

## FactSales
OrderID: Unique order identifier.
OrderDate: Transaction date.
CustomerID: Customer key.
ProductID: Product key.
SalespersonID: Sales representative key.
Quantity: Units sold.
UnitPrice: Selling price per unit.
DiscountPct: Discount rate.
GrossSales: Quantity × UnitPrice.
DiscountAmount: Gross sales × discount rate.
NetSales: Gross sales after discount; returns are negative.
UnitCost: Cost per unit.
TotalCost: Quantity × UnitCost; returns are negative.
Profit: Net sales - total cost.
PaymentMethod: Payment method.
Channel: Sales channel.
Status: Completed, Returned, Cancelled.
ProfitMarginPct: Profit / NetSales.

## Dimensions
DimDate: Calendar attributes for time intelligence.
DimCustomer: Customer profile, segment and tier.
DimProduct: Product, category, subcategory, price and cost.
DimSalesperson: Salesperson and assigned region.
DimRegion: Region/city mapping.
SalesTargets: Monthly salesperson targets.
