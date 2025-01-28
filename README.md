# My personal Linux dotfiles


Linux dotfiles managed via a bare git repository. This repo is meant to be used together with the iniPC script here: <https://github.com/jan-revay/initPC>, read the initPC repo README.md and [install_dotfiles.sh](https://github.com/jan-revay/initPC/blob/devel/CommonInitScripts/install_dotfiles.sh) for more info.

This directory also contains scripts, but only such that are not executed as a part of the [initPC script](https://github.com/jan-revay/initPC) during the init of a new machine (e.g. scripts that are executed on startup of the machine or backup scripts).

"Dotfiles" is just a fancy name for personal config files <https://wiki.archlinux.org/title/Dotfiles>

## Test proposals

- aliases should only be allowed to be merged to testing once they have been synchronized between all shells (PowerShell, zsh, fish, bash...)
- aliases should not fire `command unknown` error
- TODO - consider using this repo from the root directory instead of just home resp. review my current solution (stow for root, git bare for local home)

## TODO P1

- add VSC config & vsc extension list here (and also search the settings history to add more - Strl+shift+p -> Settings sync - show synced data)
- have all VSC config synced via git dotfiles don't use the MS sync much (only as an additional method for temporary changes)
```
{
    "recommendations": [
        // Code formatting tools
        "stkb.rewrap",
        "foxundermoon.shell-format",
        "editorconfig.editorconfig",

        // Linters
        "streetsidesoftware.code-spell-checker",
        "nhoizey.gremlins",
        "timonwong.shellcheck",
        "davidanson.vscode-markdownlint",

        // C++ tools
        "ms-vscode.cpptools",
        "ajshort.include-autocomplete",
        "ms-vscode.cpptools-extension-pack",
        "cschlosser.doxdocgen",
        "llvm-vs-code-extensions.vscode-clangd",
        "twxs.cmake",

        // Powershell LSP

        // Git and GitHub support
        "eamodio.gitlens",
        "github.vscode-github-actions",

        // Markdown tools
        "yzhang.markdown-all-in-one",

        // bash LSP
        "mads-hartmann.bash-ide-vscode",

        // Python tools
        "ms-python.python",
        "ms-python.vscode-pylance",

        // Ignore files syntax highlighting
        "ldez.ignore-files",

        // Other
        "ionutvmi.path-autocomplete",
        "tetradresearch.vscode-h2o",
        "ms-vscode.powershell"
    ]
}

```

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
