__author__ = 'Hakan Uyumaz'

from django.shortcuts import render, redirect

from ..forms.user_form import LetsEatUserCreationForm


def registration_view(request):
    if request.user.is_authenticated():
        return redirect("homepage")
    else:
        if request.method == "POST":
            form = LetsEatUserCreationForm(request.POST)

            if form.errors:
                print form.errors
                return render(request, 'register.html', dict(errors=form.errors))

            user = form.save(commit=False)
            user.is_active = True
            user.save()

            return redirect("homepage")
        else:
            return render(request, 'register.html')