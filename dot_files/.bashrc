export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# set vi mode

set -o vi

# get git status function
prompt_git() {
	local s='';
	local branchName='';

	# Check if the current directory is in a Git repository.
	git rev-parse --is-inside-work-tree &>/dev/null || return;

	# Check for what branch we’re on.
	# Get the short symbolic ref. If HEAD isn’t a symbolic ref, get a
	# tracking remote branch or tag. Otherwise, get the
	# short SHA for the latest commit, or give up.
	branchName="$(git symbolic-ref --quiet --short HEAD 2> /dev/null || \
		git describe --all --exact-match HEAD 2> /dev/null || \
		git rev-parse --short HEAD 2> /dev/null || \
		echo '(unknown)')";

	# Early exit for Chromium & Blink repo, as the dirty check takes too long.
	# Thanks, @paulirish!
	# https://github.com/paulirish/dotfiles/blob/dd33151f/.bash_prompt#L110-L123
	repoUrl="$(git config --get remote.origin.url)";
	if grep -q 'chromium/src.git' <<< "${repoUrl}"; then
		s+='*';
	else
		# Check for uncommitted changes in the index.
		if ! $(git diff --quiet --ignore-submodules --cached); then
			s+='+';
		fi;
		# Check for unstaged changes.
		if ! $(git diff-files --quiet --ignore-submodules --); then
			s+='!';
		fi;
		# Check for untracked files.
		if [ -n "$(git ls-files --others --exclude-standard)" ]; then
			s+='?';
		fi;
		# Check for stashed files.
		if $(git rev-parse --verify refs/stash &>/dev/null); then
			s+='$';
		fi;
	fi;

	[ -n "${s}" ] && s=" [${s}]";

	echo -e "${1}${branchName}${2}${s}";
}


# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Allow chnage directory without cd
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

# Highlight the hostname when connected via SSH.
if [[ "${SSH_TTY}" ]]; then
	hostStyle="${bold}${red}";
else
	hostStyle="${orange}";
fi;


if [ "$color_prompt" = yes ]; then

    bold=$(tput bold);
    red=$(tput setaf 160);
    blue=$(tput setaf 27);
    green=$(tput setaf 155);
    orange=$(tput setaf 202);
    yellow=$(tput setaf 226);
    white=$(tput setaf 231);
    reset=$(tput sgr0);
 
    # Highlight the user name when logged in as root.
    if [[ "${USER}" == "root" ]]; then
	    userStyle="${red}";
    else 
	    userStyle="${orange}";
    fi;

    # Highlight the hostname when connected via SSH.
    if [[ "${SSH_TTY}" ]]; then
	    hostStyle="${bold}${red}";
    else 
	    hostStyle="${orange}";
    fi;


    PS1='${debian_chroot:+($debian_chroot)}';
    PS1+='\[${bold}\] \[${white}\]';
    PS1+="\[\033]0;\w\007\]";
    PS1+='\n\t - \[${userStyle}\]\u';
    PS1+='\[${white}\] at \[${green}\]\h\[${white}\] in ';
    PS1+='\[${blue}\]\w ';
    PS1+="\$(prompt_git \"\[${white}\]on \[${yellow}\]\" \"\[${blue}\]\")";
    PS1+="\[${reset}\]\n: " ;    

else
    PS1='${debian_chroot:+($debian_chroot)}\u\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# auto activate virtualenv
# Modified solution based on https://stackoverflow.com/questions/45216663/how-to-automatically-activate-virtualenvs-when-cding-into-a-directory/56309561#56309561
function cd() {
  builtin cd "$@"

  ## Default path to virtualenv in your projects
  DEFAULT_ENV_PATH="./venv"

  ## If env folder is found then activate the vitualenv
  function activate_venv() {
    if [[ -f "${DEFAULT_ENV_PATH}/bin/activate" ]] ; then 
      source "${DEFAULT_ENV_PATH}/bin/activate"
      echo "Activating ${VIRTUAL_ENV}"
    fi
  }

  if [[ -z "$VIRTUAL_ENV" ]] ; then
    activate_venv
  else
    ## check the current folder belong to earlier VIRTUAL_ENV folder
    # if yes then do nothing
    # else deactivate then run a new env folder check
      parentdir="$(dirname ${VIRTUAL_ENV})"
      if [[ "$PWD"/ != "$parentdir"/* ]] ; then
        echo "Deactivating ${VIRTUAL_ENV}"
        deactivate
        activate_venv
      fi
  fi
}

# tmux

if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
    tmux attach -t default || tmux new -s default
fi
