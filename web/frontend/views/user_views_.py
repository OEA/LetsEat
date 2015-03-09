__author__ = 'Omer Aslan'

import http.client,urllib.parse,json

from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.contrib.auth import authenticate, login

def registration_view(request):
    if request.user.is_authenticated():
        return redirect("../homepage")
    else:
        if request.method == "POST":
            name = request.POST['name']
            surname = request.POST['surname']
            email = request.POST['email']
            password = request.POST['password']
            username = request.POST['username']

            params = urllib.parse.urlencode(
                {'name': name,
                 'surname': surname,
                 'email': email,
                 'password': password,
                 'username': username,
                })


            headers={"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
            conn = http.client.HTTPConnection('127.0.0.1', 8000)
            conn.request("POST", "/api/register/", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            return HttpResponse(data)
        else:
            return render(request, "./register.html")

def login_view(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        params = urllib.parse.urlencode({'username': username, 'password': password})
        headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
        conn = http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/login/", params, headers)
        r1 = conn.getresponse()
        data = r1.read()
        dict = json.loads(data.decode("utf-8"))
        print(dict['status'])
        user = None
        if dict['status'] == "success":
            print("successfully logged in")
            user = authenticate(username=username, password=password)
            return redirect("../homepage")
        if user is not None:
            return render(request, "./login.html")

        return redirect("../homepage")
    else:
        return render(request, "./login.html")

def profile(request, username):
    if request.user.is_authenticated():
        conn =  http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/profile/(?P<username>\w+)/$")
        r1 = conn.getresponse()
        data = r1.read()

        return HttpResponse(data)
    else:
        return redirect("../login")

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

def home_view(request):
    if "json" in request.session:
        print("test")
    return HttpResponse("test")
