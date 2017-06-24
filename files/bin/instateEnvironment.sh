#!/usr/bin/with-contenv sh
grep -o "container.env.[a-zA-Z0-9_]*" $1 | while read -r GREPRESULT ; do
    ENVNAME=$(echo $GREPRESULT | cut -c15-)
    ENVVALUE=$(printenv $ENVNAME)
    if [ -z "$ENVVALUE" ]; then
        (>&2 echo "Could not replace $GREPRESULT due to a missing environment variable") 
    else 
        echo "Replacing $GREPRESULT with $ENVVALUE in $1"
        sed -i -e "s~$GREPRESULT~$ENVVALUE~g" $1
    fi
done