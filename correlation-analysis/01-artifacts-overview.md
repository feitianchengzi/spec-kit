# 各阶段产物文件清单

本文档列出 Specify → Plan → Tasks 工作流中每个阶段产生的所有文件及其用途。

## 📁 目录结构总览

```
项目根目录/
├── specs/
│   └── ###-feature-name/         # 功能特性目录
│       ├── spec.md               # [Specify] 功能规格说明书
│       ├── checklists/           # [Specify] 检查清单目录
│       │   └── requirements.md   # 规格质量检查清单
│       ├── plan.md               # [Plan] 实施计划
│       ├── research.md           # [Plan Phase 0] 技术研究
│       ├── data-model.md         # [Plan Phase 1] 数据模型
│       ├── quickstart.md         # [Plan Phase 1] 快速开始指南
│       ├── contracts/            # [Plan Phase 1] API 契约目录
│       │   ├── auth.yaml         # OpenAPI/GraphQL 规范文件
│       │   └── ...
│       └── tasks.md              # [Tasks] 可执行任务清单
├── .claude/
│   └── rules/
│       └── specify-rules.md      # [Plan Phase 1] Claude Agent 上下文
├── .cursor/
│   └── commands/
│       └── specify-rules.md      # [Plan Phase 1] Cursor Agent 上下文
└── .github/
    └── prompts/
        └── specify-rules.md      # [Plan Phase 1] Copilot Agent 上下文
```

---

## 🎯 阶段 1: Specify 命令

**目标**：将自然语言需求转化为结构化的功能规格说明

**输入**：用户的自然语言描述

**输出文件**：

### 1.1 spec.md

**路径**：`specs/###-feature-name/spec.md`

**模板**：`templates/spec-template.md`

**用途**：
- 定义功能的业务需求和用户价值
- 描述用户故事和验收场景
- 列出功能需求和成功标准
- 识别关键实体（概念层面）

**核心内容**：
- ✅ 用户故事（按优先级 P1, P2, P3 排序）
- ✅ 功能需求（FR-001, FR-002...）
- ✅ 成功标准（SC-001, SC-002...）
- ✅ 关键实体（Key Entities）
- ✅ 边界情况（Edge Cases）
- ✅ 验收场景（Given-When-Then）

**特点**：
- 技术无关：不包含实现细节
- 面向业务：可供非技术人员阅读
- 可测试：所有需求都是可验证的

### 1.2 checklists/requirements.md

**路径**：`specs/###-feature-name/checklists/requirements.md`

**模板**：参考 `templates/checklist-template.md`

**用途**：
- 验证规格说明书的质量
- 确保规格符合 Spec-Driven Development 标准
- 在进入 Plan 阶段前检查完整性

**核心内容**：
- ✅ 内容质量检查（无实现细节、聚焦用户价值）
- ✅ 需求完整性检查（无未解决的 NEEDS CLARIFICATION、需求可测试）
- ✅ 功能就绪性检查（用户场景覆盖、验收标准明确）

### 1.3 Git 分支

**命名格式**：`###-feature-name`

**示例**：`001-user-auth`, `002-payment-integration`

**用途**：
- 隔离功能开发
- 匹配 specs 目录结构
- 支持并行功能开发

---

## 🏗️ 阶段 2: Plan 命令

**目标**：基于规格说明生成技术设计和实施计划

**输入**：`spec.md`, `/memory/constitution.md`

**输出文件**：

### 2.1 plan.md

**路径**：`specs/###-feature-name/plan.md`

**模板**：`templates/plan-template.md`

**用途**：
- 定义技术上下文（语言、框架、依赖）
- 规划项目结构
- 执行 Constitution Check（复杂度门禁）
- 协调 Phase 0 和 Phase 1 的设计产物

**核心内容**：
- ✅ 技术上下文（Technical Context）
- ✅ 项目结构（Project Structure）
- ✅ Constitution Check 结果
- ✅ 复杂度追踪（如有违规）

### 2.2 research.md (Phase 0)

**路径**：`specs/###-feature-name/research.md`

**模板**：❌ 无专用模板（在 plan.md 命令中动态生成）

**用途**：
- 解决 spec.md 中的所有 [NEEDS CLARIFICATION] 标记
- 研究技术选型和最佳实践
- 记录技术决策和理由

**推断内容**：
- ✅ 研究决策（Decision, Rationale, Alternatives）
- ✅ 技术最佳实践
- ✅ 设计模式选择
- ✅ 工具和库评估

**示例场景**：
```
问题：spec.md 中标记 [NEEDS CLARIFICATION: auth method]
研究：评估 JWT vs Session vs OAuth2
决策：使用 JWT + OAuth2
理由：支持移动端、无状态、行业标准
```

### 2.3 data-model.md (Phase 1)

**路径**：`specs/###-feature-name/data-model.md`

**模板**：❌ 无专用模板（在 plan.md 命令中动态生成）

**用途**：
- 将 spec.md 的 Key Entities 转化为技术数据模型
- 定义字段、类型、约束、关系
- 映射验证规则到功能需求

**推断内容**：
- ✅ 数据实体（Entity name, Fields, Relationships）
- ✅ 字段定义（Name, Type, Required, Constraints）
- ✅ 验证规则（来自 Functional Requirements）
- ✅ 状态转换（如适用）
- ✅ 实体关联的用户故事和 API 端点

**示例**：
```markdown
## Entity: User

**Source**: Key Entity "User" from spec.md
**Related User Stories**: US1, US2

### Fields
| Field         | Type     | Required | Constraints         |
|---------------|----------|----------|---------------------|
| email         | String   | Yes      | Unique, email format|
| password_hash | String   | Yes      | bcrypt hash         |
```

### 2.4 contracts/ (Phase 1)

**路径**：`specs/###-feature-name/contracts/*.yaml`

**格式**：OpenAPI 3.0 或 GraphQL Schema

**用途**：
- 定义 API 端点和数据契约
- 从 spec.md 的用户动作（User Actions）生成
- 支持契约测试（Contract Testing）

**推断内容**：
- ✅ API 端点（Path, Method, Summary）
- ✅ 请求模式（Request Schema）
- ✅ 响应模式（Response Schema）
- ✅ 验证规则（Validation Rules）
- ✅ 错误响应定义
- ✅ 来源追溯（Source User Story, Source User Action）

**示例文件**：
- `auth.yaml` - 认证相关端点
- `users.yaml` - 用户管理端点
- `orders.yaml` - 订单管理端点

### 2.5 quickstart.md (Phase 1)

**路径**：`specs/###-feature-name/quickstart.md`

**模板**：❌ 无专用模板（在 plan.md 命令中动态生成）

**用途**：
- 从 spec.md 的验收场景生成测试场景
- 提供快速验证功能的步骤
- 支持端到端测试和演示

**推断内容**：
- ✅ 测试场景（来自 Acceptance Scenarios）
- ✅ 环境设置步骤
- ✅ 数据准备说明
- ✅ API 调用示例
- ✅ 预期结果验证

### 2.6 Agent 上下文文件 (Phase 1)

**路径**（根据 AI Agent 而定）：
- `.claude/rules/specify-rules.md`
- `.cursor/commands/specify-rules.md`
- `.github/prompts/specify-rules.md`
- 等等...

**模板**：`templates/agent-file-template.md`

**用途**：
- 更新 AI Agent 的项目上下文
- 记录技术栈和架构决策
- 在 Agent 辅助开发时提供背景信息

**更新方式**：
- 脚本：`scripts/bash/update-agent-context.sh` 或 PowerShell 版本
- 自动检测项目使用的 AI Agent
- 只添加新技术，保留手动添加的内容

---

## ✅ 阶段 3: Tasks 命令

**目标**：生成可执行的、依赖排序的任务清单

**输入**：`plan.md`, `spec.md`, `data-model.md`, `contracts/`, `research.md`, `quickstart.md`

**输出文件**：

### 3.1 tasks.md

**路径**：`specs/###-feature-name/tasks.md`

**模板**：`templates/tasks-template.md`

**用途**：
- 将设计文档转化为具体的实现任务
- 按用户故事组织任务（支持独立开发）
- 提供依赖关系和并行执行指导
- 支持 MVP 优先和增量交付策略

**核心内容**：
- ✅ Phase 1: Setup（项目初始化）
- ✅ Phase 2: Foundational（阻塞性前置任务）
- ✅ Phase 3+: 用户故事阶段（按 P1, P2, P3 顺序）
  - 每个阶段包含：
    - 故事目标
    - 独立测试标准
    - 测试任务（如请求）
    - 实现任务（Models → Services → Endpoints）
    - 检查点（Checkpoint）
- ✅ Final Phase: Polish（跨故事改进）
- ✅ 依赖关系图（Dependencies & Execution Order）
- ✅ 并行执行示例（Parallel Examples）
- ✅ 实施策略（Implementation Strategy）

**任务格式**：
```
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**示例**：
```markdown
- [ ] T012 [P] [US1] Create User model in src/models/user.py
- [ ] T014 [US1] Implement AuthService in src/services/auth_service.py
```

---

## 📊 文件间关系总结

```
spec.md
  ├─→ User Stories (P1, P2, P3...)
  │     ├─→ contracts/*.yaml: API Endpoints
  │     │     └─→ tasks.md: Endpoint implementation tasks
  │     ├─→ quickstart.md: Test Scenarios
  │     │     └─→ tasks.md: Test tasks (if requested)
  │     └─→ tasks.md: Phase organization
  │
  ├─→ Key Entities
  │     └─→ data-model.md: Data Entities
  │           └─→ tasks.md: Model implementation tasks
  │
  ├─→ Functional Requirements
  │     ├─→ data-model.md: Validation Rules
  │     └─→ contracts/*.yaml: API Validation
  │
  └─→ [NEEDS CLARIFICATION]
        └─→ research.md: Research Decisions
              └─→ plan.md: Technical Context
                    └─→ tasks.md: Setup tasks

checklists/requirements.md
  └─→ 验证 spec.md 质量
        └─→ 阻止不完整的规格进入 Plan 阶段

plan.md
  └─→ 协调所有设计产物
        ├─→ Technical Context → research.md
        ├─→ Project Structure → tasks.md
        └─→ Constitution Check → 复杂度门禁
```

---

## 🔍 查找产物的快速指南

**我想了解...**

| 需求 | 查看文件 | 关键信息 |
|------|---------|----------|
| 功能的业务价值 | `spec.md` | User Scenarios & Testing |
| 用户故事和优先级 | `spec.md` | User Story 1 (P1), User Story 2 (P2)... |
| 功能需求列表 | `spec.md` | Functional Requirements (FR-001...) |
| 规格是否完整 | `checklists/requirements.md` | 检查清单状态 |
| 技术选型决策 | `research.md` | Decision, Rationale, Alternatives |
| 技术栈和依赖 | `plan.md` | Technical Context |
| 数据库设计 | `data-model.md` | Entities, Fields, Relationships |
| API 接口定义 | `contracts/*.yaml` | Endpoints, Request/Response Schemas |
| 如何测试功能 | `quickstart.md` | Test Scenarios, API calls |
| 具体实现任务 | `tasks.md` | Phases, Tasks with file paths |
| 用户故事的任务 | `tasks.md` | 搜索 `[US1]`, `[US2]` 标签 |
| 可并行的任务 | `tasks.md` | 搜索 `[P]` 标签 |
| MVP 范围 | `tasks.md` | Phase 3 (通常是 P1 用户故事) |

---

## 🎯 最佳实践

### 产物完整性

- ✅ **Specify 阶段后**：必须有 `spec.md` 和 `checklists/requirements.md`
- ✅ **Plan 阶段后**：必须有 `plan.md`, `research.md`, `data-model.md`
- ✅ **Tasks 阶段后**：必须有 `tasks.md`

### 版本控制

- ✅ 所有产物都应纳入版本控制
- ✅ 设计文档随代码实现更新
- ✅ 使用 Git 分支匹配 spec 目录

### 可追溯性

- ✅ 每个任务应引用具体的用户故事（`[US1]` 标签）
- ✅ 每个 API 端点应引用来源用户故事和用户动作
- ✅ 每个数据实体应列出关联的用户故事和端点

---

**下一步**：查看 [02-entity-structures.md](./02-entity-structures.md) 了解每个文件的详细内部结构。

