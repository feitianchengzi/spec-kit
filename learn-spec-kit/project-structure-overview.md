# Spec-Kit 项目结构概览

## 项目目录结构

```
spec-kit/
├── CHANGELOG.md                    # 项目变更日志
├── CODE_OF_CONDUCT.md             # 行为准则
├── CONTRIBUTING.md                # 贡献指南
├── docs/                          # 文档目录
│   ├── docfx.json                # DocFX 配置文件
│   ├── index.md                  # 文档首页
│   ├── installation.md           # 安装指南
│   ├── local-development.md      # 本地开发指南
│   ├── quickstart.md             # 快速开始
│   ├── README.md                 # 文档说明
│   └── toc.yml                   # 文档目录结构
├── LICENSE                        # 许可证文件
├── media/                         # 媒体资源
│   ├── bootstrap-claude-code.gif # Claude Code 引导动画
│   ├── logo_large.webp           # 大尺寸 Logo
│   ├── logo_small.webp           # 小尺寸 Logo
│   ├── spec-kit-video-header.jpg # 视频头部图片
│   └── specify_cli.gif           # CLI 演示动画
├── memory/                        # 项目记忆/宪法
│   ├── constitution_update_checklist.md # 宪法更新检查清单
│   └── constitution.md            # 项目宪法
├── pyproject.toml                 # Python 项目配置
├── README.md                      # 项目主说明文档
├── scripts/                       # 脚本目录
│   ├── bash/                     # Bash 脚本
│   │   ├── check-task-prerequisites.sh
│   │   ├── common.sh
│   │   ├── create-new-feature.sh
│   │   ├── get-feature-paths.sh
│   │   ├── setup-plan.sh
│   │   └── update-agent-context.sh
│   └── powershell/               # PowerShell 脚本
│       ├── check-task-prerequisites.ps1
│       ├── common.ps1
│       ├── create-new-feature.ps1
│       ├── get-feature-paths.ps1
│       ├── setup-plan.ps1
│       └── update-agent-context.ps1
├── SECURITY.md                    # 安全策略
├── spec-driven.md                 # 规范驱动开发说明
├── src/                          # 源代码目录
│   └── specify_cli/              # CLI 工具源码
│       └── __init__.py           # 主程序文件
├── SUPPORT.md                     # 支持信息
├── templates/                     # 模板目录
│   ├── agent-file-template.md    # 代理文件模板
│   ├── commands/                 # 命令模板
│   │   ├── plan.md              # 计划命令模板
│   │   ├── specify.md           # 规范命令模板
│   │   └── tasks.md             # 任务命令模板
│   ├── plan-template.md          # 计划模板
│   ├── spec-template.md          # 规范模板
│   └── tasks-template.md         # 任务模板
└── tutorials/                     # 教程目录（新增）
    ├── uvx-implementation-guide.md # uvx 实现原理
    └── project-structure-overview.md # 本文档
```

## 核心组件说明

### 1. 源代码 (`src/specify_cli/`)

- **`__init__.py`**: 包含完整的 CLI 工具实现
  - 主入口函数 `main()`
  - 命令行应用定义（使用 typer）
  - 所有子命令的实现
  - 交互式界面和进度跟踪

### 2. 配置文件 (`pyproject.toml`)

- **项目元数据**: 名称、版本、描述
- **依赖管理**: 所需的 Python 包
- **脚本入口点**: 定义 `specify` 命令
- **构建配置**: 使用 hatchling 作为构建后端

### 3. 模板系统 (`templates/`)

- **命令模板**: 为不同 AI 助手提供标准化的命令模板
- **项目模板**: 包含规范、计划、任务等模板文件
- **代理模板**: 用于创建 AI 代理配置文件

### 4. 脚本工具 (`scripts/`)

- **跨平台支持**: 同时提供 Bash 和 PowerShell 版本
- **功能脚本**: 包含项目创建、计划设置、上下文更新等功能
- **通用脚本**: 提供共享的脚本功能和工具

### 5. 文档系统 (`docs/`)

- **DocFX 配置**: 使用 DocFX 生成文档网站
- **多语言支持**: 包含安装、开发、快速开始等指南
- **结构化文档**: 通过 toc.yml 组织文档层次结构

### 6. 媒体资源 (`media/`)

- **品牌资源**: Logo 和品牌图片
- **演示资源**: GIF 动画展示工具功能
- **文档资源**: 支持文档的图片和视频

## 项目特点

### 1. 自包含设计

- 单个 Python 文件包含所有功能
- 支持 PEP 723 脚本元数据格式
- 可以通过 uvx 直接执行，无需安装

### 2. 跨平台兼容

- 支持 Windows (PowerShell) 和 Unix-like (Bash) 系统
- 自动检测操作系统并选择合适的脚本类型
- 统一的命令行接口

### 3. 模块化架构

- 清晰的目录结构分离不同功能
- 模板系统支持多种 AI 助手
- 可扩展的脚本和模板系统

### 4. 用户友好

- 丰富的交互式界面
- 详细的错误信息和帮助文档
- 渐进式的项目初始化流程

## 开发工作流

### 1. 本地开发

- 使用 `docs/local-development.md` 中的指南
- 通过 `pyproject.toml` 管理依赖
- 使用 hatchling 构建系统

### 2. 贡献流程

- 遵循 `CONTRIBUTING.md` 中的指南
- 使用 `CODE_OF_CONDUCT.md` 中的行为准则
- 通过 `CHANGELOG.md` 记录变更

### 3. 发布流程

- 通过 GitHub Releases 发布新版本
- 自动生成模板 ZIP 文件
- 更新文档和变更日志

## 扩展性

项目设计支持以下扩展：

1. **新的 AI 助手**: 通过添加新的模板和脚本支持
2. **新的脚本类型**: 扩展跨平台脚本支持
3. **新的命令**: 通过模板系统添加新的 CLI 命令
4. **新的功能**: 通过模块化架构添加新功能

这种结构化的设计使得 spec-kit 既易于使用，又便于维护和扩展。
