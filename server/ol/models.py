from django.db import models
from django.contrib.auth.models import User


class Recipe(models.Model):
    name = models.CharField(max_length=60, blank=False)
    url = models.URLField()
    owner = models.ForeignKey(User)


class Ingredient(models.Model):
    name = models.CharField(max_length=60, blank=False)


class RecipeItem(models.Model):
    recipe = models.ForeignKey(Recipe)
    ingredient = models.ForeignKey(Ingredient)
    measurement = models.CharField(max_length=60)
    quantity = models.DecimalField(max_digits=10, decimal_places=3)
