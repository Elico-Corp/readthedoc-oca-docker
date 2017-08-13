#!/bin/bash
log_src='['${0##*/}']'
echo $log_src[`date +%F.%H:%M:%S`]' Updating content'
base_dir=/mnt/readthedoc
repo_file=$base_dir/maintainer-tools/tools/repos_with_ids.txt

cd $base_dir
git clone https://github.com/OCA/maintainer-tools.git
cat $repo_file

OLDIFS=$IFS
IFS='|'
[ ! -f $repo_file ] && { echo "$host_file file not found"; exit 99; }
while read -r id repo
do
  echo $log_src[`date +%F.%H:%M:%S`]' Cloning repo '$repo
  name=$(sed "s/github.com\/OCA\///g" <<< $repo)
  echo $id $repo $name
  git clone  https://$repo.git $name

  echo $log_src[`date +%F.%H:%M:%S`]' Building Index for '$repo $name $doctype $title
  echo "###########################################################">./$name.rst
  echo $id.$name>>./$name.rst
  echo "###########################################################">>./$name.rst
  echo ".. toctree::">>./$name.rst
  echo "   :maxdepth: 1" >>./$name.rst
  echo "">>./$name.rst
  find $name/ -name README.rst -type f|sort|sed "s/"$name"/   "$name"/g" >>./$name.rst
  echo $log_src[`date +%F.%H:%M:%S`]' Generating Crontab for '$repo
  cat /etc/crontab | { cat; echo "0 * * * * cd /mnt/readthedoc/"$name" && git pull"; } | crontab -
  echo $log_src[`date +%F.%H:%M:%S`]' Updating Master Index adding '$repo
  echo "   "$name".rst" >> $base_dir/index.rst
done < $repo_file

IFS=$OLDIFS

echo $log_src[`date +%F.%H:%M:%S`]' Generating crontab entry'
if [ ! $(grep "/mnt/readthedoc/pull_repos_oca.sh" /etc/cron.d/pull_repo.cron) ]; then
   echo "0 0 * * * /mnt/readthedoc/pull_repos_oca.sh >> /var/log/pull_repos.log 2>&1" > /etc/cron.d/pull_repo.cron
   touch /var/log/pull_repos.log
fi

echo $log_src[`date +%F.%H:%M:%S`]' Generating the html documentation with Sphinx'
cat $base_dir/index.ftr >> $base_dir/index.rst
make html

echo $log_src[`date +%F.%H:%M:%S`]' Ended Read repos'
exit 
