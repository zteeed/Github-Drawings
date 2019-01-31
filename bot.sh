#!/bin/bash

function random_commit() {
  content=$(cat /dev/urandom | tr -dc A-Z-a-z-0-9 | head -c200)
  echo $content > content.txt
  git add content.txt
  git commit -m "Update content.txt with $content value at $1"
  git commit --amend --no-edit --date "$1"
}

function bot_start() {
  python3 ImageToData.py
  git config credential.helper store
  n=$(git rev-list --parents HEAD | wc -l); n=$((n-6))
  eval "git reset HEAD~$n"
  git commit -c ORIG_HEAD
  git push --force origin master
}

function bot_launch() {
  day=$(date +%u); n=$((52*7+day)); data=$(cat ./tmp.txt)
  date=$(LC_ALL=en_EN.utf8 date -d "-$n days")
  for char in $data; do 
    if [ $n -gt 0 ]; then
      if [ $char -eq 0 ]; then random_commit "$date"; fi
      if [ $char -eq 1 ]; then
        for i in `seq 1 200`; do random_commit "$date"; done
      fi
      n=$((n-1)); date=$(LC_ALL=en_EN.utf8 date -d "-$n days")
      git push --force origin master
    fi
  done
  rm content.txt; rm tmp.txt; git rm content.txt
  git commit -m "Remove content.txt"
  git push --force origin master
}

bot_start
bot_launch
