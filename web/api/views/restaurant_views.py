__author__ = 'Hakan Uyumaz'

import json

from django.http import HttpResponse

from ..models import Restaurant
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


def get_restaurant_JSON(restaurant):
    restaurantJSON = {}
    restaurantJSON["name"] = restaurant.name
    return restaurantJSON


def create_restaurants_json(responseJSON):
    responseJSON["restaurants"] = []
    for restaurant in Restaurant.objects.all():
        responseJSON["restaurants"].append(get_restaurant_JSON(restaurant))


def get_restaurant_list(request):
    responseJSON = {}
    create_restaurants_json(responseJSON)
    responseJSON["status"] = "success"
    responseJSON["message"] = "Successfully returned."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")
