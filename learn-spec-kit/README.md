# Spec-Kit 学习中心

欢迎来到 Spec-Kit 学习中心！这里提供了从理论到实践的完整学习路径，帮助您深入理解 Spec-Driven Development (SDD) 和 SpecKit 工具。

## 🎯 学习路径

### 第一阶段：理论基础

#### 1. **[SDD 理论介绍](./sdd-theory-guide.md)**
   - 规范驱动开发的核心思想
   - 从代码为王到规范为王的转变
   - SDD 工作流程和实践原则
   - 为什么现在需要 SDD
   - **扩展阅读**: [spec-driven.md](../spec-driven.md) - 官方 SDD 理论文档

#### 2. **[SpecKit 理论介绍](./speckit-theory-guide.md)**
   - SpecKit 的设计理念和定位
   - 如何实现 SDD 的工具化
   - 与 AI 助手的集成机制
   - 项目结构和文档组织原理

### 第二阶段：快速上手

#### 3. **[安装和简单使用](./installation-and-quickstart.md)**
   - 环境准备和工具安装
   - 创建第一个 SpecKit 项目
   - 基本命令使用
   - 快速体验 SDD 开发流程

### 第三阶段：深入理解

#### 4. **[SpecKit 命令详解](./speckit-commands-guide.md)**
   - **使用角度**: 每个命令的设计目的和使用场景
   - **具体作用**: 命令能解决什么问题
   - **最佳实践**: 如何高效使用各个命令
   - **常见问题**: 使用中的注意事项和解决方案

#### 5. **[SpecKit 命令原理](./speckit-commands-principles.md)**
   - **背后流程**: 用户触发命令后发生了什么
   - **文档组织**: 业务文档如何自动生成和更新
   - **完整流程图**: 从用户命令到文档生成的完整流程
   - **技术实现**: 命令背后的技术原理

### 第四阶段：实践应用

#### 6. **[SpecKit 实践思考](./speckit-practice-thoughts.md)**
   - **实际开发中的问题和疑问**
   - **解决方案分析**: 如何应对常见挑战
   - **版本更新**: 新版本如何解决历史问题
   - **最佳实践总结**: 从实践中总结的经验

#### 7. **[实际项目开发流程指南](./practical-workflow-guide.md)**
   - Cursor 环境下的完整开发流程
   - 脚本和文档的协同工作机制
   - 实战案例：用户认证系统开发
   - 各组件集成和最佳实践

### 第五阶段：深度技术

#### 8. **[SpecKit 工程化原理](./speckit-engineering-principles.md)**
   - **SpecKit CLI 实现原理**: 如何支持多 AI Agent
   - **发布机制**: 如何实现跨平台发布
   - **安装机制**: uvx 命令的工作原理
   - **扩展性设计**: 如何添加新的 AI Agent 支持

#### 9. **[uvx 命令实现原理详解](./uvx-implementation-guide.md)**
   - 详细说明 `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>` 命令的工作原理
   - 项目配置分析
   - 执行流程详解
   - 技术特点和模板系统

### 第六阶段：专题深入

#### 10. **[项目结构概览](./project-structure-overview.md)**
   - 完整的项目目录结构说明
   - 核心组件介绍
   - 项目特点和开发工作流
   - 扩展性说明

#### 11. **[Memory 文档系统指南](./memory-documents-guide.md)**
   - 项目宪法和治理文档说明
   - 核心原则和开发规范
   - 宪法更新和维护流程
   - 与其他系统的集成

#### 12. **[Templates 模板系统指南](./templates-system-guide.md)**
   - 所有模板文档的详细说明
   - 模板结构和占位符系统
   - 命令模板和自动化集成
   - 模板使用和自定义方法

#### 13. **[Scripts 脚本参考指南](./scripts-reference-guide.md)**
   - 所有脚本工具的详细说明
   - Bash 和 PowerShell 版本对比
   - 功能开发工作流程
   - 跨平台兼容性说明

#### 14. **[Quickstart 学习指南](./quickstart-learning-guide.md)**
   - Quickstart 的作用与定位详解
   - 与用户交互流程、页面设计的关系
   - 页面拆解的正确理解
   - 实际应用示例和最佳实践
   - 常见误区与避免方法

#### 15. **[Tasks 隐式页面设计指南](./tasks-implicit-page-design-guide.md)**
   - Tasks 命令的隐式页面设计机制
   - 基于用户故事的自动页面拆解
   - 与显式页面设计的关系和协作
   - 实际应用示例和最佳实践
   - 优势局限性和常见问题解答

#### 16. **[CLI 命令参考](./cli-commands-reference.md)**
   - 所有可用命令的详细说明
   - 参数和选项参考
   - 使用示例和最佳实践
   - 故障排除指南

## 🚀 快速开始

### 新手推荐路径

如果您是第一次接触 SpecKit，建议按以下顺序学习：

1. **理论基础** → 阅读 [SDD 理论介绍](./sdd-theory-guide.md) 和 [SpecKit 理论介绍](./speckit-theory-guide.md)
2. **快速上手** → 按照 [安装和简单使用](./installation-and-quickstart.md) 创建第一个项目
3. **深入理解** → 学习 [SpecKit 命令详解](./speckit-commands-guide.md) 和 [命令原理](./speckit-commands-principles.md)
4. **实践应用** → 参考 [实践思考](./speckit-practice-thoughts.md) 和 [实际项目开发流程指南](./practical-workflow-guide.md)
5. **深度技术** → 深入了解 [工程化原理](./speckit-engineering-principles.md) 和 [uvx 实现原理](./uvx-implementation-guide.md)

### 有经验用户路径

如果您已经了解 SDD 概念，可以直接：

1. **快速体验** → [安装和简单使用](./installation-and-quickstart.md)
2. **命令掌握** → [SpecKit 命令详解](./speckit-commands-guide.md)
3. **实践应用** → [实际项目开发流程指南](./practical-workflow-guide.md)

### 立即开始

```bash
# 检查工具安装状态
uvx --from git+https://github.com/github/spec-kit.git specify check

# 创建新项目
uvx --from git+https://github.com/github/spec-kit.git specify init my-project

# 进入项目目录
cd my-project

# 开始使用 AI 助手进行 spec-driven 开发
```

## 🛠️ 技术栈

SpecKit 基于现代 Python 技术栈构建：

- **Python 3.11+**: 核心编程语言
- **Typer**: 命令行界面框架
- **Rich**: 终端美化库
- **httpx**: HTTP 客户端
- **uv**: 现代 Python 包管理器
- **GitHub API**: 模板下载和发布管理

## 🤖 支持的 AI 助手

| AI 助手 | 支持级别 | 特点 | 适用场景 |
|---------|----------|------|----------|
| **Claude Code** | 完全支持 | 代码理解能力强 | 复杂业务逻辑实现 |
| **Gemini CLI** | 完全支持 | 多模态理解 | 跨平台开发 |
| **GitHub Copilot** | 完全支持 | 集成度高 | VS Code 用户 |
| **Cursor** | 完全支持 | 现代开发体验 | 全栈开发 |
| **Qwen Code** | 完全支持 | 中文理解强 | 中文项目开发 |
| **opencode** | 完全支持 | 开源友好 | 开源项目 |

## 🖥️ 支持的平台

- **Windows**: PowerShell 脚本支持
- **macOS**: Bash/Zsh 脚本支持  
- **Linux**: Bash 脚本支持

## 📚 学习建议

### 新手学习路径
1. **理论基础** → [SDD 理论介绍](./sdd-theory-guide.md) + [SpecKit 理论介绍](./speckit-theory-guide.md)
2. **快速上手** → [安装和简单使用](./installation-and-quickstart.md)
3. **深入理解** → [SpecKit 命令详解](./speckit-commands-guide.md) + [命令原理](./speckit-commands-principles.md)
4. **实践应用** → [实践思考](./speckit-practice-thoughts.md) + [实际项目开发流程指南](./practical-workflow-guide.md)

### 有经验用户路径
1. **快速体验** → [安装和简单使用](./installation-and-quickstart.md)
2. **命令掌握** → [SpecKit 命令详解](./speckit-commands-guide.md)
3. **实践应用** → [实际项目开发流程指南](./practical-workflow-guide.md)

## 🤝 贡献指南

如果您想为学习中心做出贡献：

1. 阅读项目的 [CONTRIBUTING.md](../CONTRIBUTING.md)
2. 遵循 [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md)
3. 在 `learn-spec-kit/` 目录下创建新的教程文档
4. 更新本 README.md 文件添加新教程的链接

## 📞 获取帮助

- **文档**: 查看 [docs/](../docs/) 目录下的官方文档
- **问题报告**: 在 [GitHub Issues](https://github.com/github/spec-kit/issues) 报告问题
- **讨论**: 参与 [GitHub Discussions](https://github.com/github/spec-kit/discussions)
- **安全**: 查看 [SECURITY.md](../SECURITY.md) 了解安全相关信息

## 📄 许可证

本项目采用 [LICENSE](../LICENSE) 中指定的许可证。

---

**注意**: 这些学习文档会随着项目的发展持续更新。如果您发现任何过时或不准确的信息，请及时反馈。

**最后更新**: 2024年12月
