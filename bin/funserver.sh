#!/bin/bash -xe
#
# Startup script for Fun running on jetty
# Adapted from jetty.sh in the jetty 9.3 distribution

#####################################################
# Set the name which is used by other variables.
# Defaults to the file name without extension.
#####################################################

echo "SERVICE_HOME starts as $SERVICE_HOME"
echo "SERVICE_NAME starts as $SERVICE_NAME"


NAME=$(echo $(basename $0) | sed -e 's/^[SK][0-9]*//' -e 's/\.sh$//')
if [ -z "$SERVICE_NAME" ]
then
    SERVICE_NAME=$NAME
fi


usage()
{
    echo
    echo "Usage: ${0##*/} [-d] {start|stop|run|restart|status}"
    echo
    exit 1
}

[ $# -gt 0 ] || usage


#####################################################
# Some utility functions
#####################################################
list_op()
{
    local L OP=$1
    shift
    for L in "$@"; do
        [ "$OP" "$L" ] || continue
        printf %s "$L"
        break
    done
}

running()
{
    if [ -f "$1" ]
    then
        local PID=$(cat "$1" 2>/dev/null) || return 1
        kill -0 "$PID" 2>/dev/null
        return
    fi
    ###rm -f "$1"
    return 1
}

started()
{
    # wait for 60s to see "STARTED" in passed file
    for T in 1 2 3 4 5 6 7 9 10 11 12 13 14 15
    do
        sleep 4
        [ -z "$(grep STARTED $1 2>/dev/null)" ] || return 0
        [ -z "$(grep STOPPED $1 2>/dev/null)" ] || return 1
        [ -z "$(grep FAILED $1 2>/dev/null)" ] || return 1
        local PID=$(cat "$2" 2>/dev/null) || return 1
        kill -0 "$PID" 2>/dev/null || return 1
        echo -n ". "
    done

    return 1
}

#####################################################
# Functions to actually perform the actions
#####################################################

start()
{
    if (( NO_START )); then
        echo "Not starting ${NAME} - NO_START=1";
        return 0
    fi

    if [ $UID -eq 0 ] && type start-stop-daemon > /dev/null 2>&1
    then
        unset CH_USER
        if [ -n "$FUN_USER" ]
        then
            CH_USER="-c$FUN_USER"
        fi

        start-stop-daemon -S -p"$FUN_PID" $CH_USER -d"$FUN_HOME" -b -m -a "$JAVA" -- "${RUN_ARGS[@]}"
        echo "start-stop-daemon -S -p$FUN_PID $CH_USER -d$FUN_HOME -b -m -a $JAVA -- ${RUN_ARGS[@]}"

    else

        if running $FUN_PID
        then
            echo "Already Running $(cat $FUN_PID)!"
            return 1
        fi

        if [ -n "$FUN_USER" ] && [ `whoami` != "$FUN_USER" ]
        then
            unset SU_SHELL
            if [ "$FUN_SHELL" ]
            then
                SU_SHELL="-s $FUN_SHELL"
            fi

            touch "$FUN_PID"
            chown "$FUN_USER" "$FUN_PID"

            # FIXME: Broken solution: wordsplitting, pathname expansion, arbitrary command execution, etc.
            su - "$FUN_USER" $SU_SHELL -c "
            exec ${RUN_CMD[*]} > /dev/null &
            disown \$!
            echo \$! > '$FUN_PID'"
        else
            "${RUN_CMD[@]}" > /dev/null &
            disown $!
            echo $! > "$FUN_PID"
        fi

    fi

    if started "$FUN_STATE" "$FUN_PID"
    then
        echo "OK `date`"
    else
        echo "FAILED `date`"
        return 1
    fi
    
    return 0
}

stop()
{
    if [ $UID -eq 0 ] && type start-stop-daemon > /dev/null 2>&1; then
        start-stop-daemon -K -p"$FUN_PID" -d"$FUN_HOME" -a "$JAVA" -s HUP

        TIMEOUT=30
        while running "$FUN_PID"; do
            if (( TIMEOUT-- == 0 )); then
                start-stop-daemon -K -p"$FUN_PID" -d"$FUN_HOME" -a "$JAVA" -s KILL
            fi

            sleep 1
        done
    else
        if [ ! -f "$FUN_PID" ] ; then
            echo "ERROR: no pid found at $FUN_PID"
            return 1
        fi
        PID=$(cat "$FUN_PID" 2>/dev/null)
        if [ -z "$PID" ] ; then
            echo "ERROR: no pid id found in $FUN_PID"
            return 1
        fi
        kill "$PID" 2>/dev/null
        TIMEOUT=30
        while running $FUN_PID; do
            if (( TIMEOUT-- == 0 )); then
                kill -KILL "$PID" 2>/dev/null
            fi
            sleep 1
        done
    fi

    rm -f "$FUN_PID"
    rm -f "$FUN_STATE"
    echo OK
    
    return 0
}

run()
{
    if running "$FUN_PID" 
    then
        echo Already Running $(cat "$FUN_PID")!
        return 1
    fi

    exec "${RUN_CMD[@]}"

    return $?
}

status()
{
    if running "$FUN_PID"
    then
        echo "FunServer running pid=$(< "$FUN_PID")"
    else
        echo "FunServer not running"
    fi
    echo
    echo "FUN_HOME      = $FUN_HOME"
    echo "FUN_PID       = $FUN_PID"
    echo "FUN_STATE     = $FUN_STATE"
    echo "FUN_USER      = $FUN_USER"
    echo "CLASSPATH     = $CLASSPATH"
    echo "JAVA          = $JAVA"
    echo "JAVA_OPTIONS  = ${JAVA_OPTIONS[*]}"
    echo "FUN_ARGS      = ${FUN_ARGS[*]}"
    echo "RUN_CMD       = ${RUN_CMD[*]}"
    echo

    if ! running "$FUN_PID"
    then
         return 1
    fi
    return 0
}


#####################################################
# Get the action
#####################################################
NO_START=0
DEBUG=0

while [[ $1 = -* ]]; do
    case $1 in
      -d) DEBUG=1 ;;
      --debug) DEBUG=1 ;;
    esac
    shift
done
ACTION=$1
shift


#####################################################
# Try to find FUN_HOME if not already set
#####################################################

FUN_JAR_PATH="./lib/fun.jar"
if [ -z $FUN_HOME ]
then
    if [ -f "$FUN_JAR_PATH" ]
    then
        FUN_HOME="."

    elif [ -f "../$FUN_JAR_PATH" ]
    then
        FUN_HOME=".."

    elif [ -n $SERVICE_NAME ] && [ -f "/opt/$SERVICE_NAME/$FUN_JAR_PATH" ]
    then
        FUN_HOME="/opt/$SERVICE_NAME"

    elif [ -f "/opt/fun/$FUN_JAR_PATH" ]
    then
        FUN_HOME="/opt/fun"

    elif [ -f "/usr/share/$FUN_JAR_PATH" ]
    then
        FUN_HOME="/usr/share/fun"

    elif [ -f "~/fun/$FUN_JAR_PATH" ]
    then
        FUN_HOME="~/fun"

    else
      echo "ERROR: FUN_HOME not set and Fun not installed in a standard location"
      exit 1
    fi
fi

cd "$FUN_HOME"
FUN_HOME=$PWD

if [ "$SERVICE_HOME" == "" ]
then
    SERVICE_HOME="$FUN_HOME"
fi

cd "$SERVICE_HOME"
SERVICE_HOME=$PWD

echo "FUN_HOME is $FUN_HOME"
echo "SERVICE_HOME is $SERVICE_HOME"

#####################################################
# Set the classpath
#####################################################
for jar_file in $FUN_HOME/lib/*.jar; do
    if [ -z $CLASSPATH ]
    then
        CLASSPATH="$jar_file"
    else
        CLASSPATH="$CLASSPATH:$jar_file"
    fi
done    


#####################################################
# Find a location for the pid and state files
#####################################################
if [ -z "$FUN_RUN" ]
then
    FUN_RUN=$(list_op -w /var/run /usr/var/run $SERVICE_HOME /tmp)
fi

if [ -z "$FUN_PID" ]
then
    FUN_PID="$FUN_RUN/${NAME}.pid"
fi


FUN_STATE="$FUN_RUN/${NAME}.state"

#####################################################
# Generate a log file name and find a place for it
#####################################################
LOG_DIR=$(list_op -w /var/log $SERVICE_HOME /tmp .)

if [ -z "$LOG_DIR" ]
then
    echo "ERROR: Unable to find writable location for log file"
    exit 1
fi

case "$LOG_DIR" in
    /var/log)
        LOG_DIR="/var/log/${NAME}"
        ;;
    $SERVICE_HOME)
        LOG_DIR="$SERVICE_HOME/log"
        ;;
    /tmp)
        LOG_DIR="/tmp/log"
        ;;
    .)
        LOG_DIR="./log"
        ;;
esac

mkdir -p $LOG_DIR

NOW=$(date +"%F")
LOG_FILE="$LOG_DIR/${NAME}-$NOW.log"

echo "Logging to $LOG_FILE"

#####################################################
# Add the state file to the FUN_ARGS
#####################################################
if [ -z "$FUN_ARGS" ]
then
    FUN_ARGS="-sf $FUN_STATE -la $LOG_FILE"
else
    FUN_ARGS="$FUN_ARGS -sf $FUN_STATE -la $LOG_FILE"
fi

if [ -n "$HOST_ADDRESS" ]
then
    echo "Listening on $HOST_ADDRESS"
    FUN_ARGS="$FUN_ARGS -a $HOST_ADDRESS"
fi

#####################################################
# Setup JAVA if unset
#####################################################
if [ -z "$JAVA" ]
then
    JAVA=$(which java)
fi

if [ -z "$JAVA" ]
then
    echo "Cannot find Java." >&2
    exit 1
fi


RUN_ARGS=(${JAVA_OPTIONS[@]} -cp ${CLASSPATH} fun.runtime.FunServer ${FUN_ARGS[*]})
RUN_CMD=("$JAVA" ${RUN_ARGS[@]})


#####################################################
# Do the action
#####################################################
case "$ACTION" in
    start)
        echo -n "Starting FunServer: "
        start
    ;;

    stop)
        echo -n "Stopping FunServer: "
        stop
    ;;

    restart)
        echo -n "Restarting FunServer: "
        stop
        start
    ;;

    run)
        echo "Running FunServer: "
        run
    ;;

    status)
        status
    ;;

  *)
    usage

    ;;
esac

exit $?

