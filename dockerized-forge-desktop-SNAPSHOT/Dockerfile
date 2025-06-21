FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine321
WORKDIR /config
VOLUME /config
RUN \
    apk update; apk upgrade -y; apk add wget curl jq openjdk17-jdk; rm -rf /var/cache/apk/* && \
    mkdir /app/forge-desktop-SNAPSHOT/ && \ 
    ASSET_URL=$(curl -s "https://api.github.com/repos/Card-Forge/forge/releases/tags/daily-snapshots" | jq -r '.assets[] | select(.name | contains(".tar.bz2")) | .browser_download_url') && \
    wget $ASSET_URL -O /app/forge-desktop-SNAPSHOT/forge-installer-SNAPSHOT-latest.tar.bz2 && \
    echo 'EXTRACTING FILES AND CREATING forge_game_selector SCRIPT' && \
    tar -xjf /app/forge-desktop-SNAPSHOT/forge-installer-SNAPSHOT-latest.tar.bz2 -C /app/forge-desktop-SNAPSHOT; rm /app/forge-desktop-SNAPSHOT/*.tar.bz2 && \
    touch /config/forge_game_selector.sh && \
    chmod +x /config/forge_game_selector.sh && \
    echo -e '#!/bin/bash\nPS3=("Choose One: ")\nforge=("Play Forge-Desktop-SNAPSHOT" "Play Forge-Adventure" "Quit")\nselect fav in "${forge[@]}"; do\n\tcase $fav in\n\t\t("Play Forge-Desktop-SNAPSHOT")\n\t\t/app/forge-desktop-SNAPSHOT/forge.sh\n\t\tbreak\n\t\t# optionally call a function or run some code here\n\t\t;;\n\t\t("Play Forge-Adventure")\n\t\t/app/forge-desktop-SNAPSHOT/forge-adventure.sh\n\t\tbreak\n\t\t# optionally call a function or run some code here\n\t\t;;\n\t\t("Quit")\n\t\techo " Thank you for using forge-game-selector"\n\t\texit\n\t\t;;\n\t\t(*) echo "invalid option $REPLY";;\n\tesac\ndone' > /config/forge_game_selector.sh
