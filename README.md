# Team Fortress 2 Server on ARM machine

[Link to the Docker Hub repository](https://hub.docker.com/r/mhktp/tf2-arm-server)

This container wraps everything that needs to be installed to make a TF2 server works on an ARM machine. It uses [Box64](https://github.com/ptitSeb/box64) ([Box86](https://github.com/ptitSeb/box86) for steamcmd) to have the best emulation performances.

## Installation
### Build
Make sure Docker is installed.
Note : the layers hash may be different because of box64 and box86 updates.

```sh
cd src
./build.sh
```

### Starting the server

**Every utils scripts are contained inside the `src` directory.**

This TF2 container assumes that the tf2 installation is persistent and might be shared across multiple docker containers. There are 2 volumes that you need to set, the TF2 installation and the `cfg` folder.

**First** you'll need to create a `bashenv` file inside `src` where you'll put :

 - RCONPWD="" # RCON password to connect remotely as Console (shared across containers)
 - ARR_SERVER_TOKENS=() # [Server account tokens](https://steamcommunity.com/dev/managegameservers)
 \# Example : ARR_SERVER_TOKENS=("5E7AF12F4DB6C559A8E59D9F9245478B", "4E2F9D7A85194F5AB0B56D295FEC4979")

**Before starting anything, here is the `start.sh` arguments list based on index :**

`$i` represents the number of active containers.

 1. Container Name: (Default: `tf2_arm_$i`) *if set as `dev`, you can start the container as root with a `/bin/bash` entrypoint.*
 2. Game Installation Directory: (Default: `$HOME/tf2`)
 3. Configuration Directory: (is the realpath from $PWD/etc/cfg/${Configuration Directory}. If it fails, it's considered to be the fullpath) (Default: `normal`)
 4. Configuration Volume Directory: (Default: `$HOME/cfg_${Configuration Directory}`)
 5. Server Account Token: (Default: `${ARR_SERVER_TOKENS[$i]}`)

### Configurations
Before doing anything, you will need to edit some files in the `etc` directory.
There is the `cfg` directory that contains the `normal` configuration directory. You can put different configuration directories for different type of servers. Furthermore, you can directly modify the files inside `normal` or make a copy, but don't forget to configure the `start.sh` arguments like this :
```sh
./start.sh "" "" myconfdir "/path/to/cfg_myconfdir"
```
Notice : the `"/path/to/cfg_myconfdir"` will be automatically created if it doesn't exists.

The `start.sh` script will copy and overwrite everything inside the configuration volume, so be careful before adding any new files in the config directory.

## Credits

Credit goes to the developer of these containers ([CM2Walki](https://github.com/CM2Walki)) for laying the foundation upon which this container was built :
[x86_64 TF2 Container](https://github.com/CM2Walki/TF2)
[x86_64 Steamcmd](https://github.com/CM2Walki/steamcmd)
