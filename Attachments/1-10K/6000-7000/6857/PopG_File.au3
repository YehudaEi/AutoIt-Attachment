; PopG_file.au3 - Andy Swarbrick (c) 2005-6
#region		Doc:
#region		Doc: History
; 18-Jan-05 Als Added _FileCompareBinary from autoit forums.
#endregion	Doc: History
#region		Doc: FunctionList
; _DirCopy2						Like DirCopy but uses _FileCopy2 to ensure the update is intelligent.
; _DriveMap						Extends DriveMap functions
; _FileCopy2 					Copies one file to another folder.  Does not copy if file exists.  Sets target date to source.
; _IsDir						Returns True if a directory.
#endregion	Doc: FunctionList
#endregion	Doc:
#region		Init:
#region		Init: Absolute Decls
	Global $ProgIdx							=0
	Global $OldPcnt							=0
	Global $OldTime							=0
	Global Const $CD_CHECKATTRIBS			=1
	Global Const $CD_CHECKDATABINARY		=2
	Global Const $CD_CHECKDATATEXT			=4
	Global Const $CD_CHECKDATECREATEDIFF	=8
	Global Const $CD_CHECKDATECREATENEWER	=16
	Global Const $CD_CHECKDATEMODIFYDIFF	=32
	Global Const $CD_CHECKDATEMODIFYNEWER	=64
	Global Const $CD_CHECKSIZEBIGGER		=128
	Global Const $CD_CHECKSIZEDIFF			=256
	Global Const $CD_SETALLFILES			=1
	Global Const $CD_SETATTRIBS				=2
	Global Const $CD_SETATTRIBSALLFILES		=4
	Global Const $CD_SETCREATEDATE			=8
	Global Const $CD_SETDATEALLFILES		=16
	Global Const $CD_SETMODIFYDATE			=32
#endregion	Init: Absolute Decls
#region		Init: Autoit Options
	Opt('MustDeclareVars',True)
#endregion	Init: Autoit Options
#region		Init: Includes
	#include '..\PopGincl\PopG_MsgBox.au3'
	#include '..\PopGincl\PopG_Run.au3'
	#include '..\PopGincl\PopG_String.au3'
#endregion	Init: Includes
#endregion	Init:
#region		Run:
#region		Run: Test Harness
;~ #region		Run: test _FileCompareBinary
;~ 	; Comparing two files...
;~ 	Local $first = "C:\FirstFile.DAT"
;~ 	Local $Second = "C:\SecondFile.DAT"
;~ 	If Not _FileCompareBinary ($first, $Second) Then
;~ 		Local $ext = @extended
;~ 		Local $error = @error
;~ 		If $error = 1 Then
;~ 			ConsoleWrite("Wrong version of AutoIT (minimum = 3.1.1.77)" & @CR)
;~ 		ElseIf $error = 2 Then
;~ 			ConsoleWrite("At least one of the two files don't exist" & @CR)
;~ 		ElseIf $error = 3 Then
;~ 			ConsoleWrite("Both files are different size" & @CR)
;~ 		ElseIf $error = 4 Then
;~ 			ConsoleWrite("Bad buffer size" & @CR)
;~ 		ElseIf $error = 5 Then
;~ 			ConsoleWrite("Cannot compare complete file (increase BufferSize)" & @CR)
;~ 		ElseIf $error = 6 Then
;~ 			ConsoleWrite("Cannot open file for read" & @CR)
;~ 		ElseIf $error = 7 Then
;~ 			ConsoleWrite("Content doesn't match (compare fail)" & @CR)
;~ 			ConsoleWrite("Mistmatch at byte " & $ext & @CR)
;~ 		Else
;~ 			ConsoleWrite("Internal error, contact function author" & @CR)
;~ 			ConsoleWrite("Error code " & $error & @TAB & "Exteded code " & $ext & @CR)
;~ 		EndIf
;~ 	Else
;~ 		ConsoleWrite("Congratulations, both files identical!" & @CR)
;~ 	EndIf
;~ 	Exit
;~ #endregion	Run: test _FileCompareBinary
#endregion	Run: Test Harness
#region		Run: Functions
; _FileCopy2 					Copies one file to another folder.  Does not copy if file exists.  Sets target date to source.
Func _FileCopy2($SrcFil,$DstFil,$CopyIfNewer=False,$CopyIfBigger=False,$CopyIfDifferent=False,$OkSetTime=False,$CopyAlways=False,$ConfCopy=False,$ProgMax=-1)
	Local $result
	Local $OkCopy=False
	Local $SrcTim,$DstTim,$SrcSiz,$DstSiz,$ProgTxt,$ProgLen,$NewPcnt
	If $ProgMax>=0 Then
		$NewPcnt=Round($ProgIdx/$ProgMax*100,-1)
		If $NewPcnt<>$OldPcnt Then
			$ProgTxt=_StringInsert2($SrcFil,@LF,40)
			ProgressSet($NewPcnt,$ProgIdx&'/'&$ProgMax&'-'&$ProgTxt)
			$OldPcnt=$NewPcnt
		EndIf
		$ProgIdx=$ProgIdx+1
		If $ProgIdx>$ProgMax Then $ProgIdx=0
	EndIf
	$SrcTim='' 
	If $CopyAlways Then
		$OkCopy=True
	Else
		If FileExists($DstFil)Then
			If $CopyIfBigger Or $CopyIfDifferent Then
				$SrcTim=FileGetTime($SrcFil,0,1)	;use modify date
				$DstTim=FileGetTime($DstFil,0,1)
			EndIf
			If $CopyIfNewer Or $CopyIfDifferent Then
				$SrcSiz=FileGetSize($SrcFil)
				$DstSiz=FileGetSize($DstFil)
			EndIf
			;
			If $CopyIfNewer And $SrcTim>$DstTim Then 
				$OkCopy=True
			ElseIf $CopyIfBigger And $SrcSiz>$DstSiz Then 
				$OkCopy=True
			ElseIf $CopyIfDifferent Then
				If $SrcTim<>$DstTim Or $SrcSiz<>$DstSiz Then $OkCopy=True
			EndIf
		Else
			$OkCopy=True
		EndIf
	EndIf
	;
	If $OkCopy Then
		If $ConfCopy Then
			$result=MsgBox($mbfInfo+$mbfYnc+$mbfOnTop,'Confirm Copy','Source='&$SrcFil&@lf&'Target='&$DstFil)
			If $result=$mbaNo		Then $OkCopy=False
			If $result=$mbaCancel	Then Return True
		EndIf
		If $OkCopy Then
			FileCopy($SrcFil,$DstFil,1)
			If $OkSetTime Then 
				;$result=MsgBox($mbfInfo+$mbfYnc+$mbfOnTop,'Time values','Source mod='&$SrcTim&@lf&'Target mod='&$DstTim&@LF&'Source cre='&FileGetTime($SrcFil,1,1)&@lf&'Target mod='&FileGetTime($DstFil,1,1)&@LF)
				;If $result=$mbaCancel	Then Return True
				;If $result=$mbaNo		Then $OkCopy=False
				If $SrcTim='' Then $SrcTim=FileGetTime($SrcFil,0,1)
				If $DstTim='' Then $DstTim=FileGetTime($DstFil,0,1)
				FileSetTime($DstFil,$SrcTim,1)
				FileSetTime($DstFil,FileGetTime($SrcFil,1,1),1)
			EndIf
		EndIf
	EndIf
	;
	Return False
EndFunc ; _FileCopy2
; _DirCopy2						Like DirCopy but uses _FileCopy2 to ensure the update is intelligent.
Func _DirCopy2($SrcDir,$DstDir,$CopyIfNewer=False,$CopyIfBigger=False,$CopyIfDifferent=False,$OkSetTime=False,$CopyAlways=False,$ConfCopy=False,$ProgMax=-1)
	Dim $hdl,$OkCopy,$FilOrDir,$err,$abort
	Local $SrcFoD,$DstFoD,$Attrib
	;If StringRight($SrcDir,1)='\' Then $SrcDir=StringLeft($SrcDir,StringLen($SrcDir)-1)
	$hdl=FileFindFirstFile($SrcDir&'\*')
	If $hdl=-1 Then Return
	$FilOrDir=FileFindNextFile($hdl)
	$err=@error
	While $err<>1
		$DstFoD=$DstDir&'\'&$FilOrDir
		$SrcFoD=$SrcDir&'\'&$FilOrDir
		$Attrib=FileGetAttrib($SrcFoD)
		If StringInStr($Attrib,'D')>0  Then
			If Not FileExists($DstFoD) Then DirCreate($DstFoD)
			If $OkSetTime Then 
				FileSetTime($DstFoD,FileGetTime($SrcFoD,0,1),0)
				FileSetTime($DstFoD,FileGetTime($SrcFoD,1,1),1)
			EndIf
			$abort=_DirCopy2($SrcFoD,$DstFoD,$CopyIfNewer,$CopyIfBigger,$CopyIfDifferent,$OkSetTime,$CopyAlways,$ConfCopy,$ProgMax)
			If $abort Then Return $abort
		Else
			$abort=_FileCopy2($SrcFoD,$DstFoD,$CopyIfNewer,$CopyIfBigger,$CopyIfDifferent,$OkSetTime,$CopyAlways,$ConfCopy,$ProgMax)
			If $abort Then Return $abort
		EndIf
		$FilOrDir=FileFindNextFile($hdl)
		$err=@error
	WEnd
	FileClose($hdl)
EndFunc
; _IsDir						Returns True if a directory.
Func _IsDir($FilOrDir)
	If StringInStr(FileGetAttrib ($FilOrDir),'D') >0 Then Return True
	Return False
EndFunc ;_IsDir
; _DriveMap						Extends DriveMap functions
Func _DriveMap($Drv,$Func,$Dir="")
	If $Func='autoadd' Then
		If StringLeft($Dir,2)='\\' Then 
			$Func='netuseadd'
		Else
			$Func='substadd'
		EndIf
	Else
		$Func=StringLower($Func)
	EndIf
	;
	DriveMapDel($Drv)
	_RunWaitSys('subst.exe /d '&$Drv)
	;
	Select
	Case $Func='substadd'
		_RunWaitSys('subst.exe '&$Drv&' '&$Dir)
	Case $Func='netuseadd'
		DriveMapAdd($Drv,$Dir)
	EndSelect
EndFunc ;_DriveMap
#endregion	Run: Functions
#endregion	Run:
