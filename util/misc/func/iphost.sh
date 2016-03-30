#if its an ip, return it, if its a host resolve it and return the ip
iphost_resolve( ){ 
  host $1 | grep .in-addr.arpa
  if [ "$?" -eq "0" ]
  then
    echo $1
  else
    dig +short $1
  fi
}


