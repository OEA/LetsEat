__author__ = 'Hakan Uyumaz'

from django import forms

from ..models import Event


class EventCreationForm(forms.ModelForm):
    class Meta:
        model = Event
        fields = ['name', 'time', 'type', ]