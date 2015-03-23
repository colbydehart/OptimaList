using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Microsoft.AspNet.Identity;
using OptimaList.Models;
using OptimaList.Repositories;
using Newtonsoft.Json.Linq;

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
        [Route("{id}")]
        public Recipe Get(int id)
        {
            return _repo.GetRecipeById(id);
        }

        [Route("")]
        [HttpPost]
        public Recipe Post(JObject request)
        {
            dynamic req = request;
            Recipe recipe = new Recipe { Name = req.recipe.Name, Url = req.recipe.Url };
            recipe.UserId = User.Identity.GetUserId();
            var uid = User.Identity.GetUserId();
            _repo.CreateRecipe(recipe);
            foreach (dynamic ing in (JArray)req.ingredients)
            {
                var ri = new RecipeItem
                {
                    Ingredient = _repo.GetOrCreateIngredient((string)ing.Name),
                    Quantity = (decimal)ing.Quantity,
                    Measurement = (string)ing.Measurement,
                    Recipe = recipe
                };
                _repo.AddRecipeItem(ri);
            }

            return recipe;
        }


        //TODO
        //[HttpPut]
        //[Route("{id}")]
        //public void Put(int id, [FromBody]Recipe Recipe)
        //{
            
        //}

        [HttpGet]
        [Route("List")]
        public JObject GetOptimaList()
        {
            var uid = User.Identity.GetUserId();
            return _repo.GetOptimalList(uid, 3);
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
