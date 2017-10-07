# PS-DriveLetterKeeper
# Allison Creely
# 09-30-2017

#Load UserVars from XML
[xml]$XMLConfig = Get-Content $PSScriptRoot\DriveLetterKeeper.xml
$UserVar_DriveLetter = $XMLConfig.UserVars.DriveLetter
$UserVar_LabelPrefix = $XMLConfig.UserVars.LabelPrefix
$UserVar_TotalDrives = $XMLConfig.UserVars.TotalDrives
$UserVar_EraseNewDrv = $XMLConfig.UserVars.EraseNewDrv
$UserVar_MakeRootDir = $XMLConfig.UserVars.MakeRootDir
$UserVar_SkipPrompts = $XMLConfig.UserVars.SkipPrompts

# Functions
function Set-DriveLetter($DriveLabel,$DriveLetter,$DeleteContents,$RootDirectory) {
	# Collect volume information
	$drive = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	$check = Get-WmiObject -Class win32_volume -Filter "DriveLetter = '$DriveLetter'"
	
	if (!$drive) {
		#Check if label exists
		Write-Output "- Not found : Skipping"
		return
	}
	elseif ($check) {
		# Check to make sure there isn't a disk mounted to the destination drive letter
		if ($drive.DriveLetter -eq $DriveLetter) {
			Write-Output "- Found : Drive letter `"$DriveLetter`" already assigned to volume labeled `"$($check.label)`""
		}
		else {
			Write-Output "- Error : Volume `"$($check.label)`" already mounted to `"$DriveLetter`" - Operation Aborted!"
		}
		return
	}
	elseif ((Test-Path ${drive.DriveLetter}\Windows) -eq $True){
		# Check to make sure this isn't the Windows system drive
		Write-Output "- Error : $($drive.DriveLetter) is a System Disk - Operation Aborted!"
		return
	}
	else {	
		# Change Drive Letter
		Write-Output "- Found : Assigning drive letter `"$DriveLetter`" to volume labeled `"$DriveLabel`""	
		$DriveOld = $drive.DriveLetter.Trim(":")
		$DriveNew = $DriveLetter.Trim(":")
		"select volume " + $DriveOld + [char]13 + [char]10 + "assign letter " + $DriveNew | diskpart > $Null
		
		# Verify Operation
		$Verify_DriveInfo   = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
		$Verify_DriveLetter = $Verify_DriveInfo.DriveLetter
		if ($Verify_DriveLetter -eq $DriveLetter) {
			Write-Output "- Info  : Drive letter was assigned sucessfully"
			
			# Delete contents of disk, if requested
			if ($DeleteContents -eq "True") {
				Write-Output "- Info  : Deleting contents of `"$DriveLetter`""
				Get-ChildItem -Path "$DriveLetter\" -Recurse | Select -ExpandProperty FullName | sort length -Descending | Remove-Item -force >$null
				
				# Create root directory, if requested
				if ($RootDirectory) {
					Write-Output "- Info  : Creating directory `"$RootDirectory`" on `"$DriveLetter`""
					New-Item "$DriveLetter\$RootDirectory" -type directory >$null
				}
			}
		}
		else {
			Write-Output "- Error : Unable to assign drive letter - Operation Aborted!"
		}
	}
}

# Build Header
$ScriptDiv  = Write-Output ("-" * 80)
$ScriptHead = Write-Output "PS-DriveLetterKeeper
$ScriptDiv
Desired Drive Letter    : $UserVar_DriveLetter
Volume Label Prefix     : $UserVar_LabelPrefix
Drives in Rotation      : $UserVar_TotalDrives
Delete Volume Contents  : $UserVar_EraseNewDrv $(if ($UserVar_EraseNewDrv -eq "True") {Write-Output "
Recreate Root Directory : $UserVar_MakeRootDir"})
$ScriptDiv"

# Prompt User
if ($UserVar_SkipPrompts -ne "True") {
	do {
		clear
		Write-Host "$ScriptHead"
		Write-Host -NoNewLine "Continue[Y/n]? "
		$response = read-host
		if  (!$response) {$response = "Y"}
		if  ($response -eq "N") {exit}
	} until ($response -eq "Y")
}

clear
Write-Host "$ScriptHead
"

# Script
for ($i=1; $i -le $UserVar_TotalDrives; $i++) {
	if ($i -lt 10) {
		$DriveLabel = "${UserVar_LabelPrefix}0$i"
	} 
	else {
		$DriveLabel = "${UserVar_LabelPrefix}$i"
	}
	Write-Output "Looking for disk $i ($DriveLabel)"
	Set-DriveLetter -DriveLabel $DriveLabel -DriveLetter $UserVar_DriveLetter -DeleteContents $UserVar_EraseNewDrv -RootDirectory $UserVar_MakeRootDir
	Write-Output ""
}

# Footer
Write-Host "$ScriptDiv"
if ($UserVar_SkipPrompts -ne "True") {
	Write-Host -NoNewLine 'Press any key to exit';
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Exit
}
