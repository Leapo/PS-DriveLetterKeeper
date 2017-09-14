# PS-DriveLetterKeeper
PowerShell script used to automatically re-mount drives (such as rotating backup drives) to the same drive letter.

# User Variables
Target Drive Letter:<br>
The drive letter you wish all disks in the set to maintain when mounted.<br>
<b>$UserVar_DriveLetter = "v:"</b>

Label Prefix:<br>
The portion of the volume label shared by all disks in the set (This will be used to identify the appropriate volume to remount).<br>
<b>$UserVar_LabelPrefix = "Backup"</b>

Total Drives:<br>
The total number of disks in the set:<br>
<b>$UserVar_TotalDrives = "2"</b>

# Naming Convention
All volumes must be labeled with the text string defined in the <b>Label Prefix</b> variable, followed by a number (01 through 24).
