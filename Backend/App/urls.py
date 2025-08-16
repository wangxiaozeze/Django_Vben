# urls.py
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import *
from django.conf.urls.static import static
from django.conf import settings

router = DefaultRouter()

urlpatterns = [
    path('', include(router.urls)),

    path('auth/login', AuthViewSet.as_view({'post': 'login'})),
    path('auth/register', AuthViewSet.as_view({'post': 'register'})),
    path('auth/logout', AuthViewSet.as_view({'post': 'logout'})),
    path('auth/refresh', AuthViewSet.as_view({'post': 'refresh'})),
    path('auth/codes', AuthViewSet.as_view({'get': 'codes'})),

    path('user/info', UserViewSet.as_view({'get': 'info'})),
    path('user/update-info', UserViewSet.as_view({'post': 'update_info'})),
    path('user/change-password', UserViewSet.as_view({'post': 'change_password'})),
    path('user/upload-avatar', UserViewSet.as_view({'post': 'upload_avatar'})),

    path('menu/all', MenuViewSet.as_view({'get': 'all'})),

    # User management endpoints
    path('users/', UserManagementViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('users/<int:pk>/', UserManagementViewSet.as_view({'get': 'retrieve', 'put': 'update', 'patch': 'partial_update', 'delete': 'destroy'})),
    path('users/<int:pk>/reset-password', UserManagementViewSet.as_view({'post': 'reset_password'})),
    path('users/<int:pk>/toggle-status', UserManagementViewSet.as_view({'post': 'toggle_status'})),
    
    # Groups and permissions endpoints
    path('groups/', GroupViewSet.as_view({'get': 'list'})),
    path('permissions/', PermissionViewSet.as_view({'get': 'list'})),

]+static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)