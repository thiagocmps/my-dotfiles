#!/bin/bash
CONFIG_PATH="$HOME/.config"

RED='\033[0;31m'
GREY='\033[90m'
GREEN='\e[32m'
BLUE='\e[34m' 
NC='\033[0m' #sem cor, finaliza as cores
BOLD="\e[1m"
NORMAL="\e[0m"

set -e

cd "$(dirname "${BASH_SOURCE[0]}")/.."

#menu verificação do sistema operacional
#verifica o sistema operativo e define seu respectivo package manager
if [[ "$OSTYPE" =~ ^linux ]]; then
  if [ -f /etc/os-release ]; then    
    source /etc/os-release
    # A variável $ID contém o nome curto da distro (ex: ubuntu, debian, fedora)
    case "$ID" in
      ubuntu|debian)
        echo -e "Sistema ${BOLD}Debian${NORMAL} detectado ($ID)"
        PKG_MANAGER="sudo apt install -y"
        THIS_OS_TYPE="debian"
        ;;
      fedora|rhel|centos)
        echo -e "Sistema ${BOLD}RedHat${NORMAL} detectado ($ID)"
        PKG_MANAGER="sudo dnf install -y"  
        THIS_OS_TYPE="fedora"
        ;;
      alpine)
        echo -e "Sistema ${BOLD}Alpine Linux${NORMAL} detectado"
        PKG_MANAGER="apk add -y"
        THIS_OS_TYPE="alpine"
        ;;
      arch)
        echo -e "Sistema ${BOLD}Arch Linux${NORMAL} detectado"
        PKG_MANAGER="sudo pacman -S --noconfirm"
        THIS_OS_TYPE="arch"
        ;;
      *)
        echo -e "Distribuição Linux não identificada: $ID"
        echo -e "${GREY}Vou compilar o nvim mesmo assim, me diz se funcionou :D${NC}"
        THIS_OS_TYPE="other_linux"
        ;;
    esac
  else
    echo -e "Arquivo /etc/os-release não encontrado. Sistema muito antigo?"
    echo -e "${BOLD}${RED}Abortado${NC}${NORMAL}"
    exit 1
  fi
  #id do MacOS
elif [[ "$OSTYPE" =~ ^darwin ]] then
  echo -e  "Está a usar ${BOLD}MacOS${NORMAL}"
  PKG_MANAGER="brew install"
elif  [[ "$OSTYPE" =~ ^msys ||  "$OSTYPE" =~ ^cygwin  ]] then
  echo -e "${RED}Script não continuará, sistema Windows detectado.${NC}"
fi

#Menu instalacao do stow 
#caso nao tenha Stow instalado, instala com pkgmanager
if ! command -v stow -v >/dev/null 2>&1; then
  echo -e "${BOLD}GNU Stow${NORMAL} necessário para continuar, deseja instalar? (caso decidir que não, o script irá fechar, sem nenhuma alteração no sistema)\n"
  read  -r  -p "(Y/n): " STOW_INPUT 
  case "$STOW_INPUT" in
    Y|y|s|S) 
      if [ -z "$PKG_MANAGER" ]; then
        echo -e "${RED}Nenhum gerenciador de pacotes detectado. Instale o GNU Stow manualmente e rode de novo.${NC}"
        exit 1
      fi
      echo -e "${BOLD}Instalando stow${NORMAL}"
      $PKG_MANAGER stow
      ;;    
    N|n) 
      echo -e "Stow não será instalado, saindo do script..."
      exit
      ;;
    *)
      echo -e "${RED}Opção inválida, saindo do script...${NC}"
      exit 1
      ;;
  esac
else
  echo -e "${BOLD}GNU Stow${NORMAL} encontrado!"
fi 

#Instalacao do nvim
if ! command -v nvim &> /dev/null; then
  echo -e "Neovim não foi encontrado, instalando..."
  # compilar neovim do repositorio oficial, em desenvolvimento

  if  [[ $THIS_OS_TYPE =~ ^debian ]]; then  
    echo -e  "Sistema $THIS_OS_TYPE detectado. Compilando Nvim do repositório oficial..."
    $PKG_MANAGER ninja-build cmake gcc g++ make unzip gettext curl git

    rm -rf /tmp/neovim && git clone -b stable --single-branch https://github.com/neovim/neovim.git /tmp/neovim && ( cd /tmp/neovim && make CMAKE_BUILD_TYPE=Release && sudo make install )
  else
    $PKG_MANAGER nvim
  fi
fi

#Funções principais
#nvim
function install_nvim {
  # Symlink é do próprio stow (o restow resolve); só faz backup de diretório real
  if [[ -d "$CONFIG_PATH" && ! -L "$CONFIG_PATH" && -d "$CONFIG_PATH/nvim" && ! -L "$CONFIG_PATH/nvim" ]]; then
    echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}"nvim-backup"${NORMAL} com as configurações antigas."

    if [[ -e "$CONFIG_PATH/nvim-backup" ]]; then
      echo -e "Já existe um backup em $CONFIG_PATH/nvim-backup"
      echo -e "${RED}Abortando...${NORMAL}"
      exit 1
    fi

    mv "$CONFIG_PATH/nvim" "$CONFIG_PATH/nvim-backup" && echo -e "Backup criado!" 
  fi

  stow -v --restow --target="$HOME" nvim && echo -e "${GREEN}Configuração instalada com sucesso!${NC}"
}

#bashrc & blerc
function install_bashrc {
  if [[ -e "$HOME/.bashrc-backup" ]]; then
    echo -e "Já existe um backup em $HOME/.bashrc-backup"
    echo -e "${RED}Abortando...${NORMAL}"
    return 1
  fi

  if [[ -f /usr/share/blesh/ble.sh ]]; then
    echo -e "ble.sh está instalado e ativo!"
  elif [[ $THIS_OS_TYPE == "arch" ]]; then
    if command -v yay &>/dev/null; then
      yay -S --noconfirm blesh-git
    elif command -v paru &>/dev/null; then
      paru -S --noconfirm blesh-git
    else
      echo -e "${RED}ble.sh não está instalado. Instale 'blesh-git' pelo AUR e rode de novo.${NC}"
      return 1
    fi
  else
    $PKG_MANAGER blesh
  fi

  if [[ -e "$HOME/.blerc-backup" ]]; then
    echo -e "Já existe um backup em $HOME/.blerc-backup"
    echo -e "${RED}Abortando...${NORMAL}"
    return 1
  fi

  #verifica se existe .bashrc, caso exista cria um backup
  if [[ -f "$HOME/.bashrc" ]]; then
    echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}.bashrc-backup${NORMAL} com as configurações antigas."

    mv "$HOME/.bashrc" "$HOME/.bashrc-backup" && echo -e "Backup criado!" 
  fi

  #mesma coisa mas com blerc
  if [[ -f "$HOME/.blerc" ]]; then
    echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}.blerc-backup${NORMAL} com as configurações antigas."
    mv "$HOME/.blerc" "$HOME/.blerc-backup" && echo -e "Backup criado!" 
  fi

  if stow -v --restow --target="$HOME" bash; then
    echo -e "Configuração instalada com sucesso!"
  else
    echo -e "${RED}Erro: Falha ao executar o GNU Stow.${NORMAL}"
    return 1
  fi
}



#Menu CLI
printf "\n"

printf "Escolha as configurações a serem instaladas:\n\n"

printf "${BLUE}[0]${NC} Instalar todos\n"
printf "${BLUE}[1]${NC} Neovim\n"
printf "${BLUE}[2]${NC} .bashrc\n"

#printf "\n"
#printf '%*s\n' "$(tput cols)" '' | tr ' ' '='
#printf "\n"

printf "\n"

printf "${GREY}É necessário ter o nvim na última versão para as configurações funcionarem sem problemas. Leia a documentação no Github para mais detalhes.${NC}"
while true; do
  printf "\n"
  read -r -p ">: " INPUT || exit 1

  case "$INPUT" in
    0) 
      echo -e "${BOLD}Instalando tudo...${NC}"
      install_nvim && install_bashrc && echo -e "Instalados com sucesso" 
      break
      ;;  
    1)
      echo -e "Instalando neovim..."
      install_nvim
      break
      ;;  
    2)
      echo -e "${BOLD}Instalando .bashrc...${NC}"
      install_bashrc
      break
      ;;
    *) 
      echo -e "${RED}Opção Inválida.${NC}"
      ;;  
  esac
done
