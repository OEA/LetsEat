__author__ = 'Omer Aslan'

import http.client
import urllib.parse
import json

from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse
from django.contrib.auth import authenticate, login
from django.contrib import auth

from api.models import User


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
            connection = http.client.HTTPConnection('127.0.0.1', 8000)
            connection.request("POST", "/api/register/", params, headers)
            registration_response = connection.getresponse()
            registration_data_json = registration_response.read()
            registration_data = json.loads(registration_data_json.decode("utf-8"))
            if registration_data["status"] == "success":
                return render(request, "login.html", {"registration": True})
            else:
                return render(request, "register.html",
                              {"error": True, "error_message": registration_data["message"]})
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
            connection = http.client.HTTPConnection('127.0.0.1',8000)
            connection.request("POST", "/api/login/", params, headers)
            login_response = connection.getresponse()
            login_data_json = login_response.read()
            login_data = json.loads(login_data_json.decode("utf-8"))
            user = None
            if login_data['status'] == "success":
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
        user = get_object_or_404(User, username=username)
        context = {'user' : user, 'username': request.user.username}
        return render(request, 'profile.html', context)
    else:
        return redirect("http://127.0.0.1:8000/login/")


def edit(request, username):
    if request.user.is_authenticated():
        if request.method == "POST":
            user = request.user
            name = request.POST["name"]
            surname = request.POST["surname"]
            newPassword = request.POST["newPassword"]
            newPassword2 = request.POST["newPassword2"]
            currentPassword = request.POST["currentPassword"]
            params = urllib.parse.urlencode(
                {'name': name, 'surname': surname, 'username': username, 'newPassword': newPassword,
                 'newPassword2': newPassword2, 'currentPassword': currentPassword})
            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
            connection = http.client.HTTPConnection('127.0.0.1', 8000)
            url = "/api/profile/%s/edit/" % username
            connection.request("POST", url, params, headers)
            edit_response = connection.getresponse()
            edit_data_json = edit_response.read()
            edit_data = json.loads(edit_data_json.decode("utf-8"))
            if edit_data["status"] == "success":
                context = {'user': user, 'username':user.username, 'error': False, 'success': True}
            else:
                context = {'user': user, 'username':user.username,'error': True, 'success': False}
            return render(request, 'profile_edit.html', context)
        else:
            user = request.user
            context = {'user': user, 'error': False, 'success': False}
            return render(request, 'profile_edit.html', context)
    else:
        return redirect("login")


def search_user(request):
    if request.user.is_authenticated():
        if request.method == "POST":
            username = request.POST['username']
            if username == "":
                 return redirect("../homepage")
            params = urllib.parse.urlencode({"username" : request.user.username})
            headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
            connection = http.client.HTTPConnection('127.0.0.1',8000)
            connection.request("POST", "/api/search/"+username+"/", params, headers)
            search_response = connection.getresponse()
            search_data_json = search_response.read()
            search_data = json.loads(search_data_json.decode("utf-8"))
            if 'users' in search_data:
                user_list = []
                for user in search_data['users']:
                    user_list.append(get_object_or_404(User, username=user['username']))
                context = {'search_field': username, 'users': user_list, 'count': user_list.count(0)}
            else:
                context = {'search_field': username, 'count': 0}
            user = None
            if search_data['status'] == "success":
                return render(request, "search.html", context)
            print("There is no user like that!")
        else:
            print("Use post method!")
            return redirect("login")
    else:
        print("Please login to system")
        return render(request, "./login.html")


def add_friend(request, username):
    if request.user.is_authenticated():
        if request.method == "POST":
            if search_user(request, username):
                User.friend_list.append(search_user(request, username))
            else:
                print("There is no user like that")
                return None
        else:
            print("please use POST method!")
    else:
        return render(request, "./login.html")


def test(request):
    return HttpResponse("Successful")

def logout(request):
    auth.logout(request)
    return redirect("../login")

def notifications_view(request):
    user = None
    if request.user.is_authenticated():
        #It will be replaced by web service when it runs
        user = request.user
        context = {'user': user, 'username': user.username}
        return render(request, 'notifications.html', context)
    else:
        return redirect("http://127.0.0.1:8000/login/")