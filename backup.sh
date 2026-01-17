#!/bin/bash

# --- Project Team Node-A 数据库自动备份脚本 v1.00 ---

# 配置区
BACKUP_DIR="/opt/insight-ai/backups/postgres"
RETENTION_DAYS=7
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
CONTAINER_NAME="insight-db"
DB_USER="insight_admin"
DB_NAME="n8n_db"
# 这里的密码直接硬编码，确保脚本独立运行时不会因为变量丢失而失败
export PGPASSWORD='z1a2q3W4!@#'

# 1. 创建备份目录
mkdir -p $BACKUP_DIR

echo "📂 Starting backup for $DB_NAME..."

# 2. 执行热备份 (导出为压缩的 .sql.gz)
docker exec $CONTAINER_NAME pg_dump -U $DB_USER $DB_NAME | gzip > $BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql.gz

# 3. 检查备份是否成功
if [ $? -eq 0 ]; then
    echo "✅ Backup completed: $BACKUP_DIR/${DB_NAME}_$TIMESTAMP.sql.gz"
else
    echo "❌ Backup failed!"
    exit 1
fi

# 4. 清理旧备份 (只保留最近 7 天的)
echo "🧹 Cleaning up backups older than $RETENTION_DAYS days..."
find $BACKUP_DIR -type f -name "*.sql.gz" -mtime +$RETENTION_DAYS -exec rm {} \;

echo "✨ All done!"
