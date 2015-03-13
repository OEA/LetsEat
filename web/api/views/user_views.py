__author__ = 'Hakan Uyumaz & Burak Atalay & Omer Aslan'

import json

from django.shortcuts import redirect
from django.contrib.auth import authenticate, login
from django.contrib import auth
from django.http import HttpResponse

from ..forms import UserCreationForm
from ..models import User


def registration_view(request):
    responseJSON = {}
    if request.user.is_authenticated():
        responseJSON["status"] = "failed"
        responseJSON["message"] = "Authenticated user cannot register."
        return HttpResponse(json.dumps(responseJSON), content_type="application/json")
    else:
        if request.method == "POST":
            form = UserCreationForm(request.POST)

            if form.errors:
                responseJSON["status"] = "failed"
                responseJSON["message"] = "Errors occurred."
                return HttpResponse(json.dumps(responseJSON), content_type="application/json")

            user = form.save(commit=False)
            user.is_active = True
            user.save()

            responseJSON["status"] = "success"
            responseJSON["message"] = "Successfully registered."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "No request found."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")

def login_view(request):
    responseJSON = {}
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
                login(request, user)
                responseJSON["status"] = "success"
                responseJSON["container"] = {}
                responseJSON["container"]["username"] = user.username
                responseJSON["container"]["name"] = user.name
                responseJSON["container"]["surname"] = user.surname
                responseJSON["container"]["email"] = user.email
                responseJSON["message"] = "Successfully logged in"
                print(responseJSON["status"])
                return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                                    content_type="application/json; charset=utf-8")
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "User credentials are not correct."
            return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                                content_type="application/json")
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
        return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def user_profile(request):

    responseJSON = {}
    if request.user.is_authenticated():
        responseJSON["status"] = "success"
        responseJSON["container"] = {}
        responseJSON["container"]["username"] = request.user.username
        responseJSON["container"]["name"] = request.user.name
        responseJSON["container"]["surname"] = request.user.surname
        responseJSON["container"]["email"] = request.user.email
        return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "Please login."
        return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def profile(request, username):
    responseJSON = {}
    if request.user.is_authenticated():
        user = User.objects.get(username=username)
        responseJSON["status"] = "success"
        responseJSON["container"] = {}
        responseJSON["container"]["username"] = user.username
        responseJSON["container"]["name"] = user.name
        responseJSON["container"]["surname"] = user.surname
        responseJSON["container"]["email"] = user.email
        return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "Please login."
        return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")

def logout(request):
    responseJSON = {}
    auth.logout(request)
    responseJSON["status"] = "success"
    responseJSON["message"] = "User logout successfully"
    return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def edit(request, username):
    responseJSON = {}
    if request.user.is_authenticated():
        user = User.objects.get(username=username)

        if user.is_authenticated():
            if request.method == "POST":
                form = UserCreationForm(data=request.POST, instance=request.user)
                if form.errors:
                    responseJSON["status"] = "failed"
                    responseJSON["message"] = "Errors occurred."
                    return HttpResponse(json.dumps(responseJSON), content_type="application/json")
                user = form.save(commit=False)
                user.is_active = True
                user.save()

                responseJSON["status"] = "success"
                responseJSON["message"] = "Successfully updated."
                return HttpResponse(json.dumps(responseJSON), content_type="application/json")
            else:
                #
                redirect("../login")
        else:
            print("api calismadi")
            return HttpResponse("You are editing the profile of user: %s." % username)
        return HttpResponse("You are editing the profile of user: %s." % username)
    else:
        return HttpResponse("You are editing the profile of user: %s." % username)

def test(request):
    return HttpResponse("Successful")

