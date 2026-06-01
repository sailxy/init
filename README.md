# Local Dev Init

用于快速初始化本地化开发环境的 Docker Compose 基础设施仓库。它把常见的开发依赖、调试工具、消息队列、链路追踪和日志观测组件放在同一个网络里，方便业务项目直接接入。

## 适用场景

- 新项目本地开发环境初始化
- 后端服务依赖的数据库、缓存、消息队列快速启动
- 本地调试 Nginx、Redis、RabbitMQ、Asynq、Jaeger、Loki、Grafana 等组件
- 多个本地业务服务通过统一 Docker 网络互联

该仓库面向本地开发环境，不建议直接用于生产环境。默认账号和密码为了开发便利而设置，请不要暴露到公网。

## 前置要求

- WSL 或 Linux/macOS 终端环境
- VS Code 或其他编辑器
- Docker Desktop 或 Docker Engine
- Docker Compose v2

检查 Docker Compose：

```bash
docker compose version
```

## 快速启动

1. 创建共享网络：

```bash
./scripts/init-docker-network.sh
```

如果网络已经存在，Docker 会提示 `network with name infra-network already exists`，可以忽略。

2. 准备宿主机挂载目录和配置文件：

```bash
sudo ./scripts/init-docker-configs.sh
```

脚本默认写入 `/opt/apps`。如果要写入其他位置，可以设置 `APP_ROOT`：

```bash
APP_ROOT=/tmp/sailxy-init-apps-test ./scripts/init-docker-configs.sh
```

3. 启动服务：

```bash
docker compose up -d
```

4. 查看容器状态：

```bash
docker compose ps
```

## 服务清单

| 服务 | 端口 | 说明 |
| --- | --- | --- |
| Nginx | `80` | 本地 Web 入口和反向代理配置示例 |
| PostgreSQL | `5432` | PostgreSQL 数据库，默认密码 `postgres` |
| MySQL | `3306` | MySQL 数据库，默认 root 密码 `root` |
| Redis | `6379` | 通用 Redis 实例 |
| RabbitMQ | `5672`, `15672` | 消息队列和管理后台，默认账号 `admin/admin` |
| Asynq Redis | `6380` | Asynq 任务队列专用 Redis |
| Asynqmon | `8080` | Asynq Web 管理后台 |
| Jaeger | `16686`, `4317`, `4318`, `5778`, `9411` | 链路追踪和 OTLP/Zipkin 接入 |
| Loki | `3100` | 日志存储 |
| Grafana | `3000` | 观测面板，默认账号 `admin/admin` |
| Alloy | `12345` | Docker 日志采集代理 |
| busybox | - | 常驻调试容器 |
| netshoot | - | 网络排查工具容器 |

## 常用访问地址

- Nginx: <http://localhost>
- RabbitMQ Management: <http://localhost:15672>
- Asynqmon: <http://localhost:8080>
- Jaeger UI: <http://localhost:16686>
- Grafana: <http://localhost:3000>
- Loki API: <http://localhost:3100>
- Alloy UI/API: <http://localhost:12345>

## 默认账号

| 组件 | 用户名 | 密码 |
| --- | --- | --- |
| PostgreSQL | `postgres` | `postgres` |
| MySQL | `root` | `root` |
| RabbitMQ | `admin` | `admin` |
| Grafana | `admin` | `admin` |

## 目录结构

```text
.
├── README.md
├── scripts
│   ├── init-docker-configs.sh
│   └── init-docker-network.sh
├── docker
│   ├── compose.yaml
│   ├── alloy
│   │   └── config.alloy
│   ├── grafana
│   │   └── provisioning/datasources/loki.yaml
│   ├── loki
│   │   └── loki-config.yaml
│   └── nginx
│       ├── nginx.conf
│       ├── conf.d/default.conf
│       └── html/
```

## 基本操作

启动：

```bash
cd docker
docker compose up -d
```

停止：

```bash
cd docker
docker compose down
```

查看日志：

```bash
cd docker
docker compose logs -f
```

查看单个服务日志：

```bash
cd docker
docker compose logs -f grafana
```

进入网络调试容器：

```bash
docker exec -it netshoot sh
```

## 许可

本项目使用 [MIT License](LICENSE)。
