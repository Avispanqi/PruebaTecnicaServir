using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SistemaControlEmpleados.Data;
using SistemaControlEmpleados.Models;
namespace SistemaControlEmpleados.Controllers;
public class EmpleadosController:Controller{
 private readonly AppRepository _repo; public EmpleadosController(AppRepository r)=>_repo=r;
 private async Task LoadDeps(int? selected=null){ ViewBag.Departamentos=new SelectList(await _repo.Departamentos(),"Id","Nombre",selected); }
 public async Task<IActionResult> Index()=>View(await _repo.Empleados());
 public async Task<IActionResult> Edit(int? id){ var m=id==null?new Empleado():await _repo.Empleado(id.Value); await LoadDeps(m?.DepartamentoId); return View(m); }
 [HttpPost] public async Task<IActionResult> Edit(Empleado m){ if(!ModelState.IsValid){await LoadDeps(m.DepartamentoId); return View(m);} try{ if(m.Id==0) await _repo.CrearEmpleado(m); else await _repo.ActualizarEmpleado(m); return RedirectToAction("Index"); }catch(Exception ex){ModelState.AddModelError("",ex.Message); await LoadDeps(m.DepartamentoId); return View(m);} }
 public async Task<IActionResult> Delete(int id){ await _repo.EliminarEmpleado(id); return RedirectToAction("Index");}
}