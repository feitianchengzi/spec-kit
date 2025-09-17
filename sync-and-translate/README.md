# 维护工具

这个目录包含了用于维护 spec-kit 项目本身的工具。

## 工具列表

### 1. Cursor Command
- **文件**: `.cursor/commands/sync-and-translate.md`
- **功能**: 定义 Cursor Command，使用 Cursor AI 进行翻译
- **使用**: 在 Cursor 中运行 "Sync and Translate" 命令
- **特性**: 动态调用脚本获取需要翻译的文件列表

### 2. Bash 脚本
- **文件**: `sync-and-translate/sync-and-translate.sh`
- **功能**: 同步 main 分支更新并准备翻译工作
- **使用**: `./sync-and-translate/sync-and-translate.sh`

### 3. PowerShell 脚本
- **文件**: `sync-and-translate/sync-and-translate.ps1`
- **功能**: 同步 main 分支更新并准备翻译工作（Windows）
- **使用**: `.\sync-and-translate\sync-and-translate.ps1`

### 4. Python 辅助脚本
- **文件**: `sync-and-translate/translate-md.py`
- **功能**: 扫描指定目录的 .md 文件并生成翻译任务清单
- **使用**: `python sync-and-translate/translate-md.py --summary`

### 5. 翻译汇总脚本
- **文件**: `sync-and-translate/translation-summary.py`
- **功能**: 生成详细的翻译汇总报告
- **使用**: `python sync-and-translate/translation-summary.py`

## 使用流程

### 步骤 1: 同步 Git 更新
```bash
# Linux/macOS
./sync-and-translate/sync-and-translate.sh

# Windows
.\sync-and-translate\sync-and-translate.ps1
```

### 步骤 2: 生成翻译任务清单
```bash
python sync-and-translate/translate-md.py --summary
```

**扫描目录：**
- 根目录 - 项目根目录下的 .md 文件
- `docs/` - 文档目录
- `memory/` - 记忆目录  
- `templates/` - 模板目录

### 步骤 3: 使用 Cursor 进行翻译
1. 在 Cursor 中运行 "Sync and Translate" 命令
2. 命令会动态调用脚本获取需要翻译的文件列表
3. 按照命令中的指导进行翻译
4. 保持代码块、URL、占位符等原文不变
5. 确保技术术语翻译的专业性

### 步骤 4: 生成翻译汇总
翻译完成后，运行以下命令生成汇总报告：

```bash
python sync-and-translate/translation-summary.py
```

### 步骤 5: 质量检查
翻译完成后，检查：
- 所有代码块是否保持原文
- URL 链接是否正确
- 技术术语是否翻译准确
- 格式是否完整

## 注意事项

- 这些工具仅用于维护 spec-kit 项目本身
- 翻译时请保持专业性和准确性
- 如有疑问，请参考原文进行对比
- 建议在翻译前创建备份分支
