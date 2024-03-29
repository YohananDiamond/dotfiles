**Welcome to my dotfiles repo!**

This repository contains most of my config files and scripts (not all,
though).

## Dependencies

- https://github.com/YohananDiamond/dotcfg

## Installation

This repo is very unstable. I really recommend taking a look only at
files that interest you instead of simply copying everything because
not only it is very unsafe due to most scripts here being pretty
buggy, but also because I believe it's better to only add to your
system things that you understand, instead of making it confusing with
the imense amount of bloat that would come with getting all scripts
from here.

But if you want to do it anyway (or if you're me! I also do this, to install the
dotfiles on a new system), you can do:

```bash
curl https://raw.githubusercontent.com/yohanandiamond/dotfiles/master/install > install
chmod +x install
./install https path-to-dotfiles
```

It's still pretty buggy so remember to make your backups before doing
anything, and it's probably a good idea to run this in a VM anyway.

## Folder structure

* `config`: config files, mostly symlinked to `~` and `~/.config`.

* `scripts`: executable files, added to PATH via `env.sh`.

* `lib`: personal libraries for use with some scripting languages.

* `patches`: some patches I usually would like to apply on a system. I
  currently have no way to automate this.

* `.trash`: old files that I don't want to delete right now, but aren't
  being used in the repo. Might be unavailable if empty (due to how
  git works).

## Inspiration / stuff I "stole"

The repos below are the ones I remember ~~stealing code~~ taking
inspiration from to build my dotfiles. There are lots of more places
that inspired me, though - specially from r/unixporn and r/vim - and
even though I can't possibly remember them all, I'd like to thank them.
It has been a pretty cool experience to make, well, pretty much my own
operating system, even though I didn't code the Linux kernel or
something.

* https://github.com/denysdovhan/dotfiles

* https://github.com/LukeSmithxyz/voidrice

* https://github.com/jdhao/nvim-config

* https://gist.github.com/sooop/8dc424e13c6fe2e2a663

  (It's Steve Losh (sjl)'s vimrc. The [original file](https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc) seems to be down.)
