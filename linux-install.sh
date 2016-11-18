#!/bin/bash

##-------------------------------------------------------------
# Allow interruption of the script at any time (Ctrl + C)
trap "exit" INT

##-------------------------------------------------------------
# Check if we're using bash or sh to run the script. If bash, OK. If sh, ask user to run the script with bash.

BASH_CHECK=$(ps | grep `echo $$` | awk '{ print $4 }')

if [ ! $BASH_CHECK = "bash" ]; then
	echo  "
Please run this script using bash (/usr/bin/bash).
	"
	exit 1
fi

##-------------------------------------------------------------
# Check if we are root or not. If yes, then terminate the script.

if [[ $UID = 0 ]]; then
	echo -e "\nPlease run this script as a regular user. Do not use root or sudo. Some commands used in the script require regular user permissions.\n"
	exit 1
fi

##-------------------------------------------------------------
# Check internet connection

INTERNET_TEST=$(ping -c 3 github.com 2>&1 | grep -c "unknown host") #Ping Github three times and look for string 'unknown host'

if [[ ! $INTERNET_TEST -eq 0 ]]; then #If 'unknown host' string is found, then
	echo -e "\nCan't connect to Github. Please check your internet connection and try again.\n"
	exit 1
fi

##-------------------------------------------------------------
# Get our current directory
WORKING_DIR=$(pwd)

# Get our Linux distribution
DISTRO=$(cat /etc/os-release | sed -n '/PRETTY_NAME/p' | grep -o '".*"' | sed -e 's/"//g' -e s/'([^)]*)'/''/g -e 's/ .*//' -e 's/[ \t]*$//')

ARCH="Arch"
UBUNTU="Ubuntu"
DEBIAN="Debian"
OPENSUSE="openSUSE"
FEDORA="Fedora"

##-------------------------------------------------------------
#Post-installation instructions

bold_in='\e[1m'
dim_in='\e[2m'
green_in='\e[32m'
out='\e[0m'
PACKAGEMANAGER_INSTALL=1
PACKAGEMANAGER_REMOVE=1
PACKAGE_NAME=1
INSTALL_NAME=1

function endtext_fail() {
echo -e "\nWhoops! Something went wrong. Please check possible error messages above.\n"
}

function endtext_ok() {
OPENRA_GITVERSION=git-$(git ls-remote https://github.com/OpenRA/OpenRA.git | head -1 | sed "s/HEAD//" | sed 's/^\(.\{7\}\).*/\1/')
RA2_GITVERSION=git-$(git ls-remote https://github.com/OpenRA/ra2.git | head -1 | sed "s/HEAD//" | sed 's/^\(.\{7\}\).*/\1/')
D2_GITVERSION=git-$(git ls-remote https://github.com/OpenRA/d2.git | head -1 | sed "s/HEAD//" | sed 's/^\(.\{7\}\).*/\1/')

echo -e  "$bold_in\n***OpenRA compilation script completed.\nPlease see further instructions below.***$out"
sleep 2
echo -e "$bold_in\n***MANUAL INSTALLATION***$out\n\nInstall OpenRA by typing '$PACKAGEMANAGER_INSTALL $WORKING_DIR/$PACKAGE_NAME' (without quotations) in a terminal window."
sleep 4
echo -e "$bold_in\n***TIBERIAN SUN & RED ALERT 2 - HOWTO***$out\n\nTO PLAY TIBERIAN SUN: Launch the game and download the required asset files from the web when the game asks you to do so.\n\nTO PLAY RED ALERT 2: You must install language.mix, multi.mix, ra2.mix and theme.mix into '$HOME/.openra/Content/ra2/' folder. You find these files from original RA2 installation media (CD's):\n\n-theme.mix, multi.mix = RA2 CD Root folder\n-ra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)\n\nTO PLAY DUNE 2 (if installed): Please see https://github.com/Fincer/openra-tibsunra2/ front page for further instructions.$bold_in\n\n***LAUNCHING OPENRA***$out\n\nTo launch OpenRA, simply type 'openra' (without quotations) in your terminal or use a desktop shortcut file.$bold_in\n\n***UNINSTALLATION***$out\n\nIf you want to remove OpenRA, just type '$PACKAGEMANAGER_REMOVE $INSTALL_NAME' (without quotations)\n\nYou can find package of $INSTALL_NAME in '$HOME' for further usage.$bold_in\n\n***MULTIPLAYER***$out\n\nIt's recommended to build OpenRA using exactly same GIT source files for multiplayer usage to minimize possible version differences/conflicts between players. Please make sure all players have exactly same git versions of their in-game mods (RA, CNC, D2, D2K, TS, RA2). Version numbers are formatted like 'git-e0d7445' etc. and can be found in each mod description in the mod selection menu.\n\nFor this compilation, the version numbers are as follows:\nOpenRA version: $OPENRA_GITVERSION\nRA2 version: $RA2_GITVERSION\nDune 2 version (if installed): $D2_GITVERSION\n\nHave fun!\n"
}

##-------------------------------------------------------------
# If we're running Arch Linux, then execute this
if [[ $DISTRO =~ "$ARCH" ]]; then

	echo -e "\n$bold_in***Welcome Comrade*** $out\n" 
	echo -e "You are about to install OpenRA with Tiberian Sun & Red Alert 2 on Arch Linux.\n"
	read -r -p "Do you want to continue? [y/N] " response
		if [[ $(echo $response | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then

			echo -e "\nAllright, let's continue. Do you want $bold_in\n\n1.$out manually install OpenRA after its compilation? $dim_in(manual pacman installation)$bold_in\n2.$out automatically install OpenRA after its compilation? $dim_in(pacman -U <compiled_openra_package>)$out\n"

			read -r -p "Please type 1 or 2 (Default: 2): " number
			attempts=5
			while [[ ! $(echo $number | sed 's/ //g') -eq 1 && ! $(echo $number | sed 's/ //g') -eq 2 && ! $(echo $number | sed 's/ //g') == "" ]]; do
				attempts=$(($attempts -1))
				if [[ $attempts -eq 0 ]]; then
					echo -e "\nMaximum attempts reached. Aborting.\n"
					break
				fi
				echo -e "\nInvalid answer. Expected number 1 or 2. Please type again ($attempts attempts left):\n"
				read number
				let number=$(echo $number | sed 's/ //g')
			done

			if [[ $number == "" ]]; then
			let number=2
			fi

			sleep 1
			rm $WORKING_DIR/data/linux/arch_linux/*.patch 2>/dev/null

			echo -e "\nDune 2 -- Question\n"
			read -r -p "Additionally, Dune 2 can be installed, too. Do you want to install it? [y/N] (Default: y) " dune2_install
			
			if [[ ! $(echo $dune2_install | sed 's/ //g') =~ ^([nN][oO]|[nN])$ ]]; then
				#Copy all patch files excluding the one which modifies 'mods' string in the Linux Makefile (double patching it will cause conflicts between D2 and RA2)
				cp ./data/patches/linux/*.patch ./data/linux/arch_linux/
				rm ./data/linux/arch_linux/linux-ra2-make-modstrings.patch
			else
				#Copy all patch files excluding the ones for Dune 2.
				cp ./data/patches/linux/*.patch ./data/linux/arch_linux/
				rm ./data/linux/arch_linux/linux-d2*.patch
			fi

			if [[ ! $(find $WORKING_DIR/data/hotfixes/linux/ -type f -iname *.patch | wc -l) -eq 0 ]]; then
				echo -e "\nHotfixes -- Question\n"
				echo -e "Use custom hotfixes if added by the user (Default: No)?\nNOTE: If you choose YES (y), be aware that your OpenRA/RA2 version will likely not be compatible with the other players unless they've applied exactly same hotfixes in their game versions, too!"
				echo -e "\nAvailable hotfixes are:\n"
				echo -e $green_in$(find $WORKING_DIR/data/hotfixes/linux/ -type f -iname *.patch | sed -e 's/.*\///' -e 's/\.[^\.]*$//')$out
				echo -e "\nMore information about hotfixes: https://github.com/Fincer/openra-tibsunra2/#about-patches--hotfixes\n"
				read -r -p "Use these hotfixes? [y/N] " hotfixes
					if [[ $(echo $hotfixes | sed 's/ //g') =~ ^([nN][oO][nN]|)$ ]]; then
						echo -e "\nHotfixes ignored and skipped. Continuing."
					elif [[ $(echo $hotfixes | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then
						cp ./data/hotfixes/linux/*.patch ./data/linux/arch_linux/
						echo -e "\nHotfixes applied. Continuing."
					else
						echo -e "\nHotfixes ignored and skipped. Continuing."
					fi
			fi

			if [[ $number -eq 1 ]]; then
				echo -e "\nSelected installation method:$bold_in Manual$out"
			else
				echo -e "\nSelected installation method:$bold_in Automatic$out"
			fi

			if [[ $(find $WORKING_DIR/data/hotfixes/linux/ -type f -iname *.patch | wc -l) -eq 0 ]]; then
			echo -e "Available hotfixes:$bold_in None$out"
			else
				if [[ $(echo $hotfixes | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then
					echo -e "Use hotfixes:$bold_in Yes$out"
				else
					echo -e "Use hotfixes:$bold_in No$out"
				fi
			fi

			if [[ ! $(echo $dune2_install | sed 's/ //g') =~ ^([nN][oO]|[nN])$ ]]; then
				echo -e "Install Dune 2:$bold_in Yes$out"
			else
				echo -e "Install Dune 2:$bold_in No$out"
			fi

			sleep 3
			echo -e "$bold_in\n***Starting OpenRA compilation process.***$out\n"
			sleep 2

			#Find all old patch occurences in PKGBUILD file and delete them.
			sed -i '/"git:\/\/github.com\/OpenRA\/ra2.git"/,/sha1sums/{//!d}' $WORKING_DIR/data/linux/arch_linux/PKGBUILD

			if [[ ! $(grep -rnw $WORKING_DIR/data/linux/arch_linux/PKGBUILD -e d2.git | wc -l) -eq 0 ]]; then
			sed -i '/"git:\/\/github.com\/OpenRA\/d2.git"/d' $WORKING_DIR/data/linux/arch_linux/PKGBUILD
			cd $WORKING_DIR/data/linux/arch_linux/
			patch -Np1 -R < $WORKING_DIR/data/linux/linux-d2-archlinux-pkgbuild.patch 2>/dev/null #Revert Dune 2 special PKGBUILD patch. Silent errors.
			cd $WORKING_DIR
			fi

			sed -i '//i '${PATCHES}')' $WORKING_DIR/data/linux/arch_linux/PKGBUILD

			#Add Dune 2 to PKGBUILD if it is going to be installed
			if [[ ! $(echo $dune2_install | sed 's/ //g') =~ ^([nN][oO]|[nN])$ ]]; then

			#Add Dune 2 sources (PKGBUILD -- source variable) -- Add Dune 2 git source
				sed -i '/source=(/a "git:\/\/github.com\/OpenRA\/d2.git"' $WORKING_DIR/data/linux/arch_linux/PKGBUILD

			#Add Dune 2 specific strings (PKGBUILD) -- Move Dune 2 source files + get version from Github + remove buildtime files
			#This is a special patch file used ONLY to patch PKGBUILD file.
				cd $WORKING_DIR/data/linux/arch_linux/
				patch -Np1 -i $WORKING_DIR/data/linux/linux-d2-archlinux-pkgbuild.patch
				cd $WORKING_DIR
			fi

			#Find all patch files and list them in PKGBUILD
			PATCHES=$(find ./data/linux/arch_linux/ -maxdepth 1 -type f -iname "*.patch" | sed -e 's/.*\///' | sed -e ':a;N;$!ba;s/\n/ /g' -e 's/ \+/\\n/g')
			sed -i '/"git:\/\/github.com\/OpenRA\/ra2.git"/a '${PATCHES}')' $WORKING_DIR/data/linux/arch_linux/PKGBUILD

			cd ./data/linux/arch_linux
			rm -rf */
			if [[ -f $(find $WORKING_DIR/data/linux/arch_linux/ -type f -iname "*.tar.xz") ]]; then
				rm $WORKING_DIR/data/linux/arch_linux/*.tar.xz 
			fi
			updpkgsums
			makepkg -c
			
			if [[ -f $(find $WORKING_DIR/data/linux/arch_linux/ -type f -iname "*.tar.xz") ]]; then
				mv *.tar.xz $WORKING_DIR
			else
				rm -rf */
				rm ./*.patch
				rm ./*.orig
				find . -name 'sed*' -delete
				endtext_fail
				exit 1
			fi

			PACKAGEMANAGER_INSTALL='sudo pacman -U'
			PACKAGEMANAGER_REMOVE='sudo pacman -Rs'
			INSTALL_NAME=$(sed -n '/pkgname/{p;q;}' ./PKGBUILD | sed -n 's/^pkgname=//p')
			PACKAGE_NAME=$(find $WORKING_DIR -maxdepth 1 -type f -iname "$INSTALL_NAME*.tar.xz" | sed -e 's/.*\///')

			if [[ ! $number -eq 1 ]]; then
				echo -e "$bold_in\n***Installing OpenRA (root password required).***$out\n"
				echo -e "NOTE: If the installation fails, this may happen because multiple openra-tibsunra2 tar.xz files have been found in $WORKING_DIR folder.\n"
				sleep 2
				$PACKAGEMANAGER_INSTALL --noconfirm $WORKING_DIR/$PACKAGE_NAME
				echo -e "$bold_in\n***OpenRA installation completed.***$out"
			fi

			#Find all patch occurences in PKGBUILD file and delete them.
			sed -i '/"git:\/\/github.com\/OpenRA\/ra2.git"/,/sha1sums/{//!d}' $WORKING_DIR/data/linux/arch_linux/PKGBUILD

			sed -i '/"git:\/\/github.com\/OpenRA\/d2.git"/d' $WORKING_DIR/data/linux/arch_linux/PKGBUILD
			if [[ ! $(grep -rnw $WORKING_DIR/data/linux/arch_linux/PKGBUILD -e d2.git | wc -l) -eq 0 ]]; then
			cd $WORKING_DIR/data/linux/arch_linux/
			patch -Np1 -R -s < $WORKING_DIR/data/linux/linux-d2-archlinux-pkgbuild.patch 2>/dev/null #Revert Dune 2 special PKGBUILD patch. Silent all messages.
			fi
			
			cd $WORKING_DIR/data/linux/arch_linux #Yes, not needed but just makes extra sure we are in the right directory!
			rm -rf */ 2>/dev/null
			rm ./*.patch 2>/dev/null
			rm ./*.orig 2>/dev/null
			find . -name 'sed*' -delete 2>/dev/null
			cd $WORKING_DIR

			if [[ -z $PACKAGE_NAME ]]; then 
				endtext_fail
				exit 1
			else
				endtext_ok
 			   	exit 1
			fi

		elif [[ $(echo $response | sed 's/ //g') =~ ^([nN][oO]|[nN])$ ]]; then
			echo -e "\nCancelling OpenRA installation.\n"
			exit 1
		else
			echo -e "\nNot a valid answer. Expected [y/N].\n\nCancelling OpenRA installation.\n"
			exit 1
		fi
fi

##-------------------------------------------------------------
# If we're running Ubuntu or Linux Mint or Debian, then execute this
if [[ $DISTRO =~ "$UBUNTU" ]] || [[ $DISTRO =~ "$DEBIAN" ]]; then

	if [[ $DISTRO =~ "$DEBIAN" ]]; then
		if [[ $(dpkg-query -W sudo 2>/dev/null | wc -l) -eq 0 ]]; then
			echo -e "\Please install sudo and add your username to sudo group.\nRun the following commands:\nsu root\nadduser <username> sudo\n\nRe-run this script again then.\nExiting now."
			exit 1
		fi
	fi

	bash ./data/linux/openra-installscript.sh

	PACKAGEMANAGER_INSTALL='sudo dpkg -i'
	PACKAGEMANAGER_REMOVE='sudo apt-get purge --remove'
	INSTALL_NAME=$(sed -n '/PACKAGE_NAME/{p;q;}' ./data/linux/openra-installscript.sh | sed -n 's/^PACKAGE_NAME=//p')
	PACKAGE_NAME=$(find $HOME -maxdepth 1 -type f -iname "$INSTALL_NAME*.deb" | sed -e 's/.*\///')

	if [[ -z $PACKAGE_NAME ]]; then 
		endtext_fail
		if [[ -d $HOME/openra-master ]]; then
			echo -e "\n"
			read -r -p "Found temporary OpenRA compilation files in $HOME. Remove them now? [y/N] " response2
			if [[ $(echo $response2 | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then
				echo -e "\nDeleting.\n"
				rm -Rf $HOME/openra-master
			fi
		fi
		exit 1
	else
		endtext_ok
		exit 1
	fi

	exit 1
fi

##-------------------------------------------------------------
# If we're running OpenSUSE or Fedora, then execute this
if [[ $DISTRO =~ "$FEDORA" ]] || [[ $DISTRO =~ "$OPENSUSE" ]]; then

	bash ./data/linux/openra-installscript.sh

	if [[ $DISTRO =~ "$OPENSUSE" ]]; then
		PACKAGEMANAGER_INSTALL='sudo zypper install'
		PACKAGEMANAGER_REMOVE='sudo zypper remove'
	elif [[ $DISTRO =~ "$FEDORA" ]]; then
		PACKAGEMANAGER_INSTALL='sudo dnf install'
		PACKAGEMANAGER_REMOVE='sudo dnf remove'
	fi
	INSTALL_NAME=$(sed -n '/PACKAGE_NAME/{p;q;}' ./data/linux/openra-installscript.sh | sed -n 's/^PACKAGE_NAME=//p')
	PACKAGE_NAME=$(find $HOME -maxdepth 1 -type f -iname "$INSTALL_NAME*.rpm" | sed -e 's/.*\///')
  
	if [[ -z $PACKAGE_NAME ]]; then 
		endtext_fail
		if [[ -d $HOME/openra-master ]]; then
			echo -e "\n"
			read -r -p "Found temporary OpenRA compilation files in $HOME. Remove them now? [y/N] " response3
			if [[ $(echo $response3 | sed 's/ //g') =~ ^([yY][eE][sS]|[yY])$ ]]; then
				echo -e "\nDeleting.\n"
				rm -Rf $HOME/openra-master
			fi
		fi
		exit 1
	else
		endtext_ok
		exit 1
	fi

	exit 1
fi

##-------------------------------------------------------------
# If we don't have any of the supported distributions
if [[ ! $DISTRO =~ "$ARCH" ]] || [[ ! $DISTRO =~ "$UBUNTU" ]] || [[ ! $DISTRO =~ "$DEBIAN" ]] || [[ ! $DISTRO =~ "$OPENSUSE" ]] || [[ ! $DISTRO =~ "$FEDORA" ]]; then
	echo "
Your Linux Distribution is not supported. Please consider making a new OpenRA installation script for it.
Supported distributions are: Ubuntu, Linux Mint, Debian, OpenSUSE, Fedora and Arch Linux.
"
	exit 1
fi
