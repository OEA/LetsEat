# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
from django.conf import settings
import django.utils.timezone


class Migration(migrations.Migration):
    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(unique=True, max_length=50, verbose_name='Username')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('email', models.EmailField(unique=True, max_length=255, verbose_name='Email')),
                ('photo', models.ImageField(null=True, blank=True, upload_to='uploaded/user_photos/%Y/%m/%d/%h/')),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends',
                 models.ManyToManyField(to=settings.AUTH_USER_MODEL, blank=True, related_name='friends_rel_+')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('name', models.CharField(max_length=50, null=True, verbose_name='Name', blank=True)),
                ('start_time', models.DateTimeField(null=True, auto_now_add=True, verbose_name='Start_Time')),
                ('type',
                 models.CharField(max_length=50, verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')])),
                ('restaurant', models.CharField(max_length=100, null=True, verbose_name='Restaurant', blank=True)),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(related_name='owner', to=settings.AUTH_USER_MODEL)),
                ('participants', models.ManyToManyField(null=True, to=settings.AUTH_USER_MODEL, blank=True,
                                                        related_name='participants')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('status', models.CharField(default='P', max_length=50, verbose_name='Event Request Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
                ('event', models.ForeignKey(related_name='event', to='api.Event')),
                ('guest', models.ForeignKey(related_name='guest', to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='FriendshipRequest',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('status', models.CharField(max_length=50, verbose_name='Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
                ('date', models.DateField(auto_now_add=True, verbose_name='Date')),
                ('receiver', models.ForeignKey(related_name='receiver', to=settings.AUTH_USER_MODEL)),
                ('sender', models.ForeignKey(related_name='sender', to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Group',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('name', models.CharField(max_length=50, null=True, verbose_name='Group Name', blank=True)),
                ('members',
                 models.ManyToManyField(null=True, to=settings.AUTH_USER_MODEL, blank=True, related_name='members')),
                ('owner',
                 models.ForeignKey(blank=True, null=True, to=settings.AUTH_USER_MODEL, related_name='group owner')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, verbose_name='ID', auto_created=True)),
                ('name', models.CharField(max_length=100, verbose_name='Name')),
                ('latitude', models.CharField(max_length=50, null=True, verbose_name='Latitude', blank=True)),
                ('longitude', models.CharField(max_length=50, null=True, verbose_name='Longitude', blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
