# 关键设计原则

本文档阐述 Spec Kit 工作流背后的核心设计原则，解释为什么这样设计，以及如何应用这些原则。

---

## 🎯 原则 1: 用户故事驱动 (Story-Driven Development)

### 核心理念

**所有产物围绕用户故事组织，而不是技术组件**。

### 为什么这样设计？

传统开发方式按技术层组织（先做所有 Models，再做所有 Services...），导致：
- ❌ 无法快速交付完整功能
- ❌ 难以独立测试单个功能
- ❌ 团队成员相互阻塞

用户故事驱动的方式：
- ✅ 每个故事是完整的功能切片（垂直切分）
- ✅ 可以独立开发、测试、部署
- ✅ 快速交付用户价值

### 如何体现？

#### Specify 阶段

```markdown
# spec.md

## User Story 1 - 用户注册 (Priority: P1)

**Independent Test**: 用户可以成功注册并收到确认邮件

**Acceptance Scenarios**:
1. Given 新用户访问注册页面...
```

**关键点**：
- 每个故事都有 `Independent Test`
- 明确优先级（P1, P2, P3...）
- 故事间尽量独立

#### Plan 阶段

所有设计产物都标记所属用户故事：

```yaml
# data-model.md
Data_Entity:
  name: "User"
  related_user_stories: ["US1", "US2"]  # 明确关联

# contracts/auth.yaml
API_Endpoint:
  path: "/api/v1/auth/register"
  source_user_story: "US1"  # 明确来源
```

#### Tasks 阶段

每个任务都标记所属用户故事：

```markdown
# tasks.md

## Phase 3: User Story 1 - 用户注册 (Priority: P1)

- [ ] T012 [P] [US1] Create User model in src/models/user.py
- [ ] T014 [US1] Implement AuthService.register()
- [ ] T015 [US1] Implement POST /api/v1/auth/register
```

**关键点**：
- `[US1]` 标签明确归属
- 每个 Phase 对应一个用户故事
- Checkpoint 验证故事完整性

### 实践指南

#### ✅ 正确做法

```
User Story: "用户可以查看订单列表"

Phase 3: User Story 1
├─ Order model（此故事需要的部分）
├─ OrderService.list()（此故事需要的方法）
└─ GET /api/v1/orders（此故事需要的端点）

✓ Checkpoint: 用户可以查看订单列表（完整功能）
```

#### ❌ 错误做法

```
Phase 1: All Models
├─ User model
├─ Order model
├─ Product model
└─ ...

Phase 2: All Services
├─ UserService
├─ OrderService
└─ ...

✗ 问题: 无法独立测试任何完整功能
```

### 好处

1. **快速 MVP**：只实现 P1 用户故事，就有可演示的产品
2. **增量交付**：每个故事完成后就能部署，持续交付价值
3. **并行开发**：不同开发者负责不同故事，减少冲突
4. **清晰追溯**：从用户需求到实现任务的完整链路

---

## 🔄 原则 2: 渐进式细化 (Progressive Refinement)

### 核心理念

**从概念层面逐步细化到技术实现层面，保持可追溯性**。

### 为什么这样设计？

一次性设计所有细节容易：
- ❌ 过早引入技术约束
- ❌ 错过业务本质
- ❌ 难以适应变化

渐进式细化：
- ✅ 先理解业务需求
- ✅ 再做技术选型
- ✅ 最后落实到代码

### 演进层次

```
┌──────────────────────────────────────────────────────────┐
│ 层次 1: 概念层 (Specify)                                  │
│ "用户"、"订单" - 业务概念                                 │
└──────────────────────────────────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────────┐
│ 层次 2: 技术层 (Plan)                                     │
│ User {email: String, password_hash: String} - 技术实现    │
└──────────────────────────────────────────────────────────┘
                        ↓
┌──────────────────────────────────────────────────────────┐
│ 层次 3: 代码层 (Tasks)                                    │
│ class User(Base): email = Column(String) - 具体代码       │
└──────────────────────────────────────────────────────────┘
```

### 实例对比

#### 概念层（spec.md）

```yaml
Key_Entity:
  name: "User"
  key_attributes:
    - "邮箱"  # 概念，无类型
    - "密码"  # 不提及如何存储
    - "注册时间"
  relationships:
    - "一个用户有多个订单"  # 自然语言描述
```

**特点**：
- 技术无关
- 业务人员可读
- 聚焦 WHAT 和 WHY

#### 技术层（data-model.md）

```yaml
Data_Entity:
  name: "User"
  source_key_entity: "User"  # 追溯到概念层
  fields:
    - name: "email"
      type: "String"  # 添加类型
      constraints: ["unique", "email_format"]  # 添加约束
    - name: "password_hash"  # 明确是哈希值，不是明文
      type: "String"
      constraints: ["min_length: 60"]  # bcrypt 长度
  relationships:
    - target_entity: "Order"
      relationship_type: "one_to_many"  # 技术关系
      foreign_key: "user_id"  # 具体外键
```

**特点**：
- 技术具体
- 添加类型和约束
- 聚焦 HOW

#### 代码层（tasks.md）

```markdown
- [ ] T012 [US1] Create User model in src/models/user.py
  - Implement fields: email, password_hash, created_at
  - Add validation: email_format, unique constraints
  - Define relationship: User.orders (one-to-many)
  - Related entity: User (from data-model.md)
```

**特点**：
- 可执行
- 具体文件路径
- 明确追溯来源

### 追溯性保证

每个层次都保留到上一层的追溯：

```
Task.related_entities → Data_Entity.source_key_entity → Key_Entity
     (tasks.md)              (data-model.md)              (spec.md)
```

### 实践指南

#### ✅ 正确的细化

```
Spec: "用户可以重置密码"
      ↓ 概念：用户、密码、重置
      
Plan: "PasswordResetToken entity with expiry"
      ↓ 技术：Token 实体、过期机制
      
Tasks: "Create PasswordResetToken model in src/models/token.py"
       ↓ 实现：具体文件、具体字段
```

#### ❌ 过早细化

```
Spec: "用户可以重置密码（使用 JWT token，存储在 Redis，
      过期时间 15 分钟，使用 SHA-256 哈希）"

✗ 问题: 在概念层引入了实现细节，限制了设计空间
```

### 好处

1. **延迟决策**：在合适的时候做技术决策
2. **灵活调整**：概念层变化不影响技术选型
3. **完整追溯**：可以从代码回溯到业务需求
4. **知识积累**：每层的设计都是有价值的文档

---

## 🔍 原则 3: 可追溯性 (Full Traceability)

### 核心理念

**每个实现任务都可以追溯到具体的业务需求**。

### 为什么这样设计？

没有追溯性的代码：
- ❌ "为什么要实现这个功能？" - 不知道
- ❌ "这段代码满足哪个需求？" - 不清楚
- ❌ "需求变化会影响哪些代码？" - 难以评估

完整追溯性：
- ✅ 理解每行代码的业务价值
- ✅ 影响分析简单准确
- ✅ 知识传承不依赖人

### 追溯关系

```
User_Story (US1)
  │
  ├─→ Functional_Requirement (FR-001, FR-002)
  │     │
  │     ├─→ Data_Entity.validation_rules
  │     │     └─→ Task (Model 实现)
  │     │
  │     └─→ API_Endpoint.validation_rules
  │           └─→ Task (Validation 实现)
  │
  ├─→ user_actions ("提交注册")
  │     └─→ API_Endpoint
  │           └─→ Task (Endpoint 实现)
  │
  └─→ acceptance_scenarios
        └─→ Test_Scenario
              └─→ Task (Test 实现)
```

### 追溯标记

#### 在 Task 中

```yaml
Task:
  id: "T012"
  description: "Create User model"
  user_story_label: "US1"  # ⭐ 所属用户故事
  related_entities: ["User"]  # ⭐ 相关实体
  related_endpoints: ["/api/v1/auth/register"]  # ⭐ 相关端点
  related_functional_requirements: ["FR-001", "FR-002"]  # ⭐ 满足的需求
```

#### 在 API_Endpoint 中

```yaml
API_Endpoint:
  path: "/api/v1/auth/register"
  source_user_story: "US1"  # ⭐ 来源用户故事
  source_user_action: "提交注册"  # ⭐ 来源用户动作
  implements_requirements: ["FR-001", "FR-002"]  # ⭐ 实现的需求
```

#### 在 Data_Entity 中

```yaml
Data_Entity:
  name: "User"
  source_key_entity: "User"  # ⭐ 来源概念实体
  related_user_stories: ["US1", "US2"]  # ⭐ 相关用户故事
  validation_rules:
    - rule: "Email must be unique"
      related_fr: "FR-004"  # ⭐ 来源功能需求
```

### 实践场景

#### 场景 1: 正向追溯（需求 → 实现）

**问题**："FR-002（邮箱验证）在哪里实现了？"

**查找路径**：
1. 搜索 `related_functional_requirements: ["FR-002"]`
2. 找到：
   - T012: User model（字段验证）
   - T014: Validation（请求验证）
   - T009: Contract test（测试验证）

#### 场景 2: 反向追溯（实现 → 需求）

**问题**："为什么要实现 T014 这个任务？"

**查找路径**：
1. 查看 T014 的 `user_story_label` → `[US1]`
2. 查看 T014 的 `related_functional_requirements` → `["FR-002", "FR-003"]`
3. 读取 spec.md 中的 US1 和 FR-002, FR-003
4. 理解业务价值：验证邮箱格式和密码长度

#### 场景 3: 影响分析（变更 → 影响）

**问题**："如果修改 FR-002（改变邮箱验证规则），会影响什么？"

**影响路径**：
1. data-model.md: User.validation_rules（需要更新）
2. contracts/auth.yaml: API_Endpoint.validation_rules（需要更新）
3. tasks.md: T012 (Model), T014 (Validation), T009 (Test)（需要重新实现）
4. quickstart.md: Test scenarios（需要更新测试用例）

### 追溯工具建议

#### 文档内搜索

```bash
# 查找所有 US1 相关任务
grep -r "\[US1\]" specs/001-user-auth/

# 查找 FR-002 的所有影响
grep -r "FR-002" specs/001-user-auth/
```

#### 追溯矩阵（可选工具）

```
| Requirement | Entity | Endpoint | Task |
|-------------|--------|----------|------|
| FR-002      | User   | POST /register | T012, T014, T009 |
| FR-003      | User   | POST /register | T012, T014 |
```

### 好处

1. **理解代码价值**：知道为什么写这段代码
2. **安全重构**：知道修改会影响什么
3. **知识传承**：新人可以快速理解业务逻辑
4. **需求覆盖**：确保所有需求都有实现

---

## 🚀 原则 4: 并行能力 (Parallelization Support)

### 核心理念

**最大化团队的并行工作能力，缩短交付时间**。

### 为什么这样设计？

串行开发：
- ❌ 团队成员相互等待
- ❌ 关键路径很长
- ❌ 无法充分利用资源

并行能力设计：
- ✅ 明确依赖关系
- ✅ 减少阻塞点
- ✅ 支持多种并行策略

### 并行层次

#### 层次 1: 阶段级并行

```
Phase 2: Foundational (完成后)
         │
         ├──────────┬──────────┐
         ↓          ↓          ↓
    Phase 3     Phase 4     Phase 5
     (US1)       (US2)       (US3)
     │           │           │
   独立开发    独立开发    独立开发
```

**前提条件**：
- Foundational phase 必须完成（阻塞点）
- 所有用户故事必须独立可测试

**适用场景**：
- 多开发者团队
- 希望并行实现多个功能

#### 层次 2: 任务级并行

```
Phase 3: User Story 1
  │
  ├─ Models
  │  ├─ T012 [P] User model ──────┐
  │  └─ T013 [P] Token model ─────┤ 可并行
  │                                │
  ├─ Tests                         │
  │  ├─ T009 [P] Contract test ────┤
  │  └─ T010 [P] Integration test ─┘
  │
  └─ Services
     └─ T014 AuthService (depends on T012, T013)
```

**标记方式**：
- `[P]` 标记：可以并行执行
- 无 `[P]` 标记：有依赖，需串行

**判断标准**：
1. ✅ 操作不同文件 → 可并行
2. ✅ 无数据依赖 → 可并行
3. ❌ 需要前置任务的输出 → 不可并行

### 依赖管理

#### 阶段依赖

```yaml
Phase_Dependencies:
  Phase 1: []  # Setup 无依赖
  Phase 2: [1]  # Foundational 依赖 Setup
  Phase 3: [2]  # US1 依赖 Foundational
  Phase 4: [2]  # US2 依赖 Foundational（独立于 US1）
  Phase 5: [2]  # US3 依赖 Foundational（独立于 US1, US2）
```

**关键设计**：
- US1, US2, US3 都只依赖 Foundational
- 用户故事间尽量独立（偶尔集成）

#### 任务依赖

```yaml
Task_Dependencies:
  T012 (User model): []  # 无依赖 [P]
  T013 (Token model): []  # 无依赖 [P]
  T014 (AuthService): [T012, T013]  # 依赖 Models
  T015 (Endpoint): [T014]  # 依赖 Service
```

### 并行执行示例

#### 示例 1: 并行创建 Models

```bash
# tasks.md 提供的并行示例

Parallel Example: User Story 1 - Models

Task: "Create User model in src/models/user.py"
Task: "Create Token model in src/models/token.py"

# 两个任务可以同时执行（不同文件，无依赖）
```

**AI Agent 执行**：
- 同时启动两个任务
- 各自创建文件
- 没有冲突

#### 示例 2: 并行团队策略

```
Team: 3 developers

Week 1:
  └─ 全员: Phase 1 (Setup) + Phase 2 (Foundational)

Week 2-3 (Foundational 完成后):
  ├─ Developer A: Phase 3 (US1)
  ├─ Developer B: Phase 4 (US2)
  └─ Developer C: Phase 5 (US3)

Week 4:
  └─ 全员: Integration testing + Polish
```

### 实践指南

#### ✅ 设计独立的用户故事

```
User Story 1: 用户注册
  └─ 可独立测试：注册功能完全工作

User Story 2: 用户登录
  └─ 可独立测试：已注册用户可以登录
  └─ 依赖 Foundational（Auth 中间件），不依赖 US1 实现

✓ US1 和 US2 可以并行开发
```

#### ❌ 避免紧耦合

```
User Story 1: 用户管理（包含注册、登录、修改资料）
User Story 2: 订单管理（依赖 US1 的某个具体实现）

✗ US2 阻塞等待 US1，无法并行
```

#### 🎯 识别并行机会

**检查清单**：
1. 任务操作的是不同文件？ → ✅ 可并行
2. 任务属于不同用户故事？ → ✅ 可能并行（检查故事依赖）
3. 任务是同类型（Models, Tests）？ → ✅ 通常可并行
4. 任务需要前置任务的输出？ → ❌ 不可并行

### 好处

1. **缩短时间**：充分利用团队资源
2. **降低风险**：关键路径更短，风险更分散
3. **提高士气**：减少等待，持续产出
4. **灵活调度**：根据团队规模选择并行策略

---

## ✅ 原则 5: 质量门禁 (Quality Gates)

### 核心理念

**在关键节点设置质量检查，确保每个阶段的产出符合标准**。

### 为什么这样设计？

没有质量门禁：
- ❌ 问题积累到后期才发现
- ❌ 返工成本高
- ❌ 交付质量不稳定

设置质量门禁：
- ✅ 及早发现问题
- ✅ 确保基线质量
- ✅ 减少技术债务

### 门禁层次

```
┌──────────────────────────────────────────────┐
│ Specify 阶段门禁                              │
│ ├─ Checklist: requirements.md                │
│ ├─ 检查: 无实现细节、需求可测试、无未解决     │
│ │         的 NEEDS CLARIFICATION              │
│ └─ 阻塞: 质量不达标不能进入 Plan 阶段         │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ Plan 阶段门禁                                 │
│ ├─ Constitution Check: 复杂度门禁            │
│ ├─ 检查: 项目数量、架构模式、依赖复杂度      │
│ └─ 阻塞: 违规必须提供理由和更简单方案分析    │
└──────────────────────────────────────────────┘
                    ↓
┌──────────────────────────────────────────────┐
│ Tasks 阶段门禁                                │
│ ├─ Checkpoint: 每个用户故事完成后            │
│ ├─ 检查: 独立测试通过、功能完整              │
│ └─ 阻塞: 当前故事未完成不继续下一个          │
└──────────────────────────────────────────────┘
```

### 门禁 1: Specify 质量检查

**文件**：`checklists/requirements.md`

**检查项**：

```markdown
## Content Quality
- [ ] No implementation details (languages, frameworks, APIs)
- [ ] Focused on user value and business needs
- [ ] Written for non-technical stakeholders

## Requirement Completeness
- [ ] No [NEEDS CLARIFICATION] markers remain
- [ ] Requirements are testable and unambiguous
- [ ] Success criteria are measurable and technology-agnostic
- [ ] All acceptance scenarios are defined
```

**阻塞逻辑**：
- 如果有未解决的 `[NEEDS CLARIFICATION]` → 不能进入 Plan
- 如果需求不可测试 → 更新 spec.md
- 如果成功标准有实现细节 → 移除技术相关内容

### 门禁 2: Constitution Check

**文件**：`/memory/constitution.md`, `plan.md`

**检查项**：

```markdown
## Constitution Check

### Project Count Limit
- Current: 1 project
- Limit: ≤ 3 projects
- Status: ✓ PASS

### Architecture Patterns
- Repository pattern: Not used
- Status: ✓ PASS (No unnecessary abstraction)
```

**阻塞逻辑**：
- 如果违规 → 必须提供理由
- 必须分析更简单方案为何不可行
- 违规必须记录在 `Complexity Tracking` 表格

**示例**：

```markdown
## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| 4th project | Microservices separation required | Monolith cannot handle scale |
```

### 门禁 3: 用户故事 Checkpoint

**位置**：`tasks.md` 每个用户故事 Phase 的末尾

**检查项**：

```markdown
## Phase 3: User Story 1 - 用户注册 (Priority: P1)

[... tasks ...]

**Checkpoint**: At this point, User Story 1 should be fully functional 
and testable independently.

Verification:
- [ ] All US1 tasks completed
- [ ] US1 independent test passes
- [ ] No dependencies on incomplete features
```

**阻塞逻辑**：
- Checkpoint 未通过 → 不继续下一个 Phase
- 确保每个故事完整交付价值

### 实践指南

#### 门禁自动化（可选）

```bash
# 示例：自动检查 spec.md 中的 NEEDS CLARIFICATION

#!/bin/bash
spec_file="specs/$FEATURE/spec.md"

if grep -q "\[NEEDS CLARIFICATION" "$spec_file"; then
  echo "❌ Spec contains unresolved clarifications"
  exit 1
fi

echo "✓ Spec quality check passed"
```

#### 人工审查

- **Specify 阶段**：产品经理审查 spec.md
- **Plan 阶段**：架构师审查 plan.md 和 Constitution Check
- **Tasks 阶段**：团队 Lead 审查 Checkpoint 完成情况

### 好处

1. **及早发现问题**：在设计阶段而非编码阶段
2. **标准化质量**：明确的检查标准
3. **减少返工**：避免不符合要求的产出流到下游
4. **知识共享**：检查清单本身就是最佳实践

---

## 📚 原则总结

### 五大原则协同

```
用户故事驱动
    ↓ 决定组织方式
渐进式细化
    ↓ 在每个层次保持
可追溯性
    ↓ 使得能够
并行能力
    ↓ 质量由以下保证
质量门禁
```

### 应用检查清单

在使用 Spec Kit 时，问自己：

- [ ] **用户故事驱动**：我的任务归属哪个用户故事？
- [ ] **渐进式细化**：我是否过早引入了技术细节？
- [ ] **可追溯性**：我能追溯到这个任务的业务价值吗？
- [ ] **并行能力**：这个任务可以和其他任务并行吗？
- [ ] **质量门禁**：我通过了当前阶段的质量检查吗？

### 设计哲学

> **"Start with user value, progressively refine to implementation, maintain full traceability, enable maximum parallelism, and ensure quality at every stage."**
>
> 从用户价值出发，渐进细化到实现，保持完整追溯，实现最大并行，确保每个阶段的质量。

---

**下一步**：查看 [06-complete-example.md](./06-complete-example.md) 通过完整示例学习这些原则的应用。

