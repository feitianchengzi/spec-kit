# 各阶段实体和属性提取

本文档详细描述每个产物文件的内部结构，包括实体定义、属性和关系。

---

## 📄 Spec.md 的实体结构

**来源**：`templates/spec-template.md`

### Feature（功能特性）

```yaml
Feature:
  number: int                      # 功能编号（001, 002, 003...）
  short_name: string               # 短名称（user-auth, payment-flow）
  branch_name: string              # 分支名（001-user-auth）
  description: string              # 原始用户描述
  status: enum                     # Draft | Ready | InProgress | Complete
  created_date: date               # 创建日期
  spec_file_path: string           # spec.md 文件路径
```

### User_Story（用户故事）⭐

**说明**：这是整个工作流的核心实体，驱动所有后续产物的生成。

```yaml
User_Story:
  id: string                       # 标识符（US1, US2, US3...）
  title: string                    # 简短标题（2-6 个词）
  priority: enum                   # P1 | P2 | P3 | P4...（P1 最高）
  description: string              # 用户旅程描述（纯文本）
  
  # 为什么这个优先级
  priority_rationale: string       # 解释优先级的理由
  
  # 独立测试标准
  independent_test: string         # 如何验证这个故事独立工作
  
  # 验收场景列表
  acceptance_scenarios: list
    - scenario_number: int         # 场景编号（1, 2, 3...）
      given: string                # 初始状态
      when: string                 # 用户动作
      then: string                 # 预期结果
  
  # 用户在此故事中的动作
  user_actions: list               # 从 description 和 scenarios 中提取
    - action: string               # 如："提交注册"、"查看订单列表"
      
  # 关联关系
  related_functional_requirements: list  # [FR-001, FR-002...]
  related_entities: list           # [User, Order...]
  related_success_criteria: list   # [SC-001, SC-002...]
```

**示例**：

```yaml
User_Story:
  id: "US1"
  title: "用户注册"
  priority: "P1"
  description: "新用户可以通过提供邮箱和密码创建账户"
  priority_rationale: "这是系统的基础功能，没有注册就无法使用其他功能"
  independent_test: "用户可以成功注册并收到确认邮件"
  acceptance_scenarios:
    - scenario_number: 1
      given: "新用户访问注册页面"
      when: "填写有效的邮箱和密码并提交"
      then: "账户创建成功，收到确认邮件"
    - scenario_number: 2
      given: "用户尝试使用已存在的邮箱注册"
      when: "提交注册表单"
      then: "显示错误提示：邮箱已被使用"
  user_actions: ["填写注册信息", "提交注册", "接收确认邮件"]
  related_functional_requirements: ["FR-001", "FR-002", "FR-003", "FR-004"]
  related_entities: ["User"]
```

### User_Story 驱动的下游实体（完整关联视图）

⭐ **重要**：一个用户故事是整个工作流的核心驱动力，它会串联所有阶段的实体。

```yaml
User_Story_US1_Downstream_Entities:
  # 直接影响（Specify 阶段内）
  direct_impacts:
    - Functional_Requirements:
        - related_functional_requirements: ["FR-001", "FR-002", "FR-003", "FR-004"]
        - relationship: "User_Story.related_functional_requirements → Functional_Requirement.id"
    
    - Key_Entities:
        - related_entities: ["User"]
        - relationship: "User_Story.related_entities → Key_Entity.name"
    
    - Success_Criteria:
        - related_success_criteria: ["SC-001"]
        - relationship: "User_Story → Success_Criteria.related_user_stories"
  
  # 演进影响（Plan 阶段）
  plan_phase_impacts:
    - API_Endpoints:
        - generated_from: "user_actions"
        - mapping: "user_action: '提交注册' → API_Endpoint: 'POST /api/v1/auth/register'"
        - file: "contracts/auth.yaml"
        - count: "1-3 个端点/故事"
    
    - Test_Scenarios:
        - generated_from: "acceptance_scenarios"
        - mapping: "acceptance_scenario 1 → Test_Scenario: 'TS-US1-001'"
        - file: "quickstart.md"
        - count: "2-5 个场景/故事"
    
    - Data_Entities:
        - generated_from: "related_entities"
        - mapping: "Key_Entity: 'User' → Data_Entity: 'User' (with technical details)"
        - file: "data-model.md"
        - count: "1-3 个实体/故事"
    
    - Research_Decisions:
        - triggered_by: "related_functional_requirements with [NEEDS CLARIFICATION]"
        - file: "research.md"
        - count: "0-3 个决策/故事"
  
  # 实施影响（Tasks 阶段）
  tasks_phase_impacts:
    - Phase:
        - generated_from: "priority"
        - mapping: "priority: 'P1' → Phase 3: 'User Story 1'"
        - file: "tasks.md"
        - relationship: "Phase.user_story_ref → User_Story.id"
    
    - Tasks:
        - count: "5-15 个任务/故事"
        - types:
            - Test_Tasks: "T009, T010 [US1] (if tests requested)"
            - Model_Tasks: "T012 [US1] Create User model"
            - Service_Tasks: "T014 [US1] Implement AuthService.register()"
            - Endpoint_Tasks: "T015 [US1] Implement POST /register"
            - Validation_Tasks: "T016 [US1] Add validation"
            - Logging_Tasks: "T017 [US1] Add logging"
        - all_marked_with: "[US1]"
        - relationship: "Task.user_story_label → User_Story.id"
    
    - Checkpoint:
        - generated_from: "independent_test"
        - description: "At this point, User Story 1 should be fully functional and testable independently"
        - verification_criterion: "用户可以成功注册并收到确认邮件"

# 量化统计
quantified_impact:
  total_entities_driven: "~15 实体实例"
  breakdown:
    Specify_phase: "3-6 实体 (FRs, Entities, SCs)"
    Plan_phase: "4-8 实体 (Endpoints, Scenarios, Data Entities, Decisions)"
    Tasks_phase: "7-15 实体 (1 Phase + 5-15 Tasks)"
  
  files_affected: "5-7 文件"
  cross_stage_traceability: "100% (每个下游实体都可追溯回 User_Story)"
```

### 关系图示

```
User_Story (US1)
    │
    ├──[priority: P1]────────────────────→ Phase 3 (tasks.md)
    │                                           │
    │                                           └→ Tasks: T009-T017 [US1]
    │
    ├──[user_actions]─────────────────────→ API_Endpoints (contracts/)
    │   - "提交注册"                            │
    │                                           └→ POST /api/v1/auth/register
    │                                               └→ Task: T015 [US1]
    │
    ├──[acceptance_scenarios]─────────────→ Test_Scenarios (quickstart.md)
    │   - Scenario 1, 2                        │
    │                                           └→ TS-US1-001, TS-US1-002
    │                                               └→ Tasks: T009, T010 [US1]
    │
    ├──[related_entities]─────────────────→ Data_Entities (data-model.md)
    │   - "User"                               │
    │                                           └→ User entity + fields
    │                                               └→ Task: T012 [US1]
    │
    ├──[related_functional_requirements]──→ Validation_Rules
    │   - FR-002, FR-003                       │
    │                                           ├→ Data_Entity.validation_rules
    │                                           ├→ API_Endpoint.validation_rules
    │                                           └→ Tasks: T012, T016 [US1]
    │
    └──[independent_test]─────────────────→ Checkpoint (tasks.md)
        - "用户可以成功注册..."                └→ Phase 3 完成验证标准
```

### 使用场景

#### 场景 1: 查找某个用户故事的所有相关实现

```bash
# 在 tasks.md 中搜索
grep "\[US1\]" tasks.md

# 结果：所有标记为 US1 的任务
# T009 [P] [US1] Contract test...
# T010 [P] [US1] Integration test...
# T012 [P] [US1] Create User model...
# ...
```

#### 场景 2: 追溯某个 API 端点的来源

```yaml
# 在 contracts/auth.yaml 中查看
API_Endpoint:
  path: "/api/v1/auth/register"
  source_user_story: "US1"          # ← 追溯回 User_Story
  source_user_action: "提交注册"     # ← 具体的用户动作
```

#### 场景 3: 理解某个用户故事的测试覆盖

```yaml
# 在 quickstart.md 中查看
Test_Scenario:
  id: "TS-US1-001"
  source_user_story: "US1"                    # ← 来源
  source_acceptance_scenario: 1               # ← 对应第 1 个验收场景
  covers_functional_requirements: ["FR-001", "FR-002", "FR-003"]
```

### 最佳实践

1. **完整性检查**：确保每个 User_Story 都有：
   - ✅ 至少 1 个 API_Endpoint（来自 user_actions）
   - ✅ 至少 2 个 Test_Scenario（来自 acceptance_scenarios）
   - ✅ 至少 1 个 Data_Entity（来自 related_entities）
   - ✅ 5-15 个 Task（标记 [US#]）

2. **可追溯性检查**：所有下游实体都应该能追溯回 User_Story：
   - API_Endpoint.source_user_story = US1
   - Test_Scenario.source_user_story = US1
   - Data_Entity.related_user_stories 包含 US1
   - Task.user_story_label = [US1]

3. **影响分析**：当 User_Story 变化时，检查：
   - 相关的 Functional_Requirements 是否需要更新
   - API_Endpoints 是否需要调整
   - Test_Scenarios 是否需要补充
   - Tasks 是否需要增减

### Functional_Requirement（功能需求）

```yaml
Functional_Requirement:
  id: string                       # 标识符（FR-001, FR-002...）
  description: string              # 需求描述（MUST/SHOULD/MAY）
  testable: boolean                # 是否可测试
  needs_clarification: boolean     # 是否有 [NEEDS CLARIFICATION] 标记
  clarification_text: string       # 需要澄清的具体问题（如有）
  clarification_question: string   # 提给用户的问题（如有）
  
  # 关联关系
  related_user_stories: list       # 哪些用户故事需要这个需求
  impacts_entities: list           # 影响哪些实体
  category: enum                   # Data | Behavior | Security | Performance | Integration
```

**示例**：

```yaml
Functional_Requirement:
  id: "FR-002"
  description: "System MUST validate email addresses"
  testable: true
  needs_clarification: false
  related_user_stories: ["US1"]
  impacts_entities: ["User"]
  category: "Data"

Functional_Requirement:
  id: "FR-006"
  description: "System MUST authenticate users via [NEEDS CLARIFICATION: auth method not specified - email/password, SSO, OAuth?]"
  testable: true
  needs_clarification: true
  clarification_text: "auth method not specified - email/password, SSO, OAuth?"
  clarification_question: "Which authentication method should be used?"
  related_user_stories: ["US1", "US2"]
  category: "Security"
```

### Success_Criteria（成功标准）

```yaml
Success_Criteria:
  id: string                       # 标识符（SC-001, SC-002...）
  metric: string                   # 可衡量的结果
  measurable: boolean              # 必须为 true
  technology_agnostic: boolean     # 必须为 true（不含实现细节）
  metric_type: enum                # Quantitative | Qualitative
  
  # 具体指标
  target_value: string             # 目标值（如："3 minutes", "95%", "1000 users"）
  measurement_method: string       # 如何测量
  
  # 关联关系
  related_user_stories: list       # 影响哪些用户故事
```

**示例**：

```yaml
Success_Criteria:
  id: "SC-001"
  metric: "Users can complete registration in under 2 minutes"
  measurable: true
  technology_agnostic: true
  metric_type: "Quantitative"
  target_value: "< 2 minutes"
  measurement_method: "从访问注册页面到收到确认邮件的总时间"
  related_user_stories: ["US1"]
```

### Key_Entity（关键实体 - 概念层面）

```yaml
Key_Entity:
  name: string                     # 实体名称
  description: string              # 代表什么
  key_attributes: list             # 关键属性（概念层面，无类型）
    - attribute: string
      description: string
  relationships: list              # 与其他实体的关系（概念层面）
    - related_entity: string
      relationship_description: string  # 如："一个用户有多个订单"
  
  # 关联关系
  related_user_stories: list       # 哪些用户故事需要这个实体
  introduced_by_requirement: string  # 来自哪个功能需求
```

**示例**：

```yaml
Key_Entity:
  name: "User"
  description: "系统用户账户"
  key_attributes:
    - attribute: "邮箱"
      description: "用户的登录凭证"
    - attribute: "密码"
      description: "安全认证"
    - attribute: "用户名"
      description: "显示名称"
    - attribute: "注册时间"
      description: "账户创建时间"
  relationships:
    - related_entity: "Order"
      relationship_description: "一个用户可以有多个订单"
  related_user_stories: ["US1", "US2"]
  introduced_by_requirement: "FR-001"
```

### Edge_Case（边界情况）

```yaml
Edge_Case:
  scenario: string                 # 边界条件描述
  handling_requirement: string     # 如何处理
  severity: enum                   # Critical | High | Medium | Low
  related_user_stories: list       # 影响哪些用户故事
  related_functional_requirements: list  # 相关的功能需求
```

---

## 🏗️ Plan.md 的实体结构

**来源**：`templates/plan-template.md`

### Technical_Context（技术上下文）⭐

```yaml
Technical_Context:
  language_version: string         # 如 "Python 3.11", "Node.js 20", "Swift 5.9"
  primary_dependencies: list       # 主要框架和库
    - name: string
      version: string
      purpose: string
  storage: string                  # 如 "PostgreSQL", "MongoDB", "CoreData"
  testing_framework: string        # 如 "pytest", "Jest", "XCTest"
  target_platform: string          # 如 "Linux server", "iOS 15+", "Web Browser"
  project_type: enum               # single | web | mobile
  
  # 性能和约束
  performance_goals: string        # 如 "1000 req/s", "60 fps", "10k lines/sec"
  constraints: list                # 如 ["<200ms p95", "<100MB memory"]
  scale_scope: string              # 如 "10k users", "1M LOC", "50 screens"
  
  # 来源追溯
  derived_from_research: string    # 来自 research.md 的决策
```

### Constitution_Gate（宪法门禁）

```yaml
Constitution_Gate:
  gate_name: string                # 门禁名称（如 "Project Count Limit"）
  gate_rule: string                # 规则描述
  passed: boolean                  # 是否通过
  
  # 如果未通过
  violation: string                # 违规内容
  justification: string            # 违规理由（必须提供）
  simpler_alternative_rejected: string  # 为什么更简单的方案不可行
  
  checked_at_phase: enum           # Phase0 | Phase1
```

### Project_Structure（项目结构）

```yaml
Project_Structure:
  structure_type: enum             # single | web | mobile
  structure_decision: string       # 选择此结构的原因
  
  # 目录树
  directories: dict
    src:
      models: []
      services: []
      api: []
    tests:
      contract: []
      integration: []
      unit: []
    
  # 或 web 结构
  directories: dict
    backend:
      src: {...}
      tests: {...}
    frontend:
      src: {...}
      tests: {...}
```

---

## 📊 Research.md 的推断实体结构

**说明**：此文件无专用模板，但可从 plan 命令的逻辑推断其结构。

### Research_Decision（研究决策）⭐

```yaml
Research_Decision:
  topic: string                    # 研究主题（如 "Authentication Method"）
  decision: string                 # 最终决定（如 "JWT with OAuth2"）
  rationale: string                # 选择理由
  
  # 替代方案
  alternatives_considered: list
    - name: string
      pros: list
      cons: list
      rejection_reason: string
  
  # 来源追溯
  source_clarification: string     # 来自 spec.md 的哪个 NEEDS CLARIFICATION
  resolves_requirement: string     # 解决哪个功能需求（FR-XXX）
  related_functional_requirements: list
  
  # 影响
  impacts_technical_context: list  # 影响 plan.md 的哪些技术选择
  impacts_dependencies: list       # 引入哪些新依赖
```

**示例**：

```yaml
Research_Decision:
  topic: "Authentication Method"
  decision: "JWT with OAuth2 (Google + GitHub providers)"
  rationale: "Industry standard, supports social login, stateless, suitable for mobile API"
  alternatives_considered:
    - name: "Session-based authentication"
      pros: ["Simple to implement", "Well-known pattern"]
      cons: ["Stateful", "Not suitable for mobile apps"]
      rejection_reason: "Not suitable for RESTful API and mobile clients"
    - name: "API Keys"
      pros: ["Very simple"]
      cons: ["Less secure for user accounts", "No user context"]
      rejection_reason: "Inappropriate for user authentication"
  source_clarification: "FR-006: auth method not specified"
  resolves_requirement: "FR-006"
  related_functional_requirements: ["FR-001", "FR-006"]
  impacts_technical_context: ["primary_dependencies"]
  impacts_dependencies: ["python-jose[cryptography]", "authlib", "httpx"]
```

### Technology_Best_Practice（技术最佳实践）

```yaml
Technology_Best_Practice:
  technology: string               # 技术名称（如 "FastAPI"）
  domain: string                   # 应用领域（如 "REST API development"）
  best_practices: list             # 最佳实践列表
    - practice: string
      rationale: string
  patterns_to_use: list            # 推荐的设计模式
    - pattern: string
      use_case: string
  anti_patterns_to_avoid: list     # 要避免的反模式
    - anti_pattern: string
      why_avoid: string
  
  # 来源
  source: string                   # 如 "Official docs", "Industry standard"
```

---

## 💾 Data-Model.md 的推断实体结构

**说明**：此文件从 spec.md 的 Key_Entity 演进而来，添加技术实现细节。

### Data_Entity（数据实体）⭐

```yaml
Data_Entity:
  name: string                     # 实体名称
  source_key_entity: string        # 来自 spec.md 的哪个 Key_Entity
  description: string              # 实体描述
  
  # 字段定义
  fields: list
    - name: string
      type: string                 # 数据类型（如 "String", "Integer", "DateTime"）
      required: boolean
      default: any
      constraints: list            # 如 ["unique", "min_length: 8", "email_format"]
      description: string
      from_requirement: string     # 来自哪个 FR-XXX
  
  # 关系映射
  relationships: list
    - target_entity: string
      relationship_type: enum      # one_to_one | one_to_many | many_to_many
      foreign_key: string
      description: string
      cascade_behavior: string     # 如 "delete cascade"
  
  # 验证规则
  validation_rules: list
    - rule: string                 # 验证规则描述
      related_fr: string           # 关联的 FR-XXX
      error_message: string        # 验证失败时的错误消息
  
  # 状态机（如适用）
  state_transitions: list
    - from_state: string
      to_state: string
      trigger: string              # 触发条件
      conditions: list             # 前置条件
      actions: list                # 转换时的动作
  
  # 关联关系
  related_user_stories: list       # 哪些用户故事需要这个实体
  used_in_endpoints: list          # 哪些 API 端点使用此实体
  source_key_entity_attributes: dict  # 原 Key_Entity 的属性映射
```

**示例**：

```yaml
Data_Entity:
  name: "User"
  source_key_entity: "User"  # from spec.md
  description: "系统用户账户实体"
  fields:
    - name: "id"
      type: "UUID"
      required: true
      constraints: ["primary_key", "unique"]
      description: "用户唯一标识"
      from_requirement: null
    - name: "email"
      type: "String"
      required: true
      constraints: ["unique", "email_format", "max_length: 255"]
      description: "用户邮箱地址"
      from_requirement: "FR-002"
    - name: "password_hash"
      type: "String"
      required: true
      constraints: ["min_length: 60"]  # bcrypt hash length
      description: "密码哈希值"
      from_requirement: "FR-003"
    - name: "username"
      type: "String"
      required: true
      constraints: ["unique", "min_length: 3", "max_length: 50", "alphanumeric_underscore"]
      description: "用户显示名称"
      from_requirement: null
    - name: "created_at"
      type: "DateTime"
      required: true
      default: "now()"
      description: "账户创建时间"
      from_requirement: null
    - name: "is_verified"
      type: "Boolean"
      required: true
      default: false
      description: "邮箱是否已验证"
      from_requirement: null
  relationships:
    - target_entity: "Order"
      relationship_type: "one_to_many"
      foreign_key: "user_id"
      description: "一个用户可以有多个订单"
      cascade_behavior: "set_null"
  validation_rules:
    - rule: "Email must match RFC 5322 format"
      related_fr: "FR-002"
      error_message: "Invalid email format"
    - rule: "Email must be unique in database"
      related_fr: "FR-004"
      error_message: "Email already exists"
    - rule: "Password minimum 8 characters before hashing"
      related_fr: "FR-003"
      error_message: "Password too short"
  related_user_stories: ["US1", "US2"]
  used_in_endpoints: ["/api/v1/auth/register", "/api/v1/auth/login", "/api/v1/users/{id}"]
  source_key_entity_attributes:
    "邮箱": "email"
    "密码": "password_hash"
    "用户名": "username"
    "注册时间": "created_at"
```

---

## 🔌 Contracts/*.yaml 的推断实体结构

**说明**：使用 OpenAPI 3.0 或 GraphQL Schema 格式。

### API_Endpoint（API 端点）⭐

```yaml
API_Endpoint:
  id: string                       # 端点标识（如 "register_user"）
  path: string                     # URL 路径（如 "/api/v1/auth/register"）
  method: enum                     # GET | POST | PUT | DELETE | PATCH
  summary: string                  # 端点简述
  description: string              # 详细描述
  
  # 来源追溯
  source_user_story: string        # 来自哪个 User_Story（US1, US2...）
  source_user_action: string       # 来自用户故事中的哪个具体动作
  implements_requirements: list    # 实现哪些功能需求（FR-XXX）
  
  # 请求定义
  request_schema:
    content_type: string           # 如 "application/json"
    body_schema:                   # JSON Schema
      type: string
      required: list
      properties: dict
    parameters: list               # 路径/查询参数
      - name: string
        in: enum                   # path | query | header
        required: boolean
        schema: object
        description: string
    headers: list
      - name: string
        required: boolean
        description: string
  
  # 响应定义
  response_schema:
    status_codes: list
      - code: int                  # 如 200, 201, 400, 404
        description: string
        content_type: string
        schema: object             # JSON Schema
        related_requirement: string  # 如果状态码由某个 FR 驱动
  
  # 验证规则
  validation_rules: list
    - field: string                # 字段名
      rule: string                 # 验证规则（如 "required, email_format, unique"）
      error_code: int              # 错误码（如 400）
      error_message: string
      from_requirement: string     # 来自哪个 FR-XXX
  
  # 错误响应
  error_responses: list
    - status_code: int
      error_type: string           # 如 "ValidationError", "NotFoundError"
      description: string
      example: object
  
  # 关联关系
  related_data_entities: list      # 使用的数据实体
  related_functional_requirements: list
  security: list                   # 如 ["BearerAuth"]
  tags: list                       # 分组标签
```

**示例（OpenAPI 3.0 格式）**：

```yaml
API_Endpoint:
  id: "register_user"
  path: "/api/v1/auth/register"
  method: "POST"
  summary: "Register new user"
  description: "Create a new user account with email and password"
  source_user_story: "US1"
  source_user_action: "提交注册"
  implements_requirements: ["FR-001", "FR-002", "FR-003", "FR-004"]
  
  request_schema:
    content_type: "application/json"
    body_schema:
      type: "object"
      required: ["email", "password", "username"]
      properties:
        email:
          type: "string"
          format: "email"
          description: "User email address (FR-002)"
        password:
          type: "string"
          minLength: 8
          description: "User password (FR-003)"
        username:
          type: "string"
          minLength: 3
          maxLength: 50
          description: "User display name"
    parameters: []
    headers: []
  
  response_schema:
    status_codes:
      - code: 201
        description: "User created successfully"
        content_type: "application/json"
        schema:
          type: "object"
          properties:
            user_id: {type: "string", format: "uuid"}
            email: {type: "string"}
            username: {type: "string"}
            message: {type: "string"}
      - code: 400
        description: "Invalid input"
        related_requirement: "FR-002, FR-003"
      - code: 409
        description: "Email already exists"
        related_requirement: "FR-004"
  
  validation_rules:
    - field: "email"
      rule: "required, email_format, unique"
      error_code: 400
      error_message: "Invalid or duplicate email"
      from_requirement: "FR-002, FR-004"
    - field: "password"
      rule: "required, min_length: 8"
      error_code: 400
      error_message: "Password too short"
      from_requirement: "FR-003"
  
  error_responses:
    - status_code: 400
      error_type: "ValidationError"
      description: "Request validation failed"
      example:
        error: "ValidationError"
        message: "Invalid email format"
        field: "email"
    - status_code: 409
      error_type: "ConflictError"
      description: "Email already in use"
      example:
        error: "ConflictError"
        message: "Email already exists"
        field: "email"
  
  related_data_entities: ["User"]
  related_functional_requirements: ["FR-001", "FR-002", "FR-003", "FR-004"]
  security: []  # 注册端点通常不需要认证
  tags: ["Authentication"]
```

---

## 🧪 Quickstart.md 的推断实体结构

### Test_Scenario（测试场景）⭐

```yaml
Test_Scenario:
  id: string                       # 如 "TS-US1-001"
  source_user_story: string        # 来自哪个 User_Story（US1, US2...）
  source_acceptance_scenario: int  # 来自该故事的第几个 Acceptance Scenario
  title: string                    # 场景标题
  description: string              # 场景描述
  
  # 测试步骤
  preconditions: list              # 前置条件
    - condition: string
      setup_action: string         # 如何准备
  
  steps: list                      # 测试步骤
    - step_number: int
      action: string               # 要执行的动作
      expected_result: string      # 预期结果
      api_call: string             # 涉及的 API 端点（如果有）
      api_method: string           # HTTP 方法
      api_request_example: object  # 请求示例
      api_response_example: object # 响应示例
  
  postconditions: list             # 后置条件
    - condition: string
      verification_method: string  # 如何验证
  
  # 数据准备
  data_setup: string               # 数据准备说明
  test_data: dict                  # 测试数据示例
  cleanup: string                  # 清理说明
  
  # 关联关系
  covers_functional_requirements: list  # 覆盖哪些 FR-XXX
  uses_endpoints: list             # 使用哪些 API 端点
  depends_on_scenarios: list       # 依赖其他场景（如果有）
```

**示例**：

```yaml
Test_Scenario:
  id: "TS-US1-001"
  source_user_story: "US1"
  source_acceptance_scenario: 1
  title: "成功注册新用户"
  description: "验证新用户可以使用有效的邮箱和密码成功注册"
  
  preconditions:
    - condition: "数据库为空或邮箱 'test@example.com' 不存在"
      setup_action: "如果存在，删除 email='test@example.com' 的用户记录"
  
  steps:
    - step_number: 1
      action: "发送注册请求"
      expected_result: "返回 201 Created 状态码"
      api_call: "/api/v1/auth/register"
      api_method: "POST"
      api_request_example:
        email: "test@example.com"
        password: "SecurePass123"
        username: "testuser"
      api_response_example:
        user_id: "123e4567-e89b-12d3-a456-426614174000"
        email: "test@example.com"
        username: "testuser"
        message: "User created successfully"
    
    - step_number: 2
      action: "检查数据库"
      expected_result: "用户记录存在"
      api_call: null
    
    - step_number: 3
      action: "检查邮件队列"
      expected_result: "确认邮件已发送"
      api_call: null
  
  postconditions:
    - condition: "用户记录存在于数据库"
      verification_method: "查询数据库 email='test@example.com'"
    - condition: "确认邮件在邮件队列中"
      verification_method: "检查邮件队列是否包含发送给 'test@example.com' 的邮件"
  
  data_setup: "确保测试邮箱不存在于数据库中"
  test_data:
    email: "test@example.com"
    password: "SecurePass123"
    username: "testuser"
  cleanup: "测试后删除创建的用户记录和邮件队列条目"
  
  covers_functional_requirements: ["FR-001", "FR-002", "FR-003"]
  uses_endpoints: ["/api/v1/auth/register"]
  depends_on_scenarios: []
```

### Environment_Setup（环境设置）

```yaml
Environment_Setup:
  dependencies: list               # 环境依赖
    - name: string
      version: string
      installation_command: string
  
  configuration: dict              # 配置项
    database:
      type: string
      connection_string: string
    email:
      provider: string
      test_mode: boolean
    
  initialization_steps: list       # 初始化步骤
    - step: string
      command: string
```

---

## ✅ Tasks.md 的实体结构

**来源**：`templates/tasks-template.md`

### Phase（任务执行阶段）⭐

```yaml
Phase:
  number: int                      # 阶段编号（1, 2, 3...）
  type: enum                       # Setup | Foundational | UserStory | Polish
  name: string                     # 阶段名称
  user_story_ref: string           # 如果是 UserStory 类型，关联的 US1/US2/US3
  user_story_priority: string      # 用户故事的优先级（P1, P2, P3...）
  
  # 阶段目标
  goal: string                     # 阶段目标描述
  independent_test: string         # 如何独立测试这个阶段（UserStory 类型）
  checkpoint_description: string   # 阶段完成检查点
  
  # 依赖和阻塞
  blocking: boolean                # 是否阻塞后续阶段（Foundational=true）
  depends_on_phases: list          # 依赖的阶段编号
  
  # 任务列表
  tasks: list                      # 任务 ID 列表（Task 实体）
  task_count: int                  # 任务数量
  parallel_task_count: int         # 可并行任务数量
```

**示例**：

```yaml
Phase:
  number: 3
  type: "UserStory"
  name: "User Story 1 - 用户注册"
  user_story_ref: "US1"
  user_story_priority: "P1"
  goal: "实现用户注册功能"
  independent_test: "用户可以成功注册并收到确认邮件"
  checkpoint_description: "At this point, User Story 1 should be fully functional and testable independently"
  blocking: false
  depends_on_phases: [2]  # 依赖 Foundational phase
  tasks: ["T008", "T009", "T010", "T011", "T012", "T013", "T014"]
  task_count: 7
  parallel_task_count: 3  # T008, T009, T010 可并行
```

### Task（可执行任务）⭐

```yaml
Task:
  id: string                       # 任务标识（T001, T002, T003...）
  phase_number: int                # 所属阶段编号
  phase_type: enum                 # Setup | Foundational | UserStory | Polish
  user_story_label: string         # 用户故事标签（[US1]/[US2]/[US3]，仅 UserStory 阶段）
  
  # 并行能力
  is_parallel: boolean             # 是否可并行执行（[P]标记）
  
  # 任务描述
  description: string              # 任务描述
  file_path: string                # 具体文件路径（必须包含）
  task_type: enum                  # Model | Service | Endpoint | Test | Config | Doc | Validation | Logging
  
  # 依赖关系
  depends_on_tasks: list           # 依赖的任务 IDs
  blocks_tasks: list               # 阻塞的任务 IDs
  
  # 来源追溯
  related_entities: list           # 关联的数据实体（来自 data-model.md）
  related_endpoints: list          # 关联的 API 端点（来自 contracts/）
  related_functional_requirements: list  # 满足的功能需求（来自 spec.md）
  related_test_scenarios: list     # 关联的测试场景（来自 quickstart.md）
  
  # 实施细节
  estimated_complexity: enum       # Simple | Medium | Complex
  implementation_notes: string     # 实施注意事项（可选）
  
  # 状态
  completed: boolean               # 是否完成（checkbox 状态）
```

**示例**：

```yaml
Task:
  id: "T012"
  phase_number: 3
  phase_type: "UserStory"
  user_story_label: "US1"
  is_parallel: true  # [P] 标记
  description: "Create User model in src/models/user.py"
  file_path: "src/models/user.py"
  task_type: "Model"
  depends_on_tasks: []  # 无依赖，可以并行
  blocks_tasks: ["T014"]  # 阻塞 AuthService 实现
  related_entities: ["User"]
  related_endpoints: ["/api/v1/auth/register", "/api/v1/auth/login"]
  related_functional_requirements: ["FR-001", "FR-002", "FR-003", "FR-004"]
  related_test_scenarios: []
  estimated_complexity: "Medium"
  implementation_notes: "Include validation rules from FR-002, FR-003, FR-004"
  completed: false
```

### Dependency_Graph（依赖关系图）

```yaml
Dependency_Graph:
  # 阶段间依赖
  phase_dependencies: dict
    1: []                          # Setup 无依赖
    2: [1]                         # Foundational 依赖 Setup
    3: [2]                         # US1 依赖 Foundational
    4: [2]                         # US2 依赖 Foundational（独立于 US1）
    5: [2]                         # US3 依赖 Foundational（独立于 US1, US2）
  
  # 用户故事间依赖
  story_dependencies: dict
    US1: []                        # 独立
    US2: []                        # 独立（可能集成 US1 但应可独立测试）
    US3: []                        # 独立
  
  # 任务间依赖
  task_dependencies: dict
    T001: []
    T002: ["T001"]
    T010: []                       # User model 无依赖
    T011: ["T010"]                 # AuthService 依赖 User model
    T012: ["T011"]                 # Endpoint 依赖 AuthService
```

### Parallel_Execution_Group（并行执行组）

```yaml
Parallel_Execution_Group:
  group_id: string                 # 如 "US1-Tests", "US1-Models"
  group_name: string               # 组名称
  user_story: string               # 所属用户故事（如果适用）
  phase_number: int                # 所属阶段
  
  task_ids: list                   # 可并行的任务 IDs
  execution_command: string        # 执行命令示例（给 AI agent）
  
  prerequisites: list              # 前置条件（哪些任务必须先完成）
```

**示例**：

```yaml
Parallel_Execution_Group:
  group_id: "US1-Models"
  group_name: "User Story 1 - Model Creation"
  user_story: "US1"
  phase_number: 3
  task_ids: ["T010", "T012"]
  execution_command: |
    Task: "Create User model in src/models/user.py"
    Task: "Create Profile model in src/models/profile.py"
  prerequisites: []  # 这组任务无前置条件
```

---

## 📊 实体间的关键关系

### 核心关系链

```
User_Story (spec.md)
  ├─→ user_actions
  │     └─→ API_Endpoint (contracts/*.yaml)
  │           └─→ Task (tasks.md, task_type: Endpoint)
  │
  ├─→ acceptance_scenarios
  │     └─→ Test_Scenario (quickstart.md)
  │           └─→ Task (tasks.md, task_type: Test)
  │
  └─→ related_entities
        └─→ Data_Entity (data-model.md)
              └─→ Task (tasks.md, task_type: Model)
```

### 优先级驱动

```
User_Story.priority (P1, P2, P3...)
  └─→ Phase.number in tasks.md
        └─→ 决定实施顺序和 MVP 范围
```

### 需求追溯

```
Functional_Requirement (spec.md)
  ├─→ Data_Entity.validation_rules (data-model.md)
  ├─→ API_Endpoint.validation_rules (contracts/*.yaml)
  └─→ Task.related_functional_requirements (tasks.md)
```

---

**下一步**：查看 [03-correlation-chains.md](./03-correlation-chains.md) 了解这些实体如何在各阶段演进。

