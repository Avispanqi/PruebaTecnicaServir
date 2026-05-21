using Microsoft.Data.SqlClient;
namespace SistemaControlEmpleados.Data;

//este objeto me permite mi conexion con db
public class Db { private readonly IConfiguration _config; public Db(IConfiguration config)=>_config=config; public SqlConnection Create()=>new SqlConnection(_config.GetConnectionString("DefaultConnection")); }
