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
            field=models.DateField(verbose_name='Date', auto_now_add=True),
            preserve_default=True,
        ),
    ]
