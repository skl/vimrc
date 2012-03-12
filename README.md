Installation
============

    git clone git://github.com/skl/vimrc.git ~/.vim
    cd ~/.vim
    git submodule update --init
    ln -s ~/.vim/vimrc ~/.vimrc

If you see the following error on vim startup:

    Taglist: Exuberant ctags ( http://ctags.sf.net) not found in PATH. Plugin
    is not loaded. )

You need to install exuberant-ctags:

    sudo apt-get install exuberant-ctags
