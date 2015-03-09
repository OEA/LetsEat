__author__ = 'ynsy'

from django.test import TestCase
from .models.user import User
from .models.user import UserManager
from django.shortcuts import render, redirect
from django.contrib.auth import authenticate, login
from django.contrib import auth
from django.http import HttpResponse


class modelTest(TestCase):
    def setUp(self):
        #UserManager.create_superuser("ynsy", "yunus","yilmaz", "yunus.yilmaz@ozu.edu.tr","LetsEat")
        User.name = "yunus"
        User.surname = "yilmaz"
        User.username = "ynsy"
        User.email = "yunus.yilmaz@ozu.edu.tr"
        User.password = "123456"

    def test_usernameEquality(self):
        self.assertEqual(User.username, 'ynsy')

    def test_nameEquality(self):
        self.assertEqual(User.name, 'yunus')

    def test_surnameEquality(self):
        self.assertEqual(User.surname, 'yilmaz')

    def test_emailEquality(self):
        self.assertEqual(User.email, 'yunus.yilmaz@ozu.edu.tr')

    def test_passwordEquality(self):
        self.assertEqual(User.password, '123456')

    def test_usernameNotEqual(self):
        self.assertNotEqual(User.username, 'ynsy2')

    def test_nameNotEqual(self):
        self.assertNotEqual(User.name, 'yunuss')

    def test_surnameNotEqual(self):
        self.assertNotEqual(User.surname, 'yilmz')

    def test_emailNotEqual(self):
        self.assertNotEqual(User.email, 'yns@as.com')

    def test_passwordNotEqual(self):
        self.assertNotEqual(User.password, '123344')

    def test_generateToken(self):
        firstToken = UserManager.generate_token(self)
        secondToken = UserManager.generate_token(self)
        self.assertNotEqual(firstToken, secondToken)

    #def registrationJSONTest(request,self):
    #    username = request.POST['username']
    #    password = request.POST['password']
    #    user = authenticate(username="ynsy", password="123456")
    #
    #    responseJSON = {}
    #    user.is_authenticated()