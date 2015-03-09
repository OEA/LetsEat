from django.conf.urls import patterns, include, url
from django.contrib import admin

from api.views import user_views
from frontend.views import user_views_


urlpatterns = patterns('',

    #Just for testing urls
    url(r'^test/$', user_views.test, name='test'),

    url(r'^api/register/$', user_views.registration_view, name='register'),
    url(r'^api/profile/(?P<username>\w+)/$', user_views.profile, name='profile'),
    url(r'^api/profile/(?P<username>\w+)/edit/$', user_views.edit, name='edit'),
    url(r'^api/login/$', user_views.login_view, name='login'),
    url(r'^login/$', user_views_.login_view, name='login'),
    url(r'^logout/$', user_views.logout, name='logout'),
    url(r'^register/$', user_views_.registration_view, name='register'),
    url(r'^profile/(?P<username>\w+)/$', user_views_.profile, name='profile'),
    url(r'^profile/(?P<username>\w+)/edit/$', user_views_.edit, name='edit'),
    url(r'^homepage/$', user_views_.home_view, name='home'),
    url(r'^admin/', include(admin.site.urls)),
)