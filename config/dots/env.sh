_exists() { command -v "$1" >/dev/null 2>/dev/null; }
_isAndroid() { [ -d ~/.termux ]; } # bad way of detecting lol

# dotfiles dir
_dotpath=~/.local/share/dots/dotpath
_fallback_dotpath=~/.dotfiles
if [ -f "$_dotpath" ]; then
  export DOTFILES=$(cat "$_dotpath")
else
  printf >&2 "warning: %s doesn't exist - %s will fallback to %s" \
             "$_dotpath" '$DOTFILES' "$_fallback_dotpath"
  export DOTFILES="$_fallback_dotpath"
fi

# XDG dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DOWNLOAD_DIR="$HOME/inbox"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_DIR="$HOME/.local/share"
export XDG_DATA_HOME="$XDG_DATA_DIR"
export XDG_CURRENT_DESKTOP="none"

# personal dirs
export STORAGE=~/storage
export WIKI=~/wiki

# global options
[ -z "$DISPLAY" ] && export WM=dwm # only export if it hasn't been set before
export TERM=xterm-256color
_isAndroid && export EDITOR=nvim || export EDITOR=start-emacs
export TERMINAL=st
export BROWSER=qutebrowser
export TERMBROWSER=w3m
export PAGER=less
export OPENER=openfork
export READER=zathura
export FILEMAN=lf

# configuration files/folders
export _ZL_DATA="$XDG_DATA_DIR/zlua"
export WINEPREFIX="$XDG_DATA_DIR/wine32"
export WINEW_32_PREFIX="$XDG_DATA_DIR/wine32"
export WINEW_64_PREFIX="$XDG_DATA_DIR/wine64"
export GOPATH="$XDG_CACHE_HOME/go"
export CARGO_HOME="$XDG_CACHE_HOME/cargo"
export RUSTUP_HOME="$XDG_CACHE_HOME/rustup"
export GEM_HOME="$XDG_DATA_DIR/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export XAUTHORITY="$XDG_DATA_DIR/Xauthority" # might break some display managers, but I don't use them.
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"

# (maybe unsafe/slow) create files
[ "$WGETRC" ] && printf "hsts-file = %s" "$XDG_CACHE_HOME/wget-hsts" >"$WGETRC"

# program options
export GIT_EDITOR="${EDITOR:-vim}"
export LESS="-RC"
export KEYTIMEOUT=1
export NNN_OPENER="$OPENER"
export NNN_TRASH=1
export RUSTFLAGS='-C link-arg=-fuse-ld=lld'
export FZF_DEFAULT_OPTS='
  --layout=reverse --border
  --color fg:4,fg+:5
  --color hl:3,hl+:10
  --color prompt:8,marker:5,pointer:8
  --color spinner:3,gutter:1,info:3
'
export GCC_COLORS='error=01;38;5;8:warning=01;38;5;9:note=01;38;5;12:caret=01;32:locus=01;38;5;11:quote=03'
export GREP_COLORS='ms=01;34:mc=01;34:sl=:cx=:fn=35:ln=32:bn=32:se=36'
_exists sccache && export RUSTC_WRAPPER=sccache

# dotfiles program options
export DIR_BOOKMARKS="$STORAGE/share/bookmarks.sh"
export FLAMEW_SCR_FOLDER="$STORAGE/pictures/screenshots"
export SETBG_IMG_DIR="$STORAGE/pictures/wallpapers/art"
export SETBG_WALLPAPER_TYPE="color"
export BKMK_FILE="$WIKI/data/bookmarks.json"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export GUILE_LOAD_PATH="$DOTFILES/lib/guile"

# dircolors
if [ -r ~/.config/dircolors ]; then
  eval "$(dircolors -b ~/.config/dircolors)"
fi
