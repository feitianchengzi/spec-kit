# Constitution 架构指南

## 概述

Constitution（宪法）是 spec-kit 项目的核心治理文档，定义了项目的非协商性原则和开发规范。本指南详细解释 Constitution 在整个 spec-driven 开发流程中的作用、架构设计以及如何正确使用它来指导项目开发。

## Constitution 的核心作用

### 1. 架构约束和原则定义

Constitution 定义了 7 个核心开发原则，这些原则是不可协商的：

#### Article I: Library-First（库优先）
- 每个功能都必须从独立库开始
- 库必须自包含、独立可测试、有文档
- 需要明确目的，不允许仅组织性的库

#### Article II: CLI Interface（CLI 接口）
- 每个库都必须通过 CLI 暴露功能
- 文本输入/输出协议：stdin/args → stdout，错误 → stderr
- 支持 JSON 和人类可读格式

#### Article III: Test-First（测试优先，不可协商）
- TDD 强制要求：测试编写 → 用户批准 → 测试失败 → 然后实现
- 严格执行红-绿-重构循环

#### Article IV: Integration Testing（集成测试）
- 需要集成测试的重点领域：
  - 新库合约测试
  - 合约变更
  - 服务间通信
  - 共享模式

#### Article V: Observability（可观测性）
- 文本 I/O 确保可调试性
- 需要结构化日志记录

#### Article VI: Versioning & Breaking Changes（版本控制和破坏性变更）
- MAJOR.MINOR.BUILD 格式
- 破坏性变更需要并行测试和迁移计划

#### Article VII: Simplicity（简洁性）
- 遵循 YAGNI 原则
- 限制项目数量（最多 3 个）
- 避免不必要的模式

### 2. 工作流程中的质量门控

Constitution 在 spec-kit 的工作流程中作为**质量门控**：

#### 计划阶段检查
在 `/templates/plan-template.md` 中，Constitution Check 是一个强制检查点：

```markdown
## Constitution Check
*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Simplicity**:
- Projects: [#] (max 3 - e.g., api, cli, tests)
- Using framework directly? (no wrapper classes)
- Single data model? (no DTOs unless serialization differs)

**Architecture**:
- EVERY feature as library? (no direct app code)
- Libraries listed: [name + purpose for each]
- CLI per library: [commands with --help/--version/--format]

**Testing (NON-NEGOTIABLE)**:
- RED-GREEN-Refactor cycle enforced? (test MUST fail first)
- Git commits show tests before implementation?
- Order: Contract→Integration→E2E→Unit strictly followed?
```

#### 设计阶段重新评估
在 Phase 1 完成后会重新评估 Constitution 合规性，如果发现新的违规行为，会要求重构设计。

### 3. 模板系统的指导原则

Constitution 直接影响所有模板的内容：

- **plan-template.md**：包含 Constitution Check 部分，验证设计是否符合原则
- **tasks-template.md**：任务生成遵循 TDD 和库优先原则
- **spec-template.md**：规范生成符合宪法要求

### 4. AI 助手的指导

Constitution 为 AI 助手提供明确的开发指导：

```markdown
3. Read the constitution at `/memory/constitution.md` to understand constitutional requirements.
```

这确保 AI 生成的所有实现都符合宪法原则，提供明确的决策框架。

## 技术栈特定规范的正确位置

### 问题：技术规范应该放在哪里？

当团队有特定的技术栈要求（如 iOS 开发必须使用 SwiftUI + View-Model 架构）时，这些规范应该放在哪里？

### 答案：分层架构

根据 spec-kit 的设计思路，应该采用分层架构：

#### 1. 宪法层面（Constitution）- ❌ 不适合
宪法应该保持**技术栈无关**的通用原则：

```markdown
## Constitution Check
**Architecture**:
- EVERY feature as library? (no direct app code)
- Libraries listed: [name + purpose for each]
- CLI per library: [commands with --help/--version/--format]
```

宪法关注的是**架构原则**，而不是具体的技术实现。

#### 2. 技术上下文层面（Technical Context）- ✅ 主要位置
在 `plan-template.md` 的 Technical Context 部分：

```markdown
## Technical Context
**Language/Version**: Swift 5.9
**Primary Dependencies**: SwiftUI, Combine
**Target Platform**: iOS 15+
**Project Type**: mobile
```

这里可以包含技术栈选择，但**不包含具体的开发规范细节**。

#### 3. Agent 文件层面 - ✅ 最佳位置
在 `agent-file-template.md` 中：

```markdown
## Active Technologies
- Swift 5.9
- SwiftUI
- Combine

## Code Style
- SwiftUI + View-Model 架构
- 必须使用 SwiftUI 进行 UI 开发
- 必须采用 View-Model 原生架构
- 禁止使用 UIKit 进行新功能开发
- ViewModel 必须继承自 ObservableObject
- 使用 @Published 属性包装器
- 遵循 MVVM 模式
```

#### 4. 项目特定文档 - ✅ 补充位置
创建 `ios-development-standards.md`：

```markdown
# iOS 开发规范

## 架构要求
- 必须使用 SwiftUI + Swift
- 必须采用 View-Model 原生架构
- 禁止使用 UIKit 进行新功能开发

## 具体实现规范
- ViewModel 必须继承自 ObservableObject
- 使用 @Published 属性包装器
- 遵循 MVVM 模式
- 网络请求使用 Combine
- 数据持久化使用 Core Data 或 SwiftData
```

## 推荐的完整方案

### 1. 宪法保持通用性
```markdown
# Constitution
## Core Principles
### Article I: Library-First
### Article II: CLI Interface  
### Article III: Test-First
### Article IV: Integration Testing
### Article V: Observability
### Article VI: Versioning
### Article VII: Simplicity
```

### 2. 技术上下文指定技术栈
```markdown
## Technical Context
**Language/Version**: Swift 5.9
**Primary Dependencies**: SwiftUI, Combine, SwiftData
**Target Platform**: iOS 15+
**Project Type**: mobile
**Architecture**: MVVM with SwiftUI
```

### 3. Agent 文件包含具体规范
```markdown
# iOS Development Guidelines

## Architecture Requirements
- MUST use SwiftUI for all UI development
- MUST follow View-Model pattern
- MUST use ObservableObject for ViewModels
- MUST use @Published for reactive properties
- FORBIDDEN: UIKit for new features

## Code Style
- ViewModels inherit from ObservableObject
- Use @Published for reactive properties
- Use Combine for networking
- Use SwiftData for persistence
```

### 4. 项目文档补充细节
创建 `docs/ios-standards.md` 包含详细的实现规范、代码示例、最佳实践等。

## 为什么这样分层？

### 1. 宪法保持稳定性
技术栈可能变化，但架构原则不变。宪法应该关注通用的开发原则，而不是具体的技术实现。

### 2. 技术上下文提供约束
告诉 AI 使用什么技术栈，但不包含具体的实现细节。

### 3. Agent 文件提供具体指导
告诉 AI 如何正确使用这些技术，包含具体的开发规范。

### 4. 项目文档提供细节
供开发者参考具体实现，包含代码示例和最佳实践。

## 治理和一致性维护

### 版本控制
Constitution 有版本号，变更需要文档化：

```markdown
**Version**: [CONSTITUTION_VERSION] | **Ratified**: [RATIFICATION_DATE] | **Last Amended**: [LAST_AMENDED_DATE]
```

### 更新检查清单
`constitution_update_checklist.md` 确保所有相关文档同步更新：

```markdown
## Templates to Update
### When adding/modifying ANY article:
- [ ] `/templates/plan-template.md` - Update Constitution Check section
- [ ] `/templates/spec-template.md` - Update if requirements/scope affected
- [ ] `/templates/tasks-template.md` - Update if new task types needed
```

### 模板同步
确保所有模板都反映最新的宪法要求，维护项目的一致性。

## 质量保证机制

### 错误处理
如果违反宪法原则且无法合理证明，会触发 ERROR 状态：

```markdown
→ If violations exist: Document in Complexity Tracking
→ If no justification possible: ERROR "Simplify approach first"
```

### 强制简化
Constitution 强制简化复杂的设计，确保生成的代码具有一致性和可维护性。

### 复杂度跟踪
对于必须的违规行为，需要在 Complexity Tracking 中记录：

```markdown
## Complexity Tracking
| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
```

## 实际应用示例

### 场景：iOS 应用开发
当开发 iOS 应用时：

1. **宪法层面**：确保功能作为独立库开发，遵循 TDD
2. **技术上下文**：指定 Swift 5.9 + SwiftUI
3. **Agent 文件**：包含 SwiftUI + View-Model 架构要求
4. **项目文档**：详细的 iOS 开发规范和代码示例

### 场景：Web 应用开发
当开发 Web 应用时：

1. **宪法层面**：同样的架构原则
2. **技术上下文**：指定 React + Node.js
3. **Agent 文件**：包含 React 组件规范和 API 设计原则
4. **项目文档**：Web 开发最佳实践

## 最佳实践

### 1. 保持宪法的通用性
- 不要将技术栈特定的规范写入宪法
- 关注架构原则，而不是具体实现
- 确保宪法在技术栈变化时仍然有效

### 2. 合理分层
- 技术栈选择放在 Technical Context
- 具体规范放在 Agent 文件
- 详细实现放在项目文档

### 3. 维护一致性
- 使用更新检查清单确保同步
- 定期验证模板与宪法的一致性
- 记录版本变更和修改原因

### 4. 强制执行
- 在关键检查点验证宪法合规性
- 对违规行为进行适当的错误处理
- 记录必要的复杂度偏差

## 总结

Constitution 在 spec-kit 中不仅仅是文档，而是整个 spec-driven 开发流程的**核心治理机制**。它通过定义不可协商的原则、提供质量检查点、指导模板生成、强制执行开发规范等方式，确保整个项目保持一致性、简洁性和高质量。

对于技术栈特定的规范，应该采用分层架构：
- **宪法**：保持通用性和稳定性
- **技术上下文**：指定技术栈
- **Agent 文件**：包含具体规范
- **项目文档**：提供实现细节

这样的分层确保了 Constitution 作为项目治理核心的有效性，同时为不同层次的技术规范提供了合适的位置。它是 spec-kit 实现"规范驱动开发"理念的关键基础设施。

---

*本指南基于 spec-kit Constitution v2.1.1 和实际项目经验编写。*
