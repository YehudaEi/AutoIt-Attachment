#include <Date.au3>
#include <File.au3>
#include <String.au3>





While 1
	RUN("C:\Program Files\Stellar Phoenix Outlook PST Repair\StellarPhoenixPSTfileSplitter.exe")
	WinWait("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "" , 1000)
	WinActivate("Öffnen")
	WinWaitActive("Öffnen")
	$file = FileOpen(@DesktopDir&"\FilesFND.txt", 0 )
	$line = FileReadLine($file)
	If @error = -1 Then ExitLoop
	Send($line)
	Send("{ENTER}")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "",  1004)
	WinActivate("Ordner" , "")
	WinWaitActive("Ordner" , "")
	ControlClick("Ordner" , "", 100, "left", 1, 56, 50)
	ControlClick("Ordner", "" , 100, "left" , 1 , 32, 79)
	ControlClick("Ordner" , "", 100, "left", 1, 141, 78)
	$Name = FileOpen(@DesktopDir&"\Ordner Test Namen.txt", 0)
	$Ordner = FileReadLine($Name)
	Sleep(200)
	ControlClick("Ordner" , "", 14150)	
	Send($Ordner)
	Send("{ENTER}")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "", 1005)
	WinActivate("Split PST" , "Split PST File")
	WinWaitActive("Split PST" , "Split PST File")
	ControlClick("Split", "", 1085)
	ControlClick("Split", "", 1082, "left", 1, 251,11)
	$Year = @YEAR - 2
	$MonthCalc = _DateDiff( 'm',$Year & "/01/01", _NowCalc())
	$Month = $MonthCalc
			While $Month > 0
				Send( "{PGUP}")
				$Month = $Month - 1
			WEnd
	$DayCalc = _DateDiff( 'd',@YEAR & "/" & @MON & "/01", _NowCalc())
	$Day = 31 - $DayCalc
			While $Day < 31 
				Send("{LEFT}")
				$Day = $Day + 1
			WEnd	
	;Send("{Enter}")
	;Send("{Enter}")
	Sleep(12000)
	;RUN("C:\Program Files\Stellar Phoenix Outlook PST Repair\StellarPhoenixPSTfileSplitter.exe")
	WinWait("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "" , 1000)
	WinActivate("Öffnen")
	WinWaitActive("Öffnen")
	Send($line)
	Send("{ENTER}")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "",  1004)
	WinActivate("Ordner" , "")
	WinWaitActive("Ordner" , "")
	ControlClick("Ordner" , "", 100, "left", 1, 56, 50)
	ControlClick("Ordner", "" , 100, "left" , 1 , 32, 79)
	ControlClick("Ordner" , "", 100, "left", 1, 141, 78)
	$name = FileOpen(@DesktopDir&"\Archiv Test Namen.txt", 0)
	$Archiv = FileReadLine($name)
	Sleep(100)
	ControlClick("Ordner" , "", 14150)	
	Send($Archiv)
	Send("{ENTER}")
	WinActivate("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	WinWaitActive("Stellar Phoenix PST File Splitter" , "Select Outlook Data File (PST) :")
	ControlClick("Stellar", "", 1005)
	WinActivate("Split PST" , "Split PST File")
	WinWaitActive("Split PST" , "Split PST File")
	ControlClick("Split", "", 1085)
	ControlClick("Split", "", 1082, "left", 1, 251,11)
	$Year = @YEAR - 2
	$MonthCalc = _DateDiff( 'm',$Year & "/01/01", _NowCalc())
	$Month = $MonthCalc
		While $Month > 0
				Send( "{PGUP}")
				$Month = $Month - 1
		WEnd
	$DayCalc = _DateDiff( 'd',@YEAR & "/" & @MON & "/01", _NowCalc())
	$Day = 31 - $DayCalc
		While $Day < 32 
				Send("{LEFT}")
				$Day = $Day + 1
		WEnd
	Send("{ENTER}")
	ControlClick("Split", "", 1083, "left", 1, 254,18)
	$Year = @YEAR - 19
	$MonthCalc = _DateDiff( 'm',$Year & "/01/01", _NowCalc())
	$Month = $MonthCalc
		While $Month > 0
				Send( "{PGUP}")
				$Month = $Month - 1
		WEnd
	$DayCalc = _DateDiff( 'd',@YEAR & "/" & @MON & "/01", _NowCalc())
	$Day = 31 - $DayCalc
		While $Day < 31 
				Send("{LEFT}")
				$Day = $Day + 1
		WEnd
	;Send("{ENTER}")
	;Send("{ENTER}") 
	Sleep(12000)
WEnd