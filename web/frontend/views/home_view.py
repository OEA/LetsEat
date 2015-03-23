__author__ = 'Burak Atalay'

from django.shortcuts import render, redirect

def homepage(request):
    context = None
    if request.user.is_authenticated():
        user = request.user
        context = {'user' : user, 'username': user.username}
        return render(request, "./homepage.html", context)
    else:
        return redirect("../")
