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
using System.Diagnostics;

namespace OptimaList.Tests.Repositories
{
    [TestClass]
    public class RecipeRepositoryTest
    {

        static private RecipeRepository repo;


        [TestMethod]
        public void GetAllRecipesTest()
        {
            Assert.AreEqual(2, repo.AllRecipes("1").Count);
        }

        [TestMethod]
        public void CreateRecipeTest()
        {
            var rec = new Recipe
            {
                Name = "pasta",
                Url = "Pas.ta",
                UserId = "1"
            };
            repo.CreateRecipe(rec);
            Assert.AreEqual(3, repo.AllRecipes("1").Count);
            var url = repo.AllRecipes("1").Where<Recipe>(r => r.Name == "pasta").Single().Url;
            Assert.AreEqual("Pas.ta", url);
            repo.DeleteRecipe(rec.ID);

        }

        [TestMethod]
        public void DeleteRecipeTest()
        {
            var n = repo.AllRecipes("1").Count;
            var rc = new Recipe { Name = "sti", Url = "ng", UserId = "1" };
            repo.CreateRecipe(rc);
            repo.DeleteRecipe(rc.ID);
            Assert.AreEqual(n, repo.AllRecipes("1").Count);
        }

        [TestMethod]
        public void GetRecipeByIdTest()
        {
            var rc = new Recipe { Name = "Rargh", Url= "Cool.dog" };
            repo.CreateRecipe(rc);
            Assert.AreEqual("Rargh", repo.GetRecipeById(rc.ID).Name);
            repo.DeleteRecipe(rc.ID);
        }

        [TestMethod]
        public void GetIngredientThatExists()
        {
            Assert.AreEqual(1, repo.GetOrCreateIngredient("potato").ID);
        }
        
        [TestMethod]
        public void GetIngredientThatExistsWithExtraFormatting()
        {
            Assert.AreEqual(1, repo.GetOrCreateIngredient(" \n Potato").ID);
        }

        [TestMethod]
        public void GetIngredientThatDoesntExists()
        {
            Assert.AreEqual(6, repo.GetOrCreateIngredient("bratwurst").ID);

        }

        [TestMethod]
        public void GetOptimalListTest()
        {
            var ls = repo.GetOptimalList("1", 2);
            Assert.AreEqual(2, ls.GetValue("recipes").Count());
        }

        [TestMethod]
        public void GetNumIngsTest()
        {
            var ls = repo.AllRecipes("1");

            Assert.AreEqual(4, repo.NumberOfIngredients(ls));
        }

        [ClassCleanup]
        static public void testBreakdown()
        {
            var context = new RecipeDbContext();
            context.Database.Delete();

        }

        [ClassInitialize]
        static public void testSetup(TestContext _testctx)
        {
            //DbConnection connection = Effort.DbConnectionFactory.CreateTransient();
            using (var context = new RecipeDbContext())
            {
                context.Database.CreateIfNotExists();
                var bp = new Recipe
                {
                    Name = "Baked Potato",
                    Url = "Baked.potato",
                    UserId = "1",
                };
                var pc = new Recipe
                {
                    Name = "Popcorn",
                    Url = "Pop.Corn",
                    UserId = "1",
                };
                var chow = new Recipe
                {
                    Name = "Chowder",
                    Url = "Chow.der",
                    UserId = "2",
                };
                context.Recipes.AddRange(new List<Recipe> { chow, bp, pc });
                context.SaveChanges();

                var po = new Ingredient { Name = "potato"};
                var bt = new Ingredient { Name = "butter"};
                var sc = new Ingredient { Name = "sour Cream"};
                var cn = new Ingredient { Name = "corn"};
                var br = new Ingredient { Name = "broth"};

                context.Ingredients.AddRange(new List<Ingredient> { po, bt, sc, cn, br });
                context.SaveChanges();

                context.RecipeItems.AddRange(new List<RecipeItem>
                {
                    new RecipeItem {ID = 1, Quantity=1, Measurement="cup", Recipe= bp, Ingredient=po},
                    new RecipeItem {ID = 2, Quantity=1, Measurement="cup", Recipe= bp, Ingredient=bt}, 
                    new RecipeItem {ID = 3, Quantity=1, Measurement="cup", Recipe= bp, Ingredient=sc}, 
                    new RecipeItem {ID = 4, Quantity=1, Measurement="cup", Recipe= pc, Ingredient=bt},
                    new RecipeItem {ID = 5, Quantity=1, Measurement="cup", Recipe= pc, Ingredient=cn}, 
                    new RecipeItem {ID = 6, Quantity=1, Measurement="cup", Recipe= chow, Ingredient=cn},  
                    new RecipeItem {ID = 7, Quantity=1, Measurement="cup", Recipe= chow, Ingredient=br}  
                });
                context.SaveChanges();
            }

            repo = new RecipeRepository(new RecipeDbContext());

        }
    }
}
