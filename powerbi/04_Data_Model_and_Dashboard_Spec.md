
# Power BI Data Model

Use a star schema.

FACT
FactSales
- OrderID (key)
- OrderDate
- CustomerID
- ProductID
- SalespersonID
- Quantity
- NetSales
- Profit
- DiscountPct
- Status
- Channel

DIMENSIONS
DimDate
DimCustomer
DimProduct
DimSalesperson
DimRegion
SalesTargets

Relationships:
DimDate[Date] 1 -> * FactSales[OrderDate]
DimCustomer[CustomerID] 1 -> * FactSales[CustomerID]
DimProduct[ProductID] 1 -> * FactSales[ProductID]
DimSalesperson[SalespersonID] 1 -> * FactSales[SalespersonID]
DimRegion[RegionID] 1 -> * DimCustomer[RegionID]
DimRegion[RegionID] 1 -> * DimSalesperson[RegionID]
DimSalesperson[SalespersonID] 1 -> * SalesTargets[SalespersonID]
DimDate[Date] 1 -> * SalesTargets[MonthStart] (use a dedicated MonthStart relationship if preferred)

Recommended filter direction:
Single direction from dimensions to facts.

Dashboard pages:
1. Executive Overview
2. Sales Trend & Growth
3. Product & Category Analysis
4. Customer Analysis
5. Salesperson & Target Performance
6. Region & Channel Analysis
7. Drill-through: Customer / Product Detail

Slicers:
Year, Quarter, Month, Region, Category, Segment, Channel, Salesperson, Customer Tier.

Design principles:
- Keep 5–7 core visuals per page.
- Use KPI cards for Revenue, Profit, Margin, Orders, Customers, AOV.
- Add dynamic titles.
- Use tooltips for extra detail.
- Use drill-through for customer/product/salesperson investigation.
- Avoid 3D charts and unnecessary gauges.
