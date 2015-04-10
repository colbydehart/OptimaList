from rest_framework import status, permissions
from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework.views import APIView
from django.http import Http404
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth.models import User
from ol.models import Recipe
from ol.serializers import *
from ol.permissions import IsOwnerOrReadOnly


class Register(APIView):
    permission_classes= (permissions.AllowAny,)

    def post(self, request, format=None):
        slzr = UserSerializer(data=request.data)
        if slzr.is_valid():
            User.objects.create_user(
                slzr.data['username'],
                slzr.data['email'],
                slzr.data['password']
            )
            return Response(slzr.data, status=status.HTTP_201_CREATED)
        else:
            return Response(slzr._errors, status=status.HTTP_400_BAD_REQUEST)


class RecipeList(APIView):
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)


    def get(self, request, format=None):
        recipes = Recipe.objects.filter(owner=request.user)
        serializer = RecipeSerializer(recipes, many=True)
        return Response(serializer.data)

    def post(self, request, format=None):
        rc = request.data.get('recipe')
        recipe = Recipe(name = rc.get('name'), url=rc.get('url'), owner=request.user)
        recipe.save()
        for ing in request.data.get('ingredients'):
            makeRecipeItem(recipe, ing)
        slzr = RecipeSerializer(recipe)
        return Response(slzr.data, status=status.HTTP_201_CREATED)

def makeRecipeItem(recipe, ri):
    ing, created = Ingredient.objects.get_or_create(name=ri.get('name'))
    recipe.recipeitem_set.create(
        recipe=recipe,
        ingredient=ing,
        measurement=ri.get('measurement'),
        quantity=ri.get('quantity')
    )




class RecipeDetail(APIView):
    permission_classes = (permissions.IsAuthenticatedOrReadOnly, IsOwnerOrReadOnly)

    def get_object(self, pk):
        try:
            return Recipe.objects.get(pk=pk)
        except Recipe.DoesNotExist:
            raise Http404

    def get(self, request, pk, format=None):
        recipe = self.get_object(pk)
        serializer = RecipeSerializer(recipe)
        return Response(serializer.data)

    def put(self, request, pk, format=None):
        recipe = self.get_object(pk)
        serializer = RecipeSerializer(recipe, request.data)
        if serializer.is_valid:
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk, format=None):
        recipe = self.get_object(pk)
        recipe.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
