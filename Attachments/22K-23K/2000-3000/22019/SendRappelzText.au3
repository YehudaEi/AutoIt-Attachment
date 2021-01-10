
; TODO : implement dynamic change in button press duration using <RAPPELZ_BUTTON_PRESS_DURATION_30>  and  SendKeyDownDelay param
; TODO : implement <RAPPELZ_BUTTON_PRESS_DELAY_30>  delay betweeen key press


#include "GuiButton.au3"

Const $RAPPELZ_TEXTER_INIFILE_NAME = "RappelzChatUtility.ini"
Const $RAPPELZ_TEXTER_INIFILE_SECTION_GENERAL = "General"
Const $RAPPELZ_TEXTER_INIFILE_WINDOWSEARCH_TOKEN = "RappelzWindowSearchString"
const $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN = "RAPPELZ_TEXTER_INIFILE_FAILURE"
const $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN_VALUE = "TRUE"
const  $RAPPELZ_TEXTER_MAX_PARAM = 20
const $MAX_DEBUG_STATECOUNT = 4
const $RAPPELZ_TEXTER_INIFILE_TOKEN_COUNT="Count"
const $RAPPELZ_TEXTER_INIFILE_TOKEN_CHATPHRASE="Chat"
const $RAPPELZ_TEXTER_INIFILE_TOKEN_BUTTONCHATPHRASE="ButtonChat"
const $RAPPELZ_TEXTER_INIFILE_SECTION_CHAT="Chat"
const $RAPPELZ_TEXTER_INIFILE_SECTION_COMMAND="Command"
const $RAPPELZ_TEXTER_INIFILE_SECTION_TOKENS="Tokens"
const $RAPPELZ_TEXTER_DISPLAY_HEIGHT_FACTOR=0.5
const $RAPPELZ_TEXTER_DISPLAY_WIDTH_FACTOR=0.5
const $RAPPELZ_TEXTER_GUI_TOP_FACTOR=0.2
const $RAPPELZ_TEXTER_GUI_LEFT_FACTOR=0.2

const $RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDELAY="DelaySliderMax"
const $RAPPELZ_TEXTER_INIFILE_TOKEN_MINDELAY="DelaySliderMin"
const $RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDURATION="DurationSliderMax"
const $RAPPELZ_TEXTER_INIFILE_TOKEN_MINDURATION="DurationSliderMin"

Const $GUI_LIST_SEPARATOR = "|"

const  $RAPPELZ_TEXTER_GUI_WINDOWTITLE = "Game Chat and Sequenced Command Utility"
const  $RAPPELZ_TEXTER_VERSION = "1.0.0"

global $curDebug = 1
global $commandfinished = true
global $buttonstatechanged = False

global $mylist
global $myedit
global $slider1 
global $checkpadwithenter

global $maxdelay
global $mindelay
global $maxduration
global $minduration
global $curduration
global $curdelay

global $DisplayHeight = @DesktopHeight
global $DisplayWidth = @DesktopWidth
; TODO : work on dynamic GUI size change
global $MainRectTopLeftX = ($RAPPELZ_TEXTER_DISPLAY_HEIGHT_FACTOR * $DisplayWidth)
global $MainRectTopLeftY= ($RAPPELZ_TEXTER_DISPLAY_HEIGHT_FACTOR * $DisplayWidth)
global $MainRectRightX= ($RAPPELZ_TEXTER_DISPLAY_HEIGHT_FACTOR * $DisplayWidth)
global $MainRectRightY= ($RAPPELZ_TEXTER_DISPLAY_HEIGHT_FACTOR * $DisplayWidth)

dim $curWintitle
dim $curchatline
dim $RappelzParam[$RAPPELZ_TEXTER_MAX_PARAM][$RAPPELZ_TEXTER_MAX_PARAM] 
dim $RappelzChat[$RAPPELZ_TEXTER_MAX_PARAM][$RAPPELZ_TEXTER_MAX_PARAM] 
dim $RappelzCommand[$RAPPELZ_TEXTER_MAX_PARAM][$RAPPELZ_TEXTER_MAX_PARAM] 

AutoItSetOption ( "WinTitleMatchMode" ,2 )
AutoItSetOption ( "GUIDataSeparatorChar" ,"|" )
;SendKeyDownDelay
;SendKeyDelay
AutoItSetOption ( "SendKeyDownDelay" ,$curduration )
AutoItSetOption ( "SendKeyDelay" ,$curdelay )




#include <GuiConstantsEx.au3>
#include <AVIConstants.au3>
#include <TreeViewConstants.au3>

; GUI
GuiCreate($RAPPELZ_TEXTER_GUI_WINDOWTITLE & " " & $RAPPELZ_TEXTER_VERSION, 400, 400)
GuiSetIcon(@SystemDir & "\mspaint.exe", 0)

InitialiseParams ()

; BUTTON
$Button_1 = GuiCtrlCreateButton("Envoyer", 10, 330, 100, 30)



    $mylist = GUICtrlCreateList("", 20, 32, 300, 97)

$myedit = GUICtrlCreateEdit("#", 10, 132, 300, 97)

		$checkpadwithenter = GUICtrlCreateCheckbox("Padded with Enter on left and right", 20,250, 250, 20)


$delayslider = GUICtrlCreateSlider(10, 10, 200, 20)
	GUICtrlSetLimit(-1, $maxdelay, $mindelay)
$durationslider = GUICtrlCreateSlider(210, 10, 200, 20)
	GUICtrlSetLimit(-1, $maxduration, $minduration)

InitialiseDisplay()


; GUI MESSAGE LOOP
GuiSetState()
While GuiGetMsg() <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
				if $commandfinished and $buttonstatechanged then
					GUICtrlSetState($Button_1, $GUI_ENABLE)
					$buttonstatechanged = false
				EndIf
		Select
            Case $msg == $GUI_EVENT_CLOSE
                ExitLoop
            Case $msg == $Button_1
				
				if $commandfinished then
					GUICtrlSetState($Button_1, $GUI_DISABLE)
					$buttonstatechanged = false
                ;displayNotepad()    ; Will Run/Open Notepad
				$curchatline = GUICtrlRead($myedit)
				WinActivate($curWintitle , "")
	
			;debugmess("inread")
			SendToRappelz($curchatline)	
				
						$buttonstatechanged = true
						$commandfinished = true
  		
				Else	
					; do nothing while not finished
				EndIf
			
			case $msg == $mylist
			debugmess("inread")
			
			$curchatline = GUICtrlRead($mylist)
			WinActivate($curWintitle , "")
	
			debugmess("inread" & $curduration  & " delay " & $curdelay)
			AutoItSetOption ( "SendKeyDownDelay" ,$curduration )
			AutoItSetOption ( "SendKeyDelay" ,$curdelay )

			SendToRappelz($curchatline)		
			
		case $msg == $GUI_EVENT_RESIZED
			
		case $msg == $myedit
			debugmess("Free Text Send" & $curduration  & " delay " & $curdelay)
			AutoItSetOption ( "SendKeyDownDelay" ,$curduration )
			AutoItSetOption ( "SendKeyDelay" ,$curdelay )
				$curchatline = GUICtrlRead($myedit)
				WinActivate($curWintitle , "")
	
			;debugmess("inread")
			SendToRappelz($curchatline)	

		case $msg = $durationslider
			;debugmess("duration slide" & $curduration  & " delay " & $curdelay)

			$curduration = GUICtrlRead($durationslider)
			debugmess("duration slide" & $curduration  & " delay " & $curdelay)
	case $msg = $delayslider
			$curdelay = GUICtrlRead($delayslider)
			debugmess("delay slide" & $curduration  & " delay " & $curdelay)

        EndSelect

	
	
WEnd


func InitialiseParams()
if  GetRappelezTexterParams($RappelzParam,$RAPPELZ_TEXTER_INIFILE_SECTION_GENERAL) then


		debugmess("initili")
$listcontent = ""
if $RappelzParam [0][0] == $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN Then
	$curWintitle = $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN
Else
	$curWinTitle = GetHashByKeyword($RappelzParam,$RAPPELZ_TEXTER_INIFILE_WINDOWSEARCH_TOKEN)
	;$curWintitle = $RappelzParam[_ArraySearch($RappelzParam,$RAPPELZ_TEXTER_INIFILE_WINDOWSEARCH_TOKEN)][1]
	
;const $RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDELAY="DelaySliderMax"
;const $RAPPELZ_TEXTER_INIFILE_TOKEN_MINDELAY="DelaySliderMin"
;const $RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDURATION="DurationSliderMax"
;const $RAPPELZ_TEXTER_INIFILE_TOKEN_MINDURATION="DurationSliderMin"
	
$maxdelay= GetHashByKeyword($RappelzParam,$RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDELAY)
$mindelay= GetHashByKeyword($RappelzParam,$RAPPELZ_TEXTER_INIFILE_TOKEN_MINDELAY)
$maxduration= GetHashByKeyword($RappelzParam,$RAPPELZ_TEXTER_INIFILE_TOKEN_MAXDURATION)
$minduration= GetHashByKeyword($RappelzParam,$RAPPELZ_TEXTER_INIFILE_TOKEN_MINDURATION)

EndIf

else  ; if GetRappelezTexterParams($RappelzParam)
	
	    MsgBox(0, "", "Failed to get INI")

EndIf
	
EndFunc


func InitialiseDisplay()
dim $i
dim $ChatArray[20]
dim $listcontent

if GetRappelzTexterEnumSetByIniSection($ChatArray,$RAPPELZ_TEXTER_INIFILE_SECTION_CHAT) Then
	
	for $i = 0 to Ubound($ChatArray,1) - 1
		
		$listcontent =  $ChatArray[$i] & $GUI_LIST_SEPARATOR  & $listcontent 
		debugmess($ChatArray[$i])
	
	
Next
		debugmess("LIST CONTENTS " & $listcontent)

	GUICtrlSetData($mylist, $listcontent)

	
	;$mylist
EndIf
	

debugmess("afterini")

	
EndFunc

func displayNotepad()
	
	$commandfinished = false


;If WinExists("Sans titre - Bloc-notes") Then
If WinExists($curWintitle) Then
    mess(0, "", "Window " & $curWintitle & "exists - going to activate it")
	
	;WinActivate("[CLASS:Notepad]", "")
	WinActivate($curWintitle , "")

	
	Send("This is a test" )
	
Else
   mess(0, "", "Could not find window" & $curWintitle)
	
EndIf
$commandfinished = true

EndFunc

func GetRappelezTexterParams(byref $arrayparam,$sectionname = $RAPPELZ_TEXTER_INIFILE_WINDOWSEARCH_TOKEN)
	local $retval
	local $thisfolder
	local $iniparams
	local $inifullpath
	local $cursectionname
	local $curarryparam[$RAPPELZ_TEXTER_MAX_PARAM][$RAPPELZ_TEXTER_MAX_PARAM]
	
	$thisfolder = @ScriptDir
	
	$inifullpath = $thisfolder & "\" & $RAPPELZ_TEXTER_INIFILE_NAME 
	
	if not IsString($sectionname) Then
		$cursectionname = $RAPPELZ_TEXTER_INIFILE_SECTION_GENERAL
	Else
		$cursectionname = $sectionname
	EndIf
		mess(0,"","opening " & $inifullpath & " for " & $cursectionname)
	$iniparams = IniReadSection ( $inifullpath, $cursectionname  )
	
		if @error Then
			mess(0, "", "iniread failed")
			
		Else	
	
			Mess(0, "", $iniparams[0][0] )
		endif
	
	if IsArray($iniparams) Then
		
				if CopyArray($iniparams,$arrayparam) Then
					$retval = True
			Else
			$retval = False
	
			EndIf
	Else
		$curarryparam[0][0] = $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN
		$curarryparam[0][1] = $RAPPELZ_TEXTER_INIFILE_FAILURE_TOKEN_VALUE
		
		if CopyArray($curarryparam,$arrayparam) Then
		$retval = False
	Else
			$retval = False
	
		EndIf
	EndIf
	
	return $retval
EndFunc

func CopyArray(byref $ArraySrc, byref $ArrayDest)
	
	if IsArray($ArraySrc) Then
		
		if Ubound($ArraySrc,0) = 2 then
		
			for $x = 0 to ubound($ArraySrc,1)-1
				
				;MsgBox(True,"r",ubound($ArraySrc,1) & "by" & ubound($ArraySrc,2))
			
				for $y = 0 to Ubound($ArraySrc,2)-1
					
					$ArrayDest[$x][$y] = $ArraySrc[$x][$y]
					
					
				Next	
				
			next 
		
		elseif Ubound($ArraySrc,0) = 1 then
			for $x = 0 to ubound($ArraySrc,1)-1
				
			
					
					$ArrayDest[$x] = $ArraySrc[$x]
					
				
			next 		
		
		EndIf
		
	EndIf
	return True
EndFunc

func mess($flag,$title,$text,$level = $MAX_DEBUG_STATECOUNT)
	
	if (($curDebug > 0) and ($level <= $curDebug)) Then
		
		MsgBox($flag,$title,$text)
		
	EndIf
	
EndFunc


Func _ArraySearch(Const ByRef $avArray, $vValue, $iStart = 0, $iEnd = 0, $iCase = 0, $iPartial = 0, $iForward = 1, $iSubItem = 0)
	If Not IsArray($avArray) Then Return SetError(1, 0, -1)

	Local $iUBound = UBound($avArray) - 1

	; Bounds checking
	If $iEnd < 1 Or $iEnd > $iUBound Then $iEnd = $iUBound
	If $iStart < 0 Then $iStart = 0
	If $iStart > $iEnd Then Return SetError(4, 0, -1)

	; Direction (flip if $iForward = 0)
	Local $iStep = 1
	If Not $iForward Then
		Local $iTmp = $iStart
		$iStart = $iEnd
		$iEnd = $iTmp
		$iStep = -1
	EndIf

	; Search
	Switch UBound($avArray, 0)
		Case 1 ; 1D array search
			If Not $iPartial Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringInStr($avArray[$i], $vValue, $iCase) > 0 Then Return $i
				Next
			EndIf
		Case 2 ; 2D array search
			Local $iUBoundSub = UBound($avArray, 2) - 1
			If $iSubItem < 0 Then $iSubItem = 0
			If $iSubItem > $iUBoundSub Then $iSubItem = $iUBoundSub

			If Not $iPartial Then
				If Not $iCase Then
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i][$iSubItem] = $vValue Then Return $i
					Next
				Else
					For $i = $iStart To $iEnd Step $iStep
						If $avArray[$i][$iSubItem] == $vValue Then Return $i
					Next
				EndIf
			Else
				For $i = $iStart To $iEnd Step $iStep
					If StringInStr($avArray[$i][$iSubItem], $vValue, $iCase) > 0 Then Return $i
				Next
			EndIf
		Case Else
			Return SetError(7, 0, -1)
	EndSwitch

	Return SetError(6, 0, -1)
EndFunc   ;==>_ArraySearch

func GetHashByKeyword(byref $HashArray,$keyword)
	
	local $valret
	
	$valret = $HashArray[_ArraySearch($HashArray,$keyword)][1]
	
	return $valret
	
EndFunc

func GetRappelzTexterEnumSetByIniSection(byref $EnumArray, $keyword)
	local $valret
	local $SectionContents[$RAPPELZ_TEXTER_MAX_PARAM][$RAPPELZ_TEXTER_MAX_PARAM] 
	local $countmin
	local $countmax
	local $valueArray[1]
	
	if GetRappelezTexterParams($SectionContents,$keyword) Then
		$countmax = GetHashByKeyword($SectionContents,$RAPPELZ_TEXTER_INIFILE_TOKEN_COUNT)
		$countmin = 1
		
		for $t = $countmin to $countmax
			redim $valueArray[$t]
			$valueArray[$t-1] = GetHashByKeyword($SectionContents,$RAPPELZ_TEXTER_INIFILE_SECTION_CHAT & $t)
			
		Next	
		
		redim $EnumArray[$countmax]
	Else
		
	EndIf
	
	if isarray($SectionContents) then
	
		CopyArray($valueArray,$EnumArray)
	
		return true
	Else
			return False

	EndIf
	
EndFunc


func debugmess($str)
	
	mess(0,"Debug Info",$Str,4)
EndFunc

Func SendToRappelz($str)
	
	; TODO : implement use of <RAPPELZ_CHAT_LINE_TOKEN>  which is stored in Ini
	if GUICtrlRead($checkpadwithenter) == $GUI_UNCHECKED Then
		Send( $str )
	
	Else
		Send("{ENTER}" & $str & "{ENTER}")
	EndIf
EndFunc