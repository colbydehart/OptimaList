using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.ComponentModel.DataAnnotations;
using System.Data.Common;
using Newtonsoft.Json;

namespace OptimaList.Models
{
    public class Recipe
    {
        public int ID { get; set; }
        public string UserId { get; set; }
        [Required, DataType(DataType.Url)]
        public string Url { get; set; }
        [Required]
        public string Name { get; set; }

        public virtual ICollection<RecipeItem> RecipeItems {get; set;}
    }

    public class RecipeItem
    {
        public int ID { get; set; }
        public decimal Quantity {get; set;}
        [Required, StringLength(30)]
        public string Measurement { get; set; }

        public int RecipeId { get; set; }
        [JsonIgnore]
        virtual public Recipe Recipe { get; set; }
        public int IngredientId { get; set; }
        virtual public Ingredient Ingredient { get; set; }
    }

    public class RecipeDbContext : DbContext
    {
        public DbSet<Recipe> Recipes { get; set; }
        public DbSet<RecipeItem> RecipeItems { get; set; }
        public DbSet<Ingredient> Ingredients { get; set; }

        public RecipeDbContext() : base() { }
        public RecipeDbContext(DbConnection connection) : base(connection, true)
        {
            this.Configuration.LazyLoadingEnabled = false;
        }
        public RecipeDbContext(string connection) : base(connection)
        {
            this.Configuration.LazyLoadingEnabled = false;
        }
    }

}