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
        registration_response = connection.getresponse()
        registration_data_json = registration_response.read()
        registration_data = json.loads(registration_data_json.decode("utf-8"))
        list = registration_data["senders"]
        print("list burada : "+str(list))
        context = {'user' : user, 'username': user.username, 'friend_request': list }
        return render(request, "./homepage.html", context)
    else:
        return redirect("../")
