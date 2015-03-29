__author__ = 'Hakan Uyumaz'

from django import forms

from ..models import Restaurant


class RestaurantCreationForm(forms.ModelForm):
    class Meta:
        model = Restaurant
        fields = ['name', ]
