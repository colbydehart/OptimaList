using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace OptimaList.Models
{
    public class ShoppingList
    {
        public ICollection<ShoppingListItem> Items { get; set; }
        public ShoppingList() { }
        public ShoppingList(List<ShoppingListItem> ls)
        {
            this.Items = ls;
        }
    }

    public class ShoppingListItem
    {
        public string Name { get; set; }
        public string Measurement { get; set; }
        public decimal amount { get; set; }
        public List<int> RecipeIds { get; set; }
    }
}