## 为 Spec Kit 做贡献

你好！我们很高兴您想为 Spec Kit 做贡献。对此项目的贡献在[项目开源许可证](LICENSE)下[公开发布](https://help.github.com/articles/github-terms-of-service/#6-contributions-under-repository-license)。

请注意，此项目发布时带有[贡献者行为准则](CODE_OF_CONDUCT.md)。通过参与此项目，您同意遵守其条款。

## 运行和测试代码的先决条件

这些是一次性安装，需要在本地测试您的更改作为拉取请求（PR）提交过程的一部分。

1. 安装 [Python 3.11+](https://www.python.org/downloads/)
1. 安装 [uv](https://docs.astral.sh/uv/) 用于包管理
1. 安装 [Git](https://git-scm.com/downloads)
1. 拥有可用的 AI 编码代理：推荐 [Claude Code](https://www.anthropic.com/claude-code)、[GitHub Copilot](https://code.visualstudio.com/) 或 [Gemini CLI](https://github.com/google-gemini/gemini-cli)，但我们正在努力添加对其他代理的支持。

## 提交拉取请求

>[!NOTE]
>如果您的拉取请求引入了对 CLI 或仓库其余部分的工作产生重大影响的大更改（例如，您正在引入新模板、参数或其他重大更改），请确保已与项目维护者**讨论并达成一致**。没有事先对话和协议的大更改拉取请求将被关闭。

1. Fork 并克隆仓库
1. 配置并安装依赖项：`uv sync`
1. 确保 CLI 在您的机器上工作：`uv run specify --help`
1. 创建新分支：`git checkout -b my-branch-name`
1. 进行更改，添加测试，并确保一切仍然正常工作
1. 如果相关，使用示例项目测试 CLI 功能
1. 推送到您的 fork 并提交拉取请求
1. 等待您的拉取请求被审查和合并。

以下是一些可以增加您的拉取请求被接受的可能性的事情：

- 遵循项目的编码约定。
- 为新功能编写测试。
- 如果您的更改影响面向用户的功能，请更新文档（`README.md`、`spec-driven.md`）。
- 尽可能保持您的更改专注。如果您想进行多个不相互依赖的更改，请考虑将它们作为单独的拉取请求提交。
- 编写[好的提交消息](http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)。
- 使用规范驱动开发工作流测试您的更改以确保兼容性。

## 开发工作流

在 spec-kit 上工作时：

1. 在您选择的编码代理中使用 `specify` CLI 命令（`/specify`、`/plan`、`/tasks`）测试更改
2. 验证 `templates/` 目录中的模板正常工作
3. 测试 `scripts/` 目录中的脚本功能
4. 如果进行了重大流程更改，确保更新内存文件（`memory/constitution.md`）

## 资源

- [规范驱动开发方法论](./spec-driven.md)
- [如何为开源做贡献](https://opensource.guide/how-to-contribute/)
- [使用拉取请求](https://help.github.com/articles/about-pull-requests/)
- [GitHub 帮助](https://help.github.com)
