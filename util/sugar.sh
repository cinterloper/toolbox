
Die() {
  kill -9 $$
}

#@params=(REQ(func:callback,int:exit_code,string:error);OPT('string[]':callback_args))
#@output=(UNDEF)
#@error=(UNDEF)
verifyOr() {
  if [[ "$2" -ne "0" ]]
  then
    echo "$3" 1>&2
    CMD=$1
    shift 3
    if [[ "$DEBUG" -eq "true" ]];
    then 
      logger $CMD $@;  
    fi
    $CMD $@
  fi
}

#@params(REQ(string:message);OPT(int:level))
#@output=(NULL)
logger() {
  if [[ -z "$@" ]]
  then
    read -a input
    printf 'DEBUG: %s\n' "${input[@]}"
  fi
  if [[ "$DEBUG" -eq "true" ]]
  then
    echo "DEBUG: " $@ 1>&2
  fi
}

#@output=(ip:gateway)
getDefaultGateway( ) {
  ip route | grep default  | cut -d ' ' -f 3
}
