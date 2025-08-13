<script lang="ts" setup>
import { ref } from 'vue';
import {
    ElMessage, ElForm, ElFormItem, ElInput, ElButton,
    ElDivider, ElDescriptions, ElDescriptionsItem, ElTag,
    ElCard, ElAlert, ElSwitch, ElStatistic, ElIcon
} from 'element-plus';
import type { FormInstance } from 'element-plus';
import { changePasswordApi } from '#/api/core/user';
import type { UserApi } from '#/api/core/user';

defineOptions({ name: 'ProfileSecurity' });

const passwordForm = ref({
    oldPassword: '',
    newPassword: '',
    confirmPassword: ''
});

const passwordFormRef = ref<FormInstance>();
const changingPassword = ref(false);

const passwordRules = {
    oldPassword: [
        { required: true, message: '请输入当前密码', trigger: 'blur' }
    ],
    newPassword: [
        { required: true, message: '请输入新密码', trigger: 'blur' },
        { min: 8, message: '密码长度不能小于8个字符', trigger: 'blur' }
    ],
    confirmPassword: [
        { required: true, message: '请确认新密码', trigger: 'blur' },
        {
            validator: (rule: any, value: string, callback: (error?: Error) => void) => {
                if (value !== passwordForm.value.newPassword) {
                    callback(new Error('两次输入的密码不一致'));
                } else {
                    callback();
                }
            },
            trigger: 'blur'
        }
    ]
};

// 安全设置
const securitySettings = ref({
    twoFactorAuth: false,
    loginNotifications: true,
    sensitiveOperations: true
});

// 密码强度计算
const passwordStrength = ref({
    score: 0,
    level: '弱',
    color: '#F56C6C'
});

const calculatePasswordStrength = (password: string) => {
    if (!password) {
        passwordStrength.value = { score: 0, level: '弱', color: '#F56C6C' };
        return;
    }

    let score = 0;
    // 长度检查
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;

    // 字符种类检查
    if (/[a-z]/.test(password)) score += 1;
    if (/[A-Z]/.test(password)) score += 1;
    if (/[0-9]/.test(password)) score += 1;
    if (/[^a-zA-Z0-9]/.test(password)) score += 1;

    // 设置强度级别
    if (score <= 2) {
        passwordStrength.value = { score, level: '弱', color: '#F56C6C' };
    } else if (score <= 4) {
        passwordStrength.value = { score, level: '中', color: '#E6A23C' };
    } else {
        passwordStrength.value = { score, level: '强', color: '#67C23A' };
    }
};

// 监听密码变化
const handlePasswordChange = () => {
    calculatePasswordStrength(passwordForm.value.newPassword);
};

// 模拟的登录设备数据
const loginDevices = ref([
    {
        id: 1,
        device: 'Chrome / Windows 10',
        ip: '192.168.1.1',
        location: '中国 北京',
        time: '2025-07-15 14:30:22',
        current: true
    },
    {
        id: 2,
        device: 'Safari / macOS',
        ip: '192.168.1.2',
        location: '中国 上海',
        time: '2025-07-14 09:12:45',
        current: false
    },
    {
        id: 3,
        device: 'Firefox / Ubuntu',
        ip: '192.168.1.3',
        location: '中国 广州',
        time: '2025-07-13 18:05:32',
        current: false
    }
]);

// 安全日志
const securityLogs = ref([
    { id: 1, type: '登录', status: '成功', ip: '192.168.1.1', location: '中国 北京', time: '2025-07-15 14:30:22', details: 'Chrome / Windows 10' },
    { id: 2, type: '修改密码', status: '成功', ip: '192.168.1.1', location: '中国 北京', time: '2025-07-10 09:15:30', details: 'Chrome / Windows 10' },
    { id: 3, type: '登录', status: '失败', ip: '23.45.67.89', location: '美国 纽约', time: '2025-07-05 22:11:05', details: '密码错误' },
    { id: 4, type: '开启两因素认证', status: '成功', ip: '192.168.1.1', location: '中国 北京', time: '2025-06-25 16:45:12', details: 'Chrome / Windows 10' }
]);

const changePassword = async (formEl: FormInstance | undefined) => {
    if (!formEl) return;

    await formEl.validate(async (valid: boolean) => {
        if (valid) {
            changingPassword.value = true;
            try {
                const params: UserApi.ChangePasswordParams = {
                    oldPassword: passwordForm.value.oldPassword,
                    newPassword: passwordForm.value.newPassword,
                };

                const res = await changePasswordApi(params);

                ElMessage.success(res?.message || '密码修改成功');
                passwordForm.value = {
                    oldPassword: '',
                    newPassword: '',
                    confirmPassword: ''
                };

            } catch (error) {
                console.error('修改密码错误:', error);
                ElMessage.error('密码修改失败，请稍后再试');
            } finally {
                changingPassword.value = false;
            }
        }
    });
};

const logoutDevice = (deviceId: number) => {
    // 模拟API调用
    loginDevices.value = loginDevices.value.filter(device => device.id !== deviceId);
    ElMessage.success('设备已登出');
};

const handleSecuritySettingChange = (key: string, value: boolean) => {
    ElMessage.success(`${value ? '开启' : '关闭'}${key === 'twoFactorAuth' ? '两因素认证' : key === 'loginNotifications' ? '登录通知' : '敏感操作验证'}成功`);
};
</script>

<template>
    <div class="profile-security p-6">
        <!-- 修改密码卡片 -->
        <ElCard shadow="hover" class="mb-6">
            <template #header>
                <div class="flex items-center">
                    <el-icon class="mr-2"><i class="el-icon-key"></i></el-icon>
                    <span>修改密码</span>
                </div>
            </template>
            
            <ElForm ref="passwordFormRef" :model="passwordForm" :rules="passwordRules" label-width="100px"
                class="max-w-xl">
                <ElFormItem label="当前密码" prop="oldPassword">
                    <ElInput v-model="passwordForm.oldPassword" type="password" :show-password="true" placeholder="请输入当前密码">
                        <template #prepend>
                            <el-icon><i class="el-icon-lock"></i></el-icon>
                        </template>
                    </ElInput>
                </ElFormItem>

                <ElFormItem label="新密码" prop="newPassword">
                    <ElInput v-model="passwordForm.newPassword" type="password" :show-password="true" placeholder="请输入新密码"
                        @input="handlePasswordChange">
                        <template #prepend>
                            <el-icon><i class="el-icon-key"></i></el-icon>
                        </template>
                    </ElInput>
                    <div class="password-strength mt-2" v-if="passwordForm.newPassword">
                        <div class="flex items-center">
                            <span class="mr-2 text-sm">密码强度:</span>
                            <div class="strength-bar">
                                <div class="strength-indicator" :style="{
                                    width: `${Math.min(100, passwordStrength.score * 16.7)}%`,
                                    backgroundColor: passwordStrength.color
                                }"></div>
                            </div>
                            <span class="ml-2 text-sm" :style="{ color: passwordStrength.color }">
                                {{ passwordStrength.level }}
                            </span>
                        </div>
                    </div>
                    <div class="password-tips text-sm text-gray-500 mt-1">
                        密码至少包含8个字符，建议使用大小写字母、数字和特殊符号的组合
                    </div>
                </ElFormItem>

                <ElFormItem label="确认密码" prop="confirmPassword">
                    <ElInput v-model="passwordForm.confirmPassword" type="password" :show-password="true"
                        placeholder="请再次输入新密码">
                        <template #prepend>
                            <el-icon><i class="el-icon-check"></i></el-icon>
                        </template>
                    </ElInput>
                </ElFormItem>

                <ElFormItem>
                    <ElButton type="primary" @click="changePassword(passwordFormRef)" :loading="changingPassword">
                        确认修改
                    </ElButton>
                </ElFormItem>
            </ElForm>
        </ElCard>

        <!-- 功能演示提示 -->
        <ElAlert
          title="功能演示"
          type="info"
          :closable="false"
          class="mb-6"
        >
          <template #default>
            <p>此页面为功能演示，部分功能尚未实现。以下功能仅作界面展示用途：</p>
            <ul class="mt-2 list-disc list-inside">
              <li>密码强度检测</li>
              <li>两步验证</li>
              <li>登录设备管理</li>
              <li>安全日志</li>
              <li>安全通知设置</li>
            </ul>
          </template>
        </ElAlert>
        
        <!-- 安全概览 -->
        <div class="mb-6 grid grid-cols-1 md:grid-cols-3 gap-6">
            <ElCard shadow="hover" class="security-card">
                <template #header>
                    <div class="flex items-center">
                        <el-icon class="mr-2"><i class="el-icon-lock"></i></el-icon>
                        <span>账户安全评分</span>
                    </div>
                </template>
                <div class="text-center">
                    <ElStatistic :value="85" class="security-score">
                        <template #suffix>/ 100</template>
                    </ElStatistic>
                    <div class="mt-3">
                        <el-tag type="success">良好</el-tag>
                    </div>
                </div>
            </ElCard>

            <ElCard shadow="hover" class="security-card">
                <template #header>
                    <div class="flex items-center">
                        <el-icon class="mr-2"><i class="el-icon-warning"></i></el-icon>
                        <span>最近风险提醒</span>
                    </div>
                </template>
                <div class="security-alert">
                    <ElAlert title="检测到异常登录尝试" type="warning" :closable="false"
                        description="2025-07-05 22:11:05 美国 纽约" />
                </div>
            </ElCard>

            <ElCard shadow="hover" class="security-card">
                <template #header>
                    <div class="flex items-center">
                        <el-icon class="mr-2"><i class="el-icon-time"></i></el-icon>
                        <span>最近登录</span>
                    </div>
                </template>
                <div class="last-login">
                    <div class="mb-2">
                        <div class="text-sm text-gray-500">登录时间</div>
                        <div class="font-medium">2025-07-15 14:30:22</div>
                    </div>
                    <div class="mb-2">
                        <div class="text-sm text-gray-500">登录地点</div>
                        <div class="font-medium">中国 北京 (192.168.1.1)</div>
                    </div>
                    <div>
                        <div class="text-sm text-gray-500">设备信息</div>
                        <div class="font-medium">Chrome / Windows 10</div>
                    </div>
                </div>
            </ElCard>
        </div>

        <!-- 主要内容区域 -->
        <div class="bg-white dark:bg-gray-800 rounded-lg shadow-md p-6">
            <h1 class="text-2xl font-bold mb-6 text-gray-800 dark:text-white">安全设置</h1>

            <!-- 安全选项 -->
            <div class="mb-8">
                <h2 class="text-lg font-medium mb-4 text-gray-700 dark:text-gray-300 border-l-4 border-blue-500 pl-3">
                    账户保护
                </h2>

                <div class="security-options">
                    <div class="security-option">
                        <div class="flex justify-between items-center">
                            <div>
                                <h3 class="text-base font-medium">两因素认证</h3>
                                <p class="text-sm text-gray-500">通过手机验证码或认证器增加账户安全</p>
                            </div>
                            <ElSwitch v-model="securitySettings.twoFactorAuth"
                                @change="(val) => handleSecuritySettingChange('twoFactorAuth', val)" />
                        </div>
                    </div>

                    <ElDivider />

                    <div class="security-option">
                        <div class="flex justify-between items-center">
                            <div>
                                <h3 class="text-base font-medium">登录通知</h3>
                                <p class="text-sm text-gray-500">新设备登录时通过邮件通知您</p>
                            </div>
                            <ElSwitch v-model="securitySettings.loginNotifications"
                                @change="(val) => handleSecuritySettingChange('loginNotifications', val)" />
                        </div>
                    </div>

                    <ElDivider />

                    <div class="security-option">
                        <div class="flex justify-between items-center">
                            <div>
                                <h3 class="text-base font-medium">敏感操作验证</h3>
                                <p class="text-sm text-gray-500">修改密码等敏感操作需要额外验证</p>
                            </div>
                            <ElSwitch v-model="securitySettings.sensitiveOperations"
                                @change="(val) => handleSecuritySettingChange('sensitiveOperations', val)" />
                        </div>
                    </div>
                </div>
            </div>

            <!-- 登录设备 -->
            <div class="mb-8">
                <h2 class="text-lg font-medium mb-4 text-gray-700 dark:text-gray-300 border-l-4 border-blue-500 pl-3">
                    登录设备
                </h2>

                <div class="login-devices">
                    <div v-for="device in loginDevices" :key="device.id"
                        class="mb-4 p-4 border border-gray-200 dark:border-gray-700 rounded-lg hover:shadow-md transition-shadow">
                        <div class="flex justify-between items-center">
                            <div>
                                <div class="flex items-center">
                                    <el-icon class="mr-2"><i class="el-icon-monitor"></i></el-icon>
                                    <span class="font-medium">{{ device.device }}</span>
                                    <ElTag v-if="device.current" type="success" class="ml-2" size="small">当前设备</ElTag>
                                </div>

                                <ElDescriptions :column="1" border size="small" class="mt-2">
                                    <ElDescriptionsItem label="IP地址">{{ device.ip }}</ElDescriptionsItem>
                                    <ElDescriptionsItem label="登录地点">{{ device.location }}</ElDescriptionsItem>
                                    <ElDescriptionsItem label="登录时间">{{ device.time }}</ElDescriptionsItem>
                                </ElDescriptions>
                            </div>

                            <ElButton v-if="!device.current" type="danger" size="small"
                                @click="logoutDevice(device.id)">
                                退出登录
                            </ElButton>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 安全日志 -->
            <div class="mt-8">
                <h2 class="text-lg font-medium mb-4 text-gray-700 dark:text-gray-300 border-l-4 border-blue-500 pl-3">
                    安全日志
                </h2>

                <div class="security-logs">
                    <div v-for="log in securityLogs" :key="log.id" class="mb-3 p-3 border-l-4 rounded-r-md"
                        :class="[
                            log.status === '成功'
                                ? 'border-green-500 bg-green-50 dark:border-green-700 dark:bg-gray-800'
                                : 'border-red-500 bg-red-50 dark:border-red-700 dark:bg-gray-800'
                        ]">
                        <div class="flex justify-between">
                            <div class="flex items-center">
                                <el-icon class="mr-2"><i
                                        :class="log.type === '登录' ? 'el-icon-user' : 'el-icon-setting'"></i></el-icon>
                                <span class="font-medium">{{ log.type }}</span>
                                <ElTag :type="log.status === '成功' ? 'success' : 'danger'" class="ml-2" size="small">{{
                                    log.status }}</ElTag>
                            </div>
                            <div class="text-sm text-gray-500 dark:text-gray-400">{{ log.time }}</div>
                        </div>
                        <div class="mt-2">
                            <div class="text-sm"><span class="text-gray-500 dark:text-gray-400">地点:</span> {{ log.location }} ({{ log.ip
                                }})</div>
                            <div class="text-sm"><span class="text-gray-500 dark:text-gray-400">详情:</span> {{ log.details }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.el-descriptions {
    max-width: 400px;
}

.security-card {
    transition: all 0.3s;
}

.security-card:hover {
    transform: translateY(-5px);
}

.security-score :deep(.el-statistic__content) {
    font-size: 36px;
    color: #67c23a;
    font-weight: bold;
}

.security-option {
    padding: 12px 0;
}

.password-strength {
    display: flex;
    align-items: center;
}

.strength-bar {
    width: 150px;
    height: 6px;
    background-color: #ebeef5;
    border-radius: 3px;
    overflow: hidden;
}

.strength-indicator {
    height: 100%;
    transition: width 0.3s, background-color 0.3s;
}

.security-logs .el-tag {
    margin-left: 8px;
}

.login-devices .el-tag {
    margin-left: 8px;
}
</style>