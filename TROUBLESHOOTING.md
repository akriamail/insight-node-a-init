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
