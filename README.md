# THM Writeups

TryHackMe 打靶记录。写法上只写**方法、判断、踩坑**，不贴 flag、不贴密码、不帖真实 IP。

## 目录

| 房间 | 难度 | 日期 | 关键链 |
|---|---|---|---|
| [Guided Pentest: Infrastructure](./guided-pentest-infrastructure.md) | Easy | 2026-11-18 | UnrealIRCd 后门 RCE → 明文 root 凭据 → SSH 提权 |
| [Guided Pentest: Web](#) | Easy | 待写 | Web 渗透流程 + 报告分层 |
| [Linux Fundamentals (Pt1)](#) | Easy | 待写 | 基础命令与文件权限 |

> 进度：已完成 6 个房间，计划补齐 4 篇 writeup。

## 我在这套记录里坚持的三条规矩

1. **脱敏**：密码写 `<REDACTED>`，flag 写 `THM{*** masked ***}`；截图里 **密码与 flag 必打码**。THM 靶机 IP（10.48.x.x / tun0 网段）是每次重开都会变的临时地址，保留原样便于复盘；涉及公网 IP、真实主机名、凭据的一律打码。
2. **写排错**：只写“一路顺利”的 writeup 没有信息量，卡住的地方才是可复现的部分。
3. **写判断，不只写命令**：每条命令后面写清“为什么这么打”，而不是“打完看到什么”。

## 目录结构

```
thm-writeups/
├── README.md                          # 本文件（目录页）
├── guided-pentest-infrastructure.md   # writeup 正文
├── docs/
│   └── img/                           # 截图（已打码）
│       ├── room-overview-masked.png   # 房间 100% 完成页
│       ├── 02-nmap.png                # nmap 服务识别
│       ├── 03-msf-shell.png           # msf 回连拿到 webmaster
│       ├── 04-password-txt.png        # 明文凭据（内容 sed 打码）
│       ├── 05-root-shell.png          # root shell（flag sed 打码）
│       └── thm-profile-masked.png     # 个人主页（暂未放进正文）
└── tools/
    └── mask.ps1                       # 截图打码小工具（Windows / PowerShell）
```

> 正文里的 4 张终端截图是 **2026-11-19 在 Kali 上重打一遍当场截的**，不是复刻；密码与 flag 用 `sed` 在命令层就地打码，命令和输出同屏可复盘。

## 新增一篇 writeup 的步骤

1. 在仓库根目录新建 `<房间名>.md`，参考 `guided-pentest-infrastructure.md` 的章节结构
2. 截图放 `docs/img/`，命名 `NN-<内容>.png`
3. 用 `tools/mask.ps1` 把 IP / 密码 / flag 遮掉
4. 在本文件「目录」表格里加一行
5. 发布前自查：明文密码 0 处、flag 原文 0 处、公网 IP 0 处

## 打码工具

```powershell
# 用法：把图片放到 docs/img/ 后执行
powershell -ExecutionPolicy Bypass -File tools/mask.ps1 -Path docs/img/02-nmap.png -X 120 -Y 340 -W 260 -H 30 -Text "10.x.x.x"
```

参数 `-X -Y -W -H` 是要遮住的矩形区域（像素），`-Text` 会以白字画在色块上（可省略）。
