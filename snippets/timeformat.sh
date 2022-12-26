#!/usr/bin/env sh

stampformat() {
    PROPERTIME=$(getseconds $1)
    date -d@$PROPERTIME -u '+%H:%M:%S.%2N'
}

milliformat() {
    PROPERTIME=$(getseconds $1)
    # From seconds to milliseconds
    PROPERTIME=$(echo "$PROPERTIME * 1000" | bc)
    echo $PROPERTIME
}

getseconds() {
     PROPERTIME=$(echo $(removeformat $1) | awk -F: '{ print ($1 * 3600) + ($2 * 60) + $3 }')
     echo $PROPERTIME
}

removeformat() {
     WITHOUTDOT=$(echo $1 | sed 's/\./:/g')
     res="${1//[^.]}"
     DOTCOUNT=$(echo "${#res}")
     if [[ $DOTCOUNT == 1  ]]; then
           WITHOUTDOT="0:"$WITHOUTDOT
     elif [[ $DOTCOUNT == 0  ]]; then
           WITHOUTDOT="0:0:"$WITHOUTDOT
     fi
     echo $WITHOUTDOT
}
