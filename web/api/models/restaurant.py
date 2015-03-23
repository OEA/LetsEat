__author__ = 'Hakan Uyumaz'

from django.db import models


class Restaurant(models.Model):
    name = models.CharField('Name', max_length=50, unique=False, null=False, blank=False)
    latitude = models.CharField('Latitude', max_length=50, unique=False, null=True, blank=True)
    longitude = models.CharField('Longitude', max_length=50, unique=False, null=True, blank=True)
