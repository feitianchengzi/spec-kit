#!/usr/bin/env bash
# Git 同步工具 - 同步 main 分支更新
# 这是用于维护 spec-kit 项目本身的工具

set -euo pipefail

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 日志函数
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 检查是否在 git 仓库中
check_git_repo() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        log_error "当前目录不是 git 仓库"
        exit 1
    fi
}

# 检查当前分支
check_current_branch() {
    local current_branch=$(git rev-parse --abbrev-ref HEAD)
    log_info "当前分支: $current_branch"
    
    if [ "$current_branch" = "main" ]; then
        log_warning "当前在 main 分支，建议切换到其他分支进行翻译工作"
        read -p "是否继续？(y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "操作已取消"
            exit 0
        fi
    fi
}

# 检查 main 分支更新
check_main_updates() {
    log_info "检查 main 分支更新..."
    
    # 获取远程更新
    git fetch origin main
    
    # 检查是否有更新
    local current_commit=$(git rev-parse HEAD)
    local main_commit=$(git rev-parse origin/main)
    
    if [ "$current_commit" = "$main_commit" ]; then
        log_success "main 分支没有更新"
        return 1
    else
        log_info "发现 main 分支更新"
        log_info "当前提交: $current_commit"
        log_info "main 提交: $main_commit"
        return 0
    fi
}

# 合并 main 分支更新
merge_main_updates() {
    log_info "开始合并 main 分支更新..."
    
    # 合并 main 分支
    if git merge origin/main --no-edit; then
        log_success "成功合并 main 分支更新"
    else
        log_warning "合并时发生冲突，正在解决冲突..."
        
        # 检查冲突文件
        local conflict_files=$(git diff --name-only --diff-filter=U)
        if [ -n "$conflict_files" ]; then
            log_info "冲突文件:"
            echo "$conflict_files"
            
            # 使用 main 分支的版本解决冲突
            log_info "使用 main 分支版本解决冲突..."
            for file in $conflict_files; do
                git checkout --theirs "$file"
                git add "$file"
                log_info "已解决冲突: $file"
            done
            
            # 完成合并
            git commit --no-edit
            log_success "冲突已解决，合并完成"
        else
            log_error "无法解决合并冲突"
            exit 1
        fi
    fi
}


# 主函数
main() {
    log_info "开始 Git 同步流程..."
    
    # 检查环境
    check_git_repo
    check_current_branch
    
    # 检查并合并更新
    if check_main_updates; then
        merge_main_updates
    fi
    
    log_success "Git 同步完成！"
    log_info "工作目录已更新到最新状态"
}

# 执行主函数
main "$@"
