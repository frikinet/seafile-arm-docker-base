#!/bin/bash


function rightsManagement() {
    if [ "$PUID" == "" ]
    then
        PUID=$(id -u seafile)
    fi

    if [ "$PGID" == "" ]
    then
        PGID=$(id -g seafile)
    fi

    groupmod -g $PGID seafile
    usermod -u $PUID seafile

    dirs=("/home/seafile" "/opt/seafile" "/shared")
    for dir in ${dirs[@]}
    do
        if [[ "$(stat -c %u $dir)" != $PUID || "$(stat -c %g $dir)" != $PGID ]]
        then
            chown -R seafile:seafile $dir
        fi
    done
}

function waitForDb() {
    export PYTHONPATH=${PYTHONPATH}:/opt/seafile/seafile-server-${VERSION}/seahub/thirdpart

    python3 - <<PYTHON_SCRIPT
import MySQLdb

while True:
    try:
        db=MySQLdb.connect(host="${MYSQL_HOST}")
    except MySQLdb.OperationalError as err:
        if err.args[0] == 1045:
            break
PYTHON_SCRIPT
}

function detectAutoMode() {
    if [ "$MYSQL_USER_PASSWD" ]
    then
        # Note: it's not possible to just call the script with "auto"
        # and the server name in argument is never set anywhere thus
        # it's basically useless.
        # So just keep it that way and wait for fixes (if they happen)
        export AUTO="auto -n useless"
    fi
}

rightsManagement
waitForDb

if [ ! -d "/shared/conf" ]
then
    detectAutoMode
    su seafile -pPc "/home/seafile/init.sh"
fi

su seafile -pPc "/home/seafile/launch.sh"
