<template>
  <div class="min-h-500px">
    <!-- 筛选器 -->
    <div v-if="showFilter" class="mb-4 p-4 bg-gray-50 rounded-lg">
      <el-form :model="filterForm" label-width="80px" inline>
        <el-form-item label="用户名">
          <el-input 
            v-model="filterForm.username" 
            placeholder="请输入用户名"
            @change="handleFilter"
            clearable
          />
        </el-form-item>
        <el-form-item label="真实姓名">
          <el-input 
            v-model="filterForm.realName" 
            placeholder="请输入真实姓名"
            @change="handleFilter"
            clearable
          />
        </el-form-item>
        <el-form-item label="邮箱">
          <el-input 
            v-model="filterForm.email" 
            placeholder="请输入邮箱"
            @change="handleFilter"
            clearable
          />
        </el-form-item>
        <el-form-item label="手机号">
          <el-input 
            v-model="filterForm.phone" 
            placeholder="请输入手机号"
            @change="handleFilter"
            clearable
          />
        </el-form-item>
        <el-form-item label="性别">
          <el-select 
            v-model="filterForm.gender" 
            placeholder="请选择性别"
            @change="handleFilter"
            clearable
            style="width: 150px;"
          >
            <el-option label="男" value="M" />
            <el-option label="女" value="F" />
            <el-option label="其他" value="O" />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-select 
            v-model="filterForm.is_active" 
            placeholder="请选择状态"
            @change="handleFilter"
            clearable
            style="width: 150px;"
          >
            <el-option label="激活" :value="true" />
            <el-option label="禁用" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item label="管理员">
          <el-select 
            v-model="filterForm.is_staff" 
            placeholder="请选择管理员"
            @change="handleFilter"
            clearable
            style="width: 150px;"
          >
            <el-option label="是" :value="true" />
            <el-option label="否" :value="false" />
          </el-select>
        </el-form-item>
        <el-form-item>
          <el-button @click="clearFilter">清除筛选</el-button>
        </el-form-item>
      </el-form>
    </div>
    
    <Grid ref="gridRef">
      <template #toolbar_buttons>
        <el-button type="primary" @click="handleCreate">
          <el-icon class="mr-1"><Plus /></el-icon>
          新建用户
        </el-button>
        <el-button type="success" @click="loadData">
          手动刷新
        </el-button>
        <el-button type="info" @click="toggleFilter">
          {{ showFilter ? '隐藏筛选' : '显示筛选' }}
        </el-button>
      </template>
      
      <template #action="{ row }">
        <el-space>
          <el-button 
            size="small" 
            type="primary" 
            link
            @click="handleEdit(row)"
          >
            编辑
          </el-button>
          <el-button 
            size="small" 
            :type="row.is_active ? 'warning' : 'success'"
            link
            @click="handleToggleStatus(row)"
          >
            {{ row.is_active ? '禁用' : '启用' }}
          </el-button>
          <el-button 
            size="small" 
            type="danger"
            link
            @click="handleResetPassword(row)"
          >
            重置密码
          </el-button>
          <el-button 
            size="small" 
            type="danger"
            link
            @click="handleDelete(row)"
          >
            删除
          </el-button>
        </el-space>
      </template>
    </Grid>

    <!-- 用户编辑对话框 -->
    <el-dialog 
      v-model="showEditDialog" 
      :title="editForm.id ? '编辑用户' : '新建用户'"
      width="600px"
      destroy-on-close
    >
      <el-form 
        ref="editFormRef"
        :model="editForm" 
        :rules="editFormRules"
        label-width="100px"
      >
        <el-form-item label="用户名" prop="username" v-if="!editForm.id">
          <el-input v-model="editForm.username" placeholder="请输入用户名" />
        </el-form-item>
        <el-form-item label="密码" prop="password" v-if="!editForm.id">
          <el-input 
            v-model="editForm.password" 
            type="password"
            placeholder="请输入密码"
            show-password
          />
        </el-form-item>
        <el-form-item label="真实姓名" prop="realName">
          <el-input v-model="editForm.realName" placeholder="请输入真实姓名" />
        </el-form-item>
        <el-form-item label="邮箱" prop="email">
          <el-input v-model="editForm.email" placeholder="请输入邮箱" />
        </el-form-item>
        <el-form-item label="手机号" prop="phone">
          <el-input v-model="editForm.phone" placeholder="请输入手机号" />
        </el-form-item>
        <el-form-item label="性别">
          <el-select v-model="editForm.gender" placeholder="请选择性别" clearable>
            <el-option label="男" value="M" />
            <el-option label="女" value="F" />
            <el-option label="其他" value="O" />
          </el-select>
        </el-form-item>
        <el-form-item label="描述">
          <el-input 
            v-model="editForm.desc" 
            type="textarea" 
            placeholder="请输入描述"
            :rows="3"
          />
        </el-form-item>
        <el-form-item label="用户组">
          <el-select 
            v-model="editForm.groups" 
            multiple 
            placeholder="请选择用户组"
            style="width: 100%"
          >
            <el-option
              v-for="group in groups"
              :key="group.id"
              :label="group.name"
              :value="group.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="用户权限">
          <el-select 
            v-model="editForm.user_permissions" 
            multiple 
            placeholder="请选择用户权限"
            style="width: 100%"
            filterable
          >
            <el-option
              v-for="permission in permissions"
              :key="permission.id"
              :label="`${permission.name} (${permission.codename})`"
              :value="permission.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="状态">
          <el-switch 
            v-model="editForm.is_active"
            active-text="激活"
            inactive-text="禁用"
          />
        </el-form-item>
        <el-form-item label="管理员权限">
          <el-switch 
            v-model="editForm.is_staff"
            active-text="是"
            inactive-text="否"
          />
        </el-form-item>
        <el-form-item label="超级管理员">
          <el-switch 
            v-model="editForm.is_superuser"
            active-text="是"
            inactive-text="否"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showEditDialog = false">取消</el-button>
        <el-button type="primary" @click="handleSave" :loading="saving">
          保存
        </el-button>
      </template>
    </el-dialog>

    <!-- 重置密码对话框 -->
    <el-dialog 
      v-model="showPasswordDialog" 
      title="重置密码"
      width="400px"
      destroy-on-close
    >
      <el-form 
        ref="passwordFormRef"
        :model="passwordForm" 
        :rules="passwordFormRules"
        label-width="100px"
      >
        <el-form-item label="新密码" prop="new_password">
          <el-input 
            v-model="passwordForm.new_password" 
            type="password"
            placeholder="请输入新密码"
            show-password
          />
        </el-form-item>
        <el-form-item label="确认密码" prop="confirm_password">
          <el-input 
            v-model="passwordForm.confirm_password" 
            type="password"
            placeholder="请再次输入新密码"
            show-password
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="showPasswordDialog = false">取消</el-button>
        <el-button type="primary" @click="handlePasswordReset" :loading="resetting">
          重置
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import type { VxeGridProps } from '#/adapter/vxe-table';
import { ref, reactive, onMounted, computed } from 'vue';
import { 
  ElMessage, 
  ElMessageBox, 
  ElDialog, 
  ElForm, 
  ElFormItem, 
  ElInput, 
  ElSelect, 
  ElOption, 
  ElSwitch, 
  ElButton, 
  ElSpace,
  ElIcon
} from 'element-plus';
import type { FormInstance, FormRules } from 'element-plus';
import { useVbenVxeGrid } from '#/adapter/vxe-table';
import { Plus } from '@element-plus/icons-vue';
import { 
  getUserListApi, 
  createUserApi,
  updateUserApi, 
  deleteUserApi, 
  resetUserPasswordApi,
  toggleUserStatusApi,
  getGroupsApi,
  getPermissionsApi,
  type SystemUserApi
} from '#/api/system/user';

const gridRef = ref();
const editFormRef = ref<FormInstance>();
const passwordFormRef = ref<FormInstance>();

const showEditDialog = ref(false);
const showPasswordDialog = ref(false);
const showFilter = ref(false);
const saving = ref(false);
const resetting = ref(false);

const groups = ref<SystemUserApi.GroupInfo[]>([]);
const permissions = ref<SystemUserApi.PermissionInfo[]>([]);

// 编辑表单
const editForm = reactive({
  id: null as number | null,
  username: '',
  password: '',
  realName: '',
  email: '',
  phone: '',
  desc: '',
  gender: '' as 'M' | 'F' | 'O' | '',
  is_active: true,
  is_staff: false,
  is_superuser: false,
  groups: [] as number[],
  user_permissions: [] as number[]
});

// 筛选表单
const filterForm = reactive({
  username: '',
  realName: '',
  email: '',
  phone: '',
  gender: '' as 'M' | 'F' | 'O' | '',
  is_active: undefined as boolean | undefined,
  is_staff: undefined as boolean | undefined,
  is_superuser: undefined as boolean | undefined
});

// 密码重置表单
const passwordForm = reactive({
  new_password: '',
  confirm_password: ''
});

const currentResetUser = ref<SystemUserApi.UserInfo | null>(null);

// 表单验证规则
const editFormRules: FormRules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 8, message: '密码长度不能少于8位', trigger: 'blur' }
  ],
  realName: [{ required: true, message: '请输入真实姓名', trigger: 'blur' }],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ]
};

const passwordFormRules: FormRules = {
  new_password: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 8, message: '密码长度不能少于8位', trigger: 'blur' }
  ],
  confirm_password: [
    { required: true, message: '请再次输入新密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.new_password) {
          callback(new Error('两次输入的密码不一致'));
        } else {
          callback();
        }
      },
      trigger: 'blur'
    }
  ]
};

// 表格配置
const gridOptions: VxeGridProps = {
  height: 600,
  border: true,
  showHeaderOverflow: true,
  showOverflow: true,
  keepSource: true,
  id: 'user-grid',
  rowConfig: {
    keyField: 'id',
    isHover: true
  },
  columns: [
    { field: 'id', title: 'ID', width: 80 },
    { field: 'username', title: '用户名', width: 120 },
    { field: 'realName', title: '真实姓名', width: 120 },
    { field: 'email', title: '邮箱', width: 200 },
    { field: 'phone', title: '手机号', width: 120 },
    { 
      field: 'gender_display', 
      title: '性别', 
      width: 80,
      formatter: ({ row }: { row: SystemUserApi.UserInfo }) => {
        return row.gender_display || '-';
      }
    },
    { 
      field: 'groups', 
      title: '用户组', 
      width: 150,
      formatter: ({ row }: { row: SystemUserApi.UserInfo }) => {
        return row.groups?.map(g => g.name).join(', ') || '-';
      }
    },
    { 
      field: 'is_active', 
      title: '状态', 
      width: 80,
      formatter: ({ cellValue }: { cellValue: boolean }) => cellValue ? '激活' : '禁用'
    },
    { 
      field: 'is_staff', 
      title: '管理员', 
      width: 80,
      formatter: ({ cellValue }: { cellValue: boolean }) => cellValue ? '是' : '否'
    },
    { 
      field: 'date_joined', 
      title: '创建时间', 
      width: 160,
      formatter: ({ cellValue }: { cellValue: string }) => {
        return cellValue ? new Date(cellValue).toLocaleString() : '-';
      }
    },
    { 
      field: 'action', 
      title: '操作', 
      width: 200, 
      fixed: 'right',
      slots: { default: 'action' }
    }
  ],
  proxyConfig: {
    ajax: {
      query: async ({ page, sort, filters }: { page: any, sort: any, filters: any }) => {
        const params = {
          page: page.currentPage,
          pageSize: page.pageSize,
          ...filters
        };
        
        // 添加筛选条件
        Object.keys(filterForm).forEach(key => {
          const value = filterForm[key as keyof typeof filterForm];
          if (value !== '' && value !== undefined && value !== null) {
            params[key] = value;
          }
        });
        
        if (sort && sort.length > 0) {
          const { field, order } = sort[0];
          params.ordering = order === 'desc' ? `-${field}` : field;
        }
        
        const result = await getUserListApi(params);
        console.log('API result:', result);
        console.log('Returning to grid:', {
          result: result.items,
          page: { total: result.total }
        });
        
        return {
          result: result.items,
          page: {
            total: result.total
          }
        };
      }
    },
    response: {
      result: 'result',
      total: 'page.total'
    }
  },
  toolbarConfig: {
    slots: {
      buttons: 'toolbar_buttons'
    }
  },
  pagerConfig: {
    enabled: true,
    pageSize: 10,
    pageSizes: [10, 20, 50, 100],
    layouts: ['PrevJump', 'PrevPage', 'Number', 'NextPage', 'NextJump', 'Sizes', 'Total']
  }
};

const [Grid, gridApi] = useVbenVxeGrid({ gridOptions });

// 测试函数：手动加载数据
const loadData = async () => {
  try {
    const result = await getUserListApi({ page: 1, pageSize: 10 });
    console.log('Manual load result:', result);
    gridApi.setGridOptions({
      data: result.items
    });
  } catch (error) {
    console.error('Manual load error:', error);
  }
};

// 加载用户组和权限数据
const loadGroupsAndPermissions = async () => {
  try {
    const [groupsRes, permissionsRes] = await Promise.all([
      getGroupsApi(),
      getPermissionsApi()
    ]);
    groups.value = groupsRes;
    permissions.value = permissionsRes;
  } catch (error) {
    console.error('Failed to load groups and permissions:', error);
  }
};

// 筛选相关方法
const toggleFilter = () => {
  showFilter.value = !showFilter.value;
};

const handleFilter = () => {
  gridApi.query();
};

const clearFilter = () => {
  Object.assign(filterForm, {
    username: '',
    realName: '',
    email: '',
    phone: '',
    gender: '',
    is_active: undefined,
    is_staff: undefined,
    is_superuser: undefined
  });
  gridApi.query();
};

// 处理新建
const handleCreate = () => {
  Object.assign(editForm, {
    id: null,
    username: '',
    password: '',
    realName: '',
    email: '',
    phone: '',
    desc: '',
    gender: '',
    is_active: true,
    is_staff: false,
    is_superuser: false,
    groups: [],
    user_permissions: []
  });
  showEditDialog.value = true;
};

// 处理编辑
const handleEdit = (row: SystemUserApi.UserInfo) => {
  Object.assign(editForm, {
    id: row.id,
    username: row.username,
    password: '',
    realName: row.realName || '',
    email: row.email || '',
    phone: row.phone || '',
    desc: row.desc || '',
    gender: row.gender || '',
    is_active: row.is_active,
    is_staff: row.is_staff,
    is_superuser: row.is_superuser,
    groups: row.groups?.map(g => g.id) || [],
    user_permissions: row.user_permissions?.map(p => p.id) || []
  });
  showEditDialog.value = true;
};

// 处理保存
const handleSave = async () => {
  if (!editFormRef.value) return;
  
  try {
    await editFormRef.value.validate();
    saving.value = true;
    
    if (editForm.id) {
      // 更新用户
      const { password, id, username, ...updateData } = editForm;
      // 处理性别字段，空字符串转为undefined
      const apiData: SystemUserApi.UserUpdateParams = {
        ...updateData,
        gender: updateData.gender === '' ? undefined : updateData.gender as 'M' | 'F' | 'O' | undefined
      };
      await updateUserApi(editForm.id, apiData);
      ElMessage.success('用户更新成功');
    } else {
      // 创建用户
      const { id, ...createFormData } = editForm;
      const createData: SystemUserApi.UserCreateParams = {
        ...createFormData,
        gender: createFormData.gender === '' ? undefined : createFormData.gender as 'M' | 'F' | 'O' | undefined
      };
      await createUserApi(createData);
      ElMessage.success('用户创建成功');
    }
    
    showEditDialog.value = false;
    gridApi.query();
  } catch (error) {
    console.error('Save failed:', error);
    ElMessage.error('保存失败');
  } finally {
    saving.value = false;
  }
};

// 处理删除
const handleDelete = async (row: SystemUserApi.UserInfo) => {
  try {
    await ElMessageBox.confirm(
      `确定要删除用户 "${row.username}" 吗？`,
      '删除确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    );
    
    await deleteUserApi(row.id);
    ElMessage.success('用户删除成功');
    gridApi.query();
  } catch (error) {
    if (error !== 'cancel') {
      console.error('Delete failed:', error);
      ElMessage.error('删除失败');
    }
  }
};

// 处理状态切换
const handleToggleStatus = async (row: SystemUserApi.UserInfo) => {
  try {
    const action = row.is_active ? '禁用' : '启用';
    await ElMessageBox.confirm(
      `确定要${action}用户 "${row.username}" 吗？`,
      '状态切换确认',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    );
    
    await toggleUserStatusApi(row.id);
    ElMessage.success(`用户已${action}`);
    gridApi.query();
  } catch (error) {
    if (error !== 'cancel') {
      console.error('Toggle status failed:', error);
      ElMessage.error('操作失败');
    }
  }
};

// 处理重置密码
const handleResetPassword = (row: SystemUserApi.UserInfo) => {
  currentResetUser.value = row;
  Object.assign(passwordForm, {
    new_password: '',
    confirm_password: ''
  });
  showPasswordDialog.value = true;
};

// 处理密码重置提交
const handlePasswordReset = async () => {
  if (!passwordFormRef.value || !currentResetUser.value) return;
  
  try {
    await passwordFormRef.value.validate();
    resetting.value = true;
    
    await resetUserPasswordApi(currentResetUser.value.id, {
      new_password: passwordForm.new_password
    });
    
    ElMessage.success('密码重置成功');
    showPasswordDialog.value = false;
  } catch (error) {
    console.error('Password reset failed:', error);
    ElMessage.error('密码重置失败');
  } finally {
    resetting.value = false;
  }
};

onMounted(() => {
  loadGroupsAndPermissions();
  // 测试手动加载数据
  loadData();
});
</script> 