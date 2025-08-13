<script lang="ts" setup>
import { ref, onMounted, reactive, computed } from 'vue';
import { 
  ElMessage, ElForm, ElFormItem, ElInput, ElButton, ElUpload, 
  ElAvatar, ElDialog, ElCard, ElSlider, ElImage, ElIcon
} from 'element-plus';
import { 
  User, Edit, Message, Cellphone, Camera, Upload
} from '@element-plus/icons-vue';
import { useUserStore } from '@vben/stores';
import type { FormInstance, UploadProps, UploadUserFile, UploadRawFile } from 'element-plus';
import { getUserInfoApi, updateUserInfoApi, uploadAvatarApi } from '#/api/core/user';
import type { UserApi } from '#/api/core/user';

defineOptions({ name: 'ProfileInfo' });

const userStore = useUserStore();
const formRef = ref<FormInstance>();
const loading = ref(false);
const uploadLoading = ref(false);
const avatarUrl = ref('');
const showAvatarUpload = ref(false);

// 个人信息表单
const userForm = ref({
  username: userStore.userInfo?.username || '',
  realName: userStore.userInfo?.realName || '',
  desc: userStore.userInfo?.desc || '',
  avatar: userStore.userInfo?.avatar || '',
  email: userStore.userInfo?.email||'',
  phone: userStore.userInfo?.phone||'',
});

// 获取用户角色文本
const getUserRoleText = () => {
  const roles = userStore.userRoles || [];
  if (roles.includes('管理员')) return '管理员';
  if (roles.includes('排班人员')) return '排班人员';
  if (roles.includes('站台客运员')) return '站台客运员';
  return roles.length > 0 ? roles.join(', ') : '普通用户';
};

const profileCards = computed(() => [
  { label: '用户名', value: userForm.value.username, icon: 'User', color: '#409eff' },
  { label: '邮箱', value: userForm.value.email, icon: 'Message', color: '#67c23a' },
  { label: '手机', value: userForm.value.phone, icon: 'Cellphone', color: '#e6a23c' },
  { label: '用户角色', value: getUserRoleText(), icon: 'User', color: '#f56c6c' },
]);

// 表单规则
const rules = {
  realName: [
    { required: true, message: '请输入真实姓名', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱地址', trigger: 'blur' },
    { type: 'email' as const, message: '请输入正确的邮箱地址', trigger: 'blur' }
  ]
};

// 头像上传
const handleAvatarClick = () => {
  showAvatarUpload.value = true;
};

// 头像上传前校验
const beforeAvatarUpload: UploadProps['beforeUpload'] = (file) => {
  const isJPG = file.type === 'image/jpeg' || file.type === 'image/png';
  const isLt2M = file.size / 1024 / 1024 < 2;

  if (!isJPG) {
    ElMessage.error('头像图片只能是 JPG 或 PNG 格式!');
    return false;
  }
  
  if (!isLt2M) {
    ElMessage.error('头像图片大小不能超过 2MB!');
    return false;
  }
  
  return true;
};

// 自定义上传
const customUpload = async (options: { file: UploadRawFile }) => {
  try {
    const { file } = options;
    if (!file) return;
    
    uploadLoading.value = true;
    
    // 显示上传的图片
    const reader = new FileReader();
    reader.onload = (e) => {
      avatarUrl.value = e.target?.result as string;
    };
    reader.readAsDataURL(file as Blob);
    
    // 创建formData
    const formData = new FormData();
    formData.append('avatar', file);
    
    const res = await uploadAvatarApi(formData);
    
    if (res) {
      userForm.value.avatar = res.url;
      // 更新存储的用户信息
      if (userStore.userInfo) {
        userStore.userInfo.avatar = res.url;
      }
      ElMessage.success(res.message || '头像上传成功');
      showAvatarUpload.value = false;
    }
    
    uploadLoading.value = false;
  } catch (error) {
    console.error('头像上传错误:', error);
    ElMessage.error('头像上传失败');
    uploadLoading.value = false;
  }
};

// 提交表单
const submitForm = async (formEl: FormInstance | undefined) => {
  if (!formEl) return;
  await formEl.validate(async (valid: boolean) => {
    if (valid) {
      loading.value = true;
      try {
        const params: UserApi.UpdateInfoParams = {
          realName: userForm.value.realName,
          email: userForm.value.email,
          phone: userForm.value.phone,
          desc: userForm.value.desc,
        };

        const res = await updateUserInfoApi(params);
        console.log(res);
        
        ElMessage.success(res?.message || '个人信息更新成功');
        
      } catch (error) {
        console.error('更新个人信息错误:', error);
        ElMessage.error('更新失败，请稍后再试');
      } finally {
        loading.value = false;
      }
    }
  });
};

// 获取用户详细信息
const fetchUserDetail = async () => {
  try {
    const res = await getUserInfoApi();
    if (res.code === 0 && res.data) {
      const userInfo = res.data;
      console.log(userInfo);
      userForm.value = {
        username: userInfo.username || '',
        realName: userInfo.realName || '',
        desc: userInfo.desc || '',
        avatar: userInfo.avatar || '',
        email: userInfo.email || '',
        phone: userInfo.phone || '',
      };
      
      // 更新用户表单数据，profileCards会自动更新
    }
  } catch (error) {
    console.error('获取用户信息错误:', error);
  }
};

onMounted(() => {
  fetchUserDetail();
});
</script>

<template>
  <div class="profile-info p-6">
    <!-- 头部信息卡片 -->
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6 mb-6">
      <div class="flex flex-col md:flex-row items-center md:items-start">
        <!-- 头像部分 -->
        <div class="relative mb-6 md:mb-0 md:mr-8">
          <ElAvatar :size="120" :src="`/api${userForm.avatar}`" class="shadow-lg">
            <img src="https://cube.elemecdn.com/e/fd/0fc7d20532fdaf769a25683617711png.png" />
          </ElAvatar>
          
          <div class="avatar-edit-overlay" @click="handleAvatarClick">
            <el-icon><Camera /></el-icon>
            <span class="text-xs mt-1">修改头像</span>
          </div>
        </div>
        
        <!-- 个人基本信息 -->
        <div class="flex-1">
          <h1 class="text-2xl font-bold mb-2 text-gray-800 dark:text-white text-center md:text-left">
            {{ userForm.realName || userForm.username }}
          </h1>
          
          <div class="text-gray-500 mb-4 text-center md:text-left">
            {{ userForm.desc || '这个人很懒，还没有填写个人简介' }}
          </div>
          
          <div class="grid grid-cols-1 md:grid-cols-3 gap-4 mt-4">
            <ElCard v-for="(card, index) in profileCards" :key="index" shadow="hover" class="info-card">
              <div class="flex items-center">
                <div class="info-card-icon" :style="{backgroundColor: card.color}">
                  <el-icon>
                    <User v-if="card.icon === 'User'" />
                    <Message v-if="card.icon === 'Message'" />
                    <Cellphone v-if="card.icon === 'Cellphone'" />
                  </el-icon>
                </div>
                <div class="ml-4">
                  <div class="text-sm text-gray-500">{{ card.label }}</div>
                  <div class="font-medium">{{ card.value || '未设置' }}</div>
                </div>
              </div>
            </ElCard>
          </div>
        </div>
      </div>
    </div>
    
    <!-- 详细信息表单 -->
    <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
      <h2 class="text-xl font-bold mb-6 text-gray-800 dark:text-white border-l-4 border-blue-500 pl-3">
        编辑个人信息
      </h2>
      
      <ElForm
        ref="formRef"
        :model="userForm"
        :rules="rules"
        label-width="100px"
        class="max-w-3xl"
      >
        <ElFormItem label="用户名" prop="username">
          <ElInput v-model="userForm.username" disabled>
            <template #prepend>
              <el-icon><User /></el-icon>
            </template>
          </ElInput>
        </ElFormItem>
        
        <ElFormItem label="真实姓名" prop="realName">
          <ElInput v-model="userForm.realName">
            <template #prepend>
              <el-icon><Edit /></el-icon>
            </template>
          </ElInput>
        </ElFormItem>
        
        <ElFormItem label="邮箱" prop="email">
          <ElInput v-model="userForm.email">
            <template #prepend>
              <el-icon><Message /></el-icon>
            </template>
          </ElInput>
        </ElFormItem>
        
        <ElFormItem label="手机号" prop="phone">
          <ElInput v-model="userForm.phone">
            <template #prepend>
              <el-icon><Cellphone /></el-icon>
            </template>
          </ElInput>
        </ElFormItem>
        
        <ElFormItem label="个人简介" prop="desc">
          <ElInput
            v-model="userForm.desc"
            type="textarea"
            :rows="4"
            placeholder="请输入个人简介"
          />
        </ElFormItem>
        
        <ElFormItem>
          <ElButton type="primary" @click="submitForm(formRef)" :loading="loading" class="w-32">
            保存修改
          </ElButton>
        </ElFormItem>
      </ElForm>
    </div>
    
    <!-- 头像上传对话框 -->
    <ElDialog 
      v-model="showAvatarUpload"
      title="上传头像"
      width="500px"
    >
      <div class="upload-dialog-content">
        <div v-if="avatarUrl" class="mb-4">
          <ElImage :src="avatarUrl" fit="contain" :preview-src-list="[avatarUrl]" class="w-full" />
        </div>
        
        <ElUpload
          class="avatar-uploader"
          action=""
          :auto-upload="false"
          :show-file-list="false"
          :on-change="(file) => customUpload({ file: file.raw! })"
          :before-upload="beforeAvatarUpload"
          drag
        >
          <div class="el-upload__text">
            <el-icon><Upload /></el-icon>
            <div class="mt-2">将文件拖到此处，或<em>点击上传</em></div>
            <div class="mt-1 text-gray-500 text-sm">支持 JPG、PNG 格式，文件小于 2MB</div>
          </div>
        </ElUpload>
      </div>
      
      <template #footer>
        <div class="dialog-footer">
          <ElButton @click="showAvatarUpload = false">取消</ElButton>
          <ElButton type="primary" :loading="uploadLoading">确认</ElButton>
        </div>
      </template>
    </ElDialog>
  </div>
</template>

<style scoped>
.upload-dialog-content {
  display: flex;
  flex-direction: column;
  align-items: center;
}

.avatar-uploader {
  width: 100%;
  text-align: center;
}

.avatar-edit-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  top: 0;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 50%;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  color: white;
  opacity: 0;
  transition: opacity 0.3s;
  cursor: pointer;
}

.avatar-edit-overlay:hover {
  opacity: 1;
}

.info-card {
  transition: all 0.3s;
}

.info-card:hover {
  transform: translateY(-5px);
}

.info-card-icon {
  width: 40px;
  height: 40px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: white;
}

/* 拖拽上传样式 */
:deep(.el-upload-dragger) {
  width: 100%;
  height: 200px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

:deep(.el-upload-dragger:hover) {
  border-color: #409eff;
}

:deep(.el-icon-upload) {
  font-size: 48px;
  color: #c0c4cc;
}

.el-upload__text em {
  color: #409eff;
  font-style: normal;
}
</style>