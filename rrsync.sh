#/bin/bash

### ABOUT
### Runs rsync, retrying on errors up to a maximum number of tries.
### Simply edit the rsync line in the script to whatever parameters you need.

# Trap interrupts and exit instead of continuing the loop
trap "echo Exited!; exit;" SIGINT SIGTERM

MAX_RETRIES=50
i=0

# Set the initial return value to failure
false

while [ $? -ne 0 -a $i -lt $MAX_RETRIES ]
do
    i=$(($i+1))
    sleep 10
    rsync -avz --partial --progress -e "ssh -p 12347" \
    cayman@54.200.43.224:/tmp/*2*.pcap .
done

if [ $i -eq $MAX_RETRIES ]
then
    echo "Hit maximum number of retries, giving up."
fi
