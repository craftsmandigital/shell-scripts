#!/bin/bash
#
# Script could be called like this two methods.
# Directory change wil not take effect in a subshell
#  $ . ./supercd.bash
#  $ source ./supercd.bash
#
#
#
#
# source ~/.zshrc    # or source ~/.zshrc if you're using zsh
# Get the list of directories from zoxide and pass it to fzf.
# Reverse list, since the lowest score is at the begining.
DIR=$(zoxide query --list | fzf)
if ! [[ $? -eq 0 ]]; then
  echo "No file selected 1"
  return
fi
#echo $PATH | sed 's/:/\n:/g' 
# Cutt ranging score in the start of the line. A clean path is the output
# DIRPATH=$(echo $DIR | sed 's/^[[:digit:][:space:]]*//')
DIRPATH=$DIR
# If a directory was selected, cd to it
if [ -d "$DIRPATH" ]; then
    cd "$DIRPATH"
    echo "Current Folder is: $DIRPATH"
  else
    return
fi
# list only files in 2 directory depth. ignore git and node module files
FILE=$(fd -H -t f -d 2 --exclude node_modules --exclude .gitignore --exclude .git | fzf --exit-0)
if ! [[ $? -eq 0 ]]; then
  echo "No file selected"
  return
fi
lvim $FILE






# #!/bin/bash

# # Define the first function that takes two arguments
# function function1 {
#   echo "This is function 1 with argument 1: $1 and argument 2: $2"
# }

# # Define the second function
# function function2 {
#   echo "This is function 2"
# }

# # Call the specified function and pass any additional arguments
# "$1" "${@:2}"


# To execute the script with the function1 function and pass two arguments to it, you would run the script as follows:
# $ ./script.sh function1 argument1 argument2
#
#
#
#
#
#
#
#
#
#
#
#
# #!/bin/bash

# # Define the first function
# function function1 {
#   echo "This is function 1"
# }

# # Define the second function that takes two arguments
# function function2 {
#   echo "This is function 2 with argument 1: $1 and argument 2: $2"
# }

# # Define the third function that takes one argument
# function function3 {
#   echo "This is function 3 with argument: $1"

# }


# # Call each specified function
# for func in "$@"
# do
#   args=("${@:2}") # get all arguments except the first one (function name)
#   $func "${args[@]}"
# done

