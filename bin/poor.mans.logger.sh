#!/usr/bin/env bash

#
# Poor mans logger, is a collection of Bash functions for simple logging.
# 
# Parameters:
# - DISABLE_COLOR_OUTPUT: to disable color output set this variable to 'true'
# - LOG_LEVEL: can be any of OFF, ALL, ERROR, WARN, INFO and DEBUG.
# - You can also set a path to a logging file by setting 
#   LOG_FILE_PATH=<path to logging file>
#
# To include this script with default settings (i.e., LOG_LEVEL="ALL" and no 
# writing to logging file), assuming that it is placed to the same directory 
# with your script:
# 
# ```
# . `dirname $0`/poor.mans.logger.sh
# ```
# In case that the script is not placed into the same directory, you have to 
# specify the full path to the poor.mans.logger.sh script, 
# e.g., /full/path/to/poor.mans.logger.sh:
#
# ```
# . /full/path/to/poor.mans.logger.sh
# ```
# 
# To include this script with custom settings, you need to set the paramters 
# before including this script:
# 
# ```
# LOG_LEVEL="ERROR"
# LOG_FILE_PATH="/tmp/output.log"
# . `dirname $0`/poor.mans.logger.sh
# ```
# 
# Otherwise, you can set LOG_LEVEL and/or LOG_FILE_PATH before the execution of your
# script that includes 'poor.mans.logger.sh'. For example, assume, that your script 
# is named as 'my_script.sh' and includes 'poor.mans.logger.sh' without setting 
# 'LOG_LEVEL' and 'LOG_FILE_PATH'. To control those parameters, you can simply set 
# those parameters just before the execution of 'my_script.sh':
#
# ```
# LOG_LEVEL="INFO" LOG_FILE_PATH="/tmp/my_output.log" ./my_script.sh
# ```
#

: ${DISABLE_COLOR_OUTPUT:="false"}

noColour='\033[0m'

# Colors for logging messages
if [[ ${DISABLE_COLOR_OUTPUT} = "true" ]]; then
  red=${noColour}
  green=${noColour}
  purple=${noColour}
  orange=${noColour}
  cyan=${noColour}
else
  red='\033[0;31m'
  green='\033[0;32m'
  purple='\033[0;35m'
  orange='\033[0;33m'
  cyan='\033[0;36m'
fi

# Threshold levels of logging
threshold_all=0
threshold_debug=1
threshold_info=2
threshold_warn=3
threshold_error=4
threshold_off=1000

# Default logging level is ALL
: ${LOG_LEVEL:="ALL"}

# Determine the logging level
case ${LOG_LEVEL} in
  "OFF" | "off")
    log_level_value=${threshold_off}
    ;;

  "ERROR" | "error")
    log_level_value=${threshold_error}
    ;;

  "WARN" | "warn")
    log_level_value=${threshold_warn}
    ;;  

  "INFO" | "info")
    log_level_value=${threshold_info}
    ;;  
  
  "DEBUG" | "debug")
    log_level_value=${threshold_debug}
    ;;
  
  *) 
    log_level_value=${threshold_all}
    ;;
esac

#
# Generic message logging function
#
# param $1 level: the name of the logging level
# param $2 color: the color to use 
# param $3 message: the message to log
log_message(){
    
    level=$1
    color=$2
    message=$3

    msg_date=$(date)
    echo -e "${noColour}${msg_date} ${color}[${level}] ${message}${noColour}"

    if [[ ! -z ${LOG_FILE_PATH+x} ]]; then
        echo "${msg_date} [${level}] ${message}" >> ${LOG_FILE_PATH}
    fi
}

# Logs info messages
# param $1: info message
log_info(){
    [[ ${log_level_value} -le ${threshold_info} ]] && log_message "INFO " ${green} "$1"
}

# Logs warning messages
# param $1: warning message
log_warn(){
    [[ ${log_level_value} -le ${threshold_warn} ]] && log_message "WARN " ${purple} "$1"
}

# Logs error messages
# param $1: error message
log_error(){
    [[ ${log_level_value} -le ${threshold_error} ]] && log_message "ERROR" ${red} "$1"
}

# Logs debug messages
# param $1: debug message
log_debug(){
    [[ ${log_level_value} -le ${threshold_debug} ]] && log_message "DEBUG" ${orange} "$1"
}