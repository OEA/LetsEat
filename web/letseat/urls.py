from django.conf.urls import patterns, include, url
from django.contrib import admin

from api.views import user_views, friendship_views, event_views, restaurant_views, group_views
from frontend.views import user_views_, home_view


urlpatterns = patterns('',

    #Just for testing urls
    url(r'^test/$', user_views.test, name='test'),
    url(r'^$', user_views_.login_view, name='login'),
    url(r'^api/register/$', user_views.registration_view, name='api_register'),
    url(r'^api/search/(?P<search_field>\w+)/$', friendship_views.search_user, name='api_search'),
    url(r'^api/add_friend/$', friendship_views.send_friend_request, name='api_add_friend'),
    url(r'^api/reject_friend/$', friendship_views.reject_friend_request, name='api_reject_friend'),
    url(r'^api/accept_friend/$', friendship_views.accept_friend_request, name='api_accept_friend'),
    url(r'^api/get_friends/$', friendship_views.get_friend_list, name='api_get_friends'),
    url(r'^api/get_restaurants/$', restaurant_views.get_restaurant_list, name='api_get_restaurant_list'),
    url(r'^api/create_restaurant/$', restaurant_views.create_restaurant, name='api_create_restaurant'),
    url(r'^api/get_friend_requests/$', friendship_views.get_friend_requests, name='api_get_friend_requests'),
    url(r'^api/get_friendship_request_situation/$', friendship_views.get_friendship_request_situation, name='api_get_friendship_request_situation'),
    url(r'^api/create_group/$', group_views.create_group, name='api_create_group'),
    url(r'^api/create_event/$', event_views.create_event, name='api_create_event'),
    url(r'^api/get_owned_events/$', event_views.get_owned_events, name='api_get_owned_events'),
    url(r'^api/get_event/$', event_views.get_event, name='api_get_event'),
    url(r'^api/get_event_requests/$', event_views.get_event_requests, name='api_get_event_requests'),
    url(r'^api/invite_event/$', event_views.invite_event, name='api_invite_event'),
    url(r'^api/accept_event/$', event_views.accept_event, name='api_accept_event'),
    url(r'^api/reject_event/$', event_views.reject_event, name='api_reject_event'),
    url(r'^api/profile/$', user_views.user_profile, name='api_user_profile'),
    url(r'^api/profile/(?P<username>\w+)/$', user_views.profile, name='api_profile'),
    url(r'^api/profile/(?P<username>\w+)/edit/$', user_views.edit, name='api_edit'),
    url(r'^api/login/$', user_views.login_view, name='api_login'),
    url(r'^api/logout/$', user_views.logout, name='api_logout'),
    url(r'^forgot_password/$', user_views_.forgot_password_view, name='forgot_password'),
    url(r'^login/$', user_views_.login_view, name='login'),
    url(r'^logout/$', user_views_.logout, name='logout'),
    url(r'^register/$', user_views_.registration_view, name='register'),
    url(r'^profile/(?P<username>\w+)/$', user_views_.profile, name='profile'),
    url(r'^profile/(?P<username>\w+)/edit/$', user_views_.edit, name='edit'),
    url(r'^homepage/$', home_view.homepage, name='home_view'),
    url(r'^search/$', user_views_.search_user, name='search_user'),
    url(r'^notifications/$', user_views_.notifications_view, name='notifications'),
    url(r'^create_event/$', event_views.create_event, name='api.create_event'),
    url(r'^admin/', include(admin.site.urls)),
)