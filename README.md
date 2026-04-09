# NorthWind-Data-Analysis-SQL-EXCEL-POWERBI
El objetivo es transformar datos transaccionales en información estratégica para la toma de decisiones. Analizaremos la rentabilidad de los productos, el desempeño de los vendedores y la eficiencia logística.

# 📊 Análisis Operativo y Financiero - Northwind DB

Este proyecto presenta un análisis integral de la base de datos Northwind, enfocado en la **eficiencia operativa, auditoría de inventarios y rentabilidad financiera**.

## 🚀 Tecnologías Utilizadas
* **SQL (MySQL):** Extracción y transformación de datos (ETL).
* **Excel:** Limpieza de datos y Control de Calidad (QA).
* **Power BI:** Visualización estratégica (En proceso).

## 📂 Contenido del Proyecto
* `northwind_analysis.sql`: Script completo con 13 niveles de análisis táctico.
* `/data`: Conjunto de resultados exportados en CSV para cada KPI calculado.

## 💡 Insights Destacados
### 🛡️ Auditoría de Inventarios (Ejercicio 12 & 13)
Se implementó un **Semáforo de Stock** que compara la demanda real mensual contra los niveles de reorden (`reorder_level`) y objetivos (`target_level`), clasificando los productos en:
* **Critical:** Demanda supera la planificación.
* **Excess:** Capital inmovilizado (Stock que no rota).
* **Healthy:** Equilibrio operativo.

### 🚚 Eficiencia Logística (Ejercicio 10)
Cálculo del **Lead Time promedio** por transportista utilizando `DATEDIFF`, eliminando ruidos de datos (valores negativos o nulos) para una toma de decisiones basada en el rendimiento real.
