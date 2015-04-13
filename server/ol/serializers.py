from rest_framework import serializers
from django.contrib.auth import get_user_model
from models import RecipeItem, Recipe, Ingredient


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = get_user_model()
        fields = ('username', 'email', 'password')


class RecipeSerializer(serializers.ModelSerializer):
    owner = serializers.ReadOnlyField(source='owner.username')

    class Meta:
        model = Recipe
        fields = ('name', 'url', 'owner', 'id')


class RecipeItemSerializer(serializers.ModelSerializer):
    recipe = serializers.StringRelatedField()
    ingredient = serializers.StringRelatedField()

    class Meta:
        model = RecipeItem
        fields = ('id', 'recipe', 'ingredient', 'measurement', 'quantity')


class IngredientSerializer(serializers.ModelSerializer):

    class Meta:
        model = Ingredient
        fields = ('id', 'name')
