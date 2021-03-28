#include <Constants.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>

Local Const $sFilePath = "C:\Docume~1\Admin\Desktop\PatientIDList.txt"
Local $sFileRead

Local $logFile = FileOpen("C:\Docume~1\Admin\Desktop\logfile.txt", 1)

_FileWriteLog($logFile, "Start")

Local $hFileOpen = FileOpen($sFilePath, $FO_READ)
If $hFileOpen = -1 Then
  MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
  Exit
EndIf

; Read the fist line of the file using the handle returned by FileOpen.
$sFileRead = FileReadLine($hFileOpen, 1)

; Close the handle returned by FileOpen.
FileClose($hFileOpen)

_FileWriteLog($logFile, "ChartID: " & $sFileRead)

do
   ;;Wait for the dentrix window to be active
   WinWaitActive("[REGEXPTITLE:(?i)(.*Dentrix Chart.*)]")

   _FileWriteLog($logFile, "Dentrix is Active.")

   ;skip anything less then 1000 as it takes to long to look up the patient
   ;If StringLen($sFileRead) > 3 Then
	  Send("{F2}")

	  WinWaitActive("Select Patient")

	  _FileWriteLog($logFile, "Patient Search is active.")
	  Sleep(250)
	  ;Do
	  ;	Sleep(250)
	  ;Until MouseGetCursor() = 2
	  Send($sFileRead)
	  ;Do
	  ;	Sleep(250)
	  ;Until MouseGetCursor() = 2
	  Send("{enter}")
	  Sleep(250)

	  ;Wait till a dialog box opens while trying to open a record, when it successfully opens the dialog box you know
	  ;that the search is complete
	  Do
		 Send("!o")
		 Sleep(250)
		 $title = WinGetTitle("")
	  Until StringInStr($title, "Enterprise Dentrix Dtxdlgs")

	  ;select the first result
	  Send("{esc}")
	  Send("{tab}")
	  Send("{down}")
	  Send("!o")

	  _FileWriteLog($logFile, "Opening Chart.")

	  $title = WinGetTitle("")
	  ;wait for the title to contain the chart ID, then we know it loaded the patient
	  Do
		 Sleep(500)

		 $title = WinGetTitle("")

		 ;OK your way through all the patient alerts
		 if StringInStr($title, "Patient Alert") Then
			Send("{enter}")
		 EndIf


		 _FileWriteLog($logFile, "Waiting for chart to open." & $title)
	  Until StringInStr($title, "[" & $sFileRead & "]")
	  ;Do
	  ;  Sleep(500)
	  ;Until MouseGetCursor() = 2
	  ;_FileWriteLog($logFile, "Mouse is arrow.")
	  Do
		 Send("!h")
		 Send("a")
		 Sleep(500)
		 $title = WinGetTitle("")
	  Until StringInStr($title, "About Chart")

	  Send("{esc}")
	  _FileWriteLog($logFile, "Chart is Open." & $title)
	  ;Sleep(10000)
	  Send("!f")
	  ;Sleep(100)
	  Send("w")

	  _FileWriteLog($logFile, "attempted to open file menu.")

	  WinWaitActive("[REGEXPTITLE:(?i)(.*Print Progress Notes.*)]")

	  _FileWriteLog($logFile, "Progress Notes is Active.")

	  Send("{enter}")

	  ;in pdfcreator name the file, remove the created by and 'print'
	  WinWaitActive("PDFCreator 1.7.3")
	  Send("{tab}")
	  Send($sFileRead)
	  Send("{tab}")
	  Send("{tab}")
	  Send("{tab}")
	  Send("{tab}")
	  Send("{tab}")
	  Send("{backspace}")
	  Send("{enter}")

	  _FileWriteLog($logFile, "Saving File.")

	  ;save the file
	  WinWaitActive("Save as")
	  Send("{enter}")

	  _FileWriteLog($logFile, "Saving File 2.")

	 $activeWindowID = WinGetHandle("")

	 ;_FileWriteLog($logFile, $activeWindowID)

	  $title = WinGetTitle("")
	  ;wait for the title to contain the chart ID, then we know it loaded the patient
	  Do
		 Sleep(500)
		 ;confirm overwrite file if the file already exists
		 ;_FileWriteLog($logFile, $activeWindowID)
		 if StringInStr($title, "Save as") Then
			Send("{left}")
			Send("{enter}")
			_FileWriteLog($logFile, "Overwrite confirmed.")
		 EndIf

		 $title = WinGetTitle("")

	  Until StringInStr($title, "Dentrix Chart")

	  _FileWriteLog($logFile, "Dentrix is Active.")
   ;EndIf

   ;;remove the first entry from the list
   Send(_FileWriteToLine("C:\Documents and Settings\Admin\Desktop\PatientIDList.txt",1,"", 1))

   ;get the next chartID
   $hFileOpen = FileOpen($sFilePath, $FO_READ)
   If $hFileOpen = -1 Then
	 MsgBox($MB_SYSTEMMODAL, "", "An error occurred when reading the file.")
	 Exit
   EndIf

   ; Read the fist line of the file using the handle returned by FileOpen.
   $sFileRead = FileReadLine($hFileOpen, 1)

   ; Close the handle returned by FileOpen.
   FileClose($hFileOpen)

   _FileWriteLog($logFile, "ChartID: " & $sFileRead)

Until StringLen ($sFileRead) = 0

_FileWriteLog($logFile, "Finished.")

FileClose($logFile)
Exit

