# Sistema Control de Empleados FH

Prototipo web MVC en .NET 8, C# y SQL Server para administrar departamentos, empleados, asignaciones de presupuesto y gastos por empleado.

## Tecnologías

- ASP.NET Core MVC (.NET 8)
- C#
- SQL Server
- Procedimientos almacenados
- Bootstrap 5 + CSS personalizado responsive
- ADO.NET con Microsoft.Data.SqlClient

## Estructura

- `SistemaControlEmpleados.sln`: solución completa.
- `SistemaControlEmpleados/Database/schema_procedimientos.sql`: creación de base de datos, tablas y procedimientos almacenados.
- `SistemaControlEmpleados/Database/consultas.sql`: consultas solicitadas en la prueba técnica.
- `SistemaControlEmpleados/Docs/Analisis_Asistencia.pdf`: análisis técnico para la funcionalidad de asistencia.

## Levantar localmente

1. Crear la base de datos y objetos ejecutando en SQL Server Management Studio:
   - `SistemaControlEmpleados/Database/schema_procedimientos.sql`

2. Abrir la solución:
   - `SistemaControlEmpleados.sln`

3. Ajustar la cadena de conexión en:
   - `SistemaControlEmpleados/appsettings.json`

   Ejemplo con autenticación Windows:

   ```json
   "DefaultConnection": "Server=localhost;Database=FH_ControlEmpleados;Trusted_Connection=True;TrustServerCertificate=True;"
   ```

4. Restaurar y ejecutar:

   ```bash
   dotnet restore
   dotnet run --project SistemaControlEmpleados
   ```

5. Abrir la URL que indique la consola, normalmente:

   ```text
   https://localhost:5001
   ```

## Validaciones incluidas

- Departamento:
  - Código obligatorio.
  - Nombre obligatorio.
  - Código único validado en backend por procedimiento almacenado y constraint UNIQUE.

- Empleado:
  - Código autogenerado como `EMP-0001`, `EMP-0002`, etc.
  - Código no editable en pantalla.
  - Nombres obligatorios.
  - Apellidos obligatorios.
  - Departamento obligatorio.

- Presupuesto:
  - Departamento obligatorio.
  - Monto mayor a cero.

- Gasto:
  - Empleado obligatorio.
  - Monto mayor a cero.
  - Descripción obligatoria.

## Reportes

La página principal muestra:

- Presupuesto asignado por departamento.
- Presupuesto utilizado.
- Presupuesto disponible.
- Porcentaje de ejecución con barra visual.
