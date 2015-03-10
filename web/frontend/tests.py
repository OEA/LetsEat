from django.test import TestCase

# Create your tests here.

#from .views import user_views_
from ..api.models.user import UserManager
from django.test import TestCase
import http.client,urllib.parse,json

class frontendTest(TestCase):
    def setUp(self):
        ynsy = UserManager.create_superuser("ynsy", "yunus","yilmaz", "yunus.yilmaz@ozu.edu.tr","123456")

    def test_super_login(self):
        params = urllib.parse.urlencode({'username': "ynsy", 'password': "123456"})
        headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
        conn = http.client.HTTPConnection('127.0.0.1',8000)
        conn.request("POST", "/api/login/", params, headers)
        r1 = conn.getresponse()
        data = r1.read()
        dict = json.loads(data.decode("utf-8"))
        self.assertEqual(dict['status'], "success")
