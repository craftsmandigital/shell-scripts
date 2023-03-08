# shell-scripts
Shell scripts for use to get my everyday more automated

The basic of this script is to use [FZF](https://github.com/junegunn/fzf) to:
- CD into a directory from a FZF list. Basicaly list from [ZOXIDE](https://github.com/ajeetdsouza/zoxide)
- from the output of the folder change, a new FZF list of files in 2 directorys depth is outputed in a list. When user hit enter on a file, then the file is opened in [nvim](https://neovim.io/)


## Further tougth of this script
- Could be flexible in Directorylist for startingpoint
  - To acive this, the best solusion could be a self made list piped into the schript ex: `ls | script.bash`
  - There could be a varity of file pickers to use. Pickers could be aranged in funcions. User could choose functions to use with comandline parameters. To implement this, tehe script could use the [`getopts`](https://stackoverflow.com/questions/16483119/an-example-of-how-to-use-getopts-in-bash) function
