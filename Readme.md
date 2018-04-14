**NOTE!** This script is currently incompatible with the current OpenRA & OpenRA/ra2 releases --- 14th April 2018

------------------

Welcoming you to Texas...

Receiving thoughts...

[![OpenRA/RA2](https://img.youtube.com/vi/QrL8m48TePY/mqdefault.jpg)](http://www.youtube.com/watch?v=QrL8m48TePY) [![OpenRA/RA2](https://img.youtube.com/vi/RgJyFMpCA7M/mqdefault.jpg)](http://www.youtube.com/watch?v=RgJyFMpCA7M)

Introduction
==============

**What is this all about?**

This Github repository provides a bunch of scripts for installing Tiberian Sun & RA2 on [OpenRA](http://www.openra.net/ "OpenRA homepage"), an open source implementation of classic Westwood RTS games. Additionally, you can install Dune 2, too.

Tiberian Sun & Red Alert 2 are still officially "unfinished titles" in OpenRA, and thus not yet provided by official OpenRA sites as an easy download option. Their current gameplay status is considered as "pre-alpha", "not ready" or "only accessible to OpenRA developers".

Still, a lot of people want to play or try Tiberian Sun & Red Alert 2 mods in OpenRA. It is possible. As automatic steps to achieve this goal are not yet officially provided by OpenRA development team, this Github repository was created.

Manual installation from source code suggested by the official OpenRA wiki is a major roadblock for many players. This repository is here to help on the installation process as much as possible by automating the process. No step-by-step wiki instructions or any understanding about compilation processes needed at all.

**Sounds cool! How to use it?**

1. [Download the script](https://github.com/Fincer/openra-tibsunra2/archive/master.zip)
2. Unzip the contents on your computer
3. Check [Installation instructions](https://github.com/Fincer/openra-tibsunra2#installation-instructions)
4. Then just launch the script, follow instructions, take a cup of coffee or whatever and wait for compiled game. 
5. Click and play

Sounds good? Yes. Works? Likely.

P.S. FAQ about the script [at the bottom of this page](https://github.com/Fincer/openra-tibsunra2/#faq).

**NOTE:** As the development of OpenRA & Red Alert 2 continues, this script will likely become unusable or needless some day. For example, if RA2 gets merged into official OpenRA Github repository OR/AND disabling RA2/TS gameplay will be removed from OpenRA.

**Operating Systems**
--------------
![alt text](https://i.ytimg.com/vi/5AjReRMoG3Y/default.jpg "Operating Systems")

OS specific script working status listed below.

**Last update:** 15th November 2016

**Works.** The following operating systems are currently supported:

- Windows 10
- Windows 7
- Ubuntu (16.10, 16.04 LTS, 15.04 LTS)
- Linux Mint (18, 17.3, 17.2)
- Debian (8.3.0)
- OpenSUSE (Tumbleweed, 42.1, 13.2)
- Fedora (24, 23, 22)
- Arch Linux

**May work.** Expect missing dependencies (see NOTE below):

- Ubuntu (15.10, 14.10, 14.04 LTS)
- Linux Mint (17.1)

**Doesn't work.** Missing dependencies (see NOTE below):

- Linux Mint (16)
- OpenSUSE (13.1)

**NOTE:** As package manager updates have been dropped from some old Linux operating systems, not all required packages to compile OpenRA may be available via internet anymore. However, if you have dependencies already installed on your system, the game may compile as expected (unless these packages are too old?). Optionally, you may be able to get missing dependencies from internet sources but get ready to spend hours for solving dependency hell issues & possible corrupted database headache.

**Installation instructions**
--------------

**Windows**

1) Make sure you have .NET Framework 4.5 installed on your computer
(Read *WINDOWS-BEFORE-INSTALLATION.txt* if needed)

2) Double click *windows-install.bat*

3) Follow the instructions

**Linux (All distributions)**

1) Open terminal window. In terminal, run:

```
bash linux-install.sh
```

2) Follow the instructions

**Tiberian Sun & Red Alert 2 - Post-installation instructions**
--------------

**Tiberian Sun**

![alt text](https://i.ytimg.com/vi/R8U0kPfAWp8/default.jpg "Tiberian Sun")

Launch the game and download the required asset files from the web when the game asks you to do so.

**Red Alert 2**

![alt text](https://i.ytimg.com/vi/ENyxseq59YQ/default.jpg "Red Alert 2")

You must install language.mix, multi.mix, ra2.mix and theme.mix into 

```
\My Documents\OpenRA\Content\ra2\ (Windows)
```

```
.openra/Content/ra2/ (linux)
```

You find these files from original RA2 installation media (CD's):

- theme.mix, multi.mix = RA2 CD Root folder
- ra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)

**OPTIONAL: Dune 2 - Post-installation instructions**
--------------

**NOTE:** Dune 2 must have been selected during the installation process in order to play it!

![alt text](https://img.youtube.com/vi/tppjzT-su0Q/default.jpg "Dune 2")

1) Launch the game

2) Select D2k

3) Click "Manage Content"

4) Click "Download" (in the "Base Game Files" row)

5) Click Back

6) Close the game

7) Get the following files from D2k
- DUNE.PAK
- VOC.PAK
- ATRE.PAK
- HARK.PAK
- ORDOS.PAK
- INTRO.PAK
- FINALE.PAK

OS specific folder paths:

```
\My Documents\OpenRA\Content\d2k\ (Windows)
```

```
.openra/Content/d2k/ (linux)
```

8) Put the files into

```
\My Documents\OpenRA\Content\d2\ (Windows)
```

```
.openra/Content/d2/ (linux)
```

9) Re-launch the game, select Dune 2 and click "Play"

**Multiplayer**

It's recommended to build OpenRA using exactly same GIT source files for multiplayer usage to minimize possible version differences/conflicts between players. Please make sure all players have exactly same git versions of their in-game mods (RA, CNC, D2, D2K, TS, RA2). Version numbers are formatted like 'git-e0d7445' etc. and can be found in each mod description in the mod selection menu.

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

**About patches & hotfixes**
--------------

**Patches**

Patches are files that are being used for patching the main game (OpenRA) so that it compiles successfully with Tiberian Sun & Red Alert 2 (& Dune 2) added. 

Basically, Red Alert 2 & Dune 2 locate in a different Github repositories so patches are needed in order to merge them successfully with the OpenRA codebase. Additionally, some minor patch codes have been added for compilation of Tiberian Sun.

Patches do not affect any bugs or features existing in the game.

```
Location: /data/patches/
```

Usage: add new patch file into the /data/patches/linux/ directory (Linux) or \data\patches\windows\ (Windows)

**Hotfixes**

Hotfixes are considered as patches as well (yes, they are patch files, too). The main difference between patches and hotfixes is that hotfixes are meant to be used to fix bugs or add features in the game codebase whereas patches just make OpenRA compilation process with Tiberian Sun & Red Alert 2 (& Dune 2) possible. 

Hotfixes are unofficial in nature. They've not officially been applied by OpenRA developers or any other party and thus playing the game with them may make your version of openra-tibsunra2 incompatible with the official 'openra-bleed' and RA2/D2 mods, even if git version numbers match with other players you see in the lobby.

Hotfixes can be used with other players. However, the hotfixes must have been applied into openra-tibsunra2 versions of any players you want to play with (not forgetting compatibility of git version numbers).

Hotfixes are optional and they've been disabled by default.

```
Location: /data/hotfixes/
```

Usage: add new hotfix patch file into the /data/hotfixes/linux/ directory (Linux) or \data\hotfixes\windows\ (Windows)

**Why are Windows & Linux separated (patches/hotfixes)?**

The main reason for this is because Windows & Linux use different line endings in patch files. Different end of lines may make patch files incompatible in various OSes so consider this more or less as a precaution.

**How do I create new hotfixes?**

You need a Unix tool 'diff' to create new hotfixes (patch files). For additional information, please see, for example, 

[Apply patch file using patch command - Cyberciti.biz](http://www.cyberciti.biz/faq/appy-patch-file-using-patch-command/)

Remember to check "end of line" (Windows or Unix) for every hotfix patch file you create.

**FAQ**
--------------
![alt text](https://i.ytimg.com/vi/fnd0qg4I_MM/mqdefault.jpg "Mr. President, I'm afraid we have a heck of a situation down here...")

Mr. President, I'm afraid we have a heck of a situation down here...

*-General Ben Carville*

**Missing support for my OS, please help!**

Consider contributing the script development. It's not too hard if you have enough motivation and spare time. The question is, have you?

**Windows OSes:** The script should work on Win 7/10. If it doesn't, consider filling a new issue [here](https://github.com/Fincer/openra-tibsunra2/issues).
- The script is based on: Powershell + Command Prompt + GNU Patch utility

**Mac OS X:** The most requested OS support feature. Regardless of countless requests, the support is not available yet. The demand for Mac OS X script is a known issue.
- No additional information available

**Linux OSes:** The script should work on Linux OSes [listed above](https://github.com/Fincer/openra-tibsunra2/#operating-systems). If it doesn't, consider filling a new issue [here](https://github.com/Fincer/openra-tibsunra2/issues). If you consider adding support for a new Linux distribution, you likely want to know that main differences in the script between various linux distributions are as follows:
- Variety of dependency package names in OS repositories
- Specific package manager commands
- The script is based on: Bash + basic Linux commands (found on many distributions by default)

**FreeBSD:** No support available, and not planned. Consider contributing the script development, if you feel you want a script for FreeBSD.
- No additional information available

**You provide outdated/wrong information here!**

Please open a new issue on Github repository page:

[Issues - Fincer/openra-tibsunra2 script](https://github.com/Fincer/openra-tibsunra2/issues "Script issues")

**The script doesn't work! This sucks, you suck!**

On script related errors, please open a new issue on Github repository page:

[Issues - Fincer/openra-tibsunra2 script](https://github.com/Fincer/openra-tibsunra2/issues "Script issues")

If you are 100% sure the failure you've encountered is not caused by the script but happens even if OpenRA is manually compiled, please open a new issue or look for an existing one here:

[Issues - OpenRA: main game](https://github.com/OpenRA/OpenRA/issues "OpenRA main game issues")

or

[Issues - Red Alert 2: OpenRA mod](https://github.com/OpenRA/ra2/issues "OpenRA RA2 mod issues")

**NOTE:** If you don't open a new issue or decide to be silent, the error may never be fixed. Errors rarely get fixed by being passive or just hoping them to be suddenly fixed by a miracle. I may not even know the issue you have. You've been informed and warned.

**I demand you to add or fix feature X! I surely won't do it but you will because I say so!**

First at all, as this repository is open source in nature, no one gets paid $$$ by making a new script or improving the existing one. Thus you can hardly demand contributors to do something about any issues unless they have will to fix or create things for you. You can't force people to spend their spare time for your requests unless they themselves decide to do so. Money is a good motivator for people, but the concept of money doesn't exist here.

Welcome to the world of open source software where things move forward slowly if at all. Sometimes the development stops even completely and codes get abandoned for eternity. The question is, do you have time or patience for this all?

If you lose your patience and if you have motivation to improve things here, please consider contributing the script development. That's the most certain way you get the things done as you want, though you may need to learn a lot of new stuff yourself and get some headache as well.

**Is this an official Github site by OpenRA developers?**

No, absolutely not. Don't even think it is. You won't get any official support for your OpenRA related issues here. 

All official OpenRA Github pages are located at https://github.com/OpenRA/ + there are OpenRA Github fork pages by some OpenRA developers.

**Tiberian Sun & Red Alert 2 gameplay is buggy as hell!**

This is not anyone's fault. OpenRA, as the name suggests, is an open source project done by volunteers at their will. Especially, Tiberian Sun & Red Alert 2 titles in OpenRA are known to still miss critical features existing in the original Westwood games. For example, you shouldn't expect for playable TS/RA2 missions until these features have been implemented. And yes, it can take time - a lot of it.

OpenRA is an ambitious project trying to bring all Westwood classic RTS's as modernized versions to PC platforms as free. The project demands time, improvising, tweaking the code and very well organized project management which has its priorities. Many issues are found in [OpenRA/OpenRA](https://github.com/OpenRA/OpenRA/issues) and [OpenRA/ra2](https://github.com/OpenRA/ra2/issues) Github repositories, but the question is, how many active developers are there around to address these issues, especially when we're talking about an open source project? To ask why TS or RA2 are still in development, let me put it simple: less developers -> less workforce -> more prioritizing -> delays in schedule. This may not be the case in OpenRA but, generally speaking, it likely can be.

If you feel you want and are able to speed up the development process of OpenRA or TS/RA2, please consider contacting OpenRA development team (read: I'm not the one you should contact) or contributing the OpenRA project otherwise. You can help the team with coding or adding gameplay features or anything that is important and is considered as important to the project by the OpenRA developers.

The minimal effort you can help the OpenRA main project with is checking/fixing existing Github issues (see links above) or filling a new one in demand.

**I have suggestions for OpenRA or TS/RA2. Where and whom should I address them to?**

Depending on the game you're talking about, use OpenRA Github pages listed below.

- For C&C Tiberian Dawn, Red Alert 1, Dune 2000 and Tiberian Sun, fill your request (issue) here:

[Issues - OpenRA: main game](https://github.com/OpenRA/OpenRA/issues "OpenRA main game issues")

- For Red Alert 2, fill your request (issue) here:

[Issues - Red Alert 2: OpenRA mod](https://github.com/OpenRA/ra2/issues "OpenRA RA2 mod issues")

Please use consideration when opening new issues, and don't forget to double check if your issue already exists there.

**How's it going with Tiberian Sun development?**

You can check the current development status, for example, [here](https://github.com/OpenRA/OpenRA/issues/7874 "Add TS features required for a full remake - OpenRA/OpenRA"). Take the page as a general reference, not as a sacred text.

**Where is Yuri's Revenge support??**

According to [GraionDilach](https://github.com/GraionDilach) (OpenRA developer), the Yuri's Revenge support in OpenRA has been discussed but no one hasn't started the development process yet. According to him, the Yuri's Revenge would be treated as a separate Github project, or as additional/extra title to OpenRA main project, just like RA2 now.

*It has also been discussed IIRC that this repository will strictly go RA2 and whoever starts YR will do it in another repo. But YR itself isn't that hard, the TS and RA2 dependencies will be the problem.*

Full comment [here](https://github.com/OpenRA/ra2/issues/309#issuecomment-257545830)

If you feel you'd like to start the Yuri's Revenge project today, please feel free to do so. At least, the support for it will likely be added to this installation script and be praised by members of CnC community.

**Good OpenRA websites to check at**

Project sites:
- [OpenRA homepage](www.openra.net)
- [OpenRA Github project page](https://github.com/OpenRA/OpenRA)
- [OpenRA Red Alert 2 Github project page](https://github.com/OpenRA/ra2)
- [OpenRA Dune 2 Github project page](https://github.com/OpenRA/d2)

Social media/Community sites:
- [OpenRA Youtube channel](https://www.youtube.com/channel/UCRoiPL1J4K1-EhQeNazrYig)
- [OpenRA Reddit site](https://www.reddit.com/r/openra/)
- [OpenRA Facebook site](https://www.facebook.com/openra/)
- [OpenRA Steam Community site](https://steamcommunity.com/groups/openra/)
- [OpenRA - PPM Forums](http://www.ppmforums.com/index.php?f=929)
- [OpenRA - Sleipnir's Stuff forums](http://www.sleipnirstuff.com/forum/viewforum.php?f=80)

Other:
- [OpenRA Resource Center](http://resource.openra.net/)
- [OpenRA Mod Database (ModDB) site](http://www.moddb.com/games/openra)
- [OpenRA Wiki page](https://github.com/OpenRA/OpenRA/wiki)
- [OpenRA Red Alert 2 Wiki page](https://github.com/OpenRA/ra2/wiki)
