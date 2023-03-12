# Created by deNch
# DENCH ISO Editor (WIP)
# Use Example #
# Remove Use: "Function", 
# Enabled Use: #"Function",

$tweaks = @(
### Require Administrator ###
"RequireAdmin",
"CustomWindow",
"SetLocation",

### File Structure ###
"SetupFileStructure",
"CreateUnattended",
"WindowsMediaTool",
"LaunchMediaTool",

### Dism Prepare ISO ###
"AskUserIsoExtract",
"MountObtainedISO",
"OptimizeFileStruct",
"PrepareWindowsImage",
"MountWindowsImage",

### Edit Registry ###
"LoadRegistry",
"ImportRegistry",
"UnloadRegistry",

### Dism Reduce ISO ###
"RemoveWinAppxPkgs",
"RemoveCapability",
"RemoveFeatures",

### Dism Create ISO ###
"UnMountWindowsImage",
"ReCompressMadeIso",
"MakeIsoAvailable",

### Auxiliary Functions ###
"WaitForKey",
"Exiting"
)

##########
# Require Administrator
##########

# Relaunch the Script with Administrator Privileges.
Function RequireAdmin {
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" $PSCommandArgs" -WorkingDirectory $pwd -Verb RunAs
Exit
cls
}
}

# Launch the Script with A Custom Windows Size.
Function CustomWindow {
powershell -command "[console]::windowwidth=75; [console]::windowheight=25; [console]::bufferwidth=[console]::windowwidth"
}

Function SetLocation {
$currentPath = $PSScriptRoot
Set-Location "$currentPath"
}

##########
# File Structure
##########

Function SetupFileStructure {
If (!(Test-Path 'C:\ISO_Editor\')) {
New-Item -Path 'C:\ISO_Editor\' -ItemType Directory | Out-Null
}
If (!(Test-Path 'C:\ISO_Editor\WindowsImage\')) {
New-Item -Path 'C:\ISO_Editor\WindowsImage\' -ItemType Directory | Out-Null
}
If (!(Test-Path 'C:\ISO_Editor\MountPoint\')) {
New-Item -Path 'C:\ISO_Editor\MountPoint\' -ItemType Directory | Out-Null
}
If (!(Test-Path 'C:\ISO_Editor\ObtainedISO\')) {
New-Item -Path 'C:\ISO_Editor\ObtainedISO\' -ItemType Directory | Out-Null
}
}


Function CreateUnattended {
$errpref = $ErrorActionPreference #save actual preference
$ErrorActionPreference = "silentlycontinue"
$currentPath = $PSScriptRoot
Set-Location "$currentPath"
$Check = "C:\ISO_Editor\WindowsImage\"
if (Get-ChildItem -Path $Check "autounattend.xml") {
$ErrorActionPreference = $errpref
} else {
New-Item ".\autounattend.xml" -ItemType File  -Value "<?xml version=""1.0"" encoding=""utf-8""?>
<unattend xmlns=""urn:schemas-microsoft-com:unattend"">
	<settings pass=""oobeSystem"">
		<component name=""Microsoft-Windows-International-Core"" processorArchitecture=""amd64"" publicKeyToken=""31bf3856ad364e35"" language=""neutral"" versionScope=""nonSxS"" xmlns:wcm=""http://schemas.microsoft.com/WMIConfig/2002/State"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
			<InputLocale>0409:00000409</InputLocale>
			<SystemLocale>en-US</SystemLocale>
			<UILanguage>en-US</UILanguage>
			<UILanguageFallback>en-US</UILanguageFallback>
			<UserLocale>en-US</UserLocale>
		</component>
		<component name=""Microsoft-Windows-Shell-Setup"" processorArchitecture=""amd64"" publicKeyToken=""31bf3856ad364e35"" language=""neutral"" versionScope=""nonSxS"" xmlns:wcm=""http://schemas.microsoft.com/WMIConfig/2002/State"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
			<TimeZone>Eastern Standard Time</TimeZone>
			<AutoLogon>
				<Enabled>true</Enabled>
				<LogonCount>9999999</LogonCount>
				<Username>User</Username>
				<Password>
					<PlainText>true</PlainText>
					<Value></Value>
				</Password>
			</AutoLogon>
			<OOBE>
				<HideEULAPage>true</HideEULAPage>
				<HideLocalAccountScreen>true</HideLocalAccountScreen>
				<HideOnlineAccountScreens>true</HideOnlineAccountScreens>
				<HideWirelessSetupInOOBE>true</HideWirelessSetupInOOBE>
				<NetworkLocation>Other</NetworkLocation>
				<ProtectYourPC>3</ProtectYourPC>
				<SkipMachineOOBE>true</SkipMachineOOBE>
				<SkipUserOOBE>true</SkipUserOOBE>
			</OOBE>
			<UserAccounts>
				<LocalAccounts>
					<LocalAccount wcm:action=""add"">
						<DisplayName>deNch</DisplayName>
						<Group>Administrators</Group>
						<Name>User</Name>
						<Password>
							<PlainText>true</PlainText>
							<Value></Value>
						</Password>
					</LocalAccount>
				</LocalAccounts>
			</UserAccounts>
		</component>
	</settings>
	<settings pass=""specialize"">
		<component name=""Microsoft-Windows-Shell-Setup"" processorArchitecture=""amd64"" publicKeyToken=""31bf3856ad364e35"" language=""neutral"" versionScope=""nonSxS"" xmlns:wcm=""http://schemas.microsoft.com/WMIConfig/2002/State"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
			<ComputerName>*</ComputerName>
		</component>
	</settings>
	<settings pass=""windowsPE"">
		<component name=""Microsoft-Windows-International-Core-WinPE"" processorArchitecture=""amd64"" publicKeyToken=""31bf3856ad364e35"" language=""neutral"" versionScope=""nonSxS"" xmlns:wcm=""http://schemas.microsoft.com/WMIConfig/2002/State"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
			<InputLocale>0409:00000409</InputLocale>
			<SystemLocale>en-US</SystemLocale>
			<UILanguage>en-US</UILanguage>
			<UILanguageFallback>en-US</UILanguageFallback>
			<UserLocale>en-US</UserLocale>
			<SetupUILanguage>
				<UILanguage>en-US</UILanguage>
			</SetupUILanguage>
		</component>
		<component name=""Microsoft-Windows-Setup"" processorArchitecture=""amd64"" publicKeyToken=""31bf3856ad364e35"" language=""neutral"" versionScope=""nonSxS"" xmlns:wcm=""http://schemas.microsoft.com/WMIConfig/2002/State"" xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"">
			<Diagnostics>
				<OptIn>false</OptIn>
			</Diagnostics>
			<DynamicUpdate>
				<Enable>false</Enable>
				<WillShowUI>OnError</WillShowUI>
			</DynamicUpdate>
			<ImageInstall>
				<OSImage>
					<Compact>true</Compact>
					<WillShowUI>OnError</WillShowUI>
				</OSImage>
			</ImageInstall>
			<UserData>
				<AcceptEula>true</AcceptEula>
				<FullName>deNch</FullName>
				<ProductKey>
					<Key></Key>
				</ProductKey>
			</UserData>
		</component>
	</settings>
</unattend>

" | Out-Null
$ErrorActionPreference = $errpref
Move-item -path ".\autounattend.xml" -Destination "C:\ISO_Editor\WindowsImage\"
Write-Host "Select MCT Defaults and Save ISO to Default Documents Location"
Write-Host "Don't Close This PS Window, Click Finish and Watch Me Work"
}
}

Function WindowsMediaTool {
#github url to download zip file
#Assign zip file url to local variable
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue"
$currentPath = $PSScriptRoot
Set-Location "$currentPath"
$Check = ".\"
if (Get-ChildItem -Path $Check "21H2 MediaCreationTool.bat") {
$ErrorActionPreference = $errpref
} else {
$Url = "https://github.com/AveYo/MediaCreationTool.bat/archive/refs/heads/main.zip"
$DownloadFile = ".\" + $(Split-Path -Path $Url -Leaf)
Invoke-WebRequest -Uri $Url -UseBasicParsing -OutFile $DownloadFile
Rename-Item .\main.zip MCTool.zip
Expand-Archive -Path .\MCTool.zip -DestinationPath .\
Remove-Item -Path ".\MCTool.zip"
Rename-Item .\MediaCreationTool.bat-main MediaCreationTool
Remove-Item -Path ".\MediaCreationTool\.gitattributes"
Remove-Item -Path ".\MediaCreationTool\.gitignore"
Remove-Item -Path ".\MediaCreationTool\LICENSE"
Remove-Item -Path ".\MediaCreationTool\preview.png"
Remove-Item -Path ".\MediaCreationTool\README.md"
Remove-Item -Path ".\MediaCreationTool\bypass11" -Recurse
$ErrorActionPreference = $errpref
}
}

Function LaunchMediaTool {
$mydocuments = [Environment]::getfolderpath("mydocuments")
$Check = "C:\ISO_Editor\ObtainedISO\"
if (Get-ChildItem -Path $Check "Windows.iso") {
} else {
$errpref = $ErrorActionPreference #save actual preference
$ErrorActionPreference = "silentlycontinue"
$currentPath = $PSScriptRoot
Set-Location "$currentPath"
Rename-Item .\MediaCreationTool\MediaCreationTool.bat "21H2 MediaCreationTool.bat"
Move-item -path ".\MediaCreationTool\21H2 MediaCreationTool.bat" -Destination ".\21H2 MediaCreationTool.bat"
Remove-Item -Path ".\MediaCreationTool" -Recurse
Start-Process ".\21H2 MediaCreationTool.bat" -Verb RunAs -Wait
Copy-item -path "$mydocuments\Windows.iso" -Destination "C:\ISO_Editor\ObtainedISO\"
Remove-Item -Path "$mydocuments\Windows.iso" -Recurse
Remove-Item -Path ".\21H2 MediaCreationTool.bat" -Recurse
Remove-Item -Path "C:\$WINDOWS.~BT" -Recurse -Force
Remove-Item -Path "C:\ESD" -Recurse
$ErrorActionPreference = $errpref
}
}

##########
# Dism Prepare ISO
##########

Function AskUserIsoExtract {
do
 {
cls
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "       ██████╗  █████╗ ███╗   ███╗███████╗██████╗  ██████╗ ███████╗        " -ForegroundColor DarkCyan
Write-Host "      ██╔════╝ ██╔══██╗████╗ ████║██╔════╝██╔══██╗██╔═══██╗██╔════╝        " -ForegroundColor DarkCyan
Write-Host "      ██║  ███╗███████║██╔████╔██║█████╗  ██████╔╝██║   ██║███████╗        " -ForegroundColor DarkCyan
Write-Host "      ██║   ██║██╔══██║██║╚██╔╝██║██╔══╝  ██╔══██╗██║   ██║╚════██║        " -ForegroundColor DarkCyan
Write-Host "      ╚██████╔╝██║  ██║██║ ╚═╝ ██║███████╗██║  ██║╚██████╔╝███████║        " -ForegroundColor DarkCyan
Write-Host "       ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝        " -ForegroundColor DarkCyan
Write-Host "  ██╗███████╗ ██████╗       ███████╗██████╗ ██╗████████╗ ██████╗ ██████╗   " -ForegroundColor DarkCyan
Write-Host "  ██║██╔════╝██╔═══██╗      ██╔════╝██╔══██╗██║╚══██╔══╝██╔═══██╗██╔══██╗  " -ForegroundColor DarkCyan
Write-Host "  ██║███████╗██║   ██║█████╗█████╗  ██║  ██║██║   ██║   ██║   ██║██████╔╝  " -ForegroundColor DarkCyan
Write-Host "  ██║╚════██║██║   ██║╚════╝██╔══╝  ██║  ██║██║   ██║   ██║   ██║██╔══██╗  " -ForegroundColor DarkCyan
Write-Host "  ██║███████║╚██████╔╝      ███████╗██████╔╝██║   ██║   ╚██████╔╝██║  ██║  " -ForegroundColor DarkCyan
Write-Host "  ╚═╝╚══════╝ ╚═════╝       ╚══════╝╚═════╝ ╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝  " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "                                                                           " -ForegroundColor DarkCyan
Write-Host "Have You Used Tool To Download Microsoft Iso And " -ForegroundColor White
Write-Host "Saved It To Default \Document Location??" -ForegroundColor White
Write-Host "If Iso Found Optimization Will Be Done" -ForegroundColor Green
Write-Host "If No Iso Found Nothing Will Be Done" -ForegroundColor Red
Write-Host "=============================================" -ForegroundColor White
Write-Host "Y: Press 'Y' to Cont" -ForegroundColor Green
Write-Host "N: Press 'N' to Exit" -ForegroundColor Red
$selection = Read-Host "Make a Selection"
switch ($selection)
{
'y' { 
Cls
Write-Host "Running Iso Optimization" -ForegroundColor Cyan
}
'n' {
Write-Host "Skipping Iso Optimization" -ForegroundColor Cyan
Write-Host "Nothing Done... Exiting" -ForegroundColor Cyan
Start-Sleep 5
Exit
}
}
}
until ($selection -match "y" -or $selection -match "n")
}

Function MountObtainedISO {
$DiskImage = Mount-DiskImage -ImagePath "C:\ISO_Editor\ObtainedISO\Windows.iso" -StorageType ISO -NoDriveLetter -PassThru
New-PSDrive -Name ISOFile -PSProvider FileSystem -Root (Get-Volume -DiskImage $DiskImage).UniqueId
Push-Location ISOFile:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue"
Copy-Item -Path ISOFile:\* -Destination C:\ISO_Editor\WindowsImage\ -Recurse -PassThru
$ErrorActionPreference = $errpref
Pop-Location
Remove-PSDrive ISOFile
Dismount-DiskImage -DevicePath $DiskImage.DevicePath
}

Function OptimizeFileStruct {
Write-Host "Optimizing Iso File Structure" -ForegroundColor Cyan
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dlmanifests" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\en-us" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\etwproviders" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migration" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\replacementmanifests" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sxs" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uup" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\vista" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\xp" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\acmigration.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\acres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\actionqueue.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\adfscomp.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\admtv3check.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\aeinv.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\alert.gif" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompatservicing.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_bidi.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_bidi.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_bidi_txt.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appcompat_detailed_txt.xsl" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiser.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiser.sdb" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserdatasha1.cat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraiserwc.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\arunimg.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\arunres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\autorun.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\background_cli.bmp" -Recurse -Force 
#Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\boot.wim" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cdplib.mof" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cdplibuninstall.mof" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\clustercompliance.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cmi2migxml.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cmisetup.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compatctrl.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compatresources.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cryptosetup.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\csiagent.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\cversion.ini" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\db_msftproductionwindowssigningca.cer" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\devinv.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diager.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagnostic.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagtrack.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\diagtrackrunner.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dism.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismapi.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismcore.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismcoreps.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\dismprov.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\du.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\facilitator.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\folderprovider.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\gatherosstate.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\generaltel.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompat.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompat.txt" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwcompatPE.txt" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwexclude.txt" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwexcludePE.txt" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hypervcomplcheck.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\iasmigplugin.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\idwbinfo.txt" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\iiscomp.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\imagingprovider.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\input.dll" -Recurse -Force 
#Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\install.esd" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\itgtupg.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\lang.ini" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\locale.nls" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\logprovider.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mediasetupuimgr.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migapp.xml" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migcore.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mighost.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migisol.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migstore.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migsys.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\migtestplugin.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mitigation.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\mxeagent.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nlsbres.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ntdsupg.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ntfrsupg.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nxquery.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\nxquery.sys" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\offline.xml" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\offlineprofileutils.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\oscomps.woa.xml" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\oscomps.xml" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\osfilter.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\outofbox_windows_db.bin" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\pnpibs.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\pnppropmig.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\product.ini" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rdsupgcheck.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.admx" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reagent.xml" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reportgen.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\reservemanager.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rmsupg.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\rollback.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\schema.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sdbapiu.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\segoeui.ttf" -Recurse -Force 
#Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setup.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupcompat.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupcore.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupdiag.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_159931.spdx.json" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_159931.spdx.json.sha256" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setuperror.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setuphost.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupmgr.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.cfg" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupplatform.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\setupprep.exe" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfcn.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflcid.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistrs1.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw7.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw8.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistw8.woa.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwb.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwb.woa.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwt.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sflistwt.woa.dat" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpat.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatrs1.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatw7.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatw8.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatwb.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sfpatwt.inf" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\smiengine.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spflvrnt.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spprgrss.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizeng.dll" -Recurse -Force 
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizimg.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\spwizres.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\sqmapi.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uddicomp.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\unattend.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\unbcl.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uninstall.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uninstall_data.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\updateagent.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgloader.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgradeagent.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgradeagent.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_bulk.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_comp.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_data.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgrade_frmwrk.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\upgwow_bulk.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uxlib.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\uxlibres.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\vhdprovider.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\w32uiimg.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\w32uires.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\warning.gif" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsclient.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsclientapi.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdscore.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdscsl.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsimage.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdstptc.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsupgcompl.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdsutil.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wicadevicefilters.xml" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wimprovider.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\win32ui.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\windlp.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetup.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupboot.hiv" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupboot.sys" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wpx.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\ws.dat" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\setup.exe" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Support" -Recurse -Force -Confirm:$false

#Windows 11 Image File Structure
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\asz" -Recurse -Force -Confirm:$false
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\appraisersdblatestoshash.txt" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\background_cli.png" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\bcd.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\bootsvc.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\compatappraiserresources.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\hwreqchk.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\icbexclusion.inf" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\imagelib.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\servicingcommon.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_161400.spdx.json" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\SetupDU_161400.spdx.json.sha256" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\utcapi.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wdscommonlib.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\wimgapi.dll" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupmon.hiv" -Recurse -Force
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\winsetupmon.sys" -Recurse -Force
$ErrorActionPreference = $errpref
}

Function PrepareWindowsImage {
Write-Host "Converting Iso Image Esd to Wim" -ForegroundColor Cyan
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
Dism /Export-Image /SourceImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.esd" /SourceIndex:6 /DestinationImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.wim" /Compress:maximum /CheckIntegrity
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\install.esd" -Recurse -Force
$ErrorActionPreference = $errpref
}

Function MountWindowsImage {
Write-Host "Mounting Windows Iso" -ForegroundColor Cyan
Dism /Mount-Image /ImageFile:C:\ISO_Editor\WindowsImage\Sources\Install.wim /Index:1  /MountDir:C:\ISO_Editor\MountPoint\
}

##########
# Edit Iso Registry
##########

Function LoadRegistry {
Write-Host "Editing Windows Registry" -ForegroundColor Cyan
reg load HKLM\dench_SYSTEM "C:\ISO_Editor\MountPoint\Windows\System32\config\SYSTEM" | Out-Null
reg load HKLM\dench_SOFTWARE "C:\ISO_Editor\MountPoint\Windows\System32\config\SOFTWARE" | Out-Null
}

Function ImportRegistry {
New-Item "C:\ISO_Editor\dench.reg" -ItemType File  -Value "Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\dench_SYSTEM\ControlSet001\Control]
""SvcHostSplitThresholdInKB""=dword:08000000

[HKEY_LOCAL_MACHINE\dench_SOFTWARE\Policies\Microsoft\Windows\OneDrive]
""DisableFileSyncNGSC""=dword:00000001

" | Out-Null
reg import "C:\ISO_Editor\dench.reg" | Out-Null
}

Function UnloadRegistry {
Remove-Item -Path "C:\ISO_Editor\dench.reg"
reg unload HKLM\dench_SYSTEM | Out-Null
reg unload HKLM\dench_SOFTWARE | Out-Null
}

##########
# Dism Reduce ISO
##########

Function RemoveWinAppxPkgs {
Write-Host "Removing Win Appx Pkgs" -ForegroundColor Cyan
#Dism /Image:C:\ISO_Editor\MountPoint\ /Get-ProvisionedAppxPackages
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
#Windows 10
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.549981C3F5F10_1.1911.21713.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather_4.25.20211.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.DesktopAppInstaller_2019.125.2243.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GetHelp_10.1706.13331.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Getstarted_8.2.22942.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEIFImageExtension_1.0.22742.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Microsoft3DViewer_6.1908.2042.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub_18.1903.1152.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection_4.4.8204.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes_3.6.73.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MixedReality.Portal_2000.19081.1301.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MSPaint_2019.729.2301.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Office.OneNote_16001.12026.20112.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.People_2019.305.632.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ScreenSketch_2019.904.1644.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.SkypeApp_14.53.77.0_neutral_~_kzf8qxf38zg5c | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.StorePurchaseApp_11811.1001.1813.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VCLibs.140.00_14.0.27323.0_x64__8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VP9VideoExtensions_1.0.22681.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Wallet_2.4.18324.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebMediaExtensions_1.0.20875.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebpImageExtension_1.0.22753.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Windows.Photos_2019.19071.12548.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms_2019.807.41.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCamera_2018.826.98.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:microsoft.windowscommunicationsapps_16005.11629.20316.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub_2019.1111.2029.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsMaps_2019.716.2316.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsSoundRecorder_2019.716.2313.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsStore_11910.1002.513.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Xbox.TCUI_1.23.28002.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxApp_48.49.31001.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGameOverlay_1.46.11001.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGamingOverlay_2.34.28001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.YourPhone_2019.430.2026.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneMusic_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneVideo_2019.19071.19011.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Windows 11
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Clipchamp.Clipchamp_2.2.8.0_neutral_~_yxz26nhyzhsrt | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.549981C3F5F10_3.2204.14815.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingNews_4.2.27001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.BingWeather_4.53.33420.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.DesktopAppInstaller_2022.310.2333.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GamingApp_2021.427.138.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.GetHelp_10.2201.421.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Getstarted_2021.2204.1.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEIFImageExtension_1.0.43012.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.HEVCVideoExtension_1.0.50361.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftOfficeHub_18.2204.1141.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftSolitaireCollection_4.12.3171.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.MicrosoftStickyNotes_4.2.2.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Paint_11.2201.22.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.People_2020.901.1724.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.PowerAutomateDesktop_10.0.3735.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.RawImageExtension_2.1.30391.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ScreenSketch_2022.2201.12.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.SecHealthUI_1000.22621.1.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.StorePurchaseApp_12008.1001.113.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Todos_2.54.42772.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.VP9VideoExtensions_1.0.50901.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebMediaExtensions_1.0.42192.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WebpImageExtension_1.0.42351.0_x64__8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Windows.Photos_21.21030.25003.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsAlarms_2022.2202.24.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsCamera_2022.2201.4.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:microsoft.windowscommunicationsapps_16005.14326.20544.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsFeedbackHub_2022.106.2230.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsMaps_2022.2202.6.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsNotepad_11.2112.32.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsSoundRecorder_2021.2103.28.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsStore_22204.1400.4.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.WindowsTerminal_3001.12.10983.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.Xbox.TCUI_1.23.28004.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGameOverlay_1.47.2385.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxGamingOverlay_2.622.3232.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxIdentityProvider_12.50.6001.0_neutral_~_8wekyb3d8bbwe | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.XboxSpeechToTextOverlay_1.17.29001.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.YourPhone_1.22022.147.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneMusic_11.2202.46.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:Microsoft.ZuneVideo_2019.22020.10021.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:MicrosoftCorporationII.QuickAssist_2022.414.1758.0_neutral_~_8wekyb3d8bbwe | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-ProvisionedAppxPackage /PackageName:MicrosoftWindows.Client.WebExperience_421.20070.195.0_neutral_~_cw5n1h2txyewy | Out-Null
$ErrorActionPreference = $errpref
}

Function RemoveCapability {
Write-Host "Removing Capabilities" -ForegroundColor Cyan
#DISM /image:C:\ISO_Editor\MountPoint\ /Get-Capabilities
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
#Windows 10
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Accessibility.Braille~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Analog.Holographic.Desktop~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.Support.QuickAssist~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.WirelessDisplay.Connect~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:DirectX.Configuration.Database~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Hello.Face.18967~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Hello.Face.Migration.18967~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Onecore.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.WebDriver~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.MSPaint~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Notepad~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Msix.PackagingTool.Driver~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:NetFX3~~~~ | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Network.Irda~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Management.Console~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RasCMAK.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RIP.Listener~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.Shielded.VM.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:SNMP.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.DeveloperMode.Core~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.Graphics.DirectX~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Client.ShellComponents~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:WMI-SNMP-Provider.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:XPS.Viewer~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Handwriting~~~en-us~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.OCR~~~en-us~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Speech~~~en-us~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.TextToSpeech~~~en-us~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Language.Basic~~~en-us~0.0.1.0 | Out-Null

#Windows 11
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Capability Identity : Accessibility.Braille~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Analog.Holographic.Desktop~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.StepsRecorder~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:App.WirelessDisplay.Connect~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Browser.InternetExplorer~~~~0.0.11.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:DirectX.Configuration.Database~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Hello.Face.20134~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:MathRecognizer~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Media.WindowsMediaPlayer~~~~0.0.12.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Onecore.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Wallpapers.Extended~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.WebDriver~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Ethernet.Client.Intel.E1i68x64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Ethernet.Client.Intel.E2f68~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Ethernet.Client.Realtek.Rtcx21x64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Ethernet.Client.Vmware.Vmxnet3~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.IoTDeviceUpdateCenter~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Notepad.System~~~~0.0.1.0 | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.PowerShell.ISE~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.StorageManagement~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Broadcom.Bcmpciedhd63~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63al~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Broadcom.Bcmwl63a~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwbw02~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwew00~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwew01~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwlv64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwns64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwsw00~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwtw02~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwtw04~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwtw06~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwtw08~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Intel.Netwtw10~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Marvel.Mrvlpcie8897~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Qualcomm.Athw8x~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Qualcomm.Athwnx~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Qualcomm.Qcamain10x64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Ralink.Netr28x~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtl8187se~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtl8192se~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtl819xp~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtl85n64~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtwlane01~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtwlane13~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.Wifi.Client.Realtek.Rtwlane~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Microsoft.Windows.WordPad~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Msix.PackagingTool.Driver~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:NetFX3~~~~ | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Network.Irda~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OneCoreUAP.OneSync~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:OpenSSH.Server~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Fax.Scan~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Print.Management.Console~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RasCMAK.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:RIP.Listener~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.AzureStack.HCI.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.BitLocker.Recovery.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.CertificateServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.DHCP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.Dns.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FailoverCluster.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.FileServices.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.GroupPolicy.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.IPAM.Client.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.LLDP.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkController.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.NetworkLoadBalancing.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteAccess.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.RemoteDesktop.Services.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.ServerManager.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageMigrationService.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.StorageReplica.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.SystemInsights.Management.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.VolumeActivation.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Rsat.WSUS.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:SNMP.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.DeveloperMode.Core~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tools.Graphics.DirectX~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Tpm.TpmDiagnostics~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Desktop.EMS-SAC.Tools~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:Windows.Kernel.LA57~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:WMI-SNMP-Provider.Client~~~~0.0.1.0 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:WMIC~~~~ | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Remove-Capability /CapabilityName:XPS.Viewer~~~~0.0.1.0 | Out-Null
$ErrorActionPreference = $errpref
}

Function RemoveFeatures {
Write-Host "Removing Features" -ForegroundColor Cyan
#Dism /Image:C:\ISO_Editor\MountPoint\ /Get-Features
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:
$errpref = $ErrorActionPreference
$ErrorActionPreference = "silentlycontinue" #restore previous preference #save actual preference
#Windows 10
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TFTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:LegacyComponents | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectPlay | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SimpleTCP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Identity-Foundation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx3 | Out-Null with Payload Removed
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-NonHTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerRole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CommonHttpFeatures | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpErrors | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpRedirect | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationDevelopment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Security | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestFiltering | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HealthAndDiagnostics | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LoggingLibraries | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestMonitor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpTracing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-URLAuthorization | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IPSecurity | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Performance | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionDynamic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerManagementTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementScriptingTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IIS6ManagementCompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Metabase | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-WindowsActivationService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ProcessModel | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-NetFxEnvironment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ConfigurationAPI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HostableWebCore | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Services45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Pipe-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-MSMQ-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-PortSharing45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-StaticContent | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DefaultDocument | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DirectoryBrowsing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebDAV | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebSockets | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationInit | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CGI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIExtensions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ServerSideIncludes | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CustomLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-BasicAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionStatic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementConsole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WMICompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacyScripts | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacySnapIn | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPSvc | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Container | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-DCOMProxy | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-ADIntegration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-HTTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Multicast | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Triggers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CertProvider | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WindowsAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DigestAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ClientCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IISCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ODBCLogging | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MediaPlayback | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WindowsMediaPlayer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DataCenterBridging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SmbDirect | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:AppServerClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-Default-Definitions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-XPSServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SearchEngine-Client-Package | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSRDC-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TelnetClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TIFFIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WorkFolders-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-InternetPrinting-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPDPrintService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPRPortMonitor | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2Root | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HypervisorPlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:VirtualMachinePlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-ProjFS | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers-DisposableClientVM | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Tools-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-PowerShell | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Hypervisor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-Clients | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HostGuardian | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-DeviceLockdown | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedShellLauncher | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedBootExp | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedLogon | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-KeyboardFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-UnifiedWriteFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectoryServices-ADAM-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-ApplicationGuard | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4-AdvSrvs | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4Extended-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ServicesForNFS-ClientOnly | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ClientForNFS-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NFS-Administration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Deprecation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Tools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Internet-Explorer-Optional-amd64 | Out-Null

#Windows 11
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-Default-Definitions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-PrintToPDFServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-XPSServices-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TelnetClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TFTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:TIFFIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:LegacyComponents | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectPlay | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSRDC-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Identity-Foundation | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2Root | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MicrosoftWindowsPowerShellV2 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SimpleTCP | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4-AdvSrvs | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx4Extended-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Services45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-Pipe-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-MSMQ-Activation45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-TCP-PortSharing45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerRole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CommonHttpFeatures | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpErrors | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpRedirect | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationDevelopment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Security | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestFiltering | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-NetFxExtensibility45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HealthAndDiagnostics | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LoggingLibraries | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-RequestMonitor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpTracing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-URLAuthorization | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IPSecurity | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Performance | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionDynamic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebServerManagementTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementScriptingTools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IIS6ManagementCompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-Metabase | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-WindowsActivationService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ProcessModel | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-NetFxEnvironment | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WAS-ConfigurationAPI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HostableWebCore | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-HTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WCF-NonHTTP-Activation | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-StaticContent | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DefaultDocument | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DirectoryBrowsing | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebDAV | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WebSockets | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ApplicationInit | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ISAPIExtensions | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASPNET45 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ASP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CGI | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ServerSideIncludes | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CustomLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-BasicAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-HttpCompressionStatic | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementConsole | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ManagementService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WMICompatibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacyScripts | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-LegacySnapIn | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPServer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPSvc | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-FTPExtensibility | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Container | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-DCOMProxy | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-ADIntegration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-HTTP | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Multicast | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MSMQ-Triggers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-CertProvider | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-WindowsAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-DigestAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ClientCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-IISCertificateMappingAuthentication | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:IIS-ODBCLogging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NetFx3 | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Deprecation | Out-Null
#Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MediaPlayback | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WindowsMediaPlayer | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-DeviceLockdown | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedShellLauncher | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedBootExp | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-EmbeddedLogon | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-KeyboardFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-UnifiedWriteFilter | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HostGuardian | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Connector-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:MultiPoint-Tools | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:AppServerClient | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SearchEngine-Client-Package | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:WorkFolders-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-Features | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-InternetPrinting-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPDPrintService | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Printing-Foundation-LPRPortMonitor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:HypervisorPlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:VirtualMachinePlatform | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Windows-Subsystem-Linux | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Client-ProjFS | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers-DisposableClientVM | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Tools-All | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-PowerShell | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Hypervisor | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Services | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Microsoft-Hyper-V-Management-Clients | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DataCenterBridging | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:DirectoryServices-ADAM-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Windows-Defender-ApplicationGuard | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ServicesForNFS-ClientOnly | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:ClientForNFS-Infrastructure | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:NFS-Administration | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers-HNS | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:Containers-SDN | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Client | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SMB1Protocol-Server | Out-Null
Dism /Image:C:\ISO_Editor\MountPoint\ /Disable-Feature /FeatureName:SmbDirect | Out-Null
$ErrorActionPreference = $errpref
}

##########
# Dism Create ISO
##########

Function UnMountWindowsImage {
Write-Host "UnMounting Iso" -ForegroundColor Cyan
Dism /Unmount-Image /MountDir:C:\ISO_Editor\MountPoint\ /Commit
Rename-Item C:\ISO_Editor\WindowsImage\Sources\install.wim installorg.wim
}

Function ReCompressMadeIso {
Write-Host "Compress Wim" -ForegroundColor Cyan
dism /Export-Image /SourceImageFile:"C:\ISO_Editor\WindowsImage\Sources\installorg.wim" /SourceIndex:1 /DestinationImageFile:"C:\ISO_Editor\WindowsImage\Sources\install.wim" /compress:maximum
Remove-Item -Path "C:\ISO_Editor\WindowsImage\Sources\installorg.wim"
}

Function New-IsoFile 
{ 
<# 
.Synopsis 
Creates a new .iso file 
.Description 
The New-IsoFile cmdlet creates a new .iso file containing content from chosen folders 
.Example 
New-IsoFile "c:\tools","c:Downloads\utils" 
This command creates a .iso file in $env:temp folder (default location) that contains c:\tools and c:\downloads\utils folders. 
The folders themselves are included at the root of the .iso image. 
.Example 
New-IsoFile -FromClipboard -Verbose 
Before running this command, select and copy (Ctrl-C) files/folders in Explorer first. 
.Example 
dir c:\WinPE | New-IsoFile -Path c:\temp\WinPE.iso -BootFile "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg\efisys.bin" -Media DVDPLUSR -Title "WinPE" 
This command creates a bootable .iso file containing the content from c:\WinPE folder, but the folder itself isn't included. 
Boot file etfsboot.com can be found in Windows ADK. 
Refer to IMAPI_MEDIA_PHYSICAL_TYPE enumeration for possible media types: 
http://msdn.microsoft.com/en-us/library/windows/desktop/aa366217(v=vs.85).aspx 
.Notes 
NAME: New-IsoFile 
AUTHOR: Chris Wu 
LASTEDIT: 03/23/2016 14:46:50 
#>

[CmdletBinding(DefaultParameterSetName='Source')]Param( 
[parameter(Position=1,Mandatory=$true,ValueFromPipeline=$true, ParameterSetName='Source')]$Source, 
[parameter(Position=2)][string]$Path = "$env:temp\$((Get-Date).ToString('yyyyMMdd-HHmmss.ffff')).iso", 
[ValidateScript({Test-Path -LiteralPath $_ -PathType Leaf})][string]$BootFile = $null, 
[ValidateSet('CDR','CDRW','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','BDR','BDRE')][string] $Media = 'DVDPLUSRW_DUALLAYER', 
[string]$Title = (Get-Date).ToString("yyyyMMdd-HHmmss.ffff"), 
[switch]$Force, 
[parameter(ParameterSetName='Clipboard')][switch]$FromClipboard 
) 

Begin { 
($cp = new-object System.CodeDom.Compiler.CompilerParameters).CompilerOptions = '/unsafe' 
if (!('ISOFile' -as [type])) { 
Add-Type -CompilerParameters $cp -TypeDefinition @'
public class ISOFile 
{ 
public unsafe static void Create(string Path, object Stream, int BlockSize, int TotalBlocks) 
{ 
int bytes = 0; 
byte[] buf = new byte[BlockSize]; 
var ptr = (System.IntPtr)(&bytes); 
var o = System.IO.File.OpenWrite(Path); 
var i = Stream as System.Runtime.InteropServices.ComTypes.IStream; 

if (o != null) { 
while (TotalBlocks-- > 0) { 
i.Read(buf, BlockSize, ptr); o.Write(buf, 0, bytes); 
} 
o.Flush(); o.Close(); 
} 
} 
} 
'@ 
} 

if ($BootFile) { 
if('BDR','BDRE' -contains $Media) { Write-Warning "Bootable image doesn't seem to work with media type $Media" } 
($Stream = New-Object -ComObject ADODB.Stream -Property @{Type=1}).Open() # adFileTypeBinary 
$Stream.LoadFromFile((Get-Item -LiteralPath $BootFile).Fullname) 
($Boot = New-Object -ComObject IMAPI2FS.BootOptions).AssignBootImage($Stream) 
} 

$MediaType = @('UNKNOWN','CDROM','CDR','CDRW','DVDROM','DVDRAM','DVDPLUSR','DVDPLUSRW','DVDPLUSR_DUALLAYER','DVDDASHR','DVDDASHRW','DVDDASHR_DUALLAYER','DISK','DVDPLUSRW_DUALLAYER','HDDVDROM','HDDVDR','HDDVDRAM','BDROM','BDR','BDRE') 

Write-Verbose -Message "Selected media type is $Media with value $($MediaType.IndexOf($Media))"
($Image = New-Object -com IMAPI2FS.MsftFileSystemImage -Property @{VolumeName=$Title}).ChooseImageDefaultsForMediaType($MediaType.IndexOf($Media)) 

if (!($Target = New-Item -Path $Path -ItemType File -Force:$Force -ErrorAction SilentlyContinue)) { Write-Error -Message "Cannot create file $Path. Use -Force parameter to overwrite if the target file already exists."; break } 
} 

Process { 
if($FromClipboard) { 
if($PSVersionTable.PSVersion.Major -lt 5) { Write-Error -Message 'The -FromClipboard parameter is only supported on PowerShell v5 or higher'; break } 
$Source = Get-Clipboard -Format FileDropList 
} 

foreach($item in $Source) { 
if($item -isnot [System.IO.FileInfo] -and $item -isnot [System.IO.DirectoryInfo]) { 
$item = Get-Item -LiteralPath $item
} 

if($item) { 
Write-Verbose -Message "Adding item to the target image: $($item.FullName)"
try { $Image.Root.AddTree($item.FullName, $true) } catch { Write-Error -Message ($_.Exception.Message.Trim() + ' Try a different media type.') } 
} 
} 
} 

End { 
if ($Boot) { $Image.BootImageOptions=$Boot } 
$Result = $Image.CreateResultImage() 
[ISOFile]::Create($Target.FullName,$Result.ImageStream,$Result.BlockSize,$Result.TotalBlocks) 
Write-Verbose -Message "Target image ($($Target.FullName)) has been created"
$Target
}
}

Function MakeIsoAvailable {
$source_dir = "C:\ISO_Editor\WindowsImage"
get-childitem "$source_dir" | New-ISOFile -path .\dench_DIY_IMAGE.iso
}

##########
# Auxiliary Functions
##########

# Wait for Key Press
Function WaitForKey {
Write-Host "Press Any Key to Continue..." -ForegroundColor White
[Console]::ReadKey($true) | Out-Null
}

# Exit Powershell
Function Exiting {
Write-Host "Exiting" -ForegroundColor Cyan
Start-Sleep 5
Exit
}

##########
# Parse Parameters and Apply Tweaks
##########

# Call the Desired Tweak Functions
$tweaks | ForEach { Invoke-Expression $_ }