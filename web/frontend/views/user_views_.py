__author__ = 'Omer Aslan'

import http.client
import urllib.parse
import json

from django.shortcuts import render, redirect
from django.http import HttpResponse
from django.contrib.auth import authenticate, login
from django.contrib import auth

from api.views import user_views as functions


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

            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
            conn = http.client.HTTPConnection('127.0.0.1', 8000)
            conn.request("POST", "/api/register/", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            dict = json.loads(data.decode("utf-8"))
            print(dict)
            if dict["status"] == "success":
                return render(request, "login.html", {"registration": True})
            else:
                return render(request, "login.html", {"error": True, "error_message": dict["message"]})
        else:
            return render(request, "register.html")



def login_view(request):
    if request.user.is_authenticated():
        return redirect("../homepage")
    else:
        if request.method == "POST":
            username = request.POST['username']
            password = request.POST['password']
            params = urllib.parse.urlencode({'username': username, 'password': password})
            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
            conn = http.client.HTTPConnection('127.0.0.1',8000)
            conn.request("POST", "/api/login/", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            dict = json.loads(data.decode("utf-8"))
            user = None
            if dict['status'] == "success":
                #print("successfully logged in")
                user = authenticate(username=username, password=password)
                login(request, user)
                return redirect("../homepage")
            if user is None:
                return render(request, "./login.html")
            return redirect("../homepage")
        else:
            return render(request, "./login.html")

def forgot_password_view(request):
    if request.user.is_authenticated():
        return redirect("../homepage")
    else:
        return render(request, "./forgot_password.html")

def profile(request, username):
    user = None
    if request.user.is_authenticated():
        #It will be replaced by web service when it runs
        user = request.user
        context = {'user' : user}
        return render(request, 'profile.html', context)
    else:
        return redirect("http://127.0.0.1:8000/login/")


def edit(request, username):
    if request.user.is_authenticated():
        #It will be replaced by web service when it runs
        if request.method == "POST":
            functions.edit(request, username)
            user = request.user
            context = {'user': user}
            return render(request, 'profile_edit.html', context)
        else:
            user = request.user
            context = {'user': user}
            return render(request, 'profile_edit.html', context)
    else:
        return redirect("login")


def test(request):
    return HttpResponse("Successful")


def logout(request):
    auth.logout(request)
    return redirect("../login")



def home_view(request):
    if request.user.is_authenticated():
        return redirect("../profile/"+request.user.username)
    #     conn =  http.client.HTTPConnection('127.0.0.1',8000)
    #     conn.request("POST", "/api/profile/(?P<username>\w+)/$")
    #     r1 = conn.getresponse()
    #     data = r1.read()
    #
    #     return HttpResponse(data)
    else:
        return redirect("../login")