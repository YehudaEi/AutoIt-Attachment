; =====================================================================================
; ==       WSS FTP Backup Controller
; ==
; == Developed and maintained By The Workspace Solution, Inc.
; == The Workspace Solution, Inc  Copyright September, 2009
; == GUI generated with Koda and AutoIt
; ==
; == Change history
; == -
; =====================================================================================
#include <FTP.au3>
#Include <File.au3>
#include <Array.au3> ;only used to dispay the return value of the _FTPFileFind* functions
#include <GuiEdit.au3>
#include <GuiConstantsEx.au3>
#include <WinAPI.au3>
#include <Date.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <GUIListBox.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#Include <Timers.au3>
#include <ProgressConstants.au3>

Opt('MustDeclareVars', 1)

Global $sFTPServer, $sUsername, $sPWD, $sLocalDir, $sRemoteDir
Dim $aRecords
Dim $HConn
Dim $DllRect
Dim $server
Dim $username
Dim $pass
Dim $DllRect
Dim $dllstruct
Dim $Result
Dim $sJulDate, $TimeVal, $sCurJulDate, $CurTimeVal
Dim $ArchControl = 0			; 0=based on date/time, 1=all files
Dim $ArchFolder = 1				; 0 = files by mod date or 1 = entire folder
Dim $sRecursive = 1				; 0 = just current folder or 1 = include subfolders
Dim	$sRemoteRoot = "/sdrive"	; Remote root of archived FTP account
Dim $sRecords
Dim $deltaTime
Dim $sSelectedDir
Dim $xfrCount
Dim $optFile = "c:\FTPFiles\FTPDefault.txt"
Dim $SYSTEMTIME = "ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort"
Dim $FILETIME = "uint;uint"

Local $FTPForm,$lblserver,$inpServer,$inpUserId,$inpPassword,$inpLocDir,$btnSelFolder
Local $inpRmtDir,$btnSingleRight,$btnAllRight,$btnSingleLeft,$btnAllLeft,$btnSend
Local $btnCancel,$ListBox1,$ListBox2,$lbluser,$lblpassword,$lbllocaldir,$lblremotedir
Local $lblDirFiles,$lblSelFiles,$MenuFile,$MenuFileNew,$MenuFileSave,$MenuFileOpen
Local $MenuFileClear,$SubMenuLocFiles,$SubMenuSelFiles,$MenuFileExit,$MenuOptions
Local $MenuOptionsGetDefault,$MenuOptionsSetDefault,$MenuHelp,$MenuHelpAbout
Local $nMsg

#cs
	typedef struct _FILETIME {
	DWORD dwLowDateTime;
	DWORD dwHighDateTime;
	} FILETIME,
#ce
#cs
	typedef struct _SYSTEMTIME {
	WORD wYear;
	WORD wMonth;
	WORD wDayOfWeek;
	WORD wDay;
	WORD wHour;
	WORD wMinute;
	WORD wSecond;
	WORD wMilliseconds;
	} SYSTEMTIME,
#ce
#Region ### START Koda GUI section ### Form=c:\users\wssdevel.thewssinc\scripts\ftpform3.kxf
$FTPForm = GUICreate("WSS FTP Archive Manager", 696, 487, 251, 162)
$lblserver = GUICtrlCreateLabel("Server:", 24, 48, 38, 17)
$inpServer = GUICtrlCreateInput("", 96, 48, 169, 21)
$inpUserId = GUICtrlCreateInput("", 96, 72, 169, 21)
$inpPassword = GUICtrlCreateInput("", 96, 96, 169, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$inpLocDir = GUICtrlCreateInput("", 96, 120, 369, 21)
$btnSelFolder = GUICtrlCreateButton("Select Folder", 482, 120, 115, 25, 0)
$inpRmtDir = GUICtrlCreateInput("", 96, 144, 369, 21)
$btnSingleRight = GUICtrlCreateButton(">", 329, 219, 30, 25)
$btnAllRight = GUICtrlCreateButton(">>", 329, 252, 31, 25)
$btnSingleLeft = GUICtrlCreateButton("<", 330, 285, 31, 25)
$btnAllLeft = GUICtrlCreateButton("<<", 330, 318, 32, 25)
$btnSend = GUICtrlCreateButton("Send", 237, 429, 75, 25)
$btnCancel = GUICtrlCreateButton("Cancel", 373, 429, 75, 25)
$ListBox1 = GUICtrlCreateList("", 15, 212, 300, 201, BitOR($LBS_SORT,$LBS_MULTIPLESEL,$LBS_STANDARD,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
$ListBox2 = GUICtrlCreateList("", 373, 212, 300, 201, BitOR($LBS_SORT,$LBS_MULTIPLESEL,$LBS_STANDARD,$WS_HSCROLL,$WS_VSCROLL,$WS_BORDER))
GUICtrlSetData(-1, "")
$lbluser = GUICtrlCreateLabel("User ID:", 24, 72, 43, 17)
$lblpassword = GUICtrlCreateLabel("Password:", 24, 96, 53, 17)
$lbllocaldir = GUICtrlCreateLabel("Local Directory", 8, 123, 80, 17)
$lblremotedir = GUICtrlCreateLabel("Remote Directory", 8, 144, 86, 17)
$lblDirFiles = GUICtrlCreateLabel("Local Directory Files", 24, 192, 99, 17)
$lblSelFiles = GUICtrlCreateLabel("Selected Files to transfer", 382, 192, 120, 17)
$MenuFile = GUICtrlCreateMenu("&File")
$MenuFileNew = GUICtrlCreateMenuItem("&New", $MenuFile)
$MenuFileSave = GUICtrlCreateMenuItem("&Save Archive List", $MenuFile)
$MenuFileOpen = GUICtrlCreateMenuItem("&Open Archive List", $MenuFile)
$MenuFileClear = GUICtrlCreateMenu("&Clear", $MenuFile)
$SubMenuLocFiles = GUICtrlCreateMenuItem("&Local directory file list", $MenuFileClear)
$SubMenuSelFiles = GUICtrlCreateMenuItem("S&elected file list", $MenuFileClear)
$MenuFileExit = GUICtrlCreateMenuItem("Exit", $MenuFile)
$MenuOptions = GUICtrlCreateMenu("&Options")
$MenuOptionsGetDefault = GUICtrlCreateMenuItem("Get Default Login Info", $MenuOptions)
$MenuOptionsSetDefault = GUICtrlCreateMenuItem("Set Default Login Info", $MenuOptions)
$MenuHelp = GUICtrlCreateMenu("&Help")
$MenuHelpAbout = GUICtrlCreateMenuItem("About", $MenuHelp)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg(1)
	Switch $nMsg[0]
		Case $btnSelFolder
            select_folder()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnCancel, $MenuFileExit
			GUIDelete($FTPForm)
			Exit
		Case $MenuFileNew
            emptyListbox($ListBox1)
            emptyListbox($ListBox2)
		Case $MenuFileNew
            emptyListbox($ListBox1)
            emptyListbox($ListBox2)
		Case $SubMenuLocFiles
			emptyListbox($ListBox1)
		Case $SubMenuSelFiles
			emptyListbox($ListBox2)
		Case $btnSingleRight
			moveFile("right")
		Case $btnSingleLeft
			moveFile("left")
		Case $btnAllRight
			moveAllFiles("right")
		Case $btnallLeft
			moveAllFiles("left")
		Case $btnSend
			$xfrCount = SendFiles($optFile)
		Case $MenuFileSave
			SaveFileList()
		Case $MenuFileOpen 
			GetFileList()
		Case $MenuOptionsGetDefault
			GetDefault($optFile)
		Case $MenuOptionsSetDefault 
			OptionPanel($optFile)
		Case $MenuHelpAbout
			About()
	EndSwitch
WEnd
Exit
;===============================================================================
; Function Name:    SendFiles()
; Description:      Connects to FTP server then if successful, sends files listed
;					in listbox2
; Parameter(s):     $optFile = 	File containing FTP login info.
; Requirement(s):   Must have files in listbox2 and correct FTP server info.
; Return Value(s):  $Return - 1 = Number of files transferred
;							  0 = Failed. No files transferred
; Author(s):        Stuart Sherlock
;===============================================================================
Func SendFiles($optFile)
	Local $hFTP,$hFile,$hSess
	Local $s = 0; progressbar-saveposition
	Local $sLocalFile,$sRemoteFile,$sFile,$sLocalPathFile
	Local $difTime, $Result
	Local $i,$ans,$FileSize, $TotalFileSizes
	Local $frmSend, $btnDone,$btnCan,$edtSend,$Progress1
	Local $Listbox2count = _GUICtrlListBox_GetCount($ListBox2)
	
	$sFTPServer = _GUICtrlEdit_GetText($inpServer)
	$sUsername = _GUICtrlEdit_GetText($inpUserId)
	$sPWD = _GUICtrlEdit_GetText($inpPassword)
	$sLocalDir = _GUICtrlEdit_GetText($inpLocDir)
	$sRemoteDir = _GUICtrlEdit_GetText($inpRmtDir)
	
	; If FTP server info is empty then look for saved info. If empty there
	; then message to user to fill in.
	if $sFTPServer = "" Then
		$ans = MsgBox(4, "FTP Error", "The FTP server information is empty, do you wish"&@LF& _
						"to try your saved FTP info? If not, please enter the required info.")
		if $ans = 6 Then
			if FileExists($optFile) Then
				$hFile = FileOpen($optFile, 0)
				$sFTPServer = FileReadLine($hFile, 1)
				if $sFTPServer = -1 Then
					MsgBox(4096, "File Error Message", "There is no FTP login information saved."&@LF& _
								"Please file in the FTP server login infomation. If you wish to "&@LF& _
								"save the login information, the click on option menu.")
				Else
					$sUsername = FileReadLine($hFile, 2)
					$sPWD = FileReadLine($hFile, 3)
					$sRemoteDir = FileReadLine($hFile, 5)
					_GUICtrlEdit_SetText($inpServer, $sFTPServer)
					_GUICtrlEdit_SetText($inpUserId, $sUsername)
					_GUICtrlEdit_SetText($inpPassword, $sPWD)
					_GUICtrlEdit_SetText($inpRmtDir, $sRemoteDir)
				EndIf
				FileClose($hFile)
			EndIf
		EndIf
	EndIf
;	MsgBox(0,"ftp info status","ftp server = "&$sFTPServer&@LF& _
;								"ftp user = "&$sUsername&@LF& _
;								"password = "&$sPWD&@LF& _
;								"Remote dir = "&$sRemoteDir)
	If $Listbox2count <= 0 Then
		MsgBox(4096, "FTP Error", "Need to select files to FTP. Please load files from "&@LF& _
					"a directory then select one or more files to FTP. ")
	Else
		$hSess = FTPConnect($sFTPServer, $sUsername, $sPWD, $hFTP)

		#Region ### START Koda GUI section ### Form=c:\users\wssdevel\scripts\frmSend.kxf
		$frmSend = GUICreate("FTP Send", 348, 296, 347, 263)
		GUISetIcon("D:\003.ico")
		$btnDone = GUICtrlCreateButton("&Done", 65, 259, 75, 25, 0)
		GUICtrlSetState($btnDone, $GUI_DISABLE)
		$btnCan = GUICtrlCreateButton("&Cancel", 162, 259, 75, 25, 0)
		$edtSend = GUICtrlCreateEdit("", 24, 16, 265, 177, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$WS_VSCROLL))
		GUICtrlSetData(-1, "")
		$Progress1 = GUICtrlCreateProgress(24, 208, 265, 33)
		#EndRegion ### END Koda GUI section ###

		$Result = SetFTPDirectory($hSess, $sRemoteDir, True)
		if $Result > -1 Then
			if $Result = 1 Then	; Set again if directory was created
				SetFTPDirectory($hSess, $sRemoteDir, True)
			EndIf
			; Get total # of bytes to bee tranferred for progress bar
			For $i = 0 to $Listbox2count - 1
				$TotalFileSizes = $TotalFileSizes + FileGetSize(_GUICtrlListBox_GetText($ListBox2, $i))
			Next

			; Transfer since folder is there!
			GUISetState(@SW_SHOW, $frmSend)	; Show dynamic upload status with progress bar
			For $i = 0 To $Listbox2count - 1
				$sLocalPathFile = _GUICtrlListBox_GetText($ListBox2, $i)
				$sRemoteFile = SplitPathFile($sLocalDir, $sLocalPathFile)
;				MsgBox(0, "path and file status after split", "path = "&$sLocalDir&"   file = "&$sRemoteFile)

				$FileSize = PutFile ($hSess, $sLocalPathFile, $sRemoteFile, $difTime)
				$sFile = _GUICtrlListBox_GetText($ListBox2, $i)
;				MsgBox(0, "Send status", "Put file size = "&$FileSize&@LF& _
;										"Session = "&$hSess&@LF& _
;										"Local Path file = "&$sLocalPathFile&@LF& _
;										"Remote file = "&$sRemoteFile&@LF& _
;										"sfile = "&$sFile)
				_GUICtrlEdit_AppendText($edtSend, $sFile&" - "&$difTime&" sec"&@CRLF)

				$s = $s + (100 * $FileSize/$TotalFileSizes)
				GUICtrlSetData($progress1, $s)
				$nMsg = GUIGetMsg(1)
				if $nMsg[1] = $frmSend and $nMsg = $btnCan Then ExitLoop
			Next
;			_ArrayDisplay($fileArray)
			FTPClose($hSess, $hFTP)
			GUICtrlSetState($btnDone, $GUI_ENABLE)
		EndIf
	EndIf
	While 1
		$nMsg = GUIGetMsg(1)
		Switch $nMsg[0]
			Case $btnCan
				GUIDelete($frmSend)
				ExitLoop
			Case $btnDone
				GUIDelete($frmSend)
				ExitLoop
		EndSwitch
	WEnd
	Return $i	; Return # of files transferred
EndFunc ;==>SendFiles
;===============================================================================
; Function Name:    OptionPanel()
; Description:      Popup a option panel to set FTP paramenters to save
; Parameter(s):     $optFile	- Path and file to save parameters
; Requirement(s):   None
; Return Value(s):  None at this time
; Author(s):        Stuart Sherlock
;===============================================================================
Func OptionPanel($optFile)
	Local $hfile
	Local $frmOptions,$GroupBox1,$lblDftserver,$inpDftServer,$inpDftUserId,$inpDftPassword
	Local $inpDftLocDir,$inpDftRmtDir,$lblDftuser,$lblpDftassword,$lblDftlocaldir
	Local $lblDftremotedir,$btnDftSave,$btnDftCan 
	Local $temp
	
	#Region ### START Koda GUI section ### Form=c:\users\wssdevel.thewssinc\scripts\frmoptions.kxf
	$frmOptions = GUICreate("FTP Default Settings", 490, 241, 347, 263, BitOR($WS_MINIMIZEBOX,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS,$DS_MODALFRAME,$DS_SETFOREGROUND))
	GUISetIcon("D:\003.ico")
	$GroupBox1 = GUICtrlCreateGroup("", 8, 1, 473, 193)
	$lblDftserver = GUICtrlCreateLabel("Server:", 29, 31, 38, 17)
	$inpDftServer = GUICtrlCreateInput("", 101, 31, 169, 21)
	$inpDftUserId = GUICtrlCreateInput("", 101, 55, 169, 21)
	$inpDftPassword = GUICtrlCreateInput("", 101, 79, 169, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
	$inpDftLocDir = GUICtrlCreateInput("", 101, 103, 369, 21)
	$inpDftRmtDir = GUICtrlCreateInput("", 101, 127, 369, 21)
	$lblDftuser = GUICtrlCreateLabel("User ID:", 29, 55, 43, 17)
	$lblpDftassword = GUICtrlCreateLabel("Password:", 29, 79, 53, 17)
	$lblDftlocaldir = GUICtrlCreateLabel("Local Directory", 13, 106, 80, 17)
	$lblDftremotedir = GUICtrlCreateLabel("Remote Directory", 13, 127, 86, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$btnDftSave = GUICtrlCreateButton("&Save", 145, 203, 75, 25, 0)
	$btnDftCan = GUICtrlCreateButton("&Cancel", 257, 203, 75, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	if FileExists($optFile) then
		$hfile = FileOpen($optFile, 0)
		; Check if file opened for reading OK
		If $hfile = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
		$temp = FileReadLine($hfile, 1)
		_GUICtrlEdit_SetText($inpDftServer, FileReadLine($hfile, 1))
		_GUICtrlEdit_SetText($inpDftUserId, FileReadLine($hfile, 2))
		_GUICtrlEdit_SetText($inpDftPassword, FileReadLine($hfile, 3))
		_GUICtrlEdit_SetText($inpDftLocDir, FileReadLine($hfile, 4))
		_GUICtrlEdit_SetText($inpDftRmtDir, FileReadLine($hfile, 5))
		FileClose($hfile)
	EndIf
	While 1
		$nMsg = GUIGetMsg(1)
		Switch $nMsg[0]
			Case $GUI_EVENT_CLOSE
				Exit
			Case $btnDftSave
				$hfile = FileOpen($optFile, 10)
				; Check if file opened for reading OK
				If $hfile = -1 Then
					MsgBox(0, "Error", "Unable to open file.")
					Exit
				EndIf
				FileWriteLine($hfile, _GUICtrlEdit_GetText($inpDftServer))
				FileWriteLine($hfile, _GUICtrlEdit_GetText($inpDftUserId))
				FileWriteLine($hfile, _GUICtrlEdit_GetText($inpDftPassword))
				FileWriteLine($hfile, _GUICtrlEdit_GetText($inpDftLocDir))
				FileWriteLine($hfile, _GUICtrlEdit_GetText($inpDftRmtDir))
				FileClose($hfile)
				GUIDelete($frmOptions)
				ExitLoop
			Case $btnDftCan
				GUIDelete($frmOptions)
				ExitLoop
		EndSwitch
	WEnd
EndFunc ;==>OptionPanel
;===============================================================================
; Function Name:    GetDefault()
; Description:      Loads in default FTP paramenters to edit fields
; Parameter(s):     $optFile		- Path and file to save parameters
; Requirement(s):   None
; Return Value(s):  None at this time
; Author(s):        Stuart Sherlock
;===============================================================================
Func GetDefault($optFile)
	Local $hfile
	Local $temp
	
	if FileExists($optFile) then
		$hfile = FileOpen($optFile, 0)
		; Check if file opened for reading OK
		If $hfile = -1 Then
			MsgBox(0, "Error", "Unable to open file.")
			Exit
		EndIf
		$temp = FileReadLine($hfile, 1)
;		MsgBox(0,"first line read", $temp)
		_GUICtrlEdit_SetText($inpServer, FileReadLine($hfile, 1))
		_GUICtrlEdit_SetText($inpUserId, FileReadLine($hfile, 2))
		_GUICtrlEdit_SetText($inpPassword, FileReadLine($hfile, 3))
		_GUICtrlEdit_SetText($inpRmtDir, FileReadLine($hfile, 5))
		FileClose($hfile)
	EndIf
EndFunc ;==>GetDefault
;===============================================================================
; Function Name:    PutFile()
; Description:      Set directory if there otherwise try to create if requested
; Parameter(s):     $HC			- FTP Session
;					$sLDir		- Local directory
;					$sLFile		- Local file
;					$sRFile		- Remote file name to use
; Requirement(s):   Remote directory must be set first
; Return Value(s):  $Return - 1 = Successfully transferred
;							  0 = Failed to transfer
; Author(s):        Stuart Sherlock
;===============================================================================
Func PutFile ($HC, $sFile, $sRFile, ByRef $deltaTime)
	Local $Result
	Local $starttime = _Timer_Init()
	
	$Result = _FTP_PutFile($HC, $sFile, $sRFile)
	$deltaTime = Round(_Timer_Diff($starttime)/1000,2 )
;	MsgBox(0, "Put Function Status", "Session = "&$HC&@LF& _
;									"Source file = " & $sFile&@LF& _
;									"Remote file = " & $sRFile&@LF& _
;									"Put result = " & $Result&@LF& _
;									"XFR time = " & $deltaTime)
	if $Result then
;		MsgBox(0, "Status", "File successfully transferred.")
		Return FileGetSize($sFile)
	Else
;		msgbox(0,"Error","PutFile 1 error =" & $error)
		Return 0
	EndIf
EndFunc  ;==>PutFile
;===============================================================================
; Function Name:    SplitPathFile()
; Description:      Splits the file name with imbedded path into path & file
; Parameter(s):     $PathDir	- Returns directory path
;					$PathFile	- Complete file with path
; Requirement(s):   None
; Return Value(s):  $Return - 1 = Returns file name
;							  0 = Failed to transfer
; Author(s):        Stuart Sherlock
;===============================================================================
Func SplitPathFile(ByRef $PathDir, $PathFile)
	Local $array
	Local $arrSize
	Local $path = $PathFile
	Local $i

	$PathDir = ""
	$array = StringSplit($path, '\', 1)
;	_ArrayDisplay($array)
	for $i = 1 to $array[0]-1
		$PathDir = $PathDir & $array[$i] & "\"
	Next
	$PathDir = StringTrimRight($PathDir, 1)	; need to remove the end '\' char for later concatination
	Return $array[$array[0]]
EndFunc  ;==>SplitPathFile
;===============================================================================
; Function Name:    GetFileList()
; Description:      Opens FTP saved FTP file list and retrieve the list that was FTPed
; Parameter(s):     $FileList	- Array
; Requirement(s):   None
; Return Value(s):  $Return - None
; Author(s):        Stuart Sherlock
;===============================================================================
Func GetFileList()
	Local $sFile = "C:\FTPFiles\" & "Test.txt"
	Local $hFile
	Local $Status
	Local $i = 0
	Local $var
	Local $MyDocsFolder = @MyDocumentsDir
	Local $GotFile

	emptyListbox($ListBox1)
	emptyListbox($ListBox2)
	$sFile = FileOpenDialog("Get File List", $MyDocsFolder & "\", "Text files (*.txt)", 1 + 2)
	_GUICtrlListBox_BeginUpdate($ListBox2)
	_GUICtrlListBox_ResetContent($ListBox2)
	$hFile = FileOpen($sFile, 0)
	While 1
		$GotFile = FileReadLine($hFile)
		If @error = -1 Then ExitLoop
;		MsgBox(0, "Get file status", Line read:  "&$FileList[$i])
		_GUICtrlListBox_AddString($ListBox2, $GotFile)
	Wend
	FileClose($hFile)
	_GUICtrlListBox_EndUpdate($ListBox2)
EndFunc  ;==>GetFileList
;===============================================================================
; Function Name:    SaveFileList()
; Description:      Save files listed in ListBox2
; Parameter(s):     None
; Requirement(s):   fileArray must not be empty
; Return Value(s):  $Return - None
; Author(s):        Stuart Sherlock
;===============================================================================
Func SaveFileList()
	Local $sFile; = "C:\FTPFiles\" & "Test.txt"
	Local $hFile
	Local $Status
	Local $aresult, $var
	Local $MyDocsFolder = @MyDocumentsDir
	Local $fileArray[5]
	Local $Listbox2count = _GUICtrlListBox_GetCount($ListBox2)

	; Resize $fileArray if more than 5 items in listbox2
	if $Listbox2count > UBound($fileArray) Then
		ReDim $fileArray[$Listbox2count+1]
	EndIf
	For $i = 0 To $ListBox2Count-1
		$fileArray[$i] = _GUICtrlListBox_GetText($ListBox2, $i)
	Next
	$aresult = _ArrayFindAll ($fileArray, "")
	; Get the actual # of used elements in the file array
	$var = UBound ($fileArray) - UBound ($aresult)
	if $var <> 0 Then
;		_ArrayDisplay($fileArray,"Save file list")
		$sFile = FileSaveDialog( "Choose a name.", $MyDocsFolder, "Text files (*.txt)", 18, "*.txt")
		; option 2 = dialog remains until valid path/file selected

		If @error Then
			MsgBox(4096,"","Save cancelled.")
		Else
			; Open file and write file names to arcive file
			$hFile = FileOpen($sFile, 10) ; 10 = create dir if not there & over previous content
			$Status = _FileWriteFromArray($hFile, $fileArray, 0, $var-1)
			If $Status = 0 Then
				MsgBox(4096, "Error", " Error saving FTP files error:" & @error)
			EndIf
			FileClose($hFile)
		EndIf
	EndIf
EndFunc  ;==>SaveFileList
;===============================================================================
; Function Name:    FTPConnent()
; Description:      Connects to specified ftp server.
; Parameter(s):     $server		- FTP site. Ex: ftp.mysite.com
;					$username	- FTP site logon user name
;					$pass		- FTP logon password
;					$hFTP		- Valid handle that this function passes to 
;								  caller. Initially used for closing FTP connection.
; Requirement(s):   Must call _FTP_Startup to open FTP services.
; Return Value(s):  $Return - 1 = Session handle if connection is successful
;							  0 = Failed to connect to FTP site
; Author(s):        Stuart Sherlock
;===============================================================================
Func FTPConnect($server, $username, $pass, ByRef $hFTP)
	Local $hSession
	Local $RetButton
	
	; Open FTP site. If failed, give message then return for handling.
	_FTP_Startup()
	$hFTP = _FTP_Open('WSSftp')
	$hSession = _FTP_Connect($hFTP, $server, $username, $pass)
	if @error then
		$RetButton = MsgBox(16,"Error","Failed to connect to FTP site." & @LF & "Ckeck logon info & Internet access")
		if $RetButton = 1 then Return -1
	EndIf
;	$intComnd = _FTP_Command($hConn, 'PASV')
	Return $hSession
EndFunc  ;==>FTPConnect
;===============================================================================
; Function Name:    FTPClose()
; Description:      Disconnects the session, closes the FTP connection, then 
;					shuts down the FTP service
; Parameter(s):     $hSess		- FTP Session
;					$hOpn		- FTP connection
; Requirement(s):   Must close in the listed order
; Return Value(s):  $Return - 1 = Successfully transferred
;							  0 = Failed to transfer
; Author(s):        Stuart Sherlock
;===============================================================================
Func FTPClose($hSess, $hOpn)
	_FTP_Disconnect($hSess)
	if _FTP_Close($hOpn) < 0 then
		MsgBox(0, "close status", "Failed to close FTP connection")
	EndIf
	if _FTP_Shutdown() = 0 Then
		MsgBox(4096, "FTP Error Message", "FTP failed to shutdown properly to "& @LF & _
					"clean up resources used by WinINet.")
	EndIf
EndFunc  ;==>FTPClose
;===============================================================================
; Function Name:    SetFTPDirectory()
; Description:      Set directory if there otherwise try to create if requested
; Parameter(s):     $HC			- FTC handle
;					$sDir		- Requested directory to set to
;					$MakeFlag	- Flag to create directory if not there
;								  True to create if not there, False not to
; Requirement(s):   None
; Return Value(s):  $Return - 1 = Created dir
;							  0 = Existed and set to
;                   		 -1 = Dir not there & did not create
; Author(s):        Stuart Sherlock
;===============================================================================
Func SetFTPDirectory($HC, $sDir, $MakeFlag)
	Local $Result
	
	$Result = _Ftp_SetCurrentDir($HC, $sDir)

	if $Result = 0 and $MakeFlag = True then
;	MsgBox(0, "SetDirectory parameters and Result", "hand = " & $HC &@LF& _
;													"Dir = " & $sDir &@LF& _
;													"Make flag = "&$MakeFlag&@LF& _
;													"Result = "&$Result)
		$Result = _FTP_CreateDir($HC, $sDir)  ;Make directory in current directory
;		if @error then
		if $Result then
;			MsgBox(0, "Create Directory Status", "Directory Created successfully.")
			Return 1
		Else
;			msgbox(0,"Create Directory Status", "MakeDir for "&$sDir&" failed.")
			Return -1
		EndIf
	Else
;		MsgBox(0, "Create Directory Status", "Directory already there.")
		Return 0
	EndIf
EndFunc  ;==> SetDirectory
;===============================================================================
; Function Name:    MoveFile()
; Description:      Move 1 or more files between source and destination listboxes
; Parameter(s):     $direction	- right - move source file(s) listbox to destination
;										  listbox
;								- left  - move destination listbox file(s) back
;										  source listbox
;					$sSelectDir	- 
; Requirement(s):   None
; Return Value(s):  $Return - one
; Author(s):        Stuart Sherlock
;===============================================================================
Func MoveFile($direction)
	Local $sItems, $aItems, $selcount
	Local $selcount
	Local $LBsource, $LBdest
	
	; Set from to list listboxes from direction parameter
	if $direction = "right" Then
		$LBsource = $ListBox1
		$LBdest = $ListBox2
	Else
		$LBsource = $ListBox2
		$LBdest = $ListBox1
	EndIf
	; Get # of selected items
	$selcount = _GUICtrlListBox_GetSelCount($LBsource)
;	MsgBox(0, "select count", $selcount)
	if $selcount <> -1 Then
		; Place selected items from source into destination
		$aItems = _GUICtrlListBox_GetSelItemsText($LBsource)
		_GUICtrlListBox_BeginUpdate($LBdest)
		For $iI = 1 To $aItems[0]
			_GUICtrlListBox_AddString($LBdest, $aItems[$iI])
		Next
		_GUICtrlListBox_EndUpdate($LBdest)
		; Get items from source
		$aItems = _GUICtrlListBox_GetSelItems($LBsource)	; Get indexes of selected items
;		_ArrayDisplay($aItems, "source files")
		; Delete the moved items from source listbox
		_GUICtrlListBox_BeginUpdate($LBsource)
		For $iI = $aItems[0] to 1 Step -1
			_GUICtrlListBox_DeleteString($LBsource, $aItems[$iI])
		Next
		_GUICtrlListBox_EndUpdate($LBsource)
	EndIf
EndFunc  ;==> MoveFile
;===============================================================================
; Function Name:    MoveAllFiles()
; Description:      Move file list between source and destination listboxes
; Parameter(s):     $direction	- right or left to move file list
;					$sSelectDir	- 
; Requirement(s):   None
; Return Value(s):  $Return - one
; Author(s):        Stuart Sherlock
;===============================================================================
Func MoveAllFiles($direction);, $sSelectedDir)
	Local $sItems, $aItems, $selcount
	Local $selcount
	Local $LBsource, $LBdest

	if $direction = "right" Then
		$LBsource = $ListBox1
		$LBdest = $ListBox2
	Else
		$LBsource = $ListBox2
		$LBdest = $ListBox1
	EndIf
	; Get total # of listbox items
	$selcount = _GUICtrlListBox_GetCount($LBsource)
;	MsgBox(0, "select count", $selcount)
	if $selcount <> -1 Then
		; Select allPlace selected items from source into destination
		 _GUICtrlListBox_SelItemRange($LBsource, 0, $selcount, True)
		$aItems = _GUICtrlListBox_GetSelItemsText($LBsource)
		_GUICtrlListBox_BeginUpdate($LBdest)
		For $iI = 1 To $selcount
			_GUICtrlListBox_AddString($LBdest, $aItems[$iI])
		Next
		_GUICtrlListBox_EndUpdate($LBdest)
		; Remove items from source listbox
		$aItems = _GUICtrlListBox_GetSelItems($LBsource); Get indexes of selected items
;		_ArrayDisplay($aItems)
		For $iI = 1 To $aItems[0]
			If $iI > 1 Then $sItems &= ", "
			$sItems &= $aItems[$iI]
		Next
;		MsgBox(4160, "Information", "Items Selected: " & $sItems)
		_GUICtrlListBox_BeginUpdate($LBsource)
		For $iI = $aItems[0] to 1 Step -1
			_GUICtrlListBox_DeleteString($LBsource, $aItems[$iI]); Delete the moved items
		Next
		_GUICtrlListBox_EndUpdate($LBsource)
	EndIf
EndFunc  ;==>MoveAllFiles
;===============================================================================
; Function Name:    select_folder()
; Description:      Select folder of files to FileList
; Parameter(s):     $sLocalDir	- Local system folder
; Requirement(s):   None
; Return Value(s):  $Return - None
; Author(s):        Stuart Sherlock
;===============================================================================
Func select_folder();ByRef $sLocalDir)
	Local $i
	Local $sLocalDir = FileSelectFolder("Select FTP folder", "", 4)
    Local $FileList
	
	If @error = 1 Then
		Return
	EndIf
	GUICtrlSetData($inpLocDir, $sLocalDir)
	$FileList =_FileListToArray($sLocalDir, "*", 1)
	
	if @error <> 4 then
;		_ArrayDisplay($FileList)
		emptyListbox($ListBox1)
		For $i = 1 To $FileList[0]
			_GUICtrlListBox_AddString($ListBox1, $sLocalDir&"\"&$FileList[$i])
		Next
		_GUICtrlListBox_EndUpdate($ListBox1)
	EndIf
EndFunc  ;==>select_folder
;===============================================================================
; Function Name:    emptyListbox()
; Description:      Empties a source or destination listbox
; Parameter(s):     $hListbox	- Listbox handle
; Requirement(s):   None
; Return Value(s):  $Return - None
; Author(s):        Stuart Sherlock
;===============================================================================
Func emptyListbox($hListBox)
	Local $Status
	Do
		$Status = _GUICtrlListBox_DeleteString($hListBox, 0)
	Until $Status = -1
EndFunc
;===============================================================================
; Function Name:    About()
; Description:      Displays program name, version, and date
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  $Return - None
; Author(s):        Stuart Sherlock
;===============================================================================
Func About()
	Local $frmAbout,$Label1,$Label2,$edtVersion,$lblVersion,$edtVerDate
	Local $lblDate,$btnAboutOK

	#Region ### START Koda GUI section ### Form=C:\Users\wssdevel.THEWSSINC\scripts\ftpabout.kxf
	$frmAbout = GUICreate("WSS FTP Archiver About", 306, 198, 193, 125)
	$Label1 = GUICtrlCreateLabel("Copy Right The Workspace Solution, Inc. 2009", 16, 48, 228, 17)
	$Label2 = GUICtrlCreateLabel("WSS FTP Data Archive Controller", 16, 24, 272, 24)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$edtVersion = GUICtrlCreateInput("0.100", 88, 96, 113, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
	$lblVersion = GUICtrlCreateLabel("Version:", 40, 96, 42, 17)
	$edtVerDate = GUICtrlCreateInput("03 September 2009", 88, 120, 113, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))
	$lblDate = GUICtrlCreateLabel("Date:", 40, 120, 30, 17)
	$btnAboutOK = GUICtrlCreateButton("OK", 112, 152, 73, 25, 0)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	While 1
		$nMsg = GUIGetMsg(1)
		Switch $nMsg[0]
			Case $GUI_EVENT_CLOSE
				GUIDelete($frmAbout)
				ExitLoop
			Case $btnAboutOK
				GUIDelete($frmAbout)
				ExitLoop
		EndSwitch
WEnd
EndFunc  ;==>About

Func _Err($e)
    MsgBox(0,"Error!", $e)
    Exit
EndFunc  ;==>emptyListbox
