# 维护工具

这个目录包含了用于维护 spec-kit 项目本身的工具。

## 工具列表

### 1. Cursor Commands
- **git-sync**: 同步 main 分支更新到当前分支
- **extract-translations**: 从脚本文件中提取需要翻译的英文文本并更新翻译字典
- **translate-md**: 翻译所有 .md 文件为简体中文

### 2. Git 同步脚本
- **文件**: `sync-and-translate/git-sync.sh` / `sync-and-translate/git-sync.ps1`
- **功能**: 同步 main 分支更新并解决冲突
- **使用**: 通过 Cursor Command "git-sync" 调用

### 3. 文件扫描脚本
- **文件**: `sync-and-translate/translate-files.py`
- **功能**: 扫描指定目录的 .md 文件并生成翻译任务清单
- **使用**: `python sync-and-translate/translate-files.py --summary`

### 4. 字符串替换脚本
- **文件**: `sync-and-translate/string-replace.py`
- **功能**: 根据翻译字典进行精确的字符串匹配和替换
- **使用**: `python sync-and-translate/string-replace.py --files <文件列表>`

### 5. 翻译字典
- **文件**: `sync-and-translate/translation-dict.txt`
- **功能**: 存储原文到译文的映射关系
- **格式**: `原文 => 译文` 每行一条记录

## 使用流程

### 步骤 1: 同步 Git 更新
在 Cursor 中运行 **"git-sync"** 命令：
- 检查 main 分支是否有更新
- 合并更新到当前分支（冲突时以 main 分支为准）
- 确保工作目录处于最新状态

### 步骤 2: 提取脚本翻译文本
在 Cursor 中运行 **"extract-translations"** 命令：
- 从 `scripts/` 目录中提取需要翻译的英文文本
- 分析脚本内容，识别需要翻译的字符串
- 更新 `translation-dict.txt` 翻译字典
- 使用字符串替换脚本处理脚本文件

**提取规则示例：**
- `**Language/Version**:` → `**语言/版本**:`
- `[PROJECT NAME]` → `[项目名称]`
- `<!-- MANUAL ADDITIONS START -->` → `<!-- 手动添加开始 -->`
- `## Active Technologies` → `## 活跃技术`

### 步骤 3: 翻译 Markdown 文档
在 Cursor 中运行 **"translate-md"** 命令：
- 扫描 .md 文件（docs/, memory/, templates/, 根目录）
- 使用字符串替换脚本处理文件
- 由 AI Agent 翻译 Markdown 文件内容
- 保持代码块、URL、占位符等原文不变
- 确保技术术语翻译的专业性和一致性

**扫描目录：**
- 根目录 - 项目根目录下的 .md 文件
- `docs/` - 文档目录
- `memory/` - 记忆目录  
- `templates/` - 模板目录

### 步骤 4: 质量检查
翻译完成后，检查：
- 所有代码块是否保持原文
- URL 链接是否正确
- 技术术语是否翻译准确
- 格式是否完整
- 字符串替换是否正确

## 注意事项

- 这些工具仅用于维护 spec-kit 项目本身
- 必须按照顺序执行：git-sync → extract-translations → translate-md
- 翻译时请保持专业性和准确性
- 如有疑问，请参考原文进行对比
- 建议在翻译前创建备份分支
- 翻译字典由人工维护，确保翻译质量
