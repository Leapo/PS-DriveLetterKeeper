# PS-DriveLetterKeeper
PowerShell script used to automatically re-mount drives (such as rotating backup drives) to the same drive letter.

# User Variables
<b>Target Drive Letter:</b><br>
The drive letter you wish all disks in the set to maintain when mounted.<br>
Example: <i>$UserVar_DriveLetter = "v:"</i>

<b>Label Prefix:</b><br>
The portion of the volume label shared by all disks in the set (This will be used to identify the appropriate volume to remount).<br>
Example: <i>$UserVar_LabelPrefix = "Backup"</i>

<b>Total Drives:</b><br>
The total number of disks in the set:<br>
Example: <i>$UserVar_TotalDrives = "2"</i>

# Naming Convention
All volumes must be labeled with the text string defined in the <b>Label Prefix</b> variable, followed by a number (01 through 24).
Example: <i>Backup01</i>, <i>Backup02</i>, ... , <i>Backup12</i>, etc.
