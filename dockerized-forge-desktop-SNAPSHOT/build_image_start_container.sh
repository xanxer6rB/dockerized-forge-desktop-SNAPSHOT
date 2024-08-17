#!/bin/bash
echo "CONTAINERIZED forge-desktop-SNAPSHOT cardgame engine BUILD SCRIPT"
PS3='Choose One: '
forge=("Build image from Dockerfile ONLY" "Run container and remove container after exit" "Run container in detached mode. Will retain data after exit" "Quit")
select fav in "${forge[@]}"; do
    case $fav in
        ("Build image from Dockerfile ONLY")
        docker build -t dockerized-forge-desktop-snapshot-docker .
        break
        ;;
        ("Run container and remove container after exit")
        docker run --rm -it -p 3002:3000 dockerized-forge-desktop-snapshot bash
        break
        ;;
        ("Run container in detached mode. Will retain data after exit")
        docker run -d -it -p 3002:3000 dockerized-forge-desktop-snapshot bash
        break
        ;;
        ("Quit")
        echo "Now exiting"
        exit
        ;;
        (*) echo "invalid option $REPLY";;
    esac
done
