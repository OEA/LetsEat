__author__ = 'Burak Atalay'

import urllib
import http.client
import json

from django.shortcuts import render, redirect

def homepage(request):
    context = None
    if request.user.is_authenticated():
        user = request.user
        params = urllib.parse.urlencode({'username': user.username})
        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
        connection = http.client.HTTPConnection('127.0.0.1',8000)
        connection.request("POST", "/api/get_friend_requests/", params, headers)
        friend_request_response = connection.getresponse()
        friend_request_json_data = friend_request_response.read()
        friend_request_data = json.loads(friend_request_json_data.decode("utf-8"))
        friend_request_list = friend_request_data["senders"]
        context = {'user' : user, 'username': user.username, 'friend_request': friend_request_list }
        return render(request, "./homepage.html", context)
    else:
        return redirect("../")
