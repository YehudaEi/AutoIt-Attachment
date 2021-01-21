;XLGetSheetNameEx2.au3
#include"ExcelCom.au3"
local $sDB,$sDBTable,$sHeader,$s_Input1
Dim  $s_FilePath=@ScriptDir&"\Blank6.xls"
; SYNTAX....._GetSheetName( $s_FilePath,$s_i_Sheet=1,$s_i_ExcelValue="Sheet",$s_i_Visible="NotVisible")
$s_SheetName=_GetSheetName($s_FilePath,3,"MyOnlySheet",1)
				MsgBox(0,"","_GetSheetName($s_FilePath,1,'MyOnlySheet',1)="&$s_SheetName)
; SYNTAX....._SheetAdd( $s_FilePath,$s_i_Sheet=1,$s_i_ExcelValue="Sheet",$s_i_Visible="NotVisible")
			 _SheetAdd($s_FilePath,4,"Sheet",1)
$s_SheetName=_GetSheetName($s_FilePath,4,"Sheet",1)
				MsgBox(0,"","_GetSheetName($s_FilePath,4,'Sheet',1)="&$s_SheetName)
; SYNTAX....._NameSheet( $s_FilePath,$s_i_Sheet=1,$s_i_ExcelValue="Sheet",$s_i_Visible="NotVisible")
			 _NameSheet($s_FilePath,4,"MyOnlySheet",1)
; SYNTAX....._XLSheetProperties( $s_FilePath,$s_i_Visible=0)
$XLSheetProps=_XLSheetProperties( $s_FilePath,1)
_Array2dDisplay($XLSheetProps, "Array as read",0)
