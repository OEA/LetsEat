__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..models import User, Event, Comment

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


def create_owner_JSON(event):
    ownerJSON = {}
    ownerJSON["username"] = event.owner.username
    ownerJSON["name"] = event.owner.name
    ownerJSON["surname"] = event.owner.surname
    ownerJSON["email"] = event.owner.email
    return ownerJSON


def create_restaurant_json(event):
    restaurantJSON = event.restaurant
    return restaurantJSON


def create_participants_JSON(event):
    participants = []
    for participant in event.participants.all():
        participantJSON = {}
        participantJSON["name"] = participant.name
        participantJSON["surname"] = participant.surname
        participantJSON["username"] = participant.username
        participantJSON["email"] = participant.email
        participants.append(participantJSON)
    return participants


def create_event_json(event):
    eventJSON = {}
    eventJSON["id"] = event.id
    eventJSON["name"] = event.name
    eventJSON["owner"] = create_owner_JSON(event)
    eventJSON["restaurant"] = create_restaurant_json(event)
    eventJSON["time"] = str(event.start_time)
    eventJSON["type"] = Event.TYPE_LABELS_REVERSE.get(event.type, None)
    eventJSON["participants"] = create_participants_JSON(event)
    eventJSON["joinable"] = event.joinable
    eventJSON["comments"] = []
    for comment in Comment.objects.filter(event=event):
        eventJSON["comments"].append(create_comment_JSON(comment))
    return eventJSON


def create_user_JSON(user):
    userJSON = {}
    userJSON["username"] = user.username
    userJSON["name"] = user.name
    userJSON["surname"] = user.surname
    userJSON["email"] = user.email
    return userJSON


def create_comment_JSON(comment):
    commentJSON = {}
    commentJSON["id"] = comment.id
    commentJSON["owner"] = create_user_JSON(comment.owner)
    commentJSON["time"] = str(comment.time)
    commentJSON["likes"] = []
    for like in comment.likes.all():
        commentJSON["likes"].append(create_user_JSON(like))
    commentJSON["comments"] = []
    sub_comments = Comment.objects.filter(comment=comment)
    for sub_comment in sub_comments:
        commentJSON["comments"].append(create_comment_JSON(sub_comment))
    commentJSON["content"] = comment.content
    return commentJSON


def create_events_json(events):
    events_list = []
    for event in events:
        eventJSON = create_event_json(event)
        events_list.append(eventJSON)
    new_events = []
    for event in reversed(events_list):
        new_events.append(event)
    return new_events


def get_personal_news(request):
    responseJSON = {}
    if is_POST(request):
        user = get_object_or_404(User, username=request.POST["username"])
        events = user.participants.all()
        responseJSON["events"] = create_events_json(events)
        success_response(responseJSON)
        responseJSON["message"] = "Events found."
    return HttpResponse(json.dumps(responseJSON))