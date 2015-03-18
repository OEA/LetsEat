__author__ = 'Hakan Uyumaz'

import json

from django.http import HttpResponse

from ..models import User


def search_user(request, search_field):
    responseJSON = {}
    if len(search_field) > 1:
        users_list = set()
        for user in User.objects.filter(name__contains=search_field):
            users_list.add(user)
        for user in User.objects.filter(surname__contains=search_field):
            users_list.add(user)
        for user in User.objects.filter(username__contains=search_field):
            users_list.add(user)
        responseJSON["status"] = "success"
        if len(users_list) > 0:
            responseJSON["message"] = "Users found."
            responseJSON["users"] = []
            for user in users_list:
                userJSON = {}
                userJSON["name"] = user.name
                userJSON["surname"] = user.surname
                userJSON["username"] = user.username
                userJSON["email"] = user.email
                responseJSON["users"].append(userJSON)
        else:
            responseJSON["message"] = "Users not found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No search field found."
    return HttpResponse(json.dumps(responseJSON))


def send_friend_request(request):
    return HttpResponse("To be implemented")


def accept_friend_request(request):
    return HttpResponse("To be implemented")


def reject_friend_request(request):
    return HttpResponse("To be implemented")