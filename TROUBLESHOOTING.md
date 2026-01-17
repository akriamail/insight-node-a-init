## SSL 证书申请问题记录
- 现象：Internal Error / DNS not pointing to device.
- 解决：确认防火墙开放 80 端口，或切换为 DNS-01 挑战模式。
### Wiki.js 部署问题 (2026-01-17)
1. **数据库连接失败**: 
   - 现象: `psql: error: role "postgres" does not exist`
   - 原因: `insight-db` 初始化时使用了自定义超级用户 `insight_admin`。
   - 解决: 使用 `docker exec -it insight-db psql -U insight_admin` 进行初始化。
2. **镜像拉取失败**: 
   - 现象: `pull access denied`
   - 解决: 将镜像从非官方路径更换为官方镜像 `requarks/wiki:2`。
3. **域名无法访问 (Empty Response)**:
   - 解决: 确保 `06-knowledge.yml` 中配置了 `networks: insight-net` 且声明为 `external: true`。
# 🛠 故障处理 (Troubleshooting)

### ⚠️ NocoDB 重启 (Database Connection Error)
- **原因**: 密码包含特殊字符（如 `@`, `#`）在 `NC_DB` URL 字符串中未编码。
- **解决**: 使用 URL 编码替换字符。`@` -> `%40`, `#` -> `%23`。

### ⚠️ n8n 无法启动 (Permission Denied)
- **原因**: `/opt/insight-ai/04-workflow/data` 权限不属于 UID 1000。
- **解决**: 执行 `chown -R 1000:1000 [目录路径]`。

### ⚠️ 变量读取失效 (Env Not Found)
- **原因**: 在 `compose/` 目录下执行命令时无法自动读取上级目录的 `.env`。
- **解决**: 使用 `docker compose --env-file ../.env` 执行。
