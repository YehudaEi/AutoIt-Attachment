#NoTrayIcon
#include <GuiConstants.au3>
#include <Array.au3>

;;***********************************************************************

Global $AreaCode, $DataFile, $CompanyN, $LogArray[1]

Func _Now()
$AMPM="AM"
$12Hour=@HOUR
If @HOUR > "12" Then
$AMPM="PM"
$12Hour=@HOUR-12
EndIf
Return @MON&"/"&@MDAY&"/"&@YEAR&" "&$12Hour&":"&@MIN&":"&@SEC&" "&$AMPM
EndFunc

Func LoadVars()
$AreaCode=INIRead("options.ini","Phone3","AreaCode","")
$DataFile=INIRead("options.ini","Phone3","Datafile","data.ini")
$CompanyN=INIRead("options.ini","Phone3","Name","for "&@username)
EndFunc

LoadVars()

Func _GUICtrlLVClear($listview)
Local $LVM_DELETEALLITEMS=0x1009
GuiCtrlSendMsg($listview, $LVM_DELETEALLITEMS,0,0)
EndFunc

Func NewName()
$company=IniRead($DataFile,GUICtrlRead($NameCombo),"Company","")
GUICtrlSetData($CompanyBox,$company)
$projects=IniRead($DataFile,GUICtrlRead($NameCombo),"Projects","|")
GUICtrlSetData($ProjectBox,$projects)
_GUICtrlLVClear($NumberList)
$numbers=IniRead($DataFile,GUICtrlRead($NameCombo),"Available","0")
For $i=1 to $numbers Step 1
	$thisNumber=IniRead($DataFile,GUICtrlRead($NameCombo),$i,"No Numbers")
	GUICtrlCreateListViewItem($thisNumber,$NumberList)
	Next
EndFunc

Func ClearMsgWin()
GUICtrlSetData($NameCombo,IniRead($DataFile,"Names","list","Type Name Here"))
GUICtrlSetData($MessageBox,"")
GUICtrlSetState($CallBackCheck,$GUI_UNCHECKED)
GUICtrlSetState($WillCallCheck,$GUI_UNCHECKED)
GUICtrlSetState($UrgentCheck,$GUI_UNCHECKED)
GUICtrlSetState($ReturnedCheck,$GUI_UNCHECKED)
NewName()
EndFunc

Func WhichNum()
For $TestNum=0 To IniRead($DataFile,GUICtrlRead($NameCombo),"Available","0")
If IniRead($DataFile,GUICtrlRead($NameCombo),$TestNum,"0") == GUICtrlRead(GUICtrlRead($NumberList)) Then ExitLoop
Next
Return $TestNum
EndFunc

Func ClearNewNum()
GUICtrlSetData($NewNumType,"")
GUICtrlSetData($NewNumAreacode,$AreaCode)
GUICtrlSetData($NewNumThree,"")
GUICtrlSetData($NewNumFour,"")
GUICtrlSetData($NewNumExt,"")
EndFunc

Func SetMsgDetails()
GUICtrlSetData($SelMsgDate,StringTrimRight(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,1)),StringLen(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,1)))-StringInStr(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,1)),"|")+1))
GUICtrlSetData($SelMsgName,StringTrimRight(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,2)),StringLen(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,2)))-StringInStr(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,2)),"|")+1))
GUICtrlSetData($SelMsgProject,StringTrimRight(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,3)),StringLen(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,3)))-StringInStr(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,3)),"|")+1))
GUICtrlSetData($SelMsgMessage,StringTrimRight(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,4)),StringLen(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,4)))-StringInStr(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,4)),"|")+1))
GUICtrlSetData($SelMsgAction,StringTrimRight(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,5)),StringLen(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,5)))-StringInStr(StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,5)),"|")+1))
GUICtrlSetData($SelMsgContact,StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),StringInStr(GUICtrlRead(GUICtrlRead($MsgLog)),"|",0,6)))
If GUICtrlRead($SelMsgContact)="0" Then GUICtrlSetData($SelMsgContact,"")
EndFunc

Func OpenMsgs($daFile)
$FiletoOpen=FileOpen($daFile,0)
GUISwitch($MsgWin)
While 1
	$ThisLine=FileReadLine($FiletoOpen)
	If @error = -1 Then ExitLoop
	If $ThisLine = "" Then ExitLoop
	If StringinStr($ThisLine,"|",0,6) = 0 AND MsgBox(4,"Error","This line appears to be the wrong format...Continue anyway?") <>6 Then
	ExitLoop
	Else
	_ArrayAdd($LogArray,GUICtrlCreateListViewItem($ThisLine,$MsgLog))
	EndIf
WEnd
FileClose($FiletoOpen)
EndFunc

Func StoreMsgs($FiletoSave)
	FileDelete($FiletoSave)
	$CurrentArrayTest=1
	While $CurrentArrayTest<=_ArrayMaxIndex($LogArray)
	If GUICtrlRead($LogArray[$CurrentArrayTest]) <> "" Then FileWrite($FileToSave,GUICtrlRead($LogArray[$CurrentArrayTest])&@CRLF)
	$CurrentArrayTest=$CurrentArrayTest+1
	WEnd
EndFunc

Func PrintMe()
$PrintFile=FileOpen(@ScriptDir&"\print.htm",2)
$CurrentArrayTest=1
$TitleString="Phone Messages "
If $CompanyN <> "" Then $TitleString=$TitleString & $CompanyN & " "
$TitleString=$TitleString & "-printed "&_Now()
FileWrite($PrintFile,"<HTML>"&@CRLF&"<HEAD>"&@CRLF&"<TITLE>"&$TitleString&"</TITLE>"&@CRLF&"</HEAD>"&@CRLF&"<BODY>"&@CRLF)

While $CurrentArrayTest<=_ArrayMaxIndex($LogArray)
$CurrLineContents = GUICtrlRead($LogArray[$CurrentArrayTest])

If $CurrLineContents <> "" Then
$MessageStrings = StringSplit($CurrLineContents,"|")
If $MessageStrings[1]="Yes" Then FileWrite($PrintFile,"<strike>")
FileWrite($PrintFile,"From: "&$MessageStrings[3]&"<br>"&@CRLF)
FileWrite($PrintFile,"Date: "&$MessageStrings[2]&"<br>"&@CRLF)
If $MessageStrings[4]<>"" Then FileWrite($PrintFile,"Re: "&$MessageStrings[4]&"<br>"&@CRLF)
If $MessageStrings[7]<>"" Then FileWrite($PrintFile,"Contact: "&$MessageStrings[7]&"<br>"&@CRLF)
If $MessageStrings[6]<>"" Then FileWrite($PrintFile,"Action: "&$MessageStrings[6]&"<p>"&@CRLF)
If $MessageStrings[5]<>"" Then FileWrite($PrintFile,"Message: <br>"&@CRLF)
If $MessageStrings[5]<>"" Then FileWrite($PrintFile,$MessageStrings[5]&"<p>"&@CRLF)
If $MessageStrings[1]="Yes" Then FileWrite($PrintFile,"</strike>")
FileWrite($PrintFile,"<hr>"&@CRLF)
EndIf

$CurrentArrayTest=$CurrentArrayTest+1
WEnd

FileWrite($PrintFile,"<center>**End of Messages**</center></BODY></HTML>")
FileClose($PrintFile)
RunWait(@COMSPEC&' /c rundll32.exe '&@SystemDir&'\mshtml.dll,PrintHTML "'&@ScriptDir&'\print.htm"',@ScriptDir,@SW_HIDE)
FileDelete(@ScriptDir&"\print.htm")
EndFunc

;;***********************************************************************

$MsgWin=GUICreate("Phone Messages " & $CompanyN,"640","480")
GUISetState(@SW_SHOW,$MsgWin)

$MsgLog=GUICtrlCreateListView("Reported|Time|Name|Project|Message|Action|Contact",5,5,500,440,$LVS_NOSORTHEADER+$LVS_SHOWSELALWAYS)

$filemenu=GUICtrlCreateMenu("File")
$PrintMsgs=GUICtrlCreateMenuItem("Print",$filemenu)
GUICtrlCreateMenuItem("",$filemenu)
$RestoreMsgs=GUICtrlCreateMenuItem("Open",$filemenu)
$SaveMsgs=GUICtrlCreateMenuItem("Save",$filemenu)
GUICtrlCreateMenuItem("",$filemenu)
$ExitMenu=GUICtrlCreateMenuItem("Exit",$filemenu)

$editmenu=GUICtrlCreateMenu("Edit")
$OpenNewMenu=GUICtrlCreateMenuItem("New Message",$editmenu)
$ReportedMenu=GUICtrlCreateMenuItem("Report message",$editmenu)
$DeleteMenu=GUICtrlCreateMenuItem("Delete message",$editmenu)
$ClearMenu=GUICtrlCreateMenuItem("Clear all messages",$editmenu)
GUICtrlCreateMenuItem("",$editmenu)
$ConfigureMenu=GUICtrlCreateMenuItem("Options",$editmenu)

$aboutmenu=GUICtrlCreateMenu("About")
$OpenAbout=GUICtrlCreateMenuItem("About Phone v3.0",$aboutmenu)

$OpenNewMsg=GUICtrlCreateButton("New message",50,430,95,-1,$BS_DEFPUSHBUTTON)
$ReportedMsg=GUICtrlCreateButton("Report selected",150,430,95,-1)
$DeleteMsg=GUICtrlCreateButton("Delete selected",250,430,95,-1)
$ClearMsgs=GUICtrlCreateButton("Clear all messages",350,430,95,-1)

GUICtrlCreateLabel("Date and Time:",510,5)
$SelMsgDate=GUICtrlCreateInput("",510,20,125,-1,$ES_READONLY)
GUICtrlCreateLabel("Name and Company:",510,50)
$SelMsgName=GUICtrlCreateInput("",510,65,125,50,$ES_MULTILINE+$ES_AUTOVSCROLL+$ES_READONLY)
GUICtrlCreateLabel("Project:",510,125)
$SelMsgProject=GUICtrlCreateInput("",510,140,125,-1,$ES_READONLY)
GUICtrlCreateLabel("Message:",510,165)
$SelMsgMessage=GUICtrlCreateInput("",510,180,125,100,$ES_MULTILINE+$ES_AUTOVSCROLL+$ES_READONLY)
GUICtrlCreateLabel("Action:",510,285)
$SelMsgAction=GUICtrlCreateInput("",510,300,125,50,$ES_MULTILINE+$ES_AUTOVSCROLL+$ES_READONLY)
GUICtrlCreateLabel("Contact:",510,355)
$SelMsgContact=GUICtrlCreateInput("",510,370,125,-1,$ES_READONLY)

;;***********************************************************************

$OptionsWin=GUICreate("Options",200,170,-1,-1,-1,$WS_EX_TOOLWINDOW,$MsgWin)

GUICtrlCreateLabel("'Phone messages for' name:",5,5)
$OptionsName=GUICtrlCreateInput(StringTrimLeft($CompanyN,4),5,20,150,-1)
GUICtrlCreateLabel("Contacts data file:",5,50)
$OptionsData=GUICtrlCreateInput($DataFile,5,65,150,-1)
$OptionsDataBrowse=GUICtrlCreateButton("Browse",155,63)
GUICtrlCreateLabel("Default areacode for new numbers:",5,95)
GUICtrlCreateLabel("(",5,112)
GUICtrlCreateLabel(")",42,112)
$OptionsAreacode=GUICtrlCreateInput($AreaCode,10,110,30,-1,$ES_NUMBER)

$OptionsDone=GUICtrlCreateButton("Done",40,140,-1,-1,$BS_DEFPUSHBUTTON)
$OptionsCancel=GUICtrlCreateButton("Cancel",100,140)

;;***********************************************************************

$NewMsg=GUICreate("New Phone Message",430,315,50,50,-1,$WS_EX_TOOLWINDOW,$MsgWin)

GUICtrlCreateLabel("Name:",5,15)
$NameCombo=GUICtrlCreateCombo ("Type Name Here",5,30,200,25)
GUICtrlSetData($NameCombo,IniRead($DataFile,"Names","list","Type Name Here"))

$NewNameButton=GUICtrlCreateButton("Store this name",10,52)
$DeleteNameButton=GUICtrlCreateButton("Delete this name",108,52)

$CallBackCheck=GUICtrlCreateCheckbox("Please return call",5,80)
$WillCallCheck=GUICtrlCreateCheckbox("Will call back",5,100)
$UrgentCheck=GUICtrlCreateCheckbox("Urgent",115,80)
$ReturnedCheck=GUICtrlCreateCheckbox("Returned call",115,100)

GUICtrlCreateLabel("Message:",5,123)
$MessageBox=GUICtrlCreateInput("",5,140,200,135,$ES_MULTILINE+$ES_AUTOVSCROLL)

GUICtrlCreateLabel("Company:",210,15)
$CompanyBox=GUICtrlCreateInput("",210,30,180,20)
$CompanySaveButton=GUICtrlCreateButton("Save",390,30,-1,20)

GUICtrlCreateLabel("Phone numbers:",210,55)
$NumberList=GUICtrlCreateListView("Type|Number",210,70,215,75,$LVS_NOSORTHEADER+$LVS_SHOWSELALWAYS)

$NewNumberButton=GUICtrlCreateButton("Add Number",230,147)
$DeleteNumberButton=GUICtrlCreateButton("Delete Number",330,147)

GUICtrlCreateLabel("Current Projects:",210,175)
$ProjectBox=GUICtrlCreateList("",210,190,215,85)

$NewProjectButton=GUICtrlCreateButton("Add Project",230,250)
$DeleteProjectButton=GUICtrlCreateButton("Delete Project",330,250)

GUICtrlCreateGroup("New Message",2,0,426,280)

$DoneButton=GUICtrlCreateButton("Done",132,285,50,-1,$BS_DEFPUSHBUTTON)
$ResetButton=GUICtrlCreateButton("Reset",182,285,50,-1)
$CancelButton=GUICtrlCreateButton("Cancel",232,285,50,-1)

;;***********************************************************************

$NewNum=GUICreate("New Number",200,140,-1,-1,-1,$WS_EX_TOOLWINDOW,$NewMsg)

GUICtrlCreateLabel("Number:",5,50)
$NewNumThree=GUICtrlCreateInput("",50,65,25,-1,$ES_NUMBER)
GUICtrlCreateLabel("-",75,68)
$NewNumFour=GUICtrlCreateInput("",80,65,35,-1,$ES_NUMBER)
GUICtrlCreateLabel("x",120,72)
$NewNumExt=GUICtrlCreateInput("",127,65,68,-1,$ES_NUMBER)
GUICtrlCreateLabel("(",5,68)

GUICtrlCreateLabel("Type:",5,5)
$NewNumType=GUICtrlCreateInput("",5,20,190,-1)

$NewNumDoneButton=GUICtrlCreateButton("Done",40,110,-1,-1,$BS_DEFPUSHBUTTON)
$NewNumCancelButton=GUICtrlCreateButton("Cancel",100,110)

$NewNumAreacode=GUICtrlCreateInput($AreaCode,10,65,25,-1,$ES_NUMBER)
GUICtrlCreateLabel(")",35,68)

;;***********************************************************************

$AboutWin=GUICreate("About Phone v3.0 (Beta)",250,200,-1,-1,-1,$WS_EX_TOOLWINDOW,$MsgWin)
GUICtrlCreateLabel("Phone Message 3.0 (Beta) ©2005 by Michael Garrison (michael@garrison.net)",5,5,240,30)
GUICtrlCreateLabel("This program is licenced as freeware, but may not be be modified, reverse-engineered, decompiled or sold.",5,40,240,60)
GUICtrlCreateLabel("Thanks to Jonathan Bennett and the AutoIt Team. (hiddensoft.com)",5,85,240,60)
GUICtrlCreateLabel("No warrantees or guarantees are expressed or implied, except that this program is virus- and spyware-free.",5,120,240,50)
$AboutOK=GUICtrlCreateButton("OK",95,170,60,-1)

;;***********************************************************************

If INIRead("Options.ini","Phone3","BadShutdown","no") = "yes" Then
If MsgBox(4,"AutoRecover","There are unsaved messages that can be recovered, would you like to do this?") = 6 Then
OpenMsgs(@ScriptDir&"\autosave.txt")
EndIf
EndIf

While 1
	$msg=GUIGetMsg(1)

	Select
		Case $msg[0]=$GUI_EVENT_CLOSE And $msg[1]=$MsgWin
		If _ArrayMaxIndex($LogArray)>0 AND IniRead("Options.ini","Phone3","BadShutdown","no") = "yes" Then
		If MsgBox(4,"Save messages?","Would you like to save your messages before closing?") = 6 Then
			$FiletoSave=FileSaveDialog("Save Messages",@DesktopDir,"Text Files (*.txt)",16)
			If StringTrimLeft($FiletoSave,StringLen($FiletoSave)-4) <> ".txt" Then $FiletoSave = $FiletoSave&".txt"
			StoreMsgs($FiletoSave)
		EndIf
		EndIf
		IniWrite("Options.ini","Phone3","BadShutdown","no")
		FileDelete(@ScriptDir&"\autosave.txt")
		ExitLoop

		Case $msg[0]=$GUI_EVENT_CLOSE And $msg[1]=$NewMsg
		GUISetState(@SW_HIDE,$NewMsg)
		GUICtrlSetData($NameCombo,IniRead($DataFile,"Names","list","Type Name Here"))
		GUICtrlSetData($MessageBox,"")
		NewName()

		Case $msg[0]=$GUI_EVENT_CLOSE And $msg[1]=$OptionsWin
		GUISetState(@SW_HIDE,$OptionsWin)

		Case $msg[0]=$GUI_EVENT_CLOSE And $msg[1]=$AboutWin OR $msg[0]=$AboutOK
		GUISetState(@SW_HIDE,$AboutWin)

		Case $msg[0]=$OpenNewMsg OR $msg[0]=$OpenNewMenu
		GUICtrlSetState($NameCombo,$GUI_FOCUS)
		GUISetState(@SW_SHOW,$NewMsg)

		Case $msg[0]=$PrintMsgs
		PrintMe()

		Case $msg[0]=$NameCombo
		NewName()

		Case $msg[0]=$NewNameButton
		If StringInStr(IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo)) Then
			If GUICtrlRead($NameCombo) == "" Then
				MsgBox(0,"Error","Blank names not accepted.  Please type a name")
			Else
				MsgBox(0,"Name Already Exists","The name you have typed already exists.  Type another name or click 'Add Number' button to edit.")
			EndIf
			Else
			IniWrite($DataFile,"Names","list",IniRead($DataFile,"Names","list","") & "|" & GUICtrlRead($NameCombo))
			IniWrite($DataFile,GUICtrlRead($NameCombo),"Company",GUICtrlRead($CompanyBox))
			IniWrite($DataFile,GUICtrlRead($NameCombo),"Available","0")
			GUICtrlSetData($NameCombo,IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo))
			NewName()
			MsgBox(0,"Name Stored","Name Stored")
		EndIf

		Case $msg[0]=$CompanySaveButton
		If StringInStr(IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo)) and GUICtrlRead($NameCombo) <> "" Then
			IniWrite($DataFile,GUICtrlRead($NameCombo),"Company",GUICtrlRead($CompanyBox))
			MsgBox(0,"Saved","Company name updated.")
		Else
		MsgBox(0,"Error","You must have a valid name selected to save a company name.")
		EndIf

		Case $msg[0]=$NewProjectButton
		If StringInStr(IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo)) and GUICtrlRead($NameCombo) <> "" Then
			$projects=IniRead($DataFile,GUICtrlRead($NameCombo),"Projects","|")
			IniWrite($DataFile,GUICtrlRead($NameCombo),"Projects",$projects & InputBox("Add Project","Please enter new Project name:") & "|")
			$projects=IniRead($DataFile,GUICtrlRead($NameCombo),"Projects","|")
			GUICtrlSetData($ProjectBox,$projects)
		Else
		MsgBox(0,"Error","You must have a valid name selected to add a project.")
		EndIf

		Case $msg[0]=$NewNumberButton
		If StringInStr(IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo)) and GUICtrlRead($NameCombo) <> "" Then
		GUISetState(@SW_SHOW,$NewNum)
		GUICtrlSetState($NewNumThree,$GUI_FOCUS)
		Else
		MsgBox(0,"Error","You must have a valid name selected to add a Number.")
		EndIf

		Case $msg[0]=$NewNumDoneButton
		GUISwitch($NewMsg)
		$NumberNum="("&GUICtrlRead($NewNumAreacode)&") "&GUICtrlRead($NewNumThree)&"-"&GUICtrlRead($NewNumFour)
		If StringLen(GUICtrlRead($NewNumExt)) > 0 Then
			$NumberNum=$NumberNum&" x"&GUICtrlRead($NewNumExt)
		EndIf
		$NumberTyp=GUICtrlRead($NewNumType)
		If StringLen(GUICtrlRead($NewNumThree)) = 3 AND StringLen(GUICtrlRead($NewNumFour)) = 4 AND $NumberTyp <> "" Then
			$CurrNum=IniRead($DataFile,GUICtrlRead($NameCombo),"Available","0")
			IniWrite($DataFile,GUICtrlRead($NameCombo),"Available",$CurrNum + 1)
			IniWrite($DataFile,GUICtrlRead($NameCombo),$CurrNum + 1,$NumberTyp & "|" & $NumberNum)
			NewName()
			GUISetState(@SW_HIDE,$NewNum)
			ClearNewNum()
		Else
			MsgBox(0,"Error","Invalid")
		EndIf

		Case $msg[0]=$NewNumCancelButton
		GUISetState(@SW_HIDE,$NewNum)
		ClearNewNum()

		Case $msg[0]=$DeleteNameButton
		If StringInStr(IniRead($DataFile,"Names","list","Type Name Here"),GUICtrlRead($NameCombo)) and GUICtrlRead($NameCombo) <> "" Then
			IniDelete($DataFile,GUICtrlRead($NameCombo))
			$String=INIRead($DataFile,"Names","list","|")
			$StringPlace=StringInStr($String,GUICtrlRead($NameCombo))
			$StringLong=StringLen(GUICtrlRead($NameCombo))
			$StringLeft=StringTrimRight($String,StringLen($String) - $StringPlace + 2)
			$StringRight=StringTrimLeft($String,$StringPlace + $StringLong)
			If StringLen($StringRight) == "0" Then
				IniWrite($DataFile,"Names","list",$StringLeft)
			Else
				INIWrite($DataFile,"Names","list",$StringLeft & "|" & $StringRight)
			EndIf
			GUICtrlSetData($NameCombo,IniRead($DataFile,"Names","list","Type Name Here"))
			GUICtrlSetData($MessageBox,"")
			NewName()
		Else
			MsgBox("0","Error","You must select a stored name")
		EndIf

		Case $msg[0]=$DeleteNumberButton
		$DelNum=WhichNum()
		$StopNum=IniRead($DataFile,GUICtrlRead($NameCombo),"Available","0")-1
		If $DelNum == IniRead($DataFile,GUICtrlRead($NameCombo),"Available","0") Then
			IniDelete($DataFile,GUICtrlRead($NameCombo),$DelNum)
		Else
		For $i=$DelNum To $StopNum
		IniWrite($DataFile,GUICtrlRead($NameCombo),$i,IniRead($DataFile,GUICtrlRead($NameCombo),$i + 1,"NAN"))
		Next
		EndIf
		IniDelete($DataFile,GUICtrlRead($NameCombo),$StopNum + 1)
		IniWrite($DataFile,GUICtrlRead($NameCombo),"Available",$StopNum)
		NewName()

		Case $msg[0]=$DeleteProjectButton
		If GUICtrlRead($ProjectBox) <> "" Then
			$String=INIRead($DataFile,GUICtrlRead($NameCombo),"Projects","|")
			$StringPlace=StringInStr($String,GUICtrlRead($ProjectBox))
			$StringLong=StringLen(GUICtrlRead($ProjectBox))
			$StringLeft=StringTrimRight($String,StringLen($String) - $StringPlace + 2)
			$StringRight=StringTrimLeft($String,$StringPlace + $StringLong)
			INIWrite($DataFile,GUICtrlRead($NameCombo),"Projects",$StringLeft & "|" & $StringRight)
			NewName()
		Else
		MsgBox(0,"Error","You must select a project to delete")
		EndIf

		Case $msg[0]=$ResetButton
		ClearMsgWin()
		GUICtrlSetState($NameCombo,$GUI_FOCUS)

		Case $msg[0]=$CancelButton
		If MsgBox(36,"Are you sure?","Do you really want to close this message without saving?")=6 Then
			GUISetState(@SW_HIDE,$NewMsg)
			ClearMsgWin()
		EndIf

		Case $msg[0]=$DoneButton
		If GUICtrlRead($NameCombo) <> "" Then
		$NameStr=GUICtrlRead($NameCombo)
		If GUICtrlRead($CompanyBox) <> "" Then $NameStr=$NameStr & " with " & GUICtrlRead($CompanyBox)
		$ActionStr=""
		If GUICtrlRead($UrgentCheck) = $GUI_CHECKED Then $ActionStr = $ActionStr & "Urgent,"
		If GUICtrlRead($ReturnedCheck) = $GUI_CHECKED Then $ActionStr = $ActionStr & " Returned Call,"
		If GUICtrlRead($CallBackCheck) = $GUI_CHECKED Then $ActionStr = $ActionStr & " Please Return Call."
		If GUICtrlRead($WillCallCheck) = $GUI_CHECKED Then $ActionStr = $ActionStr & " Will Call Back."
		$ContactStr=StringReplace(GUICtrlRead(GUICtrlRead($NumberList)),"|",": ")
		If $ContactStr="0" Then $ContactStr=""
		GUISwitch($MsgWin)
		_ArrayAdd($LogArray,GUICtrlCreateListViewItem("No|" & _Now() & "|" & $NameStr & "|" & GUICtrlRead($ProjectBox) & "|" & GUICtrlRead($MessageBox) & "|" & $ActionStr & "|" & $ContactStr,$MsgLog))
		GUISetState(@SW_HIDE,$NewMsg)
		ClearMsgWin()
		Else
		MsgBox("0","Error","You must at least enter a name and message or action to save this message")
		EndIf
		StoreMsgs(@ScriptDir&"\autosave.txt")
		IniWrite("options.ini","Phone3","BadShutdown","yes")

		Case $msg[0]=$ClearMsgs OR $msg[0]=$ClearMenu
		_GUICtrlLVClear($MsgLog)
		Global $LogArray[1]
		StoreMsgs(@ScriptDir&"\autosave.txt")
		IniWrite("options.ini","Phone3","BadShutdown","yes")
		SetMsgDetails()

		Case $msg[0]=$DeleteMsg OR $msg[0]=$DeleteMenu
		If GUICtrlRead($MsgLog) <> "" Then
			GUICtrlDelete(GUICtrlRead($MsgLog))
			SetMsgDetails()
			StoreMsgs(@ScriptDir&"\autosave.txt")
			IniWrite("options.ini","Phone3","BadShutdown","yes")
		Else
		MsgBox(0,"Error","You must select the message you want to delete")
		EndIf

		Case $msg[0]=$SaveMsgs
		If _ArrayMaxIndex($LogArray)>0 Then
		$FiletoSave=FileSaveDialog("Save Messages",@DesktopDir,"Text Files (*.txt)",16)
		If StringTrimLeft($FiletoSave,StringLen($FiletoSave)-4) <> ".txt" Then $FiletoSave = $FiletoSave&".txt"
		StoreMsgs($FiletoSave)
		IniWrite("options.ini","Phone3","BadShutdown","no")
		Else
		MsgBox(0,"Oops","No messages to save.")
		EndIf

		Case $msg[0]=$RestoreMsgs
		$FiletoOpen=FileOpenDialog("Open saved messages",@DesktopDir,"Text Files (*.txt)",3)
		OpenMsgs($FiletoOpen)

		Case $msg[0]=$ReportedMsg OR $msg[0]=$ReportedMenu
		If StringLeft(GUICtrlRead(GUICtrlRead($MsgLog)),1)="Y" Then
			GUICtrlSetData(GUICtrlRead($MsgLog),"No"&StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),3))
		Else
		If StringLeft(GUICtrlRead(GUICtrlRead($MsgLog)),1)="N" Then
			GUICtrlSetData(GUICtrlRead($MsgLog),"Yes"&StringTrimLeft(GUICtrlRead(GUICtrlRead($MsgLog)),2))
			Else
			MsgBox(0,"Error","You must select a message to change.")
			EndIf
		EndIf

		Case $msg[0]=$ConfigureMenu
		GUISetState(@SW_SHOW,$OptionsWin)

		Case $msg[0]=$OptionsDone
		If FileExists($DataFile) = 1 AND FileExists(GUICtrlRead($OptionsData))=0 Then
		If MsgBox(4,"Transfer data?","Would you like to move the data from the old location to the new one?")=6 Then FileMove($DataFile,GUICtrlRead($OptionsData))
		If @Error<>0 Then MsgBox(0,"Error","There was a problem moving the data; the old file might be read-only or open by another program.  Old data has not been changed, but will not be used anymore, and the new data file will start blank.")		
		EndIf
		GUISetState(@SW_HIDE,$OptionsWin)
		IniWrite("options.ini","Phone3","Datafile",GUICtrlRead($OptionsData))
		IniWrite("options.ini","Phone3","AreaCode",GUICtrlRead($OptionsAreacode))
		If StringLen(GUICtrlRead($OptionsName)) > 0 Then
			IniWrite("options.ini","Phone3","Name","for "&GUICtrlRead($OptionsName))
		Else
			IniWrite("options.ini","Phone3","Name","")
		EndIf
		LoadVars()
		WinSetTitle("Phone Messages","","Phone Messages "&$CompanyN)

		Case $msg[0]=$OptionsCancel
		GUISetState(@SW_HIDE,$OptionsWin)
		GUICtrlSetData($OptionsName,StringTrimLeft($CompanyN,4))
		GUICtrlSetData($OptionsAreacode,$AreaCode)
		GUICtrlSetData($OptionsData,$DataFile)

		Case $msg[0]=$OptionsDataBrowse
		$TempData=GUICtrlRead($OptionsData)
		GUICtrlSetData($OptionsData,FileSaveDialog("Select Datafile:","","All (*.*)",-1,"data.ini"))
		If GUICtrlRead($OptionsData) = 1 Then GUICtrlSetData($OptionsData,$TempData)

		Case $msg[0]=$OpenAbout
		GUISetState(@SW_SHOW,$AboutWin)

		Case $msg[0]=$GUI_EVENT_PRIMARYDOWN AND $msg[1]=$MsgWin AND $msg[3]>5 AND $msg[3]<505 AND $msg[4]>5 AND $msg[4]<445
		SetMsgDetails()

		Case $msg[0]=$GUI_EVENT_SECONDARYDOWN AND $msg[1]=$MsgWin AND $msg[3]>5 AND $msg[3]<505 AND $msg[4]>5 AND $msg[4]<445
		SetMsgDetails()

		Case $msg[0]=$ExitMenu
		Exit

	EndSelect


Wend
