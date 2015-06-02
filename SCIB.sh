#!/bin/bash

ME="$0"
END_SIGNATURE="#-E@N@D-#"

function copyThisContentToAFile {
    THIS_CONTENT_PATH="/tmp/$$.content.tmp"
    awk 'end != 1 {print} /'"$END_SIGNATURE"'$/ {end=1}' $ME > $THIS_CONTENT_PATH
    
    FILE_COPY_PATH="/tmp/$$.original.tmp"
    cp $1 $FILE_COPY_PATH
        
    cat $THIS_CONTENT_PATH $FILE_COPY_PATH > $1

    rm -f $FILE_COPY_PATH $THIS_CONTENT_PATH
}

function copyThisContentToFiles {
    for FILE in "$@"
    do
        copyThisContentToAFile $FILE
    done
}

function executeTheActualFile {
    ACTUAL_CONTENT_PATH="/tmp/$$.actual.tmp"
    
    tail -n +$(awk '/'"$END_SIGNATURE"'$/ {print NR+1}' $ME) $ME  > $ACTUAL_CONTENT_PATH
    
    chmod +x $ACTUAL_CONTENT_PATH
    
    $ACTUAL_CONTENT_PATH "$@"
    RESULT=$?

    rm -f $ACTUAL_CONTENT_PATH

    return $RESULT
}

function isThisAttachedToFile {
    END_SIGNATURE_LINE_NUMBER="$(awk '/'$END_SIGNATURE'$/ {print NR}' $ME)"
    THIS_LINES_COUNT="$(wc -l $ME | awk '{print $1}')"

    if [[ $END_SIGNATURE_LINE_NUMBER -eq $THIS_LINES_COUNT ]]
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

