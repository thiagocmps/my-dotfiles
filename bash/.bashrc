#
# ~/.bashrc
#
# Autor: Thiago Souza
# Para: Uso pessoal, mas pode usar se você gostar
# Editado em: 05/11/2026
#
# DEPENDÊNCIAS:
# bat
# ripgrep
# fast
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach  #usa o blesh-git 


#style
RED='\033[0;31m'
BLUE='\e[34m' 
NC='\033[0m' #sem cor, finaliza as cores
BOLD="\e[1m"
NORMAL="\e[0m"

HARDWARES=("cortana" "rodney" "endurance")

# verifica se existe o path antes de adicionar um novo, evita duplicatas
path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

path_prepend "$HOME/.local/bin"
path_prepend "$HOME/.cargo/bin"
path_prepend "$HOME/.local/share/npm-global/bin"
path_prepend "$HOME/go/bin"
path_prepend "$HOME/flutter-sdk/flutter/bin"

# export de ferramentas
export EDITOR=nvim

#RANGER_LOAD_DEFAULT_R=false #evita que ranger sobreponha o .config local com o global

##PS1='[\u@\h \W]\$ ' #padrão bash  

PS1='\[\e[38;2;230;160;80m\]\u\[\e[0m\]\[\e[38;2;224;108;117m\]@\[\e[0m\]\[\e[38;2;180;140;255m\]\h\[\e[0m\] \[\e[38;2;137;180;250m\]\w\[\e[0m\] \[\e[38;2;230;160;80m\]\$\[\e[0m\] '


alias ff='fastfetch'

# utilities
alias ls='ls --color=auto'
alias grep='rg --color=auto'
alias hl='rg --passthru'
alias ll='ls -lhA --color=auto' #ls but with more detail
alias ls='ls -F -A --color=auto'
alias cls='clear'
alias syncthing-cort='ssh -L 8385:localhost:8384 cortana'
alias cat='bat'
alias ips='ip a | rg inet'
alias ports='sudo netstat -tulanp'
alias vim='nvim'
alias vim.='nvim .'
alias vi='nvim'
alias v.='nvim .'
alias opencode='opencode -c'

#vms and ssh
vm() { 
  if [[ $1 == 'debian' ]]; then
    echo "Iniciando debian" 
    "$HOME/vms/debian-cli/run.sh" "${@:2}"
    local rc=$?
    return $rc
  else echo "Não existe nenhuma vm chamada '$1'"
  fi
}

lis() {
  # How it works: lis [ARG $1 = FILE or DIR to send] [ARG $2 = destiny (HARDWARE)]
  local ARGUMENT_TYPE=""
  local DESTINY="$2"

  # verifica se foi passado algum argumento
  if [[ -z "$1" ]]; then
    echo -e "${RED}Erro:${NC} Nenhum argumento fornecido."
    return 1
  fi

  # verifica se o argumento 2, o destino, foi enviado.
  # se não houver destino, verifica em qual maquina 
  # está a rodar e envia para uma maquina por padrão.
  # 
  # endurance ou qualquer outro: enviar para rodney em ~/ALIS
  # cortana ou rodney: envia para endurance em ~/ALIS 
  if [[ -z "$DESTINY" ]]; then
    if [[ $HOSTNAME == "cortana" || $HOSTNAME == "rodney" ]]; then 
      DESTINY="endurance"
      echo "sending to endurance..."
    else
      DESTINY="rodney"
      echo "sending to rodney..."
    fi
  fi

  if [[ ! " ${HARDWARES[*]} " =~ " $2 " && -n "$DESTINY" ]]; then
    echo -e "Opção inválida\nDestino '$2' não reconhecido."
    return 1
  fi

  # filtragem pelo tipo do argumento: Arquivo ou diretório válido -> passa, do contrário Erro.
  if [[ -f "$1" ]]; then
    ARGUMENT_TYPE="FILE"
    SIZE_BYTES=$(stat -c %s "$1")
  elif [[ -d "$1" ]]; then
    ARGUMENT_TYPE="DIR"
    SIZE_BYTES=$(du -sb "$1" | cut -f1)
  else  
    echo -e "${RED}Erro:${NC} Argumento inválido. Não é um diretório nem arquivo."
    return 1
  fi

  # se arquivo ou diretório tiver mais que 1gb, perguntar se realmente quer enviar o arquivo.
  if (( SIZE_BYTES > 1073741824 )); then
    SIZE_GB=$(awk "BEGIN {printf \"%.2f\", $SIZE_BYTES / 1073741824}")
    if [[ $ARGUMENT_TYPE == "DIR" ]]; then
      echo -e "Diretório ${BLUE}'$1'${NC} tem ${RED}${SIZE_GB}GB${NC}."
      echo -e "Tem certeza que quer enviar para o ${BLUE}Rodney${NC}?"
    elif [[ $ARGUMENT_TYPE == "FILE" ]]; then
      echo -e "Arquivo  ${BLUE}'$1'${NC} tem ${RED}${SIZE_GB}GB${NC}."
      echo -e "Tem certeza que quer enviar para o ${BLUE}${DESTINY}${NC}?"
    fi


    while true; do
      read -r -p "(y/n):" SEND_INPUT
      case $SEND_INPUT in
        Y|y|Yes|yes|S|s|Sim|sim)
          break
          ;;
        N|n|No|no|Nao|nao)
          echo -e "${BLUE}'$1'${NC} não será enviado."
          return 0 
          ;;
        *)
          echo -e "${RED}Resposta inválida.${NC}"
          ;;
      esac
    done
  fi

  # continua aqui a lógica de enviar para o servidor. (usando o rsync por favor ne thiago)
  if rsync -avz --progress "$1" "$DESTINY:/home/thiago/ALIS/"; then
    echo -e "Transferência concluída!\n${BLUE}$1${NC} --> ${BLUE}$DESTINY${NC}:~/ALIS"
  else
    echo -e "Erro durante a transferência.\nTem certeza que tem os hosts no ${BLUE}~/.ssh/config${NC}?"
    return 1
  fi
}

alias nixvm='cd ~/vms/nixOS && quickemu --vm nixos-26.05-graphical.conf'
alias nix-kill='cd ~/vms/nixOS && quickemu --vm nixos-26.05-graphical.conf --kill'

# navigation with cd
alias ..='cd ..'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'

#EXPERIMENTOS
#alias ...='OLD_PWD=$PWD && cd ../../ && echo "$OLD_PWD -> $PWD"'
#alias .3='OLD_PWD=$PWD && cd ../../../ && echo "$OLD_PWD -> $PWD"'
#alias .4='OLD_PWD=$PWD && cd ../../../../ && echo "$OLD_PWD -> $PWD"'
#alias .5='OLD_PWD=$PWD && cd ../../../../../ && echo "$OLD_PWD -> $PWD"'

#pacman and yay (remove that if you dont use arch)
alias cleanup='if [ -n "$(pacman -Qtdq)" ]; then sudo pacman -Rns $(pacman -Qtdq); else echo "Nenhum pacote órfão para remover."; fi && sudo paccache -r'
alias pacq='sudo pacman -Q --noconfirm'
alias pacqinf='sudo pacman -Qil --noconfirm'
alias pacsyu='sudo pacman -Syu && yay -Sua'
alias pacsyyu='sudo pacman -Syyu'
alias pacs='sudo pacman -S'

[[ ${BLE_VERSION-} ]] && ble-attach #blesh-git 

#change the background color to black
printf  "\033]11;#000000\033\\"

. "$HOME/.local/bin/env"
