# Spec-Kit 教程中心

欢迎来到 Spec-Kit 教程中心！这里包含了关于 spec-kit 项目的详细教程和文档。

## 教程目录

### 📚 核心教程

1. **[uvx 命令实现原理详解](./uvx-implementation-guide.md)**
   - 详细说明 `uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>` 命令的工作原理
   - 项目配置分析
   - 执行流程详解
   - 技术特点和模板系统

2. **[项目结构概览](./project-structure-overview.md)**
   - 完整的项目目录结构说明
   - 核心组件介绍
   - 项目特点和开发工作流
   - 扩展性说明

3. **[CLI 命令参考](./cli-commands-reference.md)**
   - 所有可用命令的详细说明
   - 参数和选项参考
   - 使用示例和最佳实践
   - 故障排除指南

4. **[Scripts 脚本参考指南](./scripts-reference-guide.md)**
   - 所有脚本工具的详细说明
   - Bash 和 PowerShell 版本对比
   - 功能开发工作流程
   - 跨平台兼容性说明

5. **[Memory 文档系统指南](./memory-documents-guide.md)**
   - 项目宪法和治理文档说明
   - 核心原则和开发规范
   - 宪法更新和维护流程
   - 与其他系统的集成

6. **[Templates 模板系统指南](./templates-system-guide.md)**
   - 所有模板文档的详细说明
   - 模板结构和占位符系统
   - 命令模板和自动化集成
   - 模板使用和自定义方法

7. **[实际项目开发流程指南](./practical-workflow-guide.md)**
   - Cursor 环境下的完整开发流程
   - 脚本和文档的协同工作机制
   - 实战案例：用户认证系统开发
   - 各组件集成和最佳实践

8. **[Quickstart 学习指南](./quickstart-learning-guide.md)**
   - Quickstart 的作用与定位详解
   - 与用户交互流程、页面设计的关系
   - 页面拆解的正确理解
   - 实际应用示例和最佳实践
   - 常见误区与避免方法

9. **[Tasks 隐式页面设计指南](./tasks-implicit-page-design-guide.md)**
   - Tasks 命令的隐式页面设计机制
   - 基于用户故事的自动页面拆解
   - 与显式页面设计的关系和协作
   - 实际应用示例和最佳实践
   - 优势局限性和常见问题解答

## 快速开始

### 1. 了解项目

如果您是第一次接触 spec-kit，建议按以下顺序阅读：

1. 先阅读 [项目结构概览](./project-structure-overview.md) 了解整体架构
2. 然后查看 [CLI 命令参考](./cli-commands-reference.md) 学习如何使用
3. 接着阅读 [Scripts 脚本参考指南](./scripts-reference-guide.md) 了解开发工具
4. 深入了解 [Memory 文档系统指南](./memory-documents-guide.md) 掌握项目治理
5. 学习 [Templates 模板系统指南](./templates-system-guide.md) 理解文档生成机制
6. **重点推荐**: 阅读 [实际项目开发流程指南](./practical-workflow-guide.md) 掌握完整工作流程
7. 最后深入 [uvx 实现原理](./uvx-implementation-guide.md) 理解技术细节

### 2. 实际使用

```bash
# 检查工具安装状态
uvx --from git+https://github.com/github/spec-kit.git specify check

# 创建新项目
uvx --from git+https://github.com/github/spec-kit.git specify init my-project

# 进入项目目录
cd my-project

# 开始使用 AI 助手进行 spec-driven 开发
```

## 技术栈

Spec-Kit 基于以下技术构建：

- **Python 3.11+**: 核心编程语言
- **Typer**: 命令行界面框架
- **Rich**: 终端美化库
- **httpx**: HTTP 客户端
- **uv**: 现代 Python 包管理器
- **GitHub API**: 模板下载和发布管理

## 支持的 AI 助手

- **Claude Code**: Anthropic 的 AI 编程助手
- **Gemini CLI**: Google 的 AI 命令行工具
- **GitHub Copilot**: GitHub 的 AI 代码助手
- **Cursor**: Cursor 编辑器的 AI 功能

## 支持的平台

- **Windows**: PowerShell 脚本支持
- **macOS**: Bash/Zsh 脚本支持
- **Linux**: Bash 脚本支持

## 贡献指南

如果您想为教程做出贡献：

1. 阅读项目的 [CONTRIBUTING.md](../CONTRIBUTING.md)
2. 遵循 [CODE_OF_CONDUCT.md](../CODE_OF_CONDUCT.md)
3. 在 `tutorials/` 目录下创建新的教程文档
4. 更新本 README.md 文件添加新教程的链接

## 获取帮助

- **文档**: 查看 [docs/](../docs/) 目录下的官方文档
- **问题报告**: 在 [GitHub Issues](https://github.com/github/spec-kit/issues) 报告问题
- **讨论**: 参与 [GitHub Discussions](https://github.com/github/spec-kit/discussions)
- **安全**: 查看 [SECURITY.md](../SECURITY.md) 了解安全相关信息

## 许可证

本项目采用 [LICENSE](../LICENSE) 中指定的许可证。

---

**注意**: 这些教程文档会随着项目的发展持续更新。如果您发现任何过时或不准确的信息，请及时反馈。
