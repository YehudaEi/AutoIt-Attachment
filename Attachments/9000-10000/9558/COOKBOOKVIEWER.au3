; AutoIt Version: 	3.1.1.128
; Author:         	Stephen Podhajecki eltorro <gehossafats@netmdc.com>
; Modified by: 		WeaponX <ghostofagoodthing@gmail.com>
; Version: 0.5
;
; Script Function: Populate Array from cookbook.xml, display in listview
;
; ----------------------------------------------------------------------------
#Include <_XMLDomWrapper.au3>; change this to your needs
#Include <Array.au3>
#include <GUIConstants.au3>

;_SetDebug(True)
opt("MustDeclareVars", 1)
;===============================================================================
Global $xmlFile
Global $count = 0
Global $sNxPath, $fHwnd
Global $ARRAY[1][1]
Global $ARRAYX
Global $ARRAYY
;===============================================================================
;Manual XML path for testing, comment out
;$xmlFile = "D:\Design\Archrival Assembler\Old Versions\cookbook.xml"

If $xmlFile = "" Then
	$xmlFile = FileOpenDialog("Open XML", @ScriptDir, "XML (*.XML)", 1)
	If @error Then
		MsgBox(4096, "File Open", "No file chosen , Exiting")
    Exit
	EndIf
EndIf

Main()
Gui()
Exit

Func Main()
    Local $szXPath1,$szXPath2, $aNodeName1,$aNodeName2, $find, $oXSD,$iNodeCount,$aAttrName1[1],$aAttrVal1[1],$aAttrName2[1],$aAttrVal2[1],$ret_val,$X
    $oXSD = _XMLFileOpen ($xmlFile, "")
    If @error Or $oXSD < 1 Then
        MsgBox(0, "Error", "There was an error opening the file " & $xmlFile)
        $oXSD = 0
        Exit
    EndIf
	
	$szXPath1 = "//DATAPACKET/METADATA/FIELDS"
    $szXPath2 = "//DATAPACKET/ROWDATA"
	
	$ARRAYX = _XMLGetNodeCount($szXPath1 & "/*")
	$ARRAYY = _XMLGetNodeCount($szXPath2 & "/*")
	ReDim $ARRAY[$ARRAYX][$ARRAYY+1]

	$aNodeName1 = _XMLGetChildNodes ($szXPath1)
	$aNodeName2 = _XMLGetChildNodes ($szXPath2)
    If $aNodeName1 <> -1 Then
        ;LOOP THROUGH //DATAPACKET/METADATA/FIELDS
		For $find = 1 To $aNodeName1[0]
			_XMLGetAllAttrib($szXPath1 & "/*" & '[' & $find & ']',$aAttrName1,$aAttrVal1)
			;ADD TO ARRAY
			$ARRAY[$find-1][0] = $aAttrVal1[0]
			;LOOP THROUGH //DATAPACKET/ROWDATA
			For $X=1 To $aNodeName2[0]
				_XMLGetAllAttrib($szXPath2 & "/*" & '[' & $X & ']',$aAttrName2,$aAttrVal2)
				;ONLY APPEND IF CURRENT FIELD NIMBER IS LESS THAN NUMBER OF ATTRIBS FOUND IN EACH ROW
				If $find <= Ubound($aAttrName2) Then
				$ARRAY[$find-1][$X] = $aAttrVal2[$find-1]
				EndIf
			Next
        Next
    Else
        MsgBox(0, "Error:", "No nodes found for " & $szXPath1)
    EndIf

    $oXSD = 0
EndFunc;==>Main

Func GUI()
	Local $msg
	Local $listview
	Local $X = 0
	Local $Y = 1
	Local $HEADER
	Local $COL
	Local $ROW
	
	GUICreate("Cookbook",600,300)  ; will create a dialog box that when displayed is centered
	GUISetState (@SW_SHOW)       ; will display an empty dialog box
	
	;CREATE HEADER FOR LISTVIEW
	While $X < Ubound($ARRAY)
		$HEADER = $HEADER & $ARRAY[$X][0] & "|"
		$X=$X+1
	WEnd
	
	$listview = GUICtrlCreateListView ($HEADER ,5,5,590,290);,$LVS_SORTDESCENDING)
	
	;Loop through $ARRAY (from "//DATAPACKET/ROWDATA")
	$Y = 1
	While $Y < Ubound($ARRAY,2)
		;Loop through $ARRAY (from "//DATAPACKET/METADATA/FIELDS")
		$X=0
		$ROW = ""
		While $X < Ubound($ARRAY)
			$ROW = $ROW & $ARRAY[$X][$Y] & "|"
			$X=$X+1
		WEnd
		GUICtrlCreateListViewItem ($ROW,$listview)
		$Y=$Y+1
	WEnd
While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
Wend
EndFunc

