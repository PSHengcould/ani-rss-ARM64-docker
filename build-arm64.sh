#!/bin/bash
# =============================================
# ANI-RSS ARM64 构建脚本
# 用于在 ARM64 机器（如树莓派、NAS）上构建镜像
# =============================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${SCRIPT_DIR}/build"

echo "=== ANI-RSS ARM64 构建脚本 ==="
echo "工作目录: ${SCRIPT_DIR}"

# 创建构建目录
mkdir -p "${BUILD_DIR}/docker"
mkdir -p "${BUILD_DIR}/ani-rss-application/target"
mkdir -p "${BUILD_DIR}/config"

# 1. 复制 Dockerfile
echo ""
echo "[1/4] 复制 ARM64 Dockerfile..."
cp "${SCRIPT_DIR}/docker/Dockerfile.arm64" "${BUILD_DIR}/Dockerfile.arm64"

# 2. 下载官方启动脚本
echo ""
echo "[2/4] 下载官方启动脚本..."
curl -fsSL "https://raw.githubusercontent.com/wushuo894/ani-rss/master/docker/run.sh" -o "${BUILD_DIR}/docker/run.sh"
curl -fsSL "https://raw.githubusercontent.com/wushuo894/ani-rss/master/docker/exec.sh" -o "${BUILD_DIR}/docker/exec.sh"
echo "启动脚本已下载"

# 3. 下载最新 jar
echo ""
echo "[3/4] 下载最新 ANI-RSS jar..."
JAR_URL="https://github.com/wushuo894/ani-rss/releases/latest/download/ani-rss.jar"
if curl -fsSL --retry 3 "${JAR_URL}" -o "${BUILD_DIR}/ani-rss-application/target/ani-rss.jar"; then
    JAR_SIZE=$(du -h "${BUILD_DIR}/ani-rss-application/target/ani-rss.jar" | cut -f1)
    echo "jar 下载成功，大小: ${JAR_SIZE}"
else
    echo "[ERROR] jar 下载失败"
    echo "请手动下载：${JAR_URL}"
    echo "保存到: ${BUILD_DIR}/ani-rss-application/target/ani-rss.jar"
    exit 1
fi

# 4. 构建镜像
echo ""
echo "[4/4] 构建 ARM64 Docker 镜像..."
cd "${BUILD_DIR}"
docker build -f Dockerfile.arm64 -t ani-rss:arm64 .

echo ""
echo "=== 构建完成 ==="
echo "镜像名称: ani-rss:arm64"
echo ""
echo "启动命令:"
echo "  docker run -d \\"
echo "    --name ani-rss \\"
echo "    -p 7789:7789 \\"
echo "    -v ${BUILD_DIR}/config:/config \\"
echo "    -e TZ=Asia/Shanghai \\"
echo "    --restart unless-stopped \\"
echo "    ani-rss:arm64"
echo ""
echo "或使用 docker-compose（请参考 docker-compose.yml）"