from django.conf.urls import include, url
from rest_framework import routers
from ol.views import *


router = routers.DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'recipes', RecipeViewSet)
router.register(r'recipeItems', RecipeItemViewSet)
router.register(r'ingredients', IngredientViewSet)


urlpatterns = [
    url(r'^', include(router.urls)),
    url(r'^api-auth/', include('rest_framework.urls', namespace='rest_framework'))
]
