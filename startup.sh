#!/bin/bash

# --- Project Team Node-A 一键启动脚本 v1.00 ---
COMPOSE_DIR="/opt/insight-ai/insight-node-a-init/compose"

echo "🚀 Starting Project Team Node-A Services..."

# 1. 检查并拉起基础网络服务 (Gateway & Security)
echo "--- [1/3] Launching Infrastructure ---"
docker compose -f $COMPOSE_DIR/01-gateway.yml up -d

# 2. 拉起数据底座 (必须在应用启动前 Ready)
echo "--- [2/3] Launching Database ---"
docker compose -f $COMPOSE_DIR/03-databases.yml up -d

# 稍微等待数据库初始化，防止应用连接过快导致报错
echo "Waiting for database to settle..."
sleep 5

# 3. 按序拉起所有业务应用
echo "--- [3/3] Launching Applications ---"
docker compose -f $COMPOSE_DIR/04-workflow.yml up -d
docker compose -f $COMPOSE_DIR/05-data-viz.yml up -d
docker compose -f $COMPOSE_DIR/06-knowledge.yml up -d

echo "✅ All services initiated!"
echo "--------------------------------------"
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
