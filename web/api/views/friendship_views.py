__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..models import User, FriendshipRequest


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
    responseJSON = {}
    if request.method == "POST":
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver).count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'P'
            friend_request.save()
            responseJSON["status"] = "succes"
            responseJSON["message"] = "Existing friend request updated."
        else:
            friend_request = FriendshipRequest(sender=sender, receiver=receiver, status='P')
            friend_request.save()
            responseJSON["status"] = "succes"
            responseJSON["message"] = "Friend request created."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))

def accept_friend_request(request):
    responseJSON = {}
    if request.method == "POST":
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver, status='P').count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'A'
            friend_request.save()
            sender.friends.add(receiver)
            responseJSON["status"] = "succes"
            responseJSON["message"] = "Existing friend request updated."
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending friend request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def reject_friend_request(request):
    responseJSON = {}
    if request.method == "POST":
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver, status='P').count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'R'
            friend_request.save()
            sender.friends.add(receiver)
            responseJSON["status"] = "succes"
            responseJSON["message"] = "Existing friend request updated."
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending friend request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def get_friend_list(request):
    responseJSON = {}
    if request.method == "POST":
        username = request.POST["username"]
        user = get_object_or_404(User, username=username)
        friend_list = user.friends
        responseJSON["status"] = "success"
        responseJSON["message"] = "Friends found."
        responseJSON["users"] = []
        for friend in friend_list:
            userJSON = {}
            userJSON["name"] = friend.name
            userJSON["surname"] = friend.surname
            userJSON["username"] = friend.username
            userJSON["email"] = friend.email
            responseJSON["users"].append(userJSON)
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def get_friend_requests(request):
    return HttpResponse("To be implemented.")