/*
============================================================
PROYECTO: Northwind Strategic Sales & Financial Analytics
HERRAMIENTAS: MySQL, Excel, Power BI
AUTOR: Raimundo Bilbao
OBJETIVO: Transformar datos transaccionales en KPIs estratégicos.
============================================================

ÍNDICE DE DESARROLLO:

--- Módulo A: Sales & Growth Performance ---
1. Total Revenue & Monthly Growth
2. Monthly Sales Trend: Análisis de series de tiempo y estacionalidad.
3. Discount Erosion Analysis (Impacto de los descuentos en el ingreso bruto vs. neto).
4. Average Order Value (AOV) (Promedio, Min y Max por cada factura emitida).

--- Módulo B: Product & Category Insights ---
5. Top 10 Best-Selling Products (Filtrando productos descontinuados)
6. Revenue by Category: Composición y rentabilidad del catálogo.
7. Inventory Turnover: Identificación de productos de baja rotación.

--- Módulo C: Operational Efficiency, Geographic & Risk ---
8. Employee Performance (Ventas vs. Descuentos por vendedor).
9. Customer Segmentation by Revenue (Identificación de clientes clave y riesgo de concentración).
10. Shipper & Logistics Impact (Tiempo de entrega y costos por transportista)
11. Geographic Revenue Distribution (Ventas netas por ciudad y país)

--- Módulo D: Operational Efficiency ---
12. Análisis de Abastecimiento Crítico.
13. Reorder Point Analysis (Identificación de productos en riesgo de quiebre de stock).
============================================================
*/

-- INICIO DEL DESARROLLO --

/* --- Módulo A: Sales & Growth Performance ---
1. Total Net Revenue: KPI principal de éxito.
2. Monthly Sales Trend: Análisis de series de tiempo y estacionalidad.
3. Discount Erosion Analysis (Impacto de los descuentos en el ingreso bruto vs. neto).
4. Average Order Value (AOV) (Promedio, Min y Max por cada factura emitida). */

-- 1. Total Net Revenue
# Para este ejercicio crearemos una VISTA (VIEW) para obtener Ingresos Brutos, Ingresos Netos y la Diferencia.

CREATE VIEW view_sales_details AS
SELECT 
	od.id, od.order_id, od.product_id, o.employee_id, o.customer_id, od.quantity, od.unit_price,
	od.discount, p.category, o.order_date, o.shipped_date, o.paid_date,
	ROUND((COALESCE(od.quantity,0) * COALESCE(od.unit_price,0)),2) AS line_gross_revenue,    
	ROUND((COALESCE(od.quantity,0) * COALESCE(od.unit_price,0) * (1 - COALESCE(od.discount,0))),2) AS line_net_revenue
FROM order_details AS od
LEFT JOIN orders AS o
	ON od.order_id = od.view_sales_details
LEFT JOIN products AS p
	ON od.product_id = p.id;


# Seleccionamos la vista creada y respondemos la pregunta 1.
SELECT *
	-- SUM(line_net_revenue) AS Total_net_revenue
FROM view_sales_details;

-- ================================================================ -- 
-- 2. Monthly Sales Trend: Análisis de series de tiempo y estacionalidad.
# Seleccionamos la vista creada anteriormente, luego agrupamos las fechas y hacemos un conteo de las órdenes para saber el volumen de ventas por mes/año.

SELECT 
	YEAR(order_date) AS date_year,
    MONTH(order_date) AS date_month,
    COUNT(order_id) AS Order_quantity,
    COUNT(DISTINCT order_id) AS Order_quantity_distinct,
    SUM(line_net_revenue) AS Net_revenue
FROM view_sales_details
GROUP BY date_year, date_month
ORDER BY date_year, date_month;

-- ================================================================ -- 
-- 3. Discount Erosion Analysis (Impacto de los descuentos en el ingreso bruto vs. neto).
# Queremos saber cuánto debimos haber cobrado vs cuánto realmente cobramos. Luego agruparemos por mes para ver la tendencia. 

SELECT 
	YEAR(order_date) AS date_year,
    MONTH(order_date) AS date_month,
    SUM(line_gross_revenue) AS Gross_revenue,
    SUM(line_net_revenue) AS Net_revenue,
    (SUM(line_gross_revenue) - SUM(line_net_revenue)) AS Discount_amount,
    ROUND((((SUM(line_gross_revenue) - SUM(line_net_revenue)) / SUM(line_gross_revenue)) * 100),2) AS Discount_percentage
FROM view_sales_details
GROUP BY date_year, date_month;

# Ahora haremos la misma consulta pero agruparemos por categoría de productos
SELECT 
	p.category,
    SUM(vsd.line_gross_revenue) AS Gross_revenue,
    SUM(vsd.line_net_revenue) AS Net_revenue,
    (SUM(vsd.line_gross_revenue) - SUM(vsd.line_net_revenue)) AS Discount_amount,
    ROUND((((SUM(vsd.line_gross_revenue) - SUM(vsd.line_net_revenue)) / SUM(vsd.line_gross_revenue)) * 100),2) AS Discount_percentage
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON vsd.product_id = p.id
GROUP BY p.category;

-- ================================================================ -- 
-- 4. Average Order Value (AOV): Gasto promedio por factura.
# Creamos una CTE para resumir el código, esto hará que se vea un poco más limpio.

WITH cte_orders_totals AS (
SELECT
	order_id,
    YEAR(order_date) AS date_year,
    MONTH(order_date) AS date_month,
    SUM(line_net_revenue) AS Total_net_income
FROM view_sales_details
GROUP BY order_id, date_year, date_month
)

SELECT 
	date_month,
	ROUND(AVG(total_net_income),2) AS avg_net_income,
    MIN(total_net_income) AS min_net_income,
    MAX(total_net_income) AS max_net_income
FROM cte_orders_totals
GROUP BY date_month
ORDER BY date_month;

/*  ================================================================
--- Módulo B: Product & Category Insights ---
5. Top 10 Best-Selling Products (Filtrando productos descontinuados)
6. Revenue by Category: Composición y rentabilidad del catálogo.
7. Inventory Turnover: Identificación de productos de baja rotación.*/

-- 5. Top 10 Best-Selling Products (Filtrando productos descontinuados)
# Seleccionamos los 10 productos más vendidos. Consultamos con la VISTA (VIEW) creada anteriormente.

SELECT 
	p.product_name AS product,
    SUM(vsd.line_net_revenue) AS net_revenue
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON vsd.product_id = p.id
WHERE p.discontinued = 0
GROUP BY product
ORDER BY net_revenue DESC
LIMIT 10;

-- ================================================================ -- 
-- 6. Revenue by Category: Composición y rentabilidad del catálogo.
# Seleccionamos la VISTA (VIEW) creada anteriormente y la unimos con la tabla products para luego agrupar la ventas por categoría y ver la las métricas destacadas
SELECT 
	p.category,
    SUM(line_net_revenue) AS total_net_revenue,
    ROUND(SUM(vsd.quantity),0) AS total_quantity,
    CONCAT(ROUND(((SUM(line_gross_revenue) - SUM(line_net_revenue)) / SUM(line_gross_revenue)) * 100,2),' %') AS Percentage_discount
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON vsd.product_id = p.id
GROUP BY p.category;

-- ================================================================ -- 
-- 7. Inventory Turnover: Identificación de productos de baja rotación.
# Debemos saber primero cuántos productos únicos se venden por categoría
# Calculamos el ingreso promedio por producto

SELECT 
	p.category,
    SUM(line_net_revenue) AS total_net_revenue,
    ROUND(SUM(vsd.quantity),0) AS total_quantity,
    COUNT(DISTINCT p.id) AS quantity_products,
    ROUND((SUM(line_net_revenue) / COUNT(DISTINCT p.id)),2) AS total_revenue_by_products    
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON vsd.product_id = p.id
GROUP BY p.category
ORDER BY total_net_revenue DESC;

-- ================================================================ -- 
/*--- Módulo C: Operational Efficiency, Geographic & Risk ---
8. Employee Performance (Ventas vs. Descuentos por vendedor).
9. Customer Segmentation by Revenue (Identificación de clientes clave y riesgo de concentración).
10. Shipper & Logistics Impact (Tiempo de entrega y costos por transportista).
11. Geographic Revenue Distribution (Ventas netas por ciudad y país) */

-- 8. Employee Performance (Ventas vs. Descuentos por vendedor).

SELECT 
	vsd.employee_id,
	CONCAT(e.first_name, ' ', e.last_name) AS Name_employee,
    COUNT(DISTINCT vsd.order_id) AS total_orders,
	SUM(vsd.line_gross_revenue) AS total_gross_revenue,
    SUM(vsd.line_net_revenue) AS total_net_revenue,
    (SUM(vsd.line_gross_revenue) - SUM(vsd.line_net_revenue)) AS total_discount,
	ROUND((SUM(vsd.line_gross_revenue) - SUM(vsd.line_net_revenue)) / SUM(vsd.line_gross_revenue) * 100,2) AS total_discount_percentage
FROM view_sales_details AS vsd
LEFT JOIN employees AS e
	ON vsd.employee_id = e.id
GROUP BY vsd.employee_id
ORDER BY total_net_revenue DESC;
# This metric helps identify deviations from the company's pricing 
# policy and assess whether sales volume is being artificially inflated through discounts

-- ================================================================ -- 
-- 9. Customer Segmentation by Revenue (Identificación de clientes clave y riesgo de concentración).
SELECT 
    c.company,
    SUM(line_net_revenue) AS total_net_revenue,
    COUNT(DISTINCT vsd.order_id) AS total_orders,
    ROUND((SUM(line_net_revenue) / COUNT(DISTINCT vsd.order_id) ),2) AS avg_ticket,
    ROUND((SUM(vsd.line_gross_revenue) - SUM(vsd.line_net_revenue)) / SUM(vsd.line_gross_revenue) * 100,2) AS total_discount_percentage
FROM view_sales_details AS vsd
LEFT JOIN customers AS c
	ON vsd.customer_id = c.id
GROUP BY c.company
ORDER BY total_net_revenue DESC;

-- ================================================================ -- 
-- 10. Shipper & Logistics Impact (Tiempo de entrega y costos por transportista).
# Queremos medir la eficiencia de las empresas con sus tiempos de entrega.
SELECT 
	s.company,
	ROUND(AVG(DATEDIFF(vsd.shipped_date, vsd.order_date)),2) AS diff_time,
    COUNT(DISTINCT vsd.order_id) AS orders_qty,
    ROUND(SUM(o.shipping_fee),2) AS freight_cost
FROM view_sales_details AS vsd
LEFT JOIN orders AS o
	ON vsd.order_id = o.id
JOIN shippers AS s
	ON o.shipper_id = s.id
WHERE vsd.shipped_date > 0
GROUP BY s.company;

-- ================================================================ -- 
-- 11. Geographic Revenue Distribution (Ventas netas por ciudad y país)
SELECT 
	o.ship_country_region AS country,
	o.ship_city AS city,
    SUM(line_net_revenue) AS total_net_revenue,
    COUNT(o.id) AS total_orders,
    COUNT(DISTINCT o.id) AS total_unique_orders,
    ROUND((SUM(line_net_revenue) / COUNT(DISTINCT o.id)),2) AS avg_revenue_by_orders
FROM view_sales_details AS vsd
LEFT JOIN orders AS o
	ON vsd.order_id = o.id
GROUP BY country, o.ship_city
ORDER BY total_net_revenue DESC;

-- ================================================================ -- 
/*--- Módulo D: Operational Efficiency ---
12. Análisis de Abastecimiento Crítico.
13. Reorder Point Analysis (Identificación de productos en riesgo de quiebre de stock).*/


-- 12. Análisis de Abastecimiento
# Queremos comparar el volumen real de ventas 
SELECT 
	p.product_name,	
    MONTH(vsd.order_date) AS month_date,
	ROUND(SUM(vsd.quantity),0) AS total_quantity_sales,
    p.reorder_level,
    p.target_level,
    (p.target_level - p.reorder_level) AS safety_margin
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON	vsd.product_id = p.id
GROUP BY p.product_name, month_date, p.reorder_level, p.target_level
ORDER BY month_date, total_quantity_sales DESC;

-- ================================================================ -- 
-- 13. Reorder Point Analysis (Identificación de productos en riesgo de quiebre de stock).
# Clasificaremos en estados el stock

SELECT 
	p.product_name,	
    MONTH(vsd.order_date) AS month_date,
	ROUND(SUM(vsd.quantity),0) AS total_quantity_sales,
    p.reorder_level,
    p.target_level,
    (p.target_level - p.reorder_level) AS safety_margin,
    CASE
		WHEN SUM(vsd.quantity) > (p.target_level) THEN 'Critical: Sales > stock'
        WHEN SUM(vsd.quantity) < ((p.reorder_level) * 0.20) THEN 'Excess: Too many stock'
        ELSE 'Healthy: Optimal Performance'
	END AS inventory_status
FROM view_sales_details AS vsd
LEFT JOIN products AS p
	ON	vsd.product_id = p.id
GROUP BY p.product_name, month_date, p.reorder_level, p.target_level
ORDER BY month_date, total_quantity_sales DESC;
