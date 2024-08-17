FROM alpine:latest as packager

RUN apk --no-cache add openjdk11-jdk openjdk11-jmods

ENV JAVA_MINIMAL="/opt/java-minimal"

# build minimal JRE
RUN /usr/lib/jvm/java-11-openjdk/bin/jlink \
    --verbose \
    --add-modules \
        java.base,java.sql,java.naming,java.desktop,java.management,java.security.jgss,java.instrument \
    --compress 2 --strip-debug --no-header-files --no-man-pages \
    --release-info="add:IMPLEMENTOR=radistao:IMPLEMENTOR_VERSION=radistao_JRE" \
    --output "$JAVA_MINIMAL"

FROM ghcr.io/linuxserver/baseimage-kasmvnc:alpine320

ENV JAVA_HOME=/opt/java-minimal
ENV PATH="$PATH:$JAVA_HOME/bin"

COPY --from=packager "$JAVA_HOME" "$JAVA_HOME"
WORKDIR /config
VOLUME /config

RUN \
    sudo apk update; sudo apk upgrade -y; apk add bzip2 wget curl; rm -rf /var/cache/apk/* && \
    sudo mkdir /app/forge-desktop-SNAPSHOT/ && \
    sudo touch setup_forge_desktop_snapshot.sh && \ 
    echo "mkdir /config/forge-desktop-SNAPSHOT; sudo wget -r -l1 -np 'https://downloads.cardforge.org/dailysnapshots/' -A 'forge-gui-desktop-*.tar.bz2'; echo 'EXTRACTING FILES TO /app/forge-desktop-SNAPSHOT'; sudo mv /config/downloads.cardforge.org/dailysnapshots/* /app/forge-desktop-SNAPSHOT; sudo bzip2 -d /app/forge-desktop-SNAPSHOT/*; sudo tar -xf /app/forge-desktop-SNAPSHOT/*; sudo mv /config/forge_game_selector.sh /tmp/forge_game_selector.sh; sudo mv /config/* /app/forge-desktop-SNAPSHOT; sudo mv /app/forge-desktop-SNAPSHOT/ssl /config; echo 'RUNNING CLEANING UP'; sudo rm -rf /app/forge-desktop-SNAPSHOT/downloads.cardforge.org; sudo mv /tmp/forge_game_selector.sh /config; echo 'SETUP COMPLETE','RUN ./forge_game_selector.sh TO SELECT A GAME MODE'" > /config/setup_forge_desktop_snapshot.sh && \
    sudo chmod +x setup_forge_desktop_snapshot.sh && \
    sudo touch /config/forge_game_selector.sh && \
    sudo chmod +x /config/forge_game_selector.sh && \
    echo -e '#!/bin/bash\nPS3=("Choose One: ")\nforge=("Play Forge-Desktop-SNAPSHOT" "Play Forge-Adventure" "Quit")\nselect fav in "${forge[@]}"; do\n\tcase $fav in\n\t\t("Play Forge-Desktop-SNAPSHOT")\n\t\t/app/forge-desktop-SNAPSHOT/forge.sh\n\t\tbreak\n\t\t# optionally call a function or run some code here\n\t\t;;\n\t\t("Play Forge-Adventure")\n\t\t/app/forge-desktop-SNAPSHOT/forge-adventure.sh\n\t\tbreak\n\t\t# optionally call a function or run some code here\n\t\t;;\n\t\t("Quit")\n\t\techo " Thank you for using forge-game-selector"\n\t\texit\n\t\t;;\n\t\t(*) echo "invalid option $REPLY";;\n\tesac\ndone' > /config/forge_game_selector.sh
    