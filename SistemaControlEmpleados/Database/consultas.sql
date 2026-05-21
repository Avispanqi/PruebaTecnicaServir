USE ControlEmpleados;
GO
/*
Consultas solicitadas en la prueba tecnica.
Estas consultas tambien se muestran visualmente en la pagina principal usando el procedimiento dbo.sp_Reporte_PresupuestoDepartamentos.
*/

-- a. Porcentaje de ejecucion de presupuesto por departamento.
-- La ejecucion se calcula como monto total gastado / total de presupuesto asignado.
;WITH Presupuesto AS (
    SELECT DepartamentoId, SUM(Monto) AS TotalAsignado
    FROM dbo.PresupuestosDepartamento
    WHERE Activo = 1
    GROUP BY DepartamentoId
), Gastos AS (
    SELECT e.DepartamentoId, SUM(g.Monto) AS TotalGastado
    FROM dbo.Gastos g
    INNER JOIN dbo.Empleados e ON e.Id = g.EmpleadoId
    WHERE g.Activo = 1 AND e.Activo = 1
    GROUP BY e.DepartamentoId
)
SELECT
    d.Codigo,
    d.Nombre AS Departamento,
    ISNULL(p.TotalAsignado, 0) AS PresupuestoAsignado,
    ISNULL(g.TotalGastado, 0) AS PresupuestoUtilizado,
    CAST(
        CASE
            WHEN ISNULL(p.TotalAsignado, 0) = 0 THEN 0
            ELSE ISNULL(g.TotalGastado, 0) * 100.0 / p.TotalAsignado
        END AS DECIMAL(18,2)
    ) AS PorcentajeEjecucion
FROM dbo.Departamentos d
LEFT JOIN Presupuesto p ON p.DepartamentoId = d.Id
LEFT JOIN Gastos g ON g.DepartamentoId = d.Id
WHERE d.Activo = 1
ORDER BY d.Nombre;
GO

-- b. Disponibilidad de presupuesto por departamento.
-- Se muestran todos los departamentos, incluyendo los que no tienen presupuesto o gastos.
;WITH Presupuesto AS (
    SELECT DepartamentoId, SUM(Monto) AS TotalAsignado
    FROM dbo.PresupuestosDepartamento
    WHERE Activo = 1
    GROUP BY DepartamentoId
), Gastos1 AS (
    SELECT e.DepartamentoId, g.EmpleadoId, SUM(g.Monto) AS TotalGastado
    FROM dbo.Gastos g
    INNER JOIN dbo.Empleados e ON e.Id = g.EmpleadoId
    WHERE g.Activo = 1 AND e.Activo = 1
    GROUP BY e.DepartamentoId,
             g.EmpleadoId
)
SELECT
    d.Codigo,
    d.Nombre AS Departamento,
    g.EmpleadoId AS Nombreempleado,
    ISNULL(p.TotalAsignado, 0) AS PresupuestoAsignado,
    ISNULL(g.TotalGastado, 0) AS PresupuestoUtilizado,
    ISNULL(p.TotalAsignado, 0) - ISNULL(g.TotalGastado, 0) AS Disponible
FROM dbo.Departamentos d
LEFT JOIN Presupuesto p ON p.DepartamentoId = d.Id
LEFT JOIN Gastos1 g ON g.DepartamentoId = d.Id
WHERE d.Activo = 1
ORDER BY d.Nombre DESC;
GO