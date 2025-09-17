---
description: 使用计划模板执行实现规划工作流以生成设计工件。
scripts:
  sh: scripts/bash/setup-plan.sh --json
  ps: scripts/powershell/setup-plan.ps1 -Json
---

根据提供的实现详情参数，执行以下操作：

1. 从仓库根目录运行 `{SCRIPT}` 并解析 JSON 获取 FEATURE_SPEC、IMPL_PLAN、SPECS_DIR、BRANCH。所有后续文件路径必须是绝对路径。
2. 读取并分析功能规范以理解：
   - 功能需求和用户故事
   - 功能性和非功能性需求
   - 成功标准和验收标准
   - 任何技术约束或依赖关系

3. 读取 `/memory/constitution.md` 中的章程以理解章程要求。

4. 执行实现计划模板：
   - 加载 `/templates/plan-template.md`（已复制到 IMPL_PLAN 路径）
   - 将输入路径设置为 FEATURE_SPEC
   - 运行执行流程（主）函数步骤 1-9
   - 模板是自包含且可执行的
   - 按照指定的错误处理和门控检查
   - 让模板指导在 $SPECS_DIR 中生成工件：
     * 阶段 0 生成 research.md
     * 阶段 1 生成 data-model.md、contracts/、quickstart.md
     * 阶段 2 生成 tasks.md
   - 将用户提供的参数详情纳入技术上下文：{ARGS}
   - 完成每个阶段时更新进度跟踪

5. 验证执行完成：
   - 检查进度跟踪显示所有阶段已完成
   - 确保所有必需的工件都已生成
   - 确认执行中没有 ERROR 状态

6. 报告结果，包括分支名称、文件路径和生成的工件。

对所有文件操作使用仓库根目录的绝对路径以避免路径问题。
