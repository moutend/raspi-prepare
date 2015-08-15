#!/bin/bash

if [ $1 -gt 0 ]
then
  exit
fi

echo "Rebooting Raspberry Pi, please wait 30 seconds."

i=30
while [ $i -gt 0 ]
do
  sleep 1
  echo -n .
  ((i=i-1))
done

echo .
