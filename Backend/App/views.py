from rest_framework import viewsets, status, permissions
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import logout
from .serializers import *
from .filters import *
from .pagination import StandardResultsSetPagination

class AuthViewSet(viewsets.ViewSet):
    # 登录不需要认证
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny],url_path='login')
    def login(self, request):
        serializer = LoginSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        
        user = serializer.validated_data['user']
        refresh = RefreshToken.for_user(user)
        
        # 返回格式与前端期望保持一致
        response = Response({
            'code': 0,  # 成功代码
            'data': {
                'accessToken': str(refresh.access_token)
            }
        })
        response.set_cookie(
            'refresh_token',
            str(refresh),
            httponly=True,
            samesite='Lax'
        )
        
        return response
    
    # 登出需要认证
    @action(detail=False, methods=['post'], permission_classes=[permissions.IsAuthenticated],url_path='logout')
    def logout(self, request):
        response = Response({
            'code': 0,
            'data': {"detail": "Successfully logged out."}
        })
        response.delete_cookie('refresh_token')
        logout(request)
        return response
    
    # 刷新令牌不需要认证（因为它使用refresh_token）
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny],url_path='refresh')
    def refresh(self, request):
        refresh_token = request.COOKIES.get('refresh_token')
        
        if not refresh_token:
            return Response(
                {
                    'code': 400,
                    'message': "Refresh token not provided."
                }, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        try:
            refresh = RefreshToken(refresh_token)
            return Response({
                'code': 0,
                'data': str(refresh.access_token),
                'status': 200
            })
        except Exception as e:
            return Response(
                {
                    'code': 401,
                    'message': str(e)
                }, 
                status=status.HTTP_401_UNAUTHORIZED
            )
    
    # 获取访问代码需要认证
    @action(detail=False, methods=['get'], permission_classes=[permissions.IsAuthenticated],url_path='codes')
    def codes(self, request):
        user = request.user
        # 获取用户所有权限代码
        all_permissions = list(user.get_all_permissions())
        
        return Response({
            'code': 0,
            'data': all_permissions
        })
    
    # 注册不需要认证
    # Backend/App/views.py 中的register方法修改
    @action(detail=False, methods=['post'], permission_classes=[permissions.AllowAny],url_path='register')
    def register(self, request):
        serializer = RegisterSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        
        # 只返回注册成功的消息，不返回token
        return Response({
            'code': 0,
            'data': {
                'message': '注册成功，请登录',
                'username': user.username
            }
        }, status=status.HTTP_201_CREATED)

class UserViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserInfoSerializer
    filterset_class = UserFilter
    pagination_class = StandardResultsSetPagination
    permission_classes = [permissions.IsAuthenticated]  # 用户相关API需要认证
    
    @action(detail=False, methods=['get'],url_path='info')
    def info(self, request):
        serializer = UserInfoSerializer(request.user)
        return Response({
            'code': 0,
            'data': serializer.data
        })
        
    @action(detail=False, methods=['post'],url_path='update-info')
    def update_info(self, request):
        user = request.user
        data = request.data
        
        # 更新用户信息
        if 'realName' in data:
            user.realName = data['realName']
        if 'email' in data:
            user.email = data['email']
        if 'desc' in data:
            user.desc = data['desc']
        if 'phone' in data:
            user.phone = data['phone']
            
        user.save()
        if hasattr(user, 'userinfo'):
            user.save()
            
        return Response({
            'code': 0,
            'data': {
                'message': '个人信息更新成功'
            }
        })
        
    @action(detail=False, methods=['post'],url_path='change-password')
    def change_password(self, request):
        user = request.user
        old_password = request.data.get('oldPassword')
        new_password = request.data.get('newPassword')
        
        # 验证旧密码是否正确
        if not user.check_password(old_password):
            return Response({
                'code': 400,
                'data': {
                    'message': '当前密码不正确'
                }
            }, status=400)
            
        # 更新密码
        user.set_password(new_password)
        user.save()
        
        return Response({
            'code': 0,
            'data': {
                'message': '密码修改成功'
            }
        })
        
    @action(detail=False, methods=['post'],url_path='upload-avatar')
    def upload_avatar(self, request):
        user = request.user
        avatar = request.FILES.get('avatar')
        
        if not avatar:
            return Response({
                'code': 400,
                'data': {
                    'message': '未提供头像文件'
                }
            }, status=400)
            
        # 保存头像文件
        import os
        from django.conf import settings
        
        # 确保media/avatars目录存在
        avatar_dir = os.path.join(settings.MEDIA_ROOT, 'avatars')
        os.makedirs(avatar_dir, exist_ok=True)
        
        # 生成文件名并保存文件
        filename = f'avatar_{user.id}_{avatar.name}'
        filepath = os.path.join(avatar_dir, filename)
        
        with open(filepath, 'wb+') as destination:
            for chunk in avatar.chunks():
                destination.write(chunk)
                
        # 更新用户头像URL
        avatar_url = f'/avatars/{filename}'

        user.avatar = avatar_url
        user.save()
        
        return Response({
            'code': 0,
            'data': {
                'message': '头像上传成功',
                'url': avatar_url
            }
        })

class MenuViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = Menu.objects.filter(parent=None).order_by('order')
    serializer_class = MenuSerializer
    filterset_class = MenuFilter
    pagination_class = StandardResultsSetPagination
    permission_classes = [permissions.IsAuthenticated]  # 菜单相关API需要认证
    
    @action(detail=False, methods=['get'],url_path='all')
    def all(self, request):
        user = request.user
        groups = user.groups.all()
        # print(groups)
        menu_ids = set()
        
        for group in groups:
            group_menus = group.menus.all()  # 这里使用了上面添加的related_name
            menu_ids.update(group_menus.values_list('id', flat=True))
        
        menus = Menu.objects.filter(id__in=menu_ids, parent=None).order_by('order')
        serializer = MenuSerializer(menus, many=True)
        # print(serializer.data)
        return Response({
            'code': 0,
            'data': serializer.data
        })
