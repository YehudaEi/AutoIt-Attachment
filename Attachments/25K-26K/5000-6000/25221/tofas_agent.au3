; AutoIt Version: v3.2.10.0
; Author: Fatih TALI Koç SYSTEM Saha Hizmetleri
; Script Function: Tofaþ Startup Agent
; ----------------------------------------------------------------------------

#include <file.au3>
#Include <Array.au3>
Dim $serverARRAY
Dim $pcARRAY
			$USERNAME = "xxxxxx"
			$DOMAIN	= "xxxxxx"
			$PASSWORD ="xxxxx"
			$date =@MDAY&"."&@MON&"."&@YEAR&"."&@HOUR&":"&@MIN&":"&@SEC
			Opt("TrayIconHide", 1) ;un-hide the icon
FileWriteLine("\\server\Utility\agent\agent.log",""&@ComputerName&".domain.local,"&@OSVersion&","&@OSServicePack&","&$date)	;---------------hearth beet	
	
	; reading server side ini. 
	If Not _FileReadToArray("\\server\Utility\agent\jobs.ini",$serverARRAY) Then
	Exit
	EndIf

		if not FileExists("C:\SYSTEM\JObs_PC.ini") Then
		DirCreate ( "C:\SYSTEM" )
		_FileCreate("C:\SYSTEM\JObs_PC.ini")
		$file = FileOpen("C:\SYSTEM\JObs_PC.ini", 1)
		FileWriteLine($file ,"[--------------------------------------------------------------------------]")
		FileWriteLine($file ,"[..Plese dont change this file. If you change program can not work well....]")
		FileWriteLine($file ,"[-----------------------Only restrict people can change--------------------]")
		FileWriteLine($file ,"[--------------------------------------------------------------------------]")
		FileClose($file)
		EndIf
					;-------server side file reading and making array from it.
					If Not _FileReadToArray("C:\SYSTEM\JObs_PC.ini",$pcARRAY) Then
				;	MsgBox(16,"Error.", "c:\SYSTEM couldnt creat or reding error..." )
					Exit
					EndIf
			;--- comparing arrays
			For $x = 5 to $serverARRAY[0]
			$Flag = 0
			For $y = 5 to $pcARRAY[0]		
			If $serverARRAY[$x]=$pcARRAY[$y] then 
					
			$Flag = 1
			ExitLoop
			endif 
			Next
			if $flag = 0 then
			RunASWait($USERNAME,$DOMAIN,$PASSWORD,0,$serverARRAY[$x], @SystemDir)	
			Endif
			Next
			Exit


