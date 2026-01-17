# Project Team Node-A: 数字化大脑


## 🏗️ 架构概览

- **网关层**: Nginx Proxy Manager (提供 HTTPS 终端及反向代理)
- **应用层**: Wiki.js (团队知识库), Teleport (安全堡垒机)
- **数据层**: PostgreSQL 16 (持久化存储)
- **网络层**: 自定义 Docker 网络 `insight-net` (隔离通信)
## 🚀 Project Team - Node-A 业务矩阵

| 服务名称 | 访问地址 | 核心功能 | 数据库 |
| :--- | :--- | :--- | :--- |
| **Wiki.js** | `wiki.insight.akria.net` | 团队知识库 & 文档中心 | `wikijs_db` |
| **n8n** | `flow.insight.akria.net` | 自动化工作流 (Low-code) | `n8n_db` |
| **NocoDB** | `data.insight.akria.net` | 无代码数据库管理表格 | `nocodb_db` |
| **Teleport**| `sec.insight.akria.net`  | 运维审计与堡垒机 | `teleport_db` |
| **NPM** | `gw.insight.akria.net`   | 域名转发与 SSL 管理 | `postgres` |

- `/compose`: 核心服务的 Docker Compose 定义文件。
- `/configs`: 各类服务的配置文件 (如 Teleport.yaml)。
- `/scripts`: 常用运维脚本。
- `DOMAINS.md`: 域名分配及端口映射清单。
- `TROUBLESHOOTING.md`: 常见故障处理记录。

## 🚀 快速启动指南

1. **环境准备**: 确保宿主机已安装 Docker 和 Docker Compose。
2. **启动数据库**: `docker compose -f compose/01-databases.yml up -d`
3. **启动网关**: `docker compose -f compose/01-gateway.yml up -d`
4. **启动知识库**: `docker compose -f compose/06-knowledge.yml up -d`
## 🚀 快速启动指南

1. **环境准备**: 确保宿主机已安装 Docker，且 `.env` 文件已正确配置。
2. **基础设施**: `docker compose -f compose/03-databases.yml up -d` (等待数据库初始化)
3. **网关层**: `docker compose -f compose/01-gateway.yml up -d`
4. **应用层**: 
   - `docker compose -f compose/04-workflow.yml up -d` (n8n)
   - `docker compose -f compose/05-data-viz.yml up -d` (NocoDB)
   - `docker compose -f compose/06-knowledge.yml up -d` (Wiki.js)
## 🔐 安全与准则
- 数据库超级管理员为 `insight_admin`。
- 生产环境修改配置后，必须通过 Git 同步至本仓库。

---
*Created by Project Team Architect @ 2026*
