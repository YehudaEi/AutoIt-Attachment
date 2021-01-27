#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/so
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;===============================================================================
; CodeGrabber.au3 - Copy and paste Autoit Forum scripts between IE and ScITE
; Version: 0.70 (beta) 06/23/2009
; Author : Spiff59
;===============================================================================
#include <WindowsConstants.au3>
#include <GuiListView.au3>
#include <GuiConstantsEx.au3> 
#include <File.au3> 
#include <Array.au3> 

If DllCall("kernel32.dll", "hwnd", "OpenMutex", "int", 0x1F0001, "int", False, "str", "CodeGrabber.exe") Then Exit ; kill dupe process
DllCall("kernel32.dll", "hwnd", "CreateMutex", "int", 0, "int", False, "str", "CodeGrabber.exe") ; add to processlist

Opt("TrayIconHide", 1)   
Global $AppID = "AutoIt CodeGrabber"
Global $AppVer = "0.70"
Global $InsertComment, $StripComment, $Codebox_Threshhold, $GUI_Transparency, $Tag_Preference
Global $FMListView, $FMFileList, $LPListView, $LPFileList 
GLobal $IE_Name, $o_IE, $o_IE_Element, $o_IE_CodetopPN, $o_IE_Codetop, $CodetopPN_InnerHTML, $Codetop_Count
Global $WindowHandle, $WindowName, $Classname, $TopicTitle, $ForumNumber, $TopicAuthor, $PostNumber, $PostAuthor
GLobal $Pathname, $Filename, $FilenameFull, $Fileaction, $FileList, $Text, $Comment, $GUI, $GUI_FM, $ScITE
Global $Checkbox_Insert, $Checkbox_Strip, $Label_Strip, $Label_Code1, $Label_Code2, $Radio_AutoIt, $Radio_Code, $Refresh
Global $Button_Threshhold_Left, $Button_Threshhold_Right, $Label_Threshhold, $Label_Trans, $Checkbox_ScITE, $FM_Flag
Global $ListViewTopic[1], $ListViewTopicNum[1], $ShowTopicWeb, $ShowTopicFolder
Global $iItem, $iColor, $iColorBk
Global $XY = WinGetPos("Program Manager")
Global $taskbar_height = ControlGetPos("[CLASS:Shell_TrayWnd]", "", "")
$taskbar_height = $taskbar_height[3]
Global $Work_Folder = @ScriptDir ; Folder where scripts are written to, and pasted from
Global $IniFile = @ScriptDir & "\Codegrabber.ini"
Global $Forum_URL = "http://www.autoitscript.com/forum/index.php?showtopic="
Global $treeview
Global $maxlist = 8 ; max size of listview before scrolling

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

Initialization() ; Process IniFile

; Main -------------------------------------------------------------------------
$IE_Name = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main", "Window Title") ; Get custom browser name 
If Not $IE_Name Then
	$o_IE = ObjCreate("InterNetExplorer.Application")
	$IE_Name = String($o_IE.name) ; Get default browser name
	$o_IE.quit
EndIf
$IE_NameLen = StringLen($IE_Name)

; Get last-active IE window, exit if it was not an Autoit Forum read or reply window
$Mode = 0
$Window = WinList()
For $x = 1 to $Window[0][0]
	If $Window[$x][0] AND BitAnd(WinGetState($Window[$x][1]), 2) _ ; Window is visible and IE
	And StringRight($Window[$x][0], $IE_NameLen) = $IE_Name  Then
		$WindowHandle = WinGetHandle($Window[$x][1])
		$WindowName = StringTrimRight($Window[$x][0], $IE_NameLen + 3)
		If StringRight($WindowName, 16) = " - AutoIT Forums" Then $Mode = 1 ; Last IE window was forum read or fast-reply
		If StringLeft($WindowName, 29) = "AutoIT Forums -> Replying in " Then $Mode = 2 ; Last window was forum reply or add-reply
		If StringLeft($WindowName, 30) = "AutoIT Forums -> Editing Post " Then $Mode = 3 ; Last window was forum post edit
		Exitloop
	EndIf
Next
If Not $Mode Then ; No IE window found, or last-active window was not Autoit Forum read or reply 
;	Message_GUI("No active AutoIt forum window", 1)
	$FM_Flag = 1
	While $FM_Flag
		FileMaintenance()
	WEnd
	Exit
EndIf

; Get document object to target window/tab
$o_Shell = ObjCreate("Shell.Application")
For $o_ShellWindow In $o_Shell.Windows()
	If Not (StringRight($o_ShellWindow.fullname, 12) = "iexplore.exe") Then ContinueLoop
;	MsgBox(1,"",$WindowName & @CRLF & $o_ShellWindow.name)
	If StringLeft($o_ShellWindow.document.title, 95) = $WindowName _ ; WinList() truncates at 95 chars
	And Hex($o_ShellWindow.hWnd) = StringTrimLeft($WindowHandle, 2) Then ; Handle duplicate window names
		$o_IE = $o_ShellWindow.document		
		For $o_IE_Element In $o_IE.GetElementsByTagName("script") ; most consistant means of obtaining topic number
			$x = String($o_IE_Element.InnerHTML)
			$y = StringInStr($x, "ipb_input_f")
			If $y Then 
				$x = StringTrimLeft($x, $y + 11)
				$y = StringInStr($x, ";")
				$y = StringLeft($x, $y - 1)
				$y = StringSplit($y, '"')
				$ForumNumber = $y[2]
				$y = StringInStr($x, "ipb_input_t")
				$x = StringTrimLeft($x, $y + 11)
				$y = StringInStr($x, ";")
				$y = StringLeft($x, $y - 1)
				$y = StringSplit($y, '"')
				$TopicNumber = $y[2]
				ExitLoop
			EndIf						
		Next
;		MsgBox(1,"","Forum = " & $ForumNumber & "  Topic = " & $TopicNumber)
		If $Mode = 1 And IsObj($o_IE.getElementById('userlinks')) Then ; logged in?
			For $x = 1 to 20
				If IsObj($o_IE.getElementById('qr_open')) Then ; check if javascript loaded
					If String($o_IE.getElementById('qr_open').style.display) = "0" Then $Mode = 4 ; override mode for Fast Reply
					ExitLoop
				EndIf
				Sleep(250)
			Next
		EndIf
		If $Mode = 1 Then ; Cut from web
			$ScreenHeight = $o_ShellWindow.height - $o_IE.parentWindow.screenTop
			$DocPosition = $o_IE.documentelement.scrolltop ; Get document's scroll position
			Find_Codetag()
			If $Text Then ; On-screen code block found
				IE_to_ScITE() 
				If WinExists($WindowName,"") Then
					$o_IE_CodetopPN.InnerHTML = $CodetopPN_InnerHTML ; Restore webpage
				EndIf
			Else
				Message_GUI("No code block found", 1)
				ExitLoop
			EndIf
			ExitLoop
		Else ; Paste to web
			ScITE_to_IE()
			Exitloop
		EndIf		
	EndIf
Next
Exit

; Subroutines ------------------------------------------------------------------
Func Find_Codetag() ; Get first on-screen codemain/autoit tag
	Local $NextDivIsTitle
	For $o_IE_Element In $o_IE.GetElementsByTagName("*") ; Get collection of tags
;		If StringInStr($o_IE_Element.InnerHTML, "Attached File") Then
;			process attachments?
;		EndIf
		Switch String($o_IE_Element.Tagname)
			Case "div"
				If $NextDivIsTitle Then
					$TopicTitle = StringStripWS($o_IE_Element.InnerText, 7)
					$NextDivIsTitle = 0
				EndIf
				Switch String($o_IE_Element.Classname)
					Case "autoit", "codemain"
						If StringInStr($o_IE_Element.InnerHTML, "<DIV class=codetop") Then ContinueLoop ; bypass outer nesting
						$Codetop_Count += 1
						; Calculate element's vertical position in document
						$oTemp = $o_IE_Element
						$ElementPosition = 0
						While IsObj($oTemp)
							$ElementPosition += $oTemp.offsetTop
							$oTemp = $oTemp.offsetParent
						WEnd
						; Compare element's vertical position to document's scroll position to see if element is on-screen
						If $DocPosition <= $ElementPosition And ($ElementPosition - $DocPosition) <= $ScreenHeight Then
							$Text = $o_IE_Element.InnerText
							$Classname = $o_IE_Element.Classname
							ExitLoop
						EndIf
					Case "codetop"
						$o_IE_CodetopPN = $o_IE_Element.Parentnode
						$o_IE_Codetop = $o_IE_Element
					Case "maintitle"
						$NextDivIsTitle = 1
					Case "postcolor"
						$Codetop_Count = 0
					Case "signature"
						$Codetop_Count = 0
				EndSwitch
			Case "span"
				Switch String($o_IE_Element.Classname)
;					Case "edit"
					Case "normalname"
						$tempauthor = String($o_IE_Element.InnerText)
;					Case "pagecurrent"
					Case "postdetails"
						If StringLeft($o_IE_Element.InnerText, 6) = "Post #" Then
							If StringLeft($o_IE_Element.InnerText, 8) = "Post #1 " Then ; only found on page 1 :(
								$TopicAuthor = $tempauthor
							EndIf
							$PostNumber = StringRight("00" & StringStripWS(StringTrimLeft($o_IE_Element.InnerText, 6), 8), 3)
							$PostAuthor = $tempauthor
						Endif
				EndSwitch
;			Case "textarea"
		EndSwitch
	Next
EndFunc

Func IE_to_ScITE() ; Copy from webpage (forum read) to .au3 file
	Eye_Candy()
	Format_Pathname("R", 16)
	$Filename = "T" & $TopicNumber & "_P" & $PostNumber & ".au3"
	$FilenameFull = $Pathname & "\" & $Filename
	If FileExists($FilenameFull) Then
		$Fileaction = Cut_Options_GUI(StringUpper($Filename) & "  already exists.", "OVERWRITE", "OPEN", "CANCEL")
	Else
		$Fileaction = Cut_Options_GUI("Capturing " & StringUpper($Filename), "COPY", "", "CANCEL")
	EndIf
	If $Fileaction = 2 Then Return
	If $Fileaction = 0 Then
		If Winactivate($WindowName,"") Then 
			MessageFade_GUI("Capturing " & $Filename, .5)
		Else
			MessageFade_GUI("Capture window not found", 1)
			Return 
		EndIf
		DirCreate($Pathname)
		FileDelete($FilenameFull)
		If $InsertComment Then
			Insert_Comment()
		EndIf
		FileWrite($FilenameFull,$Text)
	EndIf
	If $ScITE Or $Fileaction = 1 Then 
		ShellExecute($FilenameFull, "", "", "Edit")
		ProcessWait("ScITE.exe")
	EndIf
EndFunc

Func ScITE_to_IE() ; Copy from .au3 file to webpage (forum reply)
	Switch $Mode
		Case 2 ; "Reply" or "Add Reply"
			Format_Pathname("L", 29)
		Case 3 ; "Edit Post"
			Format_Pathname("L", 30)
		Case 4 ; "Fast Reply"
			Format_Pathname("R", 16)
	EndSwitch
	$Filename = "T" & $TopicNumber & "_P*" & ".au3"
	$FileList = FileListToArray($Pathname, $Filename)
	If Not IsArray($FileList) Then
		MessageFade_GUI("File " & $Filename & " not found.", 1)
		Return
	EndIf
	Paste_Options_GUI()
	If Not $Filename Then Return
	$FilenameFull = $Pathname & "\" & $Filename
	If $Fileaction = 1 Then 
		ShellExecute($FilenameFull, "", "", "Edit")
		ProcessWait("ScITE.exe")
		Return
	EndIf
	$Text = FileRead($FilenameFull)
	If $StripComment Then Strip_Comment()
	If Not Winactivate($WindowName,"") Then ; Window closed/lost
		MessageFade_GUI("Reply window not found.", 1)
		Return 
	EndIf
	While $o_ShellWindow.readyState < 3 ; Ensure page is (sufficiently) loaded
		sleep(10)
	Wend
; 	If 'autoit' snippet quoted in post, force $Tag_Preference to 'code' to avoid the autoit-tag post corruption bug
	If $Mode = 2 Then
		If (StringInStr($o_ShellWindow.document.getElementById("ed-0_textarea").innertext, "[autoit]")) Then $Tag_Preference = "code"
	EndIf
	If $Tag_Preference = "autoit" Then
		ClipPut("[autoit]" & @CRLF & $Text & @CRLF & "[/autoit]" & @CRLF)
	Else
		$Lines = StringSplit($Text, @LF)
		$Lines = $Lines[0]
		If $Codebox_Threshhold And $Lines >= $Codebox_Threshhold  Then
			ClipPut("[codebox][code]" & @CRLF & $Text & @CRLF & "[/code][/codebox]" & @CRLF)
		Else
			ClipPut("[code]" & @CRLF & $Text & @CRLF & "[/code]" & @CRLF)
		EndIf
	EndIf	
	MessageFade_GUI("Pasting " & $Filename, .5)
	$ActiveElement = String($o_ShellWindow.document.activeElement.ID)
	Switch $Mode
		Case 2, 3 ; standard reply, edit
			If $ActiveElement <> "ed-0_textarea" Then 
				$o_ShellWindow.document.getElementById("ed-0_textarea").focus
				Send("^{END}")
			EndIf
		Case 4 ; fast reply
			If $ActiveElement <> "fast-reply_textarea" Then 
				$o_ShellWindow.document.getElementById("fast-reply_textarea").focus
				Send("^{END}")
			EndIf
	EndSwitch
	Send("^v")
EndFunc

Func Insert_Comment()
	Strip_Comment()
	$Comment  = "#cs  " & $AppID & " " & $AppVer & @CRLF
	$Comment &= "  " & $TopicTitle &  @CRLF
	$Comment &= "  " & "Forum #" & $ForumNumber & ", Topic #" & $TopicNumber
	If $TopicAuthor Then $Comment &= " by " &  $TopicAuthor
	$Comment &= ", Post #" & $PostNumber & " by " & $PostAuthor & @CRLF
	$Comment &= "#ce  " & @CRLF & @CRLF
	$Text = $Comment & $Text
EndFunc

Func Strip_Comment()
	Local $comment_start = StringInStr($Text, "#cs  " & $AppID, 2, 1, 1)
	Local $comment_end = StringInStr($Text, "#ce", 2, 1, $comment_start)
	If $comment_start And $comment_end Then
		$Text = StringStripWS(StringMid($Text, $comment_end + 8), 1)
	EndIf	
EndFunc

Func Eye_Candy()
	If IsObj($o_IE_CodetopPN) Then
		$CG_header = "<a style='padding-left: 22%; COLOR: #990033;'><== &nbsp " & $AppID & " &nbsp v" & $AppVer & " &nbsp ==></a>"
		$CodetopPN_InnerHTML = String($o_IE_CodetopPN.InnerHTML)
		Local $Codetop_InnerText = $o_IE_Codetop.InnerText
		Local $x = StringInStr($CodetopPN_InnerHTML,"class=codetop", 2, $Codetop_Count)
		$tmp = StringLeft($CodetopPN_InnerHTML, $x + 12) & " style='BACKGROUND:#FFDDDD;'" & "><a>" & $Codetop_InnerText _
			& "</a>" & $CG_header & StringTrimLeft($CodetopPN_InnerHTML, $x + 13 + StringLen($Codetop_InnerText)) 

		$x = StringInStr($tmp,"class=" & $Classname, 2, 1, $x)
		$y = StringInStr($tmp,"<div ", 2, -1, $x)
		$z = StringInStr($tmp,">", 2, 1, $x)
		$zz = StringInStr($tmp,"style=", 2, 1, $y)
		If $zz And $zz < $z Then
			$tmp = StringLeft($tmp, $zz + 5) & '"BACKGROUND:#FFCCCC;' & StringTrimLeft($tmp, $zz + 6)
		Else
			Local $offset = 5 + StringLen($Classname)
			$tmp = StringLeft($tmp, $x + $offset) & ' style="BACKGROUND:#FFCCCC;"' & StringTrimLeft($tmp, $x + $offset)
		EndIf
;		MsgBox(1,"",$tmp)
		$o_IE_CodetopPN.InnerHtml = $tmp
	EndIf
EndFunc

Func Cut_Options_GUI($Label0, $Button0, $Button1, $Button2)
	Local $GUI = GUICreate("", 330, 46, 60, $XY[3] - (66 + $taskbar_height), 0x80800000, 0x00000008, $WindowHandle)
	Local $ReturnCode
	GUISetFont(8.5,600)
	GUISetBkColor(0xFFCCCC)
	GUICtrlCreateLabel($Label0, 5, 4, 300, 17, 0x01) ; $SS_CENTER
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	Local $Button_FileMaint = GUICtrlCreateButton("", 304, 3, 22, 20, 0x0040) ; style $BS_ICON
	GUICtrlSetImage(-1, "shell32.dll", 281, 0)
	GUICtrlSetTip(-1, "Folder Maintenance/Settings")
	GUISetFont(7.5, 400, 0, "Lucida Console")
	Local $Button_0 = GUICtrlCreateButton($Button0, 10, 24, 80, 18)
	Local $Button_1 = GUICtrlCreateButton($Button1, 100, 24, 80, 18)
	If Not $Button1 Then GUICtrlSetState(-1, 160) ; $GUI_DISABLE/HIDE
	Local $Button_2 = GUICtrlCreateButton($Button2, 190, 24, 80, 18)
	Local $Checkbox_1 = GUICtrlCreateCheckbox("ScITE", 280, 26, 45, 18, 0x0020) ; $BS_RIGHTBUTTON
	If $ScITE Then GUICtrlSetState(-1, 1)
	GUICtrlSetTip(-1, "Auto-launch ScITE with capture")

	WinSetTrans($GUI, "", $GUI_Transparency)
	GUISetState(@SW_SHOW)
	Winactivate($WindowName,"")
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Button_0
				$ReturnCode = 0
				ExitLoop				
			Case $Button_1
				$ReturnCode = 1
				ExitLoop				
			Case $Button_2
				$ReturnCode = 2
				ExitLoop
			Case $Button_FileMaint
				$o_IE_CodetopPN.InnerHTML = $CodetopPN_InnerHTML ; Restore webpage
				$ReturnCode = 2
				$FM_Flag = 1
				ExitLoop
		EndSwitch
	WEnd
	$ScITE = (GUICtrlRead($Checkbox_1)  = 1)
	GUIDelete($GUI)
	While $FM_Flag
		FileMaintenance()
	Wend
	Return $ReturnCode
EndFunc

Func Paste_Options_GUI()
	Local $listsize = $FileList[0]
;	If $listsize > 9 Then $listsize = 9
	Local $GUI = GUICreate("", 330, 66 + $listsize * 17, 70, $XY[3] - (86 + $listsize * 17 + $taskbar_height), 0x80800000, 0x00000008, $WindowHandle)
	Local $radio[$FileList[0] + 1]
	GUISetFont(8.5,600)
	GUISetBkColor(0xFFCCCC)
	GUICtrlCreateLabel("      Select source file for paste:", 5, 4, 300, 17, 0x01) ; $SS_CENTER
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	GUISetFont(7.5, 400, 0, "Lucida Console")
	GUICtrlCreateLabel("       FILE            CREATED          MODIFIED", 10, 28, 320, 15)
	Local $Button_FileMaint = GUICtrlCreateButton("", 305, 4, 21, 18, 0x0040) ; style $BS_ICON
	GUICtrlSetImage(-1, "shell32.dll", 281, 0)
	GUICtrlSetTip(-1, "Folder Maintenance/Settings")	
    GUICtrlCreateGroup("", 5, 19, 320, 22 + $listsize * 17)
	; change to listview ?
	For $x = 1 to $FileList[0]
		$radio[$x] = GUICtrlCreateRadio($FileList[$x], 10, 23 + $x * 17, 310, 15)
		If ($x = 1 And $FileList[0] = 1) Then GUICtrlSetState(-1, 1) ; $GUI_CHECKED
	Next
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Local $Button_Paste = GUICtrlCreateButton("PASTE", 15, 44 + $listsize * 17, 80, 18)
	Local $Button_Open = GUICtrlCreateButton("OPEN", 125, 44 + $listsize * 17, 80, 18)
	Local $Button_Cancel = GUICtrlCreateButton("CANCEL", 235, 44 + $listsize * 17, 80, 18)
	WinSetTrans($GUI, "", $GUI_Transparency)
	GUISetState(@SW_SHOW)
	Winactivate($WindowName,"")
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Button_Paste
				$Filename = ""
				For $x = 1 to $FileList[0]
					If GUICtrlRead($radio[$x]) = 1 Then
						$Filename = StringLeft($FileList[$x], StringInStr($FileList[$x], Chr(160), 2, 1) - 1)
						ExitLoop(2)
					EndIf					
				Next
			Case $Button_Open
				$Filename = ""
				For $x = 1 to $FileList[0]
					If GUICtrlRead($radio[$x]) = 1 Then
						$Filename = StringLeft($FileList[$x], StringInStr($FileList[$x], Chr(160), 2, 1) - 1)
						$Fileaction = 1
						ExitLoop(2)
					EndIf			
				Next
			Case $Button_FileMaint
				$FM_Flag = 1
				$Filename = ""
				ExitLoop
			Case $Button_Cancel
				$Filename = ""
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($GUI)
	While $FM_Flag 
		FileMaintenance()
	WEnd
EndFunc

Func Message_GUI($mtext, $timeout = 0)
	Local $GUI = GUICreate("", 320, 43, 60, $XY[3] - (63 + $taskbar_height), 0x80800000, 0x00000008)
	GUISetFont(8.5,600)
	GUISetBkColor(0xFFCCCC)
	GUICtrlCreateLabel($mtext, 5, 3, 288, 15, 0x01)
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	Local $Button_FileMaint = GUICtrlCreateButton("", 296, 2, 18, 18, 0x0040) ; style $BS_ICON
	GUICtrlSetImage(-1, "shell32.dll", 281, 0)
	GUICtrlSetTip(-1, "Folder Maintenance/Settings")	
	GUISetFont(7.5, 400, 0, "Lucida Console")
	Local $Button_Cancel = GUICtrlCreateButton("CANCEL", 235, 22, 80, 18)
	WinSetTrans($GUI, "", $GUI_Transparency)
	GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Button_FileMaint
				$FM_Flag = 1
				ExitLoop
			Case $Button_Cancel
				$Filename = ""
				ExitLoop
		EndSwitch
	WEnd
	GUIDelete($GUI)
	While $FM_Flag
		FileMaintenance()
	WEnd
EndFunc

Func MessageFade_GUI($mtext, $timeout = 0)
	Local $GUI = GUICreate("", 320, 23, 60, $XY[3] - (43 + $taskbar_height), 0x80800000, 0x00000008, $WindowHandle)
	GUISetFont(8.5,600)
	GUISetBkColor(0xFFCCCC)
	GUICtrlCreateLabel($mtext, 5, 4, 310, 15, 0x01)
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	GUISetFont(7.5, 400, 0, "Lucida Console")
	WinSetTrans($GUI, "", $GUI_Transparency)
	GUISetState(@SW_SHOW)
	Sleep($timeout * 1000)
	For $x = $GUI_Transparency to 0 Step -5
		WinSetTrans($GUI, "", $x)
		Sleep(10)
	Next
	GUIDelete($GUI)
EndFunc

Func FileListToArray($sPath, $sFilter = "*", $DirOnly = 0) ; _FileListToArray plus file created/modified date and time
	Local $hSearch, $sFile, $asFileList[8]
	If Not FileExists($sPath) Then Return SetError(1, 1, "")
	$hSearch = FileFindFirstFile($sPath & "\" & $sFilter)
	If $hSearch = -1 Then Return SetError(4, 4, "")
	While 1
		$sFile = FileFindNextFile($hSearch)
		If @error Then
			SetError(0)
			ExitLoop
		EndIf
		If (StringInStr(FileGetAttrib($sPath & "\" & $sFile), "D") <> $DirOnly) Then ContinueLoop
		$asFileList[0] += 1
		If UBound($asFileList) <= $asFileList[0] Then ReDim $asFileList[UBound($asFileList) * 2]
		$t1 =  FileGetTime($sPath & "\" & $sfile, 1)
		$t1 = $t1[0] & "-" & $t1[1] & "-" & $t1[2] & " " & $t1[3] & ":" & $t1[4]
		$t2 =  FileGetTime($sPath & "\" & $sfile, 0)
		$t2 = $t2[0] & "-" & $t2[1] & "-" & $t2[2] & " " & $t2[3] & ":" & $t2[4]
		$sfile = StringTrimLeft($sfile, StringInStr($sfile, "\", 2, -1))
		$asFileList[$asFileList[0]] = $sFile & Chr(160) & Stringleft("    ", 15 - StringLen($sfile)) & $t1 & Chr(160) & $t2
	WEnd
	FileClose($hSearch)
	ReDim $asFileList[$asFileList[0] + 1] ; Trim unused slots
	Return $asFileList
EndFunc

;-------------------------------------------------------------------------------
Func FileMaintenance()
	Local $x, $y, $z
	$Pathname = $Work_Folder
	$FMFileList = FileListToArray($Work_Folder, "Topic*", 1)
	If @error Then Local $FMFileList[1] = [0]
	Local $listsize = $FMFileList[0] 
	If $listsize > $maxlist Then $listsize = $maxlist 
	$GUI_FM = GuiCreate("", 640 + ($FMFileList[0] > $maxlist) * 20, 54 + $listsize * 17, 60, $XY[3] - (74 + $listsize * 17 + $taskbar_height), 0x80800000, 0x00000008)
	GUISetBkColor(0xFFCCCC)
	GUISetFont(8.5, 400, 0, "Lucida Console")
	$FMListView = GuiCtrlCreateListView("", 5, 5, 630 + ($FMFileList[0] > $maxlist) * 18, 22 + $listsize * 17, -1, 0x00000004) ; $LVS_EX_CHECKBOXES
	$FMListView = GUICtrlGetHandle($FMListView) ; needed for WM_NOTIFY
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	GUISetFont(7.5, 400, 0, "Lucida Console")
	$Button_FMDelete = GUICtrlCreateButton("DELETE SELECTED", 10, 31 + $listsize * 17, 100, 18)
	$Button_FMSet = GUICtrlCreateButton("SELECT ALL", 140, 31 + $listsize * 17, 80, 18)
	$Button_FMClr = GUICtrlCreateButton("CLEAR ALL", 230, 31 + $listsize * 17, 80, 18)
	$Button_FMCancel = GUICtrlCreateButton("EXIT", 340, 31 + $listsize * 17, 80, 18)
	$Button_Settings = GUICtrlCreateButton("SETTINGS", 550, 31 + $listsize * 17, 80, 18)
	WinSetTrans($GUI_FM, "", $GUI_Transparency)
	GUISetState(@SW_SHOW, $GUI_FM)
	_GUICtrlListView_AddColumn($FMListView, " ", 20)
	_GUICtrlListView_AddColumn($FMListView, "TOPIC", 50)
	_GUICtrlListView_AddColumn($FMListView, "THREAD NAME", 262)
	_GUICtrlListView_AddColumn($FMListView, "CREATED", 124)
	_GUICtrlListView_AddColumn($FMListView, "MODIFIED", 124)
	_GUICtrlListView_AddColumn($FMListView, "", 50)
	_GUICtrlListView_SetColumn($FMListView, 5, "FILES", 50, 1)
	ReDim $ListViewTopic[$FMFileList[0] + 1]
	ReDim $ListViewTopicNum[$FMFileList[0] + 1]
	For $x = 1 to $FMFileList[0]
		 _GUICtrlListView_AddItem($FMListView, " ", 4)
		$y = StringSplit($FMFileList[$x],Chr(160))
		$ListViewTopic[$x] = $y[1]
		$z = StringSplit(StringLeft($y[1], StringInStr($ListViewTopic[$x], " - ") - 1), " ")
		$ListViewTopicNum[$x] = $z[2]
		_GUICtrlListView_AddSubItem($FMListView, $x - 1, $z[2], 1)
		$z = Stringupper(StringTrimLeft($y[1], StringInStr($y[1], " - ") + 2))
		_GUICtrlListView_AddSubItem($FMListView, $x - 1, $z, 2)
		_GUICtrlListView_AddSubItem($FMListView, $x - 1, $y[2], 3)
		_GUICtrlListView_AddSubItem($FMListView, $x - 1, $y[3], 4)
		$z = DirGetSize($y[1],1)
		_GUICtrlListView_AddSubItem($FMListView, $x - 1, $z[1], 5)
	Next
	
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Button_FMDelete
				For $x = 1 to $FMFileList[0]
					If _GUICtrlListView_GetItemChecked($FMListView, $x - 1) Then
						$y = StringSplit($FMFileList[$x],Chr(160))
						DirRemove($y[1], 1)
					EndIf
				Next
				GUIDelete($GUI_FM)
				ExitLoop
			Case $Button_FMSet
				For $x = 1 to $FMFileList[0]
					_GUICtrlListView_SetItemChecked($FMListView, $x - 1, True)
				Next
			Case $Button_FMClr
				For $x = 1 to $FMFileList[0]
					_GUICtrlListView_SetItemChecked($FMListView, $x - 1, False)
				Next
			Case $Button_FMCancel
				GUIDelete($GUI_FM)
				$FM_Flag = 0
				ExitLoop
			Case $Button_Settings
				Settings_GUI()
		EndSwitch
		If $ShowTopicWeb Then
			ShellExecute($Forum_URL & $ListViewTopicNum[$ShowTopicWeb])
			$ShowTopicWeb = ""
		EndIf
		If $ShowTopicFolder Then
			ListPosts()
			If $FM_Flag = 2 Then
				$FM_Flag = 1
			Else
				GUIDelete($GUI_FM)
				$FM_Flag = 1
				Exitloop
			EndIf
		EndIf
	WEnd
EndFunc

;-------------------------------------------------------------------------------
Func Format_Pathname($LorR, $x)
	If $LorR = "L" Then
		$tmp = StringTrimLeft($WindowName, $x)
	Else
		$tmp = StringTrimRight($WindowName, $x)
	EndIf
	$tmp = StringStripWS($tmp, 3)
	$tmp = StringRegExpReplace($tmp, '"', "'")
	$Pathname = $Work_Folder & "\Topic " & $TopicNumber & " - " & StringRegExpReplace($tmp, "[:\\/?*<>|]", "_")
	While 1
		If StringRight($Pathname, 1) = "." Then
			$Pathname = StringTrimRight($Pathname, 1)
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

;-------------------------------------------------------------------------------
Func ListPosts() ; under construction
	Local $row_height = 17
	$FilenameFull = ""
	GUISetState(@SW_DISABLE, $GUI_FM)
;	$LPFileList = FileListToArray($Work_Folder & "\" & $ShowTopicFolder)
;	MsgBox(1,"",$Work_Folder & "\" & $ShowTopicFolder)
	$LPFileList = FileListToArray($Work_Folder & "\" & $ShowTopicFolder,"*.au3")
	Local $listsize = $LPFileList[0] 
	If $listsize > $maxlist Then $listsize = $maxlist 
	$GUI_LP = GuiCreate("", 285 + ($LPFileList[0] > $maxlist) * 20, 54 + $listsize * $row_height, 696, $XY[3] - (73 + $listsize * $row_height + $taskbar_height), 0x80800000, 0x00000008, $GUI_FM)
	GUISetFont(8.5, 400, 0, "Lucida Console")
	GUISetBkColor(0xFFCCCC)
	$LPListView = GuiCtrlCreateListView("", 5, 5, 275 + ($LPFileList[0] > $maxlist) * 18, 22 + $listsize * $row_height, -1, 0x00000004) ; $LVS_EX_CHECKBOXES
	$LPListView = GUICtrlGetHandle($LPListView) ; needed for WM_NOTIFY
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	GUISetFont(7.5, 400, 0, "Lucida Console")
	$Button_LPDelete = GUICtrlCreateButton("DELETE SELECTED", 10, 31 + $listsize * $row_height, 100, 18)
	$Button_LPCancel = GUICtrlCreateButton("EXIT", 195, 31 + $listsize * $row_height, 80, 18)
	WinSetTrans($GUI_LP, "", $GUI_Transparency)
	GUISetState(@SW_SHOW, $GUI_LP)

	_GUICtrlListView_AddColumn($LPListView, "FILENAME", 145)
	_GUICtrlListView_AddColumn($LPListView, "MODIFIED", 130)
	For $x = 1 to $LPFileList[0]
		$y = StringSplit($LPFileList[$x],Chr(160), 2)
		_GUICtrlListView_AddItem($LPListView, $y[0])
		_GUICtrlListView_AddSubItem($LPListView, $x - 1, StringStripWS($y[1],7), 1)
		$LPFileList[$x] = $y[0]
	Next

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Button_LPDelete
				For $x = 1 to $LPFileList[0]
					If _GUICtrlListView_GetItemChecked($LPListView, $x - 1) Then
						If $LPFileList[0] = 1 Then
							DirRemove($Work_Folder & "\" & $ShowTopicFolder, 1)
							$ShowTopicFolder = ""
						Else
							$y = $Work_Folder & "\" & $ShowTopicFolder & "\" & $LPFileList[$x]
							FileRecycle($y)
							$LPFileList[0] -= 1
						EndIf
					EndIf
				Next
				GUIDelete($GUI_LP)
				GUISetState(@SW_ENABLE, $GUI_FM)
				Exitloop
			Case $Button_LPCancel
				GUIDelete($GUI_LP)
				GUISetState(@SW_ENABLE, $GUI_FM)
				$ShowTopicFolder = ""
				$FM_Flag = 2
				ExitLoop
		EndSwitch
		If $FilenameFull Then 
			ShellExecute($FilenameFull, "", "", "Edit")
			ProcessWait("ScITE.exe")
			$FilenameFull = ""
		EndIf
	WEnd
EndFunc

; Initialization routines ------------------------------------------------------
Func Initialization()
	If FileExists($IniFile) Then
		Load_IniFile()
	Else	
		$InsertComment = 1 ; Insert thread title and topic number as comment on top of created .au3 file
		$StripComment = 1 ; Strip added thread title comment from top of .au3 file prior to posting reply to forum
		$Tag_Preference = "code" ; Use "code" or "autoit" when posting example scripts
		$Codebox_Threshhold = 24 ; # of script lines until "code" tags are wrapped with "codebox" tags (0 to disable)
		$GUI_Transparency = 240 ; Transparency level of popup GUI's
		$ScITE = 1 ; Default checkbox to launch ScITE when capturing
;		Create QuickLaunch shortcut
		$QuickLaunchPath = @AppDataDir & "\Microsoft\Internet Explorer\Quick Launch\Autoit CodeGrabber.lnk"
		$ShortcutTarget = @ScriptDir & "\Codegrabber.exe"
		FileCreateshortcut($ShortcutTarget, $QuickLaunchPath, @ScriptDir)
		Settings_GUI()
	EndIf		
EndFunc

Func Load_IniFile()
	$file = FileOpen($IniFile, 0)
	$x = Fileread($file)
	FileClose($file)
	$x = StringSplit($x, "|")
	$InsertComment = $x[1]
	$StripComment = $x[2]
	$Tag_Preference = $x[3]
	$Codebox_Threshhold = $x[4]
	$GUI_Transparency = $x[5]
	$ScITE = $x[6]
EndFunc

Func Save_IniFile()
	$file = FileOpen($IniFile, 2)
	FileWrite($file, $InsertComment & "|" & $StripComment & "|" & $Tag_Preference & "|" & $Codebox_Threshhold & "|" _
			& $GUI_Transparency & "|" & $ScITE)
	FileClose($file)
EndFunc

Func Settings_GUI()
	$GUI_Settings = GuiCreate($AppID & " " & $AppVer, 270, 270, 450, $XY[3] - (290 + $taskbar_height), 0x80800000, 0x00000008, $GUI_FM)
	GUISetBkColor(0xFFCCCC)
	GUISetFont(9, 600, 0, "Lucida Console")
	GUICtrlCreateLabel("", 0, 0, 270, 20, 0x01) ; $SS_CENTER
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	GUICtrlCreateLabel(" PROGRAM OPTIONS", 0, 6, 270, 16, 0x01) ; $SS_CENTER
	GUICtrlSetBkColor(-1, 0xFFDDDD)
	
 	GUISetFont(8, 600, 0, "Lucida Console")
	GUICtrlCreateLabel ("", 10, 35, 250, 50, 0x08) ; $SS_GRAYFRAME
	GUICtrlSetState(-1, 128)
 	GUICtrlCreateLabel(" ADDED COMMENTS ", 20, 30, 112, 18)
 	GUISetFont(8, 400, 0, "Lucida Console")
 	GUICtrlCreateLabel("INSERT COMMENTS DURING CUT", 20, 45, 170, 18)
	GUICtrlSetTip(-1, "Insert Thread and Author information at top of captured code")
 	$Checkbox_Insert = GUICtrlCreateCheckbox("", 235, 41, 18, 18)
	
 	$Label_Strip = GUICtrlCreateLabel("STRIP COMMENTS BEFORE PASTE", 20, 65, 170, 18)
	GUICtrlSetTip(-1, "Strip added Thread and Author information prior to paste")
	$Checkbox_Strip = GUICtrlCreateCheckbox("", 235, 61, 18, 18)

 	GUISetFont(8, 600, 0, "Lucida Console")
	GUICtrlCreateLabel ("", 10, 100, 250, 70, 0x08) ; $SS_GRAYFRAME
	GUICtrlSetState(-1, 128)
 	GUICtrlCreateLabel(" CODE BLOCK TAGS ", 20, 95, 118, 18)
 	GUISetFont(8, 400, 0, "Lucida Console")
	GUICtrlCreateLabel("WRAP IN [AUTOIT] TAGS", 20, 110, 140, 18)
	$Radio_AutoIt = GUICtrlCreateRadio("", 235, 106, 18, 18)	
	GUICtrlCreateLabel("WRAP IN [CODE] TAGS", 20, 130, 140, 18)
	$Radio_Code = GUICtrlCreateRadio("", 235, 126, 18, 18)
	$Label_Code1 = GUICtrlCreateLabel("EMBED IN [CODEBOX] AFTER", 20, 150, 148, 18)
	GUICtrlSetTip(-1, "Allows scrolling in post, yet retains source formatting (indentation)")
 	GUISetFont(9, 600, 0, "Lucida Console")
	$Button_Threshhold_Left = GUICtrlCreateButton("<", 167, 146, 16, 17, -1, 0x00000008) ; $WS_EX_TOPMOST
	$Button_Threshhold_Right = GUICtrlCreateButton(">", 204, 146, 16, 17)
 	GUISetFont(8, 400, 0, "Lucida Console")
	$Label_Threshhold = GUICtrlCreateLabel($Codebox_Threshhold, 183, 150, 22, 18, 0x01) ; $SS_CENTER 
	$Label_Code2 = GUICtrlCreateLabel("LINES", 224, 150, 30, 18)
	
 	GUISetFont(8, 600, 0, "Lucida Console")
	GUICtrlCreateLabel ("", 10, 185, 250, 50, 0x08) ; $SS_GRAYFRAME
	GUICtrlSetState(-1, 128)
 	GUICtrlCreateLabel(" MISCELLANEOUS ", 20, 180, 104, 18)
 	GUISetFont(8, 400, 0, "Lucida Console")
 	GUICtrlCreateLabel("LAUNCH ScITE AFTER CUT", 20, 195, 170, 18)
 	$Checkbox_ScITE = GUICtrlCreateCheckbox("", 235, 191, 18, 18)
	
	GUICtrlCreateLabel("DEFAULT GUI TRANSPARENCY", 20, 215, 148, 18)
 	GUISetFont(9, 600, 0, "Lucida Console")
	$Button_Trans_Left = GUICtrlCreateButton("<", 167, 211, 16, 17, -1, 0x00000008) ; $WS_EX_TOPMOST
	$Button_Trans_Right = GUICtrlCreateButton(">", 204, 211, 16, 17)
 	GUISetFont(8, 400, 0, "Lucida Console")
	$Label_Trans = GUICtrlCreateLabel($GUI_Transparency, 183, 215, 22, 18, 0x01) ; $SS_CENTER 
	$Button_Save = GUICtrlCreateButton("SAVE", 95, 245, 80, 17)
	GUISetState(@SW_SHOW, $GUI_Settings)

	$Refresh = 1
	While 1
		$msg = GUIGetMsg()
		If $msg > 0 Then
			$Refresh = 1
		EndIf		
		Switch $msg
			Case $Checkbox_Insert
				If GUICtrlRead($Checkbox_Insert) = 1 Then
					$InsertComment = 1
				Else
					$InsertComment = 0
				EndIf
			Case $Checkbox_Strip
				If GUICtrlRead($Checkbox_Strip) = 1 Then
					$StripComment = 1
				Else
					$StripComment = 0
				EndIf
			Case $Radio_AutoIt, $Radio_Code
				If GUICtrlRead($Radio_AutoIt) = 1 Then
					$Tag_Preference = "autoit"
				Else
					$Tag_Preference = "code"
				EndIf				
			Case $Button_Threshhold_Left
				Switch $Codebox_Threshhold
					Case 20 to 40
						$Codebox_Threshhold -= 4
					Case 10 to 16 
						$Codebox_Threshhold -= 2
					Case 8
						$Codebox_Threshhold = 0
				EndSwitch
			Case $Button_Threshhold_Right
				Switch $Codebox_Threshhold
					Case 0
						$Codebox_Threshhold = 8
					Case 8 to 14 
						$Codebox_Threshhold += 2
					Case 16 to 36 
						$Codebox_Threshhold += 4
				EndSwitch
			Case $Button_Trans_Left
				Switch $GUI_Transparency
					Case 255 
						$GUI_Transparency = 254
					Case 234 to 254
						$GUI_Transparency -= 2
					Case 194 to 232 
						$GUI_Transparency -= 4
				EndSwitch
			Case $Button_Trans_Right
				Switch $GUI_Transparency
					Case 192 to 230 
						$GUI_Transparency += 4
					Case 232 to 252 
						$GUI_Transparency += 2
					Case 254 
						$GUI_Transparency = 255
				EndSwitch
			Case $Checkbox_ScITE
				If GUICtrlRead($Checkbox_ScITE) = 1 Then
					$ScITE = 1
				Else
					$ScITE = 0
				EndIf
			Case $Button_Save 
				Save_IniFile()
				GUIDelete($GUI_Settings)
				ExitLoop
		EndSwitch
		If $Refresh Then Refresh_Settings_GUI()
	WEnd
EndFunc
		
Func Refresh_Settings_GUI()
	$Refresh = 0
	If $InsertComment Then
		GUICtrlSetState($Checkbox_Insert, 1)
		GUICtrlSetState($Checkbox_Strip, 64) ; $GUI_ENABLE
		GUICtrlSetColor($Label_Strip, 0x000000)
	Else
		$StripComment = 0
		GUICtrlSetState($Checkbox_Insert, 4)
		GUICtrlSetState($Checkbox_Strip, 4) ; $GUI_UNCHECK
		GUICtrlSetState($Checkbox_Strip, 132) ; $GUI_DISABLE + $GUI_UNCHECK
		GUICtrlSetColor($Label_Strip, 0x999999)
	EndIf
	If $StripComment Then 
		GUICtrlSetState($Checkbox_Strip, 1)
	Else
		GUICtrlSetState($Checkbox_Strip, 4)
	EndIf
	If $Tag_Preference = "autoit" Then
		GUICtrlSetState($Radio_AutoIt, 1)
		GUICtrlSetColor($Label_Code1, 0x999999)
		GUICtrlSetColor($Label_Code2, 0x999999)
		GUICtrlSetState($Button_Threshhold_Left, 128) ; $GUI_DISABLE
		GUICtrlSetState($Button_Threshhold_Right, 128) ; $GUI_DISABLE
		GUICtrlSetState($Label_Code2, 128) ; $GUI_DISABLE
		GUICtrlSetColor($Label_Threshhold, 0x999999)
	Else
		GUICtrlSetState($Radio_Code, 1)
		GUICtrlSetColor($Label_Code1, 0x000000)
		GUICtrlSetColor($Label_Code2, 0x000000)
		GUICtrlSetState($Label_Code1, 64) ; $GUI_DISABLE
		GUICtrlSetState($Button_Threshhold_Left, 64) ; $GUI_DISABLE
		GUICtrlSetState($Button_Threshhold_Right, 64) ; $GUI_DISABLE
		GUICtrlSetState($Label_Code2, 64) ; $GUI_DISABLE
		GUICtrlSetColor($Label_Threshhold, 0x000000)
		If $Codebox_Threshhold = 0 Then
			GUICtrlSetData($Label_Threshhold, "OFF")
			GUICtrlSetColor($Label_Threshhold, 0x999999)
		Else
			GUICtrlSetData($Label_Threshhold, $Codebox_Threshhold)
		EndIf
	EndIf
	WinSetTrans($AppID, "", $GUI_Transparency)
	If $GUI_Transparency = 255 Then
		GUICtrlSetData($Label_Trans, "OFF")
		GUICtrlSetColor($Label_Trans, 0x999999)
	Else
		GUICtrlSetData($Label_Trans, $GUI_Transparency)
		GUICtrlSetColor($Label_Trans, 0x000000)
	EndIf
	If $ScITE Then 
		GUICtrlSetState($Checkbox_ScITE, 1)
	Else
		GUICtrlSetState($Checkbox_ScITE, 4)
	EndIf
EndFunc
	
; ------------------------------------------------------------------------------
Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg, $iwParam
;~  Local $tBuffer
;    $hWndListView = $FMListView
 ;   If Not IsHWnd($FMListView) Then $hWndListView = GUICtrlGetHandle($FMListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")

    Switch $hWndFrom
		Case $LPListView
            Switch $iCode
                Case $NM_DBLCLK 
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				    $aHit = _GUICtrlListView_SubItemHitTest($LPListView)
					If $aHit[0] < 0 Then Return $GUI_RUNDEFMSG
					$FilenameFull = $Work_Folder & "\" & $ShowTopicFolder & "\" & $LPFileList[$aHit[0] + 1]
				Case $NM_CUSTOMDRAW
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
					Local $iDrawStage = DllStructGetData($tCustDraw, "dwDrawStage")
					
					If $iDrawStage = $CDDS_PREPAINT Then Return $CDRF_NOTIFYITEMDRAW
					If $iDrawStage = $CDDS_ITEMPREPAINT Then Return $CDRF_NOTIFYSUBITEMDRAW
					Local $iSubItem = DllStructGetData($tCustDraw, "iSubItem")
					Local $iItem = DllStructGetData($tCustDraw, "dwItemSpec")
					$iColor = 0xFF0000 ; Black text
					If $iSubItem = 1 Then
						$iColor = 0x000000 ; Blue text
					EndIf
					DllStructSetData($tCustDraw, "clrText", $iColor) ; Blue text
            EndSwitch
        Case $FMListView
            Switch $iCode
;				Case $LVN_ENDSCROLL ; redraw grid lines
;					$tNMHDR = DllStructCreate("hwnd hWnd;uint cID;int code", $ilParam)
;					$hLV = HWnd(DllStructGetData($tNMHDR, "hWnd"))
;					_WinAPI_InvalidateRect($hLV)
                Case $NM_DBLCLK 
                    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
				    $aHit = _GUICtrlListView_SubItemHitTest($FMListView)
					If $aHit[0] < 0 Then Return $GUI_RUNDEFMSG
					Switch $aHit[1]
						Case 1 ; Topic
							$ShowTopicWeb = $aHit[0] + 1
						Case 5 ; Files
							$ShowTopicFolder = $ListViewTopic[$aHit[0] + 1]
					EndSwitch
				Case $NM_CUSTOMDRAW
					Local $tCustDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $ilParam)
					Local $iDrawStage = DllStructGetData($tCustDraw, "dwDrawStage")
					
					If $iDrawStage = $CDDS_PREPAINT Then Return $CDRF_NOTIFYITEMDRAW
					If $iDrawStage = $CDDS_ITEMPREPAINT Then Return $CDRF_NOTIFYSUBITEMDRAW
					
					Local $iItem = DllStructGetData($tCustDraw, "dwItemSpec")
					Local $iSubItem = DllStructGetData($tCustDraw, "iSubItem")
					If $iSubItem Then
						$iColor = 0x000000 ; Black text
						Switch $iSubItem
							Case 1 ; Topic
								$iColor = 0xFF0000 ; Blue text
							Case 5 ; Files
								$iColor = 0xFF0000 ; Blue text
						EndSwitch
;						DllStructSetData($tCustDraw, "clrTextBk", $iColorBk)
						DllStructSetData($tCustDraw, "clrText", $iColor)
					EndIf
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc