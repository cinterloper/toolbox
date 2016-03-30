#!/bin/bash
#@args dirToWatch fileNamePattern
#@vars HOOK the callback function to be triggered
if [[ "$HOOK" == "" ]]
then
  HOOK=echo
fi

watch( ) {
  inotifywait -m -e create $1 
}

watch $1 | while read -r event
do
  $HOOK $( echo $event | cut -d ' ' -f 3 | grep $2 )
done 

