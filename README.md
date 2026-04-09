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
