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
                ('id', models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID')),
                ('password', models.CharField(max_length=128, verbose_name='password')),
                ('last_login', models.DateTimeField(default=django.utils.timezone.now, verbose_name='last login')),
                ('username', models.CharField(unique=True, max_length=50, verbose_name='Username')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('surname', models.CharField(max_length=50, verbose_name='Surname')),
                ('email', models.EmailField(unique=True, max_length=255, verbose_name='Email')),
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
                ('id', models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID')),
                ('name', models.CharField(blank=True, null=True, max_length=50, verbose_name='Name')),
                ('time', models.DateField(verbose_name='Time')),
                ('type',
                 models.CharField(choices=[('D', 'Dinning'), ('M', 'Meal')], max_length=50, verbose_name='Type')),
                ('joinable', models.BooleanField(default=False, verbose_name='Joinable')),
                ('owner', models.ForeignKey(related_name='owner', to=settings.AUTH_USER_MODEL)),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.CreateModel(
            name='EventRequest',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID')),
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
                ('id', models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID')),
                ('status',
                 models.CharField(choices=[('P', 'Pending'), ('D', 'Declined'), ('A', 'Accepted')], max_length=50,
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
            name='Restaurant',
            fields=[
                ('id', models.AutoField(primary_key=True, serialize=False, auto_created=True, verbose_name='ID')),
                ('name', models.CharField(max_length=50, verbose_name='Name')),
                ('latitude', models.CharField(blank=True, null=True, max_length=50, verbose_name='Latitude')),
                ('longitude', models.CharField(blank=True, null=True, max_length=50, verbose_name='Longitude')),
            ],
            options={
            },
            bases=(models.Model,),
        ),
        migrations.AddField(
            model_name='event',
            name='participants',
            field=models.ManyToManyField(blank=True, to='api.Restaurant', related_name='participants', null=True),
            preserve_default=True,
        ),
        migrations.AddField(
            model_name='event',
            name='restaurant',
            field=models.ForeignKey(related_name='restaurant', to='api.Restaurant'),
            preserve_default=True,
        ),
    ]
