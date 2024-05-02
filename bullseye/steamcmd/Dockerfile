############################################################
# Dockerfile that contains SteamCMD for ARMV8
############################################################
FROM --platform=linux/arm64/v8 debian:bookworm-slim as build_stage

ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

RUN set -x \
	# for steamcmd even though it's a 32 bit binary
	&& dpkg --add-architecture amd64 \
	# for box86 that needs to run steamcmd
	&& dpkg --add-architecture armhf \
	&& apt-get update \
	&& apt install -y wget gpg binutils xz-utils \
	&& wget https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& wget https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
	&& wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
	&& wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg \
	&& apt-get update \
	&& apt-get install -y libc6:armhf libtinfo6:armhf box64 box86-generic-arm:armhf \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6:amd64 \
		lib32gcc-s1:amd64 \
		ca-certificates:amd64 \
		nano \
		curl \
		locales \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	&& rm -rf /var/lib/apt/lists/* \
	&& apt-get remove gpg -y && apt-get autoremove -y && apt-get clean

ENV BASH_DIR "/tmp/bash_install"

# Install i386 bash (kind of hacky)
RUN set -x \
	mkdir -p ${BASH_DIR} \
	&& wget 'http://ftp.debian.org/debian/pool/main/b/bash/bash_5.2.15-2+b2_i386.deb' -P "${BASH_DIR}" \
	&& cd ${BASH_DIR} \
	&& mv "bash_5.2.15-2+b2_i386.deb" "bash.deb" \
	&& ar -x "bash.deb" \
	&& tar -xf data.tar.xz \
	&& mv "bin/bash" "/bin/bash_i386" \
	&& cd - && rm -r ${BASH_DIR}

# Install amd64 bash (kind of hacky)
RUN set -x \
	mkdir -p ${BASH_DIR} \
	&& wget 'http://ftp.debian.org/debian/pool/main/b/bash/bash_5.2.15-2+b2_amd64.deb' -P "${BASH_DIR}" \
	&& cd ${BASH_DIR} \
	&& mv "bash_5.2.15-2+b2_amd64.deb" "bash.deb" \
	&& ar -x "bash.deb" \
	&& tar -xf data.tar.xz \
	&& mv "bin/bash" "/bin/bash_amd64" \
	&& cd - && rm -r ${BASH_DIR}

ENV BOX64_DIR "/tmp/box"
ENV BOX86_BASH "/bin/bash_i386"
ENV BOX64_BASH "/bin/bash_amd64"

RUN set -x \
	# Create unprivileged user
	&& useradd -u "${PUID}" -m "${USER}" \
	# Download SteamCMD, execute as user
	&& su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
                && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
				&& box86 \"${BOX86_BASH}\" \"${STEAMCMDDIR}/steamcmd.sh\" +quit \
                ; ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
                && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	# # Symlink steamclient.so; So misconfigured dedicated servers can find it
 	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so"

# Old lib from debian buster that avoids crash
COPY "dl/libmvec.so.1" "/lib/x86_64-linux-gnu/libmvec.so.1"

FROM build_stage AS bookworm-root
WORKDIR ${STEAMCMDDIR}

FROM bookworm-root AS bookworm
