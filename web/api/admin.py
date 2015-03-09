from django.contrib import admin
from .models.user import User

class UserAdmin(admin.ModelAdmin):

    list_display = ('name', 'surname', 'email', 'username')

    fieldsets = [
        ('Personal Infromation',    {'fields': ['photo', 'name', 'surname', 'password', 'username']}),
        ('Contact Information',     {'fields': ['email']}),
        ('Admin Privilage',         {'fields': ['is_admin', 'is_active']}),
    ]


admin.site.register(User, UserAdmin)