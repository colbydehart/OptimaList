from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
#from django.contrib.auth.models import User
from models import Recipe
from serializers import *


@api_view(['GET', 'POST'])
def recipe_list(request, format=None):
    if request.method == 'GET':
        recipes = Recipe.objects.all()
        serializer = RecipeSerializer(recipes, many=True)
        return Response(serializer.data)
    elif request.method == 'POST':
        serializer = RecipeSerializer(request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def recipe_detail(request, pk, format=None):
    try:
        recipe = Recipe.objects.get(pk=pk)
    except Recipe.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        slzr = RecipeSerializer(recipe)
        return Response(slzr.data)

    elif request.method == 'PUT':
        slzr = RecipeSerializer(recipe, data=request.data)
        if slzr.is_valid():
            slzr.save()
            return Response(slzr.data)

    elif request.method == 'DELETE':
        recipe.delete()
        return Response(status=HTTP_204_NO_CONTENT)
