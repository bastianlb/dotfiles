# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

# NVM directory (must be set before oh-my-zsh loads the nvm plugin)
if [[ "$OSTYPE" == "darwin"* ]]; then
    export NVM_DIR="/opt/homebrew/opt/nvm"
else
    export NVM_DIR="$HOME/.nvm"
fi

# Lazy-load nvm for faster startup
zstyle ':omz:plugins:nvm' lazy yes

plugins=(
	git
	zsh-syntax-highlighting
	zsh-autosuggestions
	fzf-zsh-plugin
  vi-mode
  nvm
)

function zshaddhistory() {
	echo "${1%%$'\n'}⋮${PWD}   " >> ~/.zsh_history_ext
}

source $ZSH/oh-my-zsh.sh
source ~/.zprofile

# macOS-specific
if [[ "$OSTYPE" == "darwin"* ]]; then
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    alias slurm='ssh slurm -t "zsh --login"'
fi

# PATH
# NVM node bin (eager) — lazy nvm plugin defers PATH, but claude CLI needs it immediately
for d in "$NVM_DIR"/versions/node/*/bin(NOn[1]); do export PATH="$d:$PATH"; break; done
[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.dot/bin:$PATH"
export PATH="$HOME/.local/bin/zotero/:$PATH"
export PATH="/usr/local/cuda/bin/:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/lib64/:$LD_LIBRARY_PATH"

# Editors
export EDITOR=vim
export VISUAL=vim

# Aliases
alias vi=nvim
alias ls="eza --icons"
alias alf="ls -alFh"

# alacritty settings mess with gtk
unset GDK_PIXBUF_MODULEDIR
unset GDK_PIXBUF_MODULE_FILE

# Environment
export MCMLSCRATCH=/dss/mcmlscratch/09/ga74bej3
export PYTORCH_CUDA_ALLOC_CONF=expandable_segments:True
export KEOPS_CACHE_FOLDER=$MCMLSCRATCH/cache/pykeops

FZF_BASE="$HOME/.fzf"

# enable vim mode
bindkey -v

# Source fzf keybindings AFTER vi-mode is set up (otherwise vi-mode overrides them)
[[ -f ~/.fzf/shell/key-bindings.zsh ]] && source ~/.fzf/shell/key-bindings.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# conda
if [[ "$OSTYPE" == "darwin"* ]]; then
    source ~/.dot/conda_init_osx
else
    [[ -f ~/.conda_init ]] && source ~/.conda_init
fi

if [ -f ~/.secrets ]; then
    source ~/.secrets
fi

[[ -f ~/.local_profile ]] && source ~/.local_profile
