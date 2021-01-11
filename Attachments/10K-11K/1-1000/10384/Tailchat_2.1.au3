#include <File.au3>
#include <GUIConstants.au3>
#Include <GuiEdit.au3>
#Include <array.au3>
#Include <Misc.au3>

Opt("GUIOnEventMode", 1)
Opt('GUICloseOnESC', 1)
Dim $aCurrentUSers[1]
;     Start GUI Window and Elements creation -->
$W_size_w = 450
$Wsize_h = 610
$mainWindow = GUICreate("Tailchat", $W_size_w, $Wsize_h)
$notify_on_minimize = 0
;~ HotKeySet("^{ENTER}","ChatButton")
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUISetState(@SW_SHOW)

GUICtrlCreateLabel("Please select the file you want to tail", 30, 10)

$fileopenButton = GUICtrlCreateButton("Open File", 30, 40, -1, 20)
GUICtrlSetOnEvent($fileopenButton, "FileopenButton")

$showusers = GUICtrlCreateButton("Show Users", 120, 40, -1, 20)
GUICtrlSetOnEvent($showusers, "ShowUsers")

$PushButton = GUICtrlCreateCheckbox("Alwaysontop",250 , 560, -1, 20)
GUICtrlSetOnEvent($PushButton, "PushButton")

$AwayCheck = GUICtrlCreateCheckbox("Away Notification?",250 , 540, -1, 20)
GUICtrlSetOnEvent($AwayCheck, "Notification")

$ChatButton = GUICtrlCreateButton("Send", 30, 580, -1, 20)
GUICtrlSetOnEvent($ChatButton, "ChatButton")

$usercheck = GUICtrlCreateCheckbox("Include Username?", 250, 580)
GUICtrlSetState($usercheck,1)

$editControl = GUICtrlCreateEdit("", 30, 120, $W_size_w - 60, ($Wsize_h - 350), $WS_VSCROLL + $ES_MULTILINE + $ES_AUTOVSCROLL + $ES_READONLY)
$chatControl = GUICtrlCreateEdit("", 30, 385, $W_size_w - 60, 80,$ES_WANTRETURN)

$InputControl = GUICtrlCreateInput("Choose file", 30, 80, 300, 20,$ES_READONLY)
;~ $linecountcontrol = GUICtrlCreateInput("Lines : ", 360, 80, 75, 20, $ES_READONLY)

$initial = 0
$File_opened = 0
$count2 = 0
$scan2 = ""

While 1
    Tailit()
    Sleep(100)
WEnd

Func Tailit()
	
	    ;         Function Environment settings  -->
    $error = 0
   
    $file = ControlGetText("Tailchat", "", $InputControl)
    $count = _FileCountLines($file)
    $scan = FileReadLine($file, $count)
    $file_contents = ""
	If _IsPressed("0D") Then
		ChatButton()
	EndIf
	
	
    For $x  = 1 To $count
;~         
		$scan3 = FileReadLine($file, $x)
		$display = _isSystemLine($file, $scan3,$x)
		if $display = 1 Then
			$file_contents &= $scan3 & @CRLF
		Elseif $display = 0 Then
		EndIf
    Next
	
	;  Displays the file contents on first open.
		if ($File_opened = 1) and ($initial = 0) Then 
			GUICtrlSetData($editControl, $file_contents)
;~ 			GUICtrlSetData($linecountcontrol, "Lines : " & $count)
			_GUICtrlEditLineScroll($editControl, 0, $count)
			$initial = 1
		EndIf
		
		If $File_opened = 1 Then
			Select
				Case $count2 <> $count
					
					GUICtrlSetData($editControl, $file_contents)
;~ 					GUICtrlSetData($linecountcontrol, "Lines : " & $count)
					If BitAnd(Wingetstate("Tailchat"), 16) then
						if $notify_on_minimize = 1 Then
							TrayTip("TailChat", $scan, 5, 1)
						EndIf
					EndIf
					
					_GUICtrlEditLineScroll($editControl, 0, $count)
				   
	          Case $scan2 <> $scan
	                GUICtrlSetData($editControl, $file_contents)
;~ 	                 GUICtrlSetData($linecountcontrol, "Lines : " & $count)
	                 _GUICtrlEditLineScroll($editControl, 0, $count)
			EndSelect
		EndIf
	
    $count2 = $count
    $scan2 = $scan
   
EndFunc   ;==>Tailit

Func FileopenButton()
	if $File_opened = 1 Then
	_logout()
	EndIf
    Global $selected_file = FileOpenDialog("Open", @ScriptDir, "Text Files (*.*)")
    GUICtrlSetData($InputControl, $selected_file)
    Global $openfile = FileOpen($selected_file, 0)
    $File_opened = 1
    _login()
EndFunc   ;==>FileopenButton

Func CLOSEClicked()
    _logout()
    FileClose($openfile)
   
    Exit
EndFunc   ;==>CLOSEClicked

Func ChatButton()
   
    $check_status=  GUICtrlRead($usercheck)
    $inputtext = ControlGetText("", "", $chatControl)
    if $check_status = 1 Then
        $inputtext = @HOUR & ":" & @MIN &" " &@UserName & ":   " & $inputtext
	EndIf
	
    $openfilewrite = FileOpen($selected_file, 1)
    FileWriteLine($openfilewrite, $inputtext)
    GUICtrlSetData($chatControl, "")
    FileClose($openfilewrite)
EndFunc   ;==>ChatButton

func PushButton()     
    if GUICtrlRead($PushButton) = 1 Then
        WinSetOnTop("Tailchat", "", 1)
    Elseif GUICtrlRead($PushButton) = 4 Then
        WinSetOnTop("Tailchat", "", 0)
        EndIf
    EndFunc
   
Func _login()
    $openfilewrite = FileOpen($selected_file, 1)
	_FileWriteToLine($selected_file,1,"##~~!!" & @UserName &"|" & @hour &@min & "|" & Random(1,20,1),0)
	FileWriteLine($openfilewrite,  @username & " has joined this chat at " &@HOUR & ":" & @MIN)
    FileClose($openfilewrite)
EndFunc

Func _logout()
    $openfilewrite = FileOpen($selected_file, 1)
	_RemoveOnlineUser()
    FileWriteLine($openfilewrite, @username & " has left at " & @HOUR & ":" & @MIN)
    FileClose($openfilewrite)
EndFunc

Func Notification()
        if GUICtrlRead($AwayCheck) = 1 Then
        $notify_on_minimize = 1
    Elseif GUICtrlRead($AwayCheck) = 4 Then
        $notify_on_minimize = 0
        EndIf
EndFunc

Func _isSystemLine($file,$scan3,$x)
	if StringInStr($scan3,"##~~!!")<>0 Then
		Return 0 
	Else
		return 1
	EndIf
EndFunc

Func _RemoveOnlineUser()
	Dim $atest, $aloc[1]
		_filereadtoarray($selected_file,$atest)
		for $x = 1 to (UBound($atest)-1 )
			$isme = stringinstr($atest[$x],"##~~!!" & @UserName)
			if $isme <> 0 Then
				_ArrayAdd($aloc, $x)
			EndIf
		next
		for $y = (Ubound($aloc)-1) to 1 step -1
			_FileWriteToLine($selected_file,$aloc[$y],"",1)
		Next	
EndFunc

func ShowUsers()
	Dim $aEntFile, $afileusers[1]
	_FileReadToArray($selected_file,$aEntFile)
	for $x = 1 to UBound($aEntFile)-1 
		if StringInStr($aEntFile[$x], "##~~!!")<>0 Then
			$sUser = StringTrimLeft($aEntFile[$x], 6)
			$aSubUser = Stringsplit($sUser, "|")
			_arrayadd($afileusers, $aSubUser[1])
		EndIf
	next 
_ArrayDisplay($afileusers, "Array : aFileUsers " )

EndFunc	
