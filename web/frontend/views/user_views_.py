__author__ = 'Omer Aslan'

import json

from django.contrib.auth import authenticate, login
from django.http import HttpResponse

def registration_view(request):
    return HttpResponse("Register Page")

def login_view(request):
    return HttpResponse("Login Page")

def profile(request, username):
    return HttpResponse("You are looking at profile page of user: %s" %username)

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

