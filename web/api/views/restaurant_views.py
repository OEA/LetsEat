__author__ = 'Hakan Uyumaz'

import json

from django.http import HttpResponse

from ..models import Restaurant
from ..forms import RestaurantCreationForm

responseJSON = {}


def is_POST(request):
    if request.method != "POST":
        fail_response()
        responseJSON["message"] = "No request found."
        return False
    return True


def success_response():
    responseJSON["status"] = "success"


def fail_response():
    responseJSON["status"] = "failed"


def create_restaurant(request):
    if is_POST(request):
        restaurant = RestaurantCreationForm(request.POST)
        if restaurant.errors or not type:
            responseJSON["status"] = "failed"
            responseJSON["message"] = "Errors occurred."
            return HttpResponse(json.dumps(responseJSON), content_type="application/json")
        restaurant.save()
        responseJSON["status"] = "success"
        responseJSON["message"] = "Successfully registered."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")


def create_restaurant_JSON(restaurant):
    restaurantJSON = {}
    restaurantJSON["name"] = restaurant.name
    return restaurantJSON


def create_restaurants_json(responseJSON):
    responseJSON["restaurants"] = []
    for restaurant in Restaurant.objects.all():
        responseJSON["restaurants"].append(create_restaurant_JSON(restaurant))


def get_restaurant_list(request):
    create_restaurants_json(responseJSON)
    success_response()
    responseJSON["message"] = "Successfully returned."
    return HttpResponse(json.dumps(responseJSON), content_type="application/json")
