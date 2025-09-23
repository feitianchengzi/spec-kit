---
description: 自动翻译所有 .md 文件为简体中文
scripts:
  sh: sync-and-translate/translate-files.py
  ps: sync-and-translate/translate-files.py
---

根据提供的参数，执行以下操作：

1. 运行文件扫描脚本：
   - 执行 `python sync-and-translate/translate-files.py --list` 获取需要翻译的 .md 文件列表
   - 扫描 .md 文件（docs/, memory/, templates/, 根目录）
   - 仅返回 .md 文件路径列表，不进行内容分析

2. 使用字符串替换脚本处理文件：
   - 调用 `python sync-and-translate/string-replace.py --files <文件列表>` 进行字符串替换
   - 根据翻译字典进行精确的字符串匹配和替换
   - 按字符串长度降序排列，优先替换长字符串，避免部分匹配问题

3. 翻译 Markdown 文件：
   - 由 AI Agent 翻译 Markdown 文件内容
   - 保持代码块、URL、占位符、链接等原文不变
   - 保持 Markdown 格式完整（标题、列表、表格等）
   - 确保技术术语翻译的专业性和一致性
   - 翻译要准确、流畅、符合中文表达习惯
   - 翻译字典

4. 验证 Markdown 文件翻译质量：
   - 检查每个文件翻译后的格式完整性
   - 验证技术术语翻译的准确性
   - 确保所有代码块、链接、图片等保持原文
   - 验证字符串替换脚本的替换结果是否正确

5. 生成翻译汇总报告：
   - 输出总文件数（.md 文件）和翻译完成率
   - AI Agent 翻译的内容统计
   - 翻译质量检查结果

对所有文件操作使用仓库根目录的绝对路径以避免路径问题。
