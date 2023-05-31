#!/usr/bin/env zsh

# oh-my-zsh Bureau Theme

### Fix Color
#fg[black]="\[\033[30m\]"
#fg[red]="\[\033[31m\]"
#fg[green]="\[\033[32m\]"
#fg[yellow]="\[\033[33m\]"
#fg[blue]="\[\033[34m\]"
#fg[magenta]="\[\033[35m\]"
#fg[cyan]="\[\033[36m\]"
#fg[light]="\[\033[37m\]"
fg[gray]=$FG[059]
fg[grey]=$FG[059]
#fg[white]="\[\033[39m\]"

#for key val in ${(kv)FG}; do
#    echo "$val $key"
#done

### Git [±master ▾●]

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[gray]%}[ %{$fg[green]%}±%{$reset_color%}%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$fg[gray]%} ]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}✓%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[cyan]%}▴%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[magenta]%}▾%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_STAGED="%{$fg[green]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$fg[yellow]%}●%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[red]%}●%{$reset_color%}"

aube_git_branch () {
  ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
  echo "${ref#refs/heads/}"
}

aube_git_status() {
  _STATUS=""

  # check status of files
  _INDEX=$(command git status --porcelain 2> /dev/null)
  if [[ -n "$_INDEX" ]]; then
    if $(echo "$_INDEX" | command grep -q '^[AMRD]. '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
    fi
    if $(echo "$_INDEX" | command grep -q '^.[MTD] '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
    fi
    if $(echo "$_INDEX" | command grep -q -E '^\?\? '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
    fi
    if $(echo "$_INDEX" | command grep -q '^UU '); then
      _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
    fi
  else
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
  fi

  # check status of local repository
  _INDEX=$(command git status --porcelain -b 2> /dev/null)
  if $(echo "$_INDEX" | command grep -q '^## .*ahead'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*behind'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi
  if $(echo "$_INDEX" | command grep -q '^## .*diverged'); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_DIVERGED"
  fi

  if $(command git rev-parse --verify refs/stash &> /dev/null); then
    _STATUS="$_STATUS$ZSH_THEME_GIT_PROMPT_STASHED"
  fi

  echo $_STATUS
}

aube_git_prompt () {
  local _branch=$(aube_git_branch)
  local _status=$(aube_git_status)
  local _result=""
  if [[ "${_branch}x" != "x" ]]; then
    _result="$ZSH_THEME_GIT_PROMPT_PREFIX $_branch"
    if [[ "${_status}x" != "x" ]]; then
      _result="$_result $_status"
    fi
    _result="$_result$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
  echo $_result
}

_PATH="%{$fg[gray]%}[ %{$fg[green]%}%~%{$reset_color%} %{$fg[gray]%}]%{$reset_color%}"

if [[ $EUID -eq 0 ]]; then
  _USERNAME="%{$fg[red]%}%n%{$reset_color%}"
else
  _USERNAME="%{$fg[cyan]%}%n%{$reset_color%}"
fi
_USERNAME="%M%{$reset_color%}:$_USERNAME"


get_space () {
  local STR=$1$2
  local zero='%([BSUbfksu]|([FB]|){*})'
  local LENGTH=${#${(S%%)STR//$~zero/}}
  local SPACES=""
  (( LENGTH = ${COLUMNS} - $LENGTH - 1 ))

  for i in {0..$LENGTH}
    do
      SPACES="$SPACES "
    done

  echo $SPACES
}

_1LEFT="$_PATH"
_1RIGHT="%{$fg[gray]%}[%{$fg[white]%} %* %{$fg[gray]%}]%{$reset_color%}"
_DATE="$_1RIGHT"

aube_precmd () {
  _1SPACES=`get_space "$_1LEFT$(aube_git_prompt)" "$_DATE"`
  print -rP "$_1LEFT$(aube_git_prompt)$_1SPACES$_DATE"
}

setopt globdots
setopt prompt_subst
PROMPT='$_USERNAME$ '
RPROMPT=''

autoload -U add-zsh-hook
add-zsh-hook precmd aube_precmd