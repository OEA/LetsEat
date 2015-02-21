__author__ = 'Burak Atalay'

from django.conf.urls import patterns, url

from views import user_views

urlpatterns = patterns('',
   # ex: /polls/
                       # url(r'^$', user_views.registration_view, name='register'),
   # ex: /polls/5/
                       # url(r'^(?P<question_id>\d+)/$', views.detail, name='detail'),
   # ex: /polls/5/results/
                       #  url(r'^(?P<question_id>\d+)/results/$', views.results, name='results'),
)