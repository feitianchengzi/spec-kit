# Spec-Kit CLI 命令参考

## 概述

Spec-Kit 提供了一个命令行工具 `specify`，用于创建和管理 spec-driven 开发项目。本文档详细说明了所有可用的命令和选项。

## 安装和使用

### 通过 uvx 使用（推荐）

```bash
# 初始化新项目
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 检查工具安装状态
uvx --from git+https://github.com/github/spec-kit.git specify check
```

### 全局安装

```bash
# 安装到系统
uv tool install --from git+https://github.com/github/spec-kit.git specify-cli

# 使用命令
specify init <PROJECT_NAME>
specify check
```

## 命令列表

### `specify init` - 初始化新项目

创建新的 spec-driven 开发项目。

#### 语法

```bash
specify init [PROJECT_NAME] [OPTIONS]
```

#### 参数

- `PROJECT_NAME` (可选): 新项目的目录名称

#### 选项

| 选项 | 类型 | 默认值 | 描述 |
|------|------|--------|------|
| `--ai` | 字符串 | 交互选择 | 指定 AI 助手 (claude, gemini, copilot, cursor, qwen, opencode, windsurf, codex, kilocode, auggie, roo) |
| `--script` | 字符串 | 自动检测 | 指定脚本类型 (sh, ps) |
| `--ignore-agent-tools` | 布尔 | False | 跳过 AI 代理工具检查 |
| `--no-git` | 布尔 | False | 跳过 Git 仓库初始化 |
| `--here` | 布尔 | False | 在当前目录初始化项目 |
| `--skip-tls` | 布尔 | False | 跳过 SSL/TLS 验证（不推荐） |
| `--debug` | 布尔 | False | 显示详细的诊断输出 |

#### 使用示例

```bash
# 基本用法 - 交互式选择 AI 助手
specify init my-project

# 指定 AI 助手
specify init my-project --ai claude

# 指定脚本类型
specify init my-project --ai gemini --script sh

# 在当前目录初始化
specify init --here --ai copilot

# 跳过 Git 初始化
specify init my-project --no-git

# 跳过工具检查
specify init my-project --ignore-agent-tools

# 调试模式
specify init my-project --debug
```

#### 支持的 AI 助手

1. **claude** - Claude Code
   - 需要安装 Claude CLI
   - 在 VS Code 中使用 `/` 命令

2. **gemini** - Gemini CLI
   - 需要安装 Gemini CLI
   - 使用命令行工具

3. **copilot** - GitHub Copilot
   - 在 VS Code 中使用
   - 支持 `/specify`, `/plan`, `/tasks` 命令

4. **cursor** - Cursor IDE
   - 在 Cursor 编辑器中使用
   - 支持 AI 代理功能

#### 支持的脚本类型

1. **sh** - POSIX Shell (bash/zsh)
   - 适用于 Unix-like 系统 (Linux, macOS)
   - 默认在非 Windows 系统上

2. **ps** - PowerShell
   - 适用于 Windows 系统
   - 默认在 Windows 系统上

### `specify check` - 检查工具安装

检查所有必需工具的安装状态。

#### 语法

```bash
specify check
```

#### 功能

- 检查 Git 版本控制工具
- 检查 Claude CLI
- 检查 Gemini CLI
- 检查 VS Code（用于 GitHub Copilot）
- 检查 Cursor IDE 代理（可选）

#### 输出示例

```
███████╗██████╗ ███████╗ ██████╗██╗███████╗██╗   ██╗
██╔════╝██╔══██╗██╔════╝██╔════╝██║██╔════╝╚██╗ ██╔╝
███████╗██████╔╝█████╗  ██║     ██║█████╗   ╚████╔╝ 
╚════██║██╔═══╝ ██╔══╝  ██║     ██║██╔══╝    ╚██╔╝  
███████║██║     ███████╗╚██████╗██║██║        ██║   
╚══════╝╚═╝     ╚══════╝ ╚═════╝╚═╝╚═╝        ╚═╝   

Spec-Driven Development Toolkit

Check Available Tools
├─ ● git: Git version control (available)
├─ ● claude: Claude Code CLI (available)
├─ ○ gemini: Gemini CLI (not found - Install from: https://github.com/google-gemini/gemini-cli)
├─ ● code: VS Code (for GitHub Copilot) (available)
└─ ○ cursor-agent: Cursor IDE agent (optional) (not found - Install from: https://cursor.sh/)

Specify CLI is ready to use!
```

## 交互式界面

### AI 助手选择

当未指定 `--ai` 选项时，工具会显示交互式选择菜单：

```
Choose your AI assistant:
▶ copilot: GitHub Copilot
  claude: Claude Code
  gemini: Gemini CLI
  cursor: Cursor
  qwen: Qwen Code
  opencode: opencode
  windsurf: Windsurf
  codex: Codex CLI
  kilocode: Kilo Code
  auggie: Auggie CLI
  roo: Roo Code

Use ↑/↓ to navigate, Enter to select, Esc to cancel
```

### 脚本类型选择

当未指定 `--script` 选项时，工具会根据操作系统自动选择默认值，或在交互模式下提供选择：

```
Choose script type (or press Enter):
▶ sh: POSIX Shell (bash/zsh)
  ps: PowerShell

Use ↑/↓ to navigate, Enter to select, Esc to cancel
```

## 项目初始化流程

### 1. 参数验证

- 检查项目名称和 `--here` 标志的互斥性
- 验证 AI 助手和脚本类型选择

### 2. 工具检查

- 检查 Git 是否安装（除非使用 `--no-git`）
- 检查所选 AI 助手的必需工具（除非使用 `--ignore-agent-tools`）

### 3. 模板下载

- 从 GitHub API 获取最新发布信息
- 根据 AI 助手和脚本类型下载对应模板
- 显示下载进度

### 4. 项目创建

- 创建项目目录（除非使用 `--here`）
- 解压模板文件
- 设置脚本执行权限
- 初始化 Git 仓库（除非使用 `--no-git`）

### 5. 完成提示

显示项目创建完成信息和后续步骤指导。

## 错误处理

### 常见错误

1. **目录已存在**
   ```
   Error: Directory 'my-project' already exists
   ```

2. **AI 工具未安装**
   ```
   Error: Claude CLI is required for Claude Code projects
   Required AI tool is missing!
   Tip: Use --ignore-agent-tools to skip this check
   ```

3. **网络连接问题**
   ```
   Error fetching release information
   ```

### 调试模式

使用 `--debug` 选项获取详细的诊断信息：

```bash
specify init my-project --debug
```

调试信息包括：
- Python 版本
- 平台信息
- 当前工作目录
- 网络请求详情
- 文件提取详情

## 最佳实践

### 1. 项目命名

- 使用小写字母和连字符
- 避免空格和特殊字符
- 选择描述性的名称

### 2. AI 助手选择

- **Claude Code**: 适合 VS Code 用户，功能最全面
- **Gemini CLI**: 适合命令行用户
- **GitHub Copilot**: 适合已有 Copilot 订阅的用户
- **Cursor**: 适合使用 Cursor 编辑器的用户

### 3. 脚本类型

- 通常使用默认选择即可
- Windows 用户可能需要手动选择 PowerShell
- Unix-like 系统用户使用 Bash

### 4. Git 集成

- 建议保持 Git 初始化（默认行为）
- 使用 `--no-git` 仅在特殊情况下
- 确保 Git 已正确配置用户信息

## 故障排除

### 1. 权限问题

```bash
# 确保脚本有执行权限
chmod +x .specify/scripts/**/*.sh
```

### 2. 网络问题

```bash
# 使用调试模式查看网络详情
specify init my-project --debug

# 跳过 TLS 验证（不推荐）
specify init my-project --skip-tls
```

### 3. 工具检查

```bash
# 检查所有工具状态
specify check

# 跳过工具检查
specify init my-project --ignore-agent-tools
```

### 4. 清理和重试

```bash
# 删除失败的项目目录
rm -rf my-project

# 重新初始化
specify init my-project
```

## 更新和维护

### 检查更新

```bash
# 使用最新版本
uvx --from git+https://github.com/github/spec-kit.git specify check
```

### 版本兼容性

- 需要 Python 3.11 或更高版本
- 支持最新的 uv 工具
- 兼容主流操作系统
