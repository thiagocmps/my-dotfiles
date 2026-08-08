#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach  #usa o blesh-git 

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/npm-global/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export EDITOR=nvim

RANGER_LOAD_DEFAULT_R=false #evita que ranger sobreponha o .config local com o global

##PS1='[\u@\h \W]\$ ' #padrão bash  

PS1='\[\e[38;2;230;160;80m\]\u\[\e[0m\]\[\e[38;2;224;108;117m\]@\[\e[0m\]\[\e[38;2;180;140;255m\]\h\[\e[0m\] \[\e[38;2;137;180;250m\]\w\[\e[0m\] \[\e[38;2;230;160;80m\]\$\[\e[0m\] '

# DEPEDENCIES
# bat
# ripgrep
# fast
#

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
alias ips='ip a | rg inet '
alias ports='sudo netstat -tulanp'
alias vim='nvim'
alias vim.='nvim .'

#vms and ssh
alias debianvm='cd ~/vms/debian && quickemu --vm debian-13.6.0-netinst.conf'
#alias debianvm='cd ~/vms/debian && quickemu --vm debian-13.6.0-netinst.conf | sleep 20 && ssh -v thiago@localhost -p 22220'
alias debianvm-kill='cd ~/vms/debian && quickemu --vm debian-13.6.0-netinst.conf --kill'

# navegation with cd
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

#pacman and yay (remove that if you dont use arch (btw))
alias cleanup='if [ -n "$(pacman -Qtdq)" ]; then sudo pacman -Rns $(pacman -Qtdq); else echo "Nenhum pacote órfão para remover."; fi && sudo paccache -r'
alias pacq='sudo pacman -Q --noconfirm'
alias pacqinf='sudo pacman -Qil --noconfirm'
alias pacsyu='sudo pacman -Syu && yay -Sua'
alias pacsyyu='sudo pacman -Syyu'
alias pacs='sudo pacman -S'

#ssh aliases 
alias cortana-jellyfin-reset='ssh -t cortana "cd /dockers/jellyfin/ && docker compose down && docker compose up -d"'

[[ ${BLE_VERSION-} ]] && ble-attach #blesh-git 
