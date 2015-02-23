__author__ = 'Hakan Uyumaz & Burak Atalay'

from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.http import HttpResponse

from ..forms.user_form import UserCreationForm
from ..models.user import User


def registration_view(request):
    if request.user.is_authenticated():
        return redirect("homepage")
    else:
        if request.method == "POST":
            form = UserCreationForm(request.POST)

            if form.errors:
                print form.errors
                return render(request, 'register.html', dict(errors=form.errors))

            user = form.save(commit=False)
            user.is_active = True
            user.save()

            return redirect("homepage")
        else:
            return render(request, 'register.html')

def login_view(request):
    if request.method == "POST":
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)
        if user is not None:
                login(request, user)
                return redirect('profile.html')
        else:
            return redirect('invalid_login.html')
    else:
        return HttpResponse("No request found")

def profile(request, username):
    return HttpResponse("You are looking at profile page of user: %s" %username)

def edit(request, username):
    return HttpResponse("You are editing the profile of user: %s." %username)

def test(request):
    return HttpResponse("Successful")

