using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SistemaControlEmpleados.Data;
using SistemaControlEmpleados.Models;
namespace SistemaControlEmpleados.Controllers;

public class DepartamentosController:Controller{
 private readonly AppRepository _repo; public DepartamentosController(AppRepository r)=>_repo=r;

//todos los depa 
 public async Task<IActionResult> Index()=>View(await _repo.Departamentos());

//inserta y abre los form
 public async Task<IActionResult> Edit(int? id)=>View(id==null?new Departamento():await _repo.Departamento(id.Value));

//actualiza o recibe 
 [HttpPost] public async Task<IActionResult> Edit(Departamento m){ if(!ModelState.IsValid)return View(m); try{ if(m.Id==0) await _repo.CrearDepartamento(m); else await _repo.ActualizarDepartamento(m); TempData["ok"]="Guardado correctamente"; return RedirectToAction("Index"); }catch(Exception ex){ModelState.AddModelError("",ex.Message);return View(m);} }

//elimina
 public async Task<IActionResult> Delete(int id){ await _repo.EliminarDepartamento(id); return RedirectToAction("Index");}
}