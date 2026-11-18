#
# ~/.bashrc
#
# Autor: Thiago Souza
# Para: Uso pessoal
# Criado no dia 5 de julho, 2026
#
# Dependências:
# - bat
# - ripgrep
# - fast
# - pv
# 

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
[[ $- == *i* ]] && source /usr/share/blesh/ble.sh --noattach  #usa o blesh-git 

# importa todos os scripts dentro de ~/.config/bash/ para o .bashrc
for file in "$HOME/.config/bash/"*.sh; do
    [[ -f "$file" ]] && source "$file"
done

#RANGER_LOAD_DEFAULT_R=false #evita que ranger sobreponha o .config local com o global

##PS1='[\u@\h \W]\$ ' #padrão bash  
PS1='\[\e[38;2;230;160;80m\]\u\[\e[0m\]\[\e[38;2;224;108;117m\]@\[\e[0m\]\[\e[38;2;180;140;255m\]\h\[\e[0m\] \[\e[38;2;137;180;250m\]\w\[\e[0m\] \[\e[38;2;230;160;80m\]\$\[\e[0m\] '

[[ ${BLE_VERSION-} ]] && ble-attach #blesh-git 

. "$HOME/.local/bin/env"
