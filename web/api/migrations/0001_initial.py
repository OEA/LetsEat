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
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(unique=True, max_length=50, verbose_name='Username')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('facebook_id', models.CharField(max_length=50, unique=True, null=True, verbose_name='Facebook ID')),
                ('email', models.EmailField(unique=True, max_length=255, verbose_name='Email')),
                ('photo', models.ImageField(upload_to='uploaded/user_photos/%Y/%m/%d/%h/', null=True, blank=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends',
                 models.ManyToManyField(to=settings.AUTH_USER_MODEL, related_name='friends_rel_+', blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, blank=True, null=True, verbose_name='Name')),
                ('start_time', models.DateTimeField(null=True, auto_now_add=True, verbose_name='Start_Time')),
                ('type',
                 models.CharField(choices=[('D', 'Dinning'), ('M', 'Meal')], max_length=50, verbose_name='Type')),
                ('restaurant', models.CharField(max_length=100, blank=True, null=True, verbose_name='Restaurant')),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='owner')),
                ('participants',
                 models.ManyToManyField(to=settings.AUTH_USER_MODEL, null=True, related_name='participants',
                                        blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status',
                 models.CharField(choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')], default='P',
                                  max_length=50, verbose_name='Event Request Status')),
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
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status',
                 models.CharField(choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')], max_length=50,
                                  verbose_name='Status')),
                ('date', models.DateField(auto_now_add=True, verbose_name='Date')),
                ('receiver', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='receiver')),
                ('sender', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='sender')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Group',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, blank=True, null=True, verbose_name='Group Name')),
                ('members',
                 models.ManyToManyField(to=settings.AUTH_USER_MODEL, null=True, related_name='members', blank=True)),
                ('owner',
                 models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='group owner', blank=True, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, verbose_name='Name')),
                ('latitude', models.CharField(max_length=50, blank=True, null=True, verbose_name='Latitude')),
                ('longitude', models.CharField(max_length=50, blank=True, null=True, verbose_name='Longitude')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
