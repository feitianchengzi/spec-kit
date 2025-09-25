# 安装和快速开始指南

## 概述

本指南将帮助您快速安装 SpecKit 并创建第一个规范驱动开发项目。SpecKit 通过标准化的项目结构和 AI 助手集成，实现"规范优先"的开发模式。

## 环境要求

- **操作系统**: Windows 10+, macOS 10.15+, Linux (Ubuntu 18.04+)
- **Python**: 3.11 或更高版本
- **网络**: 需要访问 GitHub 和 AI 服务

## 支持的 AI 助手

SpecKit 支持 Claude Code、GitHub Copilot、Gemini CLI、Cursor 等

**详细信息**: 请参考项目根目录的 [README.md](../README.md) 获取完整的Agent支持列表。

## 安装 SpecKit

### 新项目安装
```bash
# 创建新项目
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>
```

### 已有项目安装
```bash
# 在当前目录初始化
uvx --from git+https://github.com/github/spec-kit.git specify init --here
```

**详细信息**: 请参考项目根目录的 [README.md](../README.md) 获取完整的安装指南。

## 基本使用

### 项目结构
创建成功后，您将看到以下项目结构：

```
my-project/
├── .specify/                   # SpecKit 核心配置
│   ├── memory/                 # 项目记忆和宪法
│   ├── scripts/                # 自动化脚本
│   └── templates/              # 文档模板
└── .claude/                    # AI 助手配置（根据选择的助手）
    └── commands/               # 命令模板
```

### 基本命令
在您的 AI 助手中，您将看到以下命令可用：

1. `/constitution` - 创建项目原则和开发指南
2. `/specify` - 定义要构建的内容（需求和用户故事）
3. `/clarify` - 澄清不明确的区域
4. `/plan` - 创建技术实现计划
5. `/tasks` - 生成可执行的任务列表
6. `/analyze` - 跨工件一致性和覆盖率分析
7. `/implement` - 执行所有任务来构建功能

## 基本使用流程

### 1. 进入项目目录
```bash
cd my-project
```

### 2. 开始规范驱动开发

在您的 AI 助手中按顺序使用以下命令：

注意：constitution、clarify、analyze 在体验时可选择跳过

```
/constitution 创建专注于代码质量、测试标准、用户体验一致性和性能要求的原则
/specify 构建一个可以帮助我整理照片的应用程序
/clarify 澄清不明确的区域
/plan 使用 Vite 和最少库数量的技术栈
/tasks 生成可执行的任务列表
/analyze 分析一致性
/implement 执行所有任务来构建功能
```

**详细信息**: 请参考项目根目录的 [README.md](../README.md) 获取完整的使用指南。

### 3. 查看生成的内容

SpecKit 会根据命令生成相应的文档：

- **`/constitution`**: 生成 `memory/constitution.md` - 项目原则和开发指南
- **`/specify`**: 生成 `specs/001-功能名称/spec.md` - 功能规范文档
- **`/plan`**: 生成多个文档：
  - `specs/001-功能名称/plan.md` - 技术实现计划
  - `specs/001-功能名称/research.md` - 技术研究文档
  - `specs/001-功能名称/data-model.md` - 数据模型
  - `specs/001-功能名称/quickstart.md` - 快速开始指南
  - `specs/001-功能名称/contracts/` - API 合约文档
- **`/tasks`**: 生成 `specs/001-功能名称/tasks.md` - 可执行任务列表
- **`/implement`**: 执行任务并生成实际代码文件

## 下一步学习

现在您已经成功安装了 SpecKit 并创建了第一个项目，接下来可以：

1. **深入学习**: 阅读 [SpecKit 命令详解](./speckit-commands-guide.md) 了解各个命令的详细用法
2. **理解原理**: 学习 [SpecKit 命令原理](./speckit-commands-principles.md) 了解背后的工作机制
3. **实战应用**: 参考 [实际项目开发流程指南](./practical-workflow-guide.md) 进行实际项目开发
4. **深入技术**: 学习 [SpecKit 工程化原理](./speckit-engineering-principles.md) 了解技术实现
