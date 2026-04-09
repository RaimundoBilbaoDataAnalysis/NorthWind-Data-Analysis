# NorthWind-Data-Analysis-SQL-EXCEL-POWERBI
El objetivo es transformar datos transaccionales en información estratégica para la toma de decisiones. Analizaremos la rentabilidad de los productos, el desempeño de los vendedores y la eficiencia logística.

# 📊 Análisis Operativo y Financiero - Northwind DB

Este proyecto presenta un análisis integral de la base de datos Northwind, enfocado en la **eficiencia operativa, auditoría de inventarios y rentabilidad financiera**.

## 🚀 Herramientas Utilizadas
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

--------------------------------------------------------------------------------

---

## 🛠️ Fase 2: Data Quality Assurance (QA) & ETL en Excel

Tras la extracción de datos mediante SQL, se ejecutó un protocolo de limpieza y transformación (ETL) para asegurar que la "materia prima" del análisis fuera íntegra y precisa. Este paso es fundamental para evitar sesgos en los KPIs finales.

### 🔍 Bitácora de Hallazgos y Transformaciones

| Archivo | Estado | Hallazgos Críticos | Acción Correctiva Realizada |
| :--- | :---: | :--- | :--- |
| **`01.REVENUE`** | ✅ | Inconsistencia decimal (Punto vs Coma) y strings `"NULL"` en fechas. | Normalización de separadores mediante *Texto en Columnas* y limpieza de nulos para habilitar cálculos cronológicos. |
| **`06.PROFITABILITY`** | ✅ | Formatos financieros interpretados como texto por el sistema. | Casteo de columnas de ingresos a formato numérico/contable para permitir cálculos de margen de beneficio. |
| **`10.LOGISTICS`** | ✅ | Presencia de `"NULL"` en fechas de envío y errores de escala en `diff_time`. | Eliminación de ruido de datos y ajuste de separadores para garantizar un cálculo exacto del **Lead Time**. |
| **`11.GEOGRAPHY`** | ✅ | Datos íntegros desde el origen. | Validación de nombres de locación y montos regionales para compatibilidad con el motor de mapas. |
| **`12.STOCK_SUPPLY`** | ✅ | Datos íntegros desde el origen. | Validación de niveles de reorden y objetivos de inventario. |
| **`13.STATUS`** | ✅ | Datos íntegros desde el origen. | Validación de etiquetas de negocio (`Critical`, `Excess`, `Healthy`) para asegurar una segmentación exacta. |

### 💡 Notas Técnicas de la Fase
* **Formato de Salida:** Se optó por archivos `.csv` (UTF-8) para garantizar la portabilidad del proyecto y una conexión eficiente con Power BI.
* **Integridad Referencial:** Se verificó que las claves primarias (IDs) no presentaran duplicados tras la limpieza, asegurando que las relaciones en el modelo de datos sean consistentes.

---

--------------------------------------------------------------------------------

# 📊 Fase 3: Dashboard POWER BI: Ventas, Operaciones y Logística

Este proyecto representa una solución integral de **Business Intelligence**, desde la extracción y limpieza de datos crudos hasta la creación de tableros interactivos para la toma de decisiones estratégicas.

---

## 🛠️ Tecnologías y Metodología
* **SQL:** Extracción, limpieza y unión de 6 fuentes de datos relacionales.
* **Excel:** Transformación y manejo de valores nulos/pendientes.
* **Power BI:** Modelado de datos, creación de medidas y diseño de visualizaciones interactivas.

---

## 📈 Visualizaciones Principales

### 1. Ventas y Finanzas (Sales & Finance)
Enfocada en el rendimiento del flujo de caja y categorías de producto.
<img width="1299" height="915" alt="Page1_sales_finance" src="https://github.com/user-attachments/assets/46c5c641-3335-4f7b-9c0c-f71e598bf277" />


### 2. Operaciones e Inventario (Operations & Inventory)
Análisis de stock crítico y eficiencia de transportistas.
<img width="1298" height="917" alt="Page2_operation_inventory" src="https://github.com/user-attachments/assets/e43394e8-ea92-45cf-8b02-7fbae594b8ef" />


### 3. Análisis Geográfico (Geographics)
Distribución territorial de los ingresos.
<img width="1295" height="916" alt="Page3_geographics" src="https://github.com/user-attachments/assets/75623eda-8bec-4d5d-9251-08581dfd7714" />


---

## 🔍 Hallazgos de Negocio (Insights)

* **Eficiencia Logística:** Se detectó que la **"Shipping Company A"** tiene un tiempo promedio de entrega de **3.69 días**, lo que representa un cuello de botella crítico frente a la **"Shipping Company C"**, que opera con un promedio de **0.33 días**.
* **Salud del Inventario:** El bloque más grande de productos (aprox. **1,912 unidades**) se encuentra en estado **Crítico (Sales > Stock)**, lo que sugiere una pérdida inminente de ventas si no se acelera el reabastecimiento.
* **Oportunidades Geográficas:** Las ciudades de **Memphis** y **Salt Lake City** concentran el mayor volumen de ingresos, lo que justifica una posible expansión de centros de distribución en esas zonas.

---

## 📂 Archivos del Proyecto
* `/data`: Contiene los CSVs originales procesados.
* `/report`: Archivo PDF con el reporte completo.
* `Operational_Performance_Dashboard.pbix`: Archivo fuente de Power BI.
