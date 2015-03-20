using System;
using System.Linq;
using Effort;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using OptimaList.Repositories;
using OptimaList.Models;
using System.Collections.Generic;
using System.Data.Entity;
using System.IO;
using System.Data.Entity.Infrastructure;
using System.Data.Common;

namespace OptimaList.Tests.Repositories
{
    [TestClass]
    public class RecipeRepositoryTest
    {

        private RecipeRepository repo;


        [TestMethod]
        public void GetAllRecipesTest()
        {
            Assert.AreEqual(2, repo.AllRecipes("1").Count);
        }

        [TestMethod]
        public void CreateRecipeTest()
        {
            repo.CreateRecipe(new Recipe { 
                Name = "pasta", 
                Url = "Pas.ta", 
                UserId="1"
            });
            Assert.AreEqual(3, repo.AllRecipes("1").Count);
            var url = repo.AllRecipes("1").Where<Recipe>(r => r.Name == "pasta").Single().Url;
            Assert.AreEqual("Pas.ta", url);
        }

        [TestMethod]
        public void DeleteRecipeTest()
        {
            repo.DeleteRecipe(1);
            Assert.AreEqual(1, repo.AllRecipes("1").Count);
        }

        [TestMethod]
        public void GetRecipeByIdTest()
        {
            var rc = repo.GetRecipeById(1);
            Assert.AreEqual("Baked Potato", rc.Name);
            var rd = repo.GetRecipeById(2);
            Assert.AreEqual("Popcorn", rd.Name);
        }

        //[TestMethod]
        //public void GetOptimalListTest()
        //{
        //    var ls = repo.GetOptimalList("1", 2);
        //    Assert.AreEqual(4, ls.Items.Count);
        //    var item = new ShoppingListItem
        //    {
        //        Name = "Butter",
        //        amount = 2.0M,
        //        Measurement = "cup",
        //        RecipeIds = new List<int> { 1, 2 }
        //    };
        //    Assert.IsTrue(ls.Items.Contains(item));
        //}


        [TestInitialize]
        public void testSetup()
        {
            DbConnection connection = Effort.DbConnectionFactory.CreateTransient();
            using (var context = new RecipeDbContext(connection))
            {
                context.Database.CreateIfNotExists();
                var bp = new Recipe
                {
                    Name = "Baked Potato",
                    ID = 1,
                    Url = "Baked.potato",
                    UserId = "1",
                };
                var pc = new Recipe
                {
                    Name = "Popcorn",
                    ID = 2,
                    Url = "Pop.Corn",
                    UserId = "1",
                };
                var chow = new Recipe
                {
                    Name = "Chowder",
                    ID = 3,
                    Url = "Chow.der",
                    UserId = "2",
                };
                context.Recipes.AddRange(new List<Recipe>{ chow, bp, pc });

                var po = new Ingredient { Name = "Potato", ID = 1 };
                var bt = new Ingredient { Name = "Butter", ID = 2 };
                var sc = new Ingredient { Name = "Sour Cream", ID = 3 };
                var cn = new Ingredient { Name = "Corn", ID = 4 };
                var br = new Ingredient { Name = "Broth", ID = 5 };

                context.Ingredients.AddRange(new List<Ingredient> { po, bt, sc, cn, br });
                context.SaveChanges();

                context.RecipeItems.AddRange(new List<RecipeItem>
                {
                    new RecipeItem {ID = 1, quantity=1, measurement="cup", Ingredient=po, Recipe=bp},
                    new RecipeItem {ID = 2, quantity=1, measurement="cup", Ingredient=bt, Recipe=bp},
                    new RecipeItem {ID = 3, quantity=1, measurement="cup", Ingredient=sc, Recipe=bp},
                    new RecipeItem {ID = 4, quantity=1, measurement="cup", Ingredient=bt, Recipe=pc},
                    new RecipeItem {ID = 5, quantity=1, measurement="cup", Ingredient=cn, Recipe=bp},
                    new RecipeItem {ID = 6, quantity=1, measurement="cup", Ingredient=br, Recipe=chow},
                    new RecipeItem {ID = 7, quantity=1, measurement="cup", Ingredient=cn, Recipe=chow}
                });
                context.SaveChanges();
            }

            repo = new RecipeRepository(new RecipeDbContext(connection));
        }
    }
}
