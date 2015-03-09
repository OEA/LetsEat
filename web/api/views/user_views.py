__author__ = 'Hakan Uyumaz & Burak Atalay'

import json

from django.contrib.auth import authenticate, login
from django.contrib import auth
from django.http import HttpResponse

from ..forms.user_form import UserCreationForm


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
                responseJSON["status"] = "suşcess"
                responseJSON["container"] = {}
                responseJSON["container"]["username"] = user.username
                responseJSON["container"]["name"] = user.name
                responseJSON["container"]["surname"] = user.surname
                responseJSON["container"]["email"] = user.email
                responseJSON["message"] = "Successfuly logged in"
                return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "User credentials are not correct."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
        return HttpResponse(json.dumps(responseJSON), content_type="application/json")

def profile(request, username):

    responseJSON = {}
    if request.user.is_authenticated():
        responseJSON["status"] = "success"
        responseJSON["container"] = {}
        responseJSON["container"]["username"] = user.username
        responseJSON["container"]["name"] = user.name
        return HttpResponse(json.dumps(responseJSON), content_type="application/json")
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "Please login."
        return HttpResponse(json.dumps(responseJSON), content_type="application/json")

def logout(request):
    auth.logout(request)
    return HttpResponse('Successful logout')

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

