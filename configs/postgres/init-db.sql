-- 创建 4 个独立的数据库
CREATE DATABASE n8n_db;
CREATE DATABASE nocodb_db;
CREATE DATABASE wikijs_db;
CREATE DATABASE teleport_db;

-- 创建一个统一的管理员账号供 Project Team 使用
-- 注意：稍后我们在 .env 文件里设置密码
