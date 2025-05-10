$env:DOTFILES = "C:\dotfiles"

{{#if (and OPENAI_BASE_URL OPENAI_API_KEY)}}
# OpenAi environment for git-commit-helper
$env:OPENAI_BASE_URL = {{OPENAI_BASE_URL}}
$env:OPENAI_API_KEY = {{OPENAI_API_KEY}}
{{/if}}

# Go
$env:GO111MODULE = "on"
$env:GOPROXY = "https://goproxy.cn"

# Rust
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# Vcpkg and CMake
# x64-windows \ x64-mingw-dynamic \ x64-mingw-static
$env:VCPKG_TARGET_TRIPLET = {{vcpkg_target}}
$env:VCPKG_DEFAULT_TRIPLET = {{vcpkg_target}}
$env:VCPKG_DEFAULT_HOST_TRIPLET = {{vcpkg_target}}
$env:VCPKG_ROOT = "C:\vcpkg"
$env:CMAKE_TOOLCHAIN_FILE = "$env:VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake"
$env:VK_ADD_LAYER_PATH = "$env:VCPKG_ROOT\installed\$env:VCPKG_TARGET_TRIPLET\bin"

# Android SDK and NDK
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
if (Test-Path $env:ANDROID_HOME) {
    $LatestNDKVersion = Get-ChildItem -Path "$env:ANDROID_HOME\ndk" -ErrorAction SilentlyContinue | Sort-Object Name -Descending | Select-Object -First 1
    if ($LatestNDKVersion -ne $null) {
        $env:NDK_HOME = $LatestNDKVersion.FullName
    }
}

# PATH modifications
$env:PATH += ";C:\run\zed"
$env:PATH += ";$env:ProgramFiles\Sublime Text"
$env:PATH += ";$env:VCPKG_ROOT"

# Aliases
Set-Alias ls eza


function ll {
    param (
        [string]$Path = "."
    )
    eza -l $Path
}

function la {
    param (
        [string]$Path = "."
    )
    eza -a $Path
}

function gitlg {
    param (
        [string]$Count
    )

    $command = "git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

    if ($Count) {
        $command += " $Count"
    }

    Invoke-Expression $command
}

function proxy {
    $env:HTTP_PROXY = "127.0.0.1:10808"
    $env:HTTPS_PROXY = "127.0.0.1:10808"
}

function unproxy {
    Remove-Item Env:HTTP_PROXY -ErrorAction SilentlyContinue
    Remove-Item Env:HTTPS_PROXY -ErrorAction SilentlyContinue
}

Set-PSReadlineKeyHandler -Key ctrl+d -Function ViExit
Set-PsFzfOption -PSReadlineChordProvider ctrl+t -PSReadlineChordReverseHistory ctrl+r
