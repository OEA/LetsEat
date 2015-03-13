from django.conf.urls import patterns, include, url
from django.contrib import admin

from api.views import user_views
from frontend.views import user_views_


urlpatterns = patterns('',

    #Just for testing urls
    url(r'^test/$', user_views.test, name='test'),

    url(r'^$', user_views_.login_view, name='login'),
    url(r'^api/register/$', user_views.registration_view, name='api_register'),
    url(r'^api/profile/$', user_views.user_profile, name='api_user_profile'),
    url(r'^api/profile/(?P<username>\w+)/$', user_views.profile, name='api_profile'),
    url(r'^api/profile/(?P<username>\w+)/edit/$', user_views.edit, name='api_edit'),
    url(r'^api/login/$', user_views.login_view, name='api_login'),
    url(r'^api/logout/$', user_views.logout, name='api_logout'),
    url(r'^login/$', user_views_.login_view, name='login'),
    url(r'^logout/$', user_views_.logout, name='logout'),
    url(r'^register/$', user_views_.registration_view, name='register'),
    url(r'^profile/(?P<username>\w+)/$', user_views_.profile, name='profile'),
    url(r'^profile/(?P<uname>\w+)/edit/$', user_views_.edit, name='edit'),
    url(r'^homepage/$', user_views_.home_view, name='home_view'),
    url(r'^admin/', include(admin.site.urls)),
)