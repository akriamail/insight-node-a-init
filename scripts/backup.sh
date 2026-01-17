#!/bin/bash

# --- Project Team Node-A 综合备份脚本 (v1.0.0 完整版) ---

# 1. 自动定位路径
REPO_DIR=$(cd "$(dirname "$0")/.."; pwd)
PARENT_DIR=$(cd "$REPO_DIR/.."; pwd)  # 获取 /opt/insight-ai 目录
BACKUP_ROOT="$PARENT_DIR/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# 2. 创建备份目录
mkdir -p $BACKUP_ROOT/postgres
mkdir -p $BACKUP_ROOT/gateway

echo "📂 开始备份 Project Team Node-A 数据..."

# 3. 备份 Postgres 数据库 (n8n & NocoDB)
export PGPASSWORD='z1a2q3W4!@#'
echo "--- [1/2] 正在导出 Postgres 数据库... ---"
docker exec insight-db pg_dump -U insight_admin n8n_db | gzip > $BACKUP_ROOT/postgres/n8n_db_$TIMESTAMP.sql.gz

# 4. 备份 NPM 全部配置 (包含核心数据库及 SSL 证书)
# 我们直接打包整个 01-gateway 目录，这是最稳妥的恢复方式
echo "--- [2/2] 正在打包 NPM 配置文件与 SSL 证书... ---"
tar -czf $BACKUP_ROOT/gateway/npm_full_config_$TIMESTAMP.tar.gz -C $PARENT_DIR/01-gateway .

# 5. 清理过期备份 (只保留 7 天)
echo "🧹 正在清理 $RETENTION_DAYS 天前的旧备份..."
find $BACKUP_ROOT -type f -mtime +$RETENTION_DAYS -exec rm {} \;

echo "✅ 备份完成！"
echo "📍 备份文件存放位置: $BACKUP_ROOT"
