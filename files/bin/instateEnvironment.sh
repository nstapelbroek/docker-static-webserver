#!/usr/bin/with-contenv sh
grep -o "[[:alpha:]]*container.env.[[:graph:]]*" $1 | while read -r GREPRESULT ; do
    ENVNAME=$(echo $GREPRESULT | cut -c15-)
    ENVVALUE=$(printenv $ENVNAME)
    if [ -z "$ENVVALUE" ]; then
        (>&2 echo "Could not replace $GREPRESULT due to a missing environment variable") 
    else 
        echo "Replacing $GREPRESULT with $ENVVALUE in $1"
        sed -i -e "s~$GREPRESULT~$ENVVALUE~g" $1
    fi
done