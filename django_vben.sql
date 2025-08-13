/*
 Navicat Premium Dump SQL

 Source Server         : localhost_3306
 Source Server Type    : MySQL
 Source Server Version : 80041 (8.0.41)
 Source Host           : localhost:3306
 Source Schema         : django_vben

 Target Server Type    : MySQL
 Target Server Version : 80041 (8.0.41)
 File Encoding         : 65001

 Date: 13/08/2025 18:59:02
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for app_menu
-- ----------------------------
DROP TABLE IF EXISTS `app_menu`;
CREATE TABLE `app_menu`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `redirect` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `meta` json NOT NULL,
  `order` int NOT NULL,
  `parent_id` bigint NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `App_menu_parent_id_5fbc9c55_fk_App_menu_id`(`parent_id` ASC) USING BTREE,
  CONSTRAINT `App_menu_parent_id_5fbc9c55_fk_App_menu_id` FOREIGN KEY (`parent_id`) REFERENCES `app_menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_menu
-- ----------------------------
INSERT INTO `app_menu` VALUES (1, 'ProfileInfo', '/profile/info', '/profile/info/index', '', '{\"icon\": \"lucide:user\", \"order\": 9950, \"title\": \"page.profile.profileInfo\"}', 0, NULL);
INSERT INTO `app_menu` VALUES (2, 'ProfileSecurity', '/profile/security', '/profile/security/index', '', '{\"icon\": \"lucide:shield\", \"order\": 9960, \"title\": \"page.profile.profileSecurity\"}', 0, NULL);

-- ----------------------------
-- Table structure for app_menu_groups
-- ----------------------------
DROP TABLE IF EXISTS `app_menu_groups`;
CREATE TABLE `app_menu_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `menu_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `App_menu_groups_menu_id_group_id_06043eba_uniq`(`menu_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `App_menu_groups_group_id_f66c1874_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `App_menu_groups_group_id_f66c1874_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `App_menu_groups_menu_id_9fa9c8fb_fk_App_menu_id` FOREIGN KEY (`menu_id`) REFERENCES `app_menu` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_menu_groups
-- ----------------------------
INSERT INTO `app_menu_groups` VALUES (1, 1, 1);
INSERT INTO `app_menu_groups` VALUES (2, 2, 1);

-- ----------------------------
-- Table structure for app_user
-- ----------------------------
DROP TABLE IF EXISTS `app_user`;
CREATE TABLE `app_user`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `password` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_login` datetime(6) NULL DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `first_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `last_name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `email` varchar(254) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  `realName` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `phone` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `desc` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `homePath` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_user
-- ----------------------------
INSERT INTO `app_user` VALUES (1, 'pbkdf2_sha256$1000000$Cehlkk64ASqtzsbTwVgN5L$i1oQzb/xRj3WO+N+q3vw1CfqxA86+sK6TV4Kbjr0OOM=', '2025-08-13 03:59:00.000000', 1, 'admin', '', '', '123456@qq.com', 1, 1, '2025-08-13 03:58:00.000000', '', '', '', '', '/profile/info');
INSERT INTO `app_user` VALUES (2, 'pbkdf2_sha256$1000000$PPhegJmgl5YyIq9GrnXVcB$JDsa1e1MsLAYlEPI6Ac87wxTCTrAnApiK7cURehThp4=', NULL, 0, '123456', '', '', '', 0, 1, '2025-08-13 10:39:33.571919', '', '', '', '', '/profile/info');

-- ----------------------------
-- Table structure for app_user_groups
-- ----------------------------
DROP TABLE IF EXISTS `app_user_groups`;
CREATE TABLE `app_user_groups`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `group_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `App_user_groups_user_id_group_id_8fedc2e4_uniq`(`user_id` ASC, `group_id` ASC) USING BTREE,
  INDEX `App_user_groups_group_id_fb4ca4e6_fk_auth_group_id`(`group_id` ASC) USING BTREE,
  CONSTRAINT `App_user_groups_group_id_fb4ca4e6_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `App_user_groups_user_id_00019dc6_fk_App_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_user_groups
-- ----------------------------
INSERT INTO `app_user_groups` VALUES (1, 1, 1);

-- ----------------------------
-- Table structure for app_user_user_permissions
-- ----------------------------
DROP TABLE IF EXISTS `app_user_user_permissions`;
CREATE TABLE `app_user_user_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `App_user_user_permissions_user_id_permission_id_c080f143_uniq`(`user_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `App_user_user_permis_permission_id_16ceac54_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `App_user_user_permis_permission_id_16ceac54_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `App_user_user_permissions_user_id_43adc0ee_fk_App_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of app_user_user_permissions
-- ----------------------------
INSERT INTO `app_user_user_permissions` VALUES (1, 1, 1);
INSERT INTO `app_user_user_permissions` VALUES (2, 1, 2);
INSERT INTO `app_user_user_permissions` VALUES (3, 1, 3);
INSERT INTO `app_user_user_permissions` VALUES (4, 1, 4);
INSERT INTO `app_user_user_permissions` VALUES (5, 1, 5);
INSERT INTO `app_user_user_permissions` VALUES (6, 1, 6);
INSERT INTO `app_user_user_permissions` VALUES (7, 1, 7);
INSERT INTO `app_user_user_permissions` VALUES (8, 1, 8);
INSERT INTO `app_user_user_permissions` VALUES (9, 1, 9);
INSERT INTO `app_user_user_permissions` VALUES (10, 1, 10);
INSERT INTO `app_user_user_permissions` VALUES (11, 1, 11);
INSERT INTO `app_user_user_permissions` VALUES (12, 1, 12);
INSERT INTO `app_user_user_permissions` VALUES (13, 1, 13);
INSERT INTO `app_user_user_permissions` VALUES (14, 1, 14);
INSERT INTO `app_user_user_permissions` VALUES (15, 1, 15);
INSERT INTO `app_user_user_permissions` VALUES (16, 1, 16);
INSERT INTO `app_user_user_permissions` VALUES (17, 1, 17);
INSERT INTO `app_user_user_permissions` VALUES (18, 1, 18);
INSERT INTO `app_user_user_permissions` VALUES (19, 1, 19);
INSERT INTO `app_user_user_permissions` VALUES (20, 1, 20);
INSERT INTO `app_user_user_permissions` VALUES (21, 1, 21);
INSERT INTO `app_user_user_permissions` VALUES (22, 1, 22);
INSERT INTO `app_user_user_permissions` VALUES (23, 1, 23);
INSERT INTO `app_user_user_permissions` VALUES (24, 1, 24);
INSERT INTO `app_user_user_permissions` VALUES (25, 1, 25);
INSERT INTO `app_user_user_permissions` VALUES (26, 1, 26);
INSERT INTO `app_user_user_permissions` VALUES (27, 1, 27);
INSERT INTO `app_user_user_permissions` VALUES (28, 1, 28);

-- ----------------------------
-- Table structure for auth_group
-- ----------------------------
DROP TABLE IF EXISTS `auth_group`;
CREATE TABLE `auth_group`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(150) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `name`(`name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group
-- ----------------------------
INSERT INTO `auth_group` VALUES (1, '管理员');

-- ----------------------------
-- Table structure for auth_group_permissions
-- ----------------------------
DROP TABLE IF EXISTS `auth_group_permissions`;
CREATE TABLE `auth_group_permissions`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `group_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_group_permissions_group_id_permission_id_0cd325b0_uniq`(`group_id` ASC, `permission_id` ASC) USING BTREE,
  INDEX `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm`(`permission_id` ASC) USING BTREE,
  CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_group_permissions
-- ----------------------------
INSERT INTO `auth_group_permissions` VALUES (1, 1, 21);
INSERT INTO `auth_group_permissions` VALUES (2, 1, 22);
INSERT INTO `auth_group_permissions` VALUES (3, 1, 23);
INSERT INTO `auth_group_permissions` VALUES (4, 1, 24);
INSERT INTO `auth_group_permissions` VALUES (5, 1, 25);
INSERT INTO `auth_group_permissions` VALUES (6, 1, 26);
INSERT INTO `auth_group_permissions` VALUES (7, 1, 27);
INSERT INTO `auth_group_permissions` VALUES (8, 1, 28);

-- ----------------------------
-- Table structure for auth_permission
-- ----------------------------
DROP TABLE IF EXISTS `auth_permission`;
CREATE TABLE `auth_permission`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NOT NULL,
  `codename` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `auth_permission_content_type_id_codename_01ab375a_uniq`(`content_type_id` ASC, `codename` ASC) USING BTREE,
  CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of auth_permission
-- ----------------------------
INSERT INTO `auth_permission` VALUES (1, 'Can add log entry', 1, 'add_logentry');
INSERT INTO `auth_permission` VALUES (2, 'Can change log entry', 1, 'change_logentry');
INSERT INTO `auth_permission` VALUES (3, 'Can delete log entry', 1, 'delete_logentry');
INSERT INTO `auth_permission` VALUES (4, 'Can view log entry', 1, 'view_logentry');
INSERT INTO `auth_permission` VALUES (5, 'Can add permission', 2, 'add_permission');
INSERT INTO `auth_permission` VALUES (6, 'Can change permission', 2, 'change_permission');
INSERT INTO `auth_permission` VALUES (7, 'Can delete permission', 2, 'delete_permission');
INSERT INTO `auth_permission` VALUES (8, 'Can view permission', 2, 'view_permission');
INSERT INTO `auth_permission` VALUES (9, 'Can add group', 3, 'add_group');
INSERT INTO `auth_permission` VALUES (10, 'Can change group', 3, 'change_group');
INSERT INTO `auth_permission` VALUES (11, 'Can delete group', 3, 'delete_group');
INSERT INTO `auth_permission` VALUES (12, 'Can view group', 3, 'view_group');
INSERT INTO `auth_permission` VALUES (13, 'Can add content type', 4, 'add_contenttype');
INSERT INTO `auth_permission` VALUES (14, 'Can change content type', 4, 'change_contenttype');
INSERT INTO `auth_permission` VALUES (15, 'Can delete content type', 4, 'delete_contenttype');
INSERT INTO `auth_permission` VALUES (16, 'Can view content type', 4, 'view_contenttype');
INSERT INTO `auth_permission` VALUES (17, 'Can add session', 5, 'add_session');
INSERT INTO `auth_permission` VALUES (18, 'Can change session', 5, 'change_session');
INSERT INTO `auth_permission` VALUES (19, 'Can delete session', 5, 'delete_session');
INSERT INTO `auth_permission` VALUES (20, 'Can view session', 5, 'view_session');
INSERT INTO `auth_permission` VALUES (21, 'Can add 菜单', 6, 'add_menu');
INSERT INTO `auth_permission` VALUES (22, 'Can change 菜单', 6, 'change_menu');
INSERT INTO `auth_permission` VALUES (23, 'Can delete 菜单', 6, 'delete_menu');
INSERT INTO `auth_permission` VALUES (24, 'Can view 菜单', 6, 'view_menu');
INSERT INTO `auth_permission` VALUES (25, 'Can add user', 7, 'add_user');
INSERT INTO `auth_permission` VALUES (26, 'Can change user', 7, 'change_user');
INSERT INTO `auth_permission` VALUES (27, 'Can delete user', 7, 'delete_user');
INSERT INTO `auth_permission` VALUES (28, 'Can view user', 7, 'view_user');

-- ----------------------------
-- Table structure for django_admin_log
-- ----------------------------
DROP TABLE IF EXISTS `django_admin_log`;
CREATE TABLE `django_admin_log`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL,
  `object_repr` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `action_flag` smallint UNSIGNED NOT NULL,
  `change_message` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `content_type_id` int NULL DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `django_admin_log_content_type_id_c4bce8eb_fk_django_co`(`content_type_id` ASC) USING BTREE,
  INDEX `django_admin_log_user_id_c564eba6_fk_App_user_id`(`user_id` ASC) USING BTREE,
  CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_user_id_c564eba6_fk_App_user_id` FOREIGN KEY (`user_id`) REFERENCES `app_user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `django_admin_log_chk_1` CHECK (`action_flag` >= 0)
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_admin_log
-- ----------------------------
INSERT INTO `django_admin_log` VALUES (1, '2025-08-13 09:20:38.003407', '1', '管理员', 1, '[{\"added\": {}}]', 3, 1);
INSERT INTO `django_admin_log` VALUES (2, '2025-08-13 09:37:48.525198', '1', 'ProfileInfo', 1, '[{\"added\": {}}]', 6, 1);
INSERT INTO `django_admin_log` VALUES (3, '2025-08-13 09:38:36.211458', '2', 'ProfileSecurity', 1, '[{\"added\": {}}]', 6, 1);
INSERT INTO `django_admin_log` VALUES (4, '2025-08-13 09:54:06.113665', '1', 'admin', 2, '[{\"changed\": {\"fields\": [\"Groups\", \"User permissions\", \"Last login\"]}}]', 7, 1);
INSERT INTO `django_admin_log` VALUES (5, '2025-08-13 10:01:27.253243', '1', 'admin', 2, '[{\"changed\": {\"fields\": [\"Home path\"]}}]', 7, 1);
INSERT INTO `django_admin_log` VALUES (6, '2025-08-13 10:54:05.666263', '1', 'ProfileInfo', 2, '[{\"changed\": {\"fields\": [\"Meta\"]}}]', 6, 1);
INSERT INTO `django_admin_log` VALUES (7, '2025-08-13 10:55:11.620893', '1', 'ProfileInfo', 2, '[{\"changed\": {\"fields\": [\"Meta\"]}}]', 6, 1);
INSERT INTO `django_admin_log` VALUES (8, '2025-08-13 10:56:06.087017', '2', 'ProfileSecurity', 2, '[{\"changed\": {\"fields\": [\"Meta\"]}}]', 6, 1);

-- ----------------------------
-- Table structure for django_content_type
-- ----------------------------
DROP TABLE IF EXISTS `django_content_type`;
CREATE TABLE `django_content_type`  (
  `id` int NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `model` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `django_content_type_app_label_model_76bd3d3b_uniq`(`app_label` ASC, `model` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 8 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_content_type
-- ----------------------------
INSERT INTO `django_content_type` VALUES (1, 'admin', 'logentry');
INSERT INTO `django_content_type` VALUES (6, 'App', 'menu');
INSERT INTO `django_content_type` VALUES (7, 'App', 'user');
INSERT INTO `django_content_type` VALUES (3, 'auth', 'group');
INSERT INTO `django_content_type` VALUES (2, 'auth', 'permission');
INSERT INTO `django_content_type` VALUES (4, 'contenttypes', 'contenttype');
INSERT INTO `django_content_type` VALUES (5, 'sessions', 'session');

-- ----------------------------
-- Table structure for django_migrations
-- ----------------------------
DROP TABLE IF EXISTS `django_migrations`;
CREATE TABLE `django_migrations`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `app` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_migrations
-- ----------------------------
INSERT INTO `django_migrations` VALUES (1, 'contenttypes', '0001_initial', '2025-08-13 03:58:05.884582');
INSERT INTO `django_migrations` VALUES (2, 'contenttypes', '0002_remove_content_type_name', '2025-08-13 03:58:06.001372');
INSERT INTO `django_migrations` VALUES (3, 'auth', '0001_initial', '2025-08-13 03:58:06.379206');
INSERT INTO `django_migrations` VALUES (4, 'auth', '0002_alter_permission_name_max_length', '2025-08-13 03:58:06.470098');
INSERT INTO `django_migrations` VALUES (5, 'auth', '0003_alter_user_email_max_length', '2025-08-13 03:58:06.476089');
INSERT INTO `django_migrations` VALUES (6, 'auth', '0004_alter_user_username_opts', '2025-08-13 03:58:06.483240');
INSERT INTO `django_migrations` VALUES (7, 'auth', '0005_alter_user_last_login_null', '2025-08-13 03:58:06.490233');
INSERT INTO `django_migrations` VALUES (8, 'auth', '0006_require_contenttypes_0002', '2025-08-13 03:58:06.493218');
INSERT INTO `django_migrations` VALUES (9, 'auth', '0007_alter_validators_add_error_messages', '2025-08-13 03:58:06.500216');
INSERT INTO `django_migrations` VALUES (10, 'auth', '0008_alter_user_username_max_length', '2025-08-13 03:58:06.508932');
INSERT INTO `django_migrations` VALUES (11, 'auth', '0009_alter_user_last_name_max_length', '2025-08-13 03:58:06.517462');
INSERT INTO `django_migrations` VALUES (12, 'auth', '0010_alter_group_name_max_length', '2025-08-13 03:58:06.538655');
INSERT INTO `django_migrations` VALUES (13, 'auth', '0011_update_proxy_permissions', '2025-08-13 03:58:06.551212');
INSERT INTO `django_migrations` VALUES (14, 'auth', '0012_alter_user_first_name_max_length', '2025-08-13 03:58:06.558748');
INSERT INTO `django_migrations` VALUES (15, 'App', '0001_initial', '2025-08-13 03:58:07.237739');
INSERT INTO `django_migrations` VALUES (16, 'admin', '0001_initial', '2025-08-13 03:58:07.520384');
INSERT INTO `django_migrations` VALUES (17, 'admin', '0002_logentry_remove_auto_add', '2025-08-13 03:58:07.537010');
INSERT INTO `django_migrations` VALUES (18, 'admin', '0003_logentry_add_action_flag_choices', '2025-08-13 03:58:07.557198');
INSERT INTO `django_migrations` VALUES (19, 'sessions', '0001_initial', '2025-08-13 03:58:07.637157');
INSERT INTO `django_migrations` VALUES (20, 'App', '0002_alter_user_homepath', '2025-08-13 10:57:34.630759');

-- ----------------------------
-- Table structure for django_session
-- ----------------------------
DROP TABLE IF EXISTS `django_session`;
CREATE TABLE `django_session`  (
  `session_key` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `session_data` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`) USING BTREE,
  INDEX `django_session_expire_date_a5c62663`(`expire_date` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of django_session
-- ----------------------------
INSERT INTO `django_session` VALUES ('q9zbvrqb8dqclcvwx8fvxli4bmv2dk41', '.eJxVjEEOwiAQAP_C2RBclkU8evcNBHZRqoYmpT0Z_25IetDrzGTeKqZtrXHrZYmTqLM6qsMvy4mfpQ0hj9Tus-a5rcuU9Uj0bru-zlJel739G9TU69gaYPRAINYaIaIE2WN2gOFGgjk5ADzZwEjGW8-OMdhgCE1h8daozxeoyjZI:1um2dp:fZxeRs6_shpwjkeTKCyu8cCZFfSZ6eRcHuaGmJGnZBY', '2025-08-27 03:59:09.041136');

SET FOREIGN_KEY_CHECKS = 1;
