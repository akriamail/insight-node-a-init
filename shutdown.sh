#!/bin/bash

# --- Project Team Node-A 一键停止脚本 v1.00 ---
COMPOSE_DIR="/opt/insight-ai/insight-node-a-init/compose"

echo "🛑 Stopping Project Team Node-A Services..."

# 1. 先停掉业务应用 (应用层)
echo "--- [1/3] Stopping Applications ---"
docker compose -f $COMPOSE_DIR/06-knowledge.yml down
docker compose -f $COMPOSE_DIR/05-data-viz.yml down
docker compose -f $COMPOSE_DIR/04-workflow.yml down

# 2. 停掉数据底座 (数据层)
echo "--- [2/3] Stopping Database ---"
docker compose -f $COMPOSE_DIR/03-databases.yml down

# 3. 最后停掉网关 (接入层)
echo "--- [3/3] Stopping Infrastructure ---"
docker compose -f $COMPOSE_DIR/01-gateway.yml down

echo "✅ All services stopped and containers removed."
echo "--------------------------------------"
docker ps -a
