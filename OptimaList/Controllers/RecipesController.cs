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
            _repo.CreateRecipe(recipe);
            foreach (dynamic ing in (JArray)req.ingredients)
            {
                var ri = new RecipeItem
                {
                    Ingredient = _repo.GetOrCreateIngredient((string)ing.Name),
                    quantity = (decimal)ing.Quantity,
                    measurement = (string)ing.Measurement,
                    Recipe = recipe
                };
                _repo.AddRecipeItem(ri);
            }

            return recipe;
        }

        [HttpPost]
        [Route("Ingredient")]
        public Ingredient GetIngredient(string name)
        {
            return _repo.GetOrCreateIngredient(name);
        }


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
