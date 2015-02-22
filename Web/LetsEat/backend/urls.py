__author__ = 'Burak Atalay'

from django.conf.urls import patterns, url

from backend import views

urlpatterns = patterns('',
   # ex: /profile/username/
   url(r'^(?P<username>\d+)/$', views.profile, name='profile'),
   # ex: /profile/username/edit/
   url(r'^(?P<username>\d+)/edit/$', views.edit, name='edit'),
)