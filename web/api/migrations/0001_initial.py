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
                ('last_login', models.DateTimeField(verbose_name='last login', default=django.utils.timezone.now)),
                ('username', models.CharField(max_length=50, unique=True, verbose_name='Username')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('email', models.EmailField(max_length=255, unique=True, verbose_name='Email')),
                ('photo', models.ImageField(null=True, upload_to='uploaded/user_photos/%Y/%m/%d/%h/', blank=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends', models.ManyToManyField(to=settings.AUTH_USER_MODEL, related_name='friends_rel_+', blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('name', models.CharField(null=True, max_length=50, verbose_name='Name', blank=True)),
                ('start_time', models.DateTimeField(auto_now_add=True, verbose_name='Start_Time')),
                ('type', models.CharField(max_length=50, verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')])),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(to=settings.AUTH_USER_MODEL, related_name='owner')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('status', models.CharField(max_length=50, default='P', choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')], verbose_name='Event Request Status')),
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
                ('id', models.AutoField(verbose_name='ID', primary_key=True, serialize=False, auto_created=True)),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('latitude', models.CharField(null=True, max_length=50, verbose_name='Latitude', blank=True)),
                ('longitude', models.CharField(null=True, max_length=50, verbose_name='Longitude', blank=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='event',
            name='participants',
            field=models.ManyToManyField(null=True, to='api.Restaurant', related_name='participants', blank=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='event',
            name='restaurant',
            field=models.ForeignKey(to='api.Restaurant', related_name='restaurant'),
            preserve_default=True,
        ),
    ]
