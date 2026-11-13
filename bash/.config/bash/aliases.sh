# ~/.config/bash/aliases.sh
alias ..='cd ..'
alias ...='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'

# coisas bobas
alias ff='fastfetch'
# alias ...='OLD_PWD=$PWD && cd ../../ && echo "$OLD_PWD -> $PWD"'
# alias .3='OLD_PWD=$PWD && cd ../../../ && echo "$OLD_PWD -> $PWD"'
# alias .4='OLD_PWD=$PWD && cd ../../../../ && echo "$OLD_PWD -> $PWD"'
# alias .5='OLD_PWD=$PWD && cd ../../../../../ && echo "$OLD_PWD -> $PWD"'

# utilities
alias grep='rg --color=auto' # grep com highlight
alias hl='rg --passthru' # highlight de texto
alias ll='ls -lhA --color=auto' # ls but with more detail
alias ls='ls -F -A --color=auto' # ls com identificacao de pasta e ".files" 
alias cat='bat' # bat é incrível
alias ips='ip a | rg inet' #ip a com grep do inet, ip
alias ports='sudo netstat -tulanp'
alias vim='nvim'
alias vim.='nvim .'
alias vi='nvim'
alias v.='nvim .'
alias opencode='opencode -c'

# pacman and yay (remove it if you dont use archlinux or any other distro arch-based)
alias cleanup='if [ -n "$(pacman -Qtdq)" ]; then sudo pacman -Rns $(pacman -Qtdq); else echo "Nenhum pacote órfão para remover."; fi && sudo paccache -r'
alias pacq='sudo pacman -Q --noconfirm'
alias pacqinf='sudo pacman -Qil --noconfirm'
alias pacsyu='sudo pacman -Syu && yay -Sua'
alias pacsyyu='sudo pacman -Syyu'
