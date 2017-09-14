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
	$check1 = Get-WmiObject -Class win32_volume -Filter "DriveLetter = '$UserVar_DriveLetter'"
	if ($check1) {
		echo "- Error: There is already a disk mounted to `"${UserVar_DriveLetter}`" - Operation Aborted!"
		return
	} 
	# Check to make sure this isn't the Windows system drive.
	$check2 = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	$check2a = $check2.DriveLetter
	$check2b = Test-Path $check2a\Windows
	if ($check2b -eq $True) {
		echo "- Error: $check2a is a System Disk - Operation Aborted!"
		return
	}

	$drive = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	if ($drive) {
		echo "- Found: Assigned drive letter `"$DriveLetter`" to volume labeled `"$DriveLabel`""
		$drive.DriveLetter = $DriveLetter
		$drive.Put() >$null
	} 
	else {
		echo "- Not found: Skipping"
	}
}

# Script
"-"*80 | echo
echo "Desired Drive Letter : $UserVar_DriveLetter"
echo "Volume Label Prefix  : $UserVar_LabelPrefix"
echo "Drives in Rotation   : $UserVar_TotalDrives"
"-"*80 | echo
echo ""

for ($i=1; $i -le $UserVar_TotalDrives; $i++) {
	if ($i -lt 10) {
		$DriveLabel = "${UserVar_LabelPrefix}0$i"
	} 
	else {
		$DriveLabel = "${UserVar_LabelPrefix}$i"
	}
	echo "Looking for disk $i ($DriveLabel)"
	Set-DriveLetter -DriveLabel $DriveLabel -DriveLetter $UserVar_DriveLetter
	echo ""
}

"-"*80 | echo