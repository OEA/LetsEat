__author__ = 'Burak Atalay'

from django.conf.urls import patterns, url

from api.views import user_views

urlpatterns = patterns('',

   # ex: /profile/username/
   url(r'^(?P<username>\d+)/$', user_views.profile, name='profile'),
   # ex: /profile/username/edit/
   url(r'^(?P<username>\d+)/edit/$', user_views.edit, name='edit'),
)