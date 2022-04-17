# General {{{
#---------------------------------------------------------------------------------

# Set history
HISTSIZE=100000
HISTFILE="$HOME/.history"
SAVEHIST=$HISTSIZE
setopt inc_append_history
setopt share_history

unsetopt nomatch

# Set default pager
export PAGER=most

# Set word characters
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# Setup rvm
[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"

# Setup mysql
export DYLD_LIBRARY_PATH=/usr/local/mysql/lib/
export PATH="$PATH:/usr/local/mysql/bin/"
export PATH="$PATH:/usr/local/Cellar/smlnj/110.72/libexec/bin"

# Setup tomcat
export JAVA_HOME=$(/usr/libexec/java_home)
export CATALINA_HOME=/usr/local/tomcat

#Custom commands inside
export PATH="$PATH:$HOME/dotfiles/bin"
# }}}
# Auto completion {{{
#---------------------------------------------------------------------------------

autoload -U compinit
compinit -C

zstyle ':completion:*' menu select
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*:*:*:*:processes' command "ps -u `whoami` -o pid,user,comm -w -w"
# }}}
# Key bindings {{{
#---------------------------------------------------------------------------------
#
# Ctrl-n      Insert sudo prefix
# Esc-e       Edit the current line in editor
# Ctrl-x f    Insert files
# Ctrl-t      Tetris
#
# Ctrl-b      Go back one word
# Ctrl-f      Go forward one word
# Ctrl-w      Delete the previous word
#
#---------------------------------------------------------------------------------

insert-root-prefix () {
   local prefix
   case $(uname -s) in
      "SunOS")
         prefix="pfexec"
      ;;
      *) 
         prefix="sudo"
      ;;
   esac
   BUFFER="$prefix $BUFFER"
   CURSOR=$(($CURSOR + $#prefix + 1))
}

zle -N insert-root-prefix
bindkey "^J" insert-root-prefix

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^[e' edit-command-line
bindkey '^X^E' edit-command-line
bindkey -M vicmd v edit-command-line

autoload -U insert-files
zle -N insert-files
bindkey "^Xf" insert-files

bindkey "^W" backward-kill-word
bindkey "^B" backward-word
bindkey "^F" forward-word

# Tetris
autoload -U tetris
zle -N tetris
bindkey "^t" tetris
# }}}
# Prompt {{{
#---------------------------------------------------------------------------------

# Get the name of the branch we are on
git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo " (${ref#refs/heads/})"
}
#Get the number of suspended jobs
suspended_jobs() {
  jobs=$(jobs | grep "suspended" | wc -l | xargs)
  if [ $jobs -ne 0 ]; then
      echo " [$jobs]"
  fi
}

autoload -U colors
colors
setopt prompt_subst
PROMPT='%{$fg[yellow]%}%c%{$fg[cyan]%}$(suspended_jobs)%{$fg[red]%}$(git_prompt_info)%{$fg[yellow]%} ⇢  %{$reset_color%}'
RPROMPT='%{$fg_bold[red]%}eirene%{$reset_color%}'
# }}}
# Custom commands {{{
#---------------------------------------------------------------------------------

# git shortcut
g() {
    if [[ $# == 0 ]]; then
        git status
    else
        git $*
    fi
}

# navigates back to the root folder of the current project
rt() {
    while [ ! -d ".git" ]; do
        cd ..
    done 
}

# a shortcut for my projects directory that supports auto-completion
#from https://github.com/holman/dotfiles
c() { 
    cd ~/work/$*
}

compdef '_files -W ~/work -/' c


a() {
    cd ~/algo/$*
}

compdef '_files -W ~/algo -/' a

cdl() {
    cd $*;
    l
}

dotf() {
    if [[ $# == 0 ]]; then
        cd ~/dotfiles
    else
        vi ~/dotfiles/$*
    fi
}

compdef '_files -W ~/dotfiles -/' dotf

# }}}
# Aliases {{{
#---------------------------------------------------------------------------------

alias cilkc='cilkc -D__CILK'

# rails
alias r='rails'

# file navigation
alias l='ls -alGh --color'
alias lsd='ls -ldG *(-/DN)' #list directories
alias ..='cd ..'
alias ...='cd ../..'
alias t='touch'
alias mv='nocorrect mv -i'
alias mkdir='nocorrect mkdir'
alias timeout='gtimeout'

# misc
alias duh='du -csh'
# alias top='top -o cpu'
alias df='df -h'
alias jobs='jobs -p'
alias cpu="ps ux | awk 'NR > 1 {res += \$3} END { print \"Total %CPU:\",res }'"
alias grep='grep --colour'
alias egrep='egrep --colour'
alias calc='noglob calc'
alias ctags="`brew --prefix`/bin/ctags"

# fucking vim
alias h="man"
alias vi="vim"
alias so="source ~/.zshrc"
alias :q="toilet -f bigmono12 -F gay FACEPALM"
# }}}

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
PATH=/usr/local/scala/bin:$PATH
PATH=/opt/apache-maven-3.5.0/bin:$PATH
# added by Miniconda3 installer
export PATH="$HOME/.npm-packages/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
# export PATH="/usr/local/opt/openssl/bin:$PATH"
export PATH="/usr/local/bin/cvs:$PATH"
export PATH=$PATH:~/.local/bin
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
export CVSROOT=:pserver:s1690572@www.inf.ed.ac.uk:/cvsroot
stty -ixon

BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"
alias vlc='/Applications/VLC.app/Contents/MacOS/VLC -I rc'

export PATH=$PATH:/opt/local/bin                                      iren
export MANPATH=$MANPATH:/opt/local/share/man
export INFOPATH=$INFOPATH:/opt/local/share/info
export PATH="/usr/local/opt/icu4c/bin:$PATH"
export PATH="/usr/local/opt/ruby/bin:$PATH"
export LEAN_PATH="$HOME/.elan/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/iren/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/iren/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/iren/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/iren/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="/usr/local/opt/llvm/bin:$PATH"
export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
