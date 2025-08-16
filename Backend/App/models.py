from django.db import models
from django.contrib.auth.models import AbstractUser, Group, Permission
from django.utils.translation import gettext_lazy as _

# Create your models here.
class User(AbstractUser):
    GENDER_CHOICES = [
        ('M', '男'),
        ('F', '女'),
        ('O', '其他'),
    ]
    
    realName = models.CharField(_("Real name"), max_length=150, blank=True)
    phone = models.CharField(_("Phone"), max_length=150, blank=True)
    avatar = models.ImageField(upload_to='avatars/', null=True, blank=True)
    gender = models.CharField(_("Gender"), max_length=1, choices=GENDER_CHOICES, blank=True, null=True)
    
    desc = models.TextField(_("Description"), blank=True)
    homePath = models.CharField(_("Home path"), max_length=255, default="/profile/info")

    groups = models.ManyToManyField(
        'auth.Group',
        related_name='app_user_groups',  # Unique related_name
        blank=True,
        help_text='The groups this user belongs to.',
        verbose_name='groups',
    )
    user_permissions = models.ManyToManyField(
        'auth.Permission',
        related_name='app_user_permissions',  # Unique related_name
        blank=True,
        help_text='Specific permissions for this user.',
        verbose_name='user permissions',
    )
    
    class Meta:
        verbose_name = _("user")
        verbose_name_plural = _("users")

class Menu(models.Model):
    name = models.CharField(max_length=100)
    path = models.CharField(max_length=255)
    component = models.CharField(max_length=255,blank=True,null=True)
    redirect = models.CharField(max_length=255, blank=True)
    meta = models.JSONField(default=dict)
    parent = models.ForeignKey('self', on_delete=models.CASCADE, null=True, blank=True, related_name='children')
    order = models.IntegerField(default=0)
    groups = models.ManyToManyField(Group, related_name='menus')

    class Meta:
        verbose_name = '菜单'
        verbose_name_plural = '菜单'
    
    def __str__(self):
        return self.name