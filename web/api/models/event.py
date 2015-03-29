__author__ = 'Hakan Uyumaz'

from django.db import models

from .restaurant import Restaurant
from .user import User


class Event(models.Model):
    TYPE_LABELS = (('D', 'Dinning'), ('M', 'Meal'))
    owner = models.ForeignKey(User, related_name="owner")
    name = models.CharField('Name', max_length=50, unique=False, null=True, blank=True)
    time = models.DateTimeField('Time', auto_now_add=False, null=False, blank=False)
    type = models.CharField('Type', max_length=50, choices=TYPE_LABELS)
    restaurant = models.ForeignKey(Restaurant, related_name='restaurant')
    participants = models.ManyToManyField(Restaurant, related_name='participants', null=True, blank=True)
    joinable = models.BooleanField('Joinable', default=False)

    def get_type_symbol(self, type):
        TYPE_LABELS_REVERSE = {x: y for x, y in self.TYPE_LABELS}
        return TYPE_LABELS_REVERSE[type]
