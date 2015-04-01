__author__ = 'Hakan Uyumaz'

from django.db import models

from .user import User


class Group(models.Model):
    name = models.CharField('Group Name', max_length=50, unique=False, null=True, blank=True)
    owner = models.ForeignKey(User, related_name='group owner', null=True, blank=True)
    members = models.ManyToManyField(User, related_name='members', null=True, blank=True)