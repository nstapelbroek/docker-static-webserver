#!/usr/bin/with-contenv sh

if [ -z "$1" ]; then
    (>&2 echo "No file argument supplied, please pass a filepath as the first argument to this script")
    exit 1;
fi

grep -o "{container.env.[a-zA-Z0-9_]\+}" $1 | while read -r GREPRESULT ; do
    # Remove the {container.env.} from the grep result
    ENVNAME=$(echo $GREPRESULT | cut -c16- | rev | cut -c2- | rev)
    ENVVALUE=$(printenv $ENVNAME)
    
    if [ -z "$ENVVALUE" ]; then
        (>&2 echo "Could not replace $GREPRESULT due to a missing environment variable")
    else
        echo "Replacing $GREPRESULT with $ENVVALUE in $1"
        sed -i -e "s^$GREPRESULT^$ENVVALUE^g" $1
    fi
done