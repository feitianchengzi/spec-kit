# 快速开始指南

本指南将帮助您使用 Spec Kit 开始规范驱动开发。

> 新功能：所有自动化脚本现在都提供 Bash（`.sh`）和 PowerShell（`.ps1`）变体。`specify` CLI 根据操作系统自动选择，除非您传递 `--script sh|ps`。

## 4 步流程

### 1. 安装 Specify

根据您使用的编码代理初始化项目：

```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME>

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <PROJECT_NAME>
```

明确选择脚本类型（可选）：
```bash
# 从官方仓库安装（英文版）
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script ps  # 强制 PowerShell
uvx --from git+https://github.com/github/spec-kit.git specify init <PROJECT_NAME> --script sh  # 强制 POSIX shell

# 从简体中文分支安装
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <PROJECT_NAME> --script ps  # 强制 PowerShell
uvx --from git+https://github.com/feitianchengzi/spec-kit.git@zh-hans specify-zh init <PROJECT_NAME> --script sh  # 强制 POSIX shell
```

### 2. 创建规范

使用 `/specify` 命令描述您想要构建的内容。专注于**什么**和**为什么**，而不是技术栈。

```bash
/specify 构建一个应用程序，帮助我在单独的相册中整理照片。相册按日期分组，可以在主页上通过拖放重新组织。相册永远不会嵌套在其他相册中。在每个相册内，照片以瓦片式界面预览。
```

### 3. 创建技术实现计划

使用 `/plan` 命令提供您的技术栈和架构选择。

```bash
/plan 应用程序使用 Vite 和最少数量的库。尽可能使用原生 HTML、CSS 和 JavaScript。图像不上传到任何地方，元数据存储在本地 SQLite 数据库中。
```

### 4. 分解并实现

使用 `/tasks` 创建可操作的任务列表，然后让您的代理实现功能。

## 详细示例：构建 Taskify

这是一个构建团队生产力平台的完整示例：

### 步骤 1：使用 `/specify` 定义需求

```text
开发 Taskify，一个团队生产力平台。它应该允许用户创建项目、添加团队成员、
分配任务、评论并在看板样式的板之间移动任务。在这个功能的初始阶段，
让我们称之为"创建 Taskify"，让我们有多个用户，但用户将提前声明，预定义。
我想要五个用户分为两个不同类别，一个产品经理和四个工程师。让我们创建三个
不同的示例项目。让我们为每个任务的状态设置标准的看板列，如"待办"、
"进行中"、"审查中"和"完成"。此应用程序将没有登录，因为这只是
第一个测试，以确保我们的基本功能已设置。对于任务卡片 UI 中的每个任务，
您应该能够在看板工作板的不同列之间更改任务的当前状态。
您应该能够为特定卡片留下无限数量的评论。您应该能够从该任务
卡片中分配一个有效用户。当您首次启动 Taskify 时，它将为您提供五个用户列表供选择。
不需要密码。当您点击用户时，您进入主视图，显示
项目列表。当您点击项目时，您打开该项目的看板。您将看到列。
您将能够在不同列之间拖放卡片。您将看到任何
分配给您的卡片，当前登录用户，与其他所有卡片颜色不同，这样您可以快速
看到您的。您可以编辑您发表的任何评论，但您不能编辑其他人发表的评论。您可以
删除您发表的任何评论，但您不能删除其他人发表的任何评论。
```

### 步骤 2：细化规范

创建初始规范后，澄清任何缺失的需求：

```text
对于您创建的每个示例项目或项目，应该有 5 到 15 个任务之间的可变数量
任务，随机分布到不同的完成状态。确保每个完成阶段至少
有一个任务。
```

还要验证规范检查清单：

```text
阅读审查和验收检查清单，如果功能规范符合标准，请勾选检查清单中的每个项目。如果不符合，请留空。
```

### 步骤 3：使用 `/plan` 生成技术计划

对您的技术栈和技术要求要具体：

```text
我们将使用 .NET Aspire 生成这个，使用 Postgres 作为数据库。前端应该使用
Blazor 服务器，具有拖放任务板和实时更新。应该创建一个 REST API，包含项目 API、
任务 API 和通知 API。
```

### 步骤 4：验证并实现

让您的 AI 代理审计实现计划：

```text
现在我希望您去审计实现计划和实现详细文件。
仔细阅读，着眼于确定是否有您需要做的任务序列
从阅读中显而易见。因为我不知道这里是否有足够的内容。
```

最后，实现解决方案：

```text
implement specs/002-create-taskify/plan.md
```

## 关键原则

- **明确**您正在构建什么以及为什么
- **不要专注于技术栈**在规范阶段
- **迭代和细化**您的规范在实现之前
- **验证**计划在编码开始之前
- **让 AI 代理处理**实现细节

## 下一步

- 阅读完整的方法论以获得深入指导
- 查看仓库中的更多示例
- 在 GitHub 上探索源代码
