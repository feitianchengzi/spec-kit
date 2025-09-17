# 安装指南

## 先决条件

- **Linux/macOS**（或 Windows；现在支持 PowerShell 脚本，无需 WSL）
- AI 编码代理：[Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)
- [uv](https://docs.astral.sh/uv/) 用于包管理
- [Python 3.11+](https://www.python.org/downloads/)
- [Git](https://git-scm.com/downloads)

## 安装

### 选择安装源

Spec Kit 提供两种安装选项：

- **官方仓库**（英文版）：`https://github.com/github/spec-kit.git`
- **简体中文分支**：`https://github.com/feitianchengzi/spec-kit.git@zh-hans`

简体中文分支包含完整的中文文档和界面，适合中文用户使用。

### 初始化新项目

最简单的开始方式是初始化一个新项目：

```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <PROJECT_NAME>
```

或在当前目录中初始化：

```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init --here

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init --here
```

### 指定 AI 代理

您可以在初始化期间主动指定您的 AI 代理：

```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai gemini
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai copilot

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --ai claude
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --ai gemini
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --ai copilot
```

### 指定脚本类型（Shell vs PowerShell）

所有自动化脚本现在都有 Bash（`.sh`）和 PowerShell（`.ps1`）变体。

自动行为：
- Windows 默认：`ps`
- 其他操作系统默认：`sh`
- 交互模式：除非您传递 `--script`，否则会提示您

强制特定脚本类型：
```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script sh
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --script ps

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --script sh
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --script ps
```

### 忽略代理工具检查

如果您希望在不检查正确工具的情况下获取模板：

```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <project_name> --ai claude --ignore-agent-tools

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <project_name> --ai claude --ignore-agent-tools
```

## 验证

初始化后，您应该在 AI 代理中看到以下可用命令：
- `/specify` - 创建规范
- `/plan` - 生成实现计划
- `/tasks` - 分解为可操作的任务

`.specify/scripts` 目录将包含 `.sh` 和 `.ps1` 脚本。

## 故障排除

### Linux 上的 Git 凭据管理器

如果您在 Linux 上遇到 Git 身份验证问题，可以安装 Git 凭据管理器：

```bash
#!/usr/bin/env bash
set -e
echo "Downloading Git Credential Manager v2.6.1..."
wget https://github.com/git-ecosystem/git-credential-manager/releases/download/v2.6.1/gcm-linux_amd64.2.6.1.deb
echo "Installing Git Credential Manager..."
sudo dpkg -i gcm-linux_amd64.2.6.1.deb
echo "Configuring Git to use GCM..."
git config --global credential.helper manager
echo "Cleaning up..."
rm gcm-linux_amd64.2.6.1.deb
```
