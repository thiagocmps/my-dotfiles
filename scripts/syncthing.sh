#!/bin/bash
SYNC_DIR_NAME='synced-directories'

# ID único da pasta (precisa ser IGUAL em todos os dispositivos)
COLD_BACKUP_ID="0hdd-storage-cold-backup"
DRAWINGS_ID="krita-drawings"
EMACS_ID="emac-main"
OBSIDIAN_ID="nsya9-d4te9"

# 1. Detectar o Sistema Operacional
OS="$(uname -s)"
case "${OS}" in
  Linux*)
    # Verifica se é Android (Termux) ou Linux Desktop
    if [ -d "/data/data/com.termux" ]; then
      echo "Detectado: Android (Termux)"
      THIS_OS_TYPE="TERMUX"
      CONFIG_DIR="$HOME/.local/state/syncthing"
      SYNC_PATH="$HOME/storage/shared/$SYNC_DIR_NAME"
      PKG_MANAGER="pkg install -y"
    else
      echo "Detectado: Linux"
      if [[ -f /etc/os-release ]] && command -v systemctl &>/dev/null; then
        source /etc/os-release
        # A variável $ID contém o nome curto da distro (ex: ubuntu, debian, fedora)
        case "$ID" in
          ubuntu|debian)
            echo "Está a usar uma base Debian ($ID)"
            PKG_MANAGER="sudo apt install -y"
            THIS_OS_TYPE="debian"
            echo "$PKG_MANAGER"
            ;;
          fedora|rhel|centos)
            echo "Estás a usar uma base Red Hat ($ID)"
            PKG_MANAGER="sudo dnf install -y"  
            THIS_OS_TYPE="fedora"
            echo "$PKG_MANAGER"
            ;;
          alpine)
            echo "Estás a usar Alpine Linux"
            PKG_MANAGER="apk add"
            THIS_OS_TYPE="alpine"
            echo "$PKG_MANAGER"
            ;;
          arch)
            echo "Estás a usar Arch Linux"
            PKG_MANAGER="sudo pacman -S --noconfirm"
            THIS_OS_TYPE="arch"
            echo "$PKG_MANAGER"
            ;;
          *)
            echo "Distribuição Linux não identificada: $ID"
            echo  "Vou compilar o nvim mesmo assim, me diz se funcionou :D"
            THIS_OS_TYPE="other_linux"
            ;;
        esac
      fi
      if [ -d "$HOME/.local/state/syncthing" ]; then
        CONFIG_DIR="$HOME/.local/state/syncthing"
      elif [ -d "$HOME/.config/syncthing" ]; then
        CONFIG_DIR="$HOME/.config/syncthing"
      else
        # Caso o Syncthing nunca tenha rodado na máquina, assume o padrão moderno
        CONFIG_DIR="$HOME/.local/state/syncthing"
      fi
      SYNC_PATH="$HOME/$SYNC_DIR_NAME"
    fi
    ;;
  Darwin*)
    echo "Detectado: macOS"
    CONFIG_DIR="$HOME/Library/Application Support/Syncthing"
    SYNC_PATH="$HOME/$SYNC_DIR_NAME"
    PKG_MANAGER="brew install"
    ;;
  CYGWIN*|MINGW32*|MSYS*|MINGW*)
    echo "Detectado: Windows"
    echo "Sistema não suportado. Abortado."
    exit 1
    ;;
  *)
    echo "Sistema operacional desconhecido."
    exit 1
    ;;
esac

if ! command -v syncthing; then
  $PKG_MANAGER syncthing
fi

case "$THIS_OS_TYPE" in
  ubuntu|fedora|arch)
    echo "Ativando serviço via Systemd..."
    systemctl --user enable --now syncthing.service
    ;;
  TERMUX)
    echo "Ativando serviço via Termux-Services..."
    if ! command -v sv-enable &>/dev/null; then
      pkg install termux-services -y
    fi
    sv-enable syncthing
    sv up syncthing 
    ;;
esac

# 2. Criar o diretório de sincronização se não existir
mkdir -p "$SYNC_PATH"


# 3. Validar se o Syncthing já gerou o config.xml inicial
if [ ! -f "$CONFIG_DIR/config.xml" ]; then
  echo "Erro: config.xml não encontrado. Inicie o Syncthing uma vez para gerar o arquivo base."
  exit 1
fi

echo "Configurando a pasta no diretório: $CONFIG_DIR"

# Pegar a API Key automaticamente do arquivo de configuração
API_KEY=$(grep -oP '(?<=<apikey>)[^<]+' "$CONFIG_DIR/config.xml")

echo "API KEY IS: $API_KEY"
# Adicionar a pasta via API enviando um JSON com o caminho correto detectado pelo script

#essa é a mais pesada, pra testes eu vou usar a do doom emacs


echo "Deseja syncronizar 'cold-backup-dir'? (S/s|N/n)"
read INPUT_BACKUP

if [[ "$INPUT_BACKUP" == "S" || "$INPUT_BACKUP" == "s" ]]; then
  echo "Sincronizando em cold-backup..."
  curl -X POST -H "X-API-Key: $API_KEY" -d '{
    "id": "'"$COLD_BACKUP_ID"'",
    "label": "cold-backup-dir",
    "path": "'"$SYNC_PATH"'/cold-backup",
    "type": "send"
  }' http://127.0.0.1:8384/rest/config/folders
fi

echo "Deseja sincronizar 'drawings-dir'? (S/s|N/n)"
read INPUT_DRAWINGS

if [[ $INPUT_DRAWINGS == "S" || $INPUT_DRAWINGS == "s" ]]; then 
  echo "Sincronizando em drawings..."
  curl -X POST -H "X-API-Key: $API_KEY" -d '{
    "id": "'"$DRAWINGS_ID"'",
    "label": "drawings-dir",
    "path": "'"$SYNC_PATH"'/drawings",
    "type": "sendreceive"
  }' http://127.0.0.1:8384/rest/config/folders
fi

curl -X POST -H "X-API-Key: $API_KEY" -d '{
  "id": "'"$EMACS_ID"'",
  "label": "emacs-dir",
  "path": "'"$SYNC_PATH"'/doom-emacs",
  "type": "sendreceive"
}' http://127.0.0.1:8384/rest/config/folders

curl -X POST -H "X-API-Key: $API_KEY" -d '{
  "id": "'"$OBSIDIAN_ID"'",
  "label": "obsidian-dir",
  "path": "'"$SYNC_PATH"'/obsidian",
  "type": "sendreceive"
}' http://127.0.0.1:8384/rest/config/folders
