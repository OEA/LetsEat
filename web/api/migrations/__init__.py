__author__ = 'Hakan Uyumaz'

from ..models import User, Event


def create_base_database(apps, schema_editor):
    hakan = User(name='Hakan', surname='Uyumaz', email='hakan.uyumaz@ozu.edu.tr', username='hakanuyumaz')
    hakan.save()
    aras_et = Event(name='Aras Et', owner=hakan)
    aras_et.save()


def delete_base_database(apps, schema_editor):
    User.objects.all().delete()
    Event.objects.all().delete()

