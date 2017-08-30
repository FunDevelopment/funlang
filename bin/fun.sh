#!/bin/bash -xe
#
# Execute a Fun script
# 


run()
{
    exec "${RUN_CMD[@]}"
    return $?
}


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

echo "FUN_HOME is $FUN_HOME"

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


RUN_ARGS=(${JAVA_OPTIONS[@]} -cp ${CLASSPATH} fun.runtime.FunScript "$@")
RUN_CMD=("$JAVA" ${RUN_ARGS[@]})

run

exit $?

