__author__ = 'bahadirkirdan & Burak Atalay'

from django.test import TestCase
from .models.user import User
from .models.friendship_request import FriendshipRequest
from .models.restaurant import Restaurant
from .models.event import Event
from .models.event_request import EventRequest
from .models.comment import Comment
from .models.group import Group
import urllib.parse
import http.client
import json
import datetime



class modelTest(TestCase):
    def setUp(self):

        #Add Users
        omer = User.objects.create_superuser(username="kalaomer", name="Omer", surname="Kala", email="kalaomer@hotmail.com", password="123456")
        taha = User.objects.create_user(username="tdgunes", name="Taha Dogan", surname="Gunes", email="tdgunes@gmail.com", password="123456")
        bilal = User.objects.create_user(username="aby", name="Ahmet Bilal", surname="Yildiz", email="aby@hotmail.com", password="123456")
        didem = User.objects.create_user(username="didi", name="Didem", surname="Kayikci", email="didemk@gmail.com", password="123456")
        zeynep = User.objects.create_user(username="zeyno", name="Zeynep", surname="Ozfici", email="zeynepozfici@gmail.com", password="123456")
        simge = User.objects.create_user(username="simge", name="Simge", surname="Sayin", email="simgesayin@yahoo.com", password="123456")

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
        subway = Restaurant(name='Subway', latitude='41.086840', longitude='29.006916')
        subway.save()

        capitol = Restaurant(name='Capitol', latitude='41.034564', longitude='29.098324')
        capitol.save()

        metro_city = Restaurant(name='Metro City', latitude='41.014599', longitude='29.032563')
        metro_city.save()


        #Add Events
        subway_meal = Event(owner=omer, name='Subway de ogle yemegi', type='M', restaurant=subway, joinable=True)
        subway_meal.save()
        subway_meal.participants.add(taha)
        subway_meal.participants.add(simge)


        metro_city_dinning = Event(owner=zeynep, name='Metro City de aksam yemegi', type='D', restaurant=metro_city, joinable=True)
        metro_city_dinning.save()
        metro_city_dinning.participants.add(simge)
        metro_city_dinning.participants.add(didem)


        capitol_meal = Event(owner=simge, name="Capitolde mevzu var", type='M', restaurant=capitol, joinable=False)
        capitol_meal.save()
        capitol_meal.participants.add(bilal)
        capitol_meal.participants.add(omer)



        #Add Event Requests
        subway_request = EventRequest(status='P', event=subway_meal, guest=bilal)
        subway_request.save()

        metro_city_request = EventRequest(status='A', event=metro_city_dinning, guest=didem)
        metro_city_request.save()

        capitol_request = EventRequest(status='D', event=capitol_meal, guest=omer)
        capitol_request.save()


        #Add Group
        ozu_group = Group(name='Ozyegin Grubu', owner=omer)
        ozu_group.save()
        ozu_group.members.add(taha)
        ozu_group.members.add(bilal)




        agile_group = Group(name='CS 476 | Agile', owner=didem)
        agile_group.save()
        agile_group.members.add(simge)
        agile_group.members.add(bilal)




        #Add Comments
        comment = Comment(owner=omer, time=datetime.datetime.now().time(), event=subway_meal, is_event_comment=True, content="Yemek cok guzeldi")
        comment.save()
        comment.likes.add(bilal)






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
            {"username": "tdgunes", }
        )
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
            {"username": "aby", }
        )
        response = self.make_request(params, "/api/get_friends/", "POST")
        self.assertEqual(response["status"], "success")


    def test_get_friend_requests(self):
        params = urllib.parse.urlencode(
            {"username": "aby", }
        )
        response = self.make_request(params, "/api/get_friend_requests/", "POST")
        self.assertEqual(response["status"], "success")

        params = urllib.parse.urlencode(
                {
                  "username": "didi",
                })
        response = self.make_request(params, "/api/get_friend_requests/", "POST")
        self.assertEqual(response["status"], "failed")


    def test_add_member(self):

        agile_group_id = Group.objects.get(name="agile_group").id

        #Missing group id
        params = urllib.parse.urlencode(
            {"group_id": "",
             "username": "didi",
             "member": "kalaomer"
             }
        )
        response = self.make_request(params, "/api/add_group_member/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing username
        params = urllib.parse.urlencode(
            {"group_id": agile_group_id,
             "username": "",
             "member": "kalaomer"
             }
        )
        response = self.make_request(params, "/api/add_group_member/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing member
        params = urllib.parse.urlencode(
            {"group_id": agile_group_id,
             "username": "didi",
             "member": ""
             }
        )
        response = self.make_request(params, "/api/add_group_member/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"group_id": agile_group_id,
             "username": "didi",
             "member": "kalaomer"
             }
        )
        response = self.make_request(params, "/api/add_group_member/", "POST")
        self.assertEqual(response["status"], "success")


    def test_remove_member(self):

        agile_group_id = Group.objects.get(name="agile_group").id

        #Missing member
        params = urllib.parse.urlencode(
            {"group_id": agile_group_id,
             "member": ""
             }
        )
        response = self.make_request(params, "/api/remove_group_member/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing group id
        params = urllib.parse.urlencode(
            {"group_id": "",
             "member": "didi"
             }
        )
        response = self.make_request(params, "/api/remove_group_member/", "POST")
        self.assertEqual(response["status"], "failed")


        params = urllib.parse.urlencode(
            {"group_id": agile_group_id,
             "member": "didi"
             }
        )
        response = self.make_request(params, "/api/remove_group_member/", "POST")
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
        self.assertEqual(superuser.name, "Omer")

    def test_superuser_has_username(self):
        superuser = User.objects.get(email="kalaomer@hotmail.com")
        self.assertEqual(superuser.username, "kalaomer")




    #Test User Credentials
    def test_user_is_active(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.is_active, False)

    def test_user_has_name(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.name, "Taha Dogan")

    def test_user_has_surname(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.surname, "Gunes")

    def test_user_has_email(self):
        user = User.objects.get(username="tdgunes")
        self.assertEqual(user.email, "tdgunes@gmail.com")

    def test_user_has_username(self):
        user = User.objects.get(email="tdgunes@gmail.com")
        self.assertEqual(user.username, "tdgunes")

    def create_event_test(self):
        hakan = User.objects.get(name="hakanuyumaz")
        subway = Restaurant.objects.get(name="Subway")

        #Missing username
        params = urllib.parse.urlencode(
            {"owner_id": hakan.id,
             "username": '',
             "type": 'D',
             "joinable": '1',
             "start_time": datetime.datetime.now()}
        )

        response = self.make_request(params, "/api/create_event/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing type
        params = urllib.parse.urlencode(
            {"owner_id": hakan.id,
             "username": subway.id,
             "type": '',
             "joinable": '1',
             "start_time": datetime.datetime.now()}
        )

        response = self.make_request(params, "/api/create_event/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing joinable
        params = urllib.parse.urlencode(
            {"owner_id": hakan.id, "username": subway.id, "type": 'D', "joinable": '',
             "start_time": datetime.datetime.now()}
        )

        response = self.make_request(params, "/api/create_event/", "POST")
        self.assertEqual(response["status"], "failed")

        #Missing start time
        params = urllib.parse.urlencode(
            {"owner_id": hakan.id, "username": subway.id, "type": 'D', "joinable": '1', "start_time": ''}
        )

        response = self.make_request(params, "/api/create_event/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"owner_id": hakan.id, "username": subway.id, "type": 'D', "joinable": '1',
             "start_time": datetime.datetime.now()}
        )

        response = self.make_request(params, "/api/create_event/", "POST")
        self.assertEqual(response["status"], "success")

    def invite_event_test(self):
        metro_city_event = Event.objects.get(name="Metro City de aksam yemegi")

        # Missing event
        params = urllib.parse.urlencode(
            {"event": '', "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/invite_event/", "POST")
        self.assertEqual(response["status"], "failed")

        # Missing username
        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": ''}
        )

        response = self.make_request(params, "/api/invite_event/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/invite_event/", "POST")
        self.assertEqual(response["status"], "success")

    def accept_event_test(self):
        metro_city_event = Event.objects.get(name="Metro City de aksam yemegi")

        # Missing event
        params = urllib.parse.urlencode(
            {"event": '', "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/accept_event/", "POST")
        self.assertEqual(response["status"], "failed")

        # Missing username
        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": ''}
        )

        response = self.make_request(params, "/api/accept_event/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/accept_event/", "POST")
        self.assertEqual(response["status"], "success")

    def reject_event_test(self):
        metro_city_event = Event.objects.get(name="Metro City de aksam yemegi")

        # Missing event
        params = urllib.parse.urlencode(
            {"event": '', "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/reject_event/", "POST")
        self.assertEqual(response["status"], "failed")

        # Missing username
        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": ''}
        )

        response = self.make_request(params, "/api/reject_event/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"event": metro_city_event.id, "username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/reject_event/", "POST")
        self.assertEqual(response["status"], "success")

    def get_owned_events_test(self):
        # Missing username
        params = urllib.parse.urlencode(
            {"username": ''}
        )

        response = self.make_request(params, "/api/get_owned_events/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"username": 'tdgunes'}
        )

        response = self.make_request(params, "/api/get_owned_events/", "POST")
        self.assertEqual(response["status"], "success")

    def get_event_test(self):

        metro_city_event = Event.objects.get(name="Metro City de aksam yemegi")

        # Missing event
        params = urllib.parse.urlencode(
            {"event": ''}
        )

        response = self.make_request(params, "/api/get_event/", "POST")
        self.assertEqual(response["status"], "failed")

        params = urllib.parse.urlencode(
            {"event": metro_city_event.id}
        )

        response = self.make_request(params, "/api/get_event/", "POST")
        self.assertEqual(response["status"], "success")

