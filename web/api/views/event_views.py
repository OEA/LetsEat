__author__ = 'Hakan Uyumaz'

import json

from django.shortcuts import get_object_or_404
from django.http import HttpResponse

from ..forms import EventCreationForm
from ..models import User, Restaurant, Event, EventRequest


def create_event(request):
    responseJSON = {}
    if request.method == "POST":
        owner_id = request.POST["owner"]
        restaurant_id = request.POST["restaurant"]
        owner = get_object_or_404(User, pk=owner_id)
        restaurant = get_object_or_404(Restaurant, pk=restaurant_id)
        form = EventCreationForm(request.POST)
        type = Event.TYPE_LABELS.get(request.POST["type"], None)
        if form.errors or not type:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Errors occurred."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        event = form.save(commit=False)
        event.owner = owner
        event.participants.add(owner)
        event.restaurant = restaurant
        if request.POST["joinable"] == 1:
            event.joinable = True
        else:
            event.joinable = False
        event.type = type
        event.save()
        responseJSON["status"] = "success"
        responseJSON["message"] = "Successfully registered."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def invite_event(request):
    responseJSON = {}
    if request.method == "POST":
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'P'
            event_request.save()
            responseJSON["status"] = "success"
            responseJSON["message"] = "Existing event request updated."
        else:
            event_request = EventRequest(event=event, guest=participant, status='P')
            event_request.save()
            responseJSON["status"] = "success"
            responseJSON["message"] = "Friend request created."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def accept_event(request):
    responseJSON = {}
    if request.method == "POST":
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'A'
            event.participants.add(participant)
            event.save()
            event_request.save()
            responseJSON["status"] = "success"
            responseJSON["message"] = "Existing event request updated."
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending event request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def reject_event(request):
    responseJSON = {}
    if request.method == "POST":
        event = get_object_or_404(Event, pk=request.POST["event"])
        participant = get_object_or_404(User, username=request.POST["participant"])
        if EventRequest.objects.filter(event=event, guest=participant).count() > 0:
            event_request = get_object_or_404(EventRequest, event=event, guest=participant)
            event_request.status = 'R'
            event_request.save()
            responseJSON["status"] = "success"
            responseJSON["message"] = "Existing event request updated."
        else:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Pending event request cannot be found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def get_owned_events(request):
    responseJSON = {}
    if request.method == "POST":
        user = get_object_or_404(User, username=request.POST["username"])
        events = Event.objects.filter(owner=user)
        responseJSON["events"] = create_events_json(events)
        responseJSON["status"] = "success"
        responseJSON["message"] = "Events found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def get_event(request):
    responseJSON = {}
    if request.method == "POST":
        event = get_object_or_404(Event, pk=request.POST["event"])
        responseJSON["event"] = create_event_json(event)
        responseJSON["status"] = "success"
        responseJSON["message"] = "Event found."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON))


def create_event_json(event):
    eventJSON = {}
    eventJSON["name"] = event.name
    ownerJSON = {}
    ownerJSON["username"] = event.owner.username
    ownerJSON["name"] = event.owner.name
    ownerJSON["surname"] = event.owner.surname
    ownerJSON["email"] = event.owner.email
    eventJSON["owner"] = ownerJSON
    restaurantJSON = {}
    restaurantJSON["name"] = event.restaurant.name
    restaurantJSON["latitude"] = event.restaurant.latitude
    restaurantJSON["longitude"] = event.restaurant.longitude
    eventJSON["restaurant"] = restaurantJSON
    eventJSON["time"] = event.time
    eventJSON["type"] = event.get_type_symbol(event.type)
    eventJSON["participants"] = []
    for participant in event.participants.all():
        participantJSON = {}
        participantJSON["name"] = participant.name
        participantJSON["surname"] = participant.surname
        participantJSON["username"] = participant.username
        participantJSON["email"] = participant.email
        eventJSON["participants"].append(participantJSON)
    eventJSON["joinable"] = event.joinable
    return eventJSON


def create_events_json(events):
    events = []
    for event in events:
        eventJSON = create_event_json(event)
        events.append(eventJSON)
    return events
