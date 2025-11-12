# 完整演进路线图

本文档提供 Specify → Plan → Tasks 工作流的宏观视图，展示从用户需求到可执行任务的完整演进过程。

---

## 🗺️ 三阶段演进总览

```
┌──────────────────────────────────────────────────────────────────────────────┐
│                                                                              │
│                    SPECIFY → PLAN → TASKS 演进路线图                          │
│                                                                              │
│  用户自然语言描述 → 结构化规格 → 技术设计 → 可执行任务                         │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘

                              │
                              │ INPUT: 用户需求描述
                              ↓

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                      阶段 1: SPECIFY 命令（需求分析）                        ┃
┃                                                                             ┃
┃  目标: 将自然语言需求转化为结构化的功能规格说明                              ┃
┃  特点: 技术无关、面向业务、可测试                                           ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

                              │
                 ┌────────────┼────────────┐
                 ↓            ↓            ↓
         ┌──────────┐  ┌──────────┐  ┌──────────┐
         │ spec.md  │  │ checklist│  │Git Branch│
         │          │  │          │  │          │
         │用户故事  │  │质量检查  │  │###-name  │
         │功能需求  │  │          │  │          │
         │成功标准  │  │          │  │          │
         │关键实体  │  │          │  │          │
         └──────────┘  └──────────┘  └──────────┘

         USER STORIES 🎯
         ├─ US1 (P1) - MVP 核心
         ├─ US2 (P2) - 第二优先
         └─ US3 (P3) - 第三优先
         
         每个故事包含:
         ✓ 优先级 (P1 > P2 > P3)
         ✓ 独立测试标准
         ✓ 验收场景 (Given-When-Then)
         ✓ 用户动作列表

                              │
                              │ OUTPUT: spec.md, checklists/requirements.md
                              ↓

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                       阶段 2: PLAN 命令（技术设计）                          ┃
┃                                                                             ┃
┃  目标: 基于规格说明生成技术设计和实施计划                                   ┃
┃  特点: 技术选型、架构设计、API 契约                                         ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

                              │
                              ↓
                    ┌──────────────────┐
                    │   PHASE 0: 研究   │
                    │  research.md     │
                    │                  │
                    │ 解决 NEEDS       │
                    │ CLARIFICATION    │
                    │                  │
                    │ 技术决策 ⭐      │
                    │ 最佳实践         │
                    │ 替代方案评估     │
                    └──────────────────┘
                              │
                              ↓
                    ┌──────────────────┐
                    │  PHASE 1: 设计    │
                    └──────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ↓                    ↓                    ↓
  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
  │data-model.md │    │ contracts/   │    │quickstart.md │
  │              │    │              │    │              │
  │数据实体      │    │API 端点      │    │测试场景      │
  │字段类型      │    │请求/响应     │    │API 调用      │
  │验证规则      │    │验证规则      │    │验证步骤      │
  │关系映射      │    │错误处理      │    │              │
  └──────────────┘    └──────────────┘    └──────────────┘
         │                    │                    │
         └────────────────────┼────────────────────┘
                              │
                              ↓
                    ┌──────────────────┐
                    │    plan.md       │
                    │                  │
                    │ 技术上下文 ⭐    │
                    │ 项目结构         │
                    │ Constitution门禁 │
                    └──────────────────┘
                              │
                              ↓
                    ┌──────────────────┐
                    │ 更新 AI Agent    │
                    │ 上下文文件        │
                    └──────────────────┘

         KEY MAPPINGS 🔗
         spec.md              plan.md
         ├─ Key_Entity    →  Data_Entity (data-model.md)
         ├─ User_Action   →  API_Endpoint (contracts/)
         ├─ Acceptance    →  Test_Scenario (quickstart.md)
         └─ [NEEDS...]    →  Research_Decision (research.md)

                              │
                              │ OUTPUT: plan.md, research.md, data-model.md,
                              │         contracts/, quickstart.md
                              ↓

┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
┃                      阶段 3: TASKS 命令（任务生成）                          ┃
┃                                                                             ┃
┃  目标: 将设计文档转化为可执行的、依赖排序的任务清单                          ┃
┃  特点: 用户故事驱动、独立可测试、支持并行                                   ┃
┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

                              │
                              ↓
                    ┌──────────────────┐
                    │    tasks.md      │
                    └──────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ↓                    ↓                    ↓
  
  Phase 1: Setup       Phase 2:           Phase 3+: User Stories
  共享基础设施          Foundational       (按优先级: P1, P2, P3...)
                       阻塞性前置条件
  
  ├─ T001 项目初始化   ├─ T004 数据库     ├─ Phase 3: US1 (P1) 🎯 MVP
  ├─ T002 依赖安装     ├─ T005 认证框架   │  ├─ Tests (可选)
  └─ T003 配置工具     ├─ T006 API路由    │  │  ├─ T010 [P] [US1] Contract
                       └─ ...             │  │  └─ T011 [P] [US1] Integration
                                          │  ├─ Models
                       ⚠️ 必须完成        │  │  └─ T012 [P] [US1] User model
                       才能开始用户故事   │  ├─ Services
                                          │  │  └─ T014 [US1] AuthService
                                          │  └─ Endpoints
                                          │     └─ T015 [US1] POST /register
                                          │
                                          │  ✓ Checkpoint: US1 可独立测试
                                          │
                                          ├─ Phase 4: US2 (P2)
                                          │  └─ 完整实现流程...
                                          │  ✓ Checkpoint: US2 可独立测试
                                          │
                                          └─ Phase 5: US3 (P3)
                                             └─ 完整实现流程...
                                             ✓ Checkpoint: US3 可独立测试

  Final Phase: Polish
  跨故事的改进和优化

         TASK ORGANIZATION 📋
         每个任务包含:
         ├─ [TaskID] 序号 (T001, T002...)
         ├─ [P] 并行标记（可选）
         ├─ [Story] 用户故事标签 ([US1], [US2]...)
         ├─ Description 描述
         ├─ File path 具体文件路径
         └─ 追溯信息（实体、端点、需求）

                              │
                              │ OUTPUT: tasks.md with complete traceability
                              ↓

                    ┌──────────────────┐
                    │   开始实施 🚀    │
                    │                  │
                    │ MVP First: Phase │
                    │ 1 → 2 → 3 (US1)  │
                    │                  │
                    │ 或增量交付: 每个 │
                    │ 用户故事独立部署 │
                    └──────────────────┘
```

---

## 📊 详细演进路线图

### 阶段 1: Specify 命令 - 需求分析

```
┌─────────────────────────────────────────────────────────────────────────┐
│ INPUT                                                                   │
├─────────────────────────────────────────────────────────────────────────┤
│ 用户自然语言描述:                                                        │
│ "我想要一个用户认证系统，支持注册、登录和密码重置功能"                    │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ PROCESSING - Specify 命令执行流程                                        │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. 生成短名称: "user-auth"                                              │
│ 2. 检查现有分支: 找到最高编号（假设为 0）                                │
│ 3. 创建分支: 001-user-auth                                              │
│ 4. 运行脚本: create-new-feature.sh --number 1 --short-name "user-auth"  │
│ 5. 分析需求:                                                            │
│    ├─ 识别用户故事（3个）                                               │
│    ├─ 提取功能需求（FR-001 ~ FR-010）                                   │
│    ├─ 定义成功标准（SC-001 ~ SC-004）                                   │
│    └─ 识别关键实体（User, Token）                                       │
│ 6. 生成 spec.md                                                         │
│ 7. 质量验证:                                                            │
│    ├─ 创建 checklists/requirements.md                                   │
│    ├─ 检查无实现细节 ✓                                                  │
│    ├─ 检查需求可测试 ✓                                                  │
│    └─ 解决 [NEEDS CLARIFICATION]（如有）                                │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ OUTPUT - 生成的文件和内容                                                │
├─────────────────────────────────────────────────────────────────────────┤
│ 📄 specs/001-user-auth/spec.md                                          │
│   ├─ User Story 1: 用户注册 (P1) ⭐ MVP                                 │
│   │   ├─ 验收场景: 成功注册、重复邮箱                                    │
│   │   ├─ 用户动作: [填写注册信息, 提交注册, 接收确认邮件]                │
│   │   └─ 独立测试: "用户可以成功注册并收到确认邮件"                       │
│   ├─ User Story 2: 用户登录 (P2)                                        │
│   │   ├─ 验收场景: 成功登录、错误密码                                    │
│   │   └─ 独立测试: "注册用户可以成功登录"                                │
│   ├─ User Story 3: 密码重置 (P3)                                        │
│   ├─ Functional Requirements: FR-001 ~ FR-010                           │
│   │   ├─ FR-001: 允许用户创建账户                                       │
│   │   ├─ FR-002: 验证邮箱格式                                           │
│   │   ├─ FR-003: 密码最少 8 字符                                        │
│   │   └─ FR-004: 防止重复邮箱                                           │
│   ├─ Success Criteria: SC-001 ~ SC-004                                  │
│   │   ├─ SC-001: 注册时间 < 2 分钟                                      │
│   │   └─ SC-002: 支持 1000 并发用户                                     │
│   └─ Key Entities: User, Token                                          │
│                                                                          │
│ 📄 specs/001-user-auth/checklists/requirements.md                       │
│   ├─ ✓ 无实现细节                                                       │
│   ├─ ✓ 需求可测试                                                       │
│   └─ ✓ 成功标准可衡量                                                   │
│                                                                          │
│ 🌿 Git Branch: 001-user-auth                                            │
└─────────────────────────────────────────────────────────────────────────┘
```

### 阶段 2: Plan 命令 - 技术设计

```
┌─────────────────────────────────────────────────────────────────────────┐
│ INPUT                                                                   │
├─────────────────────────────────────────────────────────────────────────┤
│ - specs/001-user-auth/spec.md                                           │
│ - /memory/constitution.md                                               │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ PROCESSING - Plan 命令执行流程                                           │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. 运行 setup-plan.sh 脚本                                              │
│ 2. 加载 spec.md 和 constitution.md                                      │
│ 3. 填充 Technical Context:                                              │
│    ├─ 语言: Python 3.11                                                 │
│    ├─ 框架: FastAPI                                                     │
│    ├─ 存储: PostgreSQL                                                  │
│    └─ 测试: pytest                                                      │
│ 4. Constitution Check: 检查复杂度门禁 ✓                                 │
│                                                                          │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ PHASE 0: 研究阶段                                                    │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │ 5. 提取 spec.md 中的 [NEEDS CLARIFICATION]                           │ │
│ │    └─ FR-006: 认证方法未指定                                         │ │
│ │ 6. 研究技术选型:                                                     │ │
│ │    ├─ 评估: JWT vs Session vs OAuth2                                │ │
│ │    ├─ 决策: JWT + OAuth2                                             │ │
│ │    └─ 理由: 无状态、支持移动端、行业标准                             │ │
│ │ 7. 生成 research.md                                                  │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│ ┌─────────────────────────────────────────────────────────────────────┐ │
│ │ PHASE 1: 设计阶段                                                    │ │
│ ├─────────────────────────────────────────────────────────────────────┤ │
│ │ 8. 从 Key_Entity 生成 Data_Entity:                                   │ │
│ │    User (spec.md) → User (data-model.md)                             │ │
│ │    ├─ 添加字段类型: email (String), password_hash (String)           │ │
│ │    ├─ 添加约束: unique, email_format, min_length                     │ │
│ │    └─ 映射验证规则: from FR-002, FR-003, FR-004                      │ │
│ │                                                                       │ │
│ │ 9. 从 User_Action 生成 API_Endpoint:                                 │ │
│ │    "提交注册" (US1) → POST /api/v1/auth/register                     │ │
│ │    ├─ 请求: {email, password, username}                              │ │
│ │    ├─ 响应: 201 Created, 409 Conflict                                │ │
│ │    └─ 验证: email_format, password_length                            │ │
│ │                                                                       │ │
│ │ 10. 从 Acceptance_Scenario 生成 Test_Scenario:                       │ │
│ │     US1-Scenario 1 → TS-US1-001                                      │ │
│ │     ├─ 步骤: POST /register → Check DB → Check Email                 │ │
│ │     └─ 预期: 201, User exists, Email sent                            │ │
│ │                                                                       │ │
│ │ 11. 生成 quickstart.md                                               │ │
│ │ 12. 更新 AI Agent 上下文文件                                         │ │
│ └─────────────────────────────────────────────────────────────────────┘ │
│                                                                          │
│ 13. 重新评估 Constitution Check (post-design) ✓                         │
│ 14. 生成 plan.md (协调所有产物)                                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ OUTPUT - 生成的文件和内容                                                │
├─────────────────────────────────────────────────────────────────────────┤
│ 📄 specs/001-user-auth/plan.md                                          │
│   ├─ Technical Context                                                  │
│   │   ├─ Language: Python 3.11                                          │
│   │   ├─ Dependencies: FastAPI, SQLAlchemy, python-jose, authlib        │
│   │   └─ Storage: PostgreSQL                                            │
│   ├─ Project Structure: Single project (src/, tests/)                   │
│   └─ Constitution Check: ✓ Passed                                       │
│                                                                          │
│ 📄 specs/001-user-auth/research.md                                      │
│   └─ Decision: JWT + OAuth2                                             │
│       ├─ Rationale: 无状态、支持移动端                                   │
│       └─ Alternatives: Session (rejected), API Keys (rejected)          │
│                                                                          │
│ 📄 specs/001-user-auth/data-model.md                                    │
│   └─ Entity: User                                                       │
│       ├─ Fields: id, email, password_hash, username, created_at         │
│       ├─ Validation: email_format (FR-002), min_length (FR-003)         │
│       ├─ Related Stories: [US1, US2]                                    │
│       └─ Used In: [/api/v1/auth/register, /api/v1/auth/login]           │
│                                                                          │
│ 📄 specs/001-user-auth/contracts/auth.yaml                              │
│   ├─ POST /api/v1/auth/register                                         │
│   │   ├─ Source: US1 "提交注册"                                         │
│   │   ├─ Request: {email, password, username}                           │
│   │   └─ Response: 201, 400, 409                                        │
│   └─ POST /api/v1/auth/login                                            │
│       └─ Source: US2 "登录提交"                                         │
│                                                                          │
│ 📄 specs/001-user-auth/quickstart.md                                    │
│   ├─ TS-US1-001: 成功注册                                               │
│   │   └─ Steps: POST /register → 201 → Check DB → Check Email          │
│   └─ TS-US1-002: 重复邮箱                                               │
│       └─ Steps: POST /register → 409 Conflict                           │
│                                                                          │
│ 📄 .claude/rules/specify-rules.md (或其他 Agent)                        │
│   └─ 更新技术栈: Python 3.11, FastAPI, PostgreSQL, JWT                  │
└─────────────────────────────────────────────────────────────────────────┘
```

### 阶段 3: Tasks 命令 - 任务生成

```
┌─────────────────────────────────────────────────────────────────────────┐
│ INPUT                                                                   │
├─────────────────────────────────────────────────────────────────────────┤
│ - specs/001-user-auth/plan.md (必须)                                    │
│ - specs/001-user-auth/spec.md (必须)                                    │
│ - specs/001-user-auth/data-model.md (可选)                              │
│ - specs/001-user-auth/contracts/ (可选)                                 │
│ - specs/001-user-auth/research.md (可选)                                │
│ - specs/001-user-auth/quickstart.md (可选)                              │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ PROCESSING - Tasks 命令执行流程                                          │
├─────────────────────────────────────────────────────────────────────────┤
│ 1. 运行 check-prerequisites.sh 脚本                                     │
│ 2. 加载所有可用的设计文档                                                │
│ 3. 从 spec.md 提取用户故事和优先级:                                      │
│    ├─ US1 (P1) → Phase 3                                                │
│    ├─ US2 (P2) → Phase 4                                                │
│    └─ US3 (P3) → Phase 5                                                │
│ 4. 从 plan.md 提取技术栈和项目结构                                       │
│ 5. 生成任务（按阶段组织）:                                              │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase 1: Setup (共享基础设施)                                   │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ - T001 Create project structure                                │  │
│    │ - T002 Initialize Python 3.11 + FastAPI                        │  │
│    │ - T003 [P] Configure pytest and linting                        │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase 2: Foundational (阻塞性前置条件) ⚠️                       │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ - T004 Setup PostgreSQL schema and Alembic                     │  │
│    │ - T005 [P] Implement JWT auth middleware                       │  │
│    │   └─ From: research.md (JWT decision)                          │  │
│    │ - T006 [P] Setup OAuth2 providers                              │  │
│    │   └─ From: research.md (OAuth2 decision)                       │  │
│    │ - T007 [P] Setup error handling                                │  │
│    │ - T008 Configure environment variables                         │  │
│    │                                                                 │  │
│    │ ⚠️ 这些任务完成后，所有用户故事才能开始                         │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase 3: User Story 1 - 用户注册 (P1) 🎯 MVP                   │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ Goal: 实现用户注册功能                                          │  │
│    │ Independent Test: 用户可以成功注册并收到确认邮件                │  │
│    │                                                                 │  │
│    │ Tests (如果请求):                                               │  │
│    │ - T009 [P] [US1] Contract test for POST /register              │  │
│    │   └─ From: quickstart.md (TS-US1-001, TS-US1-002)              │  │
│    │ - T010 [P] [US1] Integration test for registration             │  │
│    │   └─ Covers: US1 Acceptance Scenarios 1, 2                     │  │
│    │                                                                 │  │
│    │ Implementation:                                                 │  │
│    │ - T011 [P] [US1] Create User model                             │  │
│    │   ├─ File: src/models/user.py                                  │  │
│    │   ├─ From: data-model.md (User entity)                         │  │
│    │   └─ Implements: FR-001, FR-002, FR-003, FR-004                │  │
│    │ - T012 [US1] Implement AuthService.register()                  │  │
│    │   ├─ File: src/services/auth_service.py                        │  │
│    │   ├─ Depends: T011                                             │  │
│    │   └─ Logic: hash password, check duplicates, create user       │  │
│    │ - T013 [US1] Implement POST /api/v1/auth/register              │  │
│    │   ├─ File: src/api/v1/auth.py                                  │  │
│    │   ├─ From: contracts/auth.yaml                                 │  │
│    │   ├─ Depends: T012                                             │  │
│    │   └─ Source: US1 "提交注册" user action                        │  │
│    │ - T014 [US1] Add validation and error handling                 │  │
│    │   ├─ File: src/api/validators/auth_validator.py               │  │
│    │   └─ Validates: email format, password length                  │  │
│    │ - T015 [US1] Add logging for registration                      │  │
│    │                                                                 │  │
│    │ ✓ Checkpoint: US1 完成，可独立测试                              │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase 4: User Story 2 - 用户登录 (P2)                          │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ Goal: 实现用户登录功能                                          │  │
│    │ Independent Test: 注册用户可以成功登录                          │  │
│    │ Depends: Phase 2 (独立于 US1) ⭐                               │  │
│    │                                                                 │  │
│    │ - T016 [P] [US2] Contract test for POST /login                 │  │
│    │ - T017 [US2] Implement AuthService.login()                     │  │
│    │ - T018 [US2] Implement POST /api/v1/auth/login                 │  │
│    │   └─ Source: US2 "登录提交" user action                        │  │
│    │                                                                 │  │
│    │ ✓ Checkpoint: US2 完成，可独立测试                              │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase 5: User Story 3 - 密码重置 (P3)                          │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ Goal: 实现密码重置功能                                          │  │
│    │ Independent Test: 用户可以通过邮件重置密码                      │  │
│    │ Depends: Phase 2 (独立于 US1, US2) ⭐                          │  │
│    │                                                                 │  │
│    │ - T019 [P] [US3] Create PasswordResetToken model               │  │
│    │ - T020 [US3] Implement reset request endpoint                  │  │
│    │ - T021 [US3] Implement reset confirmation endpoint             │  │
│    │                                                                 │  │
│    │ ✓ Checkpoint: US3 完成，可独立测试                              │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│    ┌─────────────────────────────────────────────────────────────────┐  │
│    │ Phase N: Polish (跨故事改进)                                    │  │
│    ├─────────────────────────────────────────────────────────────────┤  │
│    │ - TXXX [P] Documentation updates                               │  │
│    │ - TXXX Code cleanup and refactoring                            │  │
│    │ - TXXX Performance optimization                                │  │
│    │ - TXXX Run quickstart.md validation                            │  │
│    └─────────────────────────────────────────────────────────────────┘  │
│                                                                          │
│ 6. 生成依赖关系图                                                        │
│ 7. 生成并行执行示例                                                      │
│ 8. 生成实施策略                                                          │
└─────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────┐
│ OUTPUT - 生成的文件和内容                                                │
├─────────────────────────────────────────────────────────────────────────┤
│ 📄 specs/001-user-auth/tasks.md                                         │
│                                                                          │
│   统计信息:                                                              │
│   ├─ 总任务数: 21                                                       │
│   ├─ Setup: 3 tasks                                                     │
│   ├─ Foundational: 5 tasks (阻塞)                                       │
│   ├─ US1 (P1): 7 tasks                                                  │
│   ├─ US2 (P2): 3 tasks                                                  │
│   ├─ US3 (P3): 3 tasks                                                  │
│   └─ 并行机会: 12 tasks 标记为 [P]                                      │
│                                                                          │
│   MVP 范围:                                                              │
│   └─ Phase 1 (Setup) + Phase 2 (Foundational) + Phase 3 (US1)          │
│                                                                          │
│   交付策略:                                                              │
│   ├─ MVP First: 完成 Phases 1-3 → 部署 US1                              │
│   ├─ Incremental: Phase 3 → 部署, Phase 4 → 部署, Phase 5 → 部署       │
│   └─ Parallel: Foundational 完成后，US1/US2/US3 并行开发                │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 🎯 关键决策点

### 决策点 1: 用户故事优先级（Specify 阶段）

```
决策: 如何排序用户故事？

考虑因素:
├─ 用户价值: 哪个功能对用户最重要？
├─ 业务价值: 哪个功能对业务最关键？
├─ 依赖关系: 哪个功能是其他功能的前提？
└─ 风险: 哪个功能技术风险最高（应尽早验证）？

输出:
├─ US1 (P1): 用户注册 → 基础功能，MVP 必需
├─ US2 (P2): 用户登录 → 依赖注册，但可独立测试
└─ US3 (P3): 密码重置 → 增强功能，非 MVP

影响:
└─ Tasks.md 中的 Phase 顺序
    ├─ Phase 3: US1 (P1) ← MVP 范围
    ├─ Phase 4: US2 (P2) ← 第一次增量
    └─ Phase 5: US3 (P3) ← 第二次增量
```

### 决策点 2: 技术选型（Plan 阶段）

```
决策: 使用哪种认证方法？

输入: spec.md 中的 [NEEDS CLARIFICATION: auth method]

研究过程 (research.md):
├─ 方案 A: Session-based
│   ├─ 优点: 简单、成熟
│   └─ 缺点: 有状态、不适合移动端
├─ 方案 B: API Keys
│   ├─ 优点: 非常简单
│   └─ 缺点: 安全性差、无用户上下文
└─ 方案 C: JWT + OAuth2 ✓ 选中
    ├─ 优点: 无状态、支持移动端、行业标准
    └─ 缺点: 稍复杂、需要额外库

决策: JWT + OAuth2

影响:
├─ plan.md: 添加依赖 python-jose, authlib
├─ data-model.md: User 添加 oauth_provider 字段
├─ contracts/: 添加 /auth/oauth/* 端点
└─ tasks.md: 添加 OAuth2 集成任务 (T006)
```

### 决策点 3: 任务依赖关系（Tasks 阶段）

```
决策: 哪些任务可以并行？

分析:
├─ Setup tasks (T001-T003): 可并行 ✓
├─ Foundational tasks (T004-T008):
│   ├─ T004 (DB): 独立 → [P]
│   ├─ T005 (JWT): 独立 → [P]
│   ├─ T006 (OAuth): 独立 → [P]
│   └─ T007-T008: 独立 → [P]
└─ US1 tasks (T009-T015):
    ├─ T009 (Test): 独立 → [P]
    ├─ T010 (Test): 独立 → [P]
    ├─ T011 (Model): 独立 → [P]
    ├─ T012 (Service): 依赖 T011 → 不可并行
    └─ T013-T015: 依赖 T012 → 不可并行

标记结果:
└─ 12 个任务标记为 [P]（可并行）

影响:
└─ 支持团队并行工作，加快交付速度
```

---

## 🚀 交付策略演进

### 策略 1: MVP First（最小可行产品优先）

```
目标: 尽快验证核心价值

实施顺序:
1. Phase 1: Setup → 建立项目基础
2. Phase 2: Foundational → 完成核心基础设施
3. Phase 3: User Story 1 (P1) → 实现用户注册
4. STOP ✋ 部署和验证

交付物:
└─ 用户可以注册账户的 MVP

优点:
├─ 快速验证核心假设
├─ 尽早获得用户反馈
└─ 降低投资风险

时间线:
└─ 约 1-2 周（取决于团队规模）
```

### 策略 2: Incremental Delivery（增量交付）

```
目标: 每个用户故事独立交付价值

实施顺序:
1. Phases 1-3 → 部署 US1 (用户注册) 🚀
2. Phase 4 → 部署 US2 (用户登录) 🚀
3. Phase 5 → 部署 US3 (密码重置) 🚀

每次部署:
├─ 独立测试当前用户故事
├─ 确保不破坏已有功能
└─ 收集用户反馈

优点:
├─ 持续交付价值
├─ 及时调整方向
└─ 降低发布风险

时间线:
└─ 每 1-2 周一次增量发布
```

### 策略 3: Parallel Team（并行团队）

```
目标: 多团队并行开发，加快交付

实施顺序:
1. 全团队: Phases 1-2 (Setup + Foundational)
2. 并行开发（Foundational 完成后）:
   ├─ Developer A: Phase 3 (US1 - 用户注册)
   ├─ Developer B: Phase 4 (US2 - 用户登录)
   └─ Developer C: Phase 5 (US3 - 密码重置)
3. 集成和测试

前提条件:
└─ 所有用户故事必须独立可测试 ✓

优点:
├─ 显著缩短交付时间
├─ 充分利用团队资源
└─ 故事间不相互阻塞

时间线:
└─ 约 1-2 周完成所有功能
```

---

## 📈 追溯示例

### 从用户需求到实现任务

```
用户描述:
"我想要一个用户认证系统"

    ↓ Specify 分析

spec.md: User Story 1
"用户可以通过邮箱和密码注册账户" (P1)
├─ 用户动作: "提交注册"
└─ 验收: "账户创建成功，收到确认邮件"

    ↓ Plan 设计

contracts/auth.yaml: API_Endpoint
POST /api/v1/auth/register
├─ source_user_story: "US1"
├─ source_user_action: "提交注册"
└─ request: {email, password, username}

    ↓ Tasks 实施

tasks.md: T013 [US1]
"Implement POST /api/v1/auth/register in src/api/v1/auth.py"
├─ user_story_label: [US1]
├─ related_endpoints: ["/api/v1/auth/register"]
├─ source: US1 "提交注册" user action
└─ file_path: src/api/v1/auth.py
```

### 从功能需求到验证

```
spec.md: FR-002
"System MUST validate email addresses"

    ↓ Plan 细化

data-model.md: User.validation_rules
"Email must match RFC 5322 format (FR-002)"

contracts/auth.yaml: API_Endpoint.validation_rules
field: "email", rule: "email_format", from: "FR-002"

quickstart.md: Test_Scenario
"Verify email format validation returns 400"

    ↓ Tasks 实施

tasks.md:
├─ T011 [US1] Create User model with email validation
├─ T014 [US1] Add request validation (email format)
└─ T009 [US1] Contract test (verify FR-002)
```

---

**下一步**：查看 [05-design-principles.md](./05-design-principles.md) 了解设计原则。

