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
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(max_length=50, verbose_name='Username', unique=True)),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('email', models.EmailField(max_length=255, verbose_name='Email', unique=True)),
                ('photo', models.ImageField(blank=True, upload_to='uploaded/user_photos/%Y/%m/%d/%h/', null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends',
                 models.ManyToManyField(blank=True, related_name='friends_rel_+', to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('name', models.CharField(blank=True, max_length=50, verbose_name='Name', null=True)),
                ('start_time', models.DateTimeField(null=True, verbose_name='Start_Time', auto_now_add=True)),
                ('type',
                 models.CharField(max_length=50, verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')])),
                ('restaurant', models.CharField(blank=True, max_length=100, verbose_name='Restaurant', null=True)),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='owner')),
                ('participants', models.ManyToManyField(blank=True, null=True, related_name='participants',
                                                        to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('status', models.CharField(max_length=50, default='P', verbose_name='Event Request Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
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
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('status', models.CharField(max_length=50, verbose_name='Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
                ('date', models.DateField(verbose_name='Date', auto_now_add=True)),
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
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('name', models.CharField(blank=True, max_length=50, verbose_name='Group Name', null=True)),
                ('members',
                 models.ManyToManyField(blank=True, null=True, related_name='members', to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('name', models.CharField(max_length=100, verbose_name='Name')),
                ('latitude', models.CharField(blank=True, max_length=50, verbose_name='Latitude', null=True)),
                ('longitude', models.CharField(blank=True, max_length=50, verbose_name='Longitude', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
