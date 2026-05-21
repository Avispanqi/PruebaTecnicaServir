IF DB_ID('ControlEmpleados') IS NULL CREATE DATABASE ControlEmpleados;
GO

USE ControlEmpleados;
GO

IF OBJECT_ID('dbo.Gastos','U') IS NOT NULL DROP TABLE dbo.Gastos;
IF OBJECT_ID('dbo.PresupuestosDepartamento','U') IS NOT NULL DROP TABLE dbo.PresupuestosDepartamento;
IF OBJECT_ID('dbo.Empleados','U') IS NOT NULL DROP TABLE dbo.Empleados;
IF OBJECT_ID('dbo.Departamentos','U') IS NOT NULL DROP TABLE dbo.Departamentos;
GO

CREATE TABLE dbo.Departamentos(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 Codigo NVARCHAR(20) NOT NULL UNIQUE,
 Nombre NVARCHAR(120) NOT NULL,
 Descripcion NVARCHAR(500) NULL,
 Activo BIT NOT NULL DEFAULT 1,
 FechaCreacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Empleados(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 Codigo AS ('EMP-' + RIGHT('0000' + CONVERT(VARCHAR(10), Id), 4)) PERSISTED UNIQUE,
 Nombres NVARCHAR(120) NOT NULL,
 Apellidos NVARCHAR(120) NOT NULL,
 FechaNacimiento DATE NULL,
 DepartamentoId INT NOT NULL FOREIGN KEY REFERENCES dbo.Departamentos(Id),
 Activo BIT NOT NULL DEFAULT 1,
 FechaCreacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.PresupuestosDepartamento(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 DepartamentoId INT NOT NULL FOREIGN KEY REFERENCES dbo.Departamentos(Id),
 Monto DECIMAL(18,2) NOT NULL CHECK(Monto > 0),
 FechaAsignacion DATE NOT NULL,
 Observacion NVARCHAR(500) NULL,
 Activo BIT NOT NULL DEFAULT 1,
 FechaCreacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

CREATE TABLE dbo.Gastos(
 Id INT IDENTITY(1,1) PRIMARY KEY,
 EmpleadoId INT NOT NULL FOREIGN KEY REFERENCES dbo.Empleados(Id),
 Monto DECIMAL(18,2) NOT NULL CHECK(Monto > 0),
 FechaGasto DATE NOT NULL,
 Descripcion NVARCHAR(500) NOT NULL,
 Activo BIT NOT NULL DEFAULT 1,
 FechaCreacion DATETIME2 NOT NULL DEFAULT SYSDATETIME()
);

GO

CREATE OR ALTER PROCEDURE dbo.sp_Departamento_Listar AS SELECT Id,Codigo,Nombre,Descripcion FROM dbo.Departamentos WHERE Activo=1 ORDER BY Nombre;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Departamento_Obtener @Id INT AS SELECT Id,Codigo,Nombre,Descripcion FROM dbo.Departamentos WHERE Id=@Id AND Activo=1;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Departamento_Crear @Codigo NVARCHAR(20), @Nombre NVARCHAR(120), @Descripcion NVARCHAR(500)=NULL AS
BEGIN SET NOCOUNT ON; IF NULLIF(LTRIM(RTRIM(@Codigo)),'') IS NULL THROW 50001,'El codigo es obligatorio.',1; IF NULLIF(LTRIM(RTRIM(@Nombre)),'') IS NULL THROW 50002,'El nombre es obligatorio.',1; IF EXISTS(SELECT 1 FROM dbo.Departamentos WHERE Codigo=@Codigo AND Activo=1) THROW 50003,'El codigo del departamento ya existe.',1; INSERT dbo.Departamentos(Codigo,Nombre,Descripcion) VALUES(UPPER(@Codigo),@Nombre,@Descripcion); END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Departamento_Actualizar @Id INT,@Codigo NVARCHAR(20),@Nombre NVARCHAR(120),@Descripcion NVARCHAR(500)=NULL AS
BEGIN SET NOCOUNT ON; IF EXISTS(SELECT 1 FROM dbo.Departamentos WHERE Codigo=@Codigo AND Id<>@Id AND Activo=1) THROW 50003,'El codigo del departamento ya existe.',1; UPDATE dbo.Departamentos SET Codigo=UPPER(@Codigo),Nombre=@Nombre,Descripcion=@Descripcion WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Departamento_Eliminar @Id INT AS BEGIN UPDATE dbo.Departamentos SET Activo=0 WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Empleado_Listar AS SELECT e.Id,e.Codigo,e.Nombres,e.Apellidos,e.FechaNacimiento,e.DepartamentoId,d.Nombre Departamento FROM dbo.Empleados e JOIN dbo.Departamentos d ON d.Id=e.DepartamentoId WHERE e.Activo=1 ORDER BY e.Id DESC;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Empleado_Obtener @Id INT AS SELECT e.Id,e.Codigo,e.Nombres,e.Apellidos,e.FechaNacimiento,e.DepartamentoId,d.Nombre Departamento FROM dbo.Empleados e JOIN dbo.Departamentos d ON d.Id=e.DepartamentoId WHERE e.Id=@Id AND e.Activo=1;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Empleado_Crear @Nombres NVARCHAR(120),@Apellidos NVARCHAR(120),@FechaNacimiento DATE=NULL,@DepartamentoId INT AS
BEGIN SET NOCOUNT ON; IF NULLIF(LTRIM(RTRIM(@Nombres)),'') IS NULL THROW 50011,'Los nombres son obligatorios.',1; IF NULLIF(LTRIM(RTRIM(@Apellidos)),'') IS NULL THROW 50012,'Los apellidos son obligatorios.',1; IF NOT EXISTS(SELECT 1 FROM dbo.Departamentos WHERE Id=@DepartamentoId AND Activo=1) THROW 50013,'Debe seleccionar un departamento valido.',1; INSERT dbo.Empleados(Nombres,Apellidos,FechaNacimiento,DepartamentoId) VALUES(@Nombres,@Apellidos,@FechaNacimiento,@DepartamentoId); END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Empleado_Actualizar @Id INT,@Nombres NVARCHAR(120),@Apellidos NVARCHAR(120),@FechaNacimiento DATE=NULL,@DepartamentoId INT AS
BEGIN SET NOCOUNT ON; IF NOT EXISTS(SELECT 1 FROM dbo.Departamentos WHERE Id=@DepartamentoId AND Activo=1) THROW 50013,'Debe seleccionar un departamento valido.',1; UPDATE dbo.Empleados SET Nombres=@Nombres,Apellidos=@Apellidos,FechaNacimiento=@FechaNacimiento,DepartamentoId=@DepartamentoId WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Empleado_Eliminar @Id INT AS BEGIN UPDATE dbo.Empleados SET Activo=0 WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Presupuesto_Listar AS SELECT p.Id,p.DepartamentoId,d.Nombre Departamento,p.Monto,p.FechaAsignacion,p.Observacion FROM dbo.PresupuestosDepartamento p JOIN dbo.Departamentos d ON d.Id=p.DepartamentoId WHERE p.Activo=1 ORDER BY p.FechaAsignacion DESC;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Presupuesto_Obtener @Id INT AS SELECT p.Id,p.DepartamentoId,d.Nombre Departamento,p.Monto,p.FechaAsignacion,p.Observacion FROM dbo.PresupuestosDepartamento p JOIN dbo.Departamentos d ON d.Id=p.DepartamentoId WHERE p.Id=@Id AND p.Activo=1;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Presupuesto_Crear @DepartamentoId INT,@Monto DECIMAL(18,2),@FechaAsignacion DATE,@Observacion NVARCHAR(500)=NULL AS BEGIN IF @Monto<=0 THROW 50021,'El monto debe ser mayor a cero.',1; INSERT dbo.PresupuestosDepartamento(DepartamentoId,Monto,FechaAsignacion,Observacion) VALUES(@DepartamentoId,@Monto,@FechaAsignacion,@Observacion); END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Presupuesto_Actualizar @Id INT,@DepartamentoId INT,@Monto DECIMAL(18,2),@FechaAsignacion DATE,@Observacion NVARCHAR(500)=NULL AS BEGIN IF @Monto<=0 THROW 50021,'El monto debe ser mayor a cero.',1; UPDATE dbo.PresupuestosDepartamento SET DepartamentoId=@DepartamentoId,Monto=@Monto,FechaAsignacion=@FechaAsignacion,Observacion=@Observacion WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Presupuesto_Eliminar @Id INT AS BEGIN UPDATE dbo.PresupuestosDepartamento SET Activo=0 WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Gasto_Listar AS SELECT g.Id,g.EmpleadoId,e.Codigo+' - '+e.Nombres+' '+e.Apellidos Empleado,d.Nombre Departamento,g.Monto,g.FechaGasto,g.Descripcion FROM dbo.Gastos g JOIN dbo.Empleados e ON e.Id=g.EmpleadoId JOIN dbo.Departamentos d ON d.Id=e.DepartamentoId WHERE g.Activo=1 ORDER BY g.FechaGasto DESC;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Gasto_Obtener @Id INT AS SELECT g.Id,g.EmpleadoId,e.Codigo+' - '+e.Nombres+' '+e.Apellidos Empleado,d.Nombre Departamento,g.Monto,g.FechaGasto,g.Descripcion FROM dbo.Gastos g JOIN dbo.Empleados e ON e.Id=g.EmpleadoId JOIN dbo.Departamentos d ON d.Id=e.DepartamentoId WHERE g.Id=@Id AND g.Activo=1;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Gasto_Crear @EmpleadoId INT,@Monto DECIMAL(18,2),@FechaGasto DATE,@Descripcion NVARCHAR(500) AS BEGIN IF @Monto<=0 THROW 50031,'El monto debe ser mayor a cero.',1; IF NULLIF(LTRIM(RTRIM(@Descripcion)),'') IS NULL THROW 50032,'La descripcion es obligatoria.',1; INSERT dbo.Gastos(EmpleadoId,Monto,FechaGasto,Descripcion) VALUES(@EmpleadoId,@Monto,@FechaGasto,@Descripcion); END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Gasto_Actualizar @Id INT,@EmpleadoId INT,@Monto DECIMAL(18,2),@FechaGasto DATE,@Descripcion NVARCHAR(500) AS BEGIN IF @Monto<=0 THROW 50031,'El monto debe ser mayor a cero.',1; UPDATE dbo.Gastos SET EmpleadoId=@EmpleadoId,Monto=@Monto,FechaGasto=@FechaGasto,Descripcion=@Descripcion WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Gasto_Eliminar @Id INT AS BEGIN UPDATE dbo.Gastos SET Activo=0 WHERE Id=@Id; END;
GO

CREATE OR ALTER PROCEDURE dbo.sp_Reporte_PresupuestoDepartamentos AS
BEGIN
 ;WITH p AS(SELECT DepartamentoId,SUM(Monto) Asignado FROM dbo.PresupuestosDepartamento WHERE Activo=1 GROUP BY DepartamentoId),
       g AS(SELECT e.DepartamentoId,SUM(g.Monto) Utilizado FROM dbo.Gastos g JOIN dbo.Empleados e ON e.Id=g.EmpleadoId WHERE g.Activo=1 AND e.Activo=1 GROUP BY e.DepartamentoId)
 SELECT d.Id DepartamentoId,d.Codigo,d.Nombre Departamento,ISNULL(p.Asignado,0) PresupuestoAsignado,ISNULL(g.Utilizado,0) PresupuestoUtilizado,ISNULL(p.Asignado,0)-ISNULL(g.Utilizado,0) Disponible,CAST(CASE WHEN ISNULL(p.Asignado,0)=0 THEN 0 ELSE ISNULL(g.Utilizado,0)*100.0/p.Asignado END AS DECIMAL(18,2)) PorcentajeEjecucion
 FROM dbo.Departamentos d LEFT JOIN p ON p.DepartamentoId=d.Id LEFT JOIN g ON g.DepartamentoId=d.Id WHERE d.Activo=1 ORDER BY d.Nombre;
END;
GO

