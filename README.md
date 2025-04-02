# SVP-on-Fedora

This project contains shell scripts to install SVP (SmoothVideo Project) and SMPlayer and if wanted, Jellyfin Media Player on Fedora-based distributions with SVP-support. They will not work on Debian-based, Arch-based or other operating systems.

The scripts were last tested by me on March 31st 2025 on a fresh install on Nobara (Fedora-based distribution).

## What the scripts do?

There are currently two shell scripts:

* SVP_Fedora_Install_Script_version.sh
* JMP_mpvconf_Script_version.sh

`SVP_Fedora_Install_Script_version.sh` installs SVP and all of its dependencies as well as mpv. It also asks you if you want to install Jellyfin Media Player.
<ins>You need to follow the instructions in the script carefully!</ins>

`JMP_mpvconf_Script_version.sh` is only needed if you decided to install Jellyfin Media Player with the first script. It will copy a needed configuration file for mpv.

## How to use?

1. Extract the files into your `Downloads` directory `(/home/_yourUsername_/Downloads)`
2. Make the shell script `SVP_Fedora_Install_Script_version.sh` runnable as a program. Please make sure to include the version number of your current file!
3. Open a terminal in the `Downloads` directory
4. Run the following command with sudo-privileges `sudo ./SVP_Fedora_Install_Script_version.sh` - Please make sure to include the version number of your current file! Pay attention to what the script asks you to do!
5. The script will ask you to install the SVP executable manually which will be downloaded in your `Downloads` directory. It is called `svp4-linux-64.run`. Just install it by double clicking it without changing any configuration and ***uncheck*** the box when it asks if you want to start SVP right away.
6. The script will continue in the background. Follow the other steps carefully while running the script until it has finished and exited.

### Optional

If you decided to install the Jellyfin Media Player and the prior steps have successfully completed and the shell script exited successfully, continue these steps:

7. Start Jellyfin Media Player
8. Login to your instance until you are at your home screen and can see your library.
9. Close Jellyfin Media Player
10. Make the shell script `JMP_mpvconf_Script_version.sh` runnable as a program. Please make sure to include the version number of your current file!
11. Open a terminal in the `Downloads` directory
12. Run the following command `./JMP_mpvconf_Script_version.sh` - Please make sure to include the version number of your current file! Sudo privileges are not required.

***That is all! You should be able to watch your content in Jellyfin Media Player and SMPlayer if you decided to install it with SVP enabled once SVP is running in the background.***

## Troubleshooting

As I do not have the capacity to test on more distributions and I am not as talented in coding, pull requests and posting issues are highly appreciated! Please post your potential improvements! Thank you!

## Changelog

***Version 1:***

* Initial release

## License

GNU General Public License v3.0 or later.

See [LICENSE](/LICENSE) to see the full text.



