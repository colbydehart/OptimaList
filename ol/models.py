from django.conf import settings
from django.contrib.auth import get_user_model
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
from django.db import models
from django.contrib.auth.models import User


class Recipe(models.Model):
    name = models.CharField(max_length=60, blank=False)
    url = models.URLField()
    owner = models.ForeignKey(User)

    def __str__(self):
        return self.name


class Ingredient(models.Model):
    name = models.CharField(max_length=60, blank=False)

    def __str__(self):
        return self.name


class RecipeItem(models.Model):
    recipe = models.ForeignKey(Recipe)
    ingredient = models.ForeignKey(Ingredient)
    measurement = models.CharField(max_length=60)
    quantity = models.FloatField()


@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)
