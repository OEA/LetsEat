__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..models import User, FriendshipRequest


def search_user(request, search_field):
    responseJSON = {}
    user = None
    if request.user.is_authenticated():
        user = request.user
    else:
        user = get_object_or_404(User, username=request.POST["username"])
    if len(search_field) > 0:
        users_list = set()
        for result_user in User.objects.filter(name__contains=search_field).exclude(username__exact=user.username):
            users_list.add(result_user)
        for result_user in (User.objects.filter(surname__contains=search_field)).exclude(username__exact=user.username):
            users_list.add(result_user)
        for result_user in User.objects.filter(username__contains=search_field).exclude(username__exact=user.username):
            users_list.add(result_user)
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
            responseJSON["status"] = "success"
            responseJSON["message"] = "Existing friend request updated."
        else:
            friend_request = FriendshipRequest(sender=sender, receiver=receiver, status='P')
            friend_request.save()
            responseJSON["status"] = "success"
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
            responseJSON["status"] = "success"
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
            responseJSON["status"] = "success"
            responseJSON["message"] = "Existing friend request updated."
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending friend request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def get_friendship_request_situation(request):
    responseJSON = {}
    if request.method == "POST":
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(FriendshipRequest, sender=sender_username)
        receiver = get_object_or_404(FriendshipRequest, receiver=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver).count() > 0:
            friendship_request_situation = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver).status
            friendship_requestJSON = {}
            friendship_requestJSON["sender"] = sender_username
            friendship_requestJSON["receiver"] = receiver_username
            friendship_requestJSON["status"] = friendship_request_situation
            friendship_requestJSON["friendship_request"].append(friendship_requestJSON)
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending friend request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found"
    return HttpResponse(json.dumps(responseJSON))


def get_friend_list(request):
    responseJSON = {}
    if request.method == "POST":
        username = request.POST["username"]
        user = get_object_or_404(User, username=username)
        friend_list = user.friends.all()
        responseJSON["status"] = "success"
        responseJSON["message"] = "Friends found."
        responseJSON["friends"] = []
        for friend in friend_list:
            friendJSON = {}
            friendJSON["name"] = friend.name
            friendJSON["surname"] = friend.surname
            friendJSON["username"] = friend.username
            friendJSON["email"] = friend.email
            responseJSON["friends"].append(friendJSON)
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def get_friend_requests(request):
    responseJSON = {}
    if request.method == "POST":
        username = request.POST["username"]
        user = get_object_or_404(User, username=username)
        friend_request_list = FriendshipRequest.objects.filter(receiver=user, status='P')
        responseJSON["status"] = "success"
        responseJSON["senders"] = []
        sender_list = []
        for friend_request in friend_request_list:
            sender_list.append(friend_request.sender)
        if len(sender_list) > 0:
            responseJSON["message"] = "Requests found."
        else:
            responseJSON["message"] = "Requests not found."
        for sender in sender_list:
            senderJSON = {}
            senderJSON["name"] = sender.name
            senderJSON["surname"] = sender.surname
            senderJSON["username"] = sender.username
            senderJSON["email"] = sender.email
            responseJSON["senders"].append(senderJSON)
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))