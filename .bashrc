# Standard default prompt
# Prompt color changes if logged on as root
if [[ $EUID > 0 ]]; then
    _COLOR_USER="\033[0;32m"
else
    _COLOR_USER="\033[1;31m"
fi

# Date formats can be found here (man strftime):
# https://manpages.ubuntu.com/manpages/xenial/man3/strftime.3.html
# https://www.cyberciti.biz/faq/linux-unix-formatting-dates-for-display/

# Only if connected SSH, show the host
if [[ -n "$SSH_CLIENT" ]] || [[ -n "$SSH_TTY" ]]; then
    if [[ "$_PROMPT_BUILTIN_FULL_PATH" = false ]]; then
        # Remote SSH with short path (1 line)
        export PS1="\[\033[1;35m\]\u\[\033[0;35m\]@\h \[\033[0;34m\]\D{%b %-d} \[\033[0;36m\]\D{%-H:%M} \[\033[0;33m\]\w\[\033[0;31m\]\`_parse_git_branch\` \[${_COLOR_USER}\]>\[\033[0m\] "
    else
        # Remote SSH with full path (2 lines)
        export PS1="\[\033[1;35m\]\u\[\033[0;35m\]@\h \[\033[0;34m\]\D{%b %-d} \[\033[0;36m\]\D{%-H:%M:%S} \[\033[0;33m\]\$(_pwd)\[\033[0;31m\]\`_parse_git_branch\`\[\033[0m\]\[${_COLOR_USER}\]>\[\033[0m\] "
    fi
else # Otherwise, only show the name
    if [[ "$_PROMPT_BUILTIN_FULL_PATH" = false ]]; then
        # Local with short path (1 line)
        export PS1="\[\033[0;35m\]\u \[\033[0;34m\]\D{%b %-d} \[\033[0;36m\]\D{%-H:%M} \[\033[0;33m\]\w\[\033[0;31m\]\`_parse_git_branch\` \[${_COLOR_USER}\]>\[\033[0m\] "
    else
        # Local with full path (2 lines)
        export PS1="\[\033[0;35m\]\u \[\033[0;34m\]\D{%b %-d} \[\033[0;36m\]\D{%-H:%M:%S} \[\033[0;33m\]\$(_pwd)\[\033[0;31m\]\`_parse_git_branch\`\[\033[0m\]\[${_COLOR_USER}\]>\[\033[0m\] "
    fi
fi

# Get current branch in Git repo
function _parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [[ ! "${BRANCH}" == "" ]]; then
		echo " [${BRANCH}]"
	else
		echo ""
	fi
}

# Return the path for the "full path" multi-line prompt
function _pwd() {
	# Returns the full path but still shows the home directory as ~
	echo $PWD | sed 's@'${HOME}'@@'
}

# Vim Aliases
if [[ -x "$(command -v nvim)" ]]; then
	alias vi='nvim'
	alias vim='nvim'
	alias svi='sudo nvim'
	alias vis='nvim "+set si"'
elif [[ -x "$(command -v vim)" ]]; then
	alias vi='vim'
	alias svi='sudo vim'
	alias vis='vim "+set si"'
fi


# Git Aliases
if [[ -x "$(command -v git)" ]]; then
	alias gs='git status'
	alias gp='git pull'
	alias gf='git fetch'
	alias gm='git merge'
	alias gpu='git push'
	alias gr='git reset'
	alias ga='git add .'
	alias gac='git add --all && git commit -m'
	alias gc='git commit -m'
	alias gl='git log --pretty=format:"%C(yellow)%h\\ %ad%Cred%d\\ %Creset%s%Cblue\\ [%cn]" --decorate --date=short'
	alias gd='git diff'
	alias gds='git diff --stat'
	alias gdc='git diff --cached'
	alias gc='git checkout'
	alias gcb='git checkout -b'
	alias gst='git stash'
	alias gstp='git stash pop'
fi

# Show a list of available aliases and functions
alias a='_listcommands'
function _listcommands() {
	local COLOR="\033[1;31m" # Light Red
	local NOCOLOR="\033[0m"
	echo -e "${COLOR}Aliases:${NOCOLOR}"
	# compgen -A alias
	alias | awk -F'[ =]' '{print "\033[33m"$2"\033[0m\t\033[34m"$0"\033[0m";}'
	echo
	echo -e "${COLOR}Functions:${NOCOLOR}"
	compgen -A function | grep -v '^_.*'
}

# Aliases for systemd
if [[ -x "$(command -v systemctl)" ]]; then
	# Get a list of all services
	alias services='systemctl list-units --type=service --state=running,failed'
	alias servicesall='systemctl list-units --type=service'

	# Find what systemd services have failed
	alias failed='systemctl --failed'

	# Get the status of a services
	alias servicestatus='sudo systemctl status'

	# Start or stop services
	alias servicestop='sudo systemctl stop'
	alias servicestart='sudo systemctl start'
	alias servicerestart='sudo systemctl restart' # Stop and start
	alias servicereload='sudo systemctl reload'   # Reload configuration
fi

# Go back directories dot style
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

# Go back directories dot dot number style
alias ..2='..; ..'
alias ..3='..2; ..'
alias ..4='..3; ..'
alias ..5='..4; ..'

# Depending on the installed package managers, set up some package aliases
if [[ -x "$(command -v yay)" ]]; then
	alias has='yay -Si'
	alias pkgupdateall='yay -Syyu && if type flatpak >/dev/null 2>&1; then sudo flatpak update; fi && if type snap >/dev/null 2>&1; then sudo snap refresh; fi && if type tldr >/dev/null 2>&1; then tldr --update; fi'
	alias pkgupdate='yay -S'
	alias pkginstall='yay -S'
	alias pkgremove='yay -Rsc'
	alias pkgclean='yay -Yc'
	alias pkgsearch='yay'
	alias pkglist='yay -Qe'
	alias pkglistmore='yay -Q' # Also includes dependencies
fi

alias ls='ls -aFh --color=always'     # do add built-in colors to file types
alias ll='ls -Fls'                    # long listing
alias labc='ls -lap'                  # sort alphabetically
alias lx='ll -laXBh'                  # sort by extension
alias lk='ll -laSrh'                  # sort by size
alias lt='ll -latrh'                  # sort by date
alias lc='ll -lacrh'                  # sort by change time
alias lu='ll -laurh'                  # sort by access time
alias new='ls -latr | tail -10 | tac' # list recently created/updated files
alias lw='ls -xAh'                    # wide listing format
alias lm='ll -alh | \less -S'         # pipe through less
alias lr='ls -lRh'                    # recursive ls
alias l.='ll -d .*'                   # show hidden files
alias lf="ls -l | egrep -v '^d'"      # files only
alias ldir="ls -la | egrep '^d'"      # directories only

# Start nvm
source ~/.nvm/nvm.sh
export NODE_OPTIONS=--openssl-legacy-provider
