#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach  #usa o blesh-git 

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/share/npm-global/bin:$PATH"

RANGER_LOAD_DEFAULT_RC=false #evita que ranger sobreponha o .config local com o global

##PS1='[\u@\h \W]\$ ' #padrão bash  

PS1='\[\e[38;2;230;160;80m\]\u\[\e[0m\]\[\e[38;2;224;108;117m\]@\[\e[0m\]\[\e[38;2;180;140;255m\]\h\[\e[0m\] \[\e[38;2;137;180;250m\]\w\[\e[0m\] \[\e[38;2;230;160;80m\]\$\[\e[0m\] '

alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias hl='rg --passthru'
alias ll='ls -lha --color=auto' #ls but with more detail
alias ls='ls -F -a --color=auto'

#ssh aliases 
alias cortana-jellyfin-reset='ssh -t cortana "cd /dockers/jellyfin/ && docker compose down && docker compose up -d"'

[[ ${BLE_VERSION-} ]] && ble-attach #blesh-git 
