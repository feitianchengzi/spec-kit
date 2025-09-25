# 实际项目开发流程指南 - Cursor 实战

## 概述

本指南以 Cursor 编辑器为环境，通过一个完整的项目开发实例，详细说明 spec-kit 项目中各个脚本和 MD 文档是如何协同工作的。我们将从项目初始化开始，逐步展示整个 spec-driven 开发流程。

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
│   │   └── constitution_update_checklist.md
│   ├── scripts/
│   │   └── bash/
│   │       ├── common.sh
│   │       ├── create-new-feature.sh
│   │       ├── setup-plan.sh
│   │       ├── check-task-prerequisites.sh
│   │       ├── get-feature-paths.sh
│   │       └── update-agent-context.sh
│   └── templates/
│       ├── spec-template.md
│       ├── plan-template.md
│       ├── tasks-template.md
│       └── agent-file-template.md
└── .cursor/
    └── commands/
        ├── specify.md
        ├── plan.md
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
#!/usr/bin/env bash
# 1. 解析参数
FEATURE_DESCRIPTION="用户认证系统，包含用户注册、登录、密码重置功能，支持邮箱验证和 JWT 令牌"

# 2. 获取仓库根目录
REPO_ROOT=$(git rev-parse --show-toplevel)

# 3. 生成分支名称
BRANCH_NAME="001-user-authentication"

# 4. 创建分支
git checkout -b "$BRANCH_NAME"

# 5. 创建目录结构
FEATURE_DIR="$REPO_ROOT/specs/$BRANCH_NAME"
mkdir -p "$FEATURE_DIR"

# 6. 复制模板
TEMPLATE="$REPO_ROOT/.specify/templates/spec-template.md"
SPEC_FILE="$FEATURE_DIR/spec.md"
cp "$TEMPLATE" "$SPEC_FILE"
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

**Feature Branch**: `001-user-authentication`
**Created**: 2024-01-15
**Status**: Draft
**Input**: User description: "用户认证系统，包含用户注册、登录、密码重置功能，支持邮箱验证和 JWT 令牌"

## User Scenarios & Testing

### Primary User Story
用户需要能够注册新账户、登录系统、重置密码，并接收邮箱验证。

### Acceptance Scenarios
1. **Given** 用户访问注册页面, **When** 输入有效邮箱和密码, **Then** 系统创建账户并发送验证邮件
2. **Given** 用户有有效账户, **When** 输入正确凭据, **Then** 系统返回 JWT 令牌
3. **Given** 用户忘记密码, **When** 请求密码重置, **Then** 系统发送重置链接到邮箱

### Edge Cases
- 重复邮箱注册的处理
- 无效邮箱格式的验证
- JWT 令牌过期处理
- 网络错误时的重试机制

## Requirements

### Functional Requirements
- **FR-001**: 系统必须允许用户使用邮箱和密码注册账户
- **FR-002**: 系统必须验证邮箱格式的有效性
- **FR-003**: 系统必须发送邮箱验证邮件
- **FR-004**: 系统必须支持用户登录并返回 JWT 令牌
- **FR-005**: 系统必须支持密码重置功能
- **FR-006**: 系统必须验证 JWT 令牌的有效性
- **FR-007**: 系统必须记录所有认证相关事件

### Key Entities
- **User**: 用户实体，包含邮箱、密码哈希、验证状态
- **AuthToken**: 认证令牌，包含用户ID、过期时间、类型
- **PasswordReset**: 密码重置请求，包含用户ID、令牌、过期时间
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
#!/usr/bin/env bash
# 1. 获取功能路径
eval $(get_feature_paths)
# FEATURE_DIR='/path/to/specs/001-user-authentication'
# IMPL_PLAN='/path/to/specs/001-user-authentication/plan.md'

# 2. 创建计划文件
TEMPLATE="$REPO_ROOT/.specify/templates/plan-template.md"
cp "$TEMPLATE" "$IMPL_PLAN"

# 3. 返回 JSON 输出
printf '{"FEATURE_SPEC":"%s","IMPL_PLAN":"%s","SPECS_DIR":"%s","BRANCH":"%s"}\n' \
  "$FEATURE_SPEC" "$IMPL_PLAN" "$FEATURE_DIR" "$CURRENT_BRANCH"
```

#### 3.3 AI 代理生成实现计划

**生成的 `plan.md` 内容示例**:
```markdown
# Implementation Plan: 用户认证系统

**Branch**: `001-user-authentication` | **Date**: 2024-01-15 | **Spec**: [link]
**Input**: Feature specification from `/specs/001-user-authentication/spec.md`

## Technical Context
**Language/Version**: Python 3.11
**Primary Dependencies**: FastAPI, SQLAlchemy, Pydantic
**Storage**: PostgreSQL
**Testing**: pytest, httpx
**Target Platform**: Linux server
**Project Type**: web
**Performance Goals**: 1000 req/s
**Constraints**: <200ms p95, <100MB memory
**Scale/Scope**: 10k users

## Constitution Check
**Simplicity**:
- Projects: 2 (api, tests)
- Using framework directly? Yes (FastAPI directly)
- Single data model? Yes (User model)
- Avoiding patterns? Yes (no Repository pattern)

**Architecture**:
- EVERY feature as library? Yes
- Libraries listed: auth-lib (authentication logic), api-lib (FastAPI routes)
- CLI per library: auth-lib --help, api-lib --help
- Library docs: llms.txt format planned

**Testing (NON-NEGOTIABLE)**:
- RED-GREEN-Refactor cycle enforced? Yes
- Order: Contract→Integration→E2E→Unit strictly followed? Yes
- Real dependencies used? Yes (PostgreSQL, SMTP)
- Integration tests for: new libraries, contract changes, shared schemas? Yes

## Phase 0: Outline & Research
1. **Research JWT implementation in FastAPI**
2. **Research email service integration patterns**
3. **Research password hashing best practices**
4. **Research PostgreSQL user management patterns**

## Phase 1: Design & Contracts
1. **Generate data-model.md**: User, AuthToken, PasswordReset entities
2. **Generate API contracts**: POST /auth/register, POST /auth/login, POST /auth/reset-password
3. **Generate contract tests**: One test file per endpoint
4. **Generate quickstart.md**: Manual testing scenarios
5. **Update agent context files**: Add Python/FastAPI context
```

#### 3.4 生成设计文档

**AI 代理自动生成以下文档**:

1. **`research.md`**:
```markdown
# Research: 用户认证系统

## JWT Implementation
**Decision**: 使用 PyJWT 库实现 JWT 令牌
**Rationale**: 轻量级、标准兼容、易于集成
**Alternatives considered**: Authlib (过于复杂), python-jose (维护较少)

## Email Service Integration
**Decision**: 使用 SendGrid API 发送邮件
**Rationale**: 可靠、易于集成、支持模板
**Alternatives considered**: SMTP (配置复杂), AWS SES (成本较高)

## Password Hashing
**Decision**: 使用 bcrypt 进行密码哈希
**Rationale**: 安全、慢速、抗彩虹表攻击
**Alternatives considered**: scrypt (配置复杂), Argon2 (依赖较多)
```

2. **`data-model.md`**:
```markdown
# Data Model: 用户认证系统

## User Entity
- id: UUID (Primary Key)
- email: String (Unique, Not Null)
- password_hash: String (Not Null)
- is_verified: Boolean (Default: False)
- created_at: DateTime
- updated_at: DateTime

## AuthToken Entity
- id: UUID (Primary Key)
- user_id: UUID (Foreign Key)
- token: String (Not Null)
- token_type: String (JWT/REFRESH)
- expires_at: DateTime
- created_at: DateTime

## PasswordReset Entity
- id: UUID (Primary Key)
- user_id: UUID (Foreign Key)
- reset_token: String (Not Null)
- expires_at: DateTime
- used: Boolean (Default: False)
- created_at: DateTime
```

3. **`contracts/` 目录**:
```
contracts/
├── auth_register.yaml
├── auth_login.yaml
└── auth_reset_password.yaml
```

4. **`quickstart.md`**:
```markdown
# Quickstart: 用户认证系统

## 手动测试步骤

1. **启动服务**
   ```bash
   cd backend
   python -m uvicorn main:app --reload
   ```

2. **测试用户注册**
   ```bash
   curl -X POST http://localhost:8000/auth/register \
     -H "Content-Type: application/json" \
     -d '{"email": "test@example.com", "password": "password123"}'
   ```

3. **测试用户登录**
   ```bash
   curl -X POST http://localhost:8000/auth/login \
     -H "Content-Type: application/json" \
     -d '{"email": "test@example.com", "password": "password123"}'
   ```
```

#### 3.5 更新代理上下文

**`.specify/scripts/bash/update-agent-context.sh` 执行过程**:

```bash
#!/usr/bin/env bash
# 1. 解析计划文件中的技术信息
NEW_LANG="Python 3.11"
NEW_FRAMEWORK="FastAPI"
NEW_DB="PostgreSQL"

# 2. 更新 CLAUDE.md
update_agent_file "$CLAUDE_FILE" "Claude Code"

# 3. 更新 GEMINI.md
update_agent_file "$GEMINI_FILE" "Gemini CLI"

# 4. 更新 .github/copilot-instructions.md
update_agent_file "$COPILOT_FILE" "GitHub Copilot"
```

**更新的 `CLAUDE.md` 内容**:
```markdown
# user-auth-system Development Guidelines

Auto-generated from all feature plans. Last updated: 2024-01-15

## Active Technologies
- Python 3.11 + FastAPI (001-user-authentication)
- PostgreSQL (001-user-authentication)

## Project Structure
```
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/
```

## Commands
cd backend && python -m uvicorn main:app --reload
cd backend && pytest
cd frontend && npm run dev

## Code Style
Python: Follow PEP 8, use type hints, async/await for I/O
```

### 阶段 4: 任务生成

#### 4.1 在 Cursor 中使用 /tasks 命令

```
/tasks
```

**Cursor 内部执行流程**:

1. **命令解析**: Cursor 识别 `/tasks` 命令
2. **脚本调用**: 执行 `.specify/scripts/bash/check-task-prerequisites.sh --json`
3. **文档分析**: 分析所有设计文档
4. **任务生成**: 基于模板生成具体任务

#### 4.2 脚本协同工作

**`.specify/scripts/bash/check-task-prerequisites.sh` 执行过程**:

```bash
#!/usr/bin/env bash
# 1. 检查功能目录
if [[ ! -d "$FEATURE_DIR" ]]; then
  echo "ERROR: Feature directory not found: $FEATURE_DIR"
  exit 1
fi

# 2. 检查计划文件
if [[ ! -f "$IMPL_PLAN" ]]; then
  echo "ERROR: plan.md not found in $FEATURE_DIR"
  exit 1
fi

# 3. 检查可选文档
docs=()
[[ -f "$RESEARCH" ]] && docs+=("research.md")
[[ -f "$DATA_MODEL" ]] && docs+=("data-model.md")
[[ -d "$CONTRACTS_DIR" ]] && docs+=("contracts/")
[[ -f "$QUICKSTART" ]] && docs+=("quickstart.md")

# 4. 返回 JSON 输出
printf '{"FEATURE_DIR":"%s","AVAILABLE_DOCS":%s}\n' "$FEATURE_DIR" "$json_docs"
```

#### 4.3 AI 代理生成任务列表

**生成的 `tasks.md` 内容示例**:
```markdown
# Tasks: 用户认证系统

**Input**: Design documents from `/specs/001-user-authentication/`
**Prerequisites**: plan.md (required), research.md, data-model.md, contracts/

## Phase 3.1: Setup
- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize Python 3.11 project with FastAPI dependencies
- [ ] T003 [P] Configure linting and formatting tools (ruff, black)

## Phase 3.2: Tests First (TDD) ⚠️ MUST COMPLETE BEFORE 3.3
**CRITICAL: These tests MUST be written and MUST FAIL before ANY implementation**
- [ ] T004 [P] Contract test POST /auth/register in tests/contract/test_auth_register.py
- [ ] T005 [P] Contract test POST /auth/login in tests/contract/test_auth_login.py
- [ ] T006 [P] Contract test POST /auth/reset-password in tests/contract/test_auth_reset.py
- [ ] T007 [P] Integration test user registration in tests/integration/test_registration.py
- [ ] T008 [P] Integration test user login in tests/integration/test_login.py
- [ ] T009 [P] Integration test password reset in tests/integration/test_password_reset.py

## Phase 3.3: Core Implementation (ONLY after tests are failing)
- [ ] T010 [P] User model in src/models/user.py
- [ ] T011 [P] AuthToken model in src/models/auth_token.py
- [ ] T012 [P] PasswordReset model in src/models/password_reset.py
- [ ] T013 [P] UserService CRUD in src/services/user_service.py
- [ ] T014 [P] AuthService JWT logic in src/services/auth_service.py
- [ ] T015 [P] EmailService integration in src/services/email_service.py
- [ ] T016 POST /auth/register endpoint in src/api/auth_routes.py
- [ ] T017 POST /auth/login endpoint in src/api/auth_routes.py
- [ ] T018 POST /auth/reset-password endpoint in src/api/auth_routes.py
- [ ] T019 Input validation and error handling
- [ ] T020 JWT middleware and token validation

## Phase 3.4: Integration
- [ ] T021 Connect UserService to PostgreSQL
- [ ] T022 Configure email service (SendGrid)
- [ ] T023 Request/response logging
- [ ] T024 CORS and security headers
- [ ] T025 Database migrations

## Phase 3.5: Polish
- [ ] T026 [P] Unit tests for validation in tests/unit/test_validation.py
- [ ] T027 [P] Unit tests for services in tests/unit/test_services.py
- [ ] T028 Performance tests (<200ms p95)
- [ ] T029 [P] Update docs/api.md
- [ ] T030 Remove duplication and refactor
- [ ] T031 Run manual-testing.md scenarios

## Dependencies
- Tests (T004-T009) before implementation (T010-T020)
- T010-T012 blocks T013-T015
- T013-T015 blocks T016-T018
- T021 blocks T022
- Implementation before polish (T026-T031)

## Parallel Example
```
# Launch T004-T009 together:
Task: "Contract test POST /auth/register in tests/contract/test_auth_register.py"
Task: "Contract test POST /auth/login in tests/contract/test_auth_login.py"
Task: "Contract test POST /auth/reset-password in tests/contract/test_auth_reset.py"
Task: "Integration test registration in tests/integration/test_registration.py"
Task: "Integration test login in tests/integration/test_login.py"
Task: "Integration test password reset in tests/integration/test_password_reset.py"
```
```

### 阶段 5: 任务执行

#### 5.1 在 Cursor 中执行任务

现在我们可以开始执行任务。在 Cursor 中，我们可以：

1. **并行执行测试任务** (T004-T009):
   ```
   Task: "Contract test POST /auth/register in tests/contract/test_auth_register.py"
   Task: "Contract test POST /auth/login in tests/contract/test_auth_login.py"
   Task: "Contract test POST /auth/reset-password in tests/contract/test_auth_reset.py"
   Task: "Integration test registration in tests/integration/test_registration.py"
   Task: "Integration test login in tests/integration/test_login.py"
   Task: "Integration test password reset in tests/integration/test_password_reset.py"
   ```

2. **顺序执行实现任务** (T010-T020):
   - 先创建模型 (T010-T012)
   - 再创建服务 (T013-T015)
   - 最后创建 API 端点 (T016-T018)

#### 5.2 脚本和文档的持续协同

在执行任务过程中，各种脚本和文档继续协同工作：

1. **`get-feature-paths.sh`**: 提供当前功能的路径信息
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
| `.specify/scripts/bash/check-task-prerequisites.sh` | `/tasks` 命令 | 检查前置条件 | 可用文档列表 |
| `.specify/scripts/bash/get-feature-paths.sh` | 需要路径信息时 | 提供功能路径 | 所有相关路径 |
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

### 4. AI 代理系统协同

| 代理文件 | 更新时机 | 主要功能 | 内容来源 |
|----------|---------|---------|---------|
| `CLAUDE.md` | 技术栈变更时 | Claude Code 上下文 | `plan.md` 技术信息 |
| `GEMINI.md` | 技术栈变更时 | Gemini CLI 上下文 | `plan.md` 技术信息 |
| `.github/copilot-instructions.md` | 技术栈变更时 | GitHub Copilot 上下文 | `plan.md` 技术信息 |

## 最佳实践

### 1. 命令执行顺序

1. **`/specify`**: 创建功能规范
2. **`/plan`**: 生成实现计划
3. **`/tasks`**: 生成任务列表
4. **执行任务**: 按顺序执行具体任务

### 2. 文档维护

1. **及时更新**: 在技术栈变更时及时更新代理上下文
2. **版本同步**: 保持所有文档的版本信息同步
3. **质量检查**: 定期检查文档的完整性和一致性

### 3. 脚本使用

1. **路径管理**: 使用 `.specify/scripts/bash/get-feature-paths.sh` 获取正确的路径
2. **前置检查**: 在执行任务前使用 `.specify/scripts/bash/check-task-prerequisites.sh` 检查
3. **上下文更新**: 在技术变更时使用 `.specify/scripts/bash/update-agent-context.sh` 更新

### 4. 模板自定义

1. **项目特定**: 根据项目需求自定义模板
2. **版本控制**: 为模板添加版本信息
3. **测试验证**: 修改模板后测试生成效果

## 故障排除

### 常见问题

1. **脚本执行失败**:
   - 检查当前分支是否为功能分支
   - 验证必需文件是否存在
   - 确认脚本权限是否正确

2. **文档生成不完整**:
   - 检查模板是否完整
   - 验证输入数据是否正确
   - 确认 AI 代理是否有足够上下文

3. **任务执行失败**:
   - 检查前置条件是否满足
   - 验证依赖关系是否正确
   - 确认文件路径是否存在

### 调试技巧

1. **使用 JSON 输出**: 脚本支持 `--json` 参数，便于程序化处理
2. **检查中间文件**: 查看生成过程中的中间文件
3. **验证路径**: 使用 `.specify/scripts/bash/get-feature-paths.sh` 确认路径正确性
4. **查看日志**: 检查 Cursor 的 AI 代理日志

通过这个完整的实战流程，我们可以看到 spec-kit 项目中的各个组件是如何协同工作的，形成了一个完整的 spec-driven 开发生态系统。每个脚本、模板和文档都有其特定的作用，它们相互配合，确保开发流程的标准化和自动化。
