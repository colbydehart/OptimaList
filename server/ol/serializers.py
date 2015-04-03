from rest_framework import serializers
from django.contrib.auth.models import User
from models import RecipeItem, Recipe, Ingredient


class UserSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = User
        fields = ('url', 'username', 'email', 'is_staff')


class RecipeSerializer(serializers.ModelSerializer):

    class Meta:
        model = Recipe
        fields = ('name', 'url', 'user', 'id')


class RecipeItemSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = RecipeItem
        fields = ('id', 'recipe', 'ingredient', 'measurement', 'quantity')


class IngredientSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = Ingredient
        fields = ('id', 'name')