#NoTrayIcon
#Include <File.au3>
#include <WindowsConstants.au3>

;By Nafaa


;~ create necessary Dir and key
Global $temp_Dir
Global $temp_reg
Global $name
Global $path
Global $reg1
Global $reg2
Global $AU3
Global $error=0
Global $Key

$temp_Dir=@TempDir & "\Reg_to_Au3"
If FileExists($temp_Dir) Then
if DirRemove($temp_Dir,1)=0 Then $temp_Dir=@TempDir & "\Reg_to_Au3(" & Random(0,1000,1) & ")"
endif
if DirCreate($temp_Dir)=0 Then
	MsgBox(48,"","unable to create necessary files")
	Exit
EndIf

$temp_reg="HKEY_CURRENT_USER\Software\Reg to au3"
If RegDelete($temp_reg)=2 Then $temp_reg="HKEY_CURRENT_USER\Software\Reg to au3(" & Random(0,1000,1) & ")"
if RegWrite($temp_reg)=0 Then
	MsgBox(48,"","unable to create necessary keys")
	Exit
EndIf

;~ starting
$key=""
$reg=FileOpenDialog("Select a reg file",@ScriptDir, "Reg files (*.reg)",1)
$split=StringSplit($reg,"\")
$name=$split[$split[0]]
$path=StringLeft($Reg,StringInStr($Reg,"\", 0,-1)-1)

$Veuillez = GUICreate("Please Wait", 120, 20, -1, -1, $WS_POPUPWINDOW,$WS_EX_TOPMOST)
GUISetState(@SW_SHOW)
$Label1 = GUICtrlCreateLabel("        Please Wait ...", 4, 4, 387, 17)


$n=_FileCountLines($reg)
$reg1=FileOpen($reg,0)
$reg2=FileOpen($temp_Dir & "\" & $name,2)
$newname=StringTrimRight($name,4)
$au3=FileOpen($temp_Dir & "\" & $newname,2)

FileWrite($au3,";Reg Keys or Values to Delete :" & @CRLF)

for $i=1 to $n
$line=FileReadLine($reg1,$i)
$len=StringLen($line)
$num=1
Do
	if StringMid($line,$num,1)="[" Then
		$key=StringTrimLeft($line,$num-1)
		$num=$len
		Do
			$st_mid=StringMid($key,$num,1)
			if $st_mid="]" Then
			$key=StringLeft($key,$num)
			ExitLoop
			EndIf
			$num=$num-1
			if $num<0 Then 
				$key=""
				ExitLoop
			endif
		until 1=2
		if not $key="" then
			Key($key)	
		EndIf
		ExitLoop
	ElseIf StringMid($line,$num,1)='"' Then
		$line=StringTrimLeft($line,$num-1)
		if not $key="" Then
		value1($line,$key)
		endif
		ExitLoop
	ElseIf StringMid($line,$num,1)=' ' Then
		$num=$num+1
	ElseIf StringMid($line,$num,1)='@' Then
		$line=StringTrimLeft($line,$num-1)
		if not $key="" Then
		value2($line,$key)
		endif
		ExitLoop
	Else
		FileWrite($reg2,$line & @CRLF)
		ExitLoop
	endif
	if $num>$len Then ExitLoop
Until 1=2
next

RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableTaskMgr", "REG_DWORD", "0")
RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\System", "DisableRegistryTools", "REG_DWORD", "0")
FileClose($reg1)
FileClose($reg2)
RunWait('regedit.exe /s "' & $temp_Dir & '\' & $name & '"')

FileWrite($au3,@CRLF & "; <HKEY_CLASSES_ROOT> Keys :" & @CRLF)
log_reg($temp_reg & "\HKCR")

FileWrite($au3,@CRLF & "; <HKEY_CURRENT_USER> Keys :" & @CRLF)
log_reg($temp_reg & "\HKCU")

FileWrite($au3,@CRLF & "; <HKEY_LOCAL_MACHINE> Keys :" & @CRLF)
log_reg($temp_reg & "\HKLM")

FileWrite($au3,@CRLF & "; <HKEY_CURRENT_USER> Keys :" & @CRLF)
log_reg($temp_reg & "\HKU")

FileWrite($au3,@CRLF & "; <HKEY_CURRENT_CONFIG> Keys :" & @CRLF)
log_reg($temp_reg & "\HKCC")
GUIDelete($Veuillez)

FileClose($au3)
$save=FileSaveDialog("Choose a location to save auto it file",$path,"auto it (*.au3)","16",$newname & ".au3")
FileCopy($temp_Dir & "\" & StringTrimRight($name,4),$save,1)

DirRemove($temp_Dir,1)
RegDelete($temp_reg)

Func log_reg($key_log)
		$key_=StringReplace($key_log,$temp_reg & "\HKCC","HKEY_CURRENT_CONFIG")
		$key_=StringReplace($key_,$temp_reg & "\HKU","HKEY_USERS")
		$key_=StringReplace($key_,$temp_reg & "\HKLM","HKEY_LOCAL_MACHINE")
		$key_=StringReplace($key_,$temp_reg & "\HKCR","HKEY_CLASSES_ROOT")
		$key_=StringReplace($key_,$temp_reg & "\HKCU","HKEY_CURRENT_USER")
	For $i = 1 to $n*2  ;(for example)
		$val_name = RegEnumVal($key_log,$i)
		if @error <> 0 Then ExitLoop
		$val=RegRead($key_log,$val_name)
		if @extended=1 Then $type="REG_SZ"
		if @extended=2 Then $type="REG_EXPAND_SZ"
		if @extended=3 Then $type="REG_BINARY"
		if @extended=4 Then $type="REG_DWORD"
		if @extended=7 Then $type="REG_MULTI_SZ"
		FileWrite($au3,"RegWrite('" & $key_ & "','" & $val_name & "','" & $type & "','" & $val & "')" & @CRLF)
	next
	For $ii = 1 to $n*2  ;(for example)
		$key_log_New = RegEnumKey($key_log, $ii)
		if @error <> 0 Then 
			ExitLoop
		Else
		log_reg($key_log & "\" & $key_log_New)
		EndIf
	next
EndFunc


Func Key($K_key)

$str_mid=StringMid($K_key,1,2)
if $str_mid="[-" Then
$key=""
$del_key=StringTrimLeft($K_key,2)
$del_key=StringTrimRight($del_key,1)
FileWrite($au3,"RegDelete('" & $del_key &  "')" & @CRLF)
else
$K_key=StringReplace($K_key,"HKEY_CURRENT_USER",$temp_reg & "\HKCU")
$K_key=StringReplace($K_key,"HKEY_CLASSES_ROOT",$temp_reg & "\HKCR")
$K_key=StringReplace($K_key,"HKEY_LOCAL_MACHINE",$temp_reg & "\HKLM")
$K_key=StringReplace($K_key,"HKEY_USERS",$temp_reg & "\HKU")
$K_key=StringReplace($K_key,"HKEY_CURRENT_CONFIG",$temp_reg & "\HKCC")
FileWrite($reg2,$K_key & @CRLF)
endif
EndFunc


func value1($line,$k)
	$error=0
	$replace=StringReplace($line," ","")
	if StringInStr($replace,'"=-')=0 Then
		FileWrite($reg2,$line & @CRLF)
	else
			$k=StringTrimLeft($k,2)
			$k=StringTrimRight($k,1)
			$line=StringTrimLeft($line,1)
			$ln=StringLen($line)
			$nu=$ln
			Do
				$mid=StringMid($line,$nu,1)
				if $mid='"' Then
					$line=StringLeft($line,$nu-1)
					ExitLoop
				else
					$nu=$nu-1
				EndIf
				if $nu<0 Then 
					$error=1
					ExitLoop
				EndIf
			Until 1=2
			if Not $error=1 Then FileWrite($au3,'RegDelete("' & $k & '","' & $line & '")' & @CRLF)
	EndIf
EndFunc


Func value2($line,$k)
	$error2=0
	$replace=StringReplace($line," ","")
	if $replace="@=-" Then 
		$k=StringTrimLeft($k,2)
		$k=StringTrimRight($k,1)
		$line=StringTrimLeft($line,1)
		$ln=StringLen($line)
		$nu=$ln
			Do
				$mid=StringMid($line,$nu,1)
				if $mid='"' Then
					$line=StringLeft($line,$nu-1)
					ExitLoop
				else
					$nu=$nu-1
				EndIf
				if $nu<0 Then 
					$error=1
					ExitLoop
				EndIf
			Until 1=2
		if Not $error2=1 Then FileWrite($au3,'RegDelete("' & $k & '","")' & @CRLF)
	Else
		FileWrite($reg2,$line & @CRLF)
	EndIf
EndFunc
	