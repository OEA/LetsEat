__author__ = 'Hakan Uyumaz & Burak Atalay'

from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login

from ..forms.user_form import LetsEatUserCreationForm
from ..models.user import LetsEatUser


def registration_view(request):
    if request.user.is_authenticated():
        return redirect("homepage")
    else:
        if request.method == "POST":
            form = LetsEatUserCreationForm(request.POST)

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
    username = request.POST['username']
    password = request.POST['password']
    user = authenticate(username=username, password=password)
    if user is not None:
            login(request, user)
            return redirect("profile_page")
    else:
        return redirect("invalid_login_page")