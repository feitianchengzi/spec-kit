---
description: 同步 main 分支更新到当前分支
scripts:
  sh: sync-and-translate/git-sync.sh
  ps: sync-and-translate/git-sync.ps1
---

根据提供的参数，执行以下操作：

1. 从仓库根目录运行 `sync-and-translate/git-sync.sh` 执行 Git 同步：
   - 检查 main 分支是否有更新
   - 合并更新到当前分支（冲突时以 main 分支为准）
   - 确保工作目录处于最新状态

2. 验证同步结果：
   - 检查当前分支状态
   - 确认所有更新已正确合并
   - 验证工作目录处于最新状态

对所有文件操作使用仓库根目录的绝对路径以避免路径问题。
