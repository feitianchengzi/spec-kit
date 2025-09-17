---
description: 同步 main 分支更新并自动翻译所有 .md 文件为简体中文
scripts:
  sh: sync-and-translate/sync-and-translate.sh
  ps: sync-and-translate/sync-and-translate.ps1
---

根据提供的参数，执行以下操作：

1. 从仓库根目录运行 `sync-and-translate/sync-and-translate.sh` 执行 Git 同步：
   - 检查 main 分支是否有更新
   - 合并更新到当前分支（冲突时以 main 分支为准）
   - 确保工作目录处于最新状态

2. 运行翻译扫描脚本：
   - 执行 `python sync-and-translate/translate-md.py` 获取需要翻译的文件列表
   - 解析输出以确定翻译文件路径

3. 执行自动翻译流程：
   - 翻译所有 .md 文件
   - 保持代码块、URL、占位符等原文不变
   - 确保技术术语翻译的专业性
   - 保持 Markdown 格式完整
   - 翻译要准确、流畅、符合中文表达习惯

4. 验证翻译质量：
   - 检查每个文件翻译后的格式完整性
   - 验证技术术语翻译的准确性
   - 确保所有代码块、链接、图片等保持原文

5. 生成翻译汇总报告：
   - 输出总文件数和翻译完成率
   - 翻译质量检查结果

对所有文件操作使用仓库根目录的绝对路径以避免路径问题。
