#------------------------------------------------------
## Prepare the script for possible Ctrl+C termination

while ($true)
{

#------------------------------------------------------
## Test Internet connection

If (-Not (Test-Connection -computer github.com -count 3 -quiet)) {
	"`nCan't connect to Github. Please check your internet connection and try again."
	exit
  }

#------------------------------------------------------
## Initial script messages

	"`n***Welcome Comrade***"
	Start-Sleep -s 3
	"`nThis script will generate OpenRA with Tiberian Sun & Red Alert 2 for Windows."
	Start-Sleep -s 4
	"`n- Make sure you have Microsoft .NET Framework 4.5 installed on your computer."
	Start-Sleep -s 3
	"`n- This script is NOT made by the OpenRA developers and may have bugs."
	Start-Sleep -s 3
	"`n- If you worry about what the script is doing, you can always check its code (\data\windows\install.ps1)"
	Start-Sleep -s 4
	"`n- Press Ctrl+C if you want terminate script execution."
	Start-Sleep -s 4
	"`n***Starting execution sequence now***"
	Start-Sleep -s 3

#------------------------------------------------------
## Hotfix question

If (Test-Path ".\data\hotfixes\windows\*.patch"){

	"`n- Hotfixes -- Question`n"

	"Use custom hotfixes if added by the user (Default: No)?\nNOTE: If you choose YES (y), be aware that your OpenRA/RA2 version will likely not be compatible with the other players unless they've applied exactly same hotfixes in their game versions, too!"

	"`nAvailable hotfixes are:"

	##List available hotfix files:

	get-childitem ".\data\hotfixes\windows\" -recurse | where {$_.extension -eq '.patch'} | format-table Name

	"More information about hotfixes: https://github.com/Fincer/openra-tibsunra2/#about-patches--hotfixes`n"

	$hotfixes = Read-Host "Use these hotfixes? (y/N)"

	#Remove spaces if entered
	$hotfixes = $hotfixes -replace '\s',''

	if ($hotfixes -eq "y") {
		"`nHotfixes applied. Continuing."
	} else {
		"`nHotfixes ignored and skipped. Continuing."
	}

}Else{
	"`nAvailable hotfixes: None"
}
	"`n- Dune 2 -- Question`n"

	$dune2_install = Read-Host "Additionally, Dune 2 can be installed, too. Do you want to install it? [y/N] (Default: y)"

	#Remove spaces if entered
	$dune2_install = $dune2_install -replace '\s',''

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nInstall Dune 2: Yes"
	} else {
		"`nInstall Dune 2: No"
	}

	Start-Sleep -s 2

#------------------------------------------------------
## Remove all old source files if they exist

	"`nRemoving all old source files that may exist in the data directory."

	Remove-Item .\data\windows\OpenRA-bleed -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\ra2-master -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\d2-master -Force -Recurse -ErrorAction SilentlyContinue

	Remove-Item .\data\windows\OpenRA-bleed.zip -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\ra2-master.zip -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\d2-master.zip -Force -ErrorAction SilentlyContinue

	Remove-Item .\data\windows\*.html -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\*.txt -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\*.zip -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\*.patch -Force -ErrorAction SilentlyContinue

#------------------------------------------------------
## Prepare Github environment for downloading the source

	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

	$client = New-Object System.Net.WebClient
	$client.Headers.Add("Authorization","token 1234567890notarealtoken987654321")
	$client.Headers.Add("Accept","application/vnd.github.v3.raw")

#------------------------------------------------------
## Download OpenRA-bleed source code

	"`nDownloading OpenRA source files from Github. Please Stand By."
	$client.DownloadFile("https://github.com/OpenRA/OpenRA/archive/bleed.zip?ref=bleed",".\data\windows\OpenRA-bleed.zip")

#------------------------------------------------------
## Download Red Alert 2 mod files

	"`nDownloading Red Alert 2 mod files from Github. Please Stand By."
	$client.DownloadFile("https://github.com/OpenRA/ra2/archive/master.zip?ref=master",".\data\windows\ra2-master.zip")

#------------------------------------------------------
## Download Dune 2 mod files

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nDownloading Dune 2 mod files from Github. Please Stand By."
		$client.DownloadFile("https://github.com/OpenRA/d2/archive/master.zip?ref=master",".\data\windows\d2-master.zip")
	}

#------------------------------------------------------
## Unzip OpenRA-bleed source files

	"`nUnzipping OpenRA source files into \data\windows folder."
	$shell_app=new-object -com shell.application
	$filename = "OpenRA-bleed.zip"
	$zip_file = $shell_app.namespace((Get-Location).Path + "\data\windows" + "\$filename")
	$destination = $shell_app.namespace((Get-Location).Path + "\data\windows")
	$destination.Copyhere($zip_file.items())

#------------------------------------------------------
## Unzip Red Alert 2 mod files

	"`nUnzipping Red Alert 2 mod files into \data\windows folder."
	$shell_app=new-object -com shell.application
	$filename2 = "ra2-master.zip"
	$zip_file2 = $shell_app.namespace((Get-Location).Path + "\data\windows" + "\$filename2")
	$destination = $shell_app.namespace((Get-Location).Path + "\data\windows")
	$destination.Copyhere($zip_file2.items())

#------------------------------------------------------
## Unzip Dune 2 mod files

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nUnzipping Dune 2 mod files into \data\windows folder."
		$shell_app=new-object -com shell.application
		$filename3 = "d2-master.zip"
		$zip_file3 = $shell_app.namespace((Get-Location).Path + "\data\windows" + "\$filename3")
		$destination = $shell_app.namespace((Get-Location).Path + "\data\windows")
		$destination.Copyhere($zip_file3.items())
	}

#------------------------------------------------------
## Merge OpenRA source files and Red Alert 2 (& Dune 2) mod files together

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {

		"`nMerging OpenRA source & Red Alert 2 + Dune 2 mod files."
		Copy-Item -Recurse ".\data\windows\d2-master\OpenRA.Mods.D2" ".\data\windows\OpenRA-bleed\OpenRA.Mods.D2"
		Copy-Item -Recurse ".\data\windows\d2-master" ".\data\windows\OpenRA-bleed\mods\d2"

		Remove-Item -Recurse .\data\windows\d2-master\*

		Copy-Item -Recurse ".\data\windows\ra2-master\OpenRA.Mods.RA2" ".\data\windows\OpenRA-bleed\OpenRA.Mods.RA2"
		Copy-Item -Recurse ".\data\windows\ra2-master" ".\data\windows\OpenRA-bleed\mods\ra2"
	} else {
		"`nMerging OpenRA source & Red Alert 2 mod files."
		Copy-Item -Recurse ".\data\windows\ra2-master\OpenRA.Mods.RA2" ".\data\windows\OpenRA-bleed\OpenRA.Mods.RA2"
		Copy-Item -Recurse ".\data\windows\ra2-master" ".\data\windows\OpenRA-bleed\mods\ra2"
	}

	Remove-Item -Recurse .\data\windows\ra2-master\*

#------------------------------------------------------
## Get OpenRA Git version number

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nRetrieving OpenRA & Red Alert 2 + Dune 2 Git version numbers."
	} else {
		"`nRetrieving OpenRA & Red Alert 2 Git version numbers."
	}

	$web = New-Object System.Net.WebClient
	$web.DownloadFile("https://github.com/OpenRA/OpenRA",".\data\windows\openra-github.html")

	$flag=0
	Get-Content .\data\windows\openra-github.html |
	foreach {
	Switch -Wildcard ($_){
	"*Latest commit*" {$flag=1}
	"*time datetime*" {$flag=0}
	}
	if ($flag -eq 1){
	Out-File .\data\windows\openra-html-stripped.txt -InputObject $_ -Append
	}
	}

	(Get-Content .\data\windows\openra-html-stripped.txt)[2] -replace '\s','' | Foreach-Object{ 'git-' + $_ } > .\data\windows\openra-latestcommit.txt

	$openra_gitversion = [IO.File]::ReadAllText(".\data\windows\openra-latestcommit.txt").trim("`r`n")
	Write-Output "`nOpenRA version: $openra_gitversion"

#This is used in folder name
	$openra_folderversion = [IO.File]::ReadAllText(".\data\windows\openra-latestcommit.txt").trim("`r`ngit")

#------------------------------------------------------
## Get Red Alert 2 Git version number

	$web = New-Object System.Net.WebClient
	$web.DownloadFile("https://github.com/OpenRA/ra2",".\data\windows\ra2-github.html")

	$flag=0
	Get-Content .\data\windows\ra2-github.html |
	foreach {
	Switch -Wildcard ($_){
	"*Latest commit*" {$flag=1}
	"*time datetime*" {$flag=0}
	}
	if ($flag -eq 1){
	Out-File .\data\windows\ra2-html-stripped.txt -InputObject $_ -Append
	}
	}

	(Get-Content .\data\windows\ra2-html-stripped.txt)[2] -replace '\s','' | Foreach-Object{ 'git-' + $_ } > .\data\windows\ra2-latestcommit.txt

	$ra2_gitversion = [IO.File]::ReadAllText(".\data\windows\ra2-latestcommit.txt").trim("`r`n")
	Write-Output "RA2 version: $ra2_gitversion"

#This is used in folder name
	$ra2_folderversion = [IO.File]::ReadAllText(".\data\windows\ra2-latestcommit.txt").trim("`r`ngit")

#------------------------------------------------------
## Get Dune 2 Git version number

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {

		$web = New-Object System.Net.WebClient
		$web.DownloadFile("https://github.com/OpenRA/d2",".\data\windows\d2-github.html")

		$flag=0
		Get-Content .\data\windows\d2-github.html |
		foreach {
		Switch -Wildcard ($_){
		"*Latest commit*" {$flag=1}
		"*time datetime*" {$flag=0}
		}
		if ($flag -eq 1){
		Out-File .\data\windows\d2-html-stripped.txt -InputObject $_ -Append
		}
		}

		(Get-Content .\data\windows\d2-html-stripped.txt)[2] -replace '\s','' | Foreach-Object{ 'git-' + $_ } > .\data\windows\d2-latestcommit.txt

		$d2_gitversion = [IO.File]::ReadAllText(".\data\windows\d2-latestcommit.txt").trim("`r`n")
		Write-Output "Dune 2 version: $d2_gitversion"

	#This is used in folder name
		$d2_folderversion = [IO.File]::ReadAllText(".\data\windows\d2-latestcommit.txt").trim("`r`ngit")
	}

#------------------------------------------------------
## Prepare OpenRA source code for Tiberian Sun & Red Alert 2 (& Dune 2)

	#Add patches & hotfixes
	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {

		Copy-Item ".\data\patches\windows\*.patch" ".\data\windows"

		if ($hotfixes -eq "y") {
		Copy-Item ".\data\hotfixes\windows\*.patch" ".\data\windows"
		}

		#This file will conflict with windows-d2-make-modstrings.patch
		Remove-Item .\data\windows\windows-ra2-make-modstrings.patch -Force -ErrorAction SilentlyContinue

	} else {

		Copy-Item ".\data\patches\windows\*.patch" ".\data\windows"

		if ($hotfixes -eq "y") {
		Copy-Item ".\data\hotfixes\windows\*.patch" ".\data\windows"
		}

		#Remove Dune 2 patches
		Remove-Item .\data\windows\windows-d2*.patch -Force -ErrorAction SilentlyContinue
	}
	Start-Sleep -s 3

	#Start patching operation

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nPatching OpenRA source code for Tiberian Sun & Red Alert 2 + Dune 2."
	} else {
		"`nPatching OpenRA source code for Tiberian Sun & Red Alert 2."
	}

	cd .\data\windows

	"`nFor each time a patch/hotfix is being applied, UAC may ask permission for patch.exe."

	$patchcount = (Get-Childitem .\ | where {$_.extension -eq ".patch"} | Measure-Object ).Count;

	Write-Output "`nExecuting patch.exe $patchcount times now."
	Start-Sleep -s 6
	Get-ChildItem .\ -include *.patch -recurse | Foreach ($_) {.\patch.exe -d OpenRA-bleed -Np1 -i $_.fullname }

	cd ..
	cd ..

	
#------------------------------------------------------
## Push version numbers to mod files

# Red Alert
	(Get-Content .\data\windows\Openra-bleed\mods\ra\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\ra\mod.yaml

# Tiberian Dawn
	(Get-Content .\data\windows\Openra-bleed\mods\cnc\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\cnc\mod.yaml

# Dune 2K
	(Get-Content .\data\windows\Openra-bleed\mods\d2k\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\d2k\mod.yaml

# Tiberian Sun
	(Get-Content .\data\windows\Openra-bleed\mods\ts\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\ts\mod.yaml

# Red Alert 2
	(Get-Content .\data\windows\Openra-bleed\mods\ra2\mod.yaml) -replace '{DEV_VERSION}',$ra2_gitversion | Set-Content .\data\windows\Openra-bleed\mods\ra2\mod.yaml

# Mod Chooser
	(Get-Content .\data\windows\Openra-bleed\mods\modchooser\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\modchooser\mod.yaml

# All
	(Get-Content .\data\windows\Openra-bleed\mods\all\mod.yaml) -replace '{DEV_VERSION}',$openra_gitversion | Set-Content .\data\windows\Openra-bleed\mods\all\mod.yaml

#Dune 2
	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		(Get-Content .\data\windows\Openra-bleed\mods\d2\mod.yaml) -replace '{DEV_VERSION}',$d2_gitversion | Set-Content .\data\windows\Openra-bleed\mods\d2\mod.yaml
	}

#------------------------------------------------------
## Remove temporary files

	Remove-Item .\data\windows\*.html
	Remove-Item .\data\windows\*.txt
	Remove-Item .\data\windows\*.zip
	Remove-Item .\data\windows\*.patch

#------------------------------------------------------
## Compile OpenRA with Tiberian Sun & Red Alert 2

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nCompiling OpenRA with Tiberian Sun & Red Alert 2 + Dune 2.`n"
	} else {
		"`nCompiling OpenRA with Tiberian Sun & Red Alert 2.`n"
	}

	cd .\data\windows\OpenRA-bleed\
	.\make.cmd dependencies
	.\make.cmd all
	cd ..
	cd ..
	cd ..
	"`nCopying OpenRA files to the final location. This takes a while. Please wait.`n"

	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Platforms.Default
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.Common
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.Cnc
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.D2k
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.RA
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.TS
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.RA2
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Server
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Test
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Utility
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.GameMonitor
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Game
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\packaging
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\thirdparty

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		Remove-Item -Recurse .\data\windows\OpenRA-bleed\OpenRA.Mods.D2
	}

	Remove-Item .\data\windows\OpenRA-bleed\.editorconfig
	Remove-Item .\data\windows\OpenRA-bleed\.gitattributes
	Remove-Item .\data\windows\OpenRA-bleed\.gitignore
	Remove-Item .\data\windows\OpenRA-bleed\.kateproject
	Remove-Item .\data\windows\OpenRA-bleed\.travis.yml
	Remove-Item .\data\windows\OpenRA-bleed\CONTRIBUTING.md
	Remove-Item .\data\windows\OpenRA-bleed\COPYING
	Remove-Item .\data\windows\OpenRA-bleed\ConvertFrom-Markdown.ps1
	Remove-Item .\data\windows\OpenRA-bleed\INSTALL.md
	Remove-Item .\data\windows\OpenRA-bleed\Makefile
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.sln
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.sln.orig
	Remove-Item .\data\windows\OpenRA-bleed\README.md
	Remove-Item .\data\windows\OpenRA-bleed\Settings.StyleCop
	Remove-Item .\data\windows\OpenRA-bleed\make.ps1
	Remove-Item .\data\windows\OpenRA-bleed\make.ps1.orig
	Remove-Item .\data\windows\OpenRA-bleed\make.cmd
	Remove-Item .\data\windows\OpenRA-bleed\launch-game.sh
	Remove-Item .\data\windows\OpenRA-bleed\launch-dedicated.sh
	Remove-Item .\data\windows\OpenRA-bleed\appveyor.yml
	Remove-Item .\data\windows\OpenRA-bleed\dupFinder.xslt
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Game.pdb
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Server.pdb
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Platforms.Default.pdb
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Test.nunit
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Test.pdb
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.pdb
	Remove-Item .\data\windows\OpenRA-bleed\OpenRA.Utility.pdb
	Remove-Item .\data\windows\OpenRA-bleed\AUTHORS

	Remove-Item .\data\windows\OpenRA-bleed\mods\cnc\OpenRA.Mods.Cnc.pdb
	Remove-Item .\data\windows\OpenRA-bleed\mods\common\OpenRA.Mods.Common.pdb
	Remove-Item .\data\windows\OpenRA-bleed\mods\d2k\OpenRA.Mods.D2k.pdb
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra\OpenRA.Mods.RA.pdb
	Remove-Item .\data\windows\OpenRA-bleed\mods\ts\OpenRA.Mods.TS.pdb

	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\build.cake
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\makefile
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\make.ps1
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\mod.yaml.orig
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\.gitattributes
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\.gitignore
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\.travis.yml
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\make.cmd
	Remove-Item .\data\windows\OpenRA-bleed\mods\ra2\fetch-content.sh
	Remove-Item -Recurse .\data\windows\OpenRA-bleed\mods\ra2\OpenRA.Mods.RA2

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		Remove-Item -Recurse .\data\windows\OpenRA-bleed\mods\d2\OpenRA.Mods.D2

		Copy-Item -Recurse ".\data\windows\OpenRA-bleed\" ".\OpenRA-tibsunra2-Windows-openra$openra_folderversion-ra2$ra2_folderversion-d2$d2_folderversion"

		Remove-Item .\data\windows\d2-master
	} else {
		Copy-Item -Recurse ".\data\windows\OpenRA-bleed\" ".\OpenRA-tibsunra2-Windows-openra$openra_folderversion-ra2$ra2_folderversion"
	}

	Remove-Item .\data\windows\OpenRA-bleed\* -Recurse
	Remove-Item .\data\windows\OpenRA-bleed
	Remove-Item .\data\windows\ra2-master

#------------------------------------------------------
## Post-installation messages

	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nCompilation process completed. You find the game inside 'OpenRA-tibsunra2-Windows-openra$openra_folderversion-ra2$ra2_folderversion-d2$d2_folderversion' folder"
	} else {
		"`nCompilation process completed. You find the game inside 'OpenRA-tibsunra2-Windows-openra$openra_folderversion-ra2$ra2_folderversion' folder"
	}

	Start-Sleep -s 4
	"`nTO PLAY OPENRA: Click OpenRA.exe (maybe you should create a desktop shortcut for it?)"
	"`nTO PLAY TIBERIAN SUN: Launch the game and download the required asset files from the web when the game asks you to do so."
	"`nTO PLAY RED ALERT 2: you must install language.mix, multi.mix, ra2.mix and theme.mix into \My Documents\OpenRA\Content\ra2\ folder.`nYou find these files from original RA2 installation media (CD's):`n`ntheme.mix, multi.mix = RA2 CD Root folder`nra2.mix, language.mix = RA2 CD Root\INSTALL\Game1.CAB (inside that archive file)"
	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		"`nTO PLAY DUNE 2: Please see https://github.com/Fincer/openra-tibsunra2/ front page for further instructions."
	}
	"`nMULTIPLAYER: It's recommended to build OpenRA using exactly same GIT source files for multiplayer usage to minimize possible version differences/conflicts between players. Please make sure all players have exactly same git versions of their in-game mods (RA, CNC, D2K, TS, RA2). Version numbers are formatted like 'git-e0d7445' etc. and can be found in each mod description in the mod selection menu."
	"`nFor this compilation, the version numbers are as follows:"
	Write-Output "OpenRA version: $openra_gitversion"
	Write-Output "RA2 version: $ra2_gitversion"
	if (-Not ($dune2_install -eq "n") -and -Not ($dune2_install -eq "o")) {
		Write-Output "Dune 2 version: $d2_gitversion"
	}
	"`nUNINSTALLATION: Since the game has been compiled from source and no additional setup programs are provided, all you need to do is to delete the contents of 'OpenRA-bleed-tibsunra2' folder and \My Documents\OpenRA\"
	"`nHave fun!"
	exit

#------------------------------------------------------
## Termination code for the script (Ctrl + C)

	if ($Host.UI.RawUI.KeyAvailable -and (3 -eq [int]$Host.UI.RawUI.ReadKey("AllowCtrlC,IncludeKeyUp,NoEcho").Character))
	{
		write-host "Installation script terminated by user." 
		$key = $Host.UI.RawUI.ReadKey("NoEcho, IncludeKeyDown")
		if ($key.Character -eq "N") { break; }
	}
}