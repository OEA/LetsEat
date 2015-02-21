from django.conf.urls import patterns, include, url
from django.contrib import admin

from backend import views as backend_views

urlpatterns = patterns('',
    url(r'^register/', backend_views.registration_view, name='register'),
    url(r'^admin/', include(admin.site.urls)),
)
