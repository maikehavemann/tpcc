#!/bin/sh
## 
## ENV
##   ${HOST} 
##   ${USER}
##   ${PASS}
##   ${DATA}
set -u
set -e

##
## global config
ROOT=/root/tpcc-mysql

##
## arguments
DATA=tpcc
W=1
while getopts "h:u:p:d:w:" opt; do
   case $opt in
      h)
         HOST=$OPTARG
         ;;
      u)
         USER=$OPTARG
         ;;
      p)
         PASS=$OPTARG
         ;;
      d)
         DATA=$OPTARG
         ;;
      w)
         W=$OPTARG
         ;;
   esac
done
shift $((OPTIND-1))

##
##
case $1 in
   config)
      echo "==> config"
      echo "    mysql://${HOST}/${DATA}"
      mysql -u${USER} -p${PASS} -h${HOST} -e "CREATE DATABASE ${DATA};"
      mysql -u${USER} -p${PASS} -h${HOST} ${DATA} < ${ROOT}/create_table.sql
      mysql -u${USER} -p${PASS} -h${HOST} ${DATA} < ${ROOT}/add_fkey_idx.sql
      ;;
      
   deploy)
      echo "==> deploy"
      echo "    mysql://${HOST}/${DATA}"
      echo "    ${W} warehouse"
      ${ROOT}/tpcc_load ${HOST} ${DATA} ${USER} ${PASS} ${W}
      ;;

   benchmark)
      echo "==> deploy"
      echo "    mysql://${HOST}/${DATA}"
      echo "    ${W} warehouse"
      ${ROOT}/tpcc_start -h${HOST} -d${DATA} -u${USER} -p${PASS} -w${W} -c16 -r10 -l60       
      ;;

   inspect)
      echo "==> inspect"
      echo "    mysql://${HOST}/${DATA}"
      mysql -u${USER} -p${PASS} -h${HOST} ${DATA} < ${ROOT}/count.sql
      ;;

   console)
      bash
      ;;

   help)
      echo "Usage:"
      echo "docker run -it fogfish/tpcc -h HOST -u USER -p PASS -d DATA config|deploy|benchmark|inspect|console|help"  
esac

