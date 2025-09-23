#!/usr/bin/env pwsh
[CmdletBinding()]
param([string]$AgentType)
$ErrorActionPreference = 'Stop'

$repoRoot = git rev-parse --show-toplevel
$currentBranch = git rev-parse --abbrev-ref HEAD
$featureDir = Join-Path $repoRoot "specs/$currentBranch"
$newPlan = Join-Path $featureDir 'plan.md'
if (-not (Test-Path $newPlan)) { Write-Error "错误：未找到plan.md at $newPlan"; exit 1 }

$claudeFile = Join-Path $repoRoot 'CLAUDE.md'
$geminiFile = Join-Path $repoRoot 'GEMINI.md'
$copilotFile = Join-Path $repoRoot '.github/copilot-instructions.md'
$cursorFile = Join-Path $repoRoot '.cursor/rules/specify-rules.mdc'

Write-Output "=== 更新功能的代理上下文文件 $currentBranch ==="

function Get-PlanValue($pattern) {
    if (-not (Test-Path $newPlan)) { return '' }
    $line = Select-String -Path $newPlan -Pattern $pattern | Select-Object -First 1
    if ($line) { return ($line.Line -replace "^\*\*$pattern\*\*: ", '') }
    return ''
}

$newLang = Get-PlanValue 'Language/Version'
$newFramework = Get-PlanValue 'Primary Dependencies'
$newTesting = Get-PlanValue 'Testing'
$newDb = Get-PlanValue 'Storage'
$newProjectType = Get-PlanValue 'Project Type'

function Initialize-AgentFile($targetFile, $agentName) {
    if (Test-Path $targetFile) { return }
    $template = Join-Path $repoRoot '.specify/templates/agent-file-template.md'
    if (-not (Test-Path $template)) { Write-Error "Template not found: $template"; return }
    $content = Get-Content $template -Raw
    $content = $content.Replace('[项目名称]', (Split-Path $repoRoot -Leaf))
    $content = $content.Replace('[日期]', (Get-Date -Format 'yyyy-MM-dd'))
    $content = $content.Replace('[从所有计划文件中提取]', "- $newLang + $newFramework ($currentBranch)")
    if ($newProjectType -match 'web') { $structure = "backend/`nfrontend/`ntests/" } else { $structure = "src/`ntests/" }
    $content = $content.Replace('[从计划中的实际结构]', $structure)
    if ($newLang -match 'Python') { $commands = 'cd src && pytest && ruff check .' }
    elseif ($newLang -match 'Rust') { $commands = 'cargo test && cargo clippy' }
    elseif ($newLang -match 'JavaScript|TypeScript') { $commands = 'npm test && npm run lint' }
    else { $commands = "# Add commands for $newLang" }
    $content = $content.Replace('[仅用于活跃技术的命令]', $commands)
    $content = $content.Replace('[特定语言，仅用于正在使用的语言]', "${newLang}: Follow standard conventions")
    $content = $content.Replace('[最近3个功能及其添加内容]', "- ${currentBranch}: Added ${newLang} + ${newFramework}")
    $content | Set-Content $targetFile -Encoding UTF8
}

function Update-AgentFile($targetFile, $agentName) {
    if (-not (Test-Path $targetFile)) { Initialize-AgentFile $targetFile $agentName; return }
    $content = Get-Content $targetFile -Raw
    if ($newLang -and ($content -notmatch [regex]::Escape($newLang))) { $content = $content -replace '(## Active Technologies\n)', "`$1- $newLang + $newFramework ($currentBranch)`n" }
    if ($newDb -and $newDb -ne 'N/A' -and ($content -notmatch [regex]::Escape($newDb))) { $content = $content -replace '(## Active Technologies\n)', "`$1- $newDb ($currentBranch)`n" }
    if ($content -match '## Recent Changes\n([\s\S]*?)(\n\n|$)') {
        $changesBlock = $matches[1].Trim().Split("`n")
    $changesBlock = ,"- ${currentBranch}: Added ${newLang} + ${newFramework}" + $changesBlock
        $changesBlock = $changesBlock | Where-Object { $_ } | Select-Object -First 3
        $joined = ($changesBlock -join "`n")
        $content = [regex]::Replace($content, '## Recent Changes\n([\s\S]*?)(\n\n|$)', "## Recent Changes`n$joined`n`n")
    }
    $content = [regex]::Replace($content, 'Last updated: \d{4}-\d{2}-\d{2}', "Last updated: $(Get-Date -Format 'yyyy-MM-dd')")
    $content | Set-Content $targetFile -Encoding UTF8
    Write-Output "✅ $agentName 上下文文件更新成功"
}

switch ($AgentType) {
    'claude' { Update-AgentFile $claudeFile 'Claude Code' }
    'gemini' { Update-AgentFile $geminiFile 'Gemini CLI' }
    'copilot' { Update-AgentFile $copilotFile 'GitHub Copilot' }
    'cursor' { Update-AgentFile $cursorFile 'Cursor IDE' }
    '' {
        foreach ($pair in @(
            @{file=$claudeFile; name='Claude Code'},
            @{file=$geminiFile; name='Gemini CLI'},
            @{file=$copilotFile; name='GitHub Copilot'},
            @{file=$cursorFile; name='Cursor IDE'}
        )) {
            if (Test-Path $pair.file) { Update-AgentFile $pair.file $pair.name }
        }
        if (-not (Test-Path $claudeFile) -and -not (Test-Path $geminiFile) -and -not (Test-Path $copilotFile) -and -not (Test-Path $cursorFile)) {
            Write-Output '未找到代理上下文文件。默认创建Claude Code上下文文件.'
            Update-AgentFile $claudeFile 'Claude Code'
        }
    }
    Default { Write-Error "错误：未知代理类型 '$AgentType'. 使用：claude、gemini、copilot、cursor 或留空以处理所有."; exit 1 }
}

Write-Output ''
Write-Output '更改摘要:'
if ($newLang) { Write-Output "- 添加语言: $newLang" }
if ($newFramework) { Write-Output "- 添加框架: $newFramework" }
if ($newDb -and $newDb -ne 'N/A') { Write-Output "- 添加数据库: $newDb" }

Write-Output ''
Write-Output '用法： ./update-agent-context.ps1 [claude|gemini|copilot|cursor]'
