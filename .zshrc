# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# Alias User configuration
# For a full list of active aliases, run `alias`.

# Access aliases config faster
alias ez="code ~/.zshrc"
alias sz="source ~/.zshrc"

# Git add, commit, and push at once
# Usage: pu "Commit message"
function pu()
{
	git add .
	if [ -z "$1" ]; then
		git commit -a -m "Squid Update 🦑"
	else
		git commit -m "$1"
	fi
	git push
}

# Valgrind with vscode fds tracking support (you can also use it with more valgrind options)
# Usage:
# val ./your_program
# val --track-origins=yes --tool=helgrind ./your_program
# val --track-origins=yes ./your_program arg1 arg2 argN
function val()
{
    valgrind --track-fds=yes --leak-check=full --trace-children=yes "$@" 2>&1 | awk '
    BEGIN { c=0; skip=0; n=0 }
    /^==[0-9]+==/ && !pid { match($0, /^==([0-9]+)==/, m); if (m[1]) pid=m[1] }
    skip { skip--; next }
    /\/home\/cez\/.vscode-server|\/dev\/ptmx/ { c++; skip=2; next }
    { lines[n++] = $0 }
    END {
      for (i=0; i<n; i++) {
        print lines[i]
        if (lines[i] ~ /FILE DESCRIPTORS:/)
          printf("==%s==                          (%d vscode)\n", pid, c)
      }
    }
    '
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
