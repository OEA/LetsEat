# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='user',
            name='activation_expire_date',
        ),
        migrations.RemoveField(
            model_name='user',
            name='activation_key',
        ),
    ]
