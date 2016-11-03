#!/bin/bash
set -x -v
set -u -e -o pipefail

#takes one argument: the directory to test
DIR=$1
#find the directory where the script is (print script directory)
PSD="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

#test lifecycle with each user independently
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o seqprodbio -cpr" seqprodbio
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o sbsuser -cpr" sbsuser

#create the hierarchy with sbsuser and test with seqprodbio
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o sbsuser -c" sbsuser
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o sbsuser -pr" seqprodbio

#create the hierarchy with seqprodbio and test with sbsuser
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o seqprodbio -c" seqprodbio
cd "${PSD}" && su -m -c "bash buildhierarchy.sh -d ${DIR} -o seqprodbio -pr" sbsuser


