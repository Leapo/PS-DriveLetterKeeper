# PS-DriveLetterKeeper
# Allison Creely
# 09-30-2017

# User Variables
$UserVar_DriveLetter = "v:"
$UserVar_LabelPrefix = "Backup"
$UserVar_TotalDrives = "2"
$UserVar_EraseNewDrv = "True"
$UserVar_SkipPrompts = "False"

# Functions
function Set-DriveLetter($DriveLabel,$DriveLetter,$DeleteContents) {
	# Collect volume information
	$drive = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	$check = Get-WmiObject -Class win32_volume -Filter "DriveLetter = '$DriveLetter'"
	
	#Check if label exists
	if (!$drive) {
		Write-Output "- Not found: Skipping"
		return
	}
	# Check to make sure there isn't a disk mounted to the destination drive letter
	if ($check) {
		$FoundLabel = $check.label
		if ($drive.DriveLetter -eq $DriveLetter) {
			Write-Output "- Found: Drive letter `"$DriveLetter`" already assigned to volume labeled `"$FoundLabel`""
		}
		else {
			Write-Output "- Error: Volume `"$FoundLabel`" already mounted to `"$DriveLetter`" - Operation Aborted!"
		}
		return
	}
	# Check to make sure this isn't the Windows system drive
	if ($drive) {
		$check2a = $drive.DriveLetter
		$check2b = Test-Path $check2a\Windows
		if ($check2b -eq $True) {
			Write-Output "- Error: $check2a is a System Disk - Operation Aborted!"
			return
		}
	}
	# Change Drive Letter
	if ($drive) {
		Write-Output "- Found: Assigned drive letter `"$DriveLetter`" to volume labeled `"$DriveLabel`""
		$drive.DriveLetter = $DriveLetter
		$drive.Put() >$null
		
		# Delete contents of disk, if requested
		if ($DeleteContents -eq "True") {
			Write-Output "- Info:  Deleting the contents of `"$DriveLetter`""
			Get-ChildItem -Path "$DriveLetter\" -Recurse | Select -ExpandProperty FullName | sort length -Descending | Remove-Item -force >$null
		}
	} 
}

# Header
$ScriptDiv  = Write-Output ("-" * 80)
$ScriptHead = Write-Output "PS-DriveLetterKeeper
$ScriptDiv
Desired Drive Letter   : $UserVar_DriveLetter
Volume Label Prefix    : $UserVar_LabelPrefix
Drives in Rotation     : $UserVar_TotalDrives
Delete Volume Contents : $UserVar_EraseNewDrv
$ScriptDiv"

if ($UserVar_SkipPrompts -ne "True") {
	do {
		clear
		Write-Host "$ScriptHead"
		Write-Host -nonewline "Continue[Y/n]? "
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
	Set-DriveLetter -DriveLabel $DriveLabel -DriveLetter $UserVar_DriveLetter -DeleteContents $UserVar_EraseNewDrv
	Write-Output ""
}

# Footer
Write-Host "$ScriptDiv"
if ($UserVar_SkipPrompts -ne "True") {
	Write-Host -NoNewLine 'Press any key to exit';
	$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
	Exit
}
