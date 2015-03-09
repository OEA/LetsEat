__author__ = 'Omer Aslan'

import http.client,urllib.parse

from django.shortcuts import render, redirect
from django.http import HttpResponse


def registration_view(request):
    if request.user.is_authenticated():
        return redirect("homepage.html")
    else:
        return render(request, "register.html")

def login_view(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        params = urllib.parse.urlencode({'username': 'asd', 'password': 'issue'})
        headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
        conn =  http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/login/", params, headers)
        r1 = conn.getresponse()
        data = r1.read()
        print(data)

        return HttpResponse(data)
    else:
        return render(request, "login.html")

def profile(request, username):
    if request.user.is_authenticated():
        conn =  http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/profile/(?P<username>\w+)/$")
        r1 = conn.getresponse()
        data = r1.read()
        print(data)

        return HttpResponse(data)
    else:
        return redirect("login.html")

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

