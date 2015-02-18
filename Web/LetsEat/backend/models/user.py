__author__ = 'Hakan Uyumaz'

import random
import datetime
import pytz

from django.db import models

from django.contrib.auth.models import (
    BaseUserManager, AbstractBaseUser
)


class LetsEatUserManager(BaseUserManager):
    def create_user(self, name=None, surname=None, email=None, password=None):
        if not (name and surname and password and email):
            raise ValueError('An user requires name, surname, email, password')

        user = self.model(
            name=name.title(),
            surname=surname.title(),
            email=self.normalize_email(email),
            activation_key=self.generate_token_with_email(),
            activation_expire_date=datetime.datetime.now(pytz.utc) + datetime.timedelta(2),
        )

        user.is_active = False
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, name=None, surname=None, email=None, password=None):
        doctor = self.create_user(
            name=name,
            surname=surname,
            email=email,
            password=password
        )

        doctor.is_active = True
        doctor.is_admin = True
        doctor.save(using=self._db)
        return doctor

    def generate_token(self):
        activation_key = str(random.random()).encode('utf8')
        return activation_key


class LetsEatUser(AbstractBaseUser):
    name = models.CharField('Name', max_length=50)
    surname = models.CharField('Surname', max_length=50)

    email = models.EmailField(
        verbose_name='Email',
        max_length=255,
        unique=True
    )

    photo = models.ImageField(upload_to='uploaded/user_photos/%Y/%m/%d/%h/', null=True, blank=True)

    activation_key = models.CharField(max_length=40, blank=True)
    activation_expire_date = models.DateTimeField()
    is_active = models.BooleanField(default=True)

    is_admin = models.BooleanField(default=False)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['name', 'surname']

    objects = UserManager()

    class Meta:
        pass