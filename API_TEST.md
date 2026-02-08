# API 测试文档

## 概述

本文档说明了如何测试 `qa-service-user` 服务中的医生相关 API。

## 前置条件

在运行测试之前，请确保：

1. MySQL 数据库已启动并运行
2. `qa-service-user` 服务已启动并运行在端口 8080
3. 数据库初始化脚本已执行，包含了初始的医生数据

### 启动服务

#### 1. 启动 MySQL 数据库

```bash
docker-compose up -d
```

这将启动 MySQL 数据库和 phpMyAdmin 管理界面：
- MySQL: `localhost:3306`
- phpMyAdmin: `http://localhost:8081`

#### 2. 启动后端服务

进入 `server/qa-service-user` 目录，运行：

```bash
cd server/qa-service-user
./mvnw spring-boot:run
```

或者：

```bash
cd server/qa-service-user
mvn spring-boot:run
```

服务将在 `http://localhost:8080` 启动。

## API 端点列表

| 方法 | 端点 | 描述 |
|------|------|------|
| GET | `/api/doctors` | 获取所有医生列表 |
| GET | `/api/doctors/active` | 获取活跃医生列表 |
| GET | `/api/doctors/{id}` | 根据 ID 获取医生信息 |
| GET | `/api/doctors/username/{username}` | 根据用户名获取医生信息 |
| POST | `/api/doctors` | 创建新医生 |
| PUT | `/api/doctors/{id}` | 更新医生信息 |
| DELETE | `/api/doctors/{id}` | 删除医生 |
| GET | `/api/doctors/health` | 健康检查 |

## 执行测试

### Windows 用户

使用 Windows 批处理脚本执行测试：

```bash
cd tests
api_test_windows.bat
```

### Linux/macOS 用户

使用 Bash 脚本执行测试：

```bash
cd tests
chmod +x api_test.sh
./api_test.sh
```

## 手动测试示例

### 1. 健康检查

```bash
curl http://localhost:8080/api/doctors/health
```

**预期响应：**

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

### 2. 获取所有医生

```bash
curl http://localhost:8080/api/doctors
```

**预期响应：**

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
    // ... 更多医生数据
  ],
  "timestamp": "2026-02-08T12:00:00"
}
```

### 3. 获取活跃医生

```bash
curl http://localhost:8080/api/doctors/active
```

**预期响应：**

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
    // ... 只返回 isActive = true 的医生
  ],
  "timestamp": "2026-02-08T12:00:00"
}
```

### 4. 根据 ID 获取医生

```bash
curl http://localhost:8080/api/doctors/doc001
```

**预期响应：**

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

### 5. 创建新医生

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

**预期响应：**

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

### 6. 更新医生信息

```bash
curl -X PUT http://localhost:8080/api/doctors/doc006 \
  -H "Content-Type: application/json" \
  -d '{
    "id": "doc006",
    "username": "dr-new-doctor",
    "password": "password123",
    "name": "新医生-更新",
    "title": "副主任医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "6年临床经验",
    "specialties": ["外科手术", "创伤修复", "微创手术"],
    "isActive": true
  }'
```

**预期响应：**

```json
{
  "code": 200,
  "message": "Doctor updated successfully",
  "data": {
    "id": "doc006",
    "username": "dr-new-doctor",
    "name": "新医生-更新",
    "title": "副主任医师",
    "department": "外科",
    "avatar": "https://images.pexels.com/photos/5215024/pexels-photo-5215024.jpeg?auto=compress&cs=tinysrgb&w=400",
    "experience": "6年临床经验",
    "specialties": ["外科手术", "创伤修复", "微创手术"],
    "isActive": true
  },
  "timestamp": "2026-02-08T12:00:00"
}
```

### 7. 删除医生

```bash
curl -X DELETE http://localhost:8080/api/doctors/doc006
```

**预期响应：**

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

### 8. 错误处理示例

请求不存在的医生：

```bash
curl http://localhost:8080/api/doctors/nonexistent
```

**预期响应（404）：**

```json
{
  "code": 404,
  "message": "Doctor not found",
  "data": null,
  "timestamp": "2026-02-08T12:00:00"
}
```

## 使用 phpMyAdmin 管理数据库

访问 phpMyAdmin 管理界面：

- URL: `http://localhost:8081`
- 用户名: `qa_user`
- 密码: `qa_password`

在 phpMyAdmin 中，你可以：

1. 查看 `doctors` 表的数据
2. 执行 SQL 查询
3. 修改或删除医生数据
4. 监控数据库状态

## 测试检查清单

完成以下测试以确保 API 正常工作：

- [ ] 健康检查端点返回 200
- [ ] 获取所有医生列表成功
- [ ] 获取活跃医生列表成功
- [ ] 根据 ID 获取医生信息成功
- [ ] 根据用户名获取医生信息成功
- [ ] 创建新医生成功
- [ ] 更新医生信息成功
- [ ] 删除医生成功
- [ ] 请求不存在的资源返回 404
- [ ] 创建重复用户名返回 400 错误

## 故障排除

### 问题：无法连接到数据库

**解决方案：**

1. 检查 Docker 容器是否正在运行：
   ```bash
   docker ps
   ```

2. 查看容器日志：
   ```bash
   docker logs qa-healthcare-mysql
   ```

3. 确保 `application.properties` 中的数据库配置正确

### 问题：API 返回 500 错误

**解决方案：**

1. 查看后端服务日志，找到错误堆栈信息
2. 检查数据库连接是否正常
3. 确认数据库表已正确创建

### 问题：前端无法调用 API

**解决方案：**

1. 确认 CORS 配置已正确设置
2. 检查后端服务是否正在运行
3. 确认 API URL 正确

## 总结

本测试套件涵盖了 `qa-service-user` 服务中所有医生相关的 API 端点。通过运行这些测试，可以验证：

- API 端点的正确性
- 数据的完整性和一致性
- 错误处理机制
- 与 MySQL 数据库的集成

如有任何问题或建议，请联系开发团队。
