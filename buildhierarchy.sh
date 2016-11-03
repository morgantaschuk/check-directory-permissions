#!/bin/bash
#set -x -v
set -u -e -o pipefail

usage() {
    echo "Usage: buildhierarchy.sh -d DIR_TO_TEST -o EXPECTED_OWNER [-c -p -r -g GROUP]"
    echo "-c create the files and directories"
    echo "-p test the permissions on the files and directories created previously"
    echo "-r remove the files and directories"
}

create() {
    onefile=$1
    twodir=$2
    threefile=$3
    fourfile=$4
    touch "${onefile}"
    mkdir "${twodir}"
    touch "${threefile}"
    touch "${fourfile}"
}

destroy() {
    onefile=$1
    twodir=$2
    threefile=$3
    fourfile=$4
    rm "${onefile}"
    rm "${threefile}"
    rm "${fourfile}"
    rmdir "${twodir}"
}

check_ownergroup() {
    file="${3}"
    owner="${1}"
    group="${2}"
    ownergroup=`stat -c '%U %G' "${file}"`
    if [ "${ownergroup}" != "${owner} ${group}" ]
    then
        echo "Owner and group not set correctly on ${file}"
        exit 1
    fi
}

check_permissions() {
    file="${1}"
    touch "${file}"
    cat "${file}"
}


testperms() {
    me=$1
    group=$2
    onefile=$3
    twodir=$4
    threefile=$5
    fourfile=$6

    check_ownergroup $me $group "$onefile"
    check_permissions "$onefile"

    check_ownergroup $me $group "$twodir"

    check_ownergroup $me $group "$threefile"
    check_permissions "$threefile"

    check_ownergroup $me $group "$fourfile"
    check_permissions "$fourfile"
}

CREATE=0
PERMS=0
REMOVE=0
GROUP='ilmninst'
while getopts ":d:o:cprg:" opt; do
  case $opt in
    d)
      #echo "-d was triggered, Parameter: $OPTARG" >&2
      DIR=$OPTARG
      ;;
    o)
      #echo "-o was triggered, Parameter: $OPTARG" >&2
      ME=$OPTARG
      ;;
    g)
      #echo "-g was triggered, Parameter: $OPTARG" >&2
      GROUP=$OPTARG
      ;;
    c)
      #echo "-c (create) was triggered" >&2
      CREATE=1
      ;;
    p)
      #echo "-p (check permissions) was triggered" >&2
      PERMS=1
      ;;
    r)
      #echo "-r (remove) was triggered" >&2
      REMOVE=1
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      usage
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      usage
      exit 1
      ;;
  esac
done




one="${DIR}/${ME}.file"
two="${DIR}/${ME}.dir"
three="${two}/${ME}.file"
four="${DIR}/`ls ${DIR}| head -1`/${ME}.file"

if [[ CREATE -eq 1 ]]
then
    echo "Create the hierarchy in $DIR using $ME"
    create "${one}" "${two}" "${three}" "${four}"
    echo "...Create OK"
fi

if [[ PERMS -eq 1 ]]
then
    echo "Test the hierarchy in $DIR using $ME"
    testperms "${ME}" "${GROUP}"  "${one}" "${two}" "${three}" "${four}"
    echo "...Test OK"
fi

if [[ REMOVE -eq 1 ]]
then
    echo "Destroy the hierarchy! (in $DIR using $ME)"
    destroy "${one}" "${two}" "${three}" "${four}"
    echo "...Destroy OK"
fi
