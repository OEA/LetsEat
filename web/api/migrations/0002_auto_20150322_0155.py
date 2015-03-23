# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='friendshiprequest',
            name='date',
            field=models.DateField(auto_now_add=True, verbose_name='Date'),
            preserve_default=True,
        ),
    ]
