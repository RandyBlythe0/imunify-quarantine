#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
JAIL_DIR="/root/.quarantine"
DAYS="14"
LOG="/var/log/custom_quarantine.log"
echo "Logging to $LOG"
echo "Quarantine folder is $JAIL_DIR"

function log
{
 echo "[$(date)]: [$1] : $2">>$LOG
}

function quarantine_malwares
{
recovery_file=$JAIL_DIR/recovery_$(date +"%Y-%m-%d-%H-%M").sh
echo "Recovery file: $recovery_file"
mkdir -p "$JAIL_DIR"
for file in `imunify360-agent malware malicious list --limit 100000| awk {'if( NR > 1) print $4'}`
do
        #echo $file
        file="$file"
        #echo $file
        VIRUS_PATH="`dirname $file`"
        #log "VIRUS" $file
        JAIL_PATH="$JAIL_DIR$VIRUS_PATH"
        log "COMMAND" "mkdir -p $JAIL_PATH"
        if [ -f "$file" ]; then
                log "INFO" "Building Directory Structure $JAIL_PATH"
                mkdir -p $JAIL_PATH
                log "INFO" "Moving $file to $JAIL_PATH"
                mv $file $JAIL_DIR$file
                touch $JAIL_DIR$file
                log "INFO" "Creating Restore command"
                echo "mv $JAIL_DIR$file $file" >> $recovery_file
        else
                log "ERROR" "$file doesn't exists."
                SCAN_MSG=1
        fi
        done
        if [ $SCAN_MSG -eq "1" ]; then
                echo "Some files in imunify scan list are missing, consider running scan again."
        fi

}

function delete_old_malwares
{
find $JAIL_DIR -mtime +$DAYS -exec rm {} \;
}

function help_me
{
echo "quarantine [option]"
echo "-q : move malwares detected from imunify to quarantine folder"
echo "-d : delete quarantine files lder than 14 days"
echo "-r : restore "
echo "-h : show this message"
}

function restore
{
log "INFO" "feature coming Soon..."
}

log "INFO" "*********Starting Custom Quarantine for Imunify 360**********"
param="$1"
case "$param" in
        "-q")
        echo "Moving files to Quarantine...."
        quarantine_malwares
        ;;
        "-d")
        delete_old_malwares
        ;;
        "-h")
        help_me
        ;;
        *)
        help_me
        ;;
        esac
        #shift
IFS=$SAVEIFS
