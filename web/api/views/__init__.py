__author__ = 'Hakan Uyumaz & Burak Atalay'

from .user_views import registration_view, login_view
from .friendship_views import search_user, accept_friend_request, get_friend_list, reject_friend_request, \
    send_friend_request
from .event_views import create_event, get_event, get_owned_events, invite_event, accept_event, reject_event
from .restaurant_views import create_restaurant, get_restaurant_list
from .group_views import create_group