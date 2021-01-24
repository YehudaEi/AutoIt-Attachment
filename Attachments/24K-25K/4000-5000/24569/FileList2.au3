#include<GUIConstantsEx.au3>
;~ #include<OvKFuncs.au3>
#include<WindowsConstants.au3>
#include<TabConstants.au3>
#include<Array.au3>
#Include<GuiListView.au3>
Opt("GUIResizeMode",$GUI_DOCKBORDERS)
Global $MUSICDIR="C:\Music"
Global $EXT="mp3"

If FileExists($MUSICDIR)=0 Then
	$PSUEDODIR=@TEMPDIR&"\Overkill\Music"
	DirCreate($PSUEDODIR)
	DirCreate($PSUEDODIR&"\Artist 1")
	DirCreate($PSUEDODIR&"\Artist 2")
	For $I=1 to 5
		RunWait(@ComSpec & " /c " & 'DIR "' & @ScriptDir & '" /S /B > "' & $PSUEDODIR & '\Artist 1\song' & $I & '.mp3"', "", @SW_HIDE)
	Next
	For $I=1 to 3
		RunWait(@ComSpec & " /c " & 'DIR "' & @ScriptDir & '" /S /B > "' & $PSUEDODIR & '\Artist 2\song' & $I & '.mp3"', "", @SW_HIDE)
	Next
	$MUSICDIR=$PSUEDODIR
EndIf

$ARTISTLIST=DirList($MUSICDIR)

GUICreate("Directory List",622,482,Default,Default,BitOr($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX))
	$TAB = GUICtrlCreateTab(1,1,620,480,BitOr($GUI_SS_DEFAULT_TAB,$TCS_MULTILINE,$TCS_RIGHTJUSTIFY))

;~ Dim $LISTVIEW[2]
Dim $STORE[$ARTISTLIST[0]+1][1]
	For $I=1 to $ARTISTLIST[0]
		
		GUICtrlCreateTabItem($ARTISTLIST[$I])
		$SONGLIST=FileList($MUSICDIR&"\"&$ARTISTLIST[$I],1,$EXT)
		$LISTVIEW=GUICtrlCreateListView("",2,140,615,280)
			_GUICtrlListView_SetExtendedListViewStyle($LISTVIEW, BitOR($LVS_EX_BORDERSELECT , $LVS_EX_CHECKBOXES ))
			_GUICtrlListView_InsertColumn($LISTVIEW, 0, "Filelist")
			_GUICtrlListView_SetColumnWidth($LISTVIEW, 0, $LVSCW_AUTOSIZE_USEHEADER)
			
			For $n = 1 to $SONGLIST[0]
			If $SongList[0]+1 > UBound($STORE,2) Then ReDim $STORE[$ARTISTLIST[0]+1][$SONGLIST[0]+1]
			$STORE[$I][0] = $SONGLIST[0]
			$STORE[$I][$N] = _GUICtrlListView_AddItem($LISTVIEW, $SONGLIST[$N], $N - 1)
		Next
		
		GUICtrlSetResizing($LISTVIEW,BitOr($GUI_DOCKBORDERS,$GUI_DOCKTOP))
;~ 		ReDim $LISTVIEW[$I+2]
	Next

GUICtrlCreateTabItem("")
$BUTTON = GUICtrlCreateButton("Button",1,440,120,30)
GUISetState(@SW_SHOW)

While 1
	$m = GUIGetMsg()
	If $m = $GUI_EVENT_CLOSE THEN
		DirRemove(@Tempdir&"\Overkill",1)
		Exit
	EndIf
	If $m = $BUTTON Then
		For $I=1 to $ARTISTLIST[0]
			For $N=1 to $STORE[$I][0]
				If BitOR(GUICtrlRead($STORE[$I][$N], 1), $GUI_CHECKED) = $GUI_CHECKED Then ConsoleWrite("$I="&$I&"$N="&$N&@CRLF)
			Next
		Next
	EndIf
WEnd

Func FileList($dir, $subdirs = 0, $filetype = "*")

Local $F = @TempDir & '\FileListFile.TMP'

$DLERROR1 = FileExists($dir)
If $DLERROR1 = 0 Then
	SetError(1, Default, "")
	MsgBox(16, "ERROR", "Directory " & $dir & " does not exist.")
	Exit
EndIf

If $subdirs = 0 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $dir & "\*." & $filetype & '" /B > ' & $F, "", @SW_HIDE) ; Dump DIR result to temp file, no subdirectories
ElseIf $subdirs = 1 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $dir & "\*." & $filetype & '" /B /S > ' & $F, "", @SW_HIDE) ; Dump DIR result to temp file, with subdirectores
Else
	MsgBox(16, "ERROR", $subdirs & " is not a valid value. Please use either 0 or 1.")
	Exit
EndIf

Dim $FileRead[2]
Local $Z=FileOpen($F,0)
While 1
	Local $X=Ubound($FileRead)
	Local $A=FileReadLine($Z)
	If @ERROR=-1 Then
		Redim $FileRead[$X-1]
		ExitLoop
	EndIf
	If $A<>"" Then
		$FileRead[$X-1]=$A
		Redim $FileRead[$X+1]
	EndIf
WEnd

$FileRead[0]=UBound($FileRead)-1
Return $FileRead
FileClose($Z)
FileDelete($F)
EndFunc

Func DirList($D2, $SD2 = 0)

Local $D = @TempDir & '\DirListFile.TMP'

$DLERROR1 = FileExists($D2)
If $DLERROR1 = 0 Then
	SetError(1, Default, "")
	MsgBox(16, "ERROR", "Directory " & $D2 & " does not exist.")
	Exit
EndIf

If $SD2 = 0 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $D2 & '" /A:D /B > ' & $D, "", @SW_HIDE) ; Dump DIR result to temp file, no subdirectories
ElseIf $SD2 = 1 Then
	$R1 = RunWait(@ComSpec & " /c " & 'DIR "' & $D2 & '" /A:D /B /S > ' & $D, "", @SW_HIDE) ; Dump DIR result to temp file, with subdirectores
Else
	MsgBox(16, "ERROR", $SD2 & " is not a valid value. Please use either 0 or 1.")
	Exit
EndIf

Dim $DIRREAD[2]
Local $Z=FileOpen($D,0)
While 1
	Local $X=Ubound($DIRREAD)
	Local $A=FileReadLine($Z)
	If @ERROR=-1 Then
		Redim $DIRREAD[$X-1]
		ExitLoop
	EndIf
	If $A<>"" Then
		$DIRREAD[$X-1]=$A
		Redim $DIRREAD[$X+1]
	EndIf
WEnd

$DIRREAD[0]=UBound($DIRREAD)-1
Return $DIRREAD
FileClose($Z)
FileDelete($D)
EndFunc