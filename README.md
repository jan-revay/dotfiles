# My personal dotfiles


Dotfiles are managed via a bare git repository. This repo is meant to be used together with the [iniPC repo](https://github.com/jan-revay/initPC), read the initPC repo README.md and [install_dotfiles.sh](https://github.com/jan-revay/initPC/blob/devel/CommonInitScripts/install_dotfiles.sh) for more info.

This directory also contains scripts, but only such that do not need to be executed as a part of the [initPC script](https://github.com/jan-revay/initPC) during init of a new machine.

"Dotfiles" is just a fancy name for UNIX config files <https://wiki.archlinux.org/title/Dotfiles>

## Runners & test proposals

- aliases should only be allowed to be merged to testing once they have been synchronized between all shells (PowerShell, zsh, fish, bash...)

## TODO Neovim

- change cursor color based on mode: <https://www.reddit.com/r/neovim/comments/105lqyc/how_do_i_change_the_cursor_colour_depending_on/>
- clangd
- bash LSP server
- Pyton LSP server
- file navigation
- copy pasting config
- clang-format
- clang-tidy
