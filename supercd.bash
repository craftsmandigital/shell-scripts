#!/bin/bash
# fd -apHt d -d 1 .tmux   
# Script could be called like this two methods.
# Directory change wil not take effect in a subshell
#  $ . ./supercd.bash
#  $ source ./supercd.bash

if [[ -p /dev/stdin ]]; then
   
  echo "Script is receiving input from a pipe."
  LIST="$(cat)"
  STDINCOUNT=$(echo "$LIST" | wc -l) # count lines using wc 


  if [[ "$STDINCOUNT" -gt 1 ]]; then
      echo "The value of DIR is greater than 1. Its perfect"
      # Do something
  elif [[ "$STDINCOUNT" -eq 1 ]]; then
      echo "The value of DIR is equal to 1. No ned to use dir list"
      # Do something else
  else
      echo "No inputt to file list"
      # Do something different
      return
  fi

else    #
  echo "Script is not receiving input from a pipe."

  LIST="$(zoxide query --list)"

  echo "$LIST"

fi


  # source ~/.zshrc    # or source ~/.zshrc if you're using zsh
  # Get the list of directories from zoxide and pass it to fzf.
  # Reverse list, since the lowest score is at the begining.
  #
if [[ "$STDINCOUNT" -eq 1 ]]; then
  DIR="$LIST"
  echo "Her er den ene katalogen: $DIR"
else
  DIR=$(echo $LIST | fzf)
  if ! [[ $? -eq 0 ]]; then
    # echo "No file selected 1"
    return
  fi
fi




#echo $PATH | sed 's/:/\n:/g' 
# Cutt ranging score in the start of the line. A clean path is the output
# DIRPATH=$(echo $DIR | sed 's/^[[:digit:][:space:]]*//')
DIRPATH="$DIR"
# If a directory was selected, cd to it
if [ -d "$DIRPATH" ]; then
   echo "Current Folder is:$DIRPATH:"
   pushd "$DIRPATH" # get errormessage when using cd
    
   echo "Current Folder is: $DIRPATH"
  else
   echo "Current Folder is not a directory: $DIRPATH"
    return
fi
# list only files in 2 directory depth. ignore git and node module files
FILE=$(fd -H -t f -d 2 --exclude node_modules --exclude .git | fzf --header "|| $DIRPATH ||" --exit-0)
if ! [[ $? -eq 0 ]]; then
  # echo "No file selected"
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

