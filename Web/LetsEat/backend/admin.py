from django.contrib import admin
from .models.user import LetsEatUser

class LetsEatUserAdmin(admin.ModelAdmin):
    fieldsets = [
        ('Personal Infromation',    {'fields': ['photo', 'name', 'surname']}),
        ('Contact information',     {'fields': ['email']}),
    ]


admin.site.register(LetsEatUser, LetsEatUserAdmin)
