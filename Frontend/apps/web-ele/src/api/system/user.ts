import { requestClient } from '#/api/request';

export namespace SystemUserApi {
  /** 用户列表查询参数 */
  export interface UserListParams {
    page?: number;
    pageSize?: number;
    username?: string;
    email?: string;
    realName?: string;
    phone?: string;
    gender?: 'M' | 'F' | 'O';
    is_active?: boolean;
    is_staff?: boolean;
    is_superuser?: boolean;
    ordering?: string;
  }

  /** 用户信息 */
  export interface UserInfo {
    id: number;
    username: string;
    email: string;
    realName?: string;
    phone?: string;
    avatar?: string;
    desc?: string;
    gender?: 'M' | 'F' | 'O';
    gender_display?: string;
    is_active: boolean;
    is_staff: boolean;
    is_superuser: boolean;
    date_joined: string;
    last_login?: string;
    groups: Array<{
      id: number;
      name: string;
    }>;
    user_permissions: Array<{
      id: number;
      name: string;
      codename: string;
      content_type: number;
    }>;
  }

  /** 用户列表返回值 */
  export interface UserListResult {
    items: UserInfo[];
    total: number;
    page: number;
    pageSize: number;
  }

  /** 用户更新参数 */
  export interface UserUpdateParams {
    realName?: string;
    email?: string;
    phone?: string;
    desc?: string;
    gender?: 'M' | 'F' | 'O';
    is_active?: boolean;
    is_staff?: boolean;
    is_superuser?: boolean;
    groups?: number[];
    user_permissions?: number[];
  }

  /** 用户创建参数 */
  export interface UserCreateParams {
    username: string;
    email: string;
    password: string;
    realName?: string;
    phone?: string;
    desc?: string;
    gender?: 'M' | 'F' | 'O';
    is_active?: boolean;
    is_staff?: boolean;
    is_superuser?: boolean;
    groups?: number[];
    user_permissions?: number[];
  }

  /** 操作结果 */
  export interface OperationResult {
    message: string;
  }

  /** 密码重置参数 */
  export interface ResetPasswordParams {
    new_password: string;
  }

  /** 用户组信息 */
  export interface GroupInfo {
    id: number;
    name: string;
  }

  /** 权限信息 */
  export interface PermissionInfo {
    id: number;
    name: string;
    codename: string;
    content_type: number;
  }

  /** 用户组列表返回值 */
  export interface GroupListResult extends Array<GroupInfo> {}

  /** 权限列表返回值 */
  export interface PermissionListResult extends Array<PermissionInfo> {}
}

/**
 * 获取用户列表
 */
export async function getUserListApi(params?: SystemUserApi.UserListParams) {
  return requestClient.get<SystemUserApi.UserListResult>('/users/', { params });
}

/**
 * 获取用户详情
 */
export async function getUserDetailApi(id: number) {
  return requestClient.get<SystemUserApi.UserInfo>(`/users/${id}/`);
}

/**
 * 更新用户信息
 */
export async function updateUserApi(id: number, params: SystemUserApi.UserUpdateParams) {
  return requestClient.put<SystemUserApi.OperationResult>(`/users/${id}/`, params);
}

/**
 * 删除用户
 */
export async function deleteUserApi(id: number) {
  return requestClient.delete<SystemUserApi.OperationResult>(`/users/${id}/`);
}

/**
 * 重置用户密码
 */
export async function resetUserPasswordApi(id: number, params: SystemUserApi.ResetPasswordParams) {
  return requestClient.post<SystemUserApi.OperationResult>(`/users/${id}/reset-password`, params);
}

/**
 * 切换用户状态
 */
export async function toggleUserStatusApi(id: number) {
  return requestClient.post<SystemUserApi.OperationResult>(`/users/${id}/toggle-status`);
}

/**
 * 获取用户组列表
 */
export async function getGroupsApi() {
  return requestClient.get<SystemUserApi.GroupListResult>('/groups/');
}

/**
 * 获取权限列表
 */
export async function getPermissionsApi() {
  return requestClient.get<SystemUserApi.PermissionListResult>('/permissions/');
}

/**
 * 创建用户
 */
export async function createUserApi(params: SystemUserApi.UserCreateParams) {
  return requestClient.post<SystemUserApi.OperationResult>('/users/', params);
} 