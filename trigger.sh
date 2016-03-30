#!/bin/bash
PHASE=( SETUP EXEC CALLBACK CLEANUP ERROR )




SETUP ( )
{
  mkdir $LOGPATH 2>/dev/null
}
ERROR ( )
{
     echo 1>&2 '{"error":"internal server error", "comment":"$1"}'
     exit -1
}


HOOKBACK ( )
{
  if [[ "$DEBUG" == "true" ]] || [["$DEBUG" == "1" ]]; then
    echo  curl -XPOST -d$( echo $1 | $JQPath -c . ) $CBPROTO://$CBHOST:$CBPORT/$CBPATH/$UUID >> $LOGPATH/$UUID 2>>$LOGPATH/$UUID.err 1>&2
  fi
  curl -XPOST -d$( echo $1 | $JQPath -c . ) $CBPROTO://$CBHOST:$CBPORT/$CBPATH/$UUID >> $LOGPATH/$UUID 2>>$LOGPATH/$UUID.err
}
LOGBACK ( )
{
 curl -XPOST -d$( echo $1 | $JQPath -c . ) $LBURL:$LBPORT/$UUID >> $LOGPATH/$UUID 2>>$LOGPATH/$UUID.err
}

EXEC ( )
{
     {
        RUN  1>$LOGPATH/$UUID 2>$LOGPATH/$UUID.err &
        export PID=$!
        disown -h $PID
     }||{
        ERROR '{"error":"execution error", "comment":"problem running command?"}'
     }

     echo '{"UUID":"'$UUID'","PID":"'$PID'","COMMAND":"'$CMD'","DATE":"'$(date)'", "CTYPE":"'$CTYPE'", "ARGS":"'$ARGS'"}' | $JQPath -c .
 }||{ # catch json encodeing exception
     ERROR '{"error":"internal JSON encodeing error", "comment":"bad command output?"}'
}


