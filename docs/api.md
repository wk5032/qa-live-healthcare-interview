# qa-service-user API 文档

## 服务概述

`qa-service-user` 是 QA 医疗问诊系统中的用户管理服务，主要负责管理医生信息、患者信息以及相关的认证和授权功能。

### 基本信息

- **服务名称**: qa-service-user
- **版本**: 0.0.1-SNAPSHOT
- **端口**: 8080
- **技术栈**: Spring Boot 3.5.7, JPA, MySQL 8.0

### 服务端点

- **API 基础路径**: `http://localhost:8080/api`
- **Actuator 管理端点**: `http://localhost:8080/actuator`

---

## 健康检查

### GET /actuator/health

检查服务的健康状态。

**请求示例：**

```bash
curl http://localhost:8080/actuator/health
```

**响应示例：**

```json
{
  "status": "UP",
  "components": {
    "db": {
      "status": "UP",
      "details": {
        "database": "MySQL",
        "validationQuery": "isValid()"
      }
    },
    "diskSpace": {
      "status": "UP",
      "details": {
        "total": 499963174912,
        "free": 268665942016,
        "threshold": 10485760,
        "path": "./",
        "exists": true
      }
    },
    "ping": {
      "status": "UP"
    }
  },
  "groups": [
    "liveness",
    "readiness"
  ]
}
```

### GET /actuator/info

获取应用信息。

**请求示例：**

```bash
curl http://localhost:8080/actuator/info
```

**响应示例：**

```json
{
  "app": {
    "name": "qa-service-user",
    "description": "QA Service User - Healthcare QA System User Management Service",
    "version": "0.0.1-SNAPSHOT",
    "encoding": "UTF-8",
    "java": {
      "version": "17"
    },
    "team": "QA Healthcare Team",
    "environment": "development",
    "build": {
      "timestamp": "2025-11-03"
    },
    "features": [
      "CORS",
      "Actuator",
      "Health Checks",
      "User Management",
      "MySQL Database"
    ]
  }
}
```

---

## CORS 测试端点

### GET /api/test/cors

测试 CORS 配置是否正常工作。

**请求示例：**

```bash
curl http://localhost:8080/api/test/cors
```

**响应示例：**

```json
{
  "message": "CORS configuration is working!",
  "timestamp": 1707355200000,
  "service": "qa-service-user"
}
```

### POST /api/test/cors

测试 POST 请求的 CORS 配置。

**请求示例：**

```bash
curl -X POST http://localhost:8080/api/test/cors \
  -H "Content-Type: application/json" \
  -d '{"test": "data"}'
```

**响应示例：**

```json
{
  "message": "POST request with CORS is working!",
  "receivedData": {
    "test": "data"
  },
  "timestamp": 1707355200000,
  "service": "qa-service-user"
}
```

---

## 医生管理 API

### 概述

医生管理 API 提供了对医生信息的完整 CRUD 操作，包括获取医生列表、根据条件查询、创建、更新和删除医生等操作。

### 数据模型

#### Doctor 对象

| 字段 | 类型 | 描述 | 必填 |
|------|------|------|------|
| id | String | 医生唯一标识符 | 是 |
| username | String | 登录用户名（唯一） | 是 |
| password | String | 密码 | 是 |
| name | String | 医生姓名 | 是 |
| title | String | 职称 | 是 |
| department | String | 科室 | 是 |
| avatar | String | 头像 URL | 否 |
| experience | String | 从业经验 | 否 |
| specialties | Array | 专业特长 | 否 |
| isActive | Boolean | 是否活跃 | 是 |

---

### GET /api/doctors

获取所有医生列表。

**请求参数：**

无

**请求示例：**

```bash
curl http://localhost:8080/api/doctors
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Success",
  "data": [
    {
      "id": "doc001",
      "username": "dr-zhang-wei",
      "name": "张伟医生",
      "title": "主任医师",
      "department": "心内科",
      "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
      "experience": "15年临床经验",
      "specialties": ["高血压", "冠心病", "心律失常"],
      "isActive": true
    },
    {
      "id": "doc002",
      "username": "dr-li-na",
      "name": "李娜医生",
      "title": "副主任医师",
      "department": "儿科",
      "avatar": "https://images.pexels.com/photos/5327585/pexels-photo-5327585.jpeg?auto=compress&cs=tinysrgb&w=400",
      "experience": "10年临床经验",
      "specialties": ["儿童感冒", "儿童发育", "疫苗接种"],
      "isActive": true
    }
  ],
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功返回医生列表
- `500 Internal Server Error`: 服务器内部错误

---

### GET /api/doctors/active

获取活跃医生列表（`isActive = true` 的医生）。

**请求参数：**

无

**请求示例：**

```bash
curl http://localhost:8080/api/doctors/active
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Success",
  "data": [
    {
      "id": "doc001",
      "username": "dr-zhang-wei",
      "name": "张伟医生",
      "title": "主任医师",
      "department": "心内科",
      "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
      "experience": "15年临床经验",
      "specialties": ["高血压", "冠心病", "心律失常"],
      "isActive": true
    }
  ],
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功返回活跃医生列表
- `500 Internal Server Error`: 服务器内部错误

---

### GET /api/doctors/{id}

根据医生 ID 获取医生信息。

**路径参数：**

| 参数 | 类型 | 描述 |
|------|------|------|
| id | String | 医生 ID |

**请求示例：**

```bash
curl http://localhost:8080/api/doctors/doc001
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    "id": "doc001",
    "username": "dr-zhang-wei",
    "name": "张伟医生",
    "title": "主任医师",
    "department": "心内科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "15年临床经验",
    "specialties": ["高血压", "冠心病", "心律失常"],
    "isActive": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功返回医生信息
- `404 Not Found`: 医生不存在
- `500 Internal Server Error`: 服务器内部错误

---

### GET /api/doctors/username/{username}

根据用户名获取医生信息。

**路径参数：**

| 参数 | 类型 | 描述 |
|------|------|------|
| username | String | 医生用户名 |

**请求示例：**

```bash
curl http://localhost:8080/api/doctors/username/dr-zhang-wei
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    "id": "doc001",
    "username": "dr-zhang-wei",
    "name": "张伟医生",
    "title": "主任医师",
    "department": "心内科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "15年临床经验",
    "specialties": ["高血压", "冠心病", "心律失常"],
    "isActive": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功返回医生信息
- `404 Not Found`: 医生不存在
- `500 Internal Server Error`: 服务器内部错误

---

### POST /api/doctors

创建新医生。

**请求头：**

```
Content-Type: application/json
```

**请求体：**

```json
{
  "id": "doc006",
  "username": "dr-new-doctor",
  "password": "password123",
  "name": "新医生",
  "title": "主治医师",
  "department": "外科",
  "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
  "experience": "5年临床经验",
  "specialties": ["外科手术", "创伤修复"],
  "isActive": true
}
```

**请求示例：**

```bash
curl -X POST http://localhost:8080/api/doctors \
  -H "Content-Type: application/json" \
  -d '{
    "id": "doc006",
    "username": "dr-new-doctor",
    "password": "password123",
    "name": "新医生",
    "title": "主治医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "5年临床经验",
    "specialties": ["外科手术", "创伤修复"],
    "isActive": true
  }'
```

**响应示例：**

```json
{
  "code": 201,
  "message": "Doctor created successfully",
  "data": {
    "id": "doc006",
    "username": "dr-new-doctor",
    "name": "新医生",
    "title": "主治医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "5年临床经验",
    "specialties": ["外科手术", "创伤修复"],
    "isActive": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `201 Created`: 成功创建医生
- `400 Bad Request`: 请求参数错误或用户名已存在
- `500 Internal Server Error`: 服务器内部错误

---

### PUT /api/doctors/{id}

更新医生信息。

**路径参数：**

| 参数 | 类型 | 描述 |
|------|------|------|
| id | String | 医生 ID |

**请求头：**

```
Content-Type: application/json
```

**请求体：**

```json
{
  "id": "doc001",
  "username": "dr-zhang-wei",
  "password": "123456",
  "name": "张伟医生",
  "title": "主任医师",
  "department": "心内科",
  "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
  "experience": "16年临床经验",
  "specialties": ["高血压", "冠心病", "心律失常", "心衰"],
  "isActive": true
}
```

**请求示例：**

```bash
curl -X PUT http://localhost:8080/api/doctors/doc001 \
  -H "Content-Type: application/json" \
  -d '{
    "id": "doc001",
    "username": "dr-zhang-wei",
    "password": "123456",
    "name": "张伟医生",
    "title": "主任医师",
    "department": "心内科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "16年临床经验",
    "specialties": ["高血压", "冠心病", "心律失常", "心衰"],
    "isActive": true
  }'
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Doctor updated successfully",
  "data": {
    "id": "doc001",
    "username": "dr-zhang-wei",
    "name": "张伟医生",
    "title": "主任医师",
    "department": "心内科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "16年临床经验",
    "specialties": ["高血压", "冠心病", "心律失常", "心衰"],
    "isActive": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功更新医生信息
- `400 Bad Request`: 请求参数错误或用户名已存在
- `404 Not Found`: 医生不存在
- `500 Internal Server Error`: 服务器内部错误

---

### DELETE /api/doctors/{id}

删除医生。

**路径参数：**

| 参数 | 类型 | 描述 |
|------|------|------|
| id | String | 医生 ID |

**请求示例：**

```bash
curl -X DELETE http://localhost:8080/api/doctors/doc006
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Doctor deleted successfully",
  "data": {
    "deleted": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 成功删除医生
- `404 Not Found`: 医生不存在
- `500 Internal Server Error`: 服务器内部错误

---

### GET /api/doctors/health

医生 API 健康检查端点。

**请求示例：**

```bash
curl http://localhost:8080/api/doctors/health
```

**响应示例：**

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    "service": "qa-service-user",
    "endpoint": "doctors",
    "status": "healthy"
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

**状态码：**

- `200 OK`: 服务健康

---

## 通用响应格式

所有 API 响应遵循以下统一格式：

```json
{
  "code": 200,
  "message": "Success",
  "data": {
    // 响应数据
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

| 字段 | 类型 | 描述 |
|------|------|------|
| code | Integer | 响应状态码 |
| message | String | 响应消息 |
| data | Object/Array | 响应数据（可能为 null） |
| timestamp | String | 响应时间戳（ISO 8601 格式） |

### 常见状态码

| Code | Message | 描述 |
|------|---------|------|
| 200 | Success | 请求成功 |
| 201 | Created | 资源创建成功 |
| 400 | Bad Request | 请求参数错误 |
| 404 | Not Found | 资源不存在 |
| 500 | Internal Server Error | 服务器内部错误 |

---

## 错误处理

### 示例 1：医生不存在

**请求：**

```bash
curl http://localhost:8080/api/doctors/nonexistent
```

**响应：**

```json
{
  "code": 404,
  "message": "Doctor not found",
  "data": null,
  "timestamp": "2026-02-08T12:00:00"
}
```

### 示例 2：用户名已存在

**请求：**

```bash
curl -X POST http://localhost:8080/api/doctors \
  -H "Content-Type: application/json" \
  -d '{
    "id": "doc007",
    "username": "dr-zhang-wei",
    "password": "123456",
    "name": "重复用户名医生",
    "title": "主治医师",
    "department": "外科",
    "isActive": true
  }'
```

**响应：**

```json
{
  "code": 400,
  "message": "Username already exists",
  "data": null,
  "timestamp": "2026-02-08T12:00:00"
}
```

---

## CORS 配置

本服务已配置 CORS（跨域资源共享），允许来自任何源的请求。

**CORS 配置：**

- 允许的源: `*`（所有源）
- 允许的方法: `GET`, `POST`, `PUT`, `DELETE`, `OPTIONS`
- 允许的请求头: `*`（所有请求头）
- 允许凭据: `false`
- 预检请求缓存时间: `3600` 秒

---

## 数据库信息

### 数据库配置

| 配置项 | 值 |
|--------|-----|
| 数据库类型 | MySQL 8.0 |
| 数据库名称 | qa_healthcare |
| 主机 | localhost |
| 端口 | 3306 |
| 用户名 | qa_user |
| 密码 | qa_password |

### 数据库表结构

#### doctors 表

| 字段 | 类型 | 约束 | 描述 |
|------|------|------|------|
| id | VARCHAR(50) | PRIMARY KEY | 医生 ID |
| username | VARCHAR(50) | UNIQUE, NOT NULL | 用户名 |
| password | VARCHAR(100) | NOT NULL | 密码 |
| name | VARCHAR(100) | NOT NULL | 姓名 |
| title | VARCHAR(50) | NOT NULL | 职称 |
| department | VARCHAR(50) | NOT NULL | 科室 |
| avatar | TEXT | - | 头像 URL |
| experience | VARCHAR(100) | - | 从业经验 |
| specialties | JSON | - | 专业特长 |
| is_active | BOOLEAN | NOT NULL | 是否活跃 |
| created_at | TIMESTAMP | - | 创建时间 |
| updated_at | TIMESTAMP | - | 更新时间 |

---

## 使用 phpMyAdmin 管理

phpMyAdmin 提供了一个基于 Web 的数据库管理界面。

**访问信息：**

- URL: `http://localhost:8081`
- 用户名: `qa_user`
- 密码: `qa_password`

**功能：**

- 查看和编辑数据库表
- 执行 SQL 查询
- 导入/导出数据
- 监控数据库性能

---

## 测试

详细的测试指南请参考 [API_TEST.md](../API_TEST.md)。

### 快速测试

启动服务后，可以运行以下命令进行快速测试：

```bash
# Windows
tests/api_test_windows.bat

# Linux/macOS
tests/api_test.sh
```

---

## 部署

### 使用 Docker Compose

```bash
# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f

# 停止服务
docker-compose down
```

### 手动部署

1. 启动 MySQL 数据库
2. 执行初始化脚本 `server/init.sql`
3. 运行 Spring Boot 应用：
   ```bash
   cd server/qa-service-user
   ./mvnw spring-boot:run
   ```

---

## 版本历史

| 版本 | 日期 | 描述 |
|------|------|------|
| 0.0.1-SNAPSHOT | 2026-02-08 | 初始版本，包含医生管理 API |

---

## 联系方式

如有问题或建议，请联系 QA Healthcare Team。
