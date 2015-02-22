__author__ = 'Hakan Uyumaz'

from django import forms

from ..models import User


class UserCreationForm(forms.ModelForm):

    class Meta:
        model = User
        fields =['name', 'surname', 'email', 'password',]
