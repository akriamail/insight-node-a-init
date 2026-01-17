# 域名映射清单 (Node A)

| 域名 | 内部服务 | 容器名称 | 内部端口 | 说明 |
| :--- | :--- | :--- | :--- | :--- |
| **gateway.insight.akria.net** | NPM Admin | insight-gateway | 81 | 网关管理后台 (已启用 SSL) |
| **wiki.insight.akria.net** | Wiki.js | insight-wiki | 3000 | 团队知识库 (已上线) |
| **teleport.insight.akria.net** | Teleport | insight-teleport | 3080/443 | 堡垒机 (调试中) |
| **db.insight.internal** | PostgreSQL | insight-db | 5432 | 仅限 Docker 内部网络通信 |

---

## 运维笔记 (2026-01-17)
- **域名变更**: 全面从 `insight.ai` 迁移至 `akria.net`。
- **证书管理**: 所有公网二级域名均通过 NPM 获取 Let's Encrypt 证书并强制 HTTPS。
- **内部通信**: 容器间通过 `insight-net` 虚拟网络互联，无需暴露非必要端口至公网。
