#!/bin/bash
log_src='['${0##*/}']'
echo $log_src[`date +%F.%H:%M:%S`]' Updating content'
base_dir=/mnt/readthedoc
repo_file=$base_dir/source/maintainer-tools/tools/repos_with_ids.txt
> index.tmp

cd $base_dir

OLDIFS=$IFS
IFS='|'
[ ! -f $repo_file ] && { echo $repo_file": file not found"; exit 99; }
while read -r id repo
do
  name=$(sed "s/github.com\/OCA\///g" <<< $repo)

  echo $log_src[`date +%F.%H:%M:%S`]' Building repo Index for '$repo $name
  echo "###########################################################">./$name.rst
  echo "Repos: "$name>>./$name.rst
  echo "###########################################################">>./$name.rst
  echo ".. toctree::">>./$name.rst
  echo "   :maxdepth: 1" >>./$name.rst
  echo "">>./$name.rst
  find source/$name/ -name README.rst -type f|sort|sed "s/source\/"$name"/   source\/"$name"/g" >>./$name.rst

  echo $log_src[`date +%F.%H:%M:%S`]' Updating Master Index adding '$repo
  echo "   "$name".rst" >> $base_dir/index.tmp
done < $repo_file

IFS=$OLDIFS

echo $log_src[`date +%F.%H:%M:%S`]' Generating the html documentation with Sphinx'
cat $base_dir/index.hdr > $base_dir/index.rst
sort $base_dir/index.tmp >> $base_dir/index.rst
cat $base_dir/index.ftr >> $base_dir/index.rst
rm $base_dir/index.tmp
make html

echo $log_src[`date +%F.%H:%M:%S`]' Ended Read repos'
exit

