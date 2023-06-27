#!/usr/bin/env bash 
# ref: https://stackoverflow.com/questions/402377/using-getopts-to-process-long-and-short-command-line-options

# $ ./getopts_test.sh
# $ ./getopts_test.sh -f
# Non-option argument: '-f'
# $ ./getopts_test.sh -h
# usage: code/getopts_test.sh [-v] [--loglevel[=]<value>]
# $ ./getopts_test.sh --help
# $ ./getopts_test.sh -v
# Parsing option: '-v'
# $ ./getopts_test.sh --very-bad
# $ ./getopts_test.sh --loglevel
# Parsing option: '--loglevel', value: ''
# $ ./getopts_test.sh --loglevel 11
# Parsing option: '--loglevel', value: '11'
# $ ./getopts_test.sh --loglevel=11
# Parsing option: '--loglevel', value: '11'

optspec=":hv-:"
while getopts "$optspec" optchar; do
    case "${optchar}" in
        -)
            case "${OPTARG}" in
                loglevel)
                    val="${!OPTIND}"; OPTIND=$(( $OPTIND + 1 ))
                    echo "Parsing option: '--${OPTARG}', value: '${val}'" >&2;
                    ;;
                loglevel=*)
                    val=${OPTARG#*=}
                    opt=${OPTARG%=$val}
                    echo "Parsing option: '--${opt}', value: '${val}'" >&2
                    ;;
                *)
                    if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
                        echo "Unknown option --${OPTARG}" >&2
                    fi
                    ;;
            esac;;
        h)
            echo "usage: $0 [-v] [--loglevel[=]<value>]" >&2
            exit 2
            ;;
        v)
            echo "Parsing option: '-${optchar}'" >&2
            ;;
        *)
            if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
                echo "Non-option argument: '-${OPTARG}'" >&2
            fi
            ;;
    esac
done
