# ~/.Profile

#if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# MacPorts (on Mac)
if [ -f /opt/local/bin/port ]; then
    export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi

#Fink (on Mac)
if [ -f /sw/bin/fink ]; then
    export PATH="/sw/bin:/sw/sbin:$PATH"
fi

export PROXY_HTTP=192.168.1.5:3128
export PROXY_HTTPS=192.168.1.5:3128
export PROXY_FTP=192.168.1.5:3128
export HTTP_PROXY=192.168.1.5:3128

#UserScript Folder on main machine to $PATH
if [ -d $HOME/UserScripts ]; then 
    export PATH=$PATH:$HOME/UserScripts
fi

#Aliases for convenvience and keeping me from accidentially deleting stuff.
alias cls=clear
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias ln='ln -i'
alias ls='ls -G'
alias grep='grep --color=auto'

if [ -f /opt/local/etc/profile.d/bash_completion.sh ]; then
          . /opt/local/etc/profile.d/bash_completion.sh
fi

if [ -f /Applications/Xpra.app/Contents/MacOS/Xpra ]; then
    alias xpra=/Applications/Xpra.app/Contents/MacOS/Xpra
fi

#export LSCOLORS=cxfxcDdCBxegedabagacad
#export CLICOLOR=1
#PS1='$(tput setab 39; tput setaf 231)\W$(tput setab 250)\$$(tput sgr0) '
[[ -z $CURSHELL ]] &&  PS1="[$(tput setaf 28)bash$(tput sgr0)]"$PS1
