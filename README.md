# How to install dotfiles:

```
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git clone --bare git@github.com:eckelon/dotfiles.git $HOME/.dotfiles
dotfiles config --local status.showUntrackedFiles no
dotfiles checkout

dotfiles pull --recurse-submodules

# dotfiles submodule update --remote # update all submodules
# dotfiles submodule update --init --recursive
```
