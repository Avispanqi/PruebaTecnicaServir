using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using SistemaControlEmpleados.Data;
using SistemaControlEmpleados.Models;
namespace SistemaControlEmpleados.Controllers;
public class HomeController:Controller{private readonly AppRepository _repo; public HomeController(AppRepository r)=>_repo=r; public async Task<IActionResult> Index()=>View(await _repo.Reporte());}