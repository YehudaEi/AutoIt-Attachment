Run("m4_SSD_Firmware_Update_Utility_000F.exe")
WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.")
Send("{TAB}{ENTER}")
WinWaitActive("Crucial SSD Firmware Update Utility", "PLEASE READ THIS LICENSE AGREEMENT")
Send("{TAB}{TAB}{ENTER}")
WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.")
WinWaitActive("Crucial SSD Firmware Update Utility", "This program will update the firmware on your Crucial SSD.")
Send("{TAB}{ENTER}")

;Nothing to Update - If drive is not present OR if firmware is already updated.
	;Message:  "There are no SSDs on your system that need to be updated."
	;"Quit Now" button has focus.
	;Just need to press <Enter>.