using System.ComponentModel.DataAnnotations;
namespace SistemaControlEmpleados.Models;

//este objeto mapea mis tablas de base de datos
public class Departamento { public int Id {get;set;} [Required] public string Codigo {get;set;}=""; [Required] public string Nombre {get;set;}=""; public string? Descripcion {get;set;} }
public class Empleado { public int Id {get;set;} public string Codigo {get;set;}=""; [Required] public string Nombres {get;set;}=""; [Required] public string Apellidos {get;set;}=""; public DateTime? FechaNacimiento {get;set;} [Range(1,int.MaxValue, ErrorMessage="Seleccione un departamento")] public int DepartamentoId {get;set;} public string? Departamento {get;set;} }
public class Presupuesto { public int Id {get;set;} [Range(1,int.MaxValue)] public int DepartamentoId {get;set;} public string? Departamento {get;set;} [Range(0.01,double.MaxValue)] public decimal Monto {get;set;} public DateTime FechaAsignacion {get;set;}=DateTime.Today; public string? Observacion {get;set;} }
public class Gasto { public int Id {get;set;} [Range(1,int.MaxValue)] public int EmpleadoId {get;set;} public string? Empleado {get;set;} public string? Departamento {get;set;} [Range(0.01,double.MaxValue)] public decimal Monto {get;set;} public DateTime FechaGasto {get;set;}=DateTime.Today; [Required] public string Descripcion {get;set;}=""; }
public class ReportePresupuesto { public int DepartamentoId {get;set;} public string Codigo {get;set;}=""; public string Departamento {get;set;}=""; public decimal PresupuestoAsignado {get;set;} public decimal PresupuestoUtilizado {get;set;} public decimal Disponible {get;set;} public decimal PorcentajeEjecucion {get;set;} }
