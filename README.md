# Django VbenAdmin

一个基于 Django + Vue Vben Admin 的全栈管理系统，提供现代化的管理界面和强大的后端API支持。

## 🚀 项目特性

- **后端**: Django 5.2 + Django REST Framework + JWT认证
- **前端**: Vue 3 + TypeScript + Ant Design Vue + Vben Admin
- **数据库**: MySQL 8.0
- **跨域支持**: CORS配置
- **API文档**: Swagger/OpenAPI
- **权限管理**: 基于JWT的认证授权
- **现代化UI**: 响应式设计，支持多种主题

## 📁 项目结构

```
Django_VbenAdmin/
├── Backend/                 # Django后端
│   ├── App/                # Django应用
│   ├── application/        # Django项目配置
│   ├── manage.py          # Django管理脚本
│   └── media/             # 媒体文件
├── Frontend/              # Vue前端
│   ├── apps/
│   │   ├── backend-mock/  # Mock服务
│   │   ├── web-antd/      # Ant Design版本
│   │   ├── web-ele/       # Element Plus版本
│   │   └── web-naive/     # Naive UI版本
│   ├── packages/          # 共享包
│   └── docs/              # 文档
└── 常见命令.md            # 开发命令参考
```

## 🛠️ 技术栈

### 后端技术
- **Django 5.2** - Web框架
- **Django REST Framework** - API框架
- **Django CORS Headers** - 跨域支持
- **Django Simple JWT** - JWT认证
- **Django Filters** - 数据过滤
- **DRF YASG** - API文档生成
- **MySQL** - 数据库

### 前端技术
- **Vue 3** - 前端框架
- **TypeScript** - 类型安全
- **Vite** - 构建工具
- **Pinia** - 状态管理
- **Vue Router** - 路由管理
- **Ant Design Vue** - UI组件库
- **Vben Admin** - 管理后台模板

## 📋 环境要求

- Python 3.8+
- Node.js 16+
- MySQL 8.0+
- Git

## 🔧 安装步骤

### 1. 克隆项目

```bash
git clone git@github.com:wangxiaozeze/Django_Vben.git
cd Django_Vben
```

### 2. 后端环境配置

```bash
# 进入后端目录
cd Backend

# 创建conda环境
conda create -n DjangoEnv python==3.12 -y

# 激活conda环境
conda activate DjangoEnv

# 安装依赖
pip install -r requirements.txt

# 配置数据库
# 创建MySQL数据库: Django_Vben
mysql -u root -p
CREATE DATABASE Django_Vben CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

# 数据库迁移
python manage.py makemigrations
python manage.py migrate

# 创建超级用户
python manage.py createsuperuser

# 运行开发服务器
python manage.py runserver
```

### 3. 前端环境配置

```bash
# 进入前端目录
cd Frontend

# 安装依赖
npm -g install pnpm
pnpm install

# 启动开发服务器
cd apps/web-antd
npm run dev:ele
```

## 🚀 快速开始

### 启动后端服务

```bash
cd Backend
python manage.py runserver
```

后端服务将在 http://localhost:8000 启动

### 启动前端服务

```bash
cd Frontend/apps/web-antd
npm run dev
```

前端服务将在 http://localhost:3000 启动

### 访问系统

- **前端管理界面**: http://localhost:5777
- **后端API文档**: http://localhost:8000/swagger/
- **Django管理后台**: http://localhost:8000/admin/

## 📚 API文档

项目集成了Swagger文档，启动后端服务后访问：
- Swagger UI: http://localhost:8000/swagger/
- ReDoc: http://localhost:8000/redoc/

## 🔐 认证配置

项目使用JWT认证，主要配置包括：

- **JWT设置**: 在 `Backend/application/settings.py` 中配置
- **跨域设置**: 已配置CORS支持前端跨域请求
- **权限管理**: 基于Django内置权限系统

## 🎨 前端主题

项目支持多种UI框架版本：

- **Ant Design Vue**: `Frontend/apps/web-antd/`
- **Element Plus**: `Frontend/apps/web-ele/`
- **Naive UI**: `Frontend/apps/web-naive/`

## 📦 部署

### 生产环境部署

1. **后端部署**
```bash
# 收集静态文件
python manage.py collectstatic

# 使用Gunicorn部署
pip install gunicorn
gunicorn application.wsgi:application --bind 0.0.0.0:8000
```

2. **前端部署**
```bash
# 构建生产版本
npm run build

# 部署到Nginx或其他Web服务器
```


## 🤝 贡献指南

1. Fork 项目
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 打开 Pull Request

## 📝 开发命令

详细的开发命令请参考项目根目录下的 `常见命令.md` 文件。

## 📄 许可证

本项目采用 MIT 许可证 - 查看 [LICENSE](LICENSE) 文件了解详情。

## 🙏 致谢

- [Vben Admin](https://github.com/vbenjs/vue-vben-admin) - 优秀的管理后台模板
- [Django](https://www.djangoproject.com/) - 强大的Python Web框架

## 📞 联系方式

- 项目维护者: wangxiaozeze
- GitHub: [wangxiaozeze/Django_Vben](https://github.com/wangxiaozeze/Django_Vben)

---

⭐ 如果这个项目对您有帮助，请给它一个星标！
