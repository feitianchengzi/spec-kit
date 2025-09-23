# Git 同步工具 - 同步 main 分支更新
# 这是用于维护 spec-kit 项目本身的工具

param(
    [switch]$Force
)

# 设置错误处理
$ErrorActionPreference = "Stop"

# 颜色定义
$Colors = @{
    Red = "Red"
    Green = "Green"
    Yellow = "Yellow"
    Blue = "Blue"
    White = "White"
}

# 日志函数
function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Colors.Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Colors.Green
}

function Write-LogWarning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Colors.Yellow
}

function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Colors.Red
}

# 检查是否在 git 仓库中
function Test-GitRepository {
    try {
        $null = git rev-parse --git-dir 2>$null
        return $true
    }
    catch {
        return $false
    }
}

# 检查当前分支
function Test-CurrentBranch {
    $currentBranch = git rev-parse --abbrev-ref HEAD
    Write-LogInfo "当前分支: $currentBranch"
    
    if ($currentBranch -eq "main") {
        Write-LogWarning "当前在 main 分支，建议切换到其他分支进行翻译工作"
        if (-not $Force) {
            $response = Read-Host "是否继续？(y/N)"
            if ($response -notmatch "^[Yy]$") {
                Write-LogInfo "操作已取消"
                exit 0
            }
        }
    }
}

# 检查 main 分支更新
function Test-MainUpdates {
    Write-LogInfo "检查 main 分支更新..."
    
    # 获取远程更新
    git fetch origin main
    
    # 检查是否有更新
    $currentCommit = git rev-parse HEAD
    $mainCommit = git rev-parse origin/main
    
    if ($currentCommit -eq $mainCommit) {
        Write-LogSuccess "main 分支没有更新"
        return $false
    } else {
        Write-LogInfo "发现 main 分支更新"
        Write-LogInfo "当前提交: $currentCommit"
        Write-LogInfo "main 提交: $mainCommit"
        return $true
    }
}

# 合并 main 分支更新
function Merge-MainUpdates {
    Write-LogInfo "开始合并 main 分支更新..."
    
    # 合并 main 分支
    try {
        git merge origin/main --no-edit
        Write-LogSuccess "成功合并 main 分支更新"
    }
    catch {
        Write-LogWarning "合并时发生冲突，正在解决冲突..."
        
        # 检查冲突文件
        $conflictFiles = git diff --name-only --diff-filter=U
        if ($conflictFiles) {
            Write-LogInfo "冲突文件:"
            $conflictFiles | ForEach-Object { Write-Host "  - $_" }
            
            # 使用 main 分支的版本解决冲突
            Write-LogInfo "使用 main 分支版本解决冲突..."
            $conflictFiles | ForEach-Object {
                git checkout --theirs $_
                git add $_
                Write-LogInfo "已解决冲突: $_"
            }
            
            # 完成合并
            git commit --no-edit
            Write-LogSuccess "冲突已解决，合并完成"
        } else {
            Write-LogError "无法解决合并冲突"
            exit 1
        }
    }
}


# 主函数
function Main {
    Write-LogInfo "开始 Git 同步流程..."
    
    # 检查环境
    if (-not (Test-GitRepository)) {
        Write-LogError "当前目录不是 git 仓库"
        exit 1
    }
    
    Test-CurrentBranch
    
    # 检查并合并更新
    if (Test-MainUpdates) {
        Merge-MainUpdates
    }
    
    Write-LogSuccess "Git 同步完成！"
    Write-LogInfo "工作目录已更新到最新状态"
}

# 执行主函数
Main
