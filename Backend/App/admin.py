from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, Menu

@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('username', 'email', 'realName', 'is_staff', 'is_active')
    list_filter = ('is_staff', 'is_superuser', 'is_active')
    fieldsets = BaseUserAdmin.fieldsets + (
        ('个人信息', {'fields': ('avatar', 'realName', 'phone','desc', 'homePath')}),
    )
    filter_horizontal = ('groups', 'user_permissions')


@admin.register(Menu)
class MenuAdmin(admin.ModelAdmin):
    list_display = ('name', 'path', 'parent', 'order')
    list_filter = ('parent',)
    search_fields = ('name', 'path')