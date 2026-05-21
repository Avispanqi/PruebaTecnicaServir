using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SistemaControlEmpleados.Data;
using SistemaControlEmpleados.Models;
namespace SistemaControlEmpleados.Controllers;
public class PresupuestosController:Controller{
 private readonly AppRepository _repo; public PresupuestosController(AppRepository r)=>_repo=r;
 private async Task LoadDeps(int? selected=null){ ViewBag.Departamentos=new SelectList(await _repo.Departamentos(),"Id","Nombre",selected); }
 public async Task<IActionResult> Index()=>View(await _repo.Presupuestos());
 public async Task<IActionResult> Edit(int? id){ var m=id==null?new Presupuesto():await _repo.Presupuesto(id.Value); await LoadDeps(m?.DepartamentoId); return View(m); }
 [HttpPost] public async Task<IActionResult> Edit(Presupuesto m){ if(!ModelState.IsValid){await LoadDeps(m.DepartamentoId); return View(m);} try{ if(m.Id==0) await _repo.CrearPresupuesto(m); else await _repo.ActualizarPresupuesto(m); return RedirectToAction("Index"); }catch(Exception ex){ModelState.AddModelError("",ex.Message); await LoadDeps(m.DepartamentoId); return View(m);} }
 public async Task<IActionResult> Delete(int id){ await _repo.EliminarPresupuesto(id); return RedirectToAction("Index");}
}