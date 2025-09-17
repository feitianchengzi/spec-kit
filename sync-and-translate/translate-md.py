#!/usr/bin/env python3
"""
翻译辅助脚本 - 用于维护 spec-kit 项目本身
提供文件扫描、任务清单生成等辅助功能
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any
from datetime import datetime

class MarkdownTranslator:
    """Markdown 文件翻译辅助工具"""
    
    def __init__(self, root_path: str = "."):
        self.root_path = Path(root_path).resolve()
        self.md_files = []
        self.translation_tasks = []
        
    def scan_md_files(self) -> List[Path]:
        """扫描指定目录和根目录的 .md 文件"""
        print("🔍 扫描 .md 文件...")
        
        # 扫描指定的目录和根目录
        target_dirs = ['docs', 'memory', 'templates', '.']
        
        md_files = []
        for target_dir in target_dirs:
            if target_dir == '.':
                # 扫描根目录
                print(f"  扫描目录: 根目录/")
                for file_path in self.root_path.glob("*.md"):
                    # 排除子目录中的文件，只扫描根目录
                    relative_path = file_path.relative_to(self.root_path)
                    if (not str(relative_path).startswith('docs/') and 
                        not str(relative_path).startswith('memory/') and 
                        not str(relative_path).startswith('templates/') and 
                        not str(relative_path).startswith('sync-and-translate/') and 
                        not str(relative_path).startswith('.cursor/')):
                        md_files.append(file_path)
                        print(f"    - {relative_path}")
            else:
                target_path = self.root_path / target_dir
                if target_path.exists() and target_path.is_dir():
                    print(f"  扫描目录: {target_dir}/")
                    for file_path in target_path.rglob("*.md"):
                        md_files.append(file_path)
                        print(f"    - {file_path.relative_to(self.root_path)}")
                else:
                    print(f"  目录不存在: {target_dir}/")
                
        self.md_files = sorted(md_files)
        print(f"✅ 找到 {len(self.md_files)} 个 .md 文件")
        
        return self.md_files
    
    def analyze_file_content(self, file_path: Path) -> Dict[str, Any]:
        """分析文件内容，提取翻译相关信息"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"❌ 无法读取文件 {file_path}: {e}")
            return {}
            
        # 基本统计
        lines = content.split('\n')
        word_count = len(content.split())
        char_count = len(content)
        
        # 检查是否包含中文
        has_chinese = any('\u4e00' <= char <= '\u9fff' for char in content)
        
        # 检查是否包含代码块
        has_code_blocks = '```' in content
        
        # 检查是否包含链接
        has_links = '[' in content and '](' in content
        
        # 检查是否包含图片
        has_images = '![' in content and '](' in content
        
        # 检查是否包含表格
        has_tables = '|' in content and '\n' in content
        
        return {
            'file_path': str(file_path.relative_to(self.root_path)),
            'file_size': file_path.stat().st_size,
            'lines': len(lines),
            'words': word_count,
            'characters': char_count,
            'has_chinese': has_chinese,
            'has_code_blocks': has_code_blocks,
            'has_links': has_links,
            'has_images': has_images,
            'has_tables': has_tables,
            'last_modified': datetime.fromtimestamp(file_path.stat().st_mtime).isoformat()
        }
    
    def generate_translation_tasks(self) -> List[Dict[str, Any]]:
        """生成翻译任务清单"""
        print("📋 生成翻译任务清单...")
        
        tasks = []
        for file_path in self.md_files:
            analysis = self.analyze_file_content(file_path)
            if not analysis:
                continue
                
            # 确定翻译优先级
            priority = "high"
            if analysis['has_chinese']:
                priority = "low"  # 已经包含中文，优先级较低
            elif file_path.name in ['README.md', 'CONTRIBUTING.md', 'CODE_OF_CONDUCT.md']:
                priority = "high"  # 重要文件，优先级高
            elif file_path.parent.name in ['docs', 'templates']:
                priority = "medium"  # 文档和模板，优先级中等
                
            task = {
                'file_path': analysis['file_path'],
                'priority': priority,
                'analysis': analysis,
                'status': 'pending',
                'notes': []
            }
            
            # 添加特殊注意事项
            if analysis['has_code_blocks']:
                task['notes'].append("包含代码块，需要保持原文")
            if analysis['has_links']:
                task['notes'].append("包含链接，需要保持原文")
            if analysis['has_images']:
                task['notes'].append("包含图片，需要保持原文")
            if analysis['has_tables']:
                task['notes'].append("包含表格，需要保持格式")
                
            tasks.append(task)
            
        self.translation_tasks = tasks
        print(f"✅ 生成了 {len(tasks)} 个翻译任务")
        
        return tasks
    
    def get_translation_summary(self) -> str:
        """获取翻译任务摘要"""
        summary_lines = []
        
        # 按优先级分组
        high_priority = [t for t in self.translation_tasks if t['priority'] == 'high']
        medium_priority = [t for t in self.translation_tasks if t['priority'] == 'medium']
        low_priority = [t for t in self.translation_tasks if t['priority'] == 'low']
        
        summary_lines.append("📊 翻译任务摘要")
        summary_lines.append("=" * 50)
        
        summary_lines.append(f"🔴 高优先级: {len(high_priority)} 个文件")
        for task in high_priority:
            summary_lines.append(f"   - {task['file_path']}")
            
        summary_lines.append(f"\n🟡 中优先级: {len(medium_priority)} 个文件")
        for task in medium_priority:
            summary_lines.append(f"   - {task['file_path']}")
            
        summary_lines.append(f"\n🟢 低优先级: {len(low_priority)} 个文件")
        for task in low_priority:
            summary_lines.append(f"   - {task['file_path']}")
            
        # 统计信息
        total_words = sum(t['analysis']['words'] for t in self.translation_tasks)
        total_chars = sum(t['analysis']['characters'] for t in self.translation_tasks)
        
        summary_lines.append(f"\n📈 统计信息:")
        summary_lines.append(f"   总文件数: {len(self.md_files)}")
        summary_lines.append(f"   总任务数: {len(self.translation_tasks)}")
        summary_lines.append(f"   总词数: {total_words:,}")
        summary_lines.append(f"   总字符数: {total_chars:,}")
        
        return "\n".join(summary_lines)
    
    def print_summary(self):
        """打印翻译任务摘要"""
        summary = self.get_translation_summary()
        print(f"\n{summary}")
        
        print("\n💡 翻译建议:")
        print("   1. 优先翻译高优先级文件")
        print("   2. 保持代码块、链接、图片等原文不变")
        print("   3. 注意技术术语的准确性")
        print("   4. 保持 Markdown 格式完整")
        print("   5. 翻译完成后进行质量检查")
        
        print("\n" + "="*50)

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="Markdown 文件翻译辅助工具")
    parser.add_argument("--root", default=".", help="项目根目录路径")
    parser.add_argument("--summary", action="store_true", help="显示翻译任务摘要")
    
    args = parser.parse_args()
    
    # 创建翻译器实例
    translator = MarkdownTranslator(args.root)
    
    try:
        # 扫描文件
        translator.scan_md_files()
        
        # 生成任务清单
        translator.generate_translation_tasks()
        
        # 显示摘要
        if args.summary:
            translator.print_summary()
        else:
            # 直接输出摘要
            summary = translator.get_translation_summary()
            print(f"\n{summary}")
            
        print("\n✅ 翻译辅助工具执行完成！")
        print("请使用 Cursor Command 'Sync and Translate' 进行翻译工作")
        
    except Exception as e:
        print(f"❌ 执行失败: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
