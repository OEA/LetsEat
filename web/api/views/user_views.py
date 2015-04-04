__author__ = 'Hakan Uyumaz & Burak Atalay & Omer Aslan'

import json

from django.contrib.auth import authenticate, login
from django.contrib import auth
from django.http import HttpResponse
from django.template.defaultfilters import slugify
from random import randint

from ..forms import UserCreationForm, UserUpdateForm
from ..models import User

responseJSON = {}


def is_POST(request):
    if request.method != "POST":
        fail_response(responseJSON)
        responseJSON["message"] = "No request found."
        return False
    return True


def success_response(responseJSON):
    responseJSON["status"] = "success"


def fail_response(responseJSON):
    responseJSON["status"] = "failed"


def registration_view(request):
    responseJSON = {}
    if is_POST(request):
        form = UserCreationForm(request.POST)

        if form.errors:
            fail_response(responseJSON)
            responseJSON["message"] = "Errors occurred."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")

        user = form.save(commit=False)
        user.is_active = True
        user.save()

        success_response(responseJSON)
        responseJSON["message"] = "Successfully registered."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def registration_from_facebook(request):
    responseJSON = {}
    if is_POST(request):
        request_copy = request.POST.copy()
        name = request.POST["name"]
        surname = request.POST["surname"]
        request_copy["username"] = get_available_username(name, surname)
        request_copy["password"] = get_random_password()
        form = UserCreationForm(request_copy)

        if form.errors:
            fail_response(responseJSON)
            responseJSON["message"] = "Errors occurred."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")

        user = form.save(commit=False)
        user.is_active = True
        user.save()

        success_response(responseJSON)
        responseJSON["message"] = "Successfully registered from facebook."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def get_available_username(name, surname):
    if User.objects.filter(username=normalized_username(name + " " + surname)).count() > 0:
        surname = surname + "-" + str(randint(0,500))
        return get_available_username(name, surname)
    else:
        return normalized_username(name + " " + surname)


def normalized_username(title):
    title = slugify(title)
    title = title.replace("-",".")
    return title


def get_random_password():
    #It will be done
    return "testPassworjkkjhdForFB"


def create_user_JSON(user):
    user_container = {}
    user_container["username"] = user.username
    user_container["name"] = user.name
    user_container["surname"] = user.surname
    user_container["email"] = user.email
    return user_container


def login_view(request):
    responseJSON = {}
    if is_POST(request):
        username = request.POST['username']
        password = request.POST['password']
        user = authenticate(username=username, password=password)

        if user is not None:
                login(request, user)
                success_response(responseJSON)

                responseJSON["container"] = create_user_JSON(user)
                responseJSON["message"] = "Successfully logged in"
                print(responseJSON["status"])
        else:
            fail_response(responseJSON)
            responseJSON["message"] = "User credentials are not correct."
    return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def user_profile(request):
    responseJSON = {}
    success_response(responseJSON)
    responseJSON["container"] = create_user_JSON(request.user)
    return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                        content_type="application/json")


def profile(request, username):
    responseJSON = {}
    user = User.objects.get(username=username)
    responseJSON["status"] = "success"
    responseJSON["container"] = {}
    responseJSON["container"]["username"] = user.username
    responseJSON["container"]["name"] = user.name
    responseJSON["container"]["surname"] = user.surname
    responseJSON["container"]["email"] = user.email
    return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def logout(request):
    auth.logout(request)
    success_response(responseJSON)
    responseJSON["message"] = "You logout successfully"
    return HttpResponse(json.dumps(responseJSON, ensure_ascii=False).encode('utf8'),
                            content_type="application/json")


def edit(request, username):
    responseJSON = {}
    if is_POST(request):
        user = User.objects.get(username=username)
        form = UserUpdateForm(request.POST, instance=user)
        new_password = request.POST["newPassword"]
        new_password2 = request.POST["newPassword2"]
        current_password = request.POST["currentPassword"]
        if user.check_password(current_password):
            if form.errors:
                print(form.errors)
                fail_response(responseJSON)
                responseJSON["message"] = "Form errors occurred."
            else:
                user = form.save(commit=False)
                if new_password != "" and new_password == new_password2:
                    print("Password changed")
                    user.set_password(new_password)
                user.is_active = True
                user.save()
                success_response(responseJSON)
                responseJSON["message"] = "Successfully updated."
        else:
            fail_response(responseJSON)
            responseJSON["message"] = "Current password is invalid."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def test(request):
    return HttpResponse("Successful")

