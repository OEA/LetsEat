__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..forms import EventCreationForm
from ..models import User, Event, EventRequest, Group, Comment
from ..views import file

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


def create_event(request):
    responseJSON = {}
    if is_POST(request):
        owner_id = request.POST["owner"]
        restaurant = request.POST["restaurant"]
        owner = get_object_or_404(User, username=owner_id)
        form = EventCreationForm(request.POST)
        type = Event.TYPE_LABELS_REVERSE.get(request.POST["type"], None)
        if form.errors:
            fail_response(responseJSON)
            responseJSON["message"] = "Errors occurred."
            responseJSON["error"] = str(form.errors) + " Requested Type:" + request.POST["type"] + " Type:" + str(type)
            file.create_file(request, responseJSON, "create_event", request.method)
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        event = form.save(commit=False)
        event.owner = owner
        event.save()
        event.participants.add(owner)
        event.restaurant = restaurant
        if request.POST["joinable"] == 1:
            event.joinable = True
        else:
            event.joinable = False
        event.start_time = request.POST['start_time']
        event.save()
        success_response(responseJSON)
        responseJSON["event"] = create_event_json(event)
        responseJSON["message"] = "Successfully registered."

    file.create_file(request, responseJSON, "create_event", request.method)
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def invite_event(request):
    responseJSON = {}
    if is_POST(request):
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'P'
            event_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Existing event request updated."
        else:
            event_request = EventRequest(event=event, guest=participant, status='P')
            event_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Event request created."
    file.create_file(request, responseJSON, "invite_event", request.method)
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def invite_group_event(request):
    responseJSON = {}
    if is_POST(request):
        event = get_object_or_404(Event, pk=request.POST["event"])
        group = get_object_or_404(Group, pk=request.POST["group"])
        for participant in group.members.all():
            if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
                event_request = get_object_or_404(EventRequest, event=event, guest=participant)
                event_request.status = 'P'
                event_request.save()
            else:
                event_request = EventRequest(event=event, guest=participant, status='P')
                event_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Event requests have been sent."
    file.create_file(request, responseJSON, "invite_group_event", request.method)
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def accept_event(request):
    responseJSON = {}
    if is_POST(request):
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'A'
            event.participants.add(participant)
            event.save()
            event_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Existing event request updated."
        else:
            success_response(responseJSON)
            responseJSON["message"] = "Pending event request cannot be found."
    file.create_file(request, responseJSON, "accept_event", request.method)
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def reject_event(request):
    responseJSON = {}
    if is_POST(request):
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'R'
            event_request.save()
            success_response(responseJSON)
            responseJSON["message"] = "Existing event request updated."
        else:
            fail_response(responseJSON)
            responseJSON["message"] = "Pending event request cannot be found."

    file.create_file(request, responseJSON, "reject_event", request.method)
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def get_owned_events(request):
    responseJSON = {}
    if is_POST(request):
        user = get_object_or_404(User, username=request.POST["username"])
        events = Event.objects.filter(owner=user)
        responseJSON["events"] = create_events_json(events)
        success_response(responseJSON)
        responseJSON["message"] = "Events found."
    return HttpResponse(json.dumps(responseJSON))


def get_event(request):
    responseJSON = {}
    if is_POST(request):
        event = get_object_or_404(Event, pk=request.POST["event"])
        responseJSON["event"] = create_event_json(event)
        success_response(responseJSON)
        responseJSON["message"] = "Event found."
    return HttpResponse(json.dumps(responseJSON))


def get_event_requests(request):
    responseJSON = {}
    if is_POST(request):
        user = get_object_or_404(User, username=request.POST["username"])
        event_requests = EventRequest.objects.filter(guest=user, status='P')
        responseJSON["events_requests"] = []
        for event_request in event_requests:
            event = event_request.event
            responseJSON["events_requests"].append(create_event_json(event))
        success_response(responseJSON)
    return HttpResponse(json.dumps(responseJSON))


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
    return events_list
