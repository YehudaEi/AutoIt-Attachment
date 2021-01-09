#AutoIt3Wrapper_res_fileversion= 1.0.0.0
#AutoIt3Wrapper_res_legalcopyright= d4rk
#AutoIt3Wrapper_res_description=Temporary Looker
#include <Array.au3>
#include <File.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>

#Region ### START Koda GUI section ### Form=e:\autoit project\tp former.kxf
$Form1_1 = GUICreate("Temporary Looker - d4rk", 325, 259, 193, 115)
$Group2 = GUICtrlCreateGroup("Specific Files", 8, 4, 313, 89)
$Combo1 = GUICtrlCreateCombo("", 21, 52, 129, 25,$CBS_DROPDOWNLIST)
GUICtrlSetData(-1, "*.mp3|*.wma|*.wav|*.jpg|*.png|*.ico|*.html|*.htm|*.swf|*.flv|*.js|*.php|*.*","*.*")
$Label1 = GUICtrlCreateLabel("File type for checking :", 20, 28, 111, 17)
$Label2 = GUICtrlCreateLabel("Or choose your own :", 179, 28, 105, 17)
$Confirm=GUICtrlCreateButton("Ok, I have my own", 181, 52, 97, 21)
$OwnStyle=GUICtrlCreateInput("*.au3", 181, 52, 97, 21,$ES_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group1 = GUICtrlCreateGroup("Save Directory", 8, 94, 313, 65)
$SaveDir=GUICtrlCreateInput("", 16, 118, 217, 21,$ES_READONLY)
$Browse = GUICtrlCreateButton("Browse", 241, 116, 65, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Option = GUICtrlCreateGroup("Option", 8, 159, 313, 97)
$MakeLog = GUICtrlCreateCheckbox("Make a log to those files", 16, 175, 193, 25)
$Copy = GUICtrlCreateCheckbox("Automatical copy files to Save Directory", 16, 199, 209, 25)
$Start = GUICtrlCreateButton("Ok, Let's Start", 16, 224, 129, 25, 0)
$Reset = GUICtrlCreateButton("Reset", 152, 224, 65, 25, 0)
$Exit = GUICtrlCreateButton("Exit", 224, 224, 89, 25, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUICtrlSetState($OwnStyle,$GUI_HIDE)
GUICtrlSetState($Combo1,$ES_READONLY)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

$i=0
While 1
Global $time
$time=@Hour & "`" & @MIN & "`" & @SEC & "`" & "]" & "[" &@MON & "." & @MDAY & "." & @YEAR &"]"

$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Exit
			Exit
		Case $Confirm
			GUICtrlSetState($Confirm,$GUI_DISABLE)
			GUICtrlSetState($Confirm,$GUI_HIDE)
			GUICtrlSetState($OwnStyle,$GUI_SHOW)
			GUICtrlSetState($Combo1,$GUI_DISABLE)
			GUICtrlSetState($OwnStyle,$GUI_FOCUS)
			$i=1
		Case $Browse
			$SaveBox = FileSelectFolder("Choose a folder to save output files : ", "",1)
			GUICtrlSetData($SaveDir,$SaveBox)
		Case $Reset
			GUICtrlSetState($Combo1,$GUI_ENABLE)
			GUICtrlSetState($OwnStyle,$GUI_HIDE)
			GUICtrlSetState($Confirm,$GUI_SHOW)
			GUICtrlSetState($Confirm,$GUI_ENABLE)
			GUICtrlSetState($Confirm,$GUI_ENABLE)
			GUICtrlSetState($MakeLog,$GUI_UNCHECKED)
			GUICtrlSetState($Copy,$GUI_UNCHECKED)
			$i=0
		Case $Start
			If $i=1 and StringInStr(GUICtrlRead($OwnStyle),".",2)=0 Then
				MsgBox(64,"Error ...","Invalid file type" & @CR & "The valid example should be : *.htm or myfile.htm")
				GUICtrlSetState($OwnStyle,$GUI_FOCUS)
				GUICtrlSetData($OwnStyle,"")
				ContinueCase
			EndIf

			if GUICtrlRead($SaveDir)="" Then
				MsgBox(64,"Error ...","You need a place to save your files")
				$SaveBox = FileSelectFolder("Choose a folder to save output files : ", "",1)
				GUICtrlSetData($SaveDir,$SaveBox)
				ContinueCase
			EndIf
		
			if FileExists(GUICtrlRead($SaveDir))=0 Then
				MsgBox(64,"Error ...","The following directory cannot be found : " & @CR & '"' &GUICtrlRead($SaveDir) & '"')
				GUICtrlSetState($SaveDir,$GUI_FOCUS)
				ContinueCase
			EndIf

			If $i=1 and StringLeft(GUICtrlRead($OwnStyle),1)<>"*" and StringInStr(GUICtrlRead($OwnStyle),".",2)<>0 Then
				MsgBox(64,"Notification !","You have specificed a File name and its extension, any different files with the same extension will be ingroned !")
			EndIf
	
			if $i=1 and GUICtrlRead($Copy) = $GUI_CHECKED Then
			$SpeEx=GUICtrlRead($OwnStyle)
			_Copy()
			EndIf
		
			if $i=0 and GUICtrlRead($Copy) = $GUI_CHECKED Then
			$SpeEx=GUICtrlRead($Combo1)
			_Copy()
			endif
			
			if $i=1 and GUICtrlRead($MakeLog) = $GUI_CHECKED Then
			$SpeEx=GUICtrlRead($OwnStyle)
			_MakeLog()
			endif
			
			
			if $i=0 and GUICtrlRead($MakeLog) = $GUI_CHECKED Then
			$SpeEx=GUICtrlRead($Combo1)
			_MakeLog()
			endif
	EndSwitch
WEnd
;----------------------------------------
;START OF '_Copy FUNCTION'
;----------------------------------------
func _Copy()
$ContentDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths", "Directory")
$InContent=_FileListToArray($ContentDir,"*.*",2)


$Delindex=_ArraySearch($InContent,"index.dat")
If Not @error Then
_ArrayDelete($InContent,$Delindex)
EndIf


$Deldesktop=_ArraySearch($InContent,"desktop.ini")
If Not @error Then
_ArrayDelete($InContent,$Deldesktop)
EndIf


$Element=0
_ArrayDelete($InContent,$Element)





for $i=0 to UBound($InContent)-1
$Dir=$ContentDir & "\" & $InContent[$i]
$Files=_FileListToArray($Dir,$SpeEx)

for $j=0 to UBound($Files)-1
$NewName=StringReplace($Files[$j],"%20"," ")
$Stringcount=StringLen($NewName)
$dotcount = StringInStr($NewName, ".")
$Extensioncount=$Stringcount-$dotcount
$Extension=StringRight($NewName,$Extensioncount)

if FileExists(GUICtrlRead($SaveDir) &"\"& $NewName)=1 Then
	$askforexist=MsgBox(68,"Notification !","This file :" & ' "' & GUICtrlRead($SaveDir) & "\" & $NewName & '" ' &  "appears to exist ..." & @CR & " Do you want to rename it ?")
		if $askforexist=6 Then
		do 
		$Rename=InputBox("Renaming ...","Please type a new file's name :","","",100,100)
		until $Rename<>"" and StringInStr($Rename,"/")=0 and StringInStr($Rename,"\")=0 and StringInStr($Rename,":")=0 and StringInStr($Rename,"*")=0 and StringInStr($Rename,"?")=0 and StringInStr($Rename,'"')=0 and StringInStr($Rename,"<")=0 and StringInStr($Rename,">")=0 and StringInStr($Rename,"|")=0
		FileCopy($Dir & "\" & $Files[$j],GUICtrlRead($SaveDir)  & "\" & $Rename & "." & $Extension)
		msgbox(64,"Copy Complete ...","File renamed and copy successfully to :" & @CR & '"' & GUICtrlRead($SaveDir) & '"')
		EndIf
Else
if FileExists(GUICtrlRead($SaveDir) &"\"& $NewName)=0 Then
FileCopy($Dir & "\" & $Files[$j],GUICtrlRead($SaveDir) &"\"& $NewName)
EndIf
EndIf

Next
Next
MsgBox(64,"Notification !","Copy Process Successfully Complete ...")
EndFunc
;----------------------------------------
;END OF '_Copy FUNCTION'
;----------------------------------------



;----------------------------------------
;START OF ' _MakeLog FUNCTION'
;----------------------------------------
func _MakeLog()
FileWrite(GUICtrlRead($SaveDir) & "\[Temporary Looker Log]_" &"["&$time&".txt",  @CRLF & "------------------------------------|" & @CRLF & "#####    Temporary  Looker     #####|" & @CRLF & "##### Author : d4rk <Le Khuong Duy> |-----------------------####|" & @CRLF &"#### Start Time : ["&$time& "                   ####|" &  @CRLF & "----------------------------------------------------------------|" & @CRLF)
if $i=1 Then
	FileWrite(GUICtrlRead($SaveDir) & "\[Temporary Looker Log]_" &"["&$time&".txt","Look for : " & GUICtrlRead($Ownstyle) & @CRLF & @CRLF)
Else
	FileWrite(GUICtrlRead($SaveDir) & "\[Temporary Looker Log]_" &"["&$time&".txt","Look for : " & GUICtrlRead($Combo1) & @CRLF & @CRLF)
EndIf


$ContentDir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Cache\Paths", "Directory")
$InContent=_FileListToArray($ContentDir,"*.*",2)

$Delindex=_ArraySearch($InContent,"index.dat")
If Not @error Then
_ArrayDelete($InContent,$Delindex)
EndIf

$Deldesktop=_ArraySearch($InContent,"desktop.ini")
If Not @error Then
_ArrayDelete($InContent,$Deldesktop)
EndIf

$Element=0
_ArrayDelete($InContent,$Element)

for $i=0 to UBound($InContent)-1
$Dir=$ContentDir & "\" & $InContent[$i]
$Files=_FileListToArray($Dir,$SpeEx)

for $j=0 to UBound($Files)-1
$NewName=StringReplace($Files[$j],"%20"," ")
FileWriteLine(GUICtrlRead($SaveDir) & "\[Temporary Looker Log]_" &"["&$time & ".txt",$Dir & "\" & $Files[$j])
Next
Next
MsgBox(64,"Notification !","Logging Process Successfully Complete ...")
EndFunc
;----------------------------------------
;END OF '_MakeLog FUNCTION'
;----------------------------------------
