# ANI-RSS ARM64 Docker

为 ANI-RSS 项目提供的 ARM64 架构 Docker 支持。

## 特性

- 基于官方 `eclipse-temurin:25-jre-alpine` 镜像，完全兼容 linux/arm64
- 保留官方启动脚本逻辑，无需额外修改
- 提供 docker-compose 一键部署配置

## 快速开始

### 方式一：使用 docker-compose（推荐）

```bash
git clone https://github.com/PSHengcould/ani-rss-ARM64-docker.git
cd ani-rss-ARM64-docker
curl -fsSL https://github.com/wushuo894/ani-rss/releases/latest/download/ani-rss.jar \
  -o ani-rss-application/target/ani-rss.jar
docker compose up -d
```

### 方式二：手动构建

```bash
git clone https://github.com/PSHengcould/ani-rss-ARM64-docker.git
cd ani-rss-ARM64-docker
chmod +x build-arm64.sh
./build-arm64.sh
```

## 部署到 NAS / 树莓派

1. 将本仓库内容复制到 NAS 上
2. 运行 `./build-arm64.sh` 构建镜像
3. 使用 `docker compose up -d` 启动容器
4. 访问 `http://你的NAS IP:7789`

## 环境变量

| 变量 | 默认值 | 说明 |
|------|--------|------|
| TZ | Asia/Shanghai | 时区 |
| CONFIG | /config | 配置目录 |
| SERVER_PORT | 7789 | 服务端口 |
| PUID | 0 | 运行用户 ID |
| PGID | 0 | 运行组 ID |

## 致谢

- 原始项目: [wushuo894/ani-rss](https://github.com/wushuo894/ani-rss)
- 本镜像基于官方 Dockerfile 改编，适配 ARM64 架构
