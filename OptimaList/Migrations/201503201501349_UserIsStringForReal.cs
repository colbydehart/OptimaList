namespace OptimaList.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class UserIsStringForReal : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Ingredients",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        Name = c.String(),
                    })
                .PrimaryKey(t => t.ID);
            
            CreateTable(
                "dbo.RecipeItems",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        quantity = c.Decimal(nullable: false, precision: 18, scale: 2),
                        measurement = c.String(nullable: false, maxLength: 30),
                        RecipeId = c.Int(nullable: false),
                        IngredientId = c.Int(nullable: false),
                    })
                .PrimaryKey(t => t.ID)
                .ForeignKey("dbo.Ingredients", t => t.IngredientId, cascadeDelete: true)
                .ForeignKey("dbo.Recipes", t => t.RecipeId, cascadeDelete: true)
                .Index(t => t.RecipeId)
                .Index(t => t.IngredientId);
            
            CreateTable(
                "dbo.Recipes",
                c => new
                    {
                        ID = c.Int(nullable: false, identity: true),
                        UserId = c.String(),
                        Url = c.String(nullable: false),
                        Name = c.String(nullable: false),
                    })
                .PrimaryKey(t => t.ID);
            
        }
        
        public override void Down()
        {
            DropForeignKey("dbo.RecipeItems", "RecipeId", "dbo.Recipes");
            DropForeignKey("dbo.RecipeItems", "IngredientId", "dbo.Ingredients");
            DropIndex("dbo.RecipeItems", new[] { "IngredientId" });
            DropIndex("dbo.RecipeItems", new[] { "RecipeId" });
            DropTable("dbo.Recipes");
            DropTable("dbo.RecipeItems");
            DropTable("dbo.Ingredients");
        }
    }
}
