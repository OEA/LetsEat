__author__ = 'Hakan Uyumaz'

from django import forms

from ..models import LetsEatUser


class LetsEatUserCreationForm(forms.ModelForm):

    class Meta:
        model = LetsEatUser
        fields =['name', 'surname', 'email', 'password',]
