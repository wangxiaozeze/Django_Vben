from django_filters import rest_framework as filters
from .models import *

class UserFilter(filters.FilterSet):
    username = filters.CharFilter(lookup_expr='icontains')
    
    class Meta:
        model = User
        fields = ['username']

class MenuFilter(filters.FilterSet):
    name = filters.CharFilter(lookup_expr='icontains')
    path = filters.CharFilter(lookup_expr='icontains')
    
    class Meta:
        model = Menu
        fields = ['name', 'path']