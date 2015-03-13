__author__ = 'Omer Aslan'

import http.client,urllib.parse,json

from django.shortcuts import render, redirect
from django.http import HttpResponse

from django.contrib.auth import authenticate, login



def registration_view(request):
    if request.user.is_authenticated():
        return redirect("../homepage")
    else:
        if request.method == "POST":
            name = request.POST['name']
            surname = request.POST['surname']
            email = request.POST['email']
            password = request.POST['password']
            username = request.POST['username']

            params = urllib.parse.urlencode(
                {'name': name,
                 'surname': surname,
                 'email': email,
                 'password': password,
                 'username': username,
                })


            headers={"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
            conn = http.client.HTTPConnection('127.0.0.1', 8000)
            conn.request("POST", "/api/register/", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            return HttpResponse(data)
        else:
            return render(request, "./register.html")



def login_view(request):
    if request.user.is_authenticated():
        return redirect("../homepage")
    else:
        if request.method == "POST":
            username = request.POST['username']
            password = request.POST['password']
            params = urllib.parse.urlencode({'username': username, 'password': password})
            headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
            conn = http.client.HTTPConnection('127.0.0.1',8000)
            conn.request("POST", "/api/login/", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            dict = json.loads(data.decode("utf-8"))
            print(dict['status'])
            user = None
            if dict['status'] == "success":
                print("successfully logged in")
                user = authenticate(username=username, password=password)
                login(request, user)
                print(user.email)
                return redirect("../homepage")
            if user is None:
                return render(request, "./login.html")
            return redirect("../homepage")
        else:
            return render(request, "./login.html")



def profile(request, username):
    print(username)
    user = None
    if request.user.is_authenticated():
        #It will be replaced by web service when it runs
        user = request.user
        context = {'user' : user}
        return render(request, 'profile.html', context)
    else:
        return redirect("../login")



def edit(request, uname):
    username = None
    user = None
    if request.user.is_authenticated():
        #It will be replaced by web service when it runs
        if request.method == "POST":
            password = request.POST['password']
            name = request.POST['name']
            surname = request.POST['surname']
            params = urllib.parse.urlencode({'name' : name, 'surname': surname})
            headers = {"Content-type": "application/x-www-form-urlencoded","Accept": "text/plain"}
            conn = http.client.HTTPConnection('127.0.0.1',8000)
            conn.request("POST", "/api/profile/"+uname+"/edit", params, headers)
            r1 = conn.getresponse()
            data = r1.read()
            user = request.user
            context = {'user' : user}
            return render(request, 'profile_edit.html', context)
        else:
            user = request.user
            context = {'user' : user}
            return render(request, 'profile_edit.html', context)
    else:
        return redirect("../login")
def test(request):
    return HttpResponse("Successful")

def home_view(request):
    if request.user.is_authenticated():
        return redirect("../profile/"+request.user.username)
    #     conn =  http.client.HTTPConnection('127.0.0.1',8000)
    #     conn.request("POST", "/api/profile/(?P<username>\w+)/$")
    #     r1 = conn.getresponse()
    #     data = r1.read()
    #
    #     return HttpResponse(data)
    else:
        return redirect("../login")