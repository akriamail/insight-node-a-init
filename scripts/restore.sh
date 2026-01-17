#!/bin/bash

# --- Project Team Node-A 一键恢复脚本 (v1.0.0 完整版) ---

# 1. 自动定位路径
REPO_DIR=$(cd "$(dirname "$0")/.."; pwd)
PARENT_DIR=$(cd "$REPO_DIR/.."; pwd)
BACKUP_ROOT="$PARENT_DIR/backups"

echo "⚠️  警告: 此脚本将使用最新备份覆盖当前数据！"
echo "📂 备份根目录: $BACKUP_ROOT"

# 2. 确认最新的备份文件
LATEST_DB=$(ls -t $BACKUP_ROOT/postgres/n8n_db_*.sql.gz 2>/dev/null | head -1)
LATEST_NPM=$(ls -t $BACKUP_ROOT/gateway/npm_full_config_*.tar.gz 2>/dev/null | head -1)

if [ -z "$LATEST_DB" ] || [ -z "$LATEST_NPM" ]; then
    echo "❌ 错误: 未找到备份文件，请检查 $BACKUP_ROOT"
    exit 1
fi

echo "📦 发现最新备份:"
echo " - 数据库: $(basename $LATEST_DB)"
echo " - 网关: $(basename $LATEST_NPM)"
echo "--------------------------------------"

# 3. 恢复 NPM (网关与证书)
echo "--- [1/2] 正在恢复 NPM 配置文件与 SSL 证书... ---"
# 确保目标目录存在
mkdir -p $PARENT_DIR/01-gateway
# 解压覆盖
tar -xzf $LATEST_NPM -C $PARENT_DIR/01-gateway
echo "✅ NPM 文件恢复完成。"

# 4. 启动基础服务（必须先启动数据库才能灌入数据）
echo "--- [2/2] 正在拉起数据库并恢复数据... ---"
bash $REPO_DIR/scripts/startup.sh

echo "⏳ 等待数据库就绪 (10秒)..."
sleep 10

# 5. 导入 Postgres 数据
export PGPASSWORD='z1a2q3W4!@#'
echo "💾 正在写入数据库..."
zcat $LATEST_DB | docker exec -i insight-db psql -U insight_admin -d n8n_db

if [ $? -eq 0 ]; then
    echo "✅ 数据库导入成功！"
else
    echo "❌ 数据库导入失败，请检查容器状态。"
    exit 1
fi

echo "--------------------------------------"
echo "✨ Project Team Node-A 恢复任务全部完成！"
echo "🌐 请刷新浏览器检查: data, n8n, wiki, gateway"
