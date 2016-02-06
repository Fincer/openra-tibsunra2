#!/bin/bash

# Allow interruption of the script at any time (Ctrl + C)
trap "exit" INT

#*********************************************************************************************************
## VARIABLES USED IN THE SCRIPT
#

# Package name & version
PACKAGE_NAME=openra-bleed-tibsunra2
PACKAGE_VERSION=1

PACKAGE=$PACKAGE_NAME-$PACKAGE_VERSION

# Find out used Linux distribution
RELEASE=$(lsb_release -d | sed 's/Description:\t//g')

# Check if the used OS is Ubuntu 14.04 LTS/14.10 or Linux Mint
RELEASE_VERSION=$(lsb_release -r | sed 's/[^0-9]*//g')
RELEASE_MINT=$(lsb_release -i 2>/dev/null |grep -c "Mint")

# Check for critical build dependencies (especially for Ubuntu 14.04 LTS/14.10 & Linux Mint)
PKG1_CHECK=$(dpkg-query -W -f='${Status}' libnuget-core-cil 2>/dev/null | grep -c "ok installed")
PKG2_CHECK=$(dpkg-query -W -f='${Status}' mono-devel 2>/dev/null | grep -c "ok installed")
PKG3_CHECK=$(dpkg-query -W -f='${Status}' nuget 2>/dev/null | grep -c "ok installed")

# Do we have any OpenRA packages on the system?
PKG4_CHECK=$(dpkg-query -W -f='${Status}' openra 2>/dev/null | grep -c "ok installed")
PKG5_CHECK=$(dpkg-query -W -f='${Status}' openra-playtest 2>/dev/null | grep -c "ok installed")
PKG6_CHECK=$(dpkg-query -W -f='${Status}' openra-bleed 2>/dev/null | grep -c "ok installed")

# Check for missing RA2 directories.
RA2_MISSINGDIR1="$HOME/openra-master/$PACKAGE/mods/ra2/bits/vehicles"
RA2_MISSINGDIR2="$HOME/openra-master/$PACKAGE/mods/ra2/bits/themes"

# Check if we already have sudo password in memory (timeout/timestamp check)
SUDO_CHECK=$(sudo -n uptime 2>&1|grep "load"|wc -l)

BASH_CHECK=$(ps | grep `echo $$` | awk '{ print $4 }')

bold_in='\e[1m'
line_in='\e[4m'
dim_in='\e[2m'

green_in='\e[32m'
red_in='\e[91m'

out='\e[0m'

#*********************************************************************************************************
## PRE-CHECK
#

# Check if we're using bash or sh to run the script. If bash, OK. If sh, ask user to run the script with bash.

if [ ! $BASH_CHECK = "bash" ]; then
	echo  "\nPlease run this script using bash (/usr/bin/bash).\n"
	exit 1
fi

# Check if we are root or not. If yes, then terminate the script.

if [[ $UID = 0 ]]; then
	echo -e "\nPlease run this script as a regular user. Do not use root or sudo. Some commands used in the script require regular user permissions.\n"
	exit 1
fi

#If package dir exists already, delete it.

if [ -d "$HOME/openra-master/" ]; then
	rm -rf "$HOME/openra-master"
fi

#If deb package exists already, delete it.

if [ -f $HOME/$PACKAGE_NAME*.deb ]; then
	rm -f $HOME/$PACKAGE_NAME*.deb
fi

# Stop execution if we encounter an error
set -e

#*********************************************************************************************************
## PART 1/7
#
## Installation of OpenRA compilation dependencies and user notification message

echo -e "\n$bold_in***Welcome Comrade*** $out\n" 
echo -e "This script compiles and installs OpenRA from source with Tiberian Sun & Red Alert 2.\n
- The script is NOT made by official developers of OpenRA and may contain bugs.
- The script works only on Ubuntu, Linux Mint and similar Linux distributions. It creates a deb installation package using OpenRA source code and additional Red Alert 2 mod files from Github.\n\nNOTE: As the development of OpenRA & Red Alert 2 continues, this script will likely become unusable some day. Please, feel free to modify it if necessary."
echo -e "$line_in\nThe script has been tested on:\n\nDistribution\t\tStatus$out\nUbuntu 16.04 LTS$green_in\tOK$out\nUbuntu 15.10$green_in\t\tOK$out\nUbuntu 15.04 LTS$green_in\tOK$out\nUbuntu 14.10$green_in\t\tOK$out\nUbuntu 14.04 LTS$green_in\tOK$out\nLinux Mint 17.3$green_in\t\tOK$out\nLinux Mint 17.2$green_in\t\tOK$out\nLinux Mint 17.1$green_in\t\tOK$out\nLinux Mint 16$red_in\t\tFailure$out$dim_in (can't find required packages)$out\n"

echo -e "You are using $RELEASE.\n"
read -r -p "Do you want to continue? [y/N] " response

if [[ $response =~ ^([yY][eE][sS]|[yY])$ ]]; then
	sleep 1

	echo -e "\nAllright, let's continue. Do you want $bold_in\n\n1.$out manually check which OpenRA build dependencies (packages) will be installed on your system? $dim_in(manual apt-get + deb packages installation)$bold_in\n2.$out automatically accept the installation of the OpenRA build dependencies during the script execution? $dim_in(apt-get with -y option + automatic .deb packages installation)$out\n"
	read -r -p "Please type 1 or 2: " number
	sleep 1	
	if [[ $number -eq 1 ]]; then
		METHOD=''
		echo -e "\nSelected installation method:$bold_in Manual$out"
	else
		METHOD=-y
		echo -e "\nSelected installation method:$bold_in Automatic$out"
	fi

	if [ $SUDO_CHECK -eq 0 ]; then
		if [ -z $METHOD ]; then
			echo -e "\nOpenRA compilation requires that you install some packages first. Your permission for installation is asked (yes/no) everytime it's needed. This script asks for a required root password now, so you don't have to type it multiple times later on while the script is running.\n\nPlease type sudo/root password now.\n" 
		else
			echo -e "\nOpenRA compilation requires that you install some packages first. This script asks for a required root password now, so you don't have to type it multiple times later on while the script is running.\n\nPlease type sudo/root password now.\n"
		fi
		sudo echo -e "\nRoot password OK."
		sleep 1
	else
		true
	fi

## Check if the user is running Ubuntu 14.04 LTS/14.10 or Linux Mint and whether required nuget packages are installed if these Linux versions are being used.

	if [  $RELEASE_VERSION == 1404 ] || [ $RELEASE_VERSION == 1410 ] || [ $RELEASE_MINT -eq 1 ] ; then
		echo -e "\nYou are running Ubuntu 14.04 LTS/14.10 or Linux Mint. We need to check if you have required NuGet packages installed.\nThese packages are not (longer available) from the official repository but they are provided by this package.\n"
		read -r -p "Press ENTER to proceed." enter
		if [ ${#enter} -eq 0 ]; then
			echo -e "$line_in\nChecking NuGet packages$out"
		fi
#-----------------------------------------------------------------------------------------------------------------------------------------------------------
## Check existence of 'nuget', 'libnuget-core-lib' & 'mono-devel' packages on Ubuntu 14.04 LTS/14.10/Linux Mint based system. 

			if [ $PKG2_CHECK -eq 1 ]; then
				echo -e "$green_in\nOK$out - 'mono-devel' found."
			else
				echo -e "$red_in\nWARNING$out - 'mono-devel' not found."
			fi

			if [ $PKG1_CHECK -eq 1 ]; then
				echo -e "$green_in\nOK$out - 'libnuget-core-cil' found."
			else
				echo -e "$red_in\nWARNING$out - 'libnuget-core-cil' not found."
			fi

			if [ $PKG3_CHECK -eq 1 ]; then
				echo -e "$green_in\nOK$out - 'nuget' found."
			else
				echo -e "$red_in\nWARNING$out - 'nuget' not found."
			fi

			if [ ! $PKG2_CHECK -eq 1 ]; then
				echo -e "$red_in\nWARNING$out - NuGet requires 'mono-devel' package which was not found.\n\nInstalling 'mono-devel' now."
				sleep 5
				echo -e "\nUpdating package lists with APT.\n"
				sleep 2
				sudo apt-get update && \
				sudo apt-get $METHOD install mono-devel
			fi

			if [ ! $PKG1_CHECK -eq 1 ]; then
				if [ $number = 1 ]; then
					echo
					read -r -p "Install 'libnuget-core-cil' now? [y/N] " response2
						if [[ $response2 =~ ^([yY][eE][sS]|[yY])$ ]]; then
							sudo dpkg -i ./nuget-14.04-14.10/libnuget-core-cil_2.8.5+md59+dhx1-1~getdeb1_all.deb
						else
							echo -e "\nOpenRA installation can't continue. Aborting.\n"
							exit 1
						fi
				else
					sudo dpkg -i ./nuget-14.04-14.10/libnuget-core-cil_2.8.5+md59+dhx1-1~getdeb1_all.deb
				fi
			fi

			PKG1_RECHECK=$(dpkg-query -W -f='${Status}' libnuget-core-cil 2>/dev/null | grep -c "ok installed")

			if [ ! $PKG3_CHECK -eq 1 ]; then
				if [ $number = 1 ]; then
					echo
					read -r -p "Install 'nuget' now? [y/N] " response3
						if [[ $response3 =~ ^([yY][eE][sS]|[yY])$ ]]; then
							sudo dpkg -i ./nuget-14.04-14.10/nuget_2.8.5+md59+dhx1-1~getdeb1_all.deb
						else
							echo -e "\nOpenRA installation can't continue. Aborting.\n"
							exit 1
						fi
				else
					sudo dpkg -i ./nuget-14.04-14.10/nuget_2.8.5+md59+dhx1-1~getdeb1_all.deb
				fi
			fi

			PKG3_RECHECK=$(dpkg-query -W -f='${Status}' nuget 2>/dev/null | grep -c "ok installed")

			if [ $PKG1_RECHECK -eq 1 ] && [ $PKG3_RECHECK -eq 1 ]; then
				echo -e "$green_in\nOK$out - All required NuGet packages are installed."
			else
				echo -e "$red_in\nWARNING$out - Can't find all required NuGet packages. Aborting.\n"
				exit 1
			fi
	else
		true
	fi
	sleep 2
#-----------------------------------------------------------------------------------------------------------------------------------------------------------

	echo -e "$bold_in\n1/7 ***OpenRA build dependencies***\n$out"
	sleep 2
	echo -e "Updating package lists with APT.\n"
	sleep 2
	sudo apt-get update
	echo -e "\nInstalling required OpenRA build dependencies.\n"
	sleep 4
	sudo apt-get $METHOD install git dpkg-dev dh-make sed mono-devel libfreetype6-dev libopenal-data libopenal1 libsdl2-2.0-0 nuget curl liblua5.1-0-dev zenity xdg-utils build-essential gcc make libfile-fcntllock-perl
	mozroots --import --sync && \
	sudo apt-key update

#*********************************************************************************************************
## PART 2/7
#
## Download the latest OpenRA & Red Alert 2 source files from Github, create build directories to the user's home directory. 
## Once Red Alert 2 source files have been downloaded, move them to the OpenRA parent source directory. 
## Add several missing directories for Red Alert 2.

	echo -e "$bold_in\n2/7 ***Downloading OpenRA source code & Red Alert 2 mod files from Github***\n$out"
	sleep 2
	echo -e "Part 1 (OpenRA source code):\n"

	mkdir -p $HOME/openra-master/{$PACKAGE,ra2} && \
	git clone -b bleed https://github.com/OpenRA/OpenRA.git $HOME/openra-master/$PACKAGE

	echo -e "\nPart 2 (Red Alert 2 mod files):\n"

	git clone -b master https://github.com/OpenRA/ra2.git $HOME/openra-master/ra2 && \
	mv $HOME/openra-master/ra2/OpenRA.Mods.RA2 $HOME/openra-master/$PACKAGE && \
	mv $HOME/openra-master/ra2 $HOME/openra-master/$PACKAGE/mods/

	if [ ! -d "$RA2_MISSINGDIR1" ]; then
		mkdir "$RA2_MISSINGDIR1"
	fi

	if [ ! -d "$RA2_MISSINGDIR2" ]; then
		mkdir "$RA2_MISSINGDIR2"
	fi

	cp ./patches/{tibsun_ra2.patch,makefile-mcs.patch,ra2-csproj.patch} $HOME/openra-master/

#*********************************************************************************************************
## PART 3/7
#
## Patch several OpenRA source files (Makefile and such) for Tiberian Sun & Red Alert 2

	echo -e "$bold_in\n3/7 ***Preparing OpenRA source files for Tiberian Sun & Red Alert 2***\n$out"
	sleep 2
	patch -d $HOME/openra-master/$PACKAGE -Np1 -i $HOME/openra-master/makefile-mcs.patch
	patch -d $HOME/openra-master/$PACKAGE -Np1 -i $HOME/openra-master/tibsun_ra2.patch
	patch -d $HOME/openra-master/$PACKAGE -Np1 -i $HOME/openra-master/ra2-csproj.patch

#*********************************************************************************************************
## PART 4/7
#
## Compile the game

	echo -e "$bold_in\n4/7 ***Starting OpenRA compilation with Tiberian Sun & Red Alert 2***\n$out"
	sleep 2
	cd $HOME/openra-master/$PACKAGE && \
	make version && \
	make dependencies && \
	make all [DEBUG=false]

	echo -e "$bold_in\n5/7 ***Preparing OpenRA deb package. This takes a while. Please wait.***\n$out"
	dh_make --createorig -s -y && \
	echo -e "\noverride_dh_auto_install:\n\tmake install-all install-linux-shortcuts prefix='$HOME/openra-master/$PACKAGE/debian/$PACKAGE_NAME/usr'\n\tsed -i '2s%.*%cd /usr/lib/openra%' '$HOME/openra-master/$PACKAGE/debian/$PACKAGE_NAME/usr/bin/openra'\noverride_dh_usrlocal:\noverride_dh_auto_test:" >> $HOME/openra-master/$PACKAGE/debian/rules && \
	sed -i 's/Depends: ${shlibs:Depends}, ${misc:Depends}/Depends: libopenal1, mono-runtime (>= 2.10), libmono-system-core4.0-cil, libmono-system-drawing4.0-cil, libmono-system-data4.0-cil, libmono-system-numerics4.0-cil, libmono-system-runtime-serialization4.0-cil, libmono-system-xml-linq4.0-cil, libfreetype6, libc6, libasound2, libgl1-mesa-glx, libgl1-mesa-dri, xdg-utils, zenity, libsdl2 | libsdl2-2.0-0, liblua5.1-0/g' $HOME/openra-master/$PACKAGE/debian/control && \
	sed -i 's/<insert up to 60 chars description>/A multiplayer re-envisioning of early RTS games by Westwood Studios\nConflicts: openra, openra-playtest, openra-bleed/g' $HOME/openra-master/$PACKAGE/debian/control && \
	sed -i 's/ <insert long description, indented with spaces>/ ./g' $HOME/openra-master/$PACKAGE/debian/control && \
	dpkg-buildpackage -rfakeroot -b -nc -uc -us

#*********************************************************************************************************
## PART 6/7
#
## Remove temporary OpenRA build files & directories

	echo -e "$bold_in\n6/7 ***Compilation process completed. Moving compiled deb package into '$HOME'***\n$out"
	sleep 2
	mv $HOME/openra-master/$PACKAGE_NAME*.deb $HOME
	echo -e "Removing temporary files."
	rm -rf $HOME/openra-master

#*********************************************************************************************************
## PART 7/7
#
## Install OpenRA

	echo -e "$bold_in\n7/7 ***Starting OpenRA installation process***\n$out"
	sleep 2
	if [ $PKG4_CHECK -eq 1 ] || [ $PKG5_CHECK -eq 1 ] || [ $PKG6_CHECK -eq 1 ] ; then
		echo -e "\nCan't install '$PACKAGE_NAME' because of conflicting packages.\nPlease remove previously installed openra package from your system and try again.\nBuilt $PACKAGE_NAME deb package can be found in '$HOME'.\n"
	else
		if [ $number = 1 ]; then
			read -r -p "Install '$PACKAGE_NAME' now? [y/N] " response4
				if [[ $response4 =~ ^([yY][eE][sS]|[yY])$ ]]; then
					sudo dpkg -i $HOME/$PACKAGE_NAME*.deb
				else
					echo -e "\nPlease install '$PACKAGE_NAME' manually. You find the compiled package at '$HOME'."
					sleep 2
		 		fi
		else
			sudo dpkg -i $HOME/$PACKAGE_NAME*.deb
		fi
	fi

#*********************************************************************************************************
## ADDITIONAL INFORMATION
#
## Messages

	echo -e  "\n***OpenRA installation script completed.\nPlease see further instructions below.***"
	sleep 4
	echo -e "$bold_in\n***TIBERIAN SUN & RED ALERT 2 - HOWTO***$out\n\nTO PLAY TIBERIAN SUN: Launch the game and download the required asset files from the web when the game asks you to do so.\n\nTO PLAY RED ALERT 2: You must install language.mix, multi.mix, ra2.mix and theme.mix into '$HOME/.openra/Content/ra2/' folder. You find these files from original RA2 installation media (CD's):\n\n-theme.mix, multi.mix = RA2 CD Root folder\n-ra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)$bold_in\n\n***LAUNCHING OPENRA***$out\n\nTo launch OpenRA, simply type 'openra' (without quotations) in your terminal or use a desktop shortcut file.$bold_in\n\n***UNINSTALLATION***$out\n\nIf you want to remove OpenRA, just type 'sudo apt-get purge --remove $PACKAGE_NAME'\n\nYou can find deb package of $PACKAGE_NAME at '$HOME' for further usage.$bold_in\n\n***MULTIPLAYER***$out\n\nIt's recommended to use exactly same deb installation package for multiplayer usage to minimize possible version differences/conflicts between players. If your friends compiles this package with another operating system, please make sure they use exactly same source files for their OpenRA compilation process.\n\nHave fun!\n"

else
	echo -e "\nAborted.\n"
fi