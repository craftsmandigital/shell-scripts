#!/bin/bash
# fd -apHt d -d 1 .tmux   
# Script could be called like this two methods.
# Directory change wil not take effect in a subshell
#  $ . ./supercd.bash
#  $ source ./supercd.bash


# set -x

#echo $PATH | sed 's/:/\n:/g' 
# Cutt ranging score in the start of the line. A clean path is the output
# DIRPATH=$(echo $DIR | sed 's/^[[:digit:][:space:]]*//')






DEBUG=1

debugText()
{
 if [[ "$DEBUG" -eq 1 ]]; then
 echo "debug: $1" 
 fi 
}


function checkPipedInput() {
# return values
# - List of values (string separated by newlines)
# - one value (string)
# - 0 means there is no piped inputt
# - 1 means there is no result for the piped inputt
  # debugText "this is the start"


if [[ -p /dev/stdin ]]; then
   
  # debugText "Script is receiving input from a pipe."
  local LIST="$(cat)"
  local STDINCOUNT=$(echo "$LIST" | wc -l) # count lines using wc 


  if [[ "$STDINCOUNT" -gt 1 ]]; then
    # debugText "The value of DIR is greater than 1. Its perfect"
      # Do something
      echo "$LIST"
  elif [[ "$STDINCOUNT" -eq 1 ]]; then
    if [ -z "$LIST" ]; then # Empty string the piped input has no value(empty string)
      # debugText "The piped input has no value, empty string"
      echo 1
    else
      # debugText "The value of DIR is equal to 1. ($LIST)() No ned to use dir list"
      echo "$LIST"
    fi
  else
    # debugText "No inputt to file list"
      # Do something different
      echo 1
  fi

else    #
  # debugText "Script is not receiving input from a pipe."
  echo 0
fi
}


function getDefaultList() {
  zoxide query --list
}




DIRLIST=$(checkPipedInput)
if [[ "$DIRLIST" == "0" ]]; then
  debugText "Script is not receiving input from a pipe."
  DIRLIST=$(getDefaultList)
elif [[ "$DIRLIST" == "1" ]]; then
  echo "The value of the piped input is empty. No data to work on"
  return 2
fi


debugText "Before the first picker:\n$DIRLIST"

LISTCOUNT=$(echo "$DIRLIST" | wc -l) # count lines using wc 

  # source ~/.zshrc    # or source ~/.zshrc if you're using zsh
  # Get the list of directories from zoxide and pass it to fzf.
  # Reverse list, since the lowest score is at the begining.
  #
if [[ "$LISTCOUNT" -gt 1 ]]; then
  DIRLIST=$(echo "$DIRLIST" | fzf) # count lines using wc 
  if ! [[ $? -eq 0 ]]; then
    # echo "No file selected 1"
    return
  fi
fi

debugText "after the first picker:\n$DIRLIST"



if [ -d "$DIRLIST" ]; then
   debugText "Changing Folder to:$DIRLIST:"
   pushd "$DIRLIST" # get errormessage when using cd
else
   echo "Current Folder is not a directory: $DIRLIST"
   return 2
fi


# list only files in 2 directory depth. ignore git and node module files
FILE=$(fd -H -t f -d 2 --exclude node_modules --exclude .git | fzf --header "|| $DIRLIST ||" --exit-0)
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

