; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.124
; Author:         Stephen Podhajecki eltorro <gehossafats@netmdc.com>
; Version: 0.1
;
; Script Function:
;
; ----------------------------------------------------------------------------
#Include <_XMLDomWrapper.au3>; change this to your needs
#Include <Array.au3>
;_SetDebug(True)
opt("MustDeclareVars", 1)
;===============================================================================
Global $xmlFile
Global $count = 0
Global $sNxPath, $fHwnd
;===============================================================================

$xmlFile = FileOpenDialog("Open XML", @ScriptDir, "XML (*.XML)", 1)
If @error Then
    MsgBox(4096, "File Open", "No file chosen , Exiting")
    Exit
EndIf

Main()

Exit
;===============================================================================
;Funcs
;===============================================================================
Func Main()
    Local $szXPath, $aNodeName, $find, $ns, $oXSD,$iNodeCount,$aAttrName[1],$aAttrVal[1],$ret_val
    ;Local $xmlFile = "C:\cookbook" & ".xml"
    $ns = ""
    $oXSD = _XMLFileOpen ($xmlFile, $ns)
    If @error Or $oXSD < 1 Then
        MsgBox(0, "Error", "There was an error opening the file " & $xmlFile)
        $oXSD = 0
        Exit
    EndIf
    $szXPath = "//DATAPACKET/ROWDATA"
    $iNodeCount = _XMLGetNodeCount($szXPath & "/*")
    MsgBox(0,"Node Count",$iNodeCount)

    $aNodeName = _XMLGetChildNodes ($szXPath); get a list of node names under this path
    If $aNodeName <> - 1 Then
        For $find = 1 To $aNodeName[0]
            ConsoleWrite($aNodeName[$find]& '[' & $find & ']'&@LF)
            ;It's better to use node index instead of node name as all node here have same name.
          _XMLGetAllAttrib($szXPath & "/*" & '[' & $find & ']',$aAttrName,$aAttrVal)
             _ArrayDisplay($aAttrName,$szXPath & "/*" & '[' & $find & ']')
             _ArrayDisplay($aAttrVal,$szXPath & "/*" & '[' & $find & ']')

        Next
        MsgBox(266288,"_XMLWrapper","Done")
    Else
        MsgBox(0, "Error:", "No nodes found for " & $szXPath)
    EndIf
    $oXSD = 0
EndFunc;==>Main
