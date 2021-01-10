#include <array.au3>

; #_Printers_Add_Remove_Shared# ;===============================================================================
;
; Name...........: _Printers_Add_Shared
; Description ...: Adds Network Printers and can set a default printer of those added
; Syntax.........: _Printers_Add_Shared($sMapPrinters,$iOverrideDefaultPrinter=0)
; Parameters ....: $sMapPrinters - Enter the combination of Server\PrinterShare\1, or Server\PrinterShare,
;                   $iOverrideDefaultPrinter - Optionally to override the current default with with the one you select. Value of 1 for yes; 0 or nothing for no
; Return values .: Success - Adds a network printer(s) and sets a default printer.
;                  Failure - Returns 0 and Sets @Error:
;                  |0 - No error.
;                  |1 - Invalid $sMapPrinters - The string is incorrectly entered
;                  |2 - Invalid $iOverrideDefaultPrinter - Must be a 1 or 0
; Author ........: Christopher St.Amand
; Modified.......: 2008/08/08
; Remarks .......:	
; Related .......: 
; Link ..........;	
; Example .......; Yes
; 	_Printers_Add_Shared("Server1\Printer1\1,Server1\Printer2,Server2\Printer1,Server2\Printer5\-1",1)
; 	_Printers_Add_Shared("\\Server1\Printer1\1",1)
; 	_Printers_Add_Shared("\\Server1\Printer1,Server1\Printer2,Server2\Printer1,\\Server2\Printer5\1")
;	_Printers_Add_Shared("Server1\Printer1\1")
;
;	v1.6 - Fixed an error when compiling and running script
;	v1.5 - Added the ability to remove a shared printer with a -1  ; Changed UDF name to _Printers_Add_Remove_Shared
;	v1.4 - Changed so that you don't need a comma at the end when you are attaching only one printer
;	v1.3 - Added a var that sets if a printer was added and only then will it restart spooler, else it doesn't; Converted script to standard UDF
;	v1.2 - Fixed a return value that was screwey
;	v1.1 - Fixed issue with only adding one printer; after the printer line just add a comma like so Server1\Printer1\1,
;	v1.0 - First release with only support for shared network printers, set default printer and override the previous default printer
;
; ;==========================================================================================

Func _Printers_Add_Remove_Shared($sMapPrinters,$iOverrideDefaultPrinter=0)
	Local $aSplitMapPrintersString, $aSplitMapPrintersString, $aLastPrinterSplit, $sRead_PrintServerKey, $sRead_PrinterPortkey, $sDefaultPrinter
	Local $aSplitPrinterPortKey, $iPrinterAdded = 0, $iPrinterRemoved = 0
	Select
		Case StringInStr($sMapPrinters,",") <> 0 and StringInStr($sMapPrinters,"\") <> 0 ; Check for printers
			$aSplitMapPrintersString = StringSplit($sMapPrinters,",")
			
			For $f = 1 to $aSplitMapPrintersString[0]
				If StringLeft($aSplitMapPrintersString[$f],2) = "\\" Then
					$aPrintersString = StringTrimLeft($aSplitMapPrintersString[$f],2)
				Else
					$aPrintersString = $aSplitMapPrintersString[$f]
				Endif
				If StringInStr($aPrintersString,"\") Then
					$aLastPrinterSplit = StringSplit($aPrintersString,"\")
					$sRead_PrintServerKey = RegRead("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Server")
					Select
						Case $sRead_PrintServerKey = "" and StringInStr($aPrintersString,-1)=0
							RegWrite("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Server","REG_SZ",$aLastPrinterSplit[1])
							sleep(100)
							RegWrite("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Provider","REG_SZ","win32spl.dll")
							sleep(100)
							$iPrinterAdded = 1
							
						Case $sRead_PrintServerKey = "\\"& $aLastPrinterSplit[1]
							; Printer Already added!
							
					EndSelect
					sleep(100)
					If $aLastPrinterSplit[0] = 3 Then
						Select
							Case $aLastPrinterSplit[3] = "1"
								$sDefaultPrinter = "\\"& $aLastPrinterSplit[1] &"\"& $aLastPrinterSplit[2]
							
							Case $aLastPrinterSplit[3] = "-1" and $sRead_PrintServerKey <> ""
								RegDelete("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2])
								$iPrinterRemoved = 1
							
						EndSelect
					Endif
					
				EndIf
			Next
		
		Case StringInStr($sMapPrinters,",") = 0 and StringInStr($sMapPrinters,"\") <> 0
			If StringLeft($sMapPrinters,2) = "\\" Then
				$aPrintersString = StringTrimLeft($sMapPrinters,2)
			Else
				$aPrintersString = $sMapPrinters
			Endif
			If StringInStr($aPrintersString,"\") Then
				$aLastPrinterSplit = StringSplit($aPrintersString,"\")
				$sRead_PrintServerKey = RegRead("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Server")
				Select
					Case $sRead_PrintServerKey = "" and StringInStr($aPrintersString,-1)=0
						RegWrite("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Server","REG_SZ",$aLastPrinterSplit[1])
						sleep(100)
						RegWrite("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2],"Provider","REG_SZ","win32spl.dll")
						sleep(100)
						$iPrinterAdded = 1
							
					Case $sRead_PrintServerKey = "\\"& $aLastPrinterSplit[1]
						; Printer Already added!
							
				EndSelect
					
				If $aLastPrinterSplit[0] = 3 Then
					Select
						Case $aLastPrinterSplit[3] = "1"
							$sDefaultPrinter = "\\"& $aLastPrinterSplit[1] &"\"& $aLastPrinterSplit[2]
							
						Case $aLastPrinterSplit[3] = "-1" and $sRead_PrintServerKey <> ""
							RegDelete("HKEY_CURRENT_USER\Printers\Connections\,,"& $aLastPrinterSplit[1] &","& $aLastPrinterSplit[2])
							$iPrinterRemoved = 1
							
					EndSelect
				Endif
					
			EndIf
		
		Case Else
			Return 1
			
	EndSelect
		
	; Restarts the print services if a printer was added
	If $iPrinterAdded = 1 or $iPrinterRemoved = 1 Then
		runwait(@comspec &" /c net stop spooler",@WindowsDir,@SW_HIDE)
		runwait(@comspec &" /c net start spooler",@WindowsDir,@SW_HIDE)
	EndIf
	
	Select
		Case StringIsDigit($iOverrideDefaultPrinter) <> 1 and ($iOverrideDefaultPrinter <> 1 or $iOverrideDefaultPrinter <> 0)
			return 2 ; Error that the string is not a digit or is not a 0 or 1
		
		Case $sDefaultPrinter <> "" and $iOverrideDefaultPrinter = 1
			$sRead_PrinterPortkey = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\PrinterPorts",$sDefaultPrinter)
			If $sRead_PrinterPortkey <> "" or $iOverrideDefaultPrinter = 1 Then ; If there's no printer that's already set or override is 1
				$aSplitPrinterPortKey = StringSplit($sRead_PrinterPortkey,":") ; Split to get data we need, everything before the colon
				RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows","Device","REG_SZ",$sDefaultPrinter &","& $aSplitPrinterPortKey[1] &":")
			Endif
			
	EndSelect
	
	Return 0
EndFunc