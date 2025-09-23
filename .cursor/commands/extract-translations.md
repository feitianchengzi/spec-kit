---
description: 从 scripts 目录中提取需要翻译的英文文本并更新到 translation-dict.txt
---

根据提供的参数，执行以下操作：

1. 从 scripts 文件夹获取脚本文件列表

2. 深入理解和分析以下示例，抽象英文文本提取规则，并输出提取规则到对话上下文中：
   - NEW_LANG=$(grep "^**Language/Version**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**Language\/Version**: //' | grep -v "NEEDS CLARIFICATION" || echo "") 中，**Language/Version**、**Language\/Version**、NEEDS CLARIFICATION 都需要翻译和替换
   - sed -i.bak "s/\[PROJECT NAME\]/$(basename $REPO_ROOT)/" "$temp_file"; 中，\[PROJECT NAME\] 需要翻译和替换，变体 [PROJECT NAME] 也需要翻译和替换
   - manual_start=$(grep -n "<!-- MANUAL ADDITIONS START -->" "$target_file" | cut -d: -f1); 中，<!-- MANUAL ADDITIONS START --> 需要翻译和替换
   - m=re.search(r'## Active Technologies\n(.*?)\n\n',content, re.DOTALL) 中，## Active Technologies 需要翻译和替换
   - content=content.replace(m.group(0),f"## Active Technologies\n{new_block}\n\n") 中，## Active Technologies 需要翻译和替换
   - content=re.sub(r'## Recent Changes\n.*?(\n\n|$)', '## Recent Changes\n'+"\n".join(lines)+'\n\n', content, flags=re.DOTALL) 中, ## Recent Changes 需要翻译和替换
   - sed -i.bak '/<!-- MANUAL ADDITIONS START -->/,/<!-- MANUAL ADDITIONS END -->/d' "$target_file"; 中，<!-- MANUAL ADDITIONS START -->、<!-- MANUAL ADDITIONS END --> 需要翻译和替换

3. 逐个文件，分析脚本内容，更新翻译字典文件

4. 分析脚本内容：
   - 参考 2 的示例
   - 参考 2 抽象出的提取规则
   - 从脚本内容中查找所有需要翻译的英文文本

5. 更新翻译字典文件：
   - 字典文件位置：`sync-and-translate/translation-dict.txt`
   - 翻译字典格式：`原文 => 译文` 每行一条记录
   - 避免重复添加已存在的翻译条目
   - 按字母顺序排序新条目

6. 检查是否所有文件都已处理，如果有文件未处理，回到 3 继续执行

7. 和人类确认翻译字典文件是否需要调整

8. 人类答复确认完成之后，使用字符串替换脚本处理文件：
   - 调用 `python sync-and-translate/string-replace.py --files <文件列表>` 进行字符串替换
   - 根据翻译字典进行精确的字符串匹配和替换
   - 按字符串长度降序排列，优先替换长字符串，避免部分匹配问题
   - 生成替换摘要报告，显示替换次数和详情