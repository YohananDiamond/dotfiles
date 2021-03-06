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

export TERMUX_SHELL=zsh

# XDG dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DOWNLOAD_DIR="$HOME/inbox"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_DIR="$HOME/.local/share"
export XDG_DATA_HOME="$XDG_DATA_DIR"
export XDG_CURRENT_DESKTOP="none"

# personal dirs
export WIKI=~/wiki

# global options
[ -z "$DISPLAY" ] && export WM=awesome # only export if it hasn't been set before
export TERM=xterm-256color
export EDITOR=nvim
# _isAndroid && export EDITOR=nvim || export EDITOR=start-emacs
export MAYBE_GRAPHICAL_EDITOR=maybe-graphedit
export TERMINAL=st
export BROWSER=brave-async
export TERMBROWSER=w3m
export PAGER=less
export OPENER=openfork
export READER=zathura
export FILEMAN=lf

# configuration files/folders
export _ZL_DATA="$XDG_DATA_DIR/zlua"
export _ZL_FZF_HEIGHT="" # no height limit!
export WINEPREFIX="$XDG_DATA_DIR/wine32"
export WINEW_32_PREFIX="$XDG_DATA_DIR/wine32"
export WINEW_64_PREFIX="$XDG_DATA_DIR/wine64"
export GOPATH="$XDG_CACHE_HOME/go"
export CARGO_HOME="$XDG_CACHE_HOME/cargo"
export RUSTUP_HOME="$XDG_CACHE_HOME/rustup"
export GEM_HOME="$XDG_DATA_DIR/gem"
export GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem"
export GRADLE_USER_HOME="$XDG_DATA_HOME/gradle"
export _JAVA_OPTIONS="-Djava.util.prefs.userRoot='$XDG_CONFIG_HOME/java'"
export JAVA_FONTS="/usr/share/fonts/TTF"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export TASKRC="$XDG_CONFIG_HOME/taskwarrior/taskrc"
export INPUTRC="$XDG_CONFIG_HOME/inputrc"
export XAUTHORITY="$XDG_DATA_DIR/Xauthority" # might break some display managers, but I don't use them.
export LESSKEY="$XDG_CONFIG_HOME/less/lesskey"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export IRBRC="$XDG_CONFIG_HOME/irb/irbrc"
export FZRUN_GAMES_FOLDER="$HOME/storage/software/bin-windows"
export LUAROCKS_HOME="$HOME/.luarocks"

# program options
export XORG_KBRATE_DELAY="300"
export XORG_KBRATE_INTERVAL="30"
export GIT_EDITOR="$EDITOR"
export LESS="-RC"
export KEYTIMEOUT=1
export NNN_OPENER="$OPENER"
export NNN_TRASH=1
export FZF_DEFAULT_OPTS='--layout=reverse --border
                         --color fg:5,fg+:2
                         --color hl:6,hl+:4
                         --color prompt:8,marker:5,pointer:8
                         --color spinner:3,gutter:1,info:3'
export GREP_COLORS='ms=01;34:mc=01;34:sl=:cx=:fn=35:ln=32:bn=32:se=36'

if [ "$DISPLAY" ]; then
  export PINENTRY_USER_DATA="DISPLAY=1"
else
  export PINENTRY_USER_DATA="DISPLAY=0"
fi

export GPG_TTY=$(tty)

_gcc_colors='error    = 01;38;5;8
             :warning = 01;38;5;9
             :note    = 01;38;5;12
             :caret   = 01;32
             :locus   = 01;38;5;4
             :quote   = 03'
export GCC_COLORS=$(printf "%s" "$_gcc_colors" | tr -d ' ' | tr -d '\n')

_exists sccache && export RUSTC_WRAPPER=sccache

# dotfiles program options
export DIR_BOOKMARKS=~/storage/share/bookmarks.sh
export FLAMEW_SCR_FOLDER=~/storage/pictures/screenshots
export SETBG_WALLPAPER_TYPE="image"
export BKMK_FILE="$WIKI/data/bookmarks.json"
export ITMN_FILE="$WIKI/data/itmn.json"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgreprc"
export GUILE_LOAD_PATH="$DOTFILES/lib/guile"
export CLANG_FORMAT_C_CONFIG="$DOTFILES/config/clang-format-c.yaml"
export CLANG_FORMAT_CPP_CONFIG="$DOTFILES/config/clang-format-cpp.yaml"
export X_COMPOSITOR="picom"

export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export SDL_IM_MODULE=fcitx
export XMODIFIERS='@im=fcitx'

# dircolors
if [ -r ~/.config/dircolors ]; then
  eval "$(dircolors -b ~/.config/dircolors)"
fi
