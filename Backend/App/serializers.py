from rest_framework import serializers
from django.contrib.auth import authenticate
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
