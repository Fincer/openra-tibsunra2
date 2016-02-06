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
	"`n- If you worry about what the script is doing, you can always check its code (\data\install.ps1)"
	Start-Sleep -s 4
	"`n- Press Ctrl+C if you want terminate script execution."
	Start-Sleep -s 4
	"`n***Starting execution sequence now***"
	Start-Sleep -s 3

#------------------------------------------------------
## Remove all old source files if they exist

	"`nRemoving all old source files that may exist in the data directory."

	Remove-Item .\data\OpenRA-bleed -Force -Recurse -ErrorAction SilentlyContinue
	Remove-Item .\data\ra2-master -Force -Recurse -ErrorAction SilentlyContinue

	Remove-Item .\data\OpenRA-bleed.zip -Force -ErrorAction SilentlyContinue
	Remove-Item .\data\ra2-master.zip -Force -ErrorAction SilentlyContinue

#------------------------------------------------------
## Prepare Github environment for downloading the source

	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}

	$client = New-Object System.Net.WebClient
	$client.Headers.Add("Authorization","token 1234567890notarealtoken987654321")
	$client.Headers.Add("Accept","application/vnd.github.v3.raw")

#------------------------------------------------------
## Download OpenRA-bleed source code

	"`nDownloading OpenRA source files from Github. Please Stand By."
	$client.DownloadFile("https://github.com/OpenRA/OpenRA/archive/bleed.zip?ref=bleed",".\data\OpenRA-bleed.zip”)

#------------------------------------------------------
## Download Red Alert 2 mod files

	"`nDownloading Red Alert 2 mod files from Github. Please Stand By."
	$client.DownloadFile("https://github.com/OpenRA/ra2/archive/master.zip?ref=master",".\data\ra2-master.zip”)

#------------------------------------------------------
## Unzip OpenRA-bleed source files

	"`nUnzipping OpenRA source files into data folder."
	$shell_app=new-object -com shell.application
	$filename = "OpenRA-bleed.zip"
	$zip_file = $shell_app.namespace((Get-Location).Path + "\data" + "\$filename")
	$destination = $shell_app.namespace((Get-Location).Path + "\data")
	$destination.Copyhere($zip_file.items())

#------------------------------------------------------
## Unzip Red Alert 2 mod files

	"`nUnzipping Red Alert 2 mod files into data folder."
	$shell_app=new-object -com shell.application
	$filename2 = "ra2-master.zip"
	$zip_file2 = $shell_app.namespace((Get-Location).Path + "\data" + "\$filename2")
	$destination = $shell_app.namespace((Get-Location).Path + "\data")
	$destination.Copyhere($zip_file2.items())

#------------------------------------------------------
## Merge OpenRA source files and Red Alert 2 mod files together

	"`nMerging OpenRA source & Red Alert 2 mod files."
	move-item ".\data\ra2-master\OpenRA.Mods.RA2" ".\data\OpenRA-bleed\OpenRA.Mods.RA2"
	move-item ".\data\ra2-master" ".\data\OpenRA-bleed\mods\ra2"

#------------------------------------------------------
## Prepare OpenRA source code for Tiberian Sun & Red Alert 2

	Start-Sleep -s 3
	"`nPatching OpenRA source code for Tiberian Sun & Red Alert 2."
	cd .\data
	.\patch.exe -d OpenRA-bleed -Np1 -i ..\openra-srcpatch.patch
	cd ..

#------------------------------------------------------
## Compile OpenRA with Tiberian Sun & Red Alert 2

	"`nCompiling OpenRA with Tiberian Sun & Red Alert 2.`n"
	cd .\data\OpenRA-bleed\
	.\make.cmd dependencies
	.\make.cmd all
	cd ..
	cd ..
	move-item ".\data\OpenRA-bleed\" ".\OpenRA-bleed-tibsunra2"

#------------------------------------------------------
## Post-installation messages

	"`nCompilation process completed. You find the game inside 'OpenRA-bleed-tibsunra2' folder"
	Start-Sleep -s 4
	"`nTO PLAY OPENRA: Click OpenRA.exe (maybe you should create a desktop shortcut for it?)"
	"`nTO PLAY TIBERIAN SUN: Launch the game and download the required asset files from the web when the game asks you to do so."
	"`nTO PLAY RED ALERT 2: you must install language.mix, multi.mix, ra2.mix and theme.mix into \My Documents\OpenRA\Content\ra2\ folder.`nYou find these files from original RA2 installation media (CD's):`n`ntheme.mix, multi.mix = RA2 CD Root folder`nra2.mix, language.mix = RA2 CD Root/INSTALL/Game1.CAB (inside that archive file)"
	"`nMULTIPLAYER: It's recommended to use exactly same compiled EXE files (and other stuff) for multiplayer usage to minimize possible version differences/conflicts between players. If your friends compiles this package with another operating system, please make sure they use exactly same source files for their OpenRA compilation process."
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