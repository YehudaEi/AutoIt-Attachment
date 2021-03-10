Run("Crucial_010G_SSDFirmware_Update.exe")
if WinWaitActive("Nothing to Update", "There are no SSDs on your system that need to be updated.") Then
	; In this case either the system does not have the appropriate Crucial SSD or...
	; it is already on the version specified by the utility.
	Send("{Enter}")
	; Just close the SSD firmware update utility.
ElseIf WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.") Then
	; In this case the proper drive is in the PC *and* it requires a firmware update.
	; Proceed with update.
	Send("{TAB}{ENTER}")
	WinWaitActive("Crucial SSD Firmware Update Utility", "PLEASE READ THIS LICENSE AGREEMENT")
	Send("{TAB}{TAB}{ENTER}")
	WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.")
	WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.")
	Send("{TAB}{ENTER}")
endif