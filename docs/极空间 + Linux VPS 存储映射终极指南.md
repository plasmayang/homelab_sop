# 🚀 极空间 + Linux VPS 存储映射终极指南

## 架构总览
* **网络层**：使用 Tailscale 组建 SD-WAN 虚拟局域网，彻底绕过 IPv6 配置和家庭宽带的防火墙限制。
* **权限层**：使用极空间“本地离线账号”+“团队空间”，实现免绑手机号、纯局域网验证的数据物理隔离。
* **传输层**：使用 WebDAV 协议（HTTP 5005 端口），在加密的 Tailscale 隧道中提供稳定、容错率高的跨网文件系统挂载。

---

## 阶段一：极空间（ZSpace）网络与服务部署

### 1. 解决 Docker 镜像下载网络问题（VPS 离线打包法）
由于极空间直接拉取 Docker 镜像极易超时，我们利用海外 VPS 进行“曲线救国”：
1. 在 VPS 终端执行：`docker pull tailscale/tailscale:latest`
2. 将镜像打包：`docker save -o tailscale_latest.tar tailscale/tailscale:latest`
3. 使用 `python3 -m http.server 8080` 在 VPS 开启临时下载服务。
4. 本地电脑浏览器访问 `http://VPS_IP:8080/tailscale_latest.tar` 下载到本地。
5. 在极空间的 **Docker -> 镜像 -> 本地镜像 -> 添加** 中，选择“从文件导入”并上传该 tar 包。

### 2. 部署 Tailscale 容器
1. 在极空间 Docker 中，基于刚才导入的镜像创建容器（名称建议为 `tailscale`）。
2. **网络设置**：必须更改为 **Host 模式**。
3. **环境设置 (Environment)**：新增变量，名称为 `TS_STATE_DIR`，值为 `/var/lib/tailscale`。
4. **路径挂载 (Mounts)**：在极空间个人文件夹建一个目录（如 `/docker/tailscale/state`），映射到容器内的 `/var/lib/tailscale`（用于保存登录状态，避免重启掉线）。
5. 启动容器，查看“日志”，复制里面的 `https://login.tailscale.com...` 链接到浏览器进行设备授权。
6. 登录 Tailscale 管理后台，记录下极空间的虚拟内网 IP（例如 `100.x.x.x`）。

---

## 阶段二：极空间权限与存储空间隔离

### 1. 创建 VPS 专属服务账号
1. 进入极空间的 **用户中心 -> 添加用户**。
2. 选择 **“本地离线账号”**，设定账号（如 `vpsuser`）和密码。
   *(优势：离线账号仅限局域网/Tailscale网登录，防公网爆破，极度安全。)*

### 2. 建立独立挂载目录（团队空间）
1. 使用极空间的 **“团队空间”** 应用。
2. 新建一个顶层文件夹，**强烈建议使用纯英文命名**（如 `vps-mount` 或 `VPS_Data`），以避免 Linux 终端中文路径带来的编码或转义问题。

### 3. 开启 WebDAV 服务
1. 进入 **系统设置 -> 文件及共享服务 -> WebDAV**。
2. 勾选 **启用 WebDAV 服务 (HTTP)**，默认端口为 **5005**。
   *(因为 Tailscale 本身已加密，内网直接跑 HTTP 性能更好)*

---

## 阶段三：Linux VPS (Debian/Ubuntu) 挂载配置

### 1. 基础环境与网络连通性测试
在 VPS 终端执行：
```bash
# 测试 Tailscale 网络是否打通极空间
ping -c 4 100.x.x.x 

# 更新源并安装 WebDAV 挂载工具
sudo apt update
sudo apt install davfs2 -y
```
*(安装时如遇弹窗询问是否允许普通用户挂载，选 Yes)*

### 2. 配置免密自动登录
```bash
sudo nano /etc/davfs2/secrets
```
在文件最末尾另起一行，填入极空间的连接信息：
```text
http://100.x.x.x:5005  vpsuser  你的离线账号密码
```
保存并退出。

### 3. 创建挂载点与测试
```bash
# 建立本地映射目录
sudo mkdir -p /mnt/zspace

# 手动挂载测试
sudo mount -t davfs http://100.x.x.x:5005 /mnt/zspace
```
通过 `df -h` 确认是否挂载成功。

### 4. 写入 fstab 实现开机自启
```bash
sudo nano /etc/fstab
```
在文件最末尾添加：
```text
http://100.x.x.x:5005  /mnt/zspace  davfs  rw,user,_netdev,auto  0  0
```
**关键点**：`_netdev` 参数强制要求系统在网络和 Tailscale 启动完成后再执行挂载，防止 VPS 重启卡死。

### 5. 建立快捷访问通道（软链接）
为了避免每次都要输入极长且包含内部目录结构的路径（如 `/mnt/zspace/public/vps-mount/`），在 VPS 根目录建立软链接：
```bash
sudo ln -s "/mnt/zspace/public/vps-mount" "/root/zspace-data"
```
以后在 VPS 上只需 `cd /root/zspace-data` 即可直接读写极空间文件。

---

## 🛠️ 避坑与运维备忘录

1. **绝对不要向公网暴露 445 (SMB) 端口**：即使未来你有了公网 IP 并做了端口转发，也只允许转发 WebDAV 端口。SMB 暴露公网是中勒索病毒的重灾区。
2. **强制卸载命令**：如果家里断电或极空间重启，VPS 上的挂载目录可能会卡死终端。遇到卡死，新开一个 SSH 窗口执行懒卸载即可：
   `sudo umount -l /mnt/zspace`
3. **性能预期**：WebDAV 适合大文件（视频、备份包、ISO 镜像）的顺序读写，完全取决于你家宽带的上传速度。**不要**将数据库（如 MySQL/SQLite）或高频读写的缓存文件放在挂载目录中，否则会导致极高的延迟和数据库损坏风险。
