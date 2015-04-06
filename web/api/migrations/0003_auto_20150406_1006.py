# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations


class Migration(migrations.Migration):

    dependencies = [
        ('api', '0002_user_facebook_id'),
    ]

    operations = [
        migrations.AlterField(
            model_name='user',
            name='facebook_id',
            field=models.CharField(verbose_name='Facebook ID', null=True, max_length=50, unique=True),
            preserve_default=True,
        ),
    ]
