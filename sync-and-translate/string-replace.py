#!/usr/bin/env python3
"""
字符串替换脚本 - 根据翻译字典进行字符串匹配和替换
用于维护 spec-kit 项目本身的翻译工作
"""

import os
import sys
import argparse
from pathlib import Path
from typing import Dict, List, Tuple
import re

class StringReplacer:
    """字符串替换工具"""
    
    def __init__(self, root_path: str = "."):
        self.root_path = Path(root_path).resolve()
        self.translation_dict = {}
        self.dict_file = self.root_path / "sync-and-translate" / "translation-dict.txt"
        
    def load_translation_dict(self) -> Dict[str, str]:
        """加载翻译字典"""
        print("📖 加载翻译字典...")
        
        if not self.dict_file.exists():
            print(f"❌ 翻译字典文件不存在: {self.dict_file}")
            return {}
            
        translation_dict = {}
        try:
            with open(self.dict_file, 'r', encoding='utf-8') as f:
                for line_num, line in enumerate(f, 1):
                    line = line.strip()
                    if not line or line.startswith('#'):
                        continue
                        
                    if ' => ' in line:
                        original, translated = line.split(' => ', 1)
                        original = original.strip()
                        translated = translated.strip()
                        
                        if original and translated:
                            translation_dict[original] = translated
                        else:
                            print(f"⚠️  第{line_num}行格式错误: {line}")
                    else:
                        print(f"⚠️  第{line_num}行格式错误: {line}")
                        
        except Exception as e:
            print(f"❌ 读取翻译字典失败: {e}")
            return {}
            
        self.translation_dict = translation_dict
        print(f"✅ 加载了 {len(translation_dict)} 条翻译规则")
        
        return translation_dict
    
    def replace_strings_in_file(self, file_path: Path) -> Tuple[int, List[str]]:
        """在单个文件中进行字符串替换"""
        if not file_path.exists():
            return 0, []
            
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
                
            original_content = content
            replacements = []
            
            # 按字符串长度降序排列，优先替换长字符串
            sorted_dict = sorted(self.translation_dict.items(), key=lambda x: len(x[0]), reverse=True)
            
            for original, translated in sorted_dict:
                if original in content:
                    # 使用正则表达式进行精确匹配，避免部分匹配
                    pattern = re.escape(original)
                    matches = re.findall(pattern, content)
                    if matches:
                        content = content.replace(original, translated)
                        replacements.append(f"'{original}' => '{translated}'")
            
            # 如果有替换，写回文件
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                    
            return len(replacements), replacements
            
        except Exception as e:
            print(f"❌ 处理文件失败 {file_path}: {e}")
            return 0, []
    
    def replace_strings_in_files(self, file_paths: List[Path]) -> Dict[str, Tuple[int, List[str]]]:
        """在多个文件中进行字符串替换"""
        results = {}
        
        for file_path in file_paths:
            print(f"🔄 处理文件: {file_path.relative_to(self.root_path)}")
            count, replacements = self.replace_strings_in_file(file_path)
            results[str(file_path.relative_to(self.root_path))] = (count, replacements)
            
            if count > 0:
                print(f"  ✅ 替换了 {count} 个字符串")
                for replacement in replacements:
                    print(f"    - {replacement}")
            else:
                print(f"  ℹ️  无需替换")
                
        return results
    
    def get_replacement_summary(self, results: Dict[str, Tuple[int, List[str]]]) -> str:
        """获取替换结果摘要"""
        total_files = len(results)
        files_with_replacements = sum(1 for count, _ in results.values() if count > 0)
        total_replacements = sum(count for count, _ in results.values())
        
        summary_lines = []
        summary_lines.append("📊 字符串替换摘要")
        summary_lines.append("=" * 50)
        summary_lines.append(f"📁 总文件数: {total_files}")
        summary_lines.append(f"🔄 有替换的文件: {files_with_replacements}")
        summary_lines.append(f"📝 总替换次数: {total_replacements}")
        
        if files_with_replacements > 0:
            summary_lines.append("\n📋 替换详情:")
            for file_path, (count, replacements) in results.items():
                if count > 0:
                    summary_lines.append(f"  📄 {file_path}: {count} 次替换")
                    for replacement in replacements:
                        summary_lines.append(f"    - {replacement}")
        
        return "\n".join(summary_lines)

def main():
    """主函数"""
    parser = argparse.ArgumentParser(description="字符串替换工具 - 根据翻译字典进行字符串匹配和替换")
    parser.add_argument("--root", default=".", help="项目根目录路径")
    parser.add_argument("--files", nargs="+", help="要处理的文件路径列表")
    parser.add_argument("--dict", help="翻译字典文件路径")
    parser.add_argument("--dry-run", action="store_true", help="仅显示替换内容，不实际修改文件")
    
    args = parser.parse_args()
    
    # 创建字符串替换器实例
    replacer = StringReplacer(args.root)
    
    # 设置自定义字典文件路径
    if args.dict:
        replacer.dict_file = Path(args.dict)
    
    try:
        # 加载翻译字典
        translation_dict = replacer.load_translation_dict()
        if not translation_dict:
            print("❌ 翻译字典为空，退出")
            sys.exit(1)
        
        # 获取要处理的文件列表
        if args.files:
            file_paths = []
            for f in args.files:
                file_path = Path(f)
                # 如果是相对路径，则相对于root_path解析
                if not file_path.is_absolute():
                    file_path = replacer.root_path / file_path
                file_paths.append(file_path)
        else:
            print("❌ 请指定要处理的文件路径")
            sys.exit(1)
        
        # 验证文件存在
        valid_files = []
        for file_path in file_paths:
            if file_path.exists():
                valid_files.append(file_path)
            else:
                print(f"⚠️  文件不存在: {file_path}")
        
        if not valid_files:
            print("❌ 没有有效的文件需要处理")
            sys.exit(1)
        
        if args.dry_run:
            print("🔍 预览模式 - 不会实际修改文件")
            # 在预览模式下，只显示会进行的替换
            for file_path in valid_files:
                print(f"\n📄 文件: {file_path}")
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    # 按字符串长度降序排列
                    sorted_dict = sorted(translation_dict.items(), key=lambda x: len(x[0]), reverse=True)
                    
                    for original, translated in sorted_dict:
                        if original in content:
                            count = content.count(original)
                            print(f"  - '{original}' => '{translated}' ({count} 次)")
                            
                except Exception as e:
                    print(f"  ❌ 读取文件失败: {e}")
        else:
            # 执行实际替换
            print(f"\n🔄 开始处理 {len(valid_files)} 个文件...")
            results = replacer.replace_strings_in_files(valid_files)
            
            # 显示摘要
            summary = replacer.get_replacement_summary(results)
            print(f"\n{summary}")
        
        print("\n✅ 字符串替换完成！")
        
    except Exception as e:
        print(f"❌ 执行失败: {e}")
        sys.exit(1)

if __name__ == "__main__":
    main()
