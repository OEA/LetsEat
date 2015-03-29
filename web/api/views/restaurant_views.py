__author__ = 'Hakan Uyumaz'

import json

from django.http import HttpResponse

from ..forms import RestaurantCreationForm


def create_restaurant(request):
    responseJSON = {}
    if request.method == "POST":
        restaurant = RestaurantCreationForm(request.POST)
        if restaurant.errors or not type:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Errors occurred."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        restaurant.save()
        responseJSON["status"] = "success"
        responseJSON["message"] = "Successfully registered."
    else:
        responseJSON["status"] = "failed"
        responseJSON["message"] = "No request found."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")
