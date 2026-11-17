# ~/.config/bash/exports.sh
export EDITOR=nvim

# sistema operativo e package manager do sistema
# THIS_OS_TYPE e PKG_MANAGER
if [[ "$OSTYPE" == linux* ]]; then
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release

        case "$ID" in
            ubuntu|debian)
                export THIS_OS_TYPE="debian"
                export PKG_MANAGER="apt"
                ;;
            fedora|rhel|centos)
                export THIS_OS_TYPE="fedora"
                export PKG_MANAGER="dnf"
                ;;
            alpine)
                export THIS_OS_TYPE="alpine"
                export PKG_MANAGER="apk"
                ;;
              arch)
                export THIS_OS_TYPE="arch"
                export PKG_MANAGER="pacman"
                ;;
            *)
                export THIS_OS_TYPE="other_linux"
                ;;
        esac
    fi

elif [[ "$OSTYPE" == darwin* ]]; then
    export THIS_OS_TYPE="macos"
    export PKG_MANAGER="brew"

elif [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
    export THIS_OS_TYPE="windows"
fi
