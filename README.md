### Set-up VIM

1. Clone under your home directory:

        $ git clone https://github.com/irenevp/dotfiles  ~/dotfiles

2. Set-up the symbolic links:

        $ ln -s ~/dotfiles/.vimrc ~
        $ ln -s ~/dotfiles/.vim ~

3. Download the VIM plugin manager (Vundle):

        $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

4. Bring up `vim` and run `:PluginInstall`. Restart vim to load the new plugins. Don't forget to run `:PluginUpdate` every now and then to update your plugins to the latest version.


### Troubleshooting

If the colors look strange (e.g. too blue), see:

* https://github.com/chriskempson/base16-vim#troubleshooting
* https://github.com/chriskempson/base16-shell
