# Spec-Kit Scripts 脚本参考指南

## 概述

Spec-Kit 项目包含了一套完整的脚本工具，用于支持 spec-driven 开发工作流。这些脚本分为两个版本：Bash（适用于 Unix-like 系统）和 PowerShell（适用于 Windows 系统），提供相同的功能但使用不同的脚本语言实现。

## 脚本目录结构

```
scripts/
├── bash/                          # Bash 脚本（Unix-like 系统）
│   ├── common.sh                  # 通用函数和变量
│   ├── check-task-prerequisites.sh # 检查任务前置条件
│   ├── create-new-feature.sh      # 创建新功能
│   ├── get-feature-paths.sh       # 获取功能路径
│   ├── setup-plan.sh              # 设置计划
│   └── update-agent-context.sh    # 更新代理上下文
└── powershell/                    # PowerShell 脚本（Windows 系统）
    ├── common.ps1                 # 通用函数和变量
    ├── check-task-prerequisites.ps1 # 检查任务前置条件
    ├── create-new-feature.ps1     # 创建新功能
    ├── get-feature-paths.ps1      # 获取功能路径
    ├── setup-plan.ps1             # 设置计划
    └── update-agent-context.ps1   # 更新代理上下文
```

## 通用脚本 (common)

### Bash: `common.sh`

**作用**: 提供所有 Bash 脚本共享的通用函数和变量。

**主要功能**:

1. **Git 操作函数**:
   ```bash
   get_repo_root()           # 获取仓库根目录
   get_current_branch()      # 获取当前分支名
   ```

2. **分支验证**:
   ```bash
   check_feature_branch()    # 验证是否为功能分支（格式：001-feature-name）
   ```

3. **路径管理**:
   ```bash
   get_feature_dir()         # 获取功能目录路径
   get_feature_paths()       # 获取所有功能相关路径的环境变量
   ```

4. **文件检查**:
   ```bash
   check_file()              # 检查文件是否存在
   check_dir()               # 检查目录是否存在且非空
   ```

**环境变量输出**:
```bash
REPO_ROOT='...'              # 仓库根目录
CURRENT_BRANCH='...'         # 当前分支
FEATURE_DIR='...'            # 功能目录
FEATURE_SPEC='...'           # 功能规范文件
IMPL_PLAN='...'              # 实现计划文件
TASKS='...'                  # 任务文件
RESEARCH='...'               # 研究文件
DATA_MODEL='...'             # 数据模型文件
QUICKSTART='...'             # 快速开始文件
CONTRACTS_DIR='...'          # 合约目录
```

### PowerShell: `common.ps1`

**作用**: 提供所有 PowerShell 脚本共享的通用函数和变量。

**主要功能**:

1. **Git 操作函数**:
   ```powershell
   Get-RepoRoot              # 获取仓库根目录
   Get-CurrentBranch         # 获取当前分支名
   ```

2. **分支验证**:
   ```powershell
   Test-FeatureBranch        # 验证是否为功能分支
   ```

3. **路径管理**:
   ```powershell
   Get-FeatureDir            # 获取功能目录路径
   Get-FeaturePathsEnv       # 获取所有功能相关路径的对象
   ```

4. **文件检查**:
   ```powershell
   Test-FileExists           # 检查文件是否存在
   Test-DirHasFiles          # 检查目录是否存在且包含文件
   ```

## 功能管理脚本

### 1. 创建新功能

#### Bash: `create-new-feature.sh`

**作用**: 创建新的功能分支和目录结构。

**用法**:
```bash
./create-new-feature.sh [--json] <feature_description>
```

**功能**:
1. **自动编号**: 扫描现有功能，自动生成下一个编号（001, 002, 003...）
2. **分支创建**: 基于功能描述创建格式化的分支名（如：`001-user-authentication`）
3. **目录结构**: 在 `specs/` 目录下创建功能目录
4. **模板复制**: 从 `templates/spec-template.md` 复制规范模板

**输出示例**:
```bash
BRANCH_NAME: 001-user-authentication
SPEC_FILE: /path/to/specs/001-user-authentication/spec.md
FEATURE_NUM: 001
```

**JSON 模式**:
```bash
./create-new-feature.sh --json "user authentication system"
# 输出: {"BRANCH_NAME":"001-user-authentication","SPEC_FILE":"...","FEATURE_NUM":"001"}
```

#### PowerShell: `create-new-feature.ps1`

**作用**: PowerShell 版本的创建新功能脚本。

**用法**:
```powershell
./create-new-feature.ps1 [-Json] <feature_description>
```

**功能**: 与 Bash 版本相同，但使用 PowerShell 语法实现。

### 2. 获取功能路径

#### Bash: `get-feature-paths.sh`

**作用**: 显示当前功能的所有相关路径信息。

**用法**:
```bash
./get-feature-paths.sh
```

**输出**:
```bash
REPO_ROOT: /path/to/repo
BRANCH: 001-user-authentication
FEATURE_DIR: /path/to/repo/specs/001-user-authentication
FEATURE_SPEC: /path/to/repo/specs/001-user-authentication/spec.md
IMPL_PLAN: /path/to/repo/specs/001-user-authentication/plan.md
TASKS: /path/to/repo/specs/001-user-authentication/tasks.md
```

#### PowerShell: `get-feature-paths.ps1`

**作用**: PowerShell 版本的获取功能路径脚本。

**功能**: 与 Bash 版本相同，输出当前功能的所有路径信息。

### 3. 设置计划

#### Bash: `setup-plan.sh`

**作用**: 为当前功能创建实现计划文件。

**用法**:
```bash
./setup-plan.sh [--json]
```

**功能**:
1. **验证分支**: 确保当前在功能分支上
2. **创建目录**: 确保功能目录存在
3. **复制模板**: 从 `templates/plan-template.md` 复制计划模板到 `plan.md`

**输出示例**:
```bash
FEATURE_SPEC: /path/to/specs/001-user-authentication/spec.md
IMPL_PLAN: /path/to/specs/001-user-authentication/plan.md
SPECS_DIR: /path/to/specs/001-user-authentication
BRANCH: 001-user-authentication
```

#### PowerShell: `setup-plan.ps1`

**作用**: PowerShell 版本的设置计划脚本。

**功能**: 与 Bash 版本相同，创建实现计划文件。

## 任务和上下文管理脚本

### 1. 检查任务前置条件

#### Bash: `check-task-prerequisites.sh`

**作用**: 检查当前功能的任务前置条件是否满足。

**用法**:
```bash
./check-task-prerequisites.sh [--json]
```

**检查项目**:
1. **功能目录**: 确保 `specs/<branch>/` 目录存在
2. **实现计划**: 确保 `plan.md` 文件存在
3. **可选文档**: 检查以下文件是否存在：
   - `research.md` - 研究文档
   - `data-model.md` - 数据模型文档
   - `contracts/` - 合约目录（非空）
   - `quickstart.md` - 快速开始文档

**输出示例**:
```bash
FEATURE_DIR:/path/to/specs/001-user-authentication
AVAILABLE_DOCS:
  ✓ research.md
  ✗ data-model.md
  ✓ contracts/
  ✗ quickstart.md
```

**JSON 模式**:
```bash
./check-task-prerequisites.sh --json
# 输出: {"FEATURE_DIR":"...","AVAILABLE_DOCS":["research.md","contracts/"]}
```

#### PowerShell: `check-task-prerequisites.ps1`

**作用**: PowerShell 版本的检查任务前置条件脚本。

**功能**: 与 Bash 版本相同，检查任务前置条件。

### 2. 更新代理上下文

#### Bash: `update-agent-context.sh`

**作用**: 根据当前功能的实现计划更新 AI 代理的上下文文件。

**用法**:
```bash
./update-agent-context.sh [claude|gemini|copilot]
```

**功能**:
1. **解析计划**: 从 `plan.md` 中提取技术信息：
   - 编程语言/版本
   - 主要依赖
   - 存储方案
   - 项目类型

2. **更新代理文件**:
   - **Claude Code**: 更新 `CLAUDE.md`
   - **Gemini CLI**: 更新 `GEMINI.md`
   - **GitHub Copilot**: 更新 `.github/copilot-instructions.md`

3. **智能更新**:
   - 如果文件不存在，从模板创建
   - 如果文件存在，智能合并新信息
   - 保留手动添加的内容

**更新内容**:
- **活跃技术**: 添加新的编程语言和框架
- **项目结构**: 根据项目类型设置目录结构
- **测试命令**: 根据编程语言设置测试和检查命令
- **最近变更**: 记录最新的功能添加

**输出示例**:
```bash
=== Updating agent context files for feature 001-user-authentication ===
Updating Claude Code context file: /path/to/CLAUDE.md
✅ Claude Code context file updated successfully

Summary of changes:
- Added language: Python 3.11
- Added framework: FastAPI
- Added database: PostgreSQL
```

#### PowerShell: `update-agent-context.ps1`

**作用**: PowerShell 版本的更新代理上下文脚本。

**功能**: 与 Bash 版本相同，但使用 PowerShell 语法实现。

## 使用工作流

### 典型的功能开发流程

1. **创建新功能**:
   ```bash
   # Bash
   ./scripts/bash/create-new-feature.sh "user authentication system"
   
   # PowerShell
   ./scripts/powershell/create-new-feature.ps1 "user authentication system"
   ```

2. **编写功能规范**:
   - 编辑 `specs/001-user-authentication/spec.md`

3. **设置实现计划**:
   ```bash
   # Bash
   ./scripts/bash/setup-plan.sh
   
   # PowerShell
   ./scripts/powershell/setup-plan.ps1
   ```

4. **编写实现计划**:
   - 编辑 `specs/001-user-authentication/plan.md`

5. **更新代理上下文**:
   ```bash
   # Bash
   ./scripts/bash/update-agent-context.sh claude
   
   # PowerShell
   ./scripts/powershell/update-agent-context.ps1 claude
   ```

6. **检查任务前置条件**:
   ```bash
   # Bash
   ./scripts/bash/check-task-prerequisites.sh
   
   # PowerShell
   ./scripts/powershell/check-task-prerequisites.ps1
   ```

7. **获取路径信息**:
   ```bash
   # Bash
   ./scripts/bash/get-feature-paths.sh
   
   # PowerShell
   ./scripts/powershell/get-feature-paths.ps1
   ```

## 脚本特性

### 1. 跨平台兼容

- **Bash 版本**: 适用于 Linux、macOS 等 Unix-like 系统
- **PowerShell 版本**: 适用于 Windows 系统
- **功能对等**: 两个版本提供完全相同的功能

### 2. JSON 输出支持

大多数脚本支持 `--json` 参数，提供机器可读的输出格式，便于与其他工具集成。

### 3. 错误处理

- **严格模式**: 使用 `set -e`（Bash）和 `$ErrorActionPreference = 'Stop'`（PowerShell）
- **详细错误信息**: 提供清晰的错误消息和解决建议
- **优雅失败**: 在遇到错误时提供有用的提示

### 4. 分支命名规范

- **格式**: `001-feature-name`
- **编号**: 自动递增的三位数字
- **名称**: 基于功能描述自动生成，使用小写字母和连字符

### 5. 模板系统

- **规范模板**: `templates/spec-template.md`
- **计划模板**: `templates/plan-template.md`
- **代理模板**: `templates/agent-file-template.md`

## 集成和扩展

### 1. 与 AI 代理集成

脚本设计为与以下 AI 代理无缝集成：
- **Claude Code**: 通过 `CLAUDE.md` 文件
- **Gemini CLI**: 通过 `GEMINI.md` 文件
- **GitHub Copilot**: 通过 `.github/copilot-instructions.md` 文件

### 2. 自定义扩展

可以通过以下方式扩展脚本功能：
- **添加新的检查项**: 在 `check-task-prerequisites` 脚本中添加新的文件检查
- **自定义模板**: 修改模板文件以适应特定项目需求
- **新的输出格式**: 添加新的输出格式支持

### 3. 自动化集成

脚本支持 JSON 输出，可以轻松集成到 CI/CD 流水线或其他自动化工具中。

## 最佳实践

### 1. 分支管理

- 始终在功能分支上运行脚本
- 使用描述性的功能名称
- 遵循编号命名规范

### 2. 文档维护

- 及时更新代理上下文文件
- 保持规范、计划和任务文档的同步
- 使用脚本检查前置条件

### 3. 错误处理

- 在运行脚本前检查当前分支
- 确保必要的模板文件存在
- 查看详细的错误信息

### 4. 版本控制

- 将脚本更改提交到版本控制
- 使用脚本的 JSON 输出进行自动化
- 保持 Bash 和 PowerShell 版本的功能同步

## 故障排除

### 常见问题

1. **"Not on a feature branch" 错误**:
   - 确保当前分支名称以三位数字开头（如：`001-feature-name`）

2. **"Feature directory not found" 错误**:
   - 先运行 `create-new-feature.sh` 创建功能结构

3. **"plan.md not found" 错误**:
   - 先运行 `setup-plan.sh` 创建计划文件

4. **模板文件缺失**:
   - 确保 `templates/` 目录包含必要的模板文件

### 调试技巧

1. **使用 JSON 输出**: 便于程序化处理错误
2. **检查文件权限**: 确保脚本有执行权限
3. **验证 Git 状态**: 确保在正确的仓库和分支上
4. **查看详细输出**: 脚本提供详细的路径和状态信息

这套脚本系统为 spec-driven 开发提供了完整的工具链支持，确保开发流程的规范化和自动化。
