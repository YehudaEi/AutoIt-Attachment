What is BackUp!?
BackUp! is a simple application written in AutoIt. It was designed to automate the backup process of files that need to be backed up at regular intervals that aren't dependent on time. It's manifest purpose is to be integrated with other applications that have programming capabilities, such as any product in the Microsoft Office Suite. For example, having the capability to back up an Access database when it is either opened or closed is what led to the development of BackUp!. However, it also has other uses within Windows, and through the command line it can be used to schedule automatic backups of individual files.


How does it work?
In order for BackUp! to work, it needs to read information from a profile. Each file you need to back up will have it's own profile, the contents of which are stored in a .INI file located in Program Files\BackUp!. The profile contains the following information:

- The directory where the file that needs to be backed up resides
- The filename
- The maximum number of backups to keep.
- The title of the file


How does it run?
Currently, BackUp! functions entirely through the command line by using one of four switches:

/create = This switch is used to create a profile. You can select the file you wish to back up, the title of file, and the maximum number of backups you wish to keep. When you pass this threshhold, the oldest backup will be automatically deleted and replaced with the newest one.

/edit = This switch is used to edit a profile. The prompts will be the same as with the /create switch, except you will be editing the profile rather than creating a new one. 

/ini = This switch will prompt you to select a profile, and it will then backup the file for you.

/run "profile.ini" = This switch functions the same as the /ini switch, except there is no user interaction. For example, if you have X amount of files that need to be backed up at a specific time, you can create a simple batch file, like so:

===========
@echo off
cmdow @ /HID

START "" /WAIT %SystemDrive%\Program Files\BackUp\BackUp.exe /run "profile1.ini"
START "" /WAIT %SystemDrive%\Program Files\BackUp\BackUp.exe /run "profile2.ini"
etc.

EXIT
===========

You can then schedule execution of this file through a task scheduler, place it in your Startup folder, etc. to automatically backup the files you specify.

Note: The first 3 switches are also available through shortcuts on the Start Menu.


Where are the backups stored?
The directory structure is as follows:
Root folder (contains the file that is being backed up)
--FileBackups (this folder is created by BackUp!)
----"title" (each backup will have it's own subfolder based on it's title)

Note: Each backup is also timestamped.


Known bugs:
- When you specificy to keep X amount of backups, X + 1 backups will actually be kept.
- I'm sure there are more, so please tell me!!


Roadmap:
- Improve code
- Better, more descriptive commenting
- Verify that file locations stored in each profile actually exist.
- Give user options for directory structure and backup names
- Add support for folder backups
	- Archive using 7zip
	- ?Exclude files and subfolders from backup process?
- Add option for scheduling backups to run via schtasks.exe
- Create traymenu/GUI to replace shortcuts


Change Log:
07-05-2008: v0.3
	- Removed all references to $title (use of the variable was redundant)
	- Added error-checking for FileOpenDialog (script will exit if no file is chosen)
	- Replaced InputBox with GUI that validates the data entered
	- Script now sets INI files to be read-only (try to force user to use /edit switch, and thus validate the data)
	- Fixed /edit switch to rename the profile after completion
	- Fixed MsgBox that displays after profile creation
	- Fixed SFX installer to check for existing versions (default = overwrite)

07-04-2008: v0.2
	- Initial release
	
Thanks to PsaltyDS, RAMzor, and zorphnog.