; http://msdn.microsoft.com/msdnmag/issues/1200/TypeLib/
Opt('MustDeclareVars', 1)
opt("GUIOnEventMode", 1)

;Includes
#include <GuiConstants.au3>
#include <GuiListView.au3>
#Include <GuiTreeView.au3>
#include <GuiTab.au3>
#include <Array.au3>
#NoTrayIcon

;Declare Vars
Global $TreeView, $tliTypeLibInfo
; Global Const $WM_XBUTTONDOWN = 0x0207

;Events
Global Const $NM_FIRST = 0
Global Const $NM_CLICK = ($NM_FIRST - 2)
Global Const $NM_DBLCLK = ($NM_FIRST - 3)
Global Const $NM_RCLICK = ($NM_FIRST - 5)
Global Const $TVM_HITTEST = ($TV_FIRST + 17)

; Constants
Const $INVOKE_UNKNOWN = 0
Const $INVOKE_FUNC = 1
Const $INVOKE_PROPERTYGET = 2
Const $INVOKE_PROPERTYPUT = 4
Const $INVOKE_PROPERTYPUTREF = 8
Const $INVOKE_EVENTFUNC = 16
Const $INVOKE_CONST = 32
Const $TKIND_ENUM = 0
Const $TKIND_RECORD = 1
Const $TKIND_MODULE = 2
Const $TKIND_INTERFACE = 3
Const $TKIND_DISPATCH = 4
Const $TKIND_COCLASS = 5
Const $TKIND_ALIAS = 6
Const $TKIND_UNION = 7
Const $TKIND_MAX = 8

Dim $Font ="Arial Bold"
Dim $Gui, $Filemenu, $oMyError, $Menu, $Helpmenu, $Helpitem, $Infoitem, $Tab, $Tab1, $Tab2
Dim $contexCut, $contexCopy, $contexPaste, $Label1, $Label2, $ListView1, $Listbox3
Dim $sPath
Dim $sMembers, $MemberNames, $OpenTLib
Dim $TVItem, $TextItem, $SysKind, $Ret, $iCount, $i

;Declare Objects
$tliTypeLibInfo =ObjCreate("TLI.TypeLibInfo")

; Initialize error handler 
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

;----------------------------------------- Main GUI ------------------------------------
$Gui = GuiCreate("Object Browser v1.0", 975, 571,(@DesktopWidth-975)/2, (@DesktopHeight-571)/2 , _ 
$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIevent") ; Close GuiEvent

;Menu Controls
$Filemenu = GUICtrlCreateMenu("File")
$OpenTLib = GUICtrlCreateMenuItem("Open Tlib", $Filemenu)
GUICtrlSetOnEvent(-1,"_Open")

$Helpmenu = GUICtrlCreateMenu ("?")
$Helpitem = GUICtrlCreateMenuitem ("Help",$Helpmenu)
$Infoitem = GUICtrlCreateMenuitem ("Info",$Helpmenu)

;Button Control
; .....

;Tab Control
$Tab=GUICtrlCreateTab (210,10, 765,540)
GUICtrlSetResizing ($Tab,$GUI_DOCKAUTO)

;TreeView
$TreeView= GUICtrlCreateTreeView(8, 10, 200, 538, BitOr($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, _
$TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
GUICtrlSetImage (-1, "mmcndmgr.dll",-113)
GUICtrlSetState($TreeView,$GUI_FOCUS)
$Menu = GUICtrlCreateContextMenu($TreeView)
$contexCut = GUICtrlCreateMenuitem("Cut", $Menu)
$contexCopy = GUICtrlCreateMenuitem("Copy", $Menu)
$contexPaste = GUICtrlCreateMenuitem("Paste", $Menu)

;Tab1
$Tab1=GUICtrlCreateTabitem ("ClassMember Data ")

;ListView Control
$Label1 = GUICtrlCreateLabel("Member of ",215, 35, 100, 20,"")
$Label2 = GUICtrlCreateLabel("",267, 33, 150, 20,"")
GUICtrlSetColor(-1, 0x0000C0)
GUICtrlSetFont (-1,9,400,"","Arial Bold")

$ListView1 = GUICtrlCreateListView(" ", 213, 50, 755, 355,$LVS_NOCOLUMNHEADER + $LVS_SORTASCENDING)
_GUICtrlListViewSetColumnWidth ($ListView1, 0, 500)
GUICtrlSetResizing ($ListView1,$GUI_DOCKAUTO)

;Tab2
$Tab2=GUICtrlCreateTabitem ("Summary Info ")

$Listbox3 = GUICtrlCreateList("", 213, 50, 755, 355,"")
GUICtrlSetResizing ($ListView1,$GUI_DOCKAUTO)
GUICtrlCreateLabel("TypeLib Details: ",215,35)
GUICtrlSetColor(-1,0xff0000) ;Set Red color
GUICtrlSetFont (-1,7.5, 100, 4, $font) ;Set Font

GUICtrlSetState($Tab1,$GUI_SHOW) ;Show first Tab as default
GUICtrlSetState($ListView1,$GUI_FOCUS) ;Set focus on Listbox

;GUI handling
;------------
;Register WM events
;GUIRegisterMsg($WM_XBUTTONDOWN, "TVClick")

GuiSetState()

While 1
	Sleep(100)
WEnd

;----------------------------- Main -------------------------------------------
Func _Open()
Local $sFile, $TVItem
	$sPath = FileOpenDialog("Open Type Library", @ScriptDir, "Type Libraries (*.tlb;*.olb;*.dll;*.ocx);*.tlb;*.olb;*.dll;*.ocx;*.*)")
	If $sPath = "" Then 
		Return 	; Exit
	EndIf
		
	GuiSetState(@SW_LOCK)
		_GUICtrlTreeViewDeleteAllItems ($MemberNames)
	
	$tliTypeLibInfo.ContainingFile = "tlbinf32.dll" ;$sPath ;"tlbinf32.dll" ; $sPath The file to expose its TLB info.
	
	If $oMyError.description <> "" Then
		Return
	Else
	
	GUICtrlCreateTreeViewitem("<Global>", $Treeview)
	ConsoleWrite("All Classes Names : "& @CRLF)
	For $tliTypeInfo In $tliTypeLibInfo.TypeInfos
	$sMembers = $tliTypeInfo.Name
	ConsoleWrite($tliTypeInfo.Name & " TypeKind " & $tliTypeInfo.TypeKind & " Index " & $tliTypeInfo.TypeKindString & $tliTypeInfo.TypeInfoNumber & @CRLF)
	ConsoleWrite(@CRLF)
		If StringLeft($sMembers,1) <> "_" then
		$MemberNames = GUICtrlCreateTreeViewitem($sMembers, $Treeview)
		GUICtrlSetOnEvent($MemberNames,"_TreeMemberClick") ; Get TableData on Click 
		GUICtrlSetColor(-1, 0x0000C0)
		;GUICtrlSetData($ListView1,"")
		EndIf
	Next
		_GetSummaryInfo()
	EndIf
	_GUICtrlTreeViewSort ($treeview)
	GuiSetState(@SW_UNLOCK)
EndFunc

Func _TreeMemberClick()
	If _GUICtrlTreeViewGetParentID($TreeView) = 0 then
	$TVItem = GUICtrlRead(GUICtrlRead($treeview),1)
		_GetMembers($TVItem)
	Else
		Return 
	EndIf
Endfunc

Func _GetMembers($GetEnumName)
GuiSetState(@SW_LOCK)
GUICtrlSetState($ListView1,$GUI_FOCUS)
GUICtrlSetData($Label2,$GetEnumName)
	_GUICtrlListViewDeleteAllItems($ListView1)

For $tliTypeInfo In $tliTypeLibInfo.TypeInfos
	If BitAND($tliTypeInfo.Name = $GetEnumName , $tliTypeInfo.TypeKind < 5)  Then 
	; Now we have to search each member to find the correct value.
		For $oTLMember In $tliTypeInfo.Members
                $GetEnumName = $oTLMember.Name
				If StringLeft($GetEnumName,1) <> "_" then 
					$MemberNames = GUICtrlCreateListViewItem($GetEnumName,$ListView1)
                GUICtrlSetOnEvent($MemberNames,"_MemberClick") ; Get LVData on Click 
				EndIf
        Next 
    EndIf
Next
GuiSetState(@SW_UNLOCK)
EndFunc

Func _MemberClick()
	If _GUICtrlListViewGetItemText($ListView1) = 0 then
	$TextItem = GUICtrlRead(GUICtrlRead($ListView1),1)
		_GetInfo($TextItem)
	Else
		Return 
	EndIf
EndFunc

Func _GetInfo($GetInfo)
;GUICtrlSetData($Label2,$GetEnumName)

;$tliTypeInfo.HelpString
EndFunc

;----------------------------Summary info --------------------------------------------------
Func _GetSummaryInfo()
GUICtrlSetData($Listbox3,"")
GUICtrlSetData($Listbox3,"Info # : " & $tliTypeLibInfo.TypeInfoCount)
GUICtrlSetData($Listbox3,"Name : " & $tliTypeLibInfo.Name )
GUICtrlSetData($Listbox3,"File : " & $tliTypeLibInfo.ContainingFile)
GUICtrlSetData($Listbox3,"String : " & $tliTypeLibInfo.HelpString)
GUICtrlSetData($Listbox3,"Version : " & $tliTypeLibInfo.MajorVersion & "." & $tliTypeLibInfo.MinorVersion)
GUICtrlSetData($Listbox3,"HelpFile : " & StringLower($tliTypeLibInfo.HelpFile))
GUICtrlSetData($Listbox3,"GUID : " & $tliTypeLibInfo.Guid)

$SysKind = $tliTypeLibInfo.SysKind
	Switch $SysKind
	Case 1
	GUICtrlSetData($Listbox3,"System : Win32")
	Case 0
	GUICtrlSetData($Listbox3,"System : Win16")
	Case 2
	GUICtrlSetData($Listbox3,"System : Macintosh")
	EndSwitch

; Short way TKIND_COCLASS 
; these are classes that can be created using the New, CreateObject, or GetObject Keywords
GUICtrlSetData($Listbox3, " ")
GUICtrlSetData($Listbox3, "CreateObject or GetObject Keywords :")
Local $tliCoClassInfo
	For $tliCoClassInfo In $tliTypeLibInfo.CoClasses
	GUICtrlSetData($Listbox3, $tliTypeLibInfo.Name & "." & $tliCoClassInfo.Name )
	Next
EndFunc

Consolewrite( @CRLF)

; -------- Members ------------------
$Ret = ""
$iCount = $tliTypeLibInfo.Members.Count
$i = 1
	while $i <= $iCount
	$Ret = $Ret & $tliTypeLibInfo.Members.Item($i).Name & @CRLF
	$i += 1
	Wend
Consolewrite("Members # : " & $iCount & @CRLF)
Consolewrite( $Ret & @CRLF)


;----------------------------- Gui Events ------------------------------------
Func GUIevent()
	Exit
EndFunc

;------------------------------ This is a COM Error handler --------------------------------
Func MyErrFunc()
Local $HexNumber
$HexNumber=hex($oMyError.number,8)
	Msgbox(0,"COM Error ","We intercepted a COM Error !" & @CRLF & @CRLF & _
	"err.description is: " & @TAB & $oMyError.description & @CRLF & _
	"err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
	"err.number is: " & @TAB & $HexNumber & @CRLF & _
	"err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
	"err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
	"err.source is: " & @TAB & $oMyError.source & @CRLF & _
	"err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
	"err.helpcontext is: " & @TAB & $oMyError.helpcontext _
	)
	SetError(1) ; to check for after this function returns
Endfunc
