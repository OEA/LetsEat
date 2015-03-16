__author__ = 'ynsy'

from django.test import TestCase
from .models.user import User
import urllib.parse
import http.client
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


    def test_user_login(self):

        params = urllib.parse.urlencode(
                { "password": '1',
                  "username": 'hakanuyumaz'
                })

        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
        conn = http.client.HTTPConnection('127.0.0.1', 8000)
        conn.request("POST", "/api/login/", params, headers)
        r1 = conn.getresponse()
        data = r1.read()
        dict = json.loads(data.decode("utf-8"))
        print(dict)
        self.assertEqual(dict["status"], "success")


    def test_user_logout(self):
        response = self.send_post({}, "/api/logout/")

        self.assertEqual(response["status"], "success")

    def test_user_registeration(self):

        params = urllib.parse.urlencode(
                { "name": "Hakan",
                  "surname": "Uyumaz",
                  "email": "hakan.uyumaz@ozu.edu.tr",
                  "password": "1",
                  "username": "hakanuyumaz"
                })

        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
        conn = http.client.HTTPConnection('127.0.0.1', 8000)
        conn.request("POST", "/api/register/", params, headers)
        r1 = conn.getresponse()
        data = r1.read()
        dict = json.loads(data.decode("utf-8"))

        self.assertEqual(dict["status"], "success")




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


