# GO LANG
export PATH="$PATH:/usr/local/go/bin/"
# CUDA
export PATH="$PATH:/usr/local/cuda-11.0/bin"
# Fetch Cord - https://github.com/MrPotatoBobx/FetchCord#installing-on-gnulinux
export PATH="$HOME/.local/bin:$PATH"

export PYTHONDONTWRITEBYTECODE=1

# LS_COLORS
source ~/.local/share/lscolors.sh

[ -f ~/.exports ] && source ~/.exports
