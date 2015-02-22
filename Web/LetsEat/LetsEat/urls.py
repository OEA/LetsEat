from django.conf.urls import patterns, include, url
from django.contrib import admin

from backend import views as backend_views
from backend import models as backend_models

urlpatterns = patterns('',
    url(r'^register/', backend_views.registration_view, name='register'),
    url(r'^profile/', backend_models.LetsEatUser, name='profile'),
    url(r'^login/', backend_views.login_view, name='login'),
    url(r'^admin/', include(admin.site.urls)),
)
