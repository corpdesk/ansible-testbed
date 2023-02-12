#!/usr/bin/env bash

SOPT='a:b'
LOPT='ab:'
OPTS=$(getopt -q -a \
    --options ${SOPT} \
    --longoptions ${LOPT} \
    --name "$(basename "$0")" \
    -- "$@"
)

if [[ $? > 0 ]]; then
    exit 2
fi

A= 
B=false
AB=

eval set -- $OPTS

while [[ $# > 0 ]]; do
    case ${1} in
        -a)  A=$2 && shift   ;;
        -b)  B=true          ;;
        --ab) AB=$2 && shift ;;
        --)                  ;;
        *)                   ;;
    esac
    shift
done

printf "Params:\n    A=%s\n    B=%s\n    AB=%s\n" "${A}" "${B}" "${AB}"