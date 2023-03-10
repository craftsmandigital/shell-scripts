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






# Debuging when value is other than 0
DEBUG=0

function actionList ()
{

  local actionFunction="$(grep -oE '^\s*function\s+\w*__\w*' $2 | grep -oE '__\w+' | fzf)"
  $actionFunction "$1"
}



function __openFile() {
if [[ $(file -bi "$1") == 'text/'* ]]; then
  debugText "The file $1 is a plain text file."
  lvim $1
else
  debugText "The file $1 is not a plain text file."
  wslview "$1" 
fi
}


function __cd() {
  local dir

  if [ -d "$1" ]; then
    dir="$1"
  else
    dir="$(dirname "$1")"
  fi
  pushd "$dir"
}



# https://github.com/phiresky/ripgrep-all#integration-with-fzf
function __ripgrep() {
   __cd "$1"
	RG_PREFIX="rga --files-with-matches"
	local file
	file="$(
		FZF_DEFAULT_COMMAND="$RG_PREFIX ''" \
			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
				--phony -q "" \
				--bind "change:reload:$RG_PREFIX {q}" \
				--preview-window="70%:wrap"
	)" &&
	echo "opening $file" &&
  __openFile "$file"
}


# # https://github.com/phiresky/ripgrep-all#integration-with-fzf
# rga-fzf() {
# 	RG_PREFIX="rga --files-with-matches"
# 	local file
# 	file="$(
# 		FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
# 			fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
# 				--phony -q "$1" \
# 				--bind "change:reload:$RG_PREFIX {q}" \
# 				--preview-window="70%:wrap"
# 	)" &&
# 	echo "opening $file" &&
# 	xdg-open "$file"
# }


debugText()
{
 if [[ "$DEBUG" -eq 1 ]]; then
 echo "debug: $1" 
 fi 
}


function checkPipedInput () {
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


function getDefaultList () {
  zoxide query --list
}


 # The dept of folders the list chould view.
FOLDERDEPTH=99
# grep -E '^[[:space:]]*function' $0 | awk '{print $2}'
DIRLIST=$(checkPipedInput)
if [[ "$DIRLIST" == "0" ]]; then
  debugText "Script is not receiving input from a pipe."
FOLDERDEPTH=2
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
  DIRLIST=$(echo "$DIRLIST" | fzf ) # count lines using wc 
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
   echo "Current older is not a directory: $DIRLIST"
   return 2
fi


# list only files in 2 directory depth. ignore git and node module files
# FILE=$(fd -H -t f -d $FOLDERDEPTH --exclude node_modules --exclude .git | fzf --header "|| $DIRLIST ||" --exit-0)
FILE=$(fd -H -d $FOLDERDEPTH --exclude node_modules --exclude .git | fzf --header "|| $DIRLIST ||" --exit-0)
if ! [[ $? -eq 0 ]]; then
  # echo "No file selected"
  return
else
  # actionList "$DIRLIST/$FILE" "$0" 
  actionList "./$FILE" "$0" 
fi


# rga --pretty --context 5


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

