__author__ = 'Hakan Uyumaz'

from django.db import models

from .user import User
from .event import Event


class Comment(models.Model):
    owner = models.ForeignKey(User, related_name="Comment Owner", null=False, blank=False)
    time = models.DateTimeField('Comment Time', auto_now_add=True, null=True, blank=True)
    likes = models.ManyToManyField(User, related_name='Likes', null=True, blank=True)
    comment = models.ForeignKey('self', related_name='Commented Comment', null=True, blank=True)
    event = models.ForeignKey(Event, related_name='Commented Event', null=True, blank=True)
    is_event_comment = models.BooleanField('Is Event Comment', default=True)
    content = models.CharField('Content', max_length=1000, unique=False, null=True, blank=True)

