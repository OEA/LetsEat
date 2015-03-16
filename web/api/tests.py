__author__ = 'ynsy'

from django.test import TestCase
from .models.user import User
import json



class modelTest(TestCase):
    def setUp(self):


        omer = User.objects.create_superuser("kalaomer", "Ömer", "Kala", "kalaomer@hotmail.com", "123456")
        taha = User.objects.create_user("tdgunes", "Taha Doğan", "Güneş", "tdgunes@gmail.com", "123456")

        omer.save()
        taha.save()


    def send_post(self, data, url):
        response = self.client.post(url, json.dumps(data), "application/x-www-form-urlencoded",
                                    HTTP_X_REQUESTED_WITH='XMLHttpRequest').content.decode("utf-8")
        response = json.loads(response)
        return response


    def test_super_login(self):
        data = {"username": "kalaomer",
                "password": "123456"
                }
        response = self.send_post(data, "/api/login/")

        self.assertEqual(response, "success")


    def test_registeration(self):
        data = {"name": "Ömer",
                "surname": "Kala",
                "email": "kalaomer@hotmail.com",
                "password": "123456",
                "username": "kalaomer"
                }
        response = self.client.post("/api/registration/", json.dumps(data), "application/x-www-form-urlencoded",
                                    HTTP_X_REQUESTED_WITH='XMLHttpRequest').content.decode("utf-8")
        print(response)
        response = json.loads(response)

        self.assertEqual(response["status"], "success")




    #Test Super User Credentials
    def test_superuser_is_active(self):
        superuser = User.objects.get(username="kalaomer")
        self.assertEqual(superuser.is_active, True)

    def test_superuser_has_surname(self):
        superuser = User.objects.get(username="kalaomer")
        self.assertEqual(superuser.surname, "Kala")

    def test_superuser_has_email(self):
        superuser = User.objects.get(username="kalaomer")
        self.assertEqual(superuser.email, "kalaomer@hotmail.com")

    def test_superuser_has_name(self):
        superuser = User.objects.get(username="kalaomer")
        self.assertEqual(superuser.name, "Ömer")

    def test_superuser_has_username(self):
        superuser = User.objects.get(email="kalaomer@hotmail.com")
        self.assertEqual(superuser.username, "kalaomer")




    #Test User Credentials
    def test_user_is_active(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.is_active, False)

    def test_user_has_name(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.name, "Taha Doğan")

    def test_user_has_surname(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.surname, "Güneş")

    def test_user_has_email(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.email, "tdgunes@gmail.com")

    def test_user_has_username(self):
        user = User.objects.get(email="tdgunes@gmail.com")
        self.assertEqual(user.username, "tdgunes")


