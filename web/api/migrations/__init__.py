__author__ = 'Hakan Uyumaz'

from ..models import User, Event


def create_base_database(apps, schema_editor):
    hakan = User(name='Hakan', surname='Uyumaz', email='hakan.uyumaz@ozu.edu.tr', username='hakanuyumaz')
    vidal = User(name='Vidal', surname='Hara', email='vidal.hara@ozu.edu.tr', username='vidalhara')
    omer = User(name='Ömer', surname='Aslan', email='omer.aslan@ozu.edu.tr', username='omeraslan')
    yunus = User(name='Yunus', surname='Yılmaz', email='yunus.yılmaz@ozu.edu.tr', username='yunusyilmaz')
    burak = User(name='Burak', surname='Atalay', email='burak.atalay@ozu.edu.tr', username='burakatalay')
    bahadır = User(name='Bahadır', surname='Kırdan', email='bahadir.kirdan@ozu.edu.tr', username='bahadirkirdan')
    hakan.save()
    vidal.save()
    omer.save()
    yunus.save()
    burak.save()
    bahadır.save()
    aras_et = Event(name='Aras Et', owner=hakan)
    aras_et.save()
    aras_et.participants.add(bahadır)
    



def delete_base_database(apps, schema_editor):
    User.objects.all().delete()
    Event.objects.all().delete()

