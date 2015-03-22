using Newtonsoft.Json.Linq;
using OptimaList.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Web;

namespace OptimaList.Repositories
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

        public List<Recipe> AllRecipes(string uid)
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

        public void DeleteRecipe(int id)
        {
            Recipe rec = _ctx.Recipes.Where(r => r.ID == id).First();
            _ctx.Recipes.Remove(rec);
            _ctx.RecipeItems.RemoveRange(_ctx.RecipeItems.Where(i => i.RecipeId == id));
            _ctx.SaveChanges();
        }

        public Recipe GetRecipeById(int id)
        {
            var q = from r in _ctx.Recipes
                    where r.ID == id
                    select r;

            return q.First<Recipe>();
        }

        public Ingredient GetOrCreateIngredient(string name)
        {
            name = name.Trim(' ', '_', '\n', '\r').ToLower();
            if (_ctx.Ingredients.Any(i => i.Name == name))
            {
                return _ctx.Ingredients.Single(i => i.Name == name);
            }
            var ing = new Ingredient { Name = name };
            _ctx.Ingredients.Add(ing);
            _ctx.SaveChanges();
            return ing;
        }

        public void AddRecipeItem(RecipeItem ri)
        {
            _ctx.RecipeItems.Add(ri);
            _ctx.SaveChanges();
        }


        public JArray GetOptimalList(string uid, int r)
        {
            var recipes = from rec in _ctx.Recipes
                    where rec.UserId == uid
                    select rec;

            var pool = recipes.ToList();
            var n = pool.Count;
            var res = new JArray();

            if (r > n ){
                res.Add("Not enough elements");
                return res;
            }

            var indices = Enumerable.Range(0, r).ToList();

            var bestCombo = (from i in indices select pool[i]).ToList<Recipe>();
            int leastIngs = NumberOfIngredients(bestCombo);

            //Go backwards through array
            while(indices[0] != n - r){
                foreach (int i in Enumerable.Range(0, r).Reverse())
                {
                    //if current index is (length of pool-1) + its place in indices i
                    //minus (length of indices -1)
                    if (indices[i] == i + n - r)
                        break;
                    indices[i] += 1;
                    var curCombo = (from index in indices select pool[index]).ToList();
                    var curNum = NumberOfIngredients(curCombo);
                    if (curNum < leastIngs)
                    {
                        bestCombo = curCombo;
                        leastIngs = curNum;
                    }
                }
            }

            return JArray.FromObject(bestCombo);

        }

        public int NumberOfIngredients(List<Recipe> ls)
        {
            var q = from rec in ls
                    from item in rec.RecipeItems
                    select item.IngredientId;

            return q.Distinct().Count();

        }

    }
}