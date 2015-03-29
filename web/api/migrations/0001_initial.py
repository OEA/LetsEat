# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
from django.conf import settings


class Migration(migrations.Migration):
    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('password', models.CharField(verbose_name='password', max_length=128)),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(verbose_name='Username', unique=True, max_length=50)),
                ('name', models.CharField(verbose_name='Name', max_length=50)),
                ('surname', models.CharField(verbose_name='Surname', max_length=50)),
                ('email', models.EmailField(verbose_name='Email', unique=True, max_length=255)),
                ('photo', models.ImageField(blank=True, null=True, upload_to='uploaded/user_photos/%Y/%m/%d/%h/')),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends',
                 models.ManyToManyField(blank=True, to=settings.AUTH_USER_MODEL, related_name='friends_rel_+')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(blank=True, verbose_name='Name', null=True, max_length=50)),
                ('start_time', models.DateTimeField(blank=True, verbose_name='Time', null=True)),
                ('type',
                 models.CharField(verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')], max_length=50)),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='owner')),
                ('participants',
                 models.ManyToManyField(blank=True, to=settings.AUTH_USER_MODEL, related_name='participants',
                                        null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('status', models.CharField(default='P', verbose_name='Event Request Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                            max_length=50)),
                ('event', models.ForeignKey(to='api.Event', related_name='event')),
                ('guest', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='guest')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='FriendshipRequest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('status', models.CharField(verbose_name='Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                            max_length=50)),
                ('date', models.DateField(verbose_name='Date', auto_now_add=True)),
                ('receiver', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='receiver')),
                ('sender', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='sender')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(verbose_name='ID', auto_created=True, primary_key=True, serialize=False)),
                ('name', models.CharField(verbose_name='Name', max_length=50)),
                ('latitude', models.CharField(blank=True, verbose_name='Latitude', null=True, max_length=50)),
                ('longitude', models.CharField(blank=True, verbose_name='Longitude', null=True, max_length=50)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='event',
            name='restaurant',
            field=models.ForeignKey(to='api.Restaurant', blank=True, related_name='restaurant', null=True),
            preserve_default=True,
        ),
    ]
