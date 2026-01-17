#!/bin/bash
# --- Project Team Node-A 终极备份脚本 (多库全能版) ---

REPO_DIR=$(cd "$(dirname "$0")/.."; pwd)
PARENT_DIR=$(cd "$REPO_DIR/.."; pwd)
BACKUP_ROOT="$PARENT_DIR/backups"
EXPORT_DIR="$PARENT_DIR/exports"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# 定义需要备份的数据库清单
DB_LIST=("n8n_db" "nocodb_db" "wikijs_db" "teleport_db")

mkdir -p $BACKUP_ROOT/postgres $BACKUP_ROOT/gateway $EXPORT_DIR

echo "📂 [1/3] 开始备份所有业务数据库..."
export PGPASSWORD='z1a2q3W4!@#'
for DB_NAME in "${DB_LIST[@]}"; do
    echo "  -> 导出: $DB_NAME"
    docker exec insight-db pg_dump -U insight_admin $DB_NAME | gzip > $BACKUP_ROOT/postgres/${DB_NAME}_$TIMESTAMP.sql.gz
done

echo "📂 [2/3] 备份 NPM 证书与转发规则..."
tar -czf $BACKUP_ROOT/gateway/npm_full_config_$TIMESTAMP.tar.gz -C $PARENT_DIR/01-gateway .

echo "📦 [3/3] 执行二次全量打包..."
FINAL_FILE="$EXPORT_DIR/Project_Team_Full_Backup_$TIMESTAMP.tar.gz"
tar -czf $FINAL_FILE -C $BACKUP_ROOT .

# 清理旧数据
find $BACKUP_ROOT -type f -mtime +$RETENTION_DAYS -exec rm {} \;
find $EXPORT_DIR -type f -mtime +$RETENTION_DAYS -exec rm {} \;

echo "--------------------------------------"
echo "✅ 备份完成！大包位置: $FINAL_FILE"
