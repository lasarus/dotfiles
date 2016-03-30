name=$1
home="/home/$1"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# install x configuration files
ln -nfs "$DIR/xinitrc" "$home/.xinitrc"
ln -nfs "$DIR/Xdefaults" "$home/.Xdefaults"

# install xmonad
mkdir -p "$home/.xmonad"
ln -nfs "$DIR/xmonad.hs" "$home/.xmonad/xmonad.hs"

# install emacs
ln -nfs "$DIR/.emacs.d" "$home/.emacs.d"
