__author__ = 'ynsy'

from django.test import TestCase
from .user import User
class modelTest(TestCase):
    def setUp(self):
        #UserManager.create_superuser("ynsy", "yunus","yilmaz", "yunus.yilmaz@ozu.edu.tr","LetsEat")
        User.name = "yunus"
        User.surname = "yilmaz"
        User.username = "ynsy"
        User.email = "yunus.yilmaz@ozu.edu.tr"
        User.password = "123456"

    def test_username(self):
        self.assertEqual(User.username, 'ynsy')

    def test_name(self):
        self.assertEqual(User.name, 'yunus')

    def test_surname(self):
        self.assertEqual(User.surname, 'yilmaz')

    def test_email(self):
        self.assertEqual(User.email, 'yunus.yilmaz@ozu.edu.tr')

    def test_password(self):
        self.assertEqual(User.password, '123456')


