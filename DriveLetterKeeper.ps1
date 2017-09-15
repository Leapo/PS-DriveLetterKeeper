# PS-DriveLetterKeeper
# Allison Creely
# 09-14-2017

# Variables
$UserVar_DriveLetter = "v:"
$UserVar_LabelPrefix = "Backup"
$UserVar_TotalDrives = "2"

# Functions
function Set-DriveLetter($DriveLabel,$DriveLetter) {
	# Collect volume information
	$drive = Get-WmiObject -Class win32_volume -Filter "label = '$DriveLabel'"
	$check = Get-WmiObject -Class win32_volume -Filter "DriveLetter = '$DriveLetter'"
	
	#Check if label exists
	if (!$drive) {
		"- Not found: Skipping"
		return
	}
	# Check to make sure there isn't a disk mounted to the destination drive letter
	if ($check) {
		"- Error: There is already a disk mounted to `"${DriveLetter}`" - Operation Aborted!"
		return
	}
	# Check to make sure this isn't the Windows system drive
	if ($drive) {
		$check2a = $drive.DriveLetter
		$check2b = Test-Path $check2a\Windows
		if ($check2b -eq $True) {
			"- Error: $check2a is a System Disk - Operation Aborted!"
			return
		}
	}
	# Change Drive Letter
	if ($drive) {
		"- Found: Assigned drive letter `"$DriveLetter`" to volume labeled `"$DriveLabel`""
		$drive.DriveLetter = $DriveLetter
		$drive.Put() >$null
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
	"Looking for disk $i ($DriveLabel)"
	Set-DriveLetter -DriveLabel $DriveLabel -DriveLetter $UserVar_DriveLetter
	""
}

"-"*80
