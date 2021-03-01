;Places the input box in the top left corner displaying the characters as they
;are typed.
Local $answer = InputBox("Info needed!!!", "Need Computer Name", "", "", _
		 - 1, -1, 0, 0)

; Write a single REG_ value
RegWrite ("\\$answer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Print\Printers\HP LaserJet P2050 Series PCL6\PrinterDriverData", "SSNPNotifyEventSetting", "REG_DWORD", "0")


