#!/bin/bash
mkdir -p "${STEAMAPPDIR}" || true

box86 $BOX86_BASH "${STEAMCMDDIR}/steamcmd.sh" +force_install_dir "${STEAMAPPDIR}" \
				+login anonymous \
				+app_update "${STEAMAPPID}" \
				+quit

# Are we in a metamod container and is the metamod folder missing?
if  [ ! -z "$METAMOD_VERSION" ] && [ ! -d "${STEAMAPPDIR}/${STEAMAPP}/addons/metamod" ]; then
    LATESTMM=$(wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/mmsource-latest-linux)
    wget -qO- https://mms.alliedmods.net/mmsdrop/"${METAMOD_VERSION}"/"${LATESTMM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Are we in a sourcemod container and is the sourcemod folder missing?
if  [ ! -z "$SOURCEMOD_VERSION" ] && [ ! -d "${STEAMAPPDIR}/${STEAMAPP}/addons/sourcemod" ]; then
    LATESTSM=$(wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/sourcemod-latest-linux)
    wget -qO- https://sm.alliedmods.net/smdrop/"${SOURCEMOD_VERSION}"/"${LATESTSM}" | tar xvzf - -C "${STEAMAPPDIR}/${STEAMAPP}"
fi

# Believe it or not, if you don't do this srcds_run shits itself
cd "${STEAMAPPDIR}"

SERVER_SECURITY_FLAG="-secured";

if [ "$SRCDS_SECURED" -eq 0 ]; then
    SERVER_SECURITY_FLAG="-insecured";
fi

if [ -z "${SRCDS_STARTMAP}" ]; then
    SRCDS_MAP_COMMAND="+randommap"
else
    SRCDS_MAP_COMMAND="+map ${SRCDS_STARTMAP}"
fi

if [ -n "${SRCDS_TV_PORT}" ]; then
    SRCDS_TV_COMMAND="+tv_port $SRCDS_TV_PORT"
fi

box64 $BOX64_BASH "${STEAMAPPDIR}/srcds_run_64" -game "${STEAMAPP}" -console -autoupdate \
            -steam_dir "${STEAMCMDDIR}" \
            -steamcmd_script "${HOMEDIR}/${STEAMAPP}_update.txt" \
            -usercon \
            -port "${SRCDS_PORT}" \
            +clientport "${SRCDS_CLIENT_PORT}" \
            "$SRCDS_TV_COMMAND" \
            +maxplayers "${SRCDS_MAXPLAYERS}" \
            "$SRCDS_MAP_COMMAND" \
            +sv_setsteamaccount "${SRCDS_TOKEN}" \
            +rcon_password "${SRCDS_RCONPW}" \
            +sv_password "${SRCDS_PW}" \
            +sv_region "${SRCDS_REGION}" \
            -ip "${SRCDS_IP}" \
            -authkey "${SRCDS_WORKSHOP_AUTHKEY}" \
            +servercfgfile "${SRCDS_CFG}" \
            +mapcyclefile "${SRCDS_MAPCYCLE}" \
            ${SERVER_SECURITY_FLAG}
