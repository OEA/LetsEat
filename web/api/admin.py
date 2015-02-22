from django.contrib import admin
from .models.user import User

class UserAdmin(admin.ModelAdmin):
    fieldsets = [
        ('Personal Infromation',    {'fields': ['photo', 'name', 'surname']}),
        ('Contact information',     {'fields': ['email']}),
    ]


admin.site.register(User, UserAdmin)
