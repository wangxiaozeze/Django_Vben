import type { UserInfo } from '@vben/types';

import { requestClient } from '#/api/request';

export namespace UserApi {
  /** 用户信息返回值 */
  export interface UserInfoResult {
    code: number;
    data: UserInfo;
  }

  /** 更新用户信息参数 */
  export interface UpdateInfoParams {
    realName?: string;
    email?: string;
    phone?: string;
    desc?: string;
  }

  /** 更新用户信息返回值 */
  export interface UpdateInfoResult {
    message: string;

  }

  /** 修改密码参数 */
  export interface ChangePasswordParams {
    oldPassword: string;
    newPassword: string;
  }

  /** 修改密码返回值 */
  export interface ChangePasswordResult {
    message: string;

  }

  /** 头像上传返回值 */
  export interface UploadAvatarResult {
    message: string;
    url: string;

  }

  /** 用户设置参数 */
  export interface UpdateSettingsParams {
    language?: string;
    theme?: string;
    defaultHomePath?: string;
    notifications?: {
      email?: boolean;
      browser?: boolean;
      app?: boolean;
    };
  }

  /** 用户设置返回值 */
  export interface UpdateSettingsResult {
    message: string;
  }
}

/**
 * 获取用户信息
 */
export async function getUserInfoApi() {
  return requestClient.get<UserApi.UserInfoResult>('/user/info');
}

/**
 * 更新用户信息
 */
export async function updateUserInfoApi(params: UserApi.UpdateInfoParams) {
  return requestClient.post<UserApi.UpdateInfoResult>('/user/update-info', params);
}

/**
 * 修改密码
 */
export async function changePasswordApi(params: UserApi.ChangePasswordParams) {
  return requestClient.post<UserApi.ChangePasswordResult>('/user/change-password', params);
}

/**
 * 上传头像
 */
export async function uploadAvatarApi(formData: FormData) {
  return requestClient.post<UserApi.UploadAvatarResult>('/user/upload-avatar', formData, {
    headers: {
      'Content-Type': 'multipart/form-data',
    },
  });
}

/**
 * 更新账号设置
 */
export async function updateUserSettingsApi(params: UserApi.UpdateSettingsParams) {
  return requestClient.post<UserApi.UpdateSettingsResult>('/user/settings', params);
}
