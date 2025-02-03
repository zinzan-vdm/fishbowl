#!/bin/bash

# function share() {
#
# }
#
# function share-create() {
#   local dir=${1}
#
#   if [[ -z "$dir" ]] || [[ "$dir" == '-h' ]] || [[ "$dir" == '--help' ]]; then
#     share-help
#     return 1
#   fi
#
#   if [[ ! -d "$dir" ]]; then
#     echo "Provided directory does not exist. ($dir)"
#     return 1
#   fi
#
#   dir=$(realpath "$dir")
#
#   local conf=$()
#
#   local user=$(share-random 8)
#   local pass=$(share-random 16)
# }
#
# function share-create() {
#
# }
#
# function share-delete() {
#
# }
#
# function share-create-user() {
#
# }
#
# function share-delete-user() {
#
# }
#
# function share-create-jail() {
#
# }
#
# function share-delete-jail() {
#
# }
#
# function share-config-set() {
#
# }
#
# function share-config-get() {
#
# }
#
# function share-config-del() {
#
# }
#
# function share-pathname() {
#   local path=${1}
#
#   local fullpath=$(realpath "$path")
#   local pathname=$(echo "$fullpath" | sed 's/\//___/g')
#
#   echo "$pathname"
# }
#
# function share-pathfull() {
#   local pathname=${1}
#
#   local fullpath=$(echo "$pathname" | sed 's/___/\//g')
#   local path=$(realpath "$fullpath")
#
#   echo "$path"
# }
#
# function share-random() {
#   local len=${1-16}
#
#   local rand=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c "$len")
#
#   echo "$rand"
# }
#
