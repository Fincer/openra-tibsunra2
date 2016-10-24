Introduction
==============

This Github repository provides a bunch of scripts for installing TS/RA2 on OpenRA.

The following operating systems are currently supported:

- Windows 10
- Windows 7
- Ubuntu (16.04 LTS, 15.10, 15.04 LTS, 14.10, 14.04 LTS)
- Linux Mint (17.3, 17.2 & 17.1)
- Debian (8.3.0)
- OpenSUSE (Tumbleweed, 42.1, 13.2)
- Fedora (23, 22)
- Arch Linux

A lot of people are willing to play Tiberian Sun and Red Alert 2 mods in OpenRA, no matter if they're at unfinished state or not. Personally, I feel the official OpenRA wiki may be really hard to understand for novice people who just want to play these titles and show little interest in cryptic compilation processes.

That's why, as not official support is not provided yet, I decided to do something about this TS/RA2 issue/dilemma: I made a bunch of scripts and instructions that should make life for an average user a bit easier and help installation of these two awesome titles (TS/RA2) on OpenRA.

**NOTE:** As the development of OpenRA & Red Alert 2 continues, this script will likely become unusable some day.

**Installation instructions**
--------------

**Windows**

1) Make sure you have .NET Framework 4.5 installed on your computer
(Read *WINDOWS-BEFORE-INSTALLATION.txt* for further information)

2) Double click *windows-install.bat*

3) Follow the instructions

**Linux (All distributions)**

1) Open terminal window. In terminal, run:

```
bash linux-install.sh
```

2) Follow the instructions

**Post-installation instructions**
--------------

**To play Tiberian Sun**

Launch the game and download the required asset files from the web when the game asks you to do so.

**To play Red Alert 2**

You must install language.mix, multi.mix, ra2.mix and theme.mix into 

\My Documents\OpenRA\Content\ra2\ (Windows)

.openra/Content/ra2/ (linux) 

You find these files from original RA2 installation media (CD's):

- theme.mix, multi.mix = RA2 CD Root folder
- ra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)

**Multiplayer**

It's recommended to build OpenRA using exactly same GIT source files for multiplayer usage to minimize possible version differences/conflicts between players. Please make sure all players have exactly same git versions of their in-game mods (RA, CNC, D2K, TS, RA2). Version numbers are formatted like 'git-e0d7445' etc. and can be found in each mod description in the mod selection menu.

**Uninstallation**
--------------

For uninstallation, please see specific instructions for your Operating System below.

**Windows**

Since the game has been compiled from source and no additional setup programs are provided, all you need to do is to delete the contents of 'OpenRA-tibsunra2-Windows' folder and \My Documents\OpenRA\.

**Ubuntu/Linux Mint/Debian**

If you want to remove OpenRA, just run

```
sudo apt-get purge --remove openra-bleed-tibsunra2
```

in your terminal window.

**OpenSUSE**

Run

```
sudo zypper remove openra-bleed-tibsunra2 
```

in your terminal window.

**Fedora**

Run

```
sudo dnf remove openra-bleed-tibsunra2 
```

in your terminal window.

**Arch Linux**

Run

```
sudo pacman -Rs openra-bleed-tibsunra2 
```

in your terminal window. 