# Project Team Node-A: 数字化大脑

这是 **Project Team** (21人工厂项目) 的核心基础设施管理仓库。本节点 (Node-A) 承载了知识管理、安全准则及数据库中枢。

## 🏗️ 架构概览

- **网关层**: Nginx Proxy Manager (提供 HTTPS 终端及反向代理)
- **应用层**: Wiki.js (团队知识库), Teleport (安全堡垒机)
- **数据层**: PostgreSQL 16 (持久化存储)
- **网络层**: 自定义 Docker 网络 `insight-net` (隔离通信)

## 📂 目录结构说明

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

## 🔐 安全与准则
- 所有的 `.ai` 域名已废弃，现统一使用 `.akria.net`。
- 数据库超级管理员为 `insight_admin`。
- 生产环境修改配置后，必须通过 Git 同步至本仓库。

---
*Created by Project Team Architect @ 2026*
