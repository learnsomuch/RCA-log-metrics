#!/bin/bash

# Update USAGE (USAGE1, USAGE2, USAGE3 may remain unchanged):
USAGE='Usage: $0 [-b|--boot] [-q|--quiet] [-l|--list] [-f file|--file file] [-Q arg|--query arg] args'
USAGE1='
Ambiguously abbreviated long option:'
USAGE2='
No such option:'
USAGE3='
Missing argument for'

# List all long options here (including leading --):
LONGOPTS=(--boot --auth --quiet --list --file --query --usage)

# List all short options that take an option argument here
# (without separator, without leading -):
SHORTARGOPTS=fQ

while [[ $# -ne 0 ]] ; do
  case $1 in
  --) shift ; break ;;  ### no more options
  -)  break ;;          ### no more options
  -*) ARG=$1 ; shift ;;
  *)  break ;;          ### no more options
  esac

  case $ARG in
  --*)
    FOUND=0
    for I in "${LONGOPTS[@]}" ; do
      case $I in
      "$ARG")  FOUND=1 ; OPT=$I ; break ;;
      "$ARG"*) (( FOUND++ )) ; OPT=$I ;;
      esac
    done
    case $FOUND in
    0) echo "$USAGE$USAGE2 $ARG" 1>&2 ; exit 1 ;;
    1) ;;
    *) echo "$USAGE$USAGE1 $ARG" 1>&2 ; exit 1 ;;
    esac ;;
  -["$SHORTARGOPTS"]?*)
    OPT=${ARG:0:2}
    set dummy "${ARG:2}" "$@"
    shift ;;
  -?-*)
    echo "$USAGE" 1>&2 ; exit 1 ;;
  -??*)
    OPT=${ARG:0:2}
    set dummy -"${ARG:2}" "$@"
    shift ;;
  -?)
    OPT=$ARG ;;
  *)
    echo "OOPS, this can't happen" 1>&2 ; exit 1 ;;
  esac

# list of all functions 

fun_usage() {

cat<<EOF
Usage : $0 [OPTIONS] [PARAMETERS]

Current available OPTIONS :
	-b | --bootlog	 	: This prints boot log (/var/log/boot.log) 
		[parameters]    : parameter can be any "content" to search within bootlog. For fu				   ll log to print, use blank within double quotes ( " " ) 
	-a | --authlog		: This prints auth log (/var/log/auth.log)
		[parameters]    : parameter can be any specfic "content" to search within authlog

	-u | --usage 		: Displays usage information 		

PARAMETERS :

Parameters are mandatory for any of the above listed option. If you are interested to view complete log, provide parameter as " " . If you are looking for specific text within a log, provide parameter as "text you are looking for" (within double quotes "").


for example,
root# $0 --bootlog "failed"
failed : boot order on 01-02-1010

RCA-log-metrics : This script handles various log file content searches to find root cause analaysis.
Author : Sankar Bheemarasetty ( sankar@learnsomuch.com )
License : Released under MIT License.
EOF
exit ${E_OK}

}

fun_bootlog() {

cat /var/log/boot.log | grep "$BOOTLOG";

}

fun_authlog() {

cat /var/log/auth.log | grep "$AUTHLOG";

}

  # Give both short and long form here.
  # Note: If the option takes an option argument, it it found in $1.
  # Copy the argument somewhere and shift afterwards!
  case $OPT in
	-b|--boot) [[ $# -eq 0 ]] && { echo"$USAGE$USAGE3 $OPT" 1>&2 ; exit 1 ; } 
	      BOOTLOG=$1 ; shift ; fun_bootlog ;;
  	-a|--auth) [[ $# -eq 0 ]] && { echo"$USAGE$USAGE3 $OPT" 1>&2 ; exit 1 ; }
              AUTHLOG=$1 ; shift ; fun_authlog ;;
	-q|--quiet) QUIETMODE=yes ;;
	-l|--list)  LISTMODE=yes ;;
	-f|--file)  [[ $# -eq 0 ]] && { echo "$USAGE$USAGE3 $OPT" 1>&2 ; exit 1 ; }
              FILE=$1 ; shift ;;
	-Q|--query) [[ $# -eq 0 ]] && { echo "$USAGE$USAGE3 $OPT" 1>&2 ; exit 1 ; }
              QUERYARG=$1 ; shift ;;
	-u|--usage) fun_usage ; exit 1 ;;
	*) fun_usage ; exit 1 ;;
  esac
done
