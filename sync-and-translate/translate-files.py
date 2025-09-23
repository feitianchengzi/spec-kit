#!/usr/bin/env python3
"""
文件扫描脚本 - 用于维护 spec-kit 项目本身
提供 .md 文件扫描功能，用于翻译工作
"""

import os
import sys
import json
import argparse
from pathlib import Path
from typing import List, Dict, Any
from datetime import datetime

class FileTranslator:
    """Markdown 文件扫描工具"""
    
    def __init__(self, root_path: str = "."):
        self.root_path = Path(root_path).resolve()
        self.md_files = []
        
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
    
    
    
    def get_file_list(self) -> List[str]:
        """获取需要翻译的 .md 文件列表"""
        file_list = []
        
        for file_path in self.md_files:
            relative_path = file_path.relative_to(self.root_path)
            file_list.append(str(relative_path))
            
        return sorted(file_list)
    
    def get_file_summary(self) -> str:
        """获取文件列表摘要"""
        md_count = len(self.md_files)
        
        summary_lines = []
        summary_lines.append("📊 Markdown 文件扫描摘要")
        summary_lines.append("=" * 50)
        summary_lines.append(f"📄 Markdown 文件: {md_count}")
        
        return "\n".join(summary_lines)
    
    def print_summary(self):
        """打印文件扫描摘要"""
        summary = self.get_file_summary()
        print(f"\n{summary}")
        
        print("\n💡 使用说明:")
        print("   1. 此脚本用于扫描和列出需要翻译的 .md 文件")
        print("   2. 使用 Cursor Command 'Translate MD' 进行 Markdown 文件翻译")
        print("   3. 字符串替换请使用 string-replace.py 脚本")
        print("\n🔧 命令行选项:")
        print("   --list: 仅输出 .md 文件列表")
        print("   --summary: 显示文件扫描摘要")
        
        print("\n" + "="*50)

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="Markdown 文件扫描工具 - 获取需要翻译的 .md 文件列表")
    parser.add_argument("--root", default=".", help="项目根目录路径")
    parser.add_argument("--summary", action="store_true", help="显示文件扫描摘要")
    parser.add_argument("--list", action="store_true", help="仅输出 .md 文件列表")
    
    args = parser.parse_args()
    
    # 创建文件扫描器实例
    scanner = FileTranslator(args.root)
    
    try:
        # 扫描 .md 文件
        scanner.scan_md_files()
        
        if args.list:
            # 仅输出 .md 文件列表
            file_list = scanner.get_file_list()
            for file_path in file_list:
                print(file_path)
        elif args.summary:
            # 显示摘要
            scanner.print_summary()
        else:
            # 默认输出摘要
            summary = scanner.get_file_summary()
            print(f"\n{summary}")
            
        print("\n✅ Markdown 文件扫描完成！")
        print("请使用 Cursor Command 'Translate MD' 进行翻译工作")
        
    except Exception as e:
        print(f"❌ 执行失败: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
