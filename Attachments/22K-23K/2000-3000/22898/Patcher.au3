#Include <GUIConstants.Au3>
#Include <Date.Au3>
#Include <IE.Au3>
#Include <File.Au3>
#Include <Unzip.Au3>
#Include <_Settings.Au3>
#NoTrayIcon
Opt ('GUIOnEventMode','1')


$Embedded = _IECreateEmbedded () 

Global $Neuz_Resolution, $Neuz_Shadow, $Neuz_View, $Neuz_Texture, $Neuz_Detail, $Downloaded = ('0')

If FileExists (@DesktopDir & '\Patcher.lnk') = ('0') Then 
FileCreateShortcut (@ScriptDir & '\' & @ScriptName, @DesktopDir & '\Patcher', @ScriptDir)
EndIf  

_Read_Neuz_Settings ()

$Patcher = GUICreate ($Name, '462','594','-1','-1','-1','128')
GUISetOnEvent ($GUI_EVENT_CLOSE, '_Exit')
GUICtrlCreatePic (@ScriptDir & '\Graphics\Other\Patch.bmp','-3','-3','468','600','0x80')
GUICtrlCreateObj ($Embedded, '18','255','425','193')
$Start = GUICtrlCreateButton ('Start','20','460','115','25','0x0080')  
GUICtrlSetImage  ($Start, @ScriptDir & '\Graphics\Buttons\Start.bmp')
GUICtrlSetOnEvent ($Start, '_Patch')
$Register = GUICtrlCreateButton ('Register','175','460','115','25','0x0080')
GUICtrlSetImage  ($Register, @ScriptDir & '\Graphics\Buttons\Register.bmp')
GUICtrlSetOnEvent ($Register, '_Register')
$Options = GUICtrlCreateButton ('Options','328','460','115','25','0x0080')
GUICtrlSetImage  ($Options, @ScriptDir & '\Graphics\Buttons\Options.bmp')
GUICtrlSetOnEvent ($Options, '_Options')
$Download_Track = GUICtrlCreateInput ($Downloaded & ' / ' & $Total_Files,'20','497','425','22','1')
GUICtrlSetFont ('-1', '10','','','Arial')
GUICtrlSetState ('-1', $GUI_DISABLE)
$Current_Download = GUICtrlCreateProgress ('20','527','425','22','0x01')
GUISetState (@SW_SHOW, $Patcher)

$Options = GUICreate ('Options','382','382','-1','-1','-1','128')
GUISetOnEvent ($GUI_EVENT_CLOSE, '_Options')
GUICtrlCreatePic (@ScriptDir & '\Graphics\Other\Options.bmp','0','0','382','382','0x80')
$Ok = GUICtrlCreateButton ('Ok','57','101','115','25','0x0080')
GUICtrlSetImage  ($Ok, @ScriptDir & '\Graphics\Buttons\Ok.bmp')
GUICtrlSetOnEvent ($Ok, '_Save_Neuz_Settings')
$Cancel = GUICtrlCreateButton ('Cancel','57','130','115','25','0x0080')
GUICtrlSetOnEvent ($Cancel, '_Options_Cancel')
GUICtrlSetImage  ($Cancel, @ScriptDir & '\Graphics\Buttons\Cancel.bmp')
Global $Resolution = GUICtrlCreateCombo ($Neuz_Resolution, '118','38','110','20')
GUICtrlSetFont ($Resolution, '10', '','','GungsuhChe')
Global $Shadow = GUICtrlCreateCombo ($Neuz_Shadow, '31','240','123','20')
GUICtrlSetFont ($Shadow, '10', '','','GungsuhChe')
Global $View = GUICtrlCreateCombo ($Neuz_View, '225','242','123','20')
GUICtrlSetFont ($View, '10', '','','GungsuhChe')
Global $Texture = GUICtrlCreateCombo ($Neuz_Texture, '33','328','123','20')
GUICtrlSetFont ($Texture, '10', '','','GungsuhChe')
Global $Detail = GUICtrlCreateCombo ($Neuz_Detail,'225','328','123','20')
GUICtrlSetFont ($Detail, '10', '','','GungsuhChe')
_Set_Neuz_Settings ()
GUISetState (@SW_HIDE, $Options)

_IENavigate ($Embedded, $News_Page)

Func _Register ()
_IENavigate ($Embedded, $Register_Page)
EndFunc

Func _Patch ()
For $Array = '1' To $Total_Files
_Patch_Check ($File[$Array], $Link[$Array], $Type[$Array])
Next
ShellExecute ($Game_Name, $Start_Key, $Game_Drive)
Exit 
EndFunc

Func _Patch_Check ($File, $Link, $Type)
Local $File_Size = FileGetSize ($File), $Link_Size = InetGetSize ($Link)
If FileExists ($File) Then 
If $Link_Size <> $File_Size Then _Download ($Link, $File, $Type)
Else
_Download ($Link, $File, $Type)
EndIf 
EndFunc

Func _Download ($Link, $File, $Type)
Local $File_Size = InetGetSize ($Link)
InetGet ($Link, $File, '','1')
Do 
Sleep ('100')
GUICtrlSetData ($Current_Download, _Get_Download_Percent ($File_Size))
Until @InetGetActive = ('0')
$Downloaded = ($Downloaded + '1')
GUICtrlSetData ($Download_Track, $Downloaded & ' / ' & $Total_Files)
If $Downloaded = $Total_Files Then GUICtrlSetData ($Download_Track, 'Patch Complete')
If $Type = ('Zip') Then _File_UnZip ($File, @ScriptDir)
EndFunc

Func _Get_Download_Percent ($File_Size)
$Decimal = (@InetGetBytesRead / $File_Size)
$Percent = ($Decimal * '100')
Return $Percent
EndFunc

Func _Options ()
Local $State = WinGetState ($Options)
If $State = ('5') Then 
GUISetState (@SW_SHOW, $Options)
Else
GUISetState (@SW_HIDE, $Options)
EndIf 
EndFunc 

Func _Options_Cancel ()
Local $State = WinGetState ($Options)
If $State = ('5') Then 
GUISetState (@SW_SHOW, $Options)
Else
GUISetState (@SW_HIDE, $Options)
EndIf 
_Read_Neuz_Settings ()
GUICtrlDelete ($Resolution)
GUICtrlDelete ($Shadow)
GUICtrlDelete ($View)
GUICtrlDelete ($Texture)
GUICtrlDelete ($Detail)
Global $Resolution = GUICtrlCreateCombo ($Neuz_Resolution, '118','38','110','20')
GUICtrlSetFont ($Resolution, '10', '','','GungsuhChe')
Global $Shadow = GUICtrlCreateCombo ($Neuz_Shadow, '31','240','123','20')
GUICtrlSetFont ($Shadow, '10', '','','GungsuhChe')
Global $View = GUICtrlCreateCombo ($Neuz_View, '225','242','123','20')
GUICtrlSetFont ($View, '10', '','','GungsuhChe')
Global $Texture = GUICtrlCreateCombo ($Neuz_Texture, '33','328','123','20')
GUICtrlSetFont ($Texture, '10', '','','GungsuhChe')
Global $Detail = GUICtrlCreateCombo ($Neuz_Detail,'225','328','123','20')
GUICtrlSetFont ($Detail, '10', '','','GungsuhChe')
_Set_Neuz_Settings ()
GUICtrlSetData ($Resolution, $Neuz_Resolution)
GUICtrlSetData ($Shadow, $Neuz_Shadow)
GUICtrlSetData ($View, $Neuz_View)
GUICtrlSetData ($Texture, $Neuz_Texture)
GUICtrlSetData ($Detail, $Neuz_Detail)
EndFunc

Func _Read_Neuz_Settings ()
If FileExists ('Neuz.ini') Then 
Global $Neuz_Resolution, $Neuz_Shadow, $Neuz_View, $Neuz_Texture, $Neuz_Detail
$String_1 = StringSplit (FileReadLine ('Neuz.ini','4'),' ')
$Neuz_Resolution = ($String_1['2'] & ' x ' & $String_1['3'])
$String_2 = StringSplit (FileReadLine ('Neuz.ini','10'),' ')
If $String_2['2'] = ('0') Then $Neuz_Shadow = ('High')
If $String_2['2'] = ('1') Then $Neuz_Shadow = ('Medium')
If $String_2['2'] = ('2') Then $Neuz_Shadow = ('Low')
$String_3 = StringSplit (FileReadLine ('Neuz.ini','7'),' ')
If $String_3['2'] = ('0') Then $Neuz_View = ('Far')
If $String_3['2'] = ('1') Then $Neuz_View = ('Medium')
If $String_3['2'] = ('2') Then $Neuz_View = ('Near')
$String_4 = StringSplit (FileReadLine ('Neuz.ini','6'),' ')
If $String_4['2'] = ('0') Then $Neuz_Texture = ('High')
If $String_4['2'] = ('1') Then $Neuz_Texture = ('Medium')
If $String_4['2'] = ('2') Then $Neuz_Texture = ('Low')
$String_5 = StringSplit (FileReadLine ('Neuz.ini','8'),' ')
If $String_5['2'] = ('0') Then $Neuz_Detail = ('High')
If $String_5['2'] = ('1') Then $Neuz_Detail = ('Medium')
If $String_5['2'] = ('2') Then $Neuz_Detail = ('Low')
EndIf 
EndFunc

Func _Set_Neuz_Settings ()
If FileExists ('Neuz.ini') Then 
If $Neuz_Resolution = ('800 x 600') Then 
GUICtrlSetData ($Resolution, '1024 x 768')
Else
GUICtrlSetData ($Resolution, '800 x 600')
EndIf 
If $Neuz_Shadow = ('High') Then GUICtrlSetData ($Shadow, 'Medium|Low')
If $Neuz_Shadow = ('Medium') Then GUICtrlSetData ($Shadow, 'High|Low')
If $Neuz_Shadow = ('Low') Then GUICtrlSetData ($Shadow, 'High|Medium')
If $Neuz_View = ('Far') Then GUICtrlSetData ($View, 'Medium|Near')
If $Neuz_View = ('Medium') Then GUICtrlSetData ($View, 'Far|Near')
If $Neuz_View = ('Near') Then GUICtrlSetData ($View, 'Far|Medium')
If $Neuz_Texture = ('High') Then GUICtrlSetData ($Texture, 'Medium|Low')
If $Neuz_Texture = ('Medium') Then GUICtrlSetData ($Texture, 'High|Low')
If $Neuz_Texture = ('Low') Then GUICtrlSetData ($Texture, 'High|Medium')
If $Neuz_Detail = ('High') Then GUICtrlSetData ($Detail, 'Medium|Low')
If $Neuz_Detail = ('Medium') Then GUICtrlSetData ($Detail, 'High|Low')
If $Neuz_Detail = ('Low') Then GUICtrlSetData ($Detail, 'High|Medium')
EndIf 
EndFunc

Func _Save_Neuz_Settings ()
$Read_Resolution = GUICtrlRead ($Resolution)
If $Read_Resolution = $Neuz_Resolution Then 
Else
$String_1 = StringSplit ($Read_Resolution, ' ')
$New_Resolution = ('resolution ' & $String_1['1'] & ' ' & $String_1['3'])
_FileWriteToLine ('Neuz.ini','4', $New_Resolution, '1')
EndIf 
$Read_Shadow = GUICtrlRead ($Shadow) 
If $Read_Shadow = $Neuz_Shadow Then 
Else
If $Read_Shadow = ('High') Then $New_Shadow = ('shadow 0')
If $Read_Shadow = ('Medium') Then $New_Shadow = ('shadow 1')
If $Read_Shadow = ('Low') Then $New_Shadow = ('shadow 2')
_FileWriteToLine ('Neuz.ini','10', $New_Shadow, '1')
EndIf 
$Read_View = GUICtrlRead ($View)
If $Read_View = $Neuz_View Then 
Else
If $Read_View = ('Far') Then $New_View = ('view 0')
If $Read_View = ('Medium') Then $New_View = ('view 1')
If $Read_View = ('Near') Then $New_View = ('view 2')
_FileWriteToLine ('Neuz.ini','7', $New_View, '1')
EndIf 
$Read_Texture = GUICtrlRead ($Texture)
If $Read_Texture = $Neuz_Texture Then 
Else
If $Read_Texture = ('High') Then $New_Texture = ('texture 0')
If $Read_Texture = ('Medium') Then $New_Texture = ('texture 1')
If $Read_Texture = ('Low') Then $New_Texture = ('texture 2')
_FileWriteToLine ('Neuz.ini','6', $New_Texture, '1')
EndIf 
$Read_Detail = GUICtrlRead ($Detail)
If $Read_Detail = $Neuz_Detail Then 
Else
If $Read_Detail = ('High') Then $New_Detail = ('detail 0')
If $Read_Detail = ('Medium') Then $New_Detail = ('detail 1')
If $Read_Detail = ('Low') Then $New_Detail = ('detail 2')
_FileWriteToLine ('Neuz.ini','8', $New_Detail, '1')
EndIf 
_Read_Neuz_Settings ()
GUICtrlDelete ($Resolution)
GUICtrlDelete ($Shadow)
GUICtrlDelete ($View)
GUICtrlDelete ($Texture)
GUICtrlDelete ($Detail)
Global $Resolution = GUICtrlCreateCombo ($Neuz_Resolution, '118','38','110','20')
GUICtrlSetFont ($Resolution, '10', '','','GungsuhChe')
Global $Shadow = GUICtrlCreateCombo ($Neuz_Shadow, '31','240','123','20')
GUICtrlSetFont ($Shadow, '10', '','','GungsuhChe')
Global $View = GUICtrlCreateCombo ($Neuz_View, '225','242','123','20')
GUICtrlSetFont ($View, '10', '','','GungsuhChe')
Global $Texture = GUICtrlCreateCombo ($Neuz_Texture, '33','328','123','20')
GUICtrlSetFont ($Texture, '10', '','','GungsuhChe')
Global $Detail = GUICtrlCreateCombo ($Neuz_Detail,'225','328','123','20')
GUICtrlSetFont ($Detail, '10', '','','GungsuhChe')
_Set_Neuz_Settings ()
GUICtrlSetData ($Resolution, $Neuz_Resolution)
GUICtrlSetData ($Shadow, $Neuz_Shadow)
GUICtrlSetData ($View, $Neuz_View)
GUICtrlSetData ($Texture, $Neuz_Texture)
GUICtrlSetData ($Detail, $Neuz_Detail)
EndFunc 

While ('1')
Sleep ('150')
WEnd

Func _Exit ()
Exit
EndFunc