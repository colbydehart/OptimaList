def convert(item):
    """Takes in a recipe item and outputs a tuples"""
    """of mass/volume/unit and quantity"""
    """eg 2 cups of flour => ('volume', 2)"""

    vols = 'cup,tbsp,tsp,quart,floz,mL,liter,pint,gallon'.split(',')
    masses = 'lb,oz,kg,g'.split(',')

    if item.measurement in vols:
        return cup_convert(item)
    if item.measurement in masses:
        return oz_convert(item)
    return ('unit', item.quantity)

def oz_convert(item):
    cvtr = {
        'oz':1,
        'kg':35.27,
        'lb':16,
        'g':.03527
    }
    ozs = cvtr[item.measurement]*item.quantity
    return ('mass', ozs)


def cup_convert(item):
    cvtr = {
        "mL": 0.00422675,
        "tsp": 0.0208333,
        "tbsp": 0.0625,
        "floz": 0.125,
        "cup": 1,
        "pint": 2,
        "quart": 4,
        "gallon": 16,
        "liter": 4.22675,
    }
    cups = cvtr[item.measurement] * item.quantity
    return ('volume', cups)
