import type { RouteRecordRaw } from 'vue-router';

import { BasicLayout } from '#/layouts';
import { $t } from '#/locales';

const routes: RouteRecordRaw[] = [
  {
    component: BasicLayout,
    meta: {
      icon: 'lucide:settings',
      order: 1000,
      title: $t('page.system.title'),
    },
    name: 'System',
    path: '/system',
    children: [
      {
        name: 'SystemUserManagement',
        path: '/system/user',
        component: () => import('#/views/system/user/index.vue'),
        meta: {
          affixTab: false,
          icon: 'lucide:users',
          title: $t('page.system.user.title'),
        },
      },
    ],
  },
];

export default routes; 