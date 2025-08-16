from django_filters import rest_framework as filters
from .models import *

class UserFilter(filters.FilterSet):
    username = filters.CharFilter(lookup_expr='icontains')
    email = filters.CharFilter(lookup_expr='icontains')
    realName = filters.CharFilter(lookup_expr='icontains')
    phone = filters.CharFilter(lookup_expr='icontains')
    gender = filters.ChoiceFilter(choices=User.GENDER_CHOICES)
    is_active = filters.BooleanFilter()
    is_staff = filters.BooleanFilter()
    is_superuser = filters.BooleanFilter()
    
    class Meta:
        model = User
        fields = ['username', 'email', 'realName', 'phone', 'gender', 'is_active', 'is_staff', 'is_superuser']

class MenuFilter(filters.FilterSet):
    name = filters.CharFilter(lookup_expr='icontains')
    path = filters.CharFilter(lookup_expr='icontains')
    
    class Meta:
        model = Menu
        fields = ['name', 'path']