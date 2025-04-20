# This is the PowerShell profile script that runs at startup.
# It sets up the environment variables and aliases for the PowerShell session.
$env:DOTFILES = "C:\dotfiles"

# Rust
$env:RUSTUP_DIST_SERVER = "https://rsproxy.cn"
$env:RUSTUP_UPDATE_ROOT = "https://rsproxy.cn/rustup"

# Vcpkg and CMake
$env:VCPKG_TARGET_TRIPLET = "x64-mingw-dynamic"
$env:VCPKG_DEFAULT_TRIPLET = "x64-mingw-dynamic"
$env:VCPKG_DEFAULT_HOST_TRIPLET = "x64-mingw-dynamic"
$env:VCPKG_ROOT = "C:\vcpkg"
$env:CMAKE_TOOLCHAIN_FILE = "$env:VCPKG_ROOT\scripts\buildsystems\vcpkg.cmake"
$env:VK_ADD_LAYER_PATH = "$env:VCPKG_ROOT\installed\x64-mingw-dynamic\bin"

# Android SDK and NDK
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
$LatestNDKVersion = Get-ChildItem -Path "$env:LOCALAPPDATA\Android\Sdk\ndk" | Sort-Object Name -Descending | Select-Object -First 1
if ($LatestNDKVersion -ne $null) {
    $env:NDK_HOME = $LatestNDKVersion.FullName
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
