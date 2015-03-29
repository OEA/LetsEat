__author__ = 'bahadirkirdan'

from django.test import TestCase
from .models.user import User
from .models.friendship_request import FriendshipRequest
from .models.restaurant import Restaurant
from .models.event import Event
from .models.event_request import EventRequest
import urllib.parse
import http.client
import json



class modelTest(TestCase):
    def setUp(self):

        #Add Users
        omer = User.objects.create_superuser("kalaomer", "Ömer", "Kala", "kalaomer@hotmail.com", "123456")
        taha = User.objects.create_user("tdgunes", "Taha Doğan", "Güneş", "tdgunes@gmail.com", "123456")
        bilal = User.objects.create_user("aby", "Ahmet Bilal", "Yıldız", "aby@hotmail.com", "123456")
        didem = User.objects.create_user("didi", "Didem", "Kayıkçı", "didemk@gmail.com", "123456")
        zeynep = User.objects.create_user("zeyno", "Zeynep", "Özfıçı", "zeynepozfici@gmail.com", "123456")
        simge = User.objects.create_user("simge", "Simge", "Sayın", "simgesayin@yahoo.com", "123456")

        omer.save()
        taha.save()
        bilal.save()
        didem.save()
        zeynep.save()
        simge.save()




        #Add Friend Requests
        friend_request_taha_bilal = FriendshipRequest(sender=taha, receiver=bilal, status='P')
        friend_request_taha_bilal.save()

        friend_request_bilal_didem = FriendshipRequest(sender=bilal, receiver=didem, status='A')
        friend_request_bilal_didem.save()

        friend_request_zeynep_omer = FriendshipRequest(sender=zeynep, receiver=omer, status='R')
        friend_request_zeynep_omer.save()




        #Add Restaurants
        subway = Restaurant('Subway', '41.086840', '29.006916')
        capitol = Restaurant('Capitol', '41.034564', '29.098324')
        metro_city = Restaurant('Metro City', '41.014599', '29.032563')

        subway.save()
        capitol.save()
        metro_city.save()




        #Add Events
        subway_meal = Event(omer, 'Subway de öğle yemeği', 'M', subway, taha, True)
        metro_city_dinning = Event(zeynep, 'Metro City de akşam yemeği', 'D', metro_city, simge, True)
        capitol_meal = Event(simge, "Capitolde mevzu var", 'M', capitol, bilal, False)

        subway_meal.save()
        metro_city_dinning.save()
        capitol_meal.save()



    def send_post(self, data, url):
        response = self.client.post(url, json.dumps(data), "application/x-www-form-urlencoded",
                                    HTTP_X_REQUESTED_WITH='XMLHttpRequest').content.decode("utf-8")
        response = json.loads(response)
        return response

    def make_request(self, params, url, request_method):
        headers = {"Content-type": "application/x-www-form-urlencoded", "Accept": "application/json"}
        connection = http.client.HTTPConnection('127.0.0.1', 8000)
        connection.request(request_method, url, params, headers)
        connection_response = connection.getresponse()
        data = connection_response.read()
        response = json.loads(data.decode("utf-8"))
        return response




    def test_user_login(self):
        params = urllib.parse.urlencode(
                { "password": '1',
                  "username": 'hakanuyumaz'
                })
        response = self.make_request(params, "/api/login/", "POST")
        self.assertEqual(response["status"], "success")

        #Missing password
        params = urllib.parse.urlencode(
                { "password": '',
                  "username": 'hakanuyumaz'
                })
        response = self.make_request(params, "/api/login/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing username
        params = urllib.parse.urlencode(
                { "password": '1',
                  "username": ''
                })
        response = self.make_request(params, "/api/login/", "POST")
        self.assertEqual(response["status"], "failed")



    def test_user_logout(self):
        response = self.send_post({}, "/api/logout/")

        self.assertEqual(response["status"], "success")



    def test_user_registeration(self):
        #Missing name
        params = urllib.parse.urlencode(
                { "name": "",
                  "surname": "Atasoy",
                  "email": "gizem.atasoy@ozu.edu.tr",
                  "password": "1",
                  "username": "gizematasoy"
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "failed")


        #Missing surname
        params = urllib.parse.urlencode(
                { "name": "Gizem",
                  "surname": "",
                  "email": "gizem.atasoy@ozu.edu.tr",
                  "password": "1",
                  "username": "gizematasoy"
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "failed")


        #Missing email
        params = urllib.parse.urlencode(
                { "name": "Gizem",
                  "surname": "Atasoy",
                  "email": "",
                  "password": "1",
                  "username": "gizematasoy"
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "failed")


        #Missing password
        params = urllib.parse.urlencode(
                { "name": "Gizem",
                  "surname": "Atasoy",
                  "email": "gizem.atasoy@ozu.edu.tr",
                  "password": "",
                  "username": "gizematasoy"
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing username
        params = urllib.parse.urlencode(
                { "name": "Gizem",
                  "surname": "Atasoy",
                  "email": "gizem.atasoy@ozu.edu.tr",
                  "password": "1",
                  "username": ""
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "failed")


        gizem_atasoy = User.objects.filter(username="gizematasoy")

        if gizem_atasoy:
            gizem_atasoy.delete()


        params = urllib.parse.urlencode(
                { "name": "Gizem",
                  "surname": "Atasoy",
                  "email": "gizem.atasoy@ozu.edu.tr",
                  "password": "1",
                  "username": "gizematasoy"
                })

        response = self.make_request(params, "/api/register/", "POST")
        self.assertEqual(response["status"], "success")



    def test_search_user(self):

        #Missing username
        params = urllib.parse.urlencode(
                {
                  "username": "",
                })
        response = self.make_request(params, "/api/search/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
                {
                  "username": "hakanuyumaz",
                })
        response = self.make_request(params, "/api/search/", "POST")
        self.assertEqual(response["status"], "success")



    def test_accept_friend_request(self):

        #Pending
        params = urllib.parse.urlencode(
                {
                  "sender": "tdgunes",
                  "receiver": "aby"
                })
        response = self.make_request(params, "/api/accept_friend/", "POST")
        self.assertEqual(response["status"], "success")


        #Accepted
        params = urllib.parse.urlencode(
                {
                  "sender": "aby",
                  "receiver": "didi"
                })
        response = self.make_request(params, "/api/accept_friend/", "POST")
        self.assertEqual(response["status"], "failed")


        #Rejected
        params = urllib.parse.urlencode(
                {
                  "sender": "zeyno",
                  "receiver": "kalaomer"
                })
        response = self.make_request(params, "/api/accept_friend/", "POST")
        self.assertEqual(response["status"], "failed")




    def test_reject_friend_request(self):
        params = urllib.parse.urlencode(
                {
                  "sender": "zeyno",
                  "receiver": "kalaomer"
                })
        response = self.make_request(params, "/api/reject_friend/", "POST")
        self.assertEqual(response["status"], "success")


        #Rejected
        params = urllib.parse.urlencode(
                {
                  "sender": "aby",
                  "receiver": "didi"
                })
        response = self.make_request(params, "/api/reject_friend/", "POST")
        self.assertEqual(response["status"], "failed")


        #Accepted
        params = urllib.parse.urlencode(
                {
                  "sender": "aby",
                  "receiver": "didi"
                })
        response = self.make_request(params, "/api/reject_friend/", "POST")
        self.assertEqual(response["status"], "failed")




    def test_get_friend_list(self):

        #Pending
        params = urllib.parse.urlencode(
                {
                  "username": "tdgunes",
                })
        response = self.make_request(params, "/api/get_friends/", "POST")
        self.assertEqual(response["status"], "failed")

        #Pending
        params = urllib.parse.urlencode(
                {
                  "username": "kalaomer",
                })
        response = self.make_request(params, "/api/get_friends/", "POST")
        self.assertEqual(response["status"], "failed")

        #Accepted
        params = urllib.parse.urlencode(
                {
                  "username": "aby",
                })
        response = self.make_request(params, "/api/get_friends/", "POST")
        self.assertEqual(response["status"], "success")


    def test_get_friend_requests(self):
        params = urllib.parse.urlencode(
                {
                  "username": "aby",
                })
        response = self.make_request(params, "/api/get_friend_requests/", "POST")
        self.assertEqual(response["status"], "success")

        params = urllib.parse.urlencode(
                {
                  "username": "didi",
                })
        response = self.make_request(params, "/api/get_friend_requests/", "POST")
        self.assertEqual(response["status"], "failed")


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


