#!bin/bash

########################################
#
# Unifi UC-CK Cloudkey Gen 1 updater
#
#  Update Debain jessie to the latest stage.
#
# ver 1.1
#
########################################


CODENAME=jessie
BASEDIR=/etc
BACKUPDIR=backup
APTDIR=apt
ASKREBOOT=0

# Color Codes
WHITE='\033[0;37m'
GREEN='\033[0;32m'
LRED='\033[1;31m'
YELLOW='\033[1;33m'

#USER=${SUDO_USER:-$(who -m | awk '{ print $1 }')}

# Everything else needs to be run as root
if [ $(id -u) -ne 0 ]; then
  printf "UC CK jessie update tool.\nScript must be run with root rights. Try \"sudo $0\"\n"
  exit 1
fi

is_installed() {
  if [ "$(dpkg -l "$1" 2> /dev/null | tail -n 1 | cut -d ' ' -f 1)" != "ii" ]; then
    return 1
  else
    return 0
  fi
}

do_update() {
  apt-get update &&
  apt-get upgrade -y
#&&
#  printf "Sleeping 5 seconds before reloading\n" &&
#  sleep 5 &&
  #exec $0
}

do_create_backupdir(){
    printf "${GREEN}"
    echo "Check backupdirs, and create if not exist."
    printf "${WHITE}"
    [ ! -d $BACKUPDIR ] && mkdir $BACKUPDIR
    [ ! -d $BACKUPDIR/$CODENAME ] && mkdir $BACKUPDIR/$CODENAME
    [ ! -d $BACKUPDIR/$CODENAME$BASEDIR ] && mkdir $BACKUPDIR/$CODENAME$BASEDIR
    [ ! -d $BACKUPDIR/$CODENAME$BASEDIR/$APTDIR ] && mkdir $BACKUPDIR/$CODENAME$BASEDIR/$APTDIR
    [ ! -d $BACKUPDIR/$CODENAME$BASEDIR/$APTDIR/sources.list.d ] && mkdir $BACKUPDIR/$CODENAME$BASEDIR/$APTDIR/sources.list.d
}

file_backup(){
    if [ -f "$BASEDIR/$1" ]; then
    printf "${GREEN}"
    printf "$1 file exists. Backing up.\n";
    cp $BASEDIR/$1 $BACKUPDIR/$CODENAME$BASEDIR/$1.bak
    else
    printf "${LRED}"
    printf "$1 file doesnt exist. Skipping.\n"
    #exit 1
    fi
    printf "${WHITE}"
}

packages_install() {
    for i in "$@"; do
        if is_installed $i; then
            printf "${GREEN}"
            printf "Already installed:                                  $i\n"
            printf "${WHITE}"
        else
            DEBIAN_FRONTEND=noninteractive apt install -y --force-yes $i
        fi;
    done
    printf "\n"
    printf "${GREEN}"
    printf "Done.\n\n"
    printf "${WHITE}"

}

do_finish() {
  if [ $ASKREBOOT -eq 1 ]; then
    whiptail --yesno "Would you like to reboot now?" 20 60 2
    if [ $? -eq 0 ]; then # yes
      sync
      reboot
    fi
  fi
#echo "${LANIF[*]}"
  exit 0
}

installer() {

    printf "${GREEN}"
    printf "Backing up files.\n"
    printf "${WHITE}"

    file_backup $APTDIR/sources.list
    file_backup $APTDIR/sources.list.d/security.list
    file_backup $APTDIR/sources.list.d/nodejs.list
    file_backup $APTDIR/sources.list.d/ubnt-unifi.list

    printf "\n"
    printf "${GREEN}"
    printf "Updating APT repository to archives since Debian/$CODENAME is archived.\n"
    echo "deb [trusted=yes] http://archive.debian.org/debian/ jessie main contrib non-free" > $BASEDIR/$APTDIR/sources.list
    echo "deb [trusted=yes] http://archive.debian.org/debian-security  jessie/updates main contrib non-free" > $BASEDIR/$APTDIR/sources.list.d/security.list


    [ -f $BASEDIR/$APTDIR/sources.list.d/nodejs.list~ ] &&
            printf "${LRED}" &&
            printf "NodeJS repository disabled already"&&
            printf "${WHITE}"
    [ -f $BASEDIR/$APTDIR/sources.list.d/nodejs.list ] &&
            printf "${GREEN}" &&
            printf "Disabling NodeJS repository, because not supported on Debian/$CODENAME anymmore." &&
            printf "${WHITE}" &&
            mv $BASEDIR/$APTDIR/sources.list.d/nodejs.list $BASEDIR/$APTDIR/sources.list.d/nodejs.list~

    printf "\n"

    [ -f $BASEDIR/$APTDIR/sources.list.d/ubnt-unifi.list~ ] &&
            printf "${LRED}" &&
            printf "Unifi  repository disabled already" &&
            printf "${WHITE}"
    [ -f $BASEDIR/$APTDIR/sources.list.d/ubnt-unifi.list ] &&
            printf "${GREEN}" &&
            printf "Disabling Unifi  repository, beause it's faulty.\n" &&
            printf "${WHITE}" &&
            mv $BASEDIR/$APTDIR/sources.list.d/ubnt-unifi.list $BASEDIR/$APTDIR/sources.list.d/ubnt-unifi.list~
    printf "\n"
    printf "\n"

    printf "Updating system\n"
    printf "\n"
    printf "${WHITE}"
    do_update

    printf "${GREEN}"
    printf "Installing required packages\n"
    printf "${WHITE}"


    local INSTALLIST=( mc tmux dirmngr )
    packages_install ${INSTALLIST[@]}
}



do_create_backupdir
installer
