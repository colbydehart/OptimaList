using GroceryList.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace GroceryList.Repositories
{
    public class RecipeRepository : IRecipeRepository, IDisposable
    {
        private RecipeDbContext _ctx;

        public RecipeRepository() { _ctx = new RecipeDbContext(); }
        public RecipeRepository(RecipeDbContext ctx) { _ctx = ctx; }

        public void Dispose()
        {
            _ctx.Dispose();
        }

        public List<Recipe> AllRecipes(int uid)
        {
            var q = from r in _ctx.Recipes
                    where r.UserId == uid
                    select r;

            return q.ToList<Recipe>();
        }


        public void CreateRecipe(Recipe recipe)
        {
            _ctx.Recipes.Add(recipe);
            _ctx.SaveChanges();
        }

        public void DeleteRecipe(Recipe recipe)
        {
            _ctx.Recipes.Remove(recipe);
            _ctx.SaveChanges();
        }

        public Recipe GetRecipeById(int id)
        {
            var q = from r in _ctx.Recipes
                    where r.ID == id
                    select r;

            return q.First<Recipe>();
        }



        //public ShoppingList GetOptimalList(string uid, int numOfRecipes)
        //     throw System.NotImplementedException();
        //{
        //    var q = from r in _ctx.Recipes
        //            where r.UserId == uid
        //            select r;
        //    //var combos = GetRecipeCombinations(q.ToList<Recipe>(), numOfRecipes);

        //    //ShoppingList OptimaList;
        //    //foreach (List<Recipe> combo in combos){

        //    }
        //}

        //private List<List<Recipe>> GetRecipeCombinations(List<Recipe> ls, int numOfRecipes)
        //{
        //    var res = new List<List<RecipeItem>>();
        //}

    }
}