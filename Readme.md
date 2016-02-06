Introduction
==============

This Github repository provides a bunch of scripts for installing TS/RA2 on OpenRA.

The following operating systems are currently supported:

- Windows 7
- Ubuntu (14.04 LTS, 14.10, 15.04 LTS, 15.10 & 16.04 LTS)
- Linux Mint
- Arch Linux

A lot of people are willing to play Tiberian Sun and Red Alert 2 mods in OpenRA, no matter if they're at unfinished state or not. Personally, I feel the official OpenRA wiki may be really hard to understand for novice people who just want to play these titles and show little interest in cryptic compilation processes.

That's why, as not official support is not provided yet, I decided to do something about this TS/RA2 issue/dilemma: I made a bunch of scripts and instructions that should make life for an average user a bit easier and help installation of these two awesome titles (TS/RA2) on OpenRA.

**Installation instructions**
--------------

**Windows**

1) Make sure you have .NET Framework 4.5 installed on your computer
( Read *BEFORE-INSTALLATION.txt* for further information)

2) Double click *install.bat*
3) Follow the instructions

**Ubuntu & Ubuntu Variants (Linux Mint, Lubuntu, Xubuntu, Kubuntu etc.)**

1) Double click install.sh and select "Run in terminal". A new terminal window opens. Type

```
bash install.sh
```

2) Follow the instructions

**Arch Linux**

1) Open terminal
2) Navigate to the folder where you have openra-bleed-tibsunra2.install, tibsun_ra2.patch & PKGBUILD
3) Run the following commands:

```
updpkgsums
makepkg
```

You may need to install missing dependencies at this point.

4) Install OpenRA by typing

```
sudo pacman -U openra-bleed-tibsunra2-r*.tar.xz
```

5) Once the game is installed, please follow the instructions about how to install Red Alert 2 mix files, given in the end of the installation process.
6) Play the game by typing 'openra' in terminal or using a desktop file.

**Post-installation instructions**
--------------

**To play Tiberian Sun**

Launch the game and download the required asset files from the web when the game asks you to do so.

**To play Red Alert 2**

You must install language.mix, multi.mix, ra2.mix and theme.mix into '$HOME/.openra/Content/ra2/' folder. You find these files from original RA2 installation media (CD's):

- theme.mix, multi.mix = RA2 CD Root folder
- ra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)

**Multiplayer**

It's recommended to use exactly same OpenRA binary for multiplayer usage to minimize possible version differences/conflicts between players. If your friends compiles this package with another operating system, please make sure they use exactly same source files for their OpenRA compilation process.

**Uninstallation**
--------------

For uninstallation, please see specific instructions for your Operating System below.

**Windows**

Since the game has been compiled from source and no additional setup programs are provided, all you need to do is to delete the contents of 'OpenRA-bleed-tibsunra2' folder and \My Documents\OpenRA\.

**Ubuntu/Linux Mint**

If you want to remove OpenRA, just run 'sudo apt-get purge --remove openra-bleed-tibsunra2' (without quotations) in your terminal window.

**Arch Linux**

Run 'sudo pacman -Rs openra-bleed-tibsunra2' (without quotations) in your terminal window. 
