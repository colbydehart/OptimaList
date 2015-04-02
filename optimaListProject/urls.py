from django.conf.urls import patterns, include, url
from django.contrib import admin
from optimaList import views

urlpatterns = patterns('',
    url(r'^', views.index, name='index'),
)
