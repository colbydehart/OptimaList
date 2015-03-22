using Newtonsoft.Json.Linq;
using OptimaList.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace OptimaList.Repositories
{
    public interface IRecipeRepository
    {
        List<Recipe> AllRecipes(string uid);
        void CreateRecipe(Recipe recipe);
        void DeleteRecipe(int id);
        Recipe GetRecipeById(int id);
        Ingredient GetOrCreateIngredient(string name);
        JArray GetOptimalList(string uid, int numOfRecipes);
    }
}
