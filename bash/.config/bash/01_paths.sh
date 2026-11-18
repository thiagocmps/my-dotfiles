# ~/.config/bash/colours.sh

# verifica se existe o path antes de adicionar um novo, evita duplicatas
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# adiciona aqui o caminho
path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.local/share/npm-global/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/flutter-sdk/flutter/bin"
