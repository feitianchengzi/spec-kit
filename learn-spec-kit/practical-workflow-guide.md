# 实际项目开发流程指南 - Cursor 实战

## 概述

本指南以 Cursor 编辑器为环境，通过一个完整的项目开发实例，详细说明 spec-kit 项目中各个脚本和 MD 文档是如何协同工作的。我们将从项目初始化开始，逐步展示整个 spec-driven 开发流程。

**注意**: 本指南以核心命令 /specify /plan /tasks 的协同工作机制为重点，其他命令建议大家有实践经验后带着问题试用。
**注意**: 本指南基于 `--ai cursor` 参数创建的项目，因此只包含 Bash 脚本版本，不包含 PowerShell 脚本。

## 项目背景

假设我们要开发一个"用户认证系统"功能，这是一个典型的 Web 应用功能，包含用户注册、登录、密码重置等核心功能。

## 完整开发流程

### 阶段 1: 项目初始化

#### 1.1 使用 uvx 创建项目

```bash
# 在 Cursor 终端中执行
uvx --from git+https://github.com/github/spec-kit.git specify init user-auth-system --ai cursor
```

**执行过程**:
1. `uvx` 从 GitHub 下载 spec-kit 项目
2. 解析 `pyproject.toml` 配置
3. 调用 `specify_cli:main` 函数
4. 执行 `init` 命令，创建项目结构

**生成的文件结构**:
```
user-auth-system/
├── .specify/
│   ├── memory/
│   │   ├── constitution.md
│   ├── scripts/
│   │   └── bash/
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       └── update-agent-context.sh
│   └── templates/
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── agent-file-template.md
└── .cursor/
    └── commands/
        ├── analyze.md
        ├── clarify.md
        ├── constitution.md
        ├── implement.md
        ├── plan.md
        ├── specify.md
        └── tasks.md
```

#### 1.2 进入项目目录

```bash
cd user-auth-system
```

### 阶段 2: 功能规范创建

#### 2.1 在 Cursor 中使用 /specify 命令

在 Cursor 编辑器中，我们使用 `/specify` 命令来创建功能规范：

```
/specify 用户认证系统，包含用户注册、登录、密码重置功能，支持邮箱验证和 JWT 令牌
```

**Cursor 内部执行流程**:

1. **命令解析**: Cursor 识别 `/specify` 命令
2. **脚本调用**: 执行 `.specify/scripts/bash/create-new-feature.sh`
3. **分支创建**: 创建 `001-user-authentication` 分支
4. **目录结构**: 在 `specs/001-user-authentication/` 创建功能目录
5. **模板复制**: 从 `.specify/templates/spec-template.md` 复制到 `spec.md`

#### 2.2 脚本协同工作

**`.specify/scripts/bash/create-new-feature.sh` 执行过程**:

```bash
# 1. 解析参数并生成分支名称
BRANCH_NAME="001-user-authentication"

# 2. 创建分支和目录结构
git checkout -b "$BRANCH_NAME"
mkdir -p "specs/$BRANCH_NAME"

# 3. 复制规范模板
cp ".specify/templates/spec-template.md" "specs/$BRANCH_NAME/spec.md"
```

**生成的文件**:
```
specs/001-user-authentication/
└── spec.md  # 基于 spec-template.md 创建
```

#### 2.3 AI 代理填充规范内容

Cursor 的 AI 代理读取 `templates/spec-template.md` 并填充内容：

**`spec.md` 内容示例**:
```markdown
# Feature Specification: 用户认证系统

## User Scenarios & Testing
### Primary User Story
用户需要能够注册新账户、登录系统、重置密码，并接收邮箱验证。

### Acceptance Scenarios
1. **Given** 用户访问注册页面, **When** 输入有效邮箱和密码, **Then** 系统创建账户并发送验证邮件
2. **Given** 用户有有效账户, **When** 输入正确凭据, **Then** 系统返回 JWT 令牌

## Requirements
### Functional Requirements
- **FR-001**: 系统必须允许用户使用邮箱和密码注册账户
- **FR-002**: 系统必须验证邮箱格式的有效性
- **FR-003**: 系统必须发送邮箱验证邮件
- **FR-004**: 系统必须支持用户登录并返回 JWT 令牌
```

### 阶段 3: 实现计划生成

#### 3.1 在 Cursor 中使用 /plan 命令

```
/plan Python 3.11, FastAPI, PostgreSQL, JWT, 邮箱服务集成
```

**Cursor 内部执行流程**:

1. **命令解析**: Cursor 识别 `/plan` 命令
2. **脚本调用**: 执行 `.specify/scripts/bash/setup-plan.sh --json`
3. **模板加载**: 从 `.specify/templates/plan-template.md` 创建计划文件
4. **AI 处理**: 基于规范和技术要求生成实现计划

#### 3.2 脚本协同工作

**`.specify/scripts/bash/setup-plan.sh` 执行过程**:

```bash
# 1. 获取功能路径
eval $(get_feature_paths)

# 2. 创建计划文件
cp ".specify/templates/plan-template.md" "$IMPL_PLAN"

# 3. 返回 JSON 输出
printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s"}\n' "$FEATURE_SPEC" "$IMPL_PLAN"
```

#### 3.3 AI 代理生成实现计划

**生成的 `plan.md` 内容示例**:
```markdown
# Implementation Plan: 用户认证系统

## Technical Context
**Language/Version**: Python 3.11
**Primary Dependencies**: FastAPI, SQLAlchemy, Pydantic
**Storage**: PostgreSQL
**Testing**: pytest, httpx

## Phase 0: Outline & Research
1. **Research JWT implementation in FastAPI**
2. **Research email service integration patterns**

## Phase 1: Design & Contracts
1. **Generate data-model.md**: User, AuthToken, PasswordReset entities
2. **Generate API contracts**: POST /auth/register, POST /auth/login
3. **Generate quickstart.md**: Manual testing scenarios
```

#### 3.4 生成设计文档

**AI 代理自动生成以下文档**:

1. **`research.md`**:
```markdown
# Research: 用户认证系统

## JWT Implementation
**Decision**: 使用 PyJWT 库实现 JWT 令牌
**Rationale**: 轻量级、标准兼容、易于集成

## Email Service Integration
**Decision**: 使用 SendGrid API 发送邮件
**Rationale**: 可靠、易于集成、支持模板
```

2. **`data-model.md`**:
```markdown
# Data Model: 用户认证系统

## User Entity
- id: UUID (Primary Key)
- email: String (Unique, Not Null)
- password_hash: String (Not Null)
- is_verified: Boolean (Default: False)

## AuthToken Entity
- id: UUID (Primary Key)
- user_id: UUID (Foreign Key)
- token: String (Not Null)
- expires_at: DateTime
```

3. **`quickstart.md`**:
```markdown
# Quickstart: 用户认证系统

## 手动测试步骤
1. **启动服务**: `python -m uvicorn main:app --reload`
2. **测试注册**: `curl -X POST http://localhost:8000/auth/register`
3. **测试登录**: `curl -X POST http://localhost:8000/auth/login`
```

#### 3.5 更新 Cursor 代理上下文

**`.specify/scripts/bash/update-agent-context.sh` 执行过程**:

```bash
# 1. 解析计划文件中的技术信息
NEW_LANG="Python 3.11"
NEW_FRAMEWORK="FastAPI"
NEW_DB="PostgreSQL"

# 2. 更新 Cursor 代理文件
update_agent_file "$CURSOR_FILE" "Cursor"
```

**更新的 `.cursor/commands/` 内容**:
```markdown
# user-auth-system Development Guidelines

## Active Technologies
- Python 3.11 + FastAPI
- PostgreSQL

## Commands
cd backend && python -m uvicorn main:app --reload
cd backend && pytest
```

### 阶段 4: 任务生成

#### 4.1 在 Cursor 中使用 /tasks 命令

```
/tasks
```

**Cursor 内部执行流程**:

1. **命令解析**: Cursor 识别 `/tasks` 命令
2. **脚本调用**: 执行 `.specify/scripts/bash/check-prerequisites.sh --json`
3. **文档分析**: 分析所有设计文档
4. **任务生成**: 基于模板生成具体任务

#### 4.2 脚本协同工作

**`.specify/scripts/bash/check-prerequisites.sh` 执行过程**:

```bash
# 1. 检查功能目录和计划文件
if [[ ! -d "$FEATURE_DIR" ]] || [[ ! -f "$IMPL_PLAN" ]]; then
  echo "ERROR: Missing required files"
  exit 1
fi

# 2. 检查可选文档
docs=()
[[ -f "$RESEARCH" ]] && docs+=("research.md")
[[ -f "$DATA_MODEL" ]] && docs+=("data-model.md")
[[ -d "$CONTRACTS_DIR" ]] && docs+=("contracts/")
[[ -f "$QUICKSTART" ]] && docs+=("quickstart.md")

# 3. 返回 JSON 输出
printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":%s}\n' "$FEATURE_DIR" "$json_docs"
```

#### 4.3 AI 代理生成任务列表

**生成的 `tasks.md` 内容示例**:
```markdown
# Tasks: 用户认证系统

## Phase 3.1: Setup
- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize Python 3.11 project with FastAPI dependencies

## Phase 3.2: Tests First (TDD)
- [ ] T004 [P] Contract test POST /auth/register
- [ ] T005 [P] Contract test POST /auth/login
- [ ] T006 [P] Integration test user registration

## Phase 3.3: Core Implementation
- [ ] T010 [P] User model in src/models/user.py
- [ ] T011 [P] AuthToken model in src/models/auth_token.py
- [ ] T012 [P] UserService CRUD in src/services/user_service.py
- [ ] T016 POST /auth/register endpoint in src/api/auth_routes.py
- [ ] T017 POST /auth/login endpoint in src/api/auth_routes.py

## Dependencies
- Tests (T004-T006) before implementation (T010-T017)
- T010-T011 blocks T012
- T012 blocks T016-T017
```

### 阶段 5: 任务执行

#### 5.1 在 Cursor 中执行任务

现在我们可以开始执行任务。在 Cursor 中，使用简单的命令：

```
实现 tasks
```

Cursor 会自动：
1. **并行执行测试任务** (T004-T006)
2. **顺序执行实现任务** (T010-T017)
3. **按照依赖关系执行** 确保正确的执行顺序

#### 5.2 脚本和文档的持续协同

在执行任务过程中，各种脚本和文档继续协同工作：

1. **`check-prerequisites.sh --paths-only`**: 提供当前功能的路径信息
2. **`update-agent-context.sh`**: 在技术栈变更时更新代理上下文
3. **模板系统**: 为新的文档和代码提供结构
4. **宪法检查**: 确保实现符合项目原则

### 阶段 6: 验证和完成

#### 6.1 运行测试

```bash
# 在 Cursor 终端中执行
cd backend
pytest tests/ -v
```

#### 6.2 执行快速开始

```bash
# 启动服务
python -m uvicorn main:app --reload

# 在另一个终端测试 API
curl -X POST http://localhost:8000/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com", "password": "password123"}'
```

#### 6.3 更新进度跟踪

在 `plan.md` 中更新进度：

```markdown
## Progress Tracking

**Phase Status**:
- [x] Phase 0: Research complete (/plan command)
- [x] Phase 1: Design complete (/plan command)
- [x] Phase 2: Task planning complete (/plan command - describe approach only)
- [x] Phase 3: Tasks generated (/tasks command)
- [x] Phase 4: Implementation complete
- [x] Phase 5: Validation passed

**Gate Status**:
- [x] Initial Constitution Check: PASS
- [x] Post-Design Constitution Check: PASS
- [x] All NEEDS CLARIFICATION resolved
- [x] Complexity deviations documented
```

## 协同工作机制总结

### 1. 脚本系统协同

| 脚本 | 调用时机 | 主要功能 | 输出 |
|------|---------|---------|------|
| `.specify/scripts/bash/create-new-feature.sh` | `/specify` 命令 | 创建功能分支和目录 | 分支名、规范文件路径 |
| `.specify/scripts/bash/setup-plan.sh` | `/plan` 命令 | 创建实现计划文件 | 计划文件路径 |
| `.specify/scripts/bash/check-prerequisites.sh` | `/tasks` 命令 | 检查前置条件 | 可用文档列表 |
| `.specify/scripts/bash/check-prerequisites.sh --paths-only` | 需要路径信息时 | 提供功能路径 | 所有相关路径 |
| `.specify/scripts/bash/update-agent-context.sh` | 技术栈变更时 | 更新代理上下文 | 更新的代理文件 |

### 2. 模板系统协同

| 模板 | 使用时机 | 主要功能 | 生成内容 |
|------|---------|---------|---------|
| `.specify/templates/spec-template.md` | 创建规范时 | 提供规范结构 | `spec.md` |
| `.specify/templates/plan-template.md` | 创建计划时 | 提供计划结构 | `plan.md` |
| `.specify/templates/tasks-template.md` | 生成任务时 | 提供任务结构 | `tasks.md` |
| `.specify/templates/agent-file-template.md` | 更新代理时 | 提供代理结构 | `CLAUDE.md`, `GEMINI.md` 等 |
| `.specify/templates/commands/*.md` | 执行命令时 | 提供命令指导 | 命令执行流程 |

### 3. 文档系统协同

| 文档 | 创建时机 | 主要功能 | 依赖关系 |
|------|---------|---------|---------|
| `spec.md` | `/specify` 命令 | 功能规范定义 | 无 |
| `plan.md` | `/plan` 命令 | 实现计划 | 依赖 `spec.md` |
| `research.md` | `/plan` 命令 | 技术研究 | 依赖 `plan.md` |
| `data-model.md` | `/plan` 命令 | 数据模型 | 依赖 `plan.md` |
| `contracts/` | `/plan` 命令 | API 合约 | 依赖 `plan.md` |
| `quickstart.md` | `/plan` 命令 | 快速开始 | 依赖 `plan.md` |
| `tasks.md` | `/tasks` 命令 | 任务列表 | 依赖所有设计文档 |

### 4. Cursor 代理系统协同

| 代理文件 | 更新时机 | 主要功能 | 内容来源 |
|----------|---------|---------|---------|
| `.cursor/commands/` | 技术栈变更时 | Cursor 上下文 | `plan.md` 技术信息 |
| `.cursor/rules/` | 技术栈变更时 | Cursor 规则 | `plan.md` 技术信息 |

通过这个完整的实战流程，我们可以看到 spec-kit 项目中的各个组件是如何协同工作的，形成了一个完整的 spec-driven 开发生态系统。每个脚本、模板和文档都有其特定的作用，它们相互配合，确保开发流程的标准化和自动化。
