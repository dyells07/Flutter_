using Microsoft.AspNetCore.Mvc;

namespace ApplicationBackend.Controllers.AndroidApplication
{
    [ApiController]
    [Route("[controller]/[action]")]
    public class AndLoginController : Controller
    {
        [HttpPost]
        public IActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public IActionResult RegisterUser()
        {
            return View();
        }

    }
}
