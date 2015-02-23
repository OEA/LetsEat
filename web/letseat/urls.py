from django.conf.urls import patterns, include, url
from django.contrib import admin

from api.views import user_views

urlpatterns = patterns('',

    #Just for testing urls
    url(r'^test/$', user_views.test, name='test'),

    url(r'^register/$', user_views.registration_view, name='register'),
    url(r'^profile/(?P<username>\w+)/$', user_views.profile, name='profile'),
    url(r'^profile/(?P<username>\w+)/edit/$', user_views.edit, name='edit'),
    url(r'^login/$', user_views.login_view, name='login'),

    url(r'^admin/', include(admin.site.urls)),
)
