#!/bin/bash -l
cd "$(dirname "$0")"

function _cleanup ()
{
  unset -f _usage _cleanup ; return 0
}

## Clear out nested functions on exit
trap _cleanup INT EXIT RETURN

function _usage {
cat <<EOF
  $* $Options
          Usage: updateDevServer.sh
          Options:
                  -h   --help           Show this message
                  -f   --full           Prune system during update 
EOF
exit 1;
}

function readEnvFile {
  set -o allexport
  source /opt/medied/deploy/.env
  set +o allexport
}

function sendCommands {
    local TARGET=$1
    local COMMANDS=$2
    echo "$(date '+%m/%d/%Y %H:%M:%S'): UPDATING $TARGET"
    sendStartNotification "$TARGET"
    if [ "$DRY_RUN" = true ]; then
      echo COMMANDS: "${COMMANDS}"
      echo -n "ON ERROR " && sendErrorNotification "$TARGET"
      echo -n "ON SUCCESS " && sendCompletedNotification "$TARGET"
    else
      sh -c "${COMMANDS}"
      retVal=$?
      if [ $retVal -ne 0 ]; then
        echo "Error"
        sendErrorNotification "$TARGET"
        exit $retVal
      else
        sendCompletedNotification "$TARGET"
      fi
    fi
}

function sendStartNotification {
  TARGET=$1
  sendMessageToRocketChat "Updating $TARGET to latest version on ${MEDIED_BRANCH}"
}

function sendCompletedNotification {
  TARGET=$1
  sendMessageToRocketChat "Update of $TARGET to latest version completed!"
}

function sendErrorNotification {
  TARGET=$1
  sendMessageToRocketChat "@all Update of $TARGET to latest version *FAILED*!!!"
}

function sendMessageToRocketChat {
  MESSAGE="$1"
  if [ "$DRY_RUN" = true ]; then
    echo NOTIFICATION: "$MESSAGE"
  else
    curl -s -X POST -H 'Content-Type: application/json' \
    --data "{\"username\":\"rocket.man\",\"icon_url\":\"https://chat..us/avatar/rocket.cat\",\"text\":\"$MESSAGE\",\"attachments\":[]}" \
    https:// >/dev/null
  fi
}

#[ $# = 0 ] && _usage "  >>>>>>>> no options given "

###### some declarations for these example ######
SERVER=$(hostname)

Options=$@
Optnum=$#
RESTART=false
FULL=false

##################################################################
#######  "getopts" with: short options  AND  long options  #######
#######            AND  short/long arguments               #######
while getopts ':hd' OPTION ; do
  case "$OPTION" in
    h  ) _usage ;;
    f  ) FULL=true ;;
    d  ) DRY_RUN=true ;;
    -  ) [ $OPTIND -ge 1 ] && optind=$(expr $OPTIND - 1 ) || optind=$OPTIND
         eval OPTION="\$$optind"
         OPTARG=$(echo $OPTION | cut -d'=' -f2)
         OPTION=$(echo $OPTION | cut -d'=' -f1)
         case $OPTION in
             --help      ) _usage ;;
             --dry-run   ) DRY_RUN=true ;;
             --full      ) FULL=true ;;
             * )  _usage " >>>>>>>> invalid options:" ;;
         esac
       OPTIND=1
       shift
      ;;
    ? )  _usage ">>>>>>>> invalid options:"  ;;
  esac
done

if [[ "$FULL" = true ]]; then
  ## This was changed to docker prune due to previous issues which had placed as a result of artefacts from the previous deploy.
  COMMANDS="sh bounceFull.sh"
else
  COMMANDS="sh bounce.sh"
fi

readEnvFile
sendCommands "$DOMAIN on $SERVER" "${COMMANDS}"