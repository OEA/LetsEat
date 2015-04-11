# -*- coding: utf-8 -*-
from __future__ import unicode_literals

from django.db import models, migrations
import django.utils.timezone
from django.conf import settings

from . import create_base_database, delete_base_database


class Migration(migrations.Migration):
    dependencies = [
    ]

    operations = [
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('password', models.CharField(verbose_name='password', max_length=128)),
                ('last_login', models.DateTimeField(verbose_name='last login', default=django.utils.timezone.now)),
                ('username', models.CharField(unique=True, verbose_name='Username', max_length=50)),
                ('name', models.CharField(verbose_name='Name', max_length=50)),
                ('surname', models.CharField(verbose_name='Surname', max_length=50)),
                ('facebook_id', models.CharField(unique=True, verbose_name='Facebook ID', max_length=50, null=True)),
                ('email', models.EmailField(unique=True, verbose_name='Email', max_length=255)),
                ('photo', models.ImageField(blank=True, upload_to='uploaded/user_photos/%Y/%m/%d/%h/', null=True)),
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
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('time', models.DateTimeField(verbose_name='Comment Time', auto_now_add=True, null=True)),
                ('is_event_comment', models.BooleanField(verbose_name='Is Event Comment', default=True)),
                ('content', models.CharField(blank=True, verbose_name='Content', max_length=1000, null=True)),
                ('comment',
                 models.ForeignKey(related_name='Commented Comment', blank=True, to='api.Comment', null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Event',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('name', models.CharField(blank=True, verbose_name='Name', max_length=50, null=True)),
                ('start_time', models.DateTimeField(verbose_name='Start_Time', auto_now_add=True, null=True)),
                ('type',
                 models.CharField(verbose_name='Type', choices=[('D', 'Dinning'), ('M', 'Meal')], max_length=50)),
                ('restaurant', models.CharField(blank=True, verbose_name='Restaurant', max_length=100, null=True)),
                ('joinable', models.BooleanField(verbose_name='Joinable', default=False)),
                ('owner', models.ForeignKey(related_name='owner', to=settings.AUTH_USER_MODEL)),
                ('participants',
                 models.ManyToManyField(related_name='participants', blank=True, to=settings.AUTH_USER_MODEL,
                                        null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('status', models.CharField(verbose_name='Event Request Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                            max_length=50, default='P')),
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
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('status', models.CharField(verbose_name='Status',
                                            choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')],
                                            max_length=50)),
                ('date', models.DateField(verbose_name='Date', auto_now_add=True)),
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
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('name', models.CharField(blank=True, verbose_name='Group Name', max_length=50, null=True)),
                ('members',
                 models.ManyToManyField(related_name='members', blank=True, to=settings.AUTH_USER_MODEL, null=True)),
                ('owner',
                 models.ForeignKey(related_name='group owner', blank=True, to=settings.AUTH_USER_MODEL, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='Restaurant',
            fields=[
                ('id', models.AutoField(verbose_name='ID', serialize=False, primary_key=True, auto_created=True)),
                ('name', models.CharField(verbose_name='Name', max_length=100)),
                ('latitude', models.CharField(blank=True, verbose_name='Latitude', max_length=50, null=True)),
                ('longitude', models.CharField(blank=True, verbose_name='Longitude', max_length=50, null=True)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='comment',
            name='event',
            field=models.ForeignKey(related_name='Commented Event', blank=True, to='api.Event', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='comment',
            name='likes',
            field=models.ManyToManyField(related_name='Likes', blank=True, to=settings.AUTH_USER_MODEL, null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='comment',
            name='owner',
            field=models.ForeignKey(related_name='Comment Owner', to=settings.AUTH_USER_MODEL),
            preserve_default=True,
        ),
        migrations.RunPython(create_base_database, reverse_code=delete_base_database),
    ]
