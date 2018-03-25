# PS-DriveLetterKeeper
PowerShell script used to automatically re-mount volumes (such as those on rotating backup drives) to the same drive letter.

## User Variables
All settings are stored in DriveLetterKeeper.xml

<b>Target Drive Letter:</b><br>
The drive letter you wish all disks in the set to maintain when mounted.<br>
Example: <i>DriveLetter = "v:"</i>

<b>Label Prefix:</b><br>
The portion of the volume label shared by all disks in the set (This will be used to identify the volume to remount).<br>
Example: <i>LabelPrefix = "Backup"</i>

<b>Total Drives:</b><br>
The total number of disks in the set:<br>
Example: <i>TotalDrives = "2"</i>

<b>Erase New Drive:</b><br>
Erase the newly re-mounted volume:<br>
Example: <i>EraseNewDrv = "True"</i>

<b>Create Root Directory:</b><br>
Create a folder by this name on the root of the re-mounted volume (Requires EraseDrive = "True"):<br>
Example: <i>MakeRootDir = "VeeamBackup"</i>

<b>Skip Prompts:</b><br>
Execute script, with selected options, without prompting the user (unattended):<br>
Example: <i>SkipPrompts = "False"</i>

## Naming Convention
All volumes must be labeled with the text string defined in the <b>Label Prefix</b> variable, followed by a number (<b>01</b> through <b>24</b>).
Example: <i>Backup01</i>, <i>Backup02</i>, ... , <i>Backup12</i>, etc.

# Resources
List of resources used while building this script:
* [Microsoft TechNet - Change Drive Letters and Labels via PowerShell Command](https://blogs.technet.microsoft.com/heyscriptingguy/2011/03/14/change-drive-letters-and-labels-via-a-simple-powershell-command/)
* [Stack Overflow - Press any key to continue](https://stackoverflow.com/questions/20886243/press-any-key-to-continue)
* [Gregory Strike - Change Drive Letters With PowerShell](http://www.gregorystrike.com/2010/01/26/change-drive-letters-with-powershell-and-diskpart/)
