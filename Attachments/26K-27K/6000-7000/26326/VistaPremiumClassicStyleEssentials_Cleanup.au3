; ----------------------------------------------------------------------------
;
; Software:         Windows Vista Essentials Cleanup
; Version:          v05.09
; Date Modified:    05/22/09 
; Platform:         WinXP
; Author:           James Montgomery
;
; ----------------------------------------------------------------------------

Opt("TrayIconDebug", 1)

; ----------------------------------------------------------------------------
; Windows Vista Essentials Cleanup
; ----------------------------------------------------------------------------

; Character Map
If Not FileExists(@ProgramsCommonDir & "\Office\Windows Character Map") Then
DirCreate(@ProgramsCommonDir & "\Office\Windows Character Map")
EndIf
If FileExists(@ProgramsCommonDir & "\Office\Windows Character Map") Then
FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Character Map.lnk", @ProgramsCommonDir & "\Office\Windows Character Map", 1)
EndIf
; Command Prompt
If Not FileExists(@ProgramsDir & "\System Utilities\Windows Command Prompt") Then
DirCreate(@ProgramsDir & "\System Utilities\Windows Command Prompt")
EndIf
If FileExists(@ProgramsDir & "\System Utilities\Windows Command Prompt") Then
FileCopy(@ProgramsDir & "\Accessories\Command Prompt.lnk", @ProgramsDir & "\System Utilities\Windows Command Prompt", 1)
EndIf
; Connect to a Network Projector
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Connect to a Network Projector") Then
DirCreate(@ProgramsCommonDir & "\Accessories\Windows Utilities\Connect to a Network Projector")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Connect to a Network Projector") Then
FileCopy(@ProgramsCommonDir & "\Accessories\Connect to a Network Projector.lnk", @ProgramsCommonDir & "\Windows Utilities\Connect to a Network Projector", 1)
EndIf
; Date and Time
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Date and Time") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Date and Time")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Date and Time") Then
FileCopy(@ScriptDir & "\Icons\Date and Time.lnk", @ProgramsCommonDir & "\Windows Utilities\Date and Time", 1)
EndIf
; Default Programs
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Default Programs") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Default Programs")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Default Programs") Then
FileMove(@StartMenuCommonDir & "\Default Programs.lnk", @ProgramsCommonDir & "\Windows Utilities\Default Programs", 1)
EndIf
; Disk Defragmenter
If Not FileExists(@ProgramsCommonDir & "\Maintenance\Defragmenters\Disk\Windows Disk Defragmenter") Then
	DirCreate(@ProgramsCommonDir & "\Maintenance\Defragmenters\Disk\Windows Disk Defragmenter")
EndIf
If FileExists(@ProgramsCommonDir & "\Maintenance\Defragmenters\Disk\Windows Disk Defragmenter") Then
	FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Disk Defragmenter.lnk", @ProgramsCommonDir & "\Maintenance\Defragmenters\Disk\Windows Disk Defragmenter", 1)
EndIf
; Disk Cleanup
If Not FileExists(@ProgramsCommonDir & "\Maintenance\Cleaners\Disk\Windows Disk Cleanup") Then
	DirCreate(@ProgramsCommonDir & "\Maintenance\Cleaners\Disk\Windows Disk Cleanup")
EndIf
If FileExists(@ProgramsCommonDir & "\Maintenance\Cleaners\Disk\Windows Disk Cleanup") Then
	FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Disk Cleanup.lnk", @ProgramsCommonDir & "\Maintenance\Cleaners\Disk\Windows Disk Cleanup", 1)
EndIf
; Display
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Display") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Display")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Display") Then
FileCopy(@ScriptDir & "\Icons\Display.lnk", @ProgramsCommonDir & "\Windows Utilities\Display", 1)
EndIf
; Explorer
If Not FileExists(@ProgramsDir & "\System Utilities\File Management\Windows Explorer") Then
DirCreate(@ProgramsDir & "\System Utilities\File Management\Windows Explorer")
EndIf
If FileExists(@ProgramsDir & "\System Utilities\File Management\Windows Explorer") Then
FileCopy(@ProgramsDir & "\Accessories\Windows Explorer.lnk", @ProgramsDir & "\System Utilities\File Management\Windows Explorer", 1)
EndIf
; Folder Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Folder Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Folder Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Folder Options") Then
FileCopy (@ScriptDir & "\Icons\Folder Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Folder Options", 1)
EndIf
; Game Controllers
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Game Controllers") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Game Controllers")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Game Controllers") Then
FileCopy(@ScriptDir & "\Icons\Game Controllers.lnk", @ProgramsCommonDir & "\Windows Utilities\Game Controllers", 1)
EndIf
; Internet Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Internet Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Internet Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Internet Options") Then
FileCopy(@ScriptDir & "\Icons\Internet Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Internet Options", 1)
EndIf
; Java
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Java") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Java")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Java") Then
FileCopy (@ScriptDir & "\Icons\Java.lnk", @ProgramsCommonDir & "\Windows Utilities\Java", 1)
EndIf
; Keyboard
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Keyboard") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Keyboard")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Keyboard") Then
FileCopy(@ScriptDir & "\Icons\Keyboard.lnk", @ProgramsCommonDir & "\Windows Utilities\Keyboard", 1)
EndIf
; Mouse
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Mouse") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Mouse")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Mouse") Then
FileCopy(@ScriptDir & "\Icons\Mouse.lnk", @ProgramsCommonDir & "\Windows Utilities\Mouse", 1)
EndIf
; Network and Sharing Center
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Network and Sharing Center") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Network and Sharing Center")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Network and Sharing Center") Then
FileCopy(@ScriptDir & "\Icons\Network and Sharing Center.lnk", @ProgramsCommonDir & "\Windows Utilities\Network and Sharing Center", 1)
EndIf
; NotePad
If Not FileExists(@ProgramsDir & "\Office\NotePads\Windows NotePad") Then
DirCreate(@ProgramsDir & "\Office\NotePads\Windows NotePad")
EndIf
If FileExists(@ProgramsDir & "\Office\NotePads\Windows NotePad") Then
FileCopy(@ProgramsDir & "\Accessories\Notepad.lnk", @ProgramsDir & "\Office\NotePads\Windows NotePad", 1)
EndIf
; Paint
If Not FileExists(@ProgramsCommonDir & "\Photos-Graphics\Image Editors-Viewers\Windows Paint") Then
DirCreate(@ProgramsCommonDir & "\Photos-Graphics\Image Editors-Viewers\Windows Paint")
EndIf
If FileExists(@ProgramsCommonDir & "\Photos-Graphics\Image Editors-Viewers\Windows Paint") Then
FileCopy(@ProgramsCommonDir & "\Accessories\Paint.lnk", @ProgramsCommonDir & "\Photos-Graphics\Image Editors-Viewers\Windows Paint", 1)
EndIf
; Parental Controls
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Parental Controls") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Parental Controls")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Parental Controls") Then
FileCopy(@ScriptDir & "\Icons\Parental Controls.lnk", @ProgramsCommonDir & "\Windows Utilities\Parental Controls", 1)
EndIf
; Pen and Input Devices
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Pen and Input Devices") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Pen and Input Devices")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Pen and Input Devices") Then
FileCopy(@ScriptDir & "\Icons\Pen and Input Devices.lnk", @ProgramsCommonDir & "\Windows Utilities\Pen and Input Devices", 1)
EndIf
; Performance Information and Tools
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Performance Information and Tools") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Performance Information and Tools")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Performance Information and Tools") Then
FileCopy(@ScriptDir & "\Icons\Performance Information and Tools.lnk", @ProgramsCommonDir & "\Windows Utilities\Performance Information and Tools", 1)
EndIf
; Phone and Modem Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Phone and Modem Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Phone and Modem Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Phone and Modem Options") Then
FileCopy(@ScriptDir & "\Icons\Phone and Modem Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Phone and Modem Options", 1)
EndIf
; Power Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Power Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Power Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Power Options") Then
FileCopy(@ScriptDir & "\Icons\Power Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Power Options", 1)
EndIf
; Problem Reports and Solutions
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Problem Reports and Solutions") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Problem Reports and Solutions")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Problem Reports and Solutions") Then
FileCopy(@ScriptDir & "\Icons\Problem Reports and Solutions.lnk", @ProgramsCommonDir & "\Windows Utilities\Problem Reports and Solutions", 1)
EndIf
; Programs and Features
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Programs and Features") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Programs and Features")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Programs and Features") Then
FileCopy(@ScriptDir & "\Icons\Programs and Features.lnk", @ProgramsCommonDir & "\Windows Utilities\Programs and Features", 1)
EndIf
; Regional and Language Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Regional and Language Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Regional and Language Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Regional and Language Options") Then
FileCopy(@ScriptDir & "\Icons\Regional and Language Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Regional and Language Options", 1)
EndIf
; Remote Desktop Connection
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Remote Desktop Connection") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Remote Desktop Connection")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Remote Desktop Connection") Then
FileCopy(@ScriptDir & "\Icons\Remote Desktop Connection.lnk", @ProgramsCommonDir & "\Windows Utilities\Remote Desktop Connection", 1)
EndIf
; Run
If Not FileExists(@ProgramsDir & "\System Utilities\Windows Run") Then
DirCreate(@ProgramsDir & "\System Utilities\Windows Run")
EndIf
If FileExists(@ProgramsDir & "\System Utilities\Windows Run") Then
FileCopy(@ProgramsDir & "\Accessories\Run.lnk", @ProgramsDir & "\System Utilities\Windows Run", 1)
EndIf
; Scanners and Cameras
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Scanners and Cameras") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Scanners and Cameras")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Scanners and Cameras") Then
FileCopy(@ScriptDir & "\Icons\Scanners and Cameras.lnk", @ProgramsCommonDir & "\Windows Utilities\Scanners and Cameras", 1)
EndIf
; Security Center
If Not FileExists(@ProgramsCommonDir & "\Security\Windows Security Center") Then
DirCreate(@ProgramsCommonDir & "\Security\Windows Security Center")
EndIf
If FileExists(@ProgramsCommonDir & "\Security\Windows Security Center") Then
FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Security Center.lnk", @ProgramsCommonDir & "\Security\Windows Security Center", 1)
EndIf
; Set Program Access and Defaults
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Set Program Access and Defaults") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Set Program Access and Defaults")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Set Program Access and Defaults") Then
FileCopy(@ScriptDir & "\Icons\Set Program Access and Defaults.lnk", @ProgramsCommonDir & "\Windows Utilities\Set Program Access and Defaults", 1)
EndIf
; Snipping Tool
If Not FileExists(@ProgramsCommonDir & "\Photos-Graphics\Screen Capture\Snipping Tool") Then
DirCreate(@ProgramsCommonDir & "\Photos-Graphics\Screen Capture\Snipping Tool")
EndIf
If FileExists(@ProgramsCommonDir & "\Photos-Graphics\Screen Capture\Snipping Tool") Then
FileCopy (@ProgramsCommonDir & "\Accessories\Snipping Tool.lnk", @ProgramsCommonDir & "\Photos-Graphics\Screen Capture\Snipping Tool", 1)
EndIf
; Sound Recorder
If Not FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Audio Editing\Sound Recorder") Then
DirCreate(@ProgramsCommonDir & "\Audio-Data-Video\Audio Editing\Sound Recorder")
EndIf
If FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Audio Editing\Sound Recorder") Then
FileCopy(@ProgramsCommonDir & "\Accessories\Sound Recorder.lnk", @ProgramsCommonDir & "\Audio-Data-Video\Audio Editing\Sound Recorder", 1)
EndIf
; Sounds and Audio Devices
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Sounds and Audio Devices") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Sounds and Audio Devices")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Sounds and Audio Devices") Then
FileCopy(@ScriptDir & "\Icons\Sounds and Audio Devices.lnk", @ProgramsCommonDir & "\Windows Utilities\Sounds and Audio Devices", 1)
EndIf
; Speech Recognition Options
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Speech Recognition Options") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Speech Recognition Options")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Speech Recognition Options") Then
FileCopy(@ScriptDir & "\Icons\Speech Recognition Options.lnk", @ProgramsCommonDir & "\Windows Utilities\Speech Recognition Options", 1)
EndIf
; Sync Center
If Not FileExists(@ProgramsCommonDir & "\System Utilities\Synchronization\Sync Center") Then
DirCreate(@ProgramsCommonDir & "\System Utilities\Synchronization\Sync Center")
EndIf
If FileExists(@ProgramsCommonDir & "\System Utilities\Synchronization\Sync Center") Then
FileCopy(@ProgramsCommonDir & "\Accessories\Sync Center.lnk", @ProgramsCommonDir & "\System Utilities\Synchronization\Sync Center", 1)
EndIf
; System Information
If Not FileExists(@ProgramsCommonDir & "\System Utilities\System Information\Windows System Information") Then
DirCreate(@ProgramsCommonDir & "\System Utilities\System Information\Windows System Information")
EndIf
If FileExists(@ProgramsCommonDir & "\System Utilities\System Information\Windows System Information") Then
FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\System Information.lnk", @ProgramsCommonDir & "\System Utilities\System Information\Windows System Information", 1)
EndIf
; System Restore
If Not FileExists(@ProgramsCommonDir & "\System Utilities\System Restore") Then
DirCreate(@ProgramsCommonDir & "\System Utilities\System Restore")
EndIf
If FileExists(@ProgramsCommonDir & "\System Utilities\System Restore") Then
FileCopy (@ProgramsCommonDir & "\Accessories\System Tools\System Restore.lnk", @ProgramsCommonDir & "\System Utilities\System Restore", 1)
EndIf
; Task Scheduler
If Not FileExists(@ProgramsCommonDir & "\System Utilities\Schedulers\Windows Task Scheduler") Then
DirCreate(@ProgramsCommonDir & "\System Utilities\Schedulers\Windows Task Scheduler")
EndIf
If FileExists(@ProgramsCommonDir & "\System Utilities\Schedulers\Windows Task Scheduler") Then
FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Scheduled Tasks.lnk", @ProgramsCommonDir & "\System Utilities\Schedulers\Windows Task Scheduler", 1)
EndIf
; Taskbar and Start Menu
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Taskbar and Start Menu") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Taskbar and Start Menu")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Taskbar and Start Menu") Then
FileCopy(@ScriptDir & "\Icons\Taskbar and Start Menu.lnk", @ProgramsCommonDir & "\Windows Utilities\Taskbar and Start Menu", 1)
EndIf
; Text to Speech
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Text to Speech") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Text to Speech")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Text to Speech") Then
FileCopy(@ScriptDir & "\Icons\Text to Speech.lnk", @ProgramsCommonDir & "\Windows Utilities\Text to Speech", 1)
EndIf
; User Accounts
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\User Accounts") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\User Accounts")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\User Accounts") Then
FileCopy(@ScriptDir & "\Icons\User Accounts.lnk", @ProgramsCommonDir & "\Windows Utilities\User Accounts", 1)
EndIf
; Volume Control
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Volume Control") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Volume Control")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Volume Control") Then
FileCopy(@ScriptDir & "\Icons\Volume Control.lnk", @ProgramsCommonDir & "\Windows Utilities\Volume Control", 1)
EndIf
; Volume Control
If Not FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Volume Control") Then
DirCreate(@ProgramsCommonDir & "\Audio-Data-Video\Volume Control")
EndIf
If FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Volume Control") Then
FileCopy(@ScriptDir & "\Icons\Volume Control.lnk", @ProgramsCommonDir & "\Audio-Data-Video\Volume Control", 1)
EndIf
; Windows Calendar
If Not FileExists(@ProgramsCommonDir & "\Office\Calendars\Windows Calendar") Then
DirCreate(@ProgramsCommonDir & "\Office\Calendars\Windows Calendar")
EndIf
If FileExists(@ProgramsCommonDir & "\Office\Calendars\Windows Calendar") Then
FileMove(@ProgramsCommonDir & "\Windows Calendar.lnk", @ProgramsCommonDir & "\Office\Calendars\Windows Calendar", 1)
EndIf
; Windows Calculator
If Not FileExists(@ProgramsCommonDir & "\Office\Calculators\Windows Calculator") Then
DirCreate(@ProgramsCommonDir & "\Office\Calculators\Windows Calculator")
EndIf
If FileExists(@ProgramsCommonDir & "\Office\Calculators\Windows Calculator") Then
FileCopy(@ProgramsCommonDir & "\Accessories\Calculator.lnk", @ProgramsCommonDir & "\Office\Calculators\Windows Calculator", 1)
EndIf
; Windows Contacts
If Not FileExists(@ProgramsCommonDir & "\Office\Address Books\Windows Contacts") Then
DirCreate(@ProgramsCommonDir & "\Office\Address Books\Windows Contacts")
EndIf
If FileExists(@ProgramsCommonDir & "\Office\Address Books\Windows Contacts") Then
FileMove(@ProgramsCommonDir & "\Windows Contacts.lnk", @ProgramsCommonDir & "\Office\Address Books\Windows Contacts", 1)
EndIf
; Windows DVD Maker
If Not FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows DVD Maker") Then
DirCreate(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows DVD Maker")
EndIf
If FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows DVD Maker") Then
FileMove(@ProgramsCommonDir & "\Windows DVD Maker.lnk", @ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows DVD Maker", 1)
EndIf
; Windows Easy Transfer
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows Easy Transfer") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Windows Easy Transfer")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows Easy Transfer") Then
FileCopy(@ProgramsCommonDir & "\Accessories\System Tools\Windows Easy Transfer.lnk", @ProgramsCommonDir & "\Windows Utilities\Windows Easy Transfer", 1)
EndIf
; Windows Firewall
If Not FileExists(@ProgramsCommonDir & "\Security\Firewalls\Windows Firewall") Then
DirCreate(@ProgramsCommonDir & "\Security\Firewalls\Windows Firewall")
EndIf
If FileExists(@ProgramsCommonDir & "\Security\Firewalls\Windows Firewall") Then
FileCopy(@ScriptDir & "\Icons\Windows Firewall.lnk", @ProgramsCommonDir & "\Security\Firewalls\Windows Firewall", 1)
EndIf
; Windows Mail
If Not FileExists(@ProgramsCommonDir & "\Internet\Email\Windows Mail") Then
DirCreate(@ProgramsCommonDir & "\Internet\Email\Windows Mail")
EndIf
If FileExists(@ProgramsCommonDir & "\Internet\Email\Windows Mail") Then
FileMove(@ProgramsCommonDir & "\Windows Mail.lnk", @ProgramsCommonDir & "\Internet\Email\Windows Mail", 1)
EndIf
; Windows Media Center
If Not FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Media Players\Windows Media Center") Then
DirCreate(@ProgramsCommonDir & "\Audio-Data-Video\Media Players\Windows Media Center")
EndIf
If FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Media Players\Windows Media Center") Then
FileMove(@ProgramsCommonDir & "\Windows Media Center.lnk", @ProgramsCommonDir & "\Audio-Data-Video\Media Players\Windows Media Center", 1)
EndIf
; Windows Media Player
If Not FileExists(@ProgramsDir & "\Audio-Data-Video\Media Players\Windows Media Player") Then
DirCreate(@ProgramsDir & "\Audio-Data-Video\Media Players\Windows Media Player")
EndIf
If FileExists(@ProgramsDir & "\Audio-Data-Video\Media Players\Windows Media Player") Then
FileMove(@ProgramsDir & "\Windows Media Player.lnk", @ProgramsDir & "\Audio-Data-Video\Media Players\Windows Media Player", 1)
EndIf
; Windows Meeting Space
If Not FileExists(@ProgramsCommonDir & "\Internet\Chat\Windows Meeting Space") Then
DirCreate(@ProgramsCommonDir & "\Internet\Chat\Windows Meeting Space")
EndIf
If FileExists(@ProgramsCommonDir & "\Internet\Chat\Windows Meeting Space") Then
FileMove(@ProgramsCommonDir & "\Windows Meeting Space.lnk", @ProgramsCommonDir & "\Internet\Chat\Windows Meeting Space", 1)
EndIf
; Windows Movie Maker
If Not FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows Movie Maker") Then
DirCreate(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows Movie Maker")
EndIf
If FileExists(@ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows Movie Maker") Then
FileMove(@ProgramsCommonDir & "\Windows Movie Maker.lnk", @ProgramsCommonDir & "\Audio-Data-Video\Video Editing\Windows Movie Maker", 1)
EndIf
; Windows Photo Gallery
If Not FileExists(@ProgramsCommonDir & "\Photos-Graphics\Photo Editing\Windows Photo Gallery") Then
DirCreate(@ProgramsCommonDir & "\Photos-Graphics\Photo Editing\Windows Photo Gallery")
EndIf
If FileExists(@ProgramsCommonDir & "\Photos-Graphics\Photo Editing\Windows Photo Gallery") Then
FileMove(@ProgramsCommonDir & "\Windows Photo Gallery.lnk", @ProgramsCommonDir & "\Photos-Graphics\Photo Editing\Windows Photo Gallery", 1)
EndIf
; Windows Sidebar Properties
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows Sidebar Properties") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Windows Sidebar Properties")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows Sidebar Properties") Then
FileCopy(@ScriptDir & "\Icons\Windows Sidebar Properties.lnk", @ProgramsCommonDir & "\Windows Utilities\Windows Sidebar Properties", 1)
EndIf
; Windows SideShow
If Not FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows SideShow") Then
DirCreate(@ProgramsCommonDir & "\Windows Utilities\Windows SideShow")
EndIf
If FileExists(@ProgramsCommonDir & "\Windows Utilities\Windows SideShow") Then
FileCopy(@ScriptDir & "\Icons\Windows SideShow.lnk", @ProgramsCommonDir & "\Windows Utilities\Windows SideShow", 1)
EndIf
; Windows Update
If Not FileExists(@ProgramsCommonDir & "\Maintenance\Updates\Windows Update") Then
DirCreate(@ProgramsCommonDir & "\Maintenance\Updates\Windows Update")
EndIf
If FileExists(@ProgramsCommonDir & "\Maintenance\Updates\Windows Update") Then
FileMove(@StartMenuCommonDir & "\Windows Update.lnk", @ProgramsCommonDir & "\Maintenance\Updates\Windows Update", 1)
EndIf
; WordPad
If Not FileExists(@ProgramsCommonDir & "\Office\WordPads\Windows WordPad") Then
DirCreate(@ProgramsCommonDir & "\Office\WordPads\Windows WordPad")
EndIf
If FileExists(@ProgramsCommonDir & "\Office\WordPads\Windows WordPad") Then
FileCopy (@ProgramsCommonDir & "\Accessories\WordPad.lnk", @ProgramsCommonDir & "\Office\WordPads\Windows WordPad", 1)
EndIf
TrayTip('Windows Vista Essentials Cleanup', 'This Dirty Deed Has Been Completed', 5)
Sleep(2000)
Exit



