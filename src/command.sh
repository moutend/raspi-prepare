#!/bin/bash

IS_FAILED=0
RPI_USER=pi
BEER="\xF0\x9F\x8D\xBA"

info() {
  echo "\n"$BEER"  "$1
}

run() {
  if [ "$IS_FAILED" -eq 0 ]
  then
    echo "\n"$1
    eval $1
  else
    exit
  fi
}

if [ -z $1 ]
then
  RPI_ADDR=192.168.2.2
else
  RPI_ADDR=$1
fi

echo RPI_ADDR=$RPI_ADDR
echo RPI_USER=$RPI_USER
echo RPI_PASS=raspberry

trap '' EXIT
trap 'IS_FAILED=$((IS_FAILED+1))' INT TERM
