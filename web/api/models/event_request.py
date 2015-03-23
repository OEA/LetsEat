__author__ = 'Hakan Uyumaz'

from django.db import models

from .user import User
from .event import Event


class EventRequest(models.Model):
    STATUS_LABELS = (('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted'))
    status = models.CharField('Event Request Status', max_length=50, choices=STATUS_LABELS, default='P')
    event = models.ForeignKey(Event, related_name='event')
    guest = models.ForeignKey(User, related_name='guest')
