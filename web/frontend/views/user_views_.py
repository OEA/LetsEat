__author__ = 'Omer Aslan'

import http.client
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
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
        conn =  http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/login/")
        r1 = conn.getresponse()
        data = r1.read()
        print(data)
        return HttpResponse(data)
    else:
        return render(request, "login.html")

def profile(request, username):
    return HttpResponse("You are looking at profile page of user: %s" %username)

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

