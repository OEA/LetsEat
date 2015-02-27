__author__ = 'Omer Aslan'

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
        return HttpResponse("kullanici: "+username+", pass: "+password)
    else:
        return render(request, "login.html")

def profile(request, username):
    return HttpResponse("You are looking at profile page of user: %s" %username)

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

