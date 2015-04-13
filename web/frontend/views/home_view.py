__author__ = 'Burak Atalay'

import urllib
import http.client
import json

from django.shortcuts import render, redirect


def get_friend_requests(user):
    params = urllib.parse.urlencode({'username': user.username})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
    connection = http.client.HTTPConnection('127.0.0.1', 8000)
    connection.request("POST", "/api/get_friend_requests/", params, headers)
    friend_request_response = connection.getresponse()
    friend_request_json_data = friend_request_response.read()
    friend_request_data = json.loads(friend_request_json_data.decode("utf-8"))
    friend_request_list = friend_request_data["senders"]
    return friend_request_list


def get_friends_count(user):
    params = urllib.parse.urlencode({'username': user.username})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
    connection = http.client.HTTPConnection('127.0.0.1', 8000)
    connection.request("POST", "/api/get_friends/", params, headers)
    friend_list_response = connection.getresponse()
    friend_list_json_data = friend_list_response.read()
    friend_list_data = json.loads(friend_list_json_data.decode("utf-8"))
    friend_list = friend_list_data["friends"]

    return len(friend_list)

def get_events(user):
    params = urllib.parse.urlencode({'username': user.username})
    headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
    connection = http.client.HTTPConnection('127.0.0.1', 8000)
    connection.request("POST", "/api/get_owned_events/", params, headers)
    event_list_response = connection.getresponse()
    event_list_json_data = event_list_response.read()
    event_list_data = json.loads(event_list_json_data.decode("utf-8"))
    event_list = event_list_data["events"]
    return event_list

def homepage(request):
    context = None
    if request.user.is_authenticated():
        user = request.user
        friend_request_list = get_friend_requests(user)
        friends_count = get_friends_count(user)
        get_owned_events = get_events(user)
        context = {'user' : user, 'username': user.username,
                   'friend_request': friend_request_list,
                   'friends_count': friends_count,
                   'events': get_owned_events}
        return render(request, "./homepage.html", context)
    else:
        return redirect("../")
