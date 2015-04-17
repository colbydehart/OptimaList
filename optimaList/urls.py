from rest_framework.urlpatterns import format_suffix_patterns
from rest_framework.authtoken.views import obtain_auth_token
from django.conf.urls import include, url
from ol import views


urlpatterns = [
    url(r'register/$', views.Register.as_view()),
    url(r'^token/', obtain_auth_token),
    url(r'^list/$', views.OptimaList.as_view()),
    url(r'^recipes/$', views.RecipeList.as_view()),
    url(r'^recipes/(?P<pk>[0-9]+)$', views.RecipeDetail.as_view()),
    url(r'^api-auth/', include(
        'rest_framework.urls',
        namespace='rest_framework'
    )),
]

urlpatterns = format_suffix_patterns(urlpatterns)
