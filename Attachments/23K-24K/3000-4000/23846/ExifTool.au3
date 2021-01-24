#Region *** Program Information & Notes ***
#CS ***************************************
What Does this Do?
	Renames media files (.jpg & .jpeg, .bmp, .mpg & .mpeg, .png, .gif, .tif & .tiff, .avi & .flc) based on their date, so in the directories, 
	they will show up in order, and not duplicate names, etc.
	It Looks first at the standard Digital EXIF data, and uses that for the file name.
	If that is absent, then it looks to the file creation date. If that is absent, it will give the file a date of "0000-00-00"
	Files are all appended with a 3 digit number, so files with the same date (& time) would be named, for example:
		YYYY-MM-DD_HH_MM_SS_###.ext
		2008-12-07_14-22-55_001.jpg, 2008-12-07_14-22-55_002.jpg,...2008-12-07_14-22-55_999.jpg
	OR:
		YYYY-MM-DD_###.ext
		2008-12-07_001.jpg, 2008-12-07_002.jpg,...2008-12-07_999.jpg
	It DOES NOT check across directories, so in 2 directories, files can end up with the same name,
	but within the SAME directory they can NOT.
	
	Also Converts ALL extensions to lower case, for consistency.
	
Why Does it Use a Temp File instead of an array (or multiple arrays)?
	Mainly, a single temp file is easy to use, functional, and if a HUGE number
	of files are being done, the array could get absurdly large, and have to use multiple arrays, and
	add multiple loops and... and... and.... AND it is easier to NOT use them in this case.
Can it support other file types.
	Yes, they could be easily added, but I just wanted to cover the basic Digital Camera and image formats.
Why Not RAW format?
	Most people don't use it, an those that do are usually Professionals with thei own software to
	edit/develop and name the files.
#CE ***************************************
$ProgramName = "Exif Renamer Plus"
$ProgramVersion = "1.0"
$ProgramAuthor = "Harlequin"
$ProgramAuthorEmail = "n/a"
#EndRegion
#Region *** Options ***
#NoTrayIcon
;Opt("CaretCoordMode", 1)        ;1=absolute, 0=relative, 2=client
;Opt("ExpandEnvStrings", 0)      ;0=don't expand, 1=do expand
;Opt("ExpandVarStrings", 0)      ;0=don't expand, 1=do expand
;Opt("FtpBinaryMode", 1)         ;1=binary, 0=ASCII
;Opt("GUICloseOnESC", 1)         ;1=ESC  closes, 0=ESC won't close
;Opt("GUICoordMode", 1)          ;1=absolute, 0=relative, 2=cell
;Opt("GUIDataSeparatorChar","|") ;"|" is the default
;Opt("GUIOnEventMode", 0)        ;0=disabled, 1=OnEvent mode enabled
;Opt("GUIResizeMode", 0)         ;0=no resizing, <1024 special resizing
;Opt("GUIEventOptions",0)    ;0=default, 1=just notification, 2=GuiCtrlRead tab index
;Opt("MouseClickDelay", 10)      ;10 milliseconds
;Opt("MouseClickDownDelay", 10)  ;10 milliseconds
;Opt("MouseClickDragDelay", 250) ;250 milliseconds
;Opt("MouseCoordMode", 1)        ;1=absolute, 0=relative, 2=client
;Opt("MustDeclareVars", 0)       ;0=no, 1=require pre-declare
;Opt("OnExitFunc","OnAutoItExit");"OnAutoItExit" called
;Opt("PixelCoordMode", 1)        ;1=absolute, 0=relative, 2=client
;Opt("SendAttachMode", 0)        ;0=don't attach, 1=do attach
;Opt("SendCapslockMode", 1)      ;1=store and restore, 0=don't
;Opt("SendKeyDelay", 5)          ;5 milliseconds
;Opt("SendKeyDownDelay", 1)      ;1 millisecond
;Opt("TCPTimeout",100)           ;100 milliseconds
;Opt("TrayAutoPause",1)          ;0=no pause, 1=Pause
;Opt("TrayIconDebug", 0)         ;0=no info, 1=debug line info
;Opt("TrayIconHide", 0)          ;0=show, 1=hide tray icon
;Opt("TrayMenuMode",0)           ;0=append, 1=no default menu, 2=no automatic check, 4=menuitemID  not return
;Opt("TrayOnEventMode",0)        ;0=disable, 1=enable
;Opt("WinDetectHiddenText", 0)   ;0=don't detect, 1=do detect
;Opt("WinSearchChildren", 1)     ;0=no, 1=search children also
;Opt("WinTextMatchMode", 1)      ;1=complete, 2=quick
;Opt("WinTitleMatchMode", 1)     ;1=start, 2=subStr, 3=exact, 4=advanced, -1 to -4=Nocase
;Opt("WinWaitDelay", 250)        ;250 milliseconds
#EndRegion
#Region *** Includes ***
#include <File.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#EndRegion
#Region *** Variables ***
Dim $XLoop, $YLoop, $ZLoop, $Exit_Do = 0, $Exit_While = 0 ; For Loops, nested loops, etc. - Standard Base Variables
Dim $BasePath = "", $Prev_Format = 0, $NewBaseName, $fl_Path, $fl_Ext, $NewFileName ; General variables for the app, no particular order
Dim $TempFileList = _TempFile (@TempDir, "~", ".ext", 7) ; The Temp File, used instead of an array (See Notes)
Dim $FilePath = String (@MyDocumentsDir & "\"); Set Base File Path to "My Documetns" Folder
#EndRegion
#Region *** Functions ***
Func ProgramClose() ; To Close apps, release varaibales, delete temp file(s), etc.
	FileClose ($TempFileList)
	FileDelete ($TempFileList)
	MsgBox (0,$ProgramName,"Goodbye!")
	GuiSetState (@SW_HIDE)
	Exit
EndFunc ; END ProgramClose
Func GetADirectory($gadStarting = "") ; Gets a Directory and Makes Sure it Exists (Cannot exit unless a valid Directory is Chosen)
	local $gadPath, $gadReturn, $goReturn = 0
	Do
		$gadPath = FileSelectFolder ("Select Folder - " & $ProgramName, "", 2, $gadStarting)
		If $gadPath == "" then Return @MyDocumentsDir
		If  DirGetSize ($gadPath) >= 0 Then
			$gadReturn = _PathFull ($gadPath)
			$gadReturn = String ($FilePath & "\")
			$goReturn = 1
		EndIf
	Until $goReturn = 1
	Return $gadPath
EndFunc
Func AddToFiles($RootPath, $RecYN, $FileType, $FileList) ; Adds Path & Filename to the File List for later processing - Default Type = ".jpg"
	Local $SingleDirFile, $afSearch, $file
	If $RootPath == "" Then ; If no path is passed to function, asks for a path as the root
		$RootPath = _PathFull (FileSelectFolder ("Select Starting Folder - " & $ProgramName, "", 2)) ; Get Base Path
		$RootPath = String ($RootPath & "\") ; Add "\" to base path
	EndIf
	If $RecYN == "" Then ; Checks for Recursive Parameter, and asks to select Yes/No if it is not passed
		$YNSelect = MsgBox (4+32, $ProgramName, "Include All Sub-Directories?")
		If $YNSelect == 5 Then ;Yes
			$RecYN = 1
		Else
			$RecYN = 0
		EndIf
	EndIf
	If $FileList == "" Then $FileList = _TempFile (@TempDir, "~", ".ext", 7); Generates a temp File if it does not exist or was not passed
	If $RecYN == 1 Then ; Output Recursive File list via DOS "dir" command, bare format
		RunWait(@ComSpec & ' /c ' & 'dir "' & $RootPath & $FileType & '" /B /S /A-D >>' & $FileList, "",@SW_HIDE)
	Else ; Output Base Directory file list with full path using AutoIt ONLY functions
		$afSearch = FileFindFirstFile($RootPath & $FileType)  
		If $afSearch = -1 Then
			FileClose($afSearch)
			Return
		EndIf
		FileOpen ($FileList, 1)
		While 1
			$afFile = FileFindNextFile($afSearch) 
			If @error Then
				ExitLoop
			Else
				FileWriteLine ($FileList, $RootPath & $afFile)
			EndIf
		WEnd
		FileClose ($FileList)
		FileClose ($afSearch)
	EndIf
EndFunc ; END AddToFiles
Func _GetExtProperty($sPath, $iProp = -1) ; Thanks to Simucal for this code, it saved a lot of time & research!!
	#CS=============================================================================
	= Function Name:    GetExtProperty($sPath,$iProp)
	= Description:      Returns an extended property of a given file.
	= Parameter(s):     $sPath - The path to the file you are attempting to retrieve an extended property from.
	=                   $iProp - The numerical value for the property you want returned. If $iProp is is set
	=                       to -1 then all properties will be returned in a 1 dimensional array in their corresponding order.
	=                     The properties are as follows:
	=                     Name = 0						Size = 1
	=                     Type = 2						DateModified = 3				
	=                     DateCreated = 4				DateAccessed = 5				
	=                     Attributes = 6				Status = 7
	=                     Owner = 8						Author = 9
	=                     Title = 10					Subject = 11
	=                     Category = 12					Pages = 13
	=                     Comments = 14					Copyright = 15
	=                     Artist = 16					AlbumTitle = 17
	=                     Year = 18						TrackNumber = 19
	=                     Genre = 20					Duration = 21
	=                     BitRate = 22					Protected = 23
	=                     CameraModel = 24				DatePictureTaken = 25
	=                     Dimensions = 26				Width = 27
	=                     Height = 28					Company = 30
	=                     Description = 31				FileVersion = 32
	=                     ProductName = 33				ProductVersion = 34
	= Requirement(s):   File specified in $spath must exist.
	= Return Value(s):  On Success - The extended file property, or if $iProp = -1 then an array with all properties
	=                   On Failure - 0, @Error - 1 (If file does not exist)
	= Author(s):        Simucal (Simucal@gmail.com)
	= Note(s):
	=
	#CE=============================================================================
	Local $iExist, $sFile, $sDir, $oShellApp, $oDir, $oFile, $aProperty, $sProperty
    $iExist = FileExists($sPath)
    If $iExist = 0 Then
        SetError(1)
        Return 0
    Else
        $sFile = StringTrimLeft($sPath, StringInStr($sPath, "\", 0, -1))
        $sDir = StringTrimRight($sPath, (StringLen($sPath) - StringInStr($sPath, "\", 0, -1)))
        $oShellApp = ObjCreate("shell.application")
        $oDir = $oShellApp.NameSpace ($sDir)
        $oFile = $oDir.Parsename ($sFile)
        If $iProp = -1 Then
            Local $aProperty[35]
            For $i = 0 To 34
                $aProperty[$i] = $oDir.GetDetailsOf ($oFile, $i)
            Next
            Return $aProperty
        Else
            $sProperty = $oDir.GetDetailsOf ($oFile, $iProp)
            If $sProperty = "" Then
                Return 0
            Else
                Return $sProperty
            EndIf
        EndIf
    EndIf
EndFunc   ;==>_GetExtProperty
Func MakeExifName ($Exif_File, $NewFormat = 4) ; Changes the name of a media file based on the time stamp in the Exif Data (if present)
	#CS ****************************************************
	***** Changes the name of a media file based on the    *
	***** time stamp in the Exif Data, or if tht is not    *
	***** present, then the fle created date. It will also *
	***** NOT make duplicate file names IN THE SAME        *
	***** DIRECTORY (They may exist in others, as it does  *
	***** NOT search the entire PC).                       *
	********************************************************
	***** $Exif_File = The FULL PATH AND FILE NAME         *
	*****              x1 = "YYYY-MM-DD_???"               *<< Not All Formats are implemented,
	*****              2 = "YYYY-MM-DD_###"                *<< and I will not likely implement
	*****              x3 = "YYYY-MM-DD_HH-MM-SS_???"      *<< the Alphabetic Sequence, but I did
	*****   Default => 4 = "YYYY-MM-DD_HH-MM-SS_###"       *<< add the Switch Locations if anyone
	*****                                                  *<< wants to add it themselves.
	***** ??? = Aplha Sequencing: AAA, AAB...ACA, ACB, etc *
	***** ### = Numeric Sequence: 001, 002...234, 235, etc *
	#CE ****************************************************
	Local $exFilePath, $exFileName, $ex_ReturnName
	Local $ex_Year, $ex_Month, $ex_Day
	Local $ex_Hour, $ex_Minute, $ex_Second
	Local $ex_numeric, $ex_Alpha
	Local $exLoop
	For $exLoop = StringLen ($Exif_File) to 1 Step -1 
		If StringMid  ($Exif_File, $exLoop, 1) == "\" Then
			$exFileName = StringRight ($Exif_File, StringLen($Exif_File)-$YLoop)
			$exFilePath = StringLeft ($Exif_File, $YLoop)
			$exLoop = 1
		EndIf
	Next
	$ex_DateTaken = _GetExtProperty ($Exif_File,34)
	If $ex_DateTaken == "" OR $ex_DateTaken == "0" Then
		$ex_DateTaken = _GetExtProperty ($Exif_File, 3)
		If $ex_DateTaken == "" OR $ex_DateTaken == "0" Then
			$ex_NewBaseName = "0000-00-00_00.00.00_"  ; Set New BaseFilename to "0000-00-00_00.00.00_xxx"
		Else ; Set New BaseFilename Based on MM/DD/YYYY HH:MM PM
			For $exLoop = 1 to StringLen ($ex_DateTaken) ; Extract Month, and cut day from string
				If StringMid ($ex_DateTaken, $exLoop, 1) == "/" Then
					$LeaveLoop = StringLen ($ex_DateTaken)
					$ex_Month = StringLeft ($ex_DateTaken, $exLoop-1)
					$ex_DateTaken = StringMid  ( $ex_DateTaken, $exLoop+1)
					If StringLen ($ex_Month) == 1 then $ex_Month = String ("0" & $ex_Month)
					$exLoop = $LeaveLoop
				EndIf
			Next
			For $exLoop = 1 to StringLen ($ex_DateTaken) ; Extract Day & Year and cutboth from string
				If StringMid ($ex_DateTaken, $exLoop, 1) == "/" Then 
					$LeaveLoop = StringLen ($ex_DateTaken)
					$ex_Day = StringLeft ($ex_DateTaken, $exLoop-1)
					If StringLen ($ex_Day) == 1 then $ex_Day = String ("0" & $ex_Day)
					$ex_Year = StringMid ($ex_DateTaken, $exLoop+1, 4)
					$ex_DateTaken = StringMid  ( $ex_DateTaken, $exLoop+5)
					$exLoop = $LeaveLoop
				EndIf
			Next
			For $exLoop = 1 to StringLen ($ex_DateTaken)
				If StringMid ($ex_DateTaken, $exLoop,1) == ":" Then
					$LeaveLoop = StringLen ($ex_DateTaken)
					$ex_Minute = StringMid ($ex_DateTaken, $exLoop+1, 2)
					$ex_Hour = StringLeft ($ex_DateTaken, $exLoop-1)
					If StringRight ($ex_DateTaken, 2) == "PM" Then $ex_Hour = $ex_Hour+12
					$exLoop = $LeaveLoop
				EndIf
			Next
			$ex_Second = "00"
		EndIf
	Else ; Set New BaseFilename Based on YYYY:MM:DD 16:20:28
		$ex_Year = StringLeft ($ex_DateTaken, 4)
		$ex_Month = StringMid ($ex_DateTaken, 6, 2)
		$ex_Day =  StringMid ($ex_DateTaken, 9, 2)
		$ex_Hour =  StringMid ($ex_DateTaken, 12, 2)
		$ex_Minute =  StringMid ($ex_DateTaken, 15,2)
		$ex_Second = StringRight ($ex_DateTaken, 2)
	EndIf
	Switch $NewFormat ; Set New File Name based on format selection
		Case 1 ; Included for Alphabetic Sequence Code, if desired: "YYYY-MM-DD_???"
			$NewFormat = 2
		Case 2
			$ex_ReturnName = String ( $ex_Year & "-" & $ex_Month & "-" & $ex_Day & "_")
		Case 3
			$NewFormat = 4 ; Included for Alphabetic Sequence Code, if desired: "YYYY-MM-DD_HH-MM-SS_???"
		Case 4
			$ex_ReturnName = String ( $ex_Year & "-" & $ex_Month & "-" & $ex_Day & "_" & $ex_Hour & "-" & $ex_Minute & "-" & $ex_Second & "_")
	EndSwitch
	Return $ex_ReturnName
EndFunc ; END MakeExifName
#EndRegion
#Region *** Begin Main Program (No Functions Below Here)***
#Region ### START Koda GUI section ###
$gui_FormatSelect = GUICreate($ProgramName & " v." & $ProgramVersion, 347, 450, -1, -1)
	$grp_formats = GUICtrlCreateGroup("File Format Selection", 8, 8, 121, 223)
		$btn_Checkall = GUICtrlCreateButton ("Check All", 16, 26, 103, 25)
			$Checkall_State = 0
		$chk_frmt_bmp = GUICtrlCreateCheckbox("BMP", 16, 62, 89, 17)
		$chk_frmt_jpg = GUICtrlCreateCheckbox("JPG && JPEG", 16, 86, 89, 17)
		$chk_frmt_tiff = GUICtrlCreateCheckbox("TIF && TIFF", 16, 110, 89, 17)
		$chk_frmt_gif = GUICtrlCreateCheckbox("GIF", 16, 134, 89, 17)
		$chk_frmt_png = GUICtrlCreateCheckbox("PNG", 16, 158, 89, 17)
		$chk_frmt_avi = GUICtrlCreateCheckbox("AVI && FLC", 16, 182, 89, 17)
		$chk_frmt_mpg = GUICtrlCreateCheckbox("MPG && MPEG", 16, 206, 89, 17)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	$grp_nameformat = GUICtrlCreateGroup("Filename Format", 144, 58, 193, 173)
		;$rdo_format1 = GUICtrlCreateRadio("YYYY-MM-DD_???", 152, 75, 113, 17) ; Uncomment this line IF Alphabetic Sequencing is written
		$rdo_format2 = GUICtrlCreateRadio("YYYY-MM-DD_###", 152, 105, 113, 17)
		;$rdo_format3 = GUICtrlCreateRadio("YYYY-MM-DD_HH-MM-SS_???", 152, 135, 177, 17) ; Uncomment this line IF Alphabetic Sequencing is written
		$rdo_format4 = GUICtrlCreateRadio("YYYY-MM-DD_HH-MM-SS_###", 152, 165, 177, 17)
		;$txt_Note1 = GUICtrlCreateLabel("? = Alpha Notation (A, B..AAB,AAC)" & @CRLF & "# = Numeric Notation (001,002..223)", 152, 190, 181, 34) ; Uncomment this line IF Alphabetic Sequencing is written
		$txt_Note1 = GUICtrlCreateLabel("# = Numeric Notation (001,002..223)", 152, 190, 181, 34) ; COMMENT OUT this line IF Alphabetic Sequencing is written
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState ($rdo_format4, $GUI_CHECKED)
	$grp_recursive = GUICtrlCreateGroup("Include Subdirectories", 144, 8, 193, 45)
		$rdo_recurseYes = GUICtrlCreateRadio ("Yes", 152, 28, 55)
		$rdo_recurseNo = GUICtrlCreateRadio ("No", 209, 28, 55)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetState ($rdo_recurseNo, $GUI_CHECKED)
	GUICtrlCreateGroup ("Picture Folder", 8, 235, 331, 66)
		$npt_PictureDir = GUICtrlCreateInput ($FilePath, 12, 250, 319, 22)
		$btn_ChangeDir = GUICtrlCreateButton ("Change Directory", 12, 274, 100, 22)
		GUICtrlCreateGroup("", -99, -99, 1, 1)	
	GUICtrlCreateGroup("Current Activity", 8, 310, 331, 80)
		$txt_ShowActivity = GUICtrlCreateLabel ("No Current Activity", 18, 325, 311, 60)
		GUICtrlCreateGroup("", -99, -99, 1, 1)	
	$btn_rename = GUICtrlCreateButton("Rename Files", 8, 400, 123, 41)
	$btn_help = GUICtrlCreateButton("Help", 168, 400, 75, 41, 0)
	$btn_quit = GUICtrlCreateButton("Quit", 256, 400, 75, 41, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
#Region *** Main Working Area of the App ***
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE ; Close App
			ProgramClose()
		Case $btn_quit ; Close App
			ProgramClose()
		Case $btn_help ; Help Button
			MsgBox (48, $ProgramName, "Help Not Yet Implemented")
		Case $btn_ChangeDir
			$FilePath = GetADirectory (@MyDocumentsDir)
			If StringRight ($FilePath, 1) <> "\" Then $FilePath = String ($FilePath & "\")
			GUICtrlSetData ($npt_PictureDir, $FilePath)
		Case $btn_Checkall ; Check or uncheck all file types
			If $Checkall_State == 0 Then
				GUICtrlSetState ($chk_frmt_bmp , $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_jpg, $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_tiff, $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_gif, $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_png, $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_avi, $GUI_CHECKED)
				GUICtrlSetState ($chk_frmt_mpg, $GUI_CHECKED)
				$Checkall_State = 1
				GuiCtrlSetData ($btn_Checkall, "Uncheck All")
			Else
				GUICtrlSetState ($chk_frmt_bmp , $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_jpg, $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_tiff, $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_gif, $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_png, $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_avi, $GUI_UNCHECKED)
				GUICtrlSetState ($chk_frmt_mpg, $GUI_UNCHECKED)
				$Checkall_State = 0
				GuiCtrlSetData ($btn_Checkall, "Check All")
			EndIf
		Case $btn_rename ; Rename files based on selected criteria (This is the main working area of the app)
			$FilePath = GuiCtrlRead ($npt_PictureDir)
			If DirGetSize ($FilePath) == -1 Then
				GetADirectory(@MyDocumentsDir)
			EndIf
			If StringRight ($FilePath, 1) <> "\" Then $FilePath = String ($FilePath & "\")
			If GUICtrlRead ($rdo_recurseYes) == $GUI_CHECKED Then ; Set Recursive Flag (0 = No, 1 = Yes (Default))
				$Recursive = 1
			Else
				$Recursive = 0
			EndIf
			;If GUICtrlRead ($rdo_format1) == $GUI_CHECKED Then ; Get New Filename Format (1 - 4 (Default)) ; Uncomment this line IF Alphabetic Sequencing is written
			;	$File_Name_Format = 1 ; Uncomment this line IF Alphabetic Sequencing is written
			If GUICtrlRead ($rdo_format2) == $GUI_CHECKED Then ; Get New Filename Format (1 - 4 (Default)) COMMENT OUT LINE IF Alphabetic Sequencing is written
				$File_Name_Format = 2 ; COMMENT OUT LINE IF Alphabetic Sequencing is written
			;ElseIf GUICtrlRead ($rdo_format2) == $GUI_CHECKED Then ; Uncomment this line IF Alphabetic Sequencing is written
			;	$File_Name_Format = 2 ; Uncomment this line IF Alphabetic Sequencing is written
			;ElseIf GUICtrlRead ($rdo_format3) == $GUI_CHECKED Then ; Uncomment this line IF Alphabetic Sequencing is written
			;	$File_Name_Format = 3 ; Uncomment this line IF Alphabetic Sequencing is written
			ElseIf GUICtrlRead ($rdo_format4) == $GUI_CHECKED Then
				$File_Name_Format = 4
			Else ; If, for some reason, no Radio button is selected, it defaults to format 4
				$File_Name_Format = 4 
			EndIf
			If GUICtrlRead ($chk_frmt_bmp) == $GUI_CHECKED Then ; Add ".bmp" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".bmp"')
				AddToFiles($FilePath, $Recursive, "*.bmp", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_jpg) == $GUI_CHECKED  Then ; Add ".jpg" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".jpg"')
				AddToFiles($FilePath, $Recursive, "*.jpg", $TempFileList) ; Add ".jpeg" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".jpeg"')
				AddToFiles($FilePath, $Recursive, "*.jpeg", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_tiff) == $GUI_CHECKED  Then ; Add ".tif" & ".tiff" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".tif"')
				AddToFiles($FilePath, $Recursive, "*.tif", $TempFileList) ; Add ".tif" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".tiff"')
				AddToFiles($FilePath, $Recursive, "*.tiff", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_gif) == $GUI_CHECKED  Then ; Add ".gif" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".gif"')
				AddToFiles($FilePath, $Recursive, "*.gif", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_png) == $GUI_CHECKED Then ; Add ".png" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".png"')
				AddToFiles($FilePath, $Recursive, "*.png", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_avi) == $GUI_CHECKED  Then ; Add ".avi"  & ".flc" files, if chosen
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".avi"')
				AddToFiles($FilePath, $Recursive, "*.avi", $TempFileList)
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".flc"')
				AddToFiles($FilePath, $Recursive, "*.flc", $TempFileList)
			EndIf
			If GUICtrlRead ($chk_frmt_mpg) == $GUI_CHECKED  Then ; Add ".mpg" 7 ".mpeg" files, if chosen
				AddToFiles($FilePath, $Recursive, "*.mpg", $TempFileList)
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".mpg"')
				AddToFiles($FilePath, $Recursive, "*.mpeg", $TempFileList)
				GUICtrlSetData ($txt_ShowActivity, 'Gathering Files: ".mpeg"')
			EndIf

			For $XLoop = 1 to _FileCountLines ($TempFileList) ; Begin Processing Files
				$CurrentFile = FileReadLine ($TempFileList, $XLoop)
				GUICtrlSetData ($txt_ShowActivity, "Processing Files: "& @CRLF & $CurrentFile & @CRLF & " --> Processing...")
				If FileExists ($CurrentFile) Then ; If File Exists then it is processed
					$NewBaseName = MakeExifName($CurrentFile, $File_Name_Format) ; Gets new Exif Based Root Name
					For $YLoop = StringLen ($CurrentFile) to 1 Step -1
						If StringMid ($CurrentFile, $YLoop, 1) == "." Then
							$fl_Ext = StringLower (StringMid ($CurrentFile, $YLoop))
							$YLoop = 1
						EndIf
					Next
					For $YLoop = StringLen ($CurrentFile) to 1 Step -1
						If StringMid ($CurrentFile, $YLoop, 1) == "\" Then
							$fl_Path = StringLeft ($CurrentFile, $YLoop)
							$YLoop = 1
						EndIf
					Next
				EndIf
				For $YLoop = 1 to 999
					$NewFileName = String ($fl_Path & $NewBaseName & StringFormat ("%.3i", $YLoop) & $fl_Ext)
					GUICtrlSetData ($txt_ShowActivity, "Processing Files: "& @CRLF & $CurrentFile & @CRLF & " --> " & $NewBaseName)
					If NOT FileExists ($NewFileName) Then
						FileMove ($CurrentFile, $NewFileName)
						$YLoop = 999
					EndIf
				Next		
			Next
			GuiCtrlSetData ($txt_ShowActivity, "Done Processing." & @CRLF & "No Current Activity")
		; End of "Case" Statements
	EndSwitch
WEnd
#EndRegion *** Main Working Area of the App ***
#EndRegion *** Main Program ***