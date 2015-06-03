#!/bin/bash

ME="$0"
END_SIGNATURE="#-E@N@D-#"
SCIB_LINES_COUNT=$(awk '/'"$END_SIGNATURE"'$/ {print NR+1}' $ME)

function copyThisContentToAFile {
    FILE_COPY_PATH="/tmp/$$.original.tmp"
    
    cp $1 $FILE_COPY_PATH
        
    cat $ME $FILE_COPY_PATH > $1

    rm -f $FILE_COPY_PATH
}

function copyThisContentToFiles {
    for FILE in "$@"
    do
        copyThisContentToAFile $FILE
    done
}

function executeTheActualFile {
    ACTUAL_CONTENT_PATH="/tmp/$$.actual.tmp"
    ((ACTUAL_FILE_START_LINE = SCIB_LINES_COUNT+1))
    tail -n +$ACTUAL_FILE_START_LINE $ME > $ACTUAL_CONTENT_PATH
    
    chmod +x $ACTUAL_CONTENT_PATH
    
    $ACTUAL_CONTENT_PATH "$@"
    RESULT=$?

#    rm -f $ACTUAL_CONTENT_PATH

    return $RESULT
}

function isThisAttachedToFile {
    FILE_LINES_COUNT="$(wc -l $ME | awk '{print $1}')"

    if [[ $SCIB_LINES_COUNT -eq $FILE_LINES_COUNT ]]
    then
        return 1
    else
        return 0
    fi
}

function doAction {
    echo "Hello! SCIB is here! :)"
}
    

########################################
# Main
########################################
echo "LINES COUNT: $SCIB_LINES_COUNT"


if isThisAttachedToFile
then
    doAction
    
    executeTheActualFile "$@"

    exit $?
else
    if [[ $# -gt 0 ]]
    then    
        copyThisContentToFiles "$@"
    fi
fi

exit 0


#-E@N@D-#

