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
