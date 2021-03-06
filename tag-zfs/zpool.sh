#!/bin/bash

#ZFS SPECIFIC STUFF

    
    case $PLATFORM in 
        "Linux")
            defaultMountPoint="/run/media/$(whoami)/ZFS"  
            zpoolLocation="/usr/sbin/zpool"
            group="users"
            checkIfMountable() { [[ "${defaultMountPoint}/$1" == "$2" ]] && echo 1 || echo 0 ;}
            ;;
        "Darwin")
            defaultMountPoint="/Volumes" 
            zpoolLocation=$(which zpool)
            group="staff"
            checkIfMountable() { [[ "${defaultMountPoint}/$1" == "$2" ]] && echo 1 || echo 0 ;}
            ;;
        *)
            defaultMountPoint="/mnt/ZFS" 
            ;;
    esac
    export cfs="$defaultMountPoint"


    zpooli() {  
        [ ! -d $defaultMountPoint ] && { echo $defaultMountPoint "does not exist. Creating.." ; sudo mkdir -p $defaultMountPoint ;}
        [[ "$PLATFORM" = "Darwin" ]] && sudo zpool import -a ${1} -N || sudo zpool import -a ${1} -N -R ${defaultMountPoint}
        pools=()
        mounts=()
        nameLength=""
        
        #Saving old IFS for later restore and setting new to newline to iterate over multiline cmd output
        IFSOLD=$IFS
        IFS='
'

        for line in $(sudo zfs list|tail -n+2); do
            pool=$(echo $line|cut -d ' ' -f 1)
            #Does not work in macOS because macOS grep does not support -P flag for Perl regex which is required for positive lookahead (?<=...)
            [[ "$PLATFORM" == "Linux"  ]] && mount=$(echo $line|grep -Po '(?<=\s)\/.+' )
            [[ "$PLATFORM" == "Darwin" ]] && mount=$(echo $line|grep -Eo '\/.+')
            pools=( ${pools[@]} $pool )
            mounts=( ${mounts[@]} ${mount:-"-"} )
            [[ ${#pool} -ge $nameLength ]] && nameLength=${#pool}
        done
        IFS=$IFSOLD
        #Debug line
        #for i in {1..${#pools[@]}};do echo "${pools[$i]} ${mounts[$i]}";done
        
        for (( i=1;i<=${#pools[@]};i++ )) ; do
            if [[ $(checkIfMountable "${pools[$i]}" "${mounts[$i]}") -eq 1 ]]; then
                printf "Mounting %${nameLength}s to %s\n" ${pools[$i]} ${mounts[$i]}
                sudo zfs mount ${pools[$i]}
                #sudo chown $(whoami) ${mounts[$i]}
                #sudo chgrp $group    ${mounts[$i]}
            fi
        done
        #[[ "$PLATFORM" = "Darwin" ]] && [[ -d /Volumes/ZShare/Nextcloud ]] && {
            #sudo chmod -R -E <<<"$(whoami) allow list,add_file,search,delete,add_subdirectory,delete_child,readattr,writeattr,readextattr,writeextattr,readsecurity,writesecurity,file_inherit,directory_inherit" /Volumes/ZShare/Nextcloud 
        #; }

        #[[ "$PLATFORM" = "Linux" ]] && [[ -d $defaultMountPoint/ZShare/Nextcloud ]] && {
#            find $defaultMountPoint/ZShare/Nextcloud \! -uid $(id -u) -print | xargs -I% sudo chown -R $(id -u) % 
        #}
    } 
    
    alias zpoole="sudo zpool export -a" 

