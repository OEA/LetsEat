__author__ = 'Hakan Uyumaz'

from django.db import models

from .user import User
from .event import Event


class EventRequest(models.Model):
    event = models.ForeignKey(Event, related_name='event')
    guest = models.ForeignKey(User, related_name='guest')
