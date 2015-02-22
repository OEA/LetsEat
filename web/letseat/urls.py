from django.conf.urls import patterns, include, url
from django.contrib import admin

from api.views import user_views

urlpatterns = patterns('',

    #Just for testing urls
    url(r'^test/', user_views.test, name='test'),

    url(r'^register/', user_views.registration_view, name='register'),
    url(r'^profile/', user_views.profile, name='profile'),
    url(r'^login/', user_views.login_view, name='login'),

    url(r'^admin/', include(admin.site.urls)),
    url(r'^api/', include('api.urls')),
)
