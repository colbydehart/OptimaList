from ol.models import *
from ol.serializers import *
from ol.conversion import convert
from itertools import combinations


def optimize(recipes, r):
    res = {}
    best_combo = best_combination(recipes, r)
    res['recipes'] = RecipeSerializer(best_combo, many=True).data
    res['ingredients'] = flatten_ingredients(best_combo)
    return res


def best_combination(recipes, r):
    combos = combinations(recipes, r)
    best = combos.next()
    least = num_of_ingredients(best)
    for combo in combinations(recipes, r):
        if num_of_ingredients(combo) < least:
            least = num_of_ingredients(combo)
            best = combo
    return best


def num_of_ingredients(recipes):
    ingredients = []
    for recipe in recipes:
        ingredients.extend([
            x.ingredient for x in RecipeItem.objects.filter(recipe=recipe)
        ])
    return len(set(ingredients))


def flatten_ingredients(recipes):
    res = {}
    for r in recipes:
        for i in RecipeItem.objects.filter(recipe=r):
            name = i.ingredient.name
            con = convert(i)
            if name not in res:
                res[name] = {
                    'mass':0,
                    'volume':0,
                    'unit':0
                }
            res[name][con[0]]= con[1]
    return res
