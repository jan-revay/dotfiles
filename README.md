# My personal Linux dotfiles


Linux dotfiles managed via a bare git repository. This repo is meant to be used together with the iniPC script here: <https://github.com/jan-revay/initPC>, read the initPC repo README.md and [install_dotfiles.sh](https://github.com/jan-revay/initPC/blob/devel/CommonInitScripts/install_dotfiles.sh) for more info.

This directory also contains scripts, but only such that are not executed as a part of the [initPC script](https://github.com/jan-revay/initPC) during the init of a new machine (e.g. scripts that are executed on startup of the machine or backup scripts).

"Dotfiles" is just a fancy name for personal config files <https://wiki.archlinux.org/title/Dotfiles>

## Test proposals

- aliases should only be allowed to be merged to testing once they have been synchronized between all shells (PowerShell, zsh, fish, bash...)
- aliases should not fire `command unknown` error
- TODO - consider using this repo from the root directory instead of just home resp. review my current solution (stow for root, git bare for local home)

## TODO P1

## TODO P2

## TODO P3

- Rewrite/update/delete .my_scripts
- desktop files (autostart) - read the documentation of X-GNOME attributes & turn off the app is ready notification
- remove Autostart from .my_scripts/

## TOREAD

- https://wiki.archlinux.org/title/GNOME
- https://wiki.archlinux.org/title/GNOME/Tips_and_tricks
- https://wiki.archlinux.org/title/Table_of_contents
- https://wiki.archlinux.org/title/Logitech_MX_Master
- https://wiki.archlinux.org/title/Logitech_Unifying_Receiver
- https://wiki.archlinux.org/title/Dotfiles
