from rest_framework.urlpatterns import format_suffix_patterns
from django.conf.urls import include, url
from ol import views


urlpatterns = [
    url(r'api/recipes/$', views.recipe_list),
    url(r'api/recipes/(?P<pk>[0-9]+)$', views.recipe_detail),
    url(r'^api-auth/', include(
        'rest_framework.urls',
        namespace='rest_framework'
    )),
]

urlpatterns = format_suffix_patterns(urlpatterns)
