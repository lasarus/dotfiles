name=$1
home="/home/$1"

# install x configuration files
ln -s xinitrc "$home/.xinitrc"
ln -s Xdefaults "$home/.Xdefaults"

# install xmonad
mkdir -p "$home/.xmonad"
ln -s xmonad.hs "$home/.xmonad/xmonad.hs"

# install emacs
ln -s .emacs.d "$home/.emacs.d"
