# Spec-Kit 学习中心

欢迎来到 Spec-Kit 学习中心！这里提供了从理论到实践的完整学习路径，帮助您深入理解 Spec-Driven Development (SDD) 和 SpecKit 工具。

## 🌟 为什么值得深入学习 SpecKit？

SpecKit 不仅仅是一个简单的命令工具，它代表了软件开发范式的重大转变。深入学习 SpecKit 将为您带来：

### 🎯 **规范驱动开发 (SDD) 的完整实践**
- 从"代码为王"到"规范为王"的思维转变
- 如何让规范成为可执行的开发指导
- 多阶段文档驱动的开发流程设计

### 🤖 **AI Agent 协作的工程化实践**
- 如何设计 AI Agent 友好的项目结构
- 多 AI 代理的集成机制和最佳实践
- 从 AGENTS.md 标准到实际工程应用的完整链路

### 🛠️ **精巧的模板和脚本系统**
- 模板驱动的文档生成机制
- 跨平台脚本的自动化工作流
- 命令背后的完整技术实现原理

### 🏗️ **现代软件工程的最佳实践**
- 项目治理和宪法驱动的开发
- 测试驱动开发 (TDD) 的自动化实现
- 从需求到代码的完整可追溯性

### 🚀 **AI 时代的开发范式**
- 如何与 AI 助手高效协作
- 多 AI 代理的协调和管理
- 人机协作的最佳实践模式

**无论您是初学者还是资深开发者，SpecKit 都能为您提供从基础使用到深度定制的全方位学习体验。**

## 🎯 学习路径

### 第一阶段：理论基础

#### 1.1 **[SDD 理论介绍](./sdd-theory-guide.md)**
   - 规范驱动开发的核心思想
   - 从代码为王到规范为王的转变
   - SDD 工作流程和实践原则
   - 为什么现在需要 SDD
   - **扩展阅读**: [spec-driven.md](../spec-driven.md) - 官方 SDD 理论文档

#### 1.2. **[SpecKit 理论介绍](./speckit-theory-guide.md)**
   - SpecKit 的设计理念和定位
   - 如何实现 SDD 的工具化
   - 与 AI 助手的集成机制
   - 项目结构和文档组织原理

### 第二阶段：快速上手

#### 2.1. **[安装和简单使用](./installation-and-quickstart.md)**
   - 环境准备和工具安装
   - 创建第一个 SpecKit 项目
   - 基本命令使用
   - 快速了解 SpecKit 开发流程

#### 2.2. **[实际项目开发流程指南](./practical-workflow-guide.md)**
   - Cursor 环境下的核心开发流程
   - /constitution /specify /clarify /plan /tasks /analyze /implement 7个核心命令
   - 脚本和文档的协同工作机制
   - 实战案例：用户认证系统开发

### 第三阶段：命令详解(速查手册)

#### 3.1. **[SpecKit CLI 项目管理命令参考](./cli-commands-reference.md)**
   - **项目管理命令**: `specify init`, `specify check` 等
   - 所有可用命令的详细说明
   - 参数和选项参考
   - 使用示例和最佳实践
   - 故障排除指南

#### 3.2. **[AI Agent 开发命令详解](./agent-commands-guide.md)**
   - **开发流程命令**: `/constitution`, `/specify`, `/clarify`, `/plan`, `/tasks`, `/analyze`, `/implement` 等
   - **使用角度**: 每个命令的设计目的和使用场景
   - **具体作用**: 命令能解决什么问题
   - **最佳实践**: 如何高效使用各个命令
   - **常见问题**: 使用中的注意事项和解决方案

### 第四阶段：深入理解Agent命令工作机制

#### 4.1. **[AI Agent 命令原理](./agent-commands-principles.md)**
   - **背后流程**: 用户触发命令后发生了什么
   - **文档组织**: 业务文档如何自动生成和更新
   - **完整流程图**: 从用户命令到文档生成的完整流程
   - **技术实现**: 命令背后的SpecKit原理

#### 4.2. **[Memory 文档系统指南](./memory-documents-guide.md)**
   - 项目宪法和治理文档说明
   - 核心原则和开发规范
   - 宪法更新和维护流程
   - 与其他系统的集成

#### 4.3. **[Templates 模板系统指南](./templates-system-guide.md)**
   - 所有模板文档的详细说明
   - 模板结构和占位符系统
   - 命令模板和自动化集成
   - 模板使用和自定义方法

#### 4.4. **[Scripts 脚本参考指南](./scripts-reference-guide.md)**
   - 所有脚本工具的详细说明
   - Bash 和 PowerShell 版本对比
   - 功能开发工作流程
   - 跨平台兼容性说明

#### 4.5. **[Quickstart 学习指南](./quickstart-learning-guide.md)**
   - Quickstart 的作用与定位详解
   - 与用户交互流程、页面设计的关系
   - 页面拆解的正确理解
   - 实际应用示例和最佳实践
   - 常见误区与避免方法

#### 4.6. **[Tasks 隐式页面设计指南](./tasks-implicit-page-design-guide.md)**
   - Tasks 命令的隐式页面设计机制
   - 基于用户故事的自动页面拆解
   - 与显式页面设计的关系和协作
   - 实际应用示例和最佳实践
   - 优势局限性和常见问题解答

### 第五阶段：深入理解CLI工程化技术

#### 5.1. **[项目结构概览](./project-structure-overview.md)**
   - 完整的项目目录结构说明
   - 核心组件介绍
   - 项目特点和开发工作流
   - 扩展性说明

#### 5.2. **[uvx 命令实现原理详解](./uvx-implementation-guide.md)**
   - 详细说明 `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>` 命令的工作原理
   - 项目配置分析
   - 执行流程详解
   - 技术特点和模板系统

#### 5.3. **[SpecKit 工程化原理](./speckit-engineering-principles.md)**
   - **SpecKit CLI 实现原理**: 如何支持11个AI Agent（Claude、Gemini、Copilot、Cursor、Qwen、opencode、Windsurf、Codex、Kilo Code、Auggie、Roo Code）
   - **发布机制**: 如何实现跨平台发布
   - **安装机制**: uvx 命令的工作原理
   - **扩展性设计**: 如何添加新的 AI Agent 支持

#### 5.4. **[AGENTS.md 机制详解指南](./agents-md-mechanism-guide.md)**
   - AGENTS.md 标准机制的历史背景和设计理念
   - AI 代理的读取流程和交互模式
   - 与 README.md 的区别和互补关系
   - 核心价值和项目治理优势
   - 与 SpecKit 多 AI 代理的集成机制


## 📄 许可证

本项目采用 [LICENSE](../LICENSE) 中指定的许可证。

---

**注意**: 这些学习文档会随着项目的发展持续更新。如果您发现任何过时或不准确的信息，请及时反馈。

**最后更新**: 2025年9月
