export ZSH="$ZDOTDIR/ohmyzsh"
export ZSH_THEME="aube"
export CASE_SENSITIVE="true"
export DISABLE_UPDATE_PROMPT="true"
export plugins=(git docker)

source $ZSH/oh-my-zsh.sh
setopt RM_STAR_SILENT