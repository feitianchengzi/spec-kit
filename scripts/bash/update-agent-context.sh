#!/usr/bin/env bash
set -e
REPO_ROOT=$(git rev-parse --show-toplevel)
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
FEATURE_DIR="$REPO_ROOT/specs/$CURRENT_BRANCH"
NEW_PLAN="$FEATURE_DIR/plan.md"
CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"; GEMINI_FILE="$REPO_ROOT/GEMINI.md"; COPILOT_FILE="$REPO_ROOT/.github/copilot-instructions.md"; CURSOR_FILE="$REPO_ROOT/.cursor/rules/specify-rules.mdc"
AGENT_TYPE="$1"
[ -f "$NEW_PLAN" ] || { echo "错误：未找到plan.md at $NEW_PLAN"; exit 1; }
echo "=== 更新功能的代理上下文文件 $CURRENT_BRANCH ==="
NEW_LANG=$(grep "^**语言/版本**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**语言\/版本**: //' | grep -v "需要澄清" || echo "")
NEW_FRAMEWORK=$(grep "^**主要依赖**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**主要依赖**: //' | grep -v "需要澄清" || echo "")
NEW_DB=$(grep "^**存储**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**存储**: //' | grep -v "N/A" | grep -v "需要澄清" || echo "")
NEW_PROJECT_TYPE=$(grep "^**项目类型**: " "$NEW_PLAN" 2>/dev/null | head -1 | sed 's/^**项目类型**: //' || echo "")
update_agent_file() { local target_file="$1" agent_name="$2"; echo "Updating $agent_name context file: $target_file"; local temp_file=$(mktemp); if [ ! -f "$target_file" ]; then
  echo "Creating new $agent_name context file..."; if [ -f "$REPO_ROOT/.specify/templates/agent-file-template.md" ]; then cp "$REPO_ROOT/templates/agent-file-template.md" "$temp_file"; else echo "错误：未找到模板"; return 1; fi;
  sed -i.bak "s/\[PROJECT NAME\]/$(basename $REPO_ROOT)/" "$temp_file"; sed -i.bak "s/\[DATE\]/$(date +%Y-%m-%d)/" "$temp_file"; sed -i.bak "s/\[EXTRACTED FROM ALL PLAN.MD FILES\]/- $NEW_LANG + $NEW_FRAMEWORK ($CURRENT_BRANCH)/" "$temp_file";
  if [[ "$NEW_PROJECT_TYPE" == *"web"* ]]; then sed -i.bak "s|\[ACTUAL STRUCTURE FROM PLANS\]|backend/\nfrontend/\ntests/|" "$temp_file"; else sed -i.bak "s|\[ACTUAL STRUCTURE FROM PLANS\]|src/\ntests/|" "$temp_file"; fi;
  if [[ "$NEW_LANG" == *"Python"* ]]; then COMMANDS="cd src && pytest && ruff check ."; elif [[ "$NEW_LANG" == *"Rust"* ]]; then COMMANDS="cargo test && cargo clippy"; elif [[ "$NEW_LANG" == *"JavaScript"* ]] || [[ "$NEW_LANG" == *"TypeScript"* ]]; then COMMANDS="npm test && npm run lint"; else COMMANDS="# Add commands for $NEW_LANG"; fi; sed -i.bak "s|\[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES\]|$COMMANDS|" "$temp_file";
  sed -i.bak "s|\[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE\]|$NEW_LANG: Follow standard conventions|" "$temp_file"; sed -i.bak "s|\[LAST 3 FEATURES AND WHAT THEY ADDED\]|- $CURRENT_BRANCH: Added $NEW_LANG + $NEW_FRAMEWORK|" "$temp_file"; rm "$temp_file.bak";
else
  echo "Updating existing $agent_name context file..."; manual_start=$(grep -n "<!-- 手动添加开始 -->" "$target_file" | cut -d: -f1); manual_end=$(grep -n "<!-- 手动添加结束 -->" "$target_file" | cut -d: -f1); if [ -n "$manual_start" ] && [ -n "$manual_end" ]; then sed -n "${manual_start},${manual_end}p" "$target_file" > /tmp/manual_additions.txt; fi;
  python3 - "$target_file" <<'EOF'
import re,sys,datetime
target=sys.argv[1]
with open(target) as f: content=f.read()
NEW_LANG="'$NEW_LANG'";NEW_FRAMEWORK="'$NEW_FRAMEWORK'";CURRENT_BRANCH="'$CURRENT_BRANCH'";NEW_DB="'$NEW_DB'";NEW_PROJECT_TYPE="'$NEW_PROJECT_TYPE'"
# Tech section
m=re.search(r'## Active Technologies\n(.*?)\n\n',content, re.DOTALL)
if m:
  existing=m.group(1)
  additions=[]
  if '$NEW_LANG' and '$NEW_LANG' not in existing: additions.append(f"- $NEW_LANG + $NEW_FRAMEWORK ($CURRENT_BRANCH)")
  if '$NEW_DB' and '$NEW_DB' not in existing and '$NEW_DB'!='N/A': additions.append(f"- $NEW_DB ($CURRENT_BRANCH)")
  if additions:
    new_block=existing+"\n"+"\n".join(additions)
    content=content.replace(m.group(0),f"## Active Technologies\n{new_block}\n\n")
# Recent changes
m2=re.search(r'## Recent Changes\n(.*?)(\n\n|$)',content, re.DOTALL)
if m2:
  lines=[l for l in m2.group(1).strip().split('\n') if l]
  lines.insert(0,f"- $CURRENT_BRANCH: Added $NEW_LANG + $NEW_FRAMEWORK")
  lines=lines[:3]
  content=re.sub(r'## Recent Changes\n.*?(\n\n|$)', '## Recent Changes\n'+"\n".join(lines)+'\n\n', content, flags=re.DOTALL)
content=re.sub(r'Last updated: \d{4}-\d{2}-\d{2}', 'Last updated: '+datetime.datetime.now().strftime('%Y-%m-%d'), content)
open(target+'.tmp','w').write(content)
EOF
  mv "$target_file.tmp" "$target_file"; if [ -f /tmp/manual_additions.txt ]; then sed -i.bak '/<!-- 手动添加开始 -->/,/<!-- 手动添加结束 -->/d' "$target_file"; cat /tmp/manual_additions.txt >> "$target_file"; rm /tmp/manual_additions.txt "$target_file.bak"; fi;
fi; mv "$temp_file" "$target_file" 2>/dev/null || true; echo "✅ $agent_name 上下文文件更新成功"; }
case "$AGENT_TYPE" in
  claude) update_agent_file "$CLAUDE_FILE" "Claude Code" ;;
  gemini) update_agent_file "$GEMINI_FILE" "Gemini CLI" ;;
  copilot) update_agent_file "$COPILOT_FILE" "GitHub Copilot" ;;
  cursor) update_agent_file "$CURSOR_FILE" "Cursor IDE" ;;
  "") [ -f "$CLAUDE_FILE" ] && update_agent_file "$CLAUDE_FILE" "Claude Code"; \
       [ -f "$GEMINI_FILE" ] && update_agent_file "$GEMINI_FILE" "Gemini CLI"; \
       [ -f "$COPILOT_FILE" ] && update_agent_file "$COPILOT_FILE" "GitHub Copilot"; \
       [ -f "$CURSOR_FILE" ] && update_agent_file "$CURSOR_FILE" "Cursor IDE"; \
       if [ ! -f "$CLAUDE_FILE" ] && [ ! -f "$GEMINI_FILE" ] && [ ! -f "$COPILOT_FILE" ] && [ ! -f "$CURSOR_FILE" ]; then update_agent_file "$CLAUDE_FILE" "Claude Code"; fi ;;
  *) echo "错误：未知代理类型 '$AGENT_TYPE' (期望 claude|gemini|copilot|cursor)"; exit 1 ;;
esac
echo; echo "更改摘要:"; [ -n "$NEW_LANG" ] && echo "- 添加语言: $NEW_LANG"; [ -n "$NEW_FRAMEWORK" ] && echo "- 添加框架: $NEW_FRAMEWORK"; [ -n "$NEW_DB" ] && [ "$NEW_DB" != "N/A" ] && echo "- 添加数据库: $NEW_DB"; echo; echo "用法： $0 [claude|gemini|copilot|cursor]"
