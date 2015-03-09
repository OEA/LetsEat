__author__ = 'Hakan Uyumaz'

from django import forms

from ..models import User


class UserCreationForm(forms.ModelForm):

    class Meta:
        model = User
        fields = ['name', 'surname', 'email', 'password', 'username', ]

    def save(self, commit=True):
        user = super(UserCreationForm, self).save(commit=False)
        user.set_password(self.cleaned_data["password"])
        if commit:
            user.save()
        return user