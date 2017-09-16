#!/bin/bash
# Usage: rtd_oca_pull_repos.sh base_dir or rtd_oca_pull_repos.sh
# Just clone or pull the list of repo from the file
# the script is launched from relative directory
# doc and source directory must exist
# Param: if no parameter works from current directory
# $1 contains the base dir to receive the source document

log_src='['${0##*/}']'

echo $log_src[`date +%F.%H:%M:%S`]' Updating content'
# if no argument passed, the current directory is the base directory
# Otherwise this is the directory passed as argument.
base_dir="."
if [ "$1" != "" ]; then
  base_dir=$1
fi

doc_dir=$base_dir/source
repo_file=maintainer-tools/tools/repos_with_ids.txt
name='maintainer-tools'

cd $doc_dir

echo $log_src[`date +%F.%H:%M:%S`]' Cloning maintainer repo in order to fetch list of all repos'
[ -d $name ] && cd $name && git pull && cd ..
[ ! -d $name ] &&  git clone https://github.com/OCA/maintainers-tools.git $name

OLDIFS=$IFS
IFS='|'
[ ! -f $repo_file ] && { echo "$host_file file not found"; exit 99; }
while read -r id repo
do
  echo $log_src[`date +%F.%H:%M:%S`]' Cloning repo '$repo
  name=$(sed "s/github.com\/OCA\///g" <<< $repo)
  echo $id $repo $name
  [ -d $name ] && cd $name && git pull && cd ..
  [ ! -d $name ] &&  git clone https://$repo.git $name

done < $repo_file

IFS=$OLDIFS

echo $log_src[`date +%F.%H:%M:%S`]' Ended Read repos'
exit 
