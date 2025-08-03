# NVIM cheetsheet

## Tabs and multiple files

### Open a file in a new tab

- `:tabe <filename>`

### Navigation

- `gt` - next tab
- `gT` - previous tab
- <leader> bd - close tab
- <leader> ff - open telescope
- `:tabo` - close all other tabs

## Text replace

- :%s/old/new/g
- :startline,endline s/pattern/replacement/g
- :%s/foo/bar/gi (case insensitive)
- :%s/pattern/replacement/gc (with confirmation)
- :%s/Vim/ (delete all occurrences of a word)


## Other cheetsheets

- <https://phoenixnap.com/kb/vim-commands-cheat-sheet>
