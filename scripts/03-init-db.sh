#!/bin/bash

# --- Project Team Node-A 数据库初始化脚本 (v1.0.0) ---

echo "🗄️ 正在检测并初始化 Project Team 数据库环境..."

# 1. 检查容器是否在线
if ! docker ps | grep -q insight-db; then
    echo "❌ 错误: insight-db 容器未运行。请先执行 startup.sh"
    exit 1
fi

# 2. 自动化创建数据库与授权
# 使用 heredoc 将多行指令推送到容器内的 psql
docker exec -i insight-db psql -U insight_admin -d postgres <<EOF
-- 如果 n8n_db 不存在则创建
SELECT 'CREATE DATABASE n8n_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'n8n_db')\gexec

-- 确保权限完整
GRANT ALL PRIVILEGES ON DATABASE n8n_db TO insight_admin;
EOF

echo "✅ 数据库 n8n_db 检查/创建完成。"
