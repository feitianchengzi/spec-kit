# 完整示例：用户认证系统

本文档通过一个完整的用户认证系统示例，展示从用户需求到可执行任务的完整演进过程。

---

## 📝 场景描述

**用户需求**：

> "我想要一个用户认证系统，用户可以注册账户、登录系统，以及重置忘记的密码。"

**项目背景**：
- Web 应用后端 API
- 需要支持移动端
- 预计用户量 10,000+

---

## 🎯 阶段 1: Specify 命令输出

### 输入命令

```bash
cd /path/to/project
/speckit.specify "我想要一个用户认证系统，用户可以注册账户、登录系统，以及重置忘记的密码"
```

### 生成的 spec.md

```markdown
# Feature Specification: User Authentication System

**Feature Branch**: `001-user-auth`  
**Created**: 2025-11-12  
**Status**: Draft  
**Input**: User description: "我想要一个用户认证系统，用户可以注册账户、登录系统，以及重置忘记的密码"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - 用户注册 (Priority: P1)

新用户可以通过提供邮箱和密码创建账户，并收到确认邮件。

**Why this priority**: 这是系统的基础功能，没有注册就无法使用任何其他功能。用户注册是 MVP 的核心。

**Independent Test**: 用户可以成功注册并收到确认邮件。可以独立测试注册流程而不依赖登录或其他功能。

**Acceptance Scenarios**:

1. **Given** 新用户访问注册页面，**When** 填写有效的邮箱和密码（至少 8 个字符）并提交，**Then** 账户创建成功，用户收到确认邮件，系统返回成功消息
2. **Given** 用户尝试使用已存在的邮箱注册，**When** 提交注册表单，**Then** 系统显示错误提示："该邮箱已被使用"，不创建重复账户
3. **Given** 用户输入无效的邮箱格式，**When** 提交注册表单，**Then** 系统显示错误提示："邮箱格式无效"

---

### User Story 2 - 用户登录 (Priority: P2)

已注册用户可以使用邮箱和密码登录系统，获得访问令牌。

**Why this priority**: 登录是注册后的自然下一步，是访问系统功能的必要条件。

**Independent Test**: 已注册用户可以成功登录并使用令牌访问受保护的资源。

**Acceptance Scenarios**:

1. **Given** 已注册用户访问登录页面，**When** 输入正确的邮箱和密码，**Then** 成功登录，系统返回访问令牌
2. **Given** 用户输入错误的密码，**When** 尝试登录，**Then** 系统显示错误提示："邮箱或密码错误"，不透露具体是哪个错误
3. **Given** 用户输入不存在的邮箱，**When** 尝试登录，**Then** 系统显示错误提示："邮箱或密码错误"

---

### User Story 3 - 密码重置 (Priority: P3)

忘记密码的用户可以通过邮件重置密码。

**Why this priority**: 密码重置是增强用户体验的功能，但不是 MVP 的必需功能。用户可以联系支持或重新注册。

**Independent Test**: 用户可以通过邮件链接成功重置密码，并使用新密码登录。

**Acceptance Scenarios**:

1. **Given** 用户忘记密码，**When** 在重置页面输入注册邮箱并提交，**Then** 系统发送重置链接到该邮箱
2. **Given** 用户收到重置链接，**When** 点击链接并输入新密码（至少 8 个字符），**Then** 密码更新成功，用户可以使用新密码登录
3. **Given** 用户使用过期的重置链接，**When** 尝试重置密码，**Then** 系统显示错误提示："重置链接已过期，请重新请求"

---

### Edge Cases

- **连续失败登录**：用户连续 5 次登录失败后，账户临时锁定 15 分钟，防止暴力破解
- **重置链接有效期**：密码重置链接 1 小时后过期，确保安全性
- **并发注册**：两个用户同时使用相同邮箱注册时，系统正确处理，只允许一个成功
- **邮件发送失败**：如果邮件服务不可用，系统记录错误日志，并在后台重试发送

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: 系统必须允许用户通过邮箱和密码创建账户
- **FR-002**: 系统必须验证邮箱地址格式（符合 RFC 5322 标准）
- **FR-003**: 密码必须至少包含 8 个字符
- **FR-004**: 系统必须防止重复邮箱注册（邮箱唯一性）
- **FR-005**: 系统必须使用安全哈希算法存储密码（不存储明文密码）
- **FR-006**: 用户注册成功后，系统必须发送确认邮件
- **FR-007**: 系统必须在用户登录成功后返回访问令牌
- **FR-008**: 系统必须验证登录凭证，并在凭证错误时返回模糊错误消息（不透露是邮箱还是密码错误）
- **FR-009**: 系统必须提供密码重置功能，通过邮件发送重置链接
- **FR-010**: 密码重置链接必须在 1 小时后过期

### Key Entities *(include if feature involves data)*

- **User**: 代表系统用户账户，包含邮箱、密码（哈希存储）、用户名、注册时间、账户状态（活跃/锁定）
- **PasswordResetToken**: 代表密码重置令牌，包含令牌值、关联用户、创建时间、过期时间、是否已使用

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: 用户可以在 2 分钟内完成注册流程（从访问注册页面到收到确认邮件）
- **SC-002**: 系统支持 1000 个并发用户同时注册或登录，响应时间不超过 1 秒
- **SC-003**: 90% 的用户在首次尝试时成功完成注册
- **SC-004**: 密码存储使用行业标准哈希算法（如 bcrypt），通过安全审计
```

### 生成的 checklists/requirements.md

```markdown
# Specification Quality Checklist: User Authentication System

**Purpose**: Validate specification completeness and quality before proceeding to planning
**Created**: 2025-11-12
**Feature**: [Link to spec.md](../spec.md)

## Content Quality

- [x] No implementation details (languages, frameworks, APIs)
- [x] Focused on user value and business needs
- [x] Written for non-technical stakeholders
- [x] All mandatory sections completed

## Requirement Completeness

- [x] No [NEEDS CLARIFICATION] markers remain
- [x] Requirements are testable and unambiguous
- [x] Success criteria are measurable
- [x] Success criteria are technology-agnostic (no implementation details)
- [x] All acceptance scenarios are defined
- [x] Edge cases are identified
- [x] Scope is clearly bounded
- [x] Dependencies and assumptions identified

## Feature Readiness

- [x] All functional requirements have clear acceptance criteria
- [x] User scenarios cover primary flows
- [x] Feature meets measurable outcomes defined in Success Criteria
- [x] No implementation details leak into specification

## Notes

✓ Specification is ready for planning phase (`/speckit.plan`)
```

---

## 🏗️ 阶段 2: Plan 命令输出

### 输入命令

```bash
/speckit.plan
```

### 生成的 plan.md

```markdown
# Implementation Plan: User Authentication System

**Branch**: `001-user-auth` | **Date**: 2025-11-12 | **Spec**: [link](spec.md)
**Input**: Feature specification from `/specs/001-user-auth/spec.md`

## Summary

Implement a user authentication system supporting registration, login, and password reset. 
Technical approach: RESTful API with JWT authentication, PostgreSQL storage, and bcrypt password hashing.

## Technical Context

**Language/Version**: Python 3.11  
**Primary Dependencies**: FastAPI 0.104+, SQLAlchemy 2.0+, python-jose[cryptography], bcrypt, httpx  
**Storage**: PostgreSQL 15+  
**Testing**: pytest, pytest-asyncio  
**Target Platform**: Linux server (Docker containerized)  
**Project Type**: Single (Backend API)  
**Performance Goals**: 1000 req/s, < 1s response time for auth operations  
**Constraints**: < 200ms p95 latency, < 512MB memory per container  
**Scale/Scope**: 10,000+ users, 3 main endpoints (register, login, reset)

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

### Project Count Check
- **Current**: 1 project (Backend API)
- **Limit**: ≤ 3 projects
- **Status**: ✓ PASS

### Architecture Patterns Check
- **Repository Pattern**: Not used (direct SQLAlchemy models)
- **Service Layer**: Used (AuthService)
- **Status**: ✓ PASS (Appropriate for project size)

### Complexity Check
- **Endpoints**: 3 main endpoints
- **Entities**: 2 entities (User, PasswordResetToken)
- **Dependencies**: 5 primary dependencies
- **Status**: ✓ PASS (Complexity appropriate for feature scope)

## Project Structure

### Documentation (this feature)

```
specs/001-user-auth/
├── spec.md              # Feature specification
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
│   └── auth.yaml        # API contract
└── tasks.md             # Phase 2 output (generated by /speckit.tasks)
```

### Source Code (repository root)

```
src/
├── models/
│   ├── __init__.py
│   ├── user.py
│   └── password_reset_token.py
├── services/
│   ├── __init__.py
│   ├── auth_service.py
│   └── email_service.py
├── api/
│   ├── __init__.py
│   └── v1/
│       ├── __init__.py
│       └── auth.py
├── middleware/
│   ├── __init__.py
│   └── jwt_auth.py
└── utils/
    ├── __init__.py
    └── validators.py

tests/
├── contract/
│   └── test_auth_contract.py
├── integration/
│   ├── test_user_registration.py
│   ├── test_user_login.py
│   └── test_password_reset.py
└── unit/
    ├── test_auth_service.py
    └── test_validators.py
```

**Structure Decision**: Single project structure chosen because:
- Backend API only (no frontend in this feature)
- Simple service layer without microservices complexity
- All components in one deployable unit

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

_No violations - this section is empty._
```

### 生成的 research.md

```markdown
# Research Decisions: User Authentication System

**Feature**: 001-user-auth  
**Phase**: Phase 0 (Research)  
**Date**: 2025-11-12

## Decision 1: Password Hashing Algorithm

**Topic**: Secure password storage

**Decision**: Use bcrypt with cost factor 12

**Rationale**:
- Industry standard for password hashing
- Adaptive cost factor (can increase as hardware improves)
- Built-in salt generation
- Resistant to rainbow table attacks
- Cost factor 12 provides good balance between security and performance

**Alternatives Considered**:
1. **PBKDF2**
   - Pros: NIST recommended, well-tested
   - Cons: Less resistant to GPU attacks compared to bcrypt
   - Rejection reason: bcrypt better for password hashing specifically

2. **Argon2**
   - Pros: Newer, winner of Password Hashing Competition
   - Cons: Less mature ecosystem, requires additional dependencies
   - Rejection reason: bcrypt sufficient for current scale, wider adoption

**Impacts**:
- Dependencies: Add `bcrypt` library
- Models: `User.password_hash` field (String, 60 chars for bcrypt output)
- Service: `AuthService.hash_password()` and `verify_password()` methods

---

## Decision 2: Token-based Authentication

**Topic**: User session management

**Decision**: JWT (JSON Web Tokens) with HS256 algorithm

**Rationale**:
- Stateless authentication (no server-side session storage)
- Suitable for API and mobile clients
- Self-contained (includes user ID and claims)
- Industry standard (RFC 7519)
- Good library support (python-jose)

**Alternatives Considered**:
1. **Session-based (cookies)**
   - Pros: Simple, well-understood
   - Cons: Stateful (requires session store), not ideal for mobile apps
   - Rejection reason: Project requires mobile support, stateless preferred

2. **OAuth2 with third-party providers**
   - Pros: Offload authentication to Google/GitHub
   - Cons: Requires user to have third-party account, more complex setup
   - Rejection reason: Feature requires email/password authentication, OAuth2 can be added later

**Impacts**:
- Dependencies: Add `python-jose[cryptography]`
- Middleware: JWT validation middleware
- Service: Token generation in `AuthService.login()`
- Configuration: Secret key for JWT signing (environment variable)

---

## Decision 3: Email Delivery

**Topic**: Sending confirmation and reset emails

**Decision**: Async email sending with retry mechanism using background tasks

**Rationale**:
- Email sending should not block HTTP response
- Failures should be retried (email service may be temporarily unavailable)
- Use FastAPI background tasks for simplicity
- SMTP for email delivery (configurable provider)

**Alternatives Considered**:
1. **Synchronous email sending**
   - Pros: Simpler implementation
   - Cons: Blocks request, poor user experience if email service is slow
   - Rejection reason: Response time requirement (< 1s)

2. **Message queue (Celery/RabbitMQ)**
   - Pros: Robust, handles retries well
   - Cons: Additional infrastructure, overkill for current scale
   - Rejection reason: Background tasks sufficient for 10K users

**Impacts**:
- Dependencies: Add `httpx` (for async HTTP if using HTTP-based email service)
- Service: `EmailService` with async send methods
- API: Use FastAPI `BackgroundTasks` in endpoints
- Configuration: SMTP settings (host, port, credentials)

---

## Decision 4: Password Reset Token Generation

**Topic**: Secure password reset mechanism

**Decision**: Cryptographically secure random tokens with 1-hour expiration

**Rationale**:
- Use `secrets.token_urlsafe()` for secure random tokens
- Store token in database with expiration timestamp
- Token is single-use (marked as used after successful reset)
- 1-hour expiration balances security and user convenience

**Impacts**:
- Models: `PasswordResetToken` entity
- Service: Token generation and validation in `AuthService`
- Database: Index on token for fast lookup

---

## Summary

All research decisions are complete. No unresolved [NEEDS CLARIFICATION] markers remain.

Ready for Phase 1 (Design).
```

### 生成的 data-model.md

```markdown
# Data Model: User Authentication System

**Feature**: 001-user-auth  
**Phase**: Phase 1 (Design)  
**Date**: 2025-11-12

## Entity: User

**Source**: Key Entity "User" from spec.md  
**Related User Stories**: US1 (Registration), US2 (Login)

### Fields

| Field         | Type      | Required | Constraints                     | From Requirement | Description                          |
|---------------|-----------|----------|---------------------------------|------------------|--------------------------------------|
| id            | UUID      | Yes      | Primary key, unique             | -                | 用户唯一标识                         |
| email         | String    | Yes      | Unique, email format, max 255   | FR-002, FR-004   | 用户邮箱地址                         |
| password_hash | String    | Yes      | Fixed length 60 (bcrypt)        | FR-003, FR-005   | 密码哈希值（bcrypt, cost factor 12） |
| username      | String    | Yes      | Unique, 3-50 chars              | -                | 用户显示名称                         |
| created_at    | DateTime  | Yes      | Auto-generated (UTC)            | -                | 账户创建时间                         |
| is_verified   | Boolean   | Yes      | Default: false                  | -                | 邮箱是否已验证                       |
| is_locked     | Boolean   | Yes      | Default: false                  | Edge case        | 账户是否锁定（失败登录保护）         |
| locked_until  | DateTime  | No       | Nullable                        | Edge case        | 账户锁定到什么时间                   |
| login_attempts| Integer   | Yes      | Default: 0                      | Edge case        | 连续失败登录次数                     |

### Relationships

- **One-to-many with PasswordResetToken**: 一个用户可以有多个重置令牌（历史记录）
  - Foreign key: `PasswordResetToken.user_id`
  - Cascade: Delete cascade (删除用户时删除关联令牌)

### Validation Rules

| Rule | Related FR | Error Message |
|------|------------|---------------|
| Email must match RFC 5322 format | FR-002 | "Invalid email format" |
| Email must be unique in database | FR-004 | "Email already exists" |
| Password minimum 8 characters (before hashing) | FR-003 | "Password must be at least 8 characters" |
| Username 3-50 characters, alphanumeric + underscore | - | "Username must be 3-50 characters" |

### Indexes

- `email` (unique index) - for fast lookup and uniqueness constraint
- `username` (unique index) - for fast lookup and uniqueness constraint

### Used In

- **User Stories**: US1 (Registration), US2 (Login), US3 (Password Reset)
- **Endpoints**: 
  - `/api/v1/auth/register` (create)
  - `/api/v1/auth/login` (read)
  - `/api/v1/auth/reset-request` (read)
  - `/api/v1/auth/reset-confirm` (update)

---

## Entity: PasswordResetToken

**Source**: Key Entity "PasswordResetToken" from spec.md  
**Related User Stories**: US3 (Password Reset)

### Fields

| Field      | Type      | Required | Constraints                  | From Requirement | Description                |
|------------|-----------|----------|------------------------------|------------------|----------------------------|
| id         | UUID      | Yes      | Primary key, unique          | -                | 令牌唯一标识               |
| token      | String    | Yes      | Unique, length 32 (urlsafe)  | FR-009           | 重置令牌值                 |
| user_id    | UUID      | Yes      | Foreign key to User          | FR-009           | 关联用户                   |
| created_at | DateTime  | Yes      | Auto-generated (UTC)         | -                | 令牌创建时间               |
| expires_at | DateTime  | Yes      | created_at + 1 hour          | FR-010           | 令牌过期时间               |
| used_at    | DateTime  | No       | Nullable                     | -                | 令牌使用时间（单次使用）   |
| is_used    | Boolean   | Yes      | Default: false               | -                | 令牌是否已使用             |

### Relationships

- **Many-to-one with User**: 多个令牌属于一个用户
  - Foreign key: `user_id`
  - References: `User.id`

### Validation Rules

| Rule | Related FR | Error Message |
|------|------------|---------------|
| Token must be unique | FR-009 | "Token generation error" |
| Token must expire 1 hour after creation | FR-010 | "Reset link has expired" |
| Token can only be used once | FR-009 | "Reset link already used" |

### Indexes

- `token` (unique index) - for fast lookup during reset
- `user_id, created_at` (composite index) - for querying user's recent tokens

### Used In

- **User Stories**: US3 (Password Reset)
- **Endpoints**: 
  - `/api/v1/auth/reset-request` (create)
  - `/api/v1/auth/reset-confirm` (read, update)

---

## Database Schema (SQL DDL Example)

```sql
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(60) NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    is_verified BOOLEAN NOT NULL DEFAULT FALSE,
    is_locked BOOLEAN NOT NULL DEFAULT FALSE,
    locked_until TIMESTAMP WITH TIME ZONE,
    login_attempts INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE password_reset_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    token VARCHAR(32) UNIQUE NOT NULL,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    is_used BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE INDEX idx_password_reset_tokens_user_created 
    ON password_reset_tokens(user_id, created_at);
```
```

### 生成的 contracts/auth.yaml

```yaml
openapi: 3.0.0
info:
  title: User Authentication API
  version: 1.0.0
  description: API contracts for user authentication system

paths:
  /api/v1/auth/register:
    post:
      summary: Register new user
      description: Create a new user account with email and password
      operationId: registerUser
      tags:
        - Authentication
      x-source-user-story: US1
      x-source-user-action: "提交注册"
      x-implements-requirements:
        - FR-001
        - FR-002
        - FR-003
        - FR-004
        - FR-005
        - FR-006
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
                - username
              properties:
                email:
                  type: string
                  format: email
                  maxLength: 255
                  description: "User email address (FR-002)"
                  example: "user@example.com"
                password:
                  type: string
                  minLength: 8
                  description: "User password, minimum 8 characters (FR-003)"
                  example: "SecurePass123"
                username:
                  type: string
                  minLength: 3
                  maxLength: 50
                  pattern: "^[a-zA-Z0-9_]+$"
                  description: "User display name"
                  example: "johndoe"
      responses:
        '201':
          description: User created successfully
          content:
            application/json:
              schema:
                type: object
                properties:
                  user_id:
                    type: string
                    format: uuid
                    example: "123e4567-e89b-12d3-a456-426614174000"
                  email:
                    type: string
                    example: "user@example.com"
                  username:
                    type: string
                    example: "johndoe"
                  message:
                    type: string
                    example: "User created successfully. Please check your email for verification."
        '400':
          description: Invalid input (validation error)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              examples:
                invalidEmail:
                  value:
                    error: "ValidationError"
                    message: "Invalid email format"
                    field: "email"
                shortPassword:
                  value:
                    error: "ValidationError"
                    message: "Password must be at least 8 characters"
                    field: "password"
        '409':
          description: Email already exists (FR-004)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              example:
                error: "ConflictError"
                message: "Email already exists"
                field: "email"
        '500':
          description: Internal server error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /api/v1/auth/login:
    post:
      summary: User login
      description: Authenticate user and return JWT token
      operationId: loginUser
      tags:
        - Authentication
      x-source-user-story: US2
      x-source-user-action: "登录提交"
      x-implements-requirements:
        - FR-007
        - FR-008
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
                - password
              properties:
                email:
                  type: string
                  format: email
                  example: "user@example.com"
                password:
                  type: string
                  example: "SecurePass123"
      responses:
        '200':
          description: Login successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  access_token:
                    type: string
                    description: "JWT access token (FR-007)"
                    example: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
                  token_type:
                    type: string
                    example: "bearer"
                  expires_in:
                    type: integer
                    description: "Token expiration in seconds"
                    example: 3600
        '401':
          description: Invalid credentials (FR-008 - ambiguous error message)
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              example:
                error: "AuthenticationError"
                message: "Invalid email or password"
        '423':
          description: Account locked due to too many failed attempts
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              example:
                error: "AccountLockedError"
                message: "Account temporarily locked. Please try again in 15 minutes."
                locked_until: "2025-11-12T10:45:00Z"

  /api/v1/auth/reset-request:
    post:
      summary: Request password reset
      description: Send password reset email to user
      operationId: requestPasswordReset
      tags:
        - Authentication
      x-source-user-story: US3
      x-source-user-action: "请求重置密码"
      x-implements-requirements:
        - FR-009
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - email
              properties:
                email:
                  type: string
                  format: email
                  example: "user@example.com"
      responses:
        '200':
          description: Reset email sent (always returns success for security)
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: "If the email exists, a password reset link has been sent."
        '400':
          description: Invalid email format
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /api/v1/auth/reset-confirm:
    post:
      summary: Confirm password reset
      description: Reset password using token from email
      operationId: confirmPasswordReset
      tags:
        - Authentication
      x-source-user-story: US3
      x-source-user-action: "确认新密码"
      x-implements-requirements:
        - FR-009
        - FR-010
      requestBody:
        required: true
        content:
          application/json:
            schema:
              type: object
              required:
                - token
                - new_password
              properties:
                token:
                  type: string
                  description: "Reset token from email"
                  example: "abc123def456..."
                new_password:
                  type: string
                  minLength: 8
                  description: "New password, minimum 8 characters"
                  example: "NewSecurePass456"
      responses:
        '200':
          description: Password reset successful
          content:
            application/json:
              schema:
                type: object
                properties:
                  message:
                    type: string
                    example: "Password reset successfully. You can now login with your new password."
        '400':
          description: Invalid token or password
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'
              examples:
                expiredToken:
                  value:
                    error: "ValidationError"
                    message: "Reset link has expired. Please request a new one."
                usedToken:
                  value:
                    error: "ValidationError"
                    message: "Reset link已经被使用. Please request a new one."
                invalidToken:
                  value:
                    error: "ValidationError"
                    message: "Invalid reset link."

components:
  schemas:
    Error:
      type: object
      properties:
        error:
          type: string
          description: "Error type"
        message:
          type: string
          description: "Human-readable error message"
        field:
          type: string
          description: "Field that caused the error (optional)"
```

### 生成的 quickstart.md

```markdown
# Quickstart Guide: User Authentication System

**Feature**: 001-user-auth  
**Purpose**: Test scenarios for validating authentication functionality

## Environment Setup

### Prerequisites

```bash
# Python 3.11+
python --version

# PostgreSQL 15+
psql --version

# Install dependencies
pip install -r requirements.txt

# Set environment variables
export DATABASE_URL="postgresql://user:pass@localhost/auth_db"
export JWT_SECRET="your-secret-key-here"
export SMTP_HOST="smtp.example.com"
export SMTP_PORT="587"
export SMTP_USER="noreply@example.com"
export SMTP_PASSWORD="smtp-password"
```

### Database Setup

```bash
# Create database
createdb auth_db

# Run migrations
alembic upgrade head
```

### Start Server

```bash
uvicorn src.main:app --reload --port 8000
```

---

## Test Scenario TS-US1-001: 成功注册新用户

**Source**: User Story 1, Acceptance Scenario 1  
**Covers**: FR-001, FR-002, FR-003, FR-006

### Preconditions

- Database is empty or email `test@example.com` does not exist
- Email service is configured and accessible

### Steps

#### Step 1: Send Registration Request

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123",
    "username": "testuser"
  }'
```

**Expected Response**: HTTP 201 Created

```json
{
  "user_id": "123e4567-e89b-12d3-a456-426614174000",
  "email": "test@example.com",
  "username": "testuser",
  "message": "User created successfully. Please check your email for verification."
}
```

#### Step 2: Verify Database Record

```sql
SELECT id, email, username, is_verified, created_at 
FROM users 
WHERE email = 'test@example.com';
```

**Expected**: User record exists with `is_verified = false`

#### Step 3: Check Email Queue

**Expected**: Confirmation email sent to `test@example.com` with subject "Welcome to [App Name]"

### Postconditions

- User record exists in database
- Confirmation email in queue or sent
- Password is hashed (not plaintext)

### Cleanup

```sql
DELETE FROM users WHERE email = 'test@example.com';
```

---

## Test Scenario TS-US1-002: 重复邮箱注册失败

**Source**: User Story 1, Acceptance Scenario 2  
**Covers**: FR-004

### Preconditions

- User with email `existing@example.com` already exists

```sql
INSERT INTO users (email, password_hash, username) 
VALUES ('existing@example.com', '$2b$12$...', 'existinguser');
```

### Steps

#### Step 1: Attempt Registration with Existing Email

```bash
curl -X POST http://localhost:8000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "existing@example.com",
    "password": "AnotherPass456",
    "username": "anotheruser"
  }'
```

**Expected Response**: HTTP 409 Conflict

```json
{
  "error": "ConflictError",
  "message": "Email already exists",
  "field": "email"
}
```

### Postconditions

- No new user created
- Original user data unchanged

---

## Test Scenario TS-US2-001: 成功登录

**Source**: User Story 2, Acceptance Scenario 1  
**Covers**: FR-007, FR-008

### Preconditions

- User exists with email `test@example.com` and password `SecurePass123`

### Steps

#### Step 1: Send Login Request

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "SecurePass123"
  }'
```

**Expected Response**: HTTP 200 OK

```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_in": 3600
}
```

#### Step 2: Verify Token

Decode JWT token and verify:
- Signature is valid
- `user_id` claim matches user's ID
- `exp` (expiration) is set to 1 hour from now

#### Step 3: Use Token to Access Protected Resource

```bash
curl -X GET http://localhost:8000/api/v1/users/me \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Expected**: HTTP 200 with user profile data

---

## Test Scenario TS-US2-002: 错误密码登录失败

**Source**: User Story 2, Acceptance Scenario 2  
**Covers**: FR-008

### Steps

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "WrongPassword"
  }'
```

**Expected Response**: HTTP 401 Unauthorized

```json
{
  "error": "AuthenticationError",
  "message": "Invalid email or password"
}
```

**Note**: Error message is ambiguous (doesn't reveal if email or password is wrong) per FR-008

---

## Test Scenario TS-US3-001: 密码重置完整流程

**Source**: User Story 3, Acceptance Scenarios 1 & 2  
**Covers**: FR-009, FR-010

### Steps

#### Step 1: Request Password Reset

```bash
curl -X POST http://localhost:8000/api/v1/auth/reset-request \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com"
  }'
```

**Expected Response**: HTTP 200 OK

```json
{
  "message": "If the email exists, a password reset link has been sent."
}
```

#### Step 2: Check Email and Extract Token

**Expected**: Email sent with reset link containing token

Example link: `https://example.com/reset?token=abc123def456...`

Extract token: `abc123def456...`

#### Step 3: Confirm Password Reset

```bash
curl -X POST http://localhost:8000/api/v1/auth/reset-confirm \
  -H "Content-Type: application/json" \
  -d '{
    "token": "abc123def456...",
    "new_password": "NewSecurePass456"
  }'
```

**Expected Response**: HTTP 200 OK

```json
{
  "message": "Password reset successfully. You can now login with your new password."
}
```

#### Step 4: Login with New Password

```bash
curl -X POST http://localhost:8000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "NewSecurePass456"
  }'
```

**Expected**: HTTP 200 with new JWT token

---

## Performance Test Scenarios

### Load Test: 1000 Concurrent Registrations

**Purpose**: Verify SC-002 (1000 concurrent users)

```bash
# Using Apache Bench
ab -n 1000 -c 1000 -p register_payload.json \
   -T application/json \
   http://localhost:8000/api/v1/auth/register
```

**Expected**:
- All requests complete within 5 seconds
- 90% of requests < 1s response time
- No 500 errors

### Timing Test: Registration Flow

**Purpose**: Verify SC-001 (< 2 minutes from start to confirmation email)

**Measure**:
1. Start timer
2. POST /api/v1/auth/register
3. Wait for confirmation email delivery
4. Stop timer

**Expected**: Total time < 2 minutes
```

---

## ✅ 阶段 3: Tasks 命令输出

### 输入命令

```bash
/speckit.tasks
```

### 生成的 tasks.md

**完整的 tasks.md 请参考 `templates/tasks-template.md`**，这里展示关键部分：

```markdown
# Tasks: User Authentication System

**Input**: Design documents from `/specs/001-user-auth/`
**Prerequisites**: plan.md, spec.md, data-model.md, contracts/, research.md, quickstart.md

## Phase 1: Setup

- [ ] T001 Create project structure per plan.md
- [ ] T002 Initialize Python 3.11 project with FastAPI 0.104+
- [ ] T003 [P] Configure pytest, pytest-asyncio, linting (black, mypy)

---

## Phase 2: Foundational (Blocking Prerequisites)

⚠️ **CRITICAL**: No user story work can begin until this phase is complete

- [ ] T004 Setup PostgreSQL schema and Alembic migrations
  - File: `alembic/versions/001_initial_schema.py`
  - Create tables: users, password_reset_tokens
  
- [ ] T005 [P] Implement JWT authentication middleware
  - File: `src/middleware/jwt_auth.py`
  - From: research.md (JWT decision)
  - Logic: Verify JWT tokens, extract user_id claim
  
- [ ] T006 [P] Setup error handling framework
  - File: `src/utils/errors.py`
  - Define: ValidationError, AuthenticationError, ConflictError
  
- [ ] T007 [P] Configure environment variables
  - File: `src/config.py`
  - Variables: DATABASE_URL, JWT_SECRET, SMTP settings
  
- [ ] T008 [P] Implement EmailService base class
  - File: `src/services/email_service.py`
  - Methods: `send_confirmation_email()`, `send_reset_email()`
  - Use: FastAPI BackgroundTasks (from research.md)

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - 用户注册 (Priority: P1) 🎯 MVP

**Goal**: 实现用户注册功能

**Independent Test**: 用户可以成功注册并收到确认邮件

### Tests for User Story 1 (Optional)

- [ ] T009 [P] [US1] Contract test for POST /api/v1/auth/register
  - File: `tests/contract/test_auth_contract.py`
  - Verify: Request/response schema matches contracts/auth.yaml
  - Test: 201 Created, 400 Invalid email, 409 Duplicate email
  
- [ ] T010 [P] [US1] Integration test for registration journey
  - File: `tests/integration/test_user_registration.py`
  - Covers: quickstart.md TS-US1-001, TS-US1-002
  - Test: Full registration flow, database verification, email sent

### Implementation for User Story 1

- [ ] T011 [P] [US1] Create User model
  - File: `src/models/user.py`
  - From: data-model.md (User entity)
  - Fields: id, email, password_hash, username, created_at, is_verified, is_locked, locked_until, login_attempts
  - Validation: email format (FR-002), email unique (FR-004)
  - Related entities: [User]
  - Related FRs: [FR-001, FR-002, FR-003, FR-004, FR-005]
  
- [ ] T012 [US1] Implement AuthService.register()
  - File: `src/services/auth_service.py`
  - Depends: T011 (User model)
  - Logic:
    - Validate email format and password length
    - Check email uniqueness
    - Hash password using bcrypt (cost factor 12, from research.md)
    - Create user record
    - Send confirmation email (background task)
  - Related FRs: [FR-001, FR-002, FR-003, FR-004, FR-005, FR-006]
  
- [ ] T013 [P] [US1] Implement input validators
  - File: `src/utils/validators.py`
  - Methods: `validate_email()`, `validate_password()`, `validate_username()`
  - Implements: FR-002 (email format), FR-003 (password length)
  
- [ ] T014 [US1] Implement POST /api/v1/auth/register endpoint
  - File: `src/api/v1/auth.py`
  - From: contracts/auth.yaml
  - Depends: T012 (AuthService), T013 (Validators)
  - Source: US1 "提交注册" user action
  - Logic:
    - Parse request body
    - Call validators
    - Call AuthService.register()
    - Return 201 Created or error
  - Related endpoints: ["/api/v1/auth/register"]
  
- [ ] T015 [US1] Add logging for registration operations
  - File: `src/services/auth_service.py` (add logging)
  - Log: registration attempts, success, failures (email duplicates)

**Checkpoint**: User Story 1 complete - test independently before proceeding

---

## Phase 4: User Story 2 - 用户登录 (Priority: P2)

**Goal**: 实现用户登录功能

**Independent Test**: 注册用户可以成功登录并使用令牌访问资源

### Tests for User Story 2 (Optional)

- [ ] T016 [P] [US2] Contract test for POST /api/v1/auth/login
  - File: `tests/contract/test_auth_contract.py` (add test)
  - Verify: Request/response schema, token format
  
- [ ] T017 [P] [US2] Integration test for login journey
  - File: `tests/integration/test_user_login.py`
  - Covers: quickstart.md TS-US2-001, TS-US2-002
  - Test: Successful login, wrong password, account locking

### Implementation for User Story 2

- [ ] T018 [US2] Implement AuthService.login()
  - File: `src/services/auth_service.py` (add method)
  - Depends: T011 (User model)
  - Logic:
    - Verify email exists
    - Verify password using bcrypt
    - Check if account is locked
    - Increment login_attempts on failure
    - Lock account after 5 failed attempts (15 min, from edge cases)
    - Generate JWT token on success (using python-jose, from research.md)
    - Reset login_attempts on success
  - Related FRs: [FR-007, FR-008]
  
- [ ] T019 [US2] Implement POST /api/v1/auth/login endpoint
  - File: `src/api/v1/auth.py` (add route)
  - From: contracts/auth.yaml
  - Depends: T018 (AuthService.login)
  - Source: US2 "登录提交" user action
  - Logic:
    - Parse request
    - Call AuthService.login()
    - Return token or error (ambiguous error per FR-008)
  - Related endpoints: ["/api/v1/auth/login"]
  
- [ ] T020 [US2] Add logging for login operations
  - File: `src/services/auth_service.py` (add logging)
  - Log: login attempts, successes, failures, account locks

**Checkpoint**: User Stories 1 and 2 both functional

---

## Phase 5: User Story 3 - 密码重置 (Priority: P3)

**Goal**: 实现密码重置功能

**Independent Test**: 用户可以通过邮件重置密码

### Tests for User Story 3 (Optional)

- [ ] T021 [P] [US3] Integration test for password reset flow
  - File: `tests/integration/test_password_reset.py`
  - Covers: quickstart.md TS-US3-001
  - Test: Full reset flow, token expiration, token single-use

### Implementation for User Story 3

- [ ] T022 [P] [US3] Create PasswordResetToken model
  - File: `src/models/password_reset_token.py`
  - From: data-model.md (PasswordResetToken entity)
  - Fields: id, token, user_id, created_at, expires_at, used_at, is_used
  - Relationship: Many-to-one with User
  - Related entities: [PasswordResetToken]
  
- [ ] T023 [US3] Implement AuthService.request_password_reset()
  - File: `src/services/auth_service.py` (add method)
  - Depends: T011 (User), T022 (PasswordResetToken)
  - Logic:
    - Verify email exists (silently fail if not, for security)
    - Generate secure token (using secrets.token_urlsafe, from research.md)
    - Create PasswordResetToken record (expires_at = now + 1 hour)
    - Send reset email with token (background task)
  - Related FRs: [FR-009, FR-010]
  
- [ ] T024 [US3] Implement AuthService.confirm_password_reset()
  - File: `src/services/auth_service.py` (add method)
  - Logic:
    - Verify token exists and is valid
    - Check expiration (FR-010)
    - Check if already used
    - Hash new password
    - Update user password
    - Mark token as used
  - Related FRs: [FR-009, FR-010]
  
- [ ] T025 [US3] Implement POST /api/v1/auth/reset-request endpoint
  - File: `src/api/v1/auth.py` (add route)
  - From: contracts/auth.yaml
  - Source: US3 "请求重置密码" user action
  - Depends: T023
  
- [ ] T026 [US3] Implement POST /api/v1/auth/reset-confirm endpoint
  - File: `src/api/v1/auth.py` (add route)
  - From: contracts/auth.yaml
  - Source: US3 "确认新密码" user action
  - Depends: T024

**Checkpoint**: All user stories functional

---

## Phase 6: Polish & Cross-Cutting Concerns

- [ ] T027 [P] Add unit tests for AuthService
  - File: `tests/unit/test_auth_service.py`
  - Test: Individual methods with mocked dependencies
  
- [ ] T028 [P] Add unit tests for validators
  - File: `tests/unit/test_validators.py`
  
- [ ] T029 Run quickstart.md validation
  - Execute all test scenarios from quickstart.md
  - Verify all pass
  
- [ ] T030 Performance testing (verify SC-002)
  - File: `tests/load/test_concurrent_users.py`
  - Test: 1000 concurrent users
  
- [ ] T031 [P] API documentation (OpenAPI/Swagger)
  - FastAPI auto-generates from contracts
  - Verify documentation is accurate
  
- [ ] T032 Code cleanup and refactoring
  - Remove unused imports
  - Ensure consistent code style

---

## Dependencies & Execution Order

### Phase Dependencies
- Setup (Phase 1): No dependencies
- Foundational (Phase 2): Depends on Setup - BLOCKS all user stories
- US1 (Phase 3): Depends on Foundational
- US2 (Phase 4): Depends on Foundational (independent of US1)
- US3 (Phase 5): Depends on Foundational (independent of US1, US2)
- Polish (Phase 6): Depends on completion of desired user stories

### User Story Dependencies
- **US1 (P1)**: Can start after Foundational - No dependencies on other stories
- **US2 (P2)**: Can start after Foundational - Independent of US1
- **US3 (P3)**: Can start after Foundational - Independent of US1, US2

### Task Dependencies (User Story 1)
- T009, T010 (tests) → No dependencies (write first, should FAIL)
- T011 (User model) → No dependencies [P]
- T012 (AuthService) → Depends on T011
- T013 (Validators) → No dependencies [P]
- T014 (Endpoint) → Depends on T012, T013
- T015 (Logging) → Can run in parallel with T014 [P]

### Parallel Opportunities
- All Setup tasks (T001-T003) can run in parallel
- All Foundational tasks marked [P] can run in parallel
- Once Foundational completes, all user stories can start in parallel
- Within each story, tasks marked [P] can run in parallel

---

## Implementation Strategy

### MVP First (User Story 1 Only)
1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

✓ Deliverable: Users can register accounts (MVP功能）

### Incremental Delivery
1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy
With 3 developers:

1. Team completes Setup + Foundational together (Week 1)
2. Once Foundational is done (Week 2-3):
   - Developer A: User Story 1 (Registration)
   - Developer B: User Story 2 (Login)
   - Developer C: User Story 3 (Password Reset)
3. Stories complete and integrate independently
4. Team integrates and tests together (Week 4)

---

## Summary

- **Total Tasks**: 32
- **Setup**: 3 tasks
- **Foundational**: 5 tasks (blocking)
- **User Story 1 (P1)**: 7 tasks
- **User Story 2 (P2)**: 5 tasks
- **User Story 3 (P3)**: 6 tasks
- **Polish**: 6 tasks
- **Parallel Opportunities**: 15 tasks marked [P]

**MVP Scope**: Phase 1 + Phase 2 + Phase 3 (User Story 1)

**Estimated Timeline**:
- MVP First: 1-2 weeks
- All Features: 2-3 weeks (sequential) or 1-2 weeks (parallel team)
```

---

## 🎓 关键要点总结

从这个完整示例中，我们可以看到：

### 用户故事驱动

- **P1 (US1)**: 用户注册 → MVP 核心
- **P2 (US2)**: 用户登录 → 第一次增量
- **P3 (US3)**: 密码重置 → 第二次增量

每个故事都可以独立实现和测试。

### 渐进式细化

```
"用户" (spec.md 概念)
    ↓
User {email: String, password_hash: String} (data-model.md 技术)
    ↓
CREATE TABLE users... (tasks.md 实现)
```

### 完整追溯

```
FR-002 (邮箱验证)
    → User.email (data-model.md)
    → POST /register validation (contracts/auth.yaml)
    → T011, T013, T014 (tasks.md)
```

### 并行能力

- **阶段级**: US1, US2, US3 可以并行开发（依赖 Foundational）
- **任务级**: T009, T010, T011, T013 可以并行（标记 [P]）

### 质量门禁

- **Specify**: 检查清单验证规格质量
- **Plan**: Constitution Check 验证复杂度
- **Tasks**: Checkpoint 验证故事完整性

---

**这就是完整的 Spec Kit 工作流！** 从一句话需求到可执行的 32 个任务，所有演进过程清晰可追溯。

