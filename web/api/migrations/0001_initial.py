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
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(max_length=50, unique=True, verbose_name='Username')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('facebook_id', models.CharField(max_length=50, unique=True, null=True, verbose_name='Facebook ID')),
                ('email', models.EmailField(max_length=255, unique=True, verbose_name='Email')),
                ('photo', models.ImageField(upload_to='uploaded/user_photos/%Y/%m/%d/%h/', blank=True, null=True)),
                ('is_active', models.BooleanField(default=True)),
                ('is_admin', models.BooleanField(default=False)),
                ('friends',
                 models.ManyToManyField(related_name='friends_rel_+', blank=True, to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Comment',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('time', models.DateTimeField(auto_now_add=True, null=True, verbose_name='Comment Time')),
                ('is_event_comment', models.BooleanField(default=True, verbose_name='Is Event Comment')),
                ('content', models.CharField(max_length=1000, blank=True, null=True, verbose_name='Content')),
                ('commented_comment',
                 models.ForeignKey(related_name='Commented Comment', blank=True, null=True, to='api.Comment')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, blank=True, null=True, verbose_name='Name')),
                ('start_time', models.DateTimeField(auto_now_add=True, null=True, verbose_name='Start_Time')),
                ('type',
                 models.CharField(max_length=50, choices=[('D', 'Dinning'), ('M', 'Meal')], verbose_name='Type')),
                ('restaurant', models.CharField(max_length=100, blank=True, null=True, verbose_name='Restaurant')),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(related_name='owner', to=settings.AUTH_USER_MODEL)),
                ('participants', models.ManyToManyField(related_name='participants', blank=True, null=True,
                                                        to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('status',
                 models.CharField(max_length=50, choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                  default='P', verbose_name='Event Request Status')),
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
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('status',
                 models.CharField(max_length=50, choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                  verbose_name='Status')),
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
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=50, blank=True, null=True, verbose_name='Group Name')),
                ('members',
                 models.ManyToManyField(related_name='members', blank=True, null=True, to=settings.AUTH_USER_MODEL)),
                ('owner',
                 models.ForeignKey(related_name='group owner', blank=True, null=True, to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(primary_key=True, auto_created=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, verbose_name='Name')),
                ('latitude', models.CharField(max_length=50, blank=True, null=True, verbose_name='Latitude')),
                ('longitude', models.CharField(max_length=50, blank=True, null=True, verbose_name='Longitude')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='comment',
            name='commented_event',
            field=models.ForeignKey(related_name='Commented Event', blank=True, null=True, to='api.Event'),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='comment',
            name='likes',
            field=models.ManyToManyField(related_name='Likes', blank=True, null=True, to=settings.AUTH_USER_MODEL),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='comment',
            name='owner',
            field=models.ForeignKey(related_name='Comment Owner', to=settings.AUTH_USER_MODEL),
            preserve_default=True,
        ),
    ]
