#!/usr/bin/env pwsh
[CmdletBinding()]
param([switch]$Json)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"

$paths = Get-FeaturePathsEnv
if (-not (Test-FeatureBranch -Branch $paths.CURRENT_BRANCH)) { exit 1 }

if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
    Write-Output "错误：未找到功能目录: $($paths.FEATURE_DIR)"
    Write-Output "先运行/specify创建功能结构."
    exit 1
}
if (-not (Test-Path $paths.IMPL_PLAN -PathType Leaf)) {
    Write-Output "错误：未找到plan.md in $($paths.FEATURE_DIR)"
    Write-Output "先运行/plan创建计划."
    exit 1
}

if ($Json) {
    $docs = @()
    if (Test-Path $paths.RESEARCH) { $docs += 'research.md' }
    if (Test-Path $paths.DATA_MODEL) { $docs += 'data-model.md' }
    if ((Test-Path $paths.CONTRACTS_DIR) -and (Get-ChildItem -Path $paths.CONTRACTS_DIR -ErrorAction SilentlyContinue | Select-Object -First 1)) { $docs += 'contracts/' }
    if (Test-Path $paths.QUICKSTART) { $docs += 'quickstart.md' }
    [PSCustomObject]@{ FEATURE_DIR=$paths.FEATURE_DIR; AVAILABLE_DOCS=$docs } | ConvertTo-Json -Compress
} else {
    Write-Output "FEATURE_DIR:$($paths.FEATURE_DIR)"
    Write-Output "AVAILABLE_DOCS:"
    Test-FileExists -Path $paths.RESEARCH -Description 'research.md' | Out-Null
    Test-FileExists -Path $paths.DATA_MODEL -Description 'data-model.md' | Out-Null
    Test-DirHasFiles -Path $paths.CONTRACTS_DIR -Description 'contracts/' | Out-Null
    Test-FileExists -Path $paths.QUICKSTART -Description 'quickstart.md' | Out-Null
}
