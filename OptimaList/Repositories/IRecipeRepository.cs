using GroceryList.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GroceryList.Repositories
{
    public interface IRecipeRepository
    {
        List<Recipe> AllRecipes(int uid);
        void CreateRecipe(Recipe recipe);
        void DeleteRecipe(Recipe recipe);
        Recipe GetRecipeById(int id);
        //ShoppingList GetOptimalList(string uid, int numOfRecipes);
    }
}
