# PS-DriveLetterKeeper
PowerShell script used to automatically re-mount drives (such as rotating backup drives) to the same drive letter.

# User Variables
Desired (target) drive letter:<br>
$UserVar_DriveLetter = "v:"

Name prefixed to the volume label of all disks in the set (used to identify disks):<br>
$UserVar_LabelPrefix = "Backup"

Total number of disks in the set:<br>
$UserVar_TotalDrives = "2"
