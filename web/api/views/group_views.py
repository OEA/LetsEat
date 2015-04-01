__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..models import User, Group

responseJSON = {}


def is_POST(request):
    if request.method != "POST":
        fail_response()
        responseJSON["message"] = "No request found."
        return False
    return True


def success_response(responseJSON):
    responseJSON["status"] = "success"


def fail_response(responseJSON):
    responseJSON["status"] = "failed"


def create_user_JSON(user):
    userJSON = {}
    userJSON["name"] = user.name
    userJSON["surname"] = user.surname
    userJSON["username"] = user.username
    userJSON["email"] = user.email
    return userJSON


def create_group_JSON(group):
    groupJSON = {}
    groupJSON["id"] = group.id
    groupJSON["name"] = group.name
    groupJSON["owner"] = create_user_JSON(group.owner)
    groupJSON["members"] = []
    for member in group.members.all():
        groupJSON["members"].append(create_user_JSON(member))
    return groupJSON


def create_group(request):
    responseJSON = {}
    if is_POST(request):
        group_name = request.POST["group_name"]
        user = get_object_or_404(User, username=request.POST["username"])
        group = Group(name=group_name, owner=user)
        group.save()
        group.members.add(user)
        group.save()
        success_response(responseJSON)
        responseJSON["group"] = create_group_JSON(group)

    return HttpResponse(json.dumps(responseJSON))