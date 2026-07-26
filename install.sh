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

cd "$(dirname "$0")"

#menu verificação do sistema operacional
#verifica o sistema operativo e define seu respectivo package manager
if [[ "$OSTYPE" =~ ^linux ]]; then
  if [ -f /etc/os-release ]; then    
    source /etc/os-release
    # A variável $ID contém o nome curto da distro (ex: ubuntu, debian, fedora)
    case "$ID" in
      ubuntu|debian)
        echo -e "Sistema ${BOLD}Debian${NORMAL} detectado ($ID)"
        PKG_MANAGER="sudo apt install"
        THIS_OS_TYPE="debian"
        ;;
      fedora|rhel|centos)
        echo -e "Sistema ${BOLD}RedHat${NORMAL} detectado ($ID)"
        PKG_MANAGER="sudo dnf install"  
        THIS_OS_TYPE="fedora"
        ;;
      alpine)
        echo -e "Sistema ${BOLD}Alpine Linux${NORMAL} detectado"
        PKG_MANAGER="apk add"
        THIS_OS_TYPE="alpine"
        ;;
      arch)
        echo -e "Sistema ${BOLD}Arch Linux${NORMAL} detectado"
        PKG_MANAGER="sudo pacman -S"
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
  fi
  #id do MacOS
elif [[ "$OSTYPE" =~ ^darwin ]] then
  echo -e  "Está a usar ${BOLD}MacOS${NORMAL}"
  PKG_MANAGER="brew install"
elif  [[ "$OSTYPE" =~ ^msys ||  "$OSTYPE" =~ ^cygwin  ]] then
  echo -e "${RED}Script não continuará, sistema Windows detectado.${RC}"
fi

#Menu instalacao do stow 
#caso nao tenha Stow instalado, instala com pkgmanager
if ! command -v stow -v >/dev/null 2>&1; then
  echo -e "${BOLD}GNU Stow${NORMAL} necessário para continuar, deseja instalar? (caso decidir que não, o script irá fechar, sem nenhuma alteração no sistema)\n"
  read  -r  -p "(Y/n): " STOW_INPUT 
  case "$STOW_INPUT" in
    Y|y|s|S) 
      echo -e "${BOLD}Instalando stow${NORMAL}"
      $PKG_MANAGER stow
      break
      ;;    
    N|n) 
      echo -e "Stow não será instalado, saindo do script..."
      exit
      break
      ;;
  esac
else
  echo -e "${BOLD}GNU Stow${NORMAL} encontrado!"
fi 

#Instalacao do nvim
if ! command -v nvim &> /dev/null; then
  echo -e "Neovim não foi encontrado, instalando..."
  # compilar neovim do repositorio oficial, em desenvolvimento

  if  [[ $THIS_OS_TYPE =~ ^debian  || $THIS_OS_TYPE =~ ^fedora  ]] then  
    echo -e  "Sistema $THIS_OS_TYPE detectado. Compilando Nvim do repositório oficial..."
    # 1. Instala as dependências usando a sua variável (funciona para Debian e Fedora)
    $PKG_MANAGER ninja-build cmake gcc g++ make unzip gettext curl git

    # 2. Baixa, compila e instala o Neovim estável em uma única linha de comandos encadeados
    rm -rf /tmp/neovim && git clone -b stable --single-branch https://github.com/neovim/neovim.git /tmp/neovim && cd /tmp/neovim && make CMAKE_BUILD_TYPE=Release && sudo make install
    PKG_MANAGER  else
    $PKG_MANAGER nvim
  fi   
  $PKG_MANAGER nvim
fi

#Funções principais
#nvim
function install_nvim {
  if [[ -d "$CONFIG_PATH/nvim" ]]; then
    echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}"nvim-backup"${NORMAL} com as configurações antigas."

    if [[ -e "$CONFIG_PATH/nvim-backup" ]]; then
      echo -e "Já existe um backup em $CONFIG_PATH/nvim-backup"
      echo -e "${RED}Abortando...${NORMAL}"
      exit 1
    fi

    mv "$CONFIG_PATH/nvim" "$CONFIG_PATH/nvim-backup" && echo -e "Backup criado!" 
    stow -v --target="$HOME" nvim && echo -e "${GREEN}Configuração instalada com sucesso!${NC}"
  else 
    stow -v --target="$HOME" nvim && echo -e "${GREEN}Configuração instalada com sucesso!${NC}"
  fi 
}

#nvim
function install_bashrc {
  if [[ -f "$HOME/.bashrc" ]]; then
    echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}.bashrc-backup${NORMAL} com as configurações antigas."
    if [[ -e "$HOME/.bashrc-backup" ]]; then
      echo -e "Já existe um backup em $HOME/.bashrc-backup"
      echo -e "${RED}Abortando...${NORMAL}"
      exit 1
    fi
    if [[ -f "$HOME/.blerc" ]]; then
      echo -e "Há uma configuração ativa. Vai ser criado ${BOLD}.blerc-backup${NORMAL} com as configurações antigas."
      if [[ -e "$HOME/.blerc-backup" ]]; then
        echo -e "Já existe um backup em $HOME/.blerc-backup"
        echo -e "${RED}Abortando...${NORMAL}"
        exit 1
      fi
    fi
    mv "$HOME/.bashrc" "$HOME/.bashrc-backup" && echo -e "Backup criado!" 
    stow -v --target="$HOME" bash && echo -e "Configuração instalada com sucesso!"
  else 
    stow -v --target="$HOME" bash && echo -e "Configuração instalada com sucesso!"
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
  read -r -p ">: " INPUT

  case "$INPUT" in
    0) 
      echo -e "${BOLD}Instalando tudo...${NC}"
      install_nvim && install_bashrc && echo -e "Instalados com sucesso" 
      break
      ;;  
    1)
      echo -e "Instalando neovim..."
      install_nvim && echo -e "${GREEN}"
      break
      ;;  
    2)
      echo -e "${BOLD}Instalando .bashrc...${NC}"
      install_bashrc
      break
      ;;
    *) 
      echo -e "${RED}Opção Inválida.${NC}"
      break
      ;;  
  esac
done
