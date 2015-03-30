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
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(verbose_name='Username', max_length=50, unique=True)),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('email', models.EmailField(verbose_name='Email', max_length=255, unique=True)),
                ('photo', models.ImageField(upload_to='uploaded/user_photos/%Y/%m/%d/%h/', blank=True, null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends', models.ManyToManyField(related_name='friends_rel_+', to=settings.AUTH_USER_MODEL, blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, verbose_name='Name', blank=True, null=True)),
                ('start_time', models.DateTimeField(auto_now_add=True, verbose_name='Start_Time', null=True)),
                ('type', models.CharField(max_length=50, verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')])),
                ('restaurant', models.CharField(max_length=100, verbose_name='Restaurant', blank=True, null=True)),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='owner')),
                ('participants', models.ManyToManyField(related_name='participants', to=settings.AUTH_USER_MODEL, blank=True, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(default='P', max_length=50, verbose_name='Event Request Status', choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
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
                ('status', models.CharField(max_length=50, verbose_name='Status', choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')])),
                ('date', models.DateField(auto_now_add=True, verbose_name='Date')),
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
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, verbose_name='Name')),
                ('latitude', models.CharField(max_length=50, verbose_name='Latitude', blank=True, null=True)),
                ('longitude', models.CharField(max_length=50, verbose_name='Longitude', blank=True, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
    ]
