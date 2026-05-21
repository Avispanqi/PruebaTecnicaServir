using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SistemaControlEmpleados.Data;
using SistemaControlEmpleados.Models;
namespace SistemaControlEmpleados.Controllers;
public class GastosController:Controller{
 private readonly AppRepository _repo; public GastosController(AppRepository r)=>_repo=r;
 private async Task LoadEmps(int? selected=null){ ViewBag.Empleados=new SelectList((await _repo.Empleados()).Select(e=>new{e.Id,Nombre=e.Codigo+" - "+e.Nombres+" "+e.Apellidos}),"Id","Nombre",selected); }
 public async Task<IActionResult> Index()=>View(await _repo.Gastos());
 public async Task<IActionResult> Edit(int? id){ var m=id==null?new Gasto():await _repo.Gasto(id.Value); await LoadEmps(m?.EmpleadoId); return View(m); }
 [HttpPost] public async Task<IActionResult> Edit(Gasto m){ if(!ModelState.IsValid){await LoadEmps(m.EmpleadoId); return View(m);} try{ if(m.Id==0) await _repo.CrearGasto(m); else await _repo.ActualizarGasto(m); return RedirectToAction("Index"); }catch(Exception ex){ModelState.AddModelError("",ex.Message); await LoadEmps(m.EmpleadoId); return View(m);} }
 public async Task<IActionResult> Delete(int id){ await _repo.EliminarGasto(id); return RedirectToAction("Index");}
}