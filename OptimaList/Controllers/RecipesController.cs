using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.AspNet.Identity;
using OptimaList.Models;
using OptimaList.Repositories;

namespace OptimaList.Controllers
{
    [RoutePrefix("api/Recipes")]
    [Authorize]
    public class RecipesController : ApiController
    {
        public RecipeRepository _repo = new RecipeRepository();

        [Route("")]
        public IEnumerable<Recipe> Get()
        {
            var uid = User.Identity.GetUserId();
            return _repo.AllRecipes(uid);
        }

        // GET api/values/5
        public string Get(int id)
        {
            return "value";
        }

        [Route("")]
        [HttpPost]
        public void Post([FromBody]Recipe recipe)
        {
            recipe.UserId = User.Identity.GetUserId();
            _repo.CreateRecipe(recipe);
        }

        // PUT api/values/5
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete]
        [Route("{id}")]
        public void Delete(int id)
        {
            _repo.DeleteRecipe(id);
        }
    }
}
