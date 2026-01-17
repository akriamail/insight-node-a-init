#!/bin/bash

# --- Project Team Node-A 灾难恢复脚本 (v1.0.0 闭环版) ---

REPO_DIR=$(cd "$(dirname "$0")/.."; pwd)
PARENT_DIR=$(cd "$REPO_DIR/.."; pwd)
BACKUP_ROOT="$PARENT_DIR/backups"
EXPORT_DIR="$PARENT_DIR/exports"

echo "⚠️  开始灾难恢复演练..."

# 1. 检查是否存在“全量大包” (针对从云端下载回来的情况)
LATEST_FULL_ARCHIVE=$(ls -t $EXPORT_DIR/Project_Team_Full_Backup_*.tar.gz 2>/dev/null | head -1)

if [ -n "$LATEST_FULL_ARCHIVE" ]; then
    echo "📦 发现全量大包: $(basename $LATEST_FULL_ARCHIVE)"
    echo "🔄 正在解压大包到备份目录..."
    mkdir -p $BACKUP_ROOT
    tar -xzf $LATEST_FULL_ARCHIVE -C $BACKUP_ROOT
    echo "✅ 大包解压完成。"
fi

# 2. 确定最新的碎片备份文件
LATEST_DB=$(ls -t $BACKUP_ROOT/postgres/n8n_db_*.sql.gz 2>/dev/null | head -1)
LATEST_NPM=$(ls -t $BACKUP_ROOT/gateway/npm_full_config_*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_DB" ] || [ -z "$LATEST_NPM" ]; then
    echo "❌ 错误: 未找到可用的备份文件！"
    exit 1
fi

echo "📂 准备恢复数据:"
echo " - 数据库: $(basename $LATEST_DB)"
echo " - 网关: $(basename $LATEST_NPM)"

# 3. 恢复 NPM 文件
echo "--- [1/2] 恢复网关配置与证书 ---"
mkdir -p $PARENT_DIR/01-gateway
tar -xzf $LATEST_NPM -C $PARENT_DIR/01-gateway

# 4. 启动容器 (必须先启动 db 容器)
echo "--- [2/2] 正在启动系统并导入数据 ---"
bash $REPO_DIR/scripts/startup.sh
echo "⏳ 等待数据库启动 (10s)..."
sleep 10

# 5. 导入 SQL
export PGPASSWORD='z1a2q3W4!@#'
zcat $LATEST_DB | docker exec -i insight-db psql -U insight_admin -d n8n_db

echo "✨ 恢复流程执行完毕！请检查域名访问情况。"
