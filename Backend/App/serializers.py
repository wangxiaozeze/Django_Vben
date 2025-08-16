from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.models import Group, Permission
from .models import *

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    confirmPassword = serializers.CharField(write_only=True)
    
    class Meta:
        model = User
        fields = ('username', 'password', 'confirmPassword')
    
    def validate(self, attrs):
        if attrs['password'] != attrs['confirmPassword']:
            raise serializers.ValidationError({"confirmPassword": "Passwords do not match."})
        return attrs
    
    def create(self, validated_data):
        validated_data.pop('confirmPassword')
        user = User.objects.create_user(**validated_data)
        return user

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField(write_only=True)
    selectAccount = serializers.CharField(required=False)
    captcha = serializers.BooleanField(required=False)
    
    def validate(self, attrs):
        username = attrs.get('username')
        password = attrs.get('password')
        
        if username and password:
            # 如果前端同时提供了selectAccount和username，优先使用username
            user = authenticate(username=username, password=password)
            if user:
                if not user.is_active:
                    raise serializers.ValidationError("User account is disabled.")
                attrs['user'] = user
                return attrs
            else:
                raise serializers.ValidationError("Invalid username or password.")
        else:
            raise serializers.ValidationError("Must include 'username' and 'password'.")

class UserInfoSerializer(serializers.ModelSerializer):
    roles = serializers.SerializerMethodField()
    
    class Meta:
        model = User
        fields = ('id', 'username', 'avatar', 'realName', 'phone', 'email', 'desc', 'homePath', 'roles')
        
    def get_roles(self, obj):
        return list(obj.groups.values_list('name', flat=True))


class MenuSerializer(serializers.ModelSerializer):
    children = serializers.SerializerMethodField()
    
    class Meta:
        model = Menu
        fields = ('name', 'path', 'component', 'redirect', 'meta', 'children')
    
    def get_children(self, obj):
        children = obj.children.all().order_by('order')
        return MenuSerializer(children, many=True).data

class GroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = Group
        fields = ('id', 'name')

class PermissionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permission
        fields = ('id', 'name', 'codename', 'content_type')

class UserManagementSerializer(serializers.ModelSerializer):
    groups = GroupSerializer(many=True, read_only=True)
    user_permissions = PermissionSerializer(many=True, read_only=True)
    gender_display = serializers.CharField(source='get_gender_display', read_only=True)
    
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'realName', 'phone', 'avatar', 'desc', 'gender', 'gender_display',
                 'is_active', 'is_staff', 'is_superuser', 'date_joined', 'last_login',
                 'groups', 'user_permissions')
        read_only_fields = ('date_joined', 'last_login')

class UserUpdateSerializer(serializers.ModelSerializer):
    groups = serializers.PrimaryKeyRelatedField(queryset=Group.objects.all(), many=True, required=False)
    user_permissions = serializers.PrimaryKeyRelatedField(queryset=Permission.objects.all(), many=True, required=False)
    
    class Meta:
        model = User
        fields = ('realName', 'email', 'phone', 'desc', 'gender', 'is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')
    
    def update(self, instance, validated_data):
        groups = validated_data.pop('groups', None)
        user_permissions = validated_data.pop('user_permissions', None)
        
        # Update basic fields
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        
        # Update groups if provided
        if groups is not None:
            instance.groups.set(groups)
        
        # Update user permissions if provided
        if user_permissions is not None:
            instance.user_permissions.set(user_permissions)
        
        return instance

class ResetPasswordSerializer(serializers.Serializer):
    new_password = serializers.CharField(write_only=True, min_length=8)

class UserCreateSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True, min_length=8)
    groups = serializers.PrimaryKeyRelatedField(queryset=Group.objects.all(), many=True, required=False)
    user_permissions = serializers.PrimaryKeyRelatedField(queryset=Permission.objects.all(), many=True, required=False)
    
    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'realName', 'phone', 'desc', 'gender',
                 'is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')
    
    def create(self, validated_data):
        groups = validated_data.pop('groups', [])
        user_permissions = validated_data.pop('user_permissions', [])
        password = validated_data.pop('password')
        
        # 创建用户
        user = User.objects.create_user(password=password, **validated_data)
        
        # 设置用户组和权限
        if groups:
            user.groups.set(groups)
        if user_permissions:
            user.user_permissions.set(user_permissions)
        
        return user
