###########################################################
# Dockerfile that builds a TF2 Gameserver
###########################################################
FROM steamcmd_arm:latest AS build_stage

ENV STEAMAPPID 232250
ENV STEAMAPP tf
ENV STEAMAPPDIR "${HOMEDIR}/${STEAMAPP}-dedicated"
ENV CFGDIR "${STEAMAPPDIR}/${STEAMAPP}/cfg"
ENV CPU_MHZ 2000

VOLUME [ "${STEAMAPPDIR}", "${CFGDIR}" ]

RUN set -x \
	# Add i386 architecture
	&& dpkg --add-architecture amd64 \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		wget:amd64=1.21.3-1+b2 \
		ca-certificates:amd64=20230311 \
		zlib1g:amd64=1:1.2.13.dfsg-1 \
		libncurses5:amd64=6.4-4 \
		libbz2-1.0:amd64=1.0.8-5+b1 \
		libtinfo5:amd64=6.4-4 \
		libcurl3-gnutls:amd64=7.88.1-10+deb12u5 \
	&& apt-get autoremove -y && apt-get clean \
	&& mkdir -p "${STEAMAPPDIR}" \
	# Create autoupdate config
	&& { \
		echo '@ShutdownOnFailedCommand 1'; \
		echo '@NoPromptForPassword 1'; \
		echo 'force_install_dir '"${STEAMAPPDIR}"''; \
		echo 'login anonymous'; \
		echo 'app_update '"${STEAMAPPID}"''; \
		echo 'quit'; \
	   } > "${HOMEDIR}/${STEAMAPP}_update.txt" \
	# Clean up
	&& rm -rf /var/lib/apt/lists/*

FROM build_stage AS bookworm-base

ENV SRCDS_FPSMAX=300 \
	SRCDS_TICKRATE=66 \
	SRCDS_PORT=27015 \
	SRCDS_TV_PORT=27020 \
        SRCDS_NET_PUBLIC_ADDRESS="0" \
        SRCDS_IP="0" \
	SRCDS_MAXPLAYERS=24 \
	SRCDS_TOKEN=0 \
	SRCDS_RCONPW="" \
	SRCDS_PW="" \
	SRCDS_STARTMAP="" \
	SRCDS_REGION=3 \
	SRCDS_WORKSHOP_START_MAP=0 \
	SRCDS_HOST_WORKSHOP_COLLECTION=0 \
	SRCDS_WORKSHOP_AUTHKEY="" \
	SRCDS_CFG="server.cfg" \
	SRCDS_MAPCYCLE="mapcycle.txt" \
	SRCDS_SECURED=1

COPY "./etc/entry.sh" "${HOMEDIR}/entry.sh"
COPY "./etc/debug.sh" "${HOMEDIR}/debug.sh"

RUN chmod +x "${HOMEDIR}/entry.sh" \
	&& chmod +x "${HOMEDIR}/debug.sh" \
	&& chown -R "${USER}:${USER}" "${HOMEDIR}/entry.sh" "${STEAMAPPDIR}" "${HOMEDIR}/${STEAMAPP}_update.txt"

# Switch to user
USER ${USER}

WORKDIR ${HOMEDIR}

CMD ["bash", "entry.sh"]

# Expose default ports
EXPOSE 27015/tcp \
	27015/udp \
	27020/udp
