#------------------------------------------------------
## Prepare the script for possible Ctrl+C termination

while ($true)
{

#------------------------------------------------------
## Initial script messages

	"***Welcome Comrade***"
	Start-Sleep -s 3
	"`nThis script will generate OpenRA with Tiberian Sun & Red Alert 2 for Windows."
	Start-Sleep -s 4
	"`n- Make sure you have Microsoft .NET Framework 4.5 installed on your computer."
	Start-Sleep -s 3
	"`n- This script is NOT made by the OpenRA developers and may contain bugs."
	Start-Sleep -s 3
	"`n- If you worry about what the script is doing, you can always check its code (\data\windows\install.ps1)"
	Start-Sleep -s 4
	"`n- Press Ctrl+C if you want terminate script execution."
	Start-Sleep -s 4
	"`n***Starting execution sequence now***"
	Start-Sleep -s 3

#------------------------------------------------------
## Remove all old source files if they exist

	"`nRemoving all old source files that may exist in the data directory."

	Remove-Item .\data\windows\OpenRA-bleed -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\ra2-master -Force -Recurse -ErrorAction SilentlyContinue

	Remove-Item .\data\windows\OpenRA-bleed.zip -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\windows\ra2-master.zip -Force -ErrorAction SilentlyContinue

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
## Merge OpenRA source files and Red Alert 2 mod files together

	"`nMerging OpenRA source & Red Alert 2 mod files."
	move-item ".\data\windows\ra2-master\OpenRA.Mods.RA2" ".\data\windows\OpenRA-bleed\OpenRA.Mods.RA2"
	move-item ".\data\windows\ra2-master" ".\data\windows\OpenRA-bleed\mods\ra2"

#------------------------------------------------------
## Get OpenRA Git version number

	"`nRetrieving OpenRA & Red Alert 2 Git version numbers."

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
#------------------------------------------------------
## Prepare OpenRA source code for Tiberian Sun & Red Alert 2

	Copy-Item ".\data\patches\*.patch" ".\data\windows"

	Start-Sleep -s 3
	"`nPatching OpenRA source code for Tiberian Sun & Red Alert 2."

	cd .\data\windows

	"`nFor each time a patch is being applied, UAC may ask permission for patch.exe."

	$patchcount = (Get-Childitem .\ | where {$_.extension -eq ".patch"} | Measure-Object ).Count;

	Write-Output "`nExecuting patch.exe $patchcount times now."

	Get-ChildItem .\ -include *.patch -recurse | Foreach ($_) {.\patch.exe -d OpenRA-bleed -Np1 --binary -i $_.fullname }

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

#------------------------------------------------------
## Remove temporary files

	Remove-Item .\data\windows\*.html
	Remove-Item .\data\windows\*.txt
	Remove-Item .\data\windows\*.zip
	Remove-Item .\data\windows\*.patch

#------------------------------------------------------
## Compile OpenRA with Tiberian Sun & Red Alert 2

	"`nCompiling OpenRA with Tiberian Sun & Red Alert 2.`n"
	cd .\data\windows\OpenRA-bleed\
	.\make.cmd dependencies
	.\make.cmd all
	cd ..
	cd ..
	cd ..
	move-item ".\data\windows\OpenRA-bleed\" ".\OpenRA-tibsunra2-Windows"

#------------------------------------------------------
## Post-installation messages

	"`nCompilation process completed. You find the game inside 'OpenRA-tibsunra2-Windows' folder"
	Start-Sleep -s 4
	"`nTO PLAY OPENRA: Click OpenRA.exe (maybe you should create a desktop shortcut for it?)"
	"`nTO PLAY TIBERIAN SUN: Launch the game and download the required asset files from the web when the game asks you to do so."
	"`nTO PLAY RED ALERT 2: you must install language.mix, multi.mix, ra2.mix and theme.mix into \My Documents\OpenRA\Content\ra2\ folder.`nYou find these files from original RA2 installation media (CD's):`n`ntheme.mix, multi.mix = RA2 CD Root folder`nra2.mix, language.mix = RA2 CD Root\INSTALL\Game1.CAB (inside that archive file)"
	"`nMULTIPLAYER: It's recommended to build OpenRA using exactly same GIT source files for multiplayer usage to minimize possible version differences/conflicts between players. Please make sure all players have exactly same git versions of their in-game mods (RA, CNC, D2K, TS, RA2). Version numbers are formatted like 'git-e0d7445' etc. and can be found in each mod description in the mod selection menu."
	"`nFor this compilation, the version numbers are as follows:"
	Write-Output "OpenRA version: $openra_gitversion"
	Write-Output "RA2 version: $ra2_gitversion"
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