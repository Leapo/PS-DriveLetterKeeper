# DriveLetterKeeper
# Allison Creely
# 09-13-2017

# Variables
$UserVar_DriveLetter = "v:"
$UserVar_LabelPrefix = "Backup"
$UserVar_TotalDrives = "2"

# Functions
function Set-DriveLetter($DriveLabel,$DriveLetter) {
	# Check to make sure there isn't already a disk mounted to the desired drive letter.
	$check1 = Get-WmiObject -Class win32_volume -Filter "DriveLetter = '$DriveLetter'"
	if ($check1) {
		"- Error: There is already a disk mounted to `"${DriveLetter}`" - Operation Aborted!"
		return
	} 
	# Check to make sure this isn't the Windows system drive.
	$check2 = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	$check2a = $check2.DriveLetter
	$check2b = Test-Path $check2a\Windows
	if ($check2b -eq $True) {
		"- Error: $check2a is a System Disk - Operation Aborted!"
		return
	}

	$drive = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	if ($drive) {
		"- Found: Assigned drive letter `"$DriveLetter`" to volume labeled `"$DriveLabel`""
		$drive.DriveLetter = $DriveLetter
		$drive.Put() >$null
	} 
	else {
		"- Not found: Skipping"
	}
}

# Script
"-"*80
"Desired Drive Letter : $UserVar_DriveLetter"
"Volume Label Prefix  : $UserVar_LabelPrefix"
"Drives in Rotation   : $UserVar_TotalDrives"
"-"*80
""

for ($i=1; $i -le $UserVar_TotalDrives; $i++) {
	if ($i -lt 10) {
		$DriveLabel = "${UserVar_LabelPrefix}0$i"
	} 
	else {
		$DriveLabel = "${UserVar_LabelPrefix}$i"
	}
	echo "Looking for disk $i ($DriveLabel)"
	Set-DriveLetter -DriveLabel $DriveLabel -DriveLetter $UserVar_DriveLetter
	""
}

"-"*80
