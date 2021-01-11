
; Test GUI to download single game from www.reflexive.com given games AID number.
; latest beta autoit required.

;commented out internal proxy for privacy.
HttpSetProxy(2, "*.*.*.*:****")
#include <INet.au3>
#include <Array.au3>
#include <GuiConstants.au3> ; Call Gui functions

Dim $Title, $desc, $theAIDDL

Func _SRE_Between($s_String, $s_Start, $s_End, $bCaseInsensitive = False)
    Local $sCaseFlag = ""
    If $bCaseInsensitive Then $sCaseFlag = "(?i)"
    $a_Array = StringRegExp($s_String, '(?s)' & $sCaseFlag & $s_Start & '(.*?)' & $s_End, 3)
    If IsArray($a_Array) Then Return $a_Array
    Return SetError(1, 0, 0)
EndFunc;==>_SRE_Between thanks to whoever wrote it.

Func _StringStripNonAlNum($OrigString)
;Strip out all Non Alpha-Numerics
	Local $lLen
    Local  $sAns
    Local $lCtr
    Local $sChar
    
    $lLen = StringLen($OrigString)
    For $lCtr = 1 To $lLen
        $sChar = StringMid($OrigString, $lCtr, 1)
        If StringIsAlNum(StringMid($OrigString, $lCtr, 1)) Then
            $sAns = $sAns & $sChar
        EndIf
	Next
	;$sAns contains the game name with no spaces of invaild chars 
	return $sAns
	
Endfunc


Func _flipDLswitch (Const $switch)
	; Enable or disable Download buttons
	; Eval ( string )
	Local $Gui_Flip
	
	IF $switch = 0 Then ;switch off DL group - uncheck all checkboxes
		$Gui_Flip = $GUI_UNCHECKED	
		;GUICtrlSetState ( $chk1, $Gui_Flip ) chk1 to chk8
		For $i = 1 TO 8
			GUICtrlSetState ( Eval("chk" & $i), $Gui_Flip )
		Next
		
		
	endif
	; no need to check boxes when switching on
	
	IF $switch = 1 Then ; switch on DL group - enable all boxes and buttons, and set group lable
		$Gui_Flip = $GUI_ENABLE
		GUICtrlSetData ( $DLgroup1, $DLgrouptext1 & $Title)
	Else
		$Gui_Flip = $GUI_DISABLE ; switch off reset group lable
		GUICtrlSetData ( $DLgroup1, $DLgrouptext1)
	EndIf
	
	; enable/disable depending on $switch
	;GUICtrlSetState ( $chk1, $Gui_Flip ) chk1 to chk8
	For $i = 1 TO 8
			GUICtrlSetState ( Eval("chk" & $i), $Gui_Flip )
	Next
		
	GUICtrlSetState ( $DownloadDL1, $Gui_Flip)
	GUICtrlSetState ( $StopDL1, $Gui_Flip)
	
EndFunc



Func _ClearFormDL1 ()
	GUICtrlSetImage ($thePicDL1, "")
	GUICtrlSetData ( $gameinfodisplayDL1, "" )
	GUICtrlSetData ( $AIDDL1, "" )
	_flipDLswitch (0) ;Switch off the download group
	
EndFunc

Func _ChkAID (Const $theAIDchk)
	; Check that The entered AID is a existing/Valid game ID
	;                                                                 
	;search string InvalidGame
	;_ClearFormDL1()
	Local $AIDsrcchk
	
	IF $theAIDchk <> "" THEN ; do not check for empty AID as this results in a false positive
		$AIDsrcchk = _INetGetSource("                                                        " & $theAIDchk & "&CID=0")
			IF StringInStr ( $AIDsrcchk, "InvalidGame") > 0 Then
				return 0
			Else 
				return 1
				
			endif
	Endif
	$AIDsrcchk = ""
EndFunc


Func _DLGameInfo (Const $theAIDchk )
	; With a valid AID, get and display the GameName, Game Info, Game Image
	
	Local $AIDsrc
	Local $returnTitle
	Local $returnDesc
	
	$AIDsrc = _INetGetSource("                                                             " & $theAIDchk & "&SORT=Age&CID=0")
	
	
	$returnTitle = _SRE_Between($AIDsrc, "<Title>", "</Title>", True)
	$Title = StringTrimRight ($returnTitle[0], 11) ;strip off the final word download
	; This is the game title from now on and will be the basis for the filename
	$Title = _StringStripNonAlNum($Title)
	
	;<meta name="description" content="
	;">
	$returnDesc = _SRE_Between($AIDsrc, '<meta name="description" content="', '">', True)
	;This is the game description that will become the gametitle.info file
	$desc = $returnDesc[0]
	
	$AIDsrc = 0 ; memory clear
	$returnTitle = 0
	$returnDesc = 0
	
	InetGet ( "                                          " & $theAIDchk & "_BvlGlass_200x200.jpg",@TempDir & "\" & $Title & "Setup.exe.jpg",0,0 )


	;Display the info items name,image,desc
	GUICtrlSetImage ($thePicDL1, @TempDir & "\" & $Title & "Setup.exe.jpg")
	GUICtrlSetData ( $gameinfodisplayDL1, $desc )
	;GUICtrlSetData ( $DLgroup1, $DLgrouptext1 & $Title) 
	_flipDLswitch (1) ; game exists and info displayed, switch on download group ready for download.
	
EndFunc

Func _DLGame (Const $theAIDchk, Byref $go_stop)
	;Once Game is confirmed download it to correct folder, deal with _DLGameInfo data,
	;create cat gamename.game files from checkboxes.
	; Deal with start|stop DL events, possibly disable check_AID buttons while DL event
	
EndFunc

;The GUI
$DL1 = GuiCreate ("Reflexive Arcade Collection - Download A Game" , 430, 370)
GuiSetIcon("TheArcade\Extras\icons\reflexive.ico", 0, $DL1)
GuiSetBkColor(0XFFFFFF, $DL1)

;Create the Game Image
$thepicDL1 = GuiCtrlCreatePic("",10,10, 0,0)


;The edit box
$gameinfodisplayDL1 = GUICtrlCreateEdit ("", 220,10,200,200, BitOR($ES_READONLY, $WS_VSCROLL))
GUICtrlSetBkColor ($gameinfodisplayDL1,0XFFFFFF)
GUICtrlSetState ( $gameinfodisplayDL1, $GUI_ENABLE )


; The Input box for AID to download
GUICtrlCreateLabel ( "Enter The Game AID To Download", 10, 225)
$AIDDL1 = GUICtrlCreateInput ( "", 190, 220, 35,20 , $ES_NUMBER )

;the buttons
$CheckAIDDL1 = GUICtrlCreateButton ( "Check AID", 10, 250, 80, 30) 
$ClearDL1 = GUICtrlCreateButton ( "Clear", 10, 290, 80, 30)
$CloseDL1 = GUICtrlCreateButton ( "Close", 10, 330, 80, 30)


;The download check box group
$DLgrouptext1 = "Choose The Categories For: "
$DLgroup1 = GuiCtrlCreateGroup($DLgrouptext1, 100, 250, 320, 110)
$chk1 = GUICtrlCreateCheckbox ("Action", 110, 270)
$chk2 = GUICtrlCreateCheckbox ("Breakout", 110, 310)
$chk3 = GUICtrlCreateCheckbox ("Card", 200, 270)
$chk4 = GUICtrlCreateCheckbox ("Multi", 200, 310)
$chk5 = GUICtrlCreateCheckbox ("Puzz", 110, 290)
$chk6 = GUICtrlCreateCheckbox ("Shooter", 110, 330)
$chk7 = GUICtrlCreateCheckbox ("Strat", 200, 290)
$chk8 = GUICtrlCreateCheckbox ("Word", 200, 330)
$DownloadDL1 = GUICtrlCreateButton ( "Download", 300, 275, 80, 30) 
$StopDL1 = GUICtrlCreateButton ( "Stop", 300, 315, 80, 30) 
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group


_ClearFormDL1 () ;set initial gui status
GUICtrlSetState($AIDDL1, $GUI_FOCUS) ;put focus to input box
GUISetState(@SW_SHOW ,$DL1) ;redraw all items before main routine starts

While 1
	$msg = GUIGetMsg() ; get the event message from the form
	Select
		Case $msg = $ClearDL1	;Click on Clear
			_ClearFormDL1 ()
			GUICtrlSetState($AIDDL1, $GUI_ENABLE) 
			
		Case $msg = $CheckAIDDL1  ;Click the check button
			; disable the inputbox as dont want aid to change between aid-chk and aid-Download
			GUICtrlSetState($AIDDL1, $GUI_DISABLE)
			IF _ChkAID (GUICtrlRead($AIDDL1)) Then
				_DLGameInfo (GUICtrlRead($AIDDL1))
			Else
				GUICtrlSetData ( $gameinfodisplayDL1, "Invaild Game AID" )
			Endif
			
		Case $msg = $GUI_EVENT_CLOSE	;Click on close X
			ExitLoop
			
		Case $msg = $CloseDL1	;Click on close
			ExitLoop
	EndSelect
Wend