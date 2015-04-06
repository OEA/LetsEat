__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..models import User, FriendshipRequest

responseJSON = {}


def is_POST(request):
    if request.method != "POST":
        fail_response()
        responseJSON["message"] = "No request found."
        return False
    return True


def success_response(responseJSON):
    responseJSON["status"] = "success"


def fail_response():
    responseJSON["status"] = "failed"


def create_user_JSON(user):
    userJSON = {}
    userJSON["name"] = user.name
    userJSON["surname"] = user.surname
    userJSON["username"] = user.username
    userJSON["email"] = user.email
    return userJSON


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
        success_response(responseJSON)
        #print(json.dumps(responseJSON))
        if len(users_list) > 0:
            responseJSON["message"] = "Users found."
            responseJSON["users"] = []
            for user in users_list:
                responseJSON["users"].append(create_user_JSON(user))
        else:
            responseJSON["message"] = "Users not found."
    else:
        fail_response(responseJSON)
        responseJSON["message"] = "No search field found."
    #print(json.dumps(responseJSON))
    return HttpResponse(json.dumps(responseJSON))


def send_friend_request(request):
    responseJSON = {}
    if is_POST(request):
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver).count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'P'
            friend_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Existing friend request updated."
        else:
            friend_request = FriendshipRequest(sender=sender, receiver=receiver, status='P')
            friend_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Friend request created."
    return HttpResponse(json.dumps(responseJSON))

def accept_friend_request(request):
    responseJSON = {}
    if is_POST(request):
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver, status='P').count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'A'
            friend_request.save()
            sender.friends.add(receiver)
            success_response(responseJSON)
            responseJSON["message"] = "Existing friend request updated."
        else:
            fail_response(responseJSON)
            responseJSON["message"] = "Pending friend request cannot be found."
    return HttpResponse(json.dumps(responseJSON))


def reject_friend_request(request):
    responseJSON = {}
    if is_POST(request):
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(User, username=sender_username)
        receiver = get_object_or_404(User, username=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver, status='P').count() > 0:
            friend_request = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver)
            friend_request.status = 'R'
            friend_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Existing friend request updated."
        else:
            fail_response(responseJSON)
            responseJSON["message"] = "Pending friend request cannot be found."
    return HttpResponse(json.dumps(responseJSON))


def get_friendship_request_situation(request):
    responseJSON = {}
    if is_POST(request):
        sender_username = request.POST["sender"]
        receiver_username = request.POST["receiver"]
        sender = get_object_or_404(FriendshipRequest, sender=sender_username)
        receiver = get_object_or_404(FriendshipRequest, receiver=receiver_username)
        if FriendshipRequest.objects.filter(sender=sender, receiver=receiver).count() > 0:
            friendship_request_situation = get_object_or_404(FriendshipRequest, sender=sender, receiver=receiver).status
            success_response(responseJSON)
            friendship_requestJSON = {}
            friendship_requestJSON["sender"] = sender_username
            friendship_requestJSON["receiver"] = receiver_username
            friendship_requestJSON["status"] = friendship_request_situation
            friendship_requestJSON["friendship_request"].append(friendship_requestJSON)
        else:
            fail_response()
            responseJSON["message"] = "Pending friend request cannot be found."
    return HttpResponse(json.dumps(responseJSON))


def get_friend_list(request):
    responseJSON = {}
    if is_POST(request):
        username = request.POST["username"]
        user = get_object_or_404(User, username=username)
        friend_list = user.friends.all()
        success_response(responseJSON)
        responseJSON["message"] = "Friends found."
        responseJSON["friends"] = []
        for friend in friend_list:
            responseJSON["friends"].append(create_user_JSON(friend))
    return HttpResponse(json.dumps(responseJSON))


def get_friend_requests(request):
    responseJSON = {}
    if is_POST(request):
        username = request.POST["username"]
        #print(json.dumps(responseJSON))
        user = get_object_or_404(User, username=username)
        friend_request_list = FriendshipRequest.objects.filter(receiver=user, status='P')
        success_response(responseJSON)
        responseJSON["senders"] = []
        sender_list = []

        for friend_request in friend_request_list:
            sender_list.append(friend_request.sender)
        if len(sender_list) > 0:
            responseJSON["message"] = "Requests found."
        else:
            responseJSON["message"] = "Requests not found."

        for sender in sender_list:
            responseJSON["senders"].append(create_user_JSON(sender))
    return HttpResponse(json.dumps(responseJSON))


def remove_friend(request):
    responseJSON = {}
    if is_POST(request):
        username = request.POST["username"]
        friend_username = request.POST["friend"]
        user = get_object_or_404(User, username=username)
        friend = get_object_or_404(User, username=friend_username)
        user.friends.remove(friend)
        success_response(responseJSON)
        responseJSON["message"] = "Friend removed"
    return HttpResponse(json.dumps(responseJSON))