#!/bin/bash
# --- Project Team Node-A 终极恢复脚本 (多库全能版) ---

REPO_DIR=$(cd "$(dirname "$0")/.."; pwd)
PARENT_DIR=$(cd "$REPO_DIR/.."; pwd)
BACKUP_ROOT="$PARENT_DIR/backups"
EXPORT_DIR="$PARENT_DIR/exports"
DB_LIST=("n8n_db" "nocodb_db" "wikijs_db" "teleport_db")

echo "⚠️  启动 Project Team 灾难恢复程序..."

# 1. 自动处理大包解压
LATEST_FULL=$(ls -t $EXPORT_DIR/Project_Team_Full_Backup_*.tar.gz 2>/dev/null | head -1)
if [ -n "$LATEST_FULL" ]; then
    echo "📦 解压最新全量包: $(basename $LATEST_FULL)"
    mkdir -p $BACKUP_ROOT
    tar -xzf $LATEST_FULL -C $BACKUP_ROOT
fi

# 2. 恢复网关文件
echo "--- [1/3] 还原网关配置与 SSL 证书 ---"
mkdir -p $PARENT_DIR/01-gateway
LATEST_NPM=$(ls -t $BACKUP_ROOT/gateway/npm_full_config_*.tar.gz 2>/dev/null | head -1)
tar -xzf $LATEST_NPM -C $PARENT_DIR/01-gateway

# 3. 启动并初始化环境
echo "--- [2/3] 启动容器并初始化数据库房间 ---"
bash $REPO_DIR/scripts/startup.sh
sleep 10
bash $REPO_DIR/scripts/03-init-db.sh

# 4. 循环导入所有数据库
echo "--- [3/3] 正在灌入数据 ---"
export PGPASSWORD='z1a2q3W4!@#'
for DB_NAME in "${DB_LIST[@]}"; do
    LATEST_DB=$(ls -t $BACKUP_ROOT/postgres/${DB_NAME}_*.sql.gz 2>/dev/null | head -1)
    if [ -n "$LATEST_DB" ]; then
        echo "  -> 正在注入: $DB_NAME"
        zcat $LATEST_DB | docker exec -i insight-db psql -U insight_admin -d $DB_NAME
    else
        echo "  ⚠️ 跳过: 未找到 $DB_NAME 的备份"
    fi
done

echo "✨ 任务完成！Project Team 已满血复活。"
