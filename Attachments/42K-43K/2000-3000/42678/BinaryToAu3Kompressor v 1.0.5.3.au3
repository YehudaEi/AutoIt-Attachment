#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Users\admin\AppData\Local\Temp\BTAK\Win.ico
#AutoIt3Wrapper_Outfile=BinaryToAu3Kompressor.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Description=Convert a file in binary code and Kompress it.
#AutoIt3Wrapper_Res_Fileversion=1.0.5.2
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2013
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GuiComboBoxEx.au3>

If Not _Singleton(@ScriptName,1) Then Exit
OnAutoItExitRegister('_OnAutoItExit')
Opt('GuiOnEventMode',1)
Opt('MustDeclareVars',1)
Opt('TrayMenuMode',1)
Opt('GUICloseOnESC',0)

#Region ------ Global Variables ------------------------------
Global Const $BS_AUTOCHECKBOX=0x0003
Global $sFilePath,$sFileRead,$idInput,$idProg,$hCombo,$idCheckBoxOverWrite,$idCheckBoxLZMA,$idCheckBoxLznt,$idCheckBoxBase64,$idCheckBoxAddFunc
Global $idButtonCreate,$idLabelFilePath,$iCopy,$hGui,$sTempDir=@TempDir&'\BTAK',$sVersion=_ScriptGetVersion()
Global $sSoftTitle='BinaryToAu3Kompressor v'&$sVersion,$iBestResult,$iFlash
Global $aMacros[12]=['@TempDir','@HomeDrive','@ProgramFilesDir','@ProgramsDir','@ScriptDir','@SystemDir','@WindowsDir','@UserProfileDir','@AppDataDir','@DesktopDir','@MyDocumentsDir','@CommonFilesDir']
Global $idlabelFunc[7],$idEditLength[7],$iBinaryLen[7],$idEditRatio[7],$iBinaryLenLzntFunc=817,$iBinaryLenLzmaFunc=48195,$iBinaryLenBase64Func=786
Global $_B64E_CodeBuffer,$_B64E_CodeBufferMemory,$_B64E_Init,$_B64E_EncodeData,$_B64E_EncodeEnd
Global $sRegTitleKey='BinaryToAu3Kompressor'
Global $sRegKeySettings='HKCU'&StringReplace(StringReplace(@OSArch,'x64','64'),'x86','')&'\Software\'&$sRegTitleKey&'\Settings'
Global $LzmaInit=False,$bLzmaDll="",$pLzmaDll=""

#EndRegion --- Global Variables ------------------------------

_Gui()
_TrayMenuSet()
_BalloonTipsEnable()

While 1
	Sleep(30)
WEnd

Func _ArrayMinIndex(Const ByRef $avArray,$iCompNumeric=0,$iStart=0,$iEnd=0)
	If Not IsArray($avArray)Then Return SetError(1,0,-1)
	If UBound($avArray,0)<>1 Then Return SetError(3,0,-1)
	Local $iUBound=UBound($avArray)-1
	If $iEnd<1 Or $iEnd>$iUBound Then $iEnd=$iUBound
	If $iStart<0 Then $iStart=0
	If $iStart>$iEnd Then Return SetError(2,0,-1)
	Local $iMinIndex=$iStart
	If $iCompNumeric Then
		For $i=$iStart To $iEnd
			If Number($avArray[$iMinIndex])>Number($avArray[$i]) Then $iMinIndex=$i
		Next
	Else
		For $i=$iStart To $iEnd
			If $avArray[$iMinIndex]>$avArray[$i] Then $iMinIndex=$i
		Next
	EndIf
	Return $iMinIndex
EndFunc ;==> _ArrayMinIndex()

Func _BalloonTipsEnable() ; Enable Balloon Tips.
	Local $iTips=RegRead('HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced','EnableBalloonTips')
	If @error Or Not $iTips Then
		Local $iWrite=RegWrite('HKCU\Software\Microsoft\WINDOWS\CurrentVersion\Explorer\Advanced','EnableBalloonTips','REG_DWORD',0x00000001)
		Return SetError(@error,0,$iWrite)
	Else
		Return SetError(0,0,$iTips)
	EndIf
EndFunc ;==> _BalloonTipsEnable()

Func _Base64Decode($input_string) ; by trancexx
	Local $struct=DllStructCreate('int')
	Local $a_Call=DllCall('Crypt32.dll','int','CryptStringToBinary','str',$input_string,'int',0,'int',1,'ptr',0,'ptr',DllStructGetPtr($struct,1),'ptr',0,'ptr',0)
	If @error Or Not $a_Call[0] Then Return SetError(1,0,'')
	Local $a=DllStructCreate('byte['&DllStructGetData($struct,1)&']')
	$a_Call=DllCall('Crypt32.dll','int','CryptStringToBinary','str',$input_string,'int',0,'int',1,'ptr',DllStructGetPtr($a),'ptr',DllStructGetPtr($struct,1),'ptr',0,'ptr',0)
	If @error Or Not $a_Call[0] Then Return SetError(2,0,'')
	Return DllStructGetData($a,1)
EndFunc ;==> _Base64Decode()

Func _Base64E_Exit() ; by Ward
	$_B64E_CodeBuffer=0
	_MemVirtualFree($_B64E_CodeBufferMemory,0,$MEM_RELEASE)
EndFunc ;==> _Base64E_Exit()

Func _Base64Encode($Data,$LineBreak=76) ; by Ward
	Local $State=_Base64EncodeInit($LineBreak)
	Return _Base64EncodeData($State,$Data)& _Base64EncodeEnd($State)
EndFunc ;==> _Base64Encode()

Func _Base64EncodeData(ByRef $State,$Data) ; by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Or Not IsDllStruct($State) Then Return SetError(1,0,'')
	$Data=Binary($Data)
	Local $InputLen=BinaryLen($Data)
	Local $Input=DllStructCreate('byte['&$InputLen&']')
	DllStructSetData($Input,1,$Data)
	Local $OputputLen=Ceiling(BinaryLen($Data)*1.4)+3
	Local $Output=DllStructCreate('char['&$OputputLen&']')
	DllCall('user32.dll','int','CallWindowProc','ptr',DllStructGetPtr($_B64E_CodeBuffer)+$_B64E_EncodeData,'ptr',DllStructGetPtr($Input),'uint',$InputLen,'ptr',DllStructGetPtr($Output),'ptr',DllStructGetPtr($State))
	Return DllStructGetData($Output,1)
EndFunc ;==> _Base64EncodeData()

Func _Base64EncodeEnd(ByRef $State) ; by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Or Not IsDllStruct($State) Then Return SetError(1,0,'')
	Local $Output=DllStructCreate('char[5]')
	DllCall('user32.dll','int','CallWindowProc','ptr',DllStructGetPtr($_B64E_CodeBuffer)+$_B64E_EncodeEnd,'ptr',DllStructGetPtr($Output),'ptr',DllStructGetPtr($State),'int',0,'int',0)
	Return DllStructGetData($Output,1)
EndFunc ;==> _Base64EncodeEnd()

Func _Base64EncodeInit($LineBreak=76) ; by Ward
	If Not IsDllStruct($_B64E_CodeBuffer) Then
		If @AutoItX64 Then
			Local $Opcode='0x89C08D42034883EC0885D2C70100000000C64104000F49C2C7410800000000C1F80283E20389410C740683C00189410C4883C408C389C94883EC3848895C242848897424304889CB8B0A83F901742083F9024889D87444C6000A4883C001488B74243029D8488B5C24284883C438C30FB67204E803020000BA3D0000004080FE3F7F08480FBEF60FB614308813C643013D488D4303C643023DEBBC0FB67204E8D7010000BA3D0000004080FE3F7F08480FBEF60FB614308813C643013D488D4302EB9489DB4883EC68418B014863D248895C242848897424304C89C348897C24384C896424484C89CE83F80148896C24404C896C24504C897424584C897C24604C8D2411410FB6790474434D89C64989CD0F82F700000083F8024C89C5747B31C0488B5C2428488B742430488B7C2438488B6C24404C8B6424484C8B6C24504C8B7424584C8B7C24604883C468C34C89C54989CF4D39E70F840B010000450FBE374D8D6F014489F025F0000000C1F80409C7E8040100004080FF3FBA3D0000007F08480FBEFF0FB614384489F78855004883C50183E70FC1E7024D39E50F84B2000000450FB675004983C5014489F025C0000000C1F80609C7E8BD0000004080FF3FBA3D0000007F08480FBEFF0FB61438BF3F0000008855004421F74C8D7502E896000000480FBED70FB604108845018B460883C0013B460C89460875104C8D7503C645020AC7460800000000904D39E5742E410FBE7D004D8D7D01498D6E01E8560000004889FA83E70348C1EA02C1E70483E23F0FB60410418806E913FFFFFF4489F040887E04C7060000000029D8E9CCFEFFFF89E840887E04C7060200000029D8E9B9FEFFFF89E840887E04C7060100000029D8E9A6FEFFFFE8400000004142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F58C3'
		Else
			Local $Opcode='0x89C08B4C24088B44240489CAC1FA1FC1EA1E01CAC1FA0283E103C70000000000C6400400C740080000000089500C740683C20189500CC2100089C983EC0C8B4C2414895C24048B5C2410897424088B1183FA01741D83FA0289D87443C6000A83C0018B74240829D88B5C240483C40CC210000FB67104E80C020000BA3D00000089F180F93F7F0989F20FBEF20FB6143088138D4303C643013DC643023DEBBD0FB67104E8DF010000BA3D00000089F180F93F7F0989F20FBEF20FB6143088138D4302C643013DEB9489DB83EC3C895C242C8B5C244C896C24388B542440897424308B6C2444897C24348B030FB6730401D583F801742D8B4C24488954241C0F820101000083F80289CF747D31C08B5C242C8B7424308B7C24348B6C243883C43CC210008B4C244889D739EF0F84400100008D57010FBE3F89542418894C241489F825F0000000C1F80409C6897C241CE8330100008B542418C644240C3D8B4C241489C789F03C3F7F0B0FBEF00FB604378844240C0FB644240C8D790188018B74241C83E60FC1E60239EA0F84CB0000000FB60A83C2018954241C89C825C0000000C1F80609C6884C2414E8D8000000BA3D0000000FB64C24148944240C89F03C3F7F0B0FBEF08B44240C0FB6143083E13F881789CEE8AD00000089F10FBED18D4F020FB604108847018B430883C0013B430C894308750EC647020A8D4F03C7430800000000396C241C743A8B44241C8B7C241C0FBE30894C241483C701E8650000008B4C241489F283E60381E2FC000000C1EA02C1E6040FB60410880183C101E9E4FEFFFF89F088430489C8C703000000002B442448E9B2FEFFFF89F189F8884B04C703020000002B442448E99CFEFFFF89F088430489C8C703010000002B442448E986FEFFFFE8400000004142434445464748494A4B4C4D4E4F505152535455565758595A6162636465666768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F58C3'
		EndIf
		$_B64E_Init=(StringInStr($Opcode,'89C0')-3) / 2
		$_B64E_EncodeData=(StringInStr($Opcode,'89DB')-3) / 2
		$_B64E_EncodeEnd=(StringInStr($Opcode,'89C9')-3) / 2
		$Opcode=Binary($Opcode)
		$_B64E_CodeBufferMemory=_MemVirtualAlloc(0,BinaryLen($Opcode),$MEM_COMMIT,$PAGE_EXECUTE_READWRITE)
		$_B64E_CodeBuffer=DllStructCreate('byte['&BinaryLen($Opcode)&']',$_B64E_CodeBufferMemory)
		DllStructSetData($_B64E_CodeBuffer,1,$Opcode)
		OnAutoItExitRegister('_Base64E_Exit')
	EndIf
	Local $State=DllStructCreate('byte[16]')
	DllCall('user32.dll','none','CallWindowProc','ptr',DllStructGetPtr($_B64E_CodeBuffer)+$_B64E_Init,'ptr',DllStructGetPtr($State),'uint',$LineBreak,'int',0,'int',0)
	Return $State
EndFunc ;==> _Base64EncodeInit()

Func _BinaryToAu3($sFilePath,$sOutputDirPath='',$iOverWrite=1,$iOpenInScite=1)
	Local $sFileName=StringTrimLeft($sFilePath,StringInStr($sFilePath,'\',1,-1))
	Local $hFile=FileOpen($sFilePath,16)
	If $hFile=-1 Then
		MsgBox(262144+4096+16,'Error',"Can not Access this file.",5)
		Return SetError(1,0,'')
	EndIf
	$sFileRead=FileRead($hFile)
	FileClose($hFile)
	If StringLeft($sOutputDirPath,1)<>'@' Then $sOutputDirPath='"'&$sOutputDirPath
	If StringRight($sOutputDirPath,1)<>'"' Then $sOutputDirPath&='"'
	Local $sString
	Local $iAddFunc=Int(_IsChecked($idCheckBoxAddFunc))
;~  The order of compression type must be like this for avoid CRC Error.
;~ 1-Lznt
	Local $iAddFuncLznt
	If $iOpenInScite=1 Then $iAddFuncLznt=Int(_IsChecked($idCheckBoxLznt))
	If $iOpenInScite=2 Or $iOpenInScite=5 Or $iOpenInScite=6 Then $iAddFuncLznt=1
	If $iAddFuncLznt And $iOpenInScite<>0 Then $sFileRead=_LzntCompress(Binary($sFileRead))
;~ 2-Lzma
	Local $iAddFuncLzma
	If $iOpenInScite=1 Then $iAddFuncLzma=Int(_IsChecked($idCheckBoxLZMA))
	If $iOpenInScite=3 Or $iOpenInScite=5 Or $iOpenInScite=7 Then $iAddFuncLzma=1
	If $iAddFuncLzma And $iOpenInScite<>0 Then $sFileRead=_LzmaEnc(Binary($sFileRead),9) ; 1-9
;~ 3-Base64
	Local $iAddFuncB64
	If $iOpenInScite=1 Then $iAddFuncB64=Int(_IsChecked($idCheckBoxBase64))
	If $iOpenInScite=4 Or $iOpenInScite=6 Or $iOpenInScite=7 Then $iAddFuncB64=1
	If $iAddFuncB64 And $iOpenInScite<>0 Then $sFileRead=_Base64Encode($sFileRead,4000) ; MAX_LINESIZE	4095
	Local $aRet=StringRegExp($sFileRead,'(.{1,4000})',3)
	Local $iUbound=UBound($aRet)
	Local $sFuncName=_FuncGetValidName($sFileName,'[\W]','')
	$sString&='_'&$sFuncName&'("'&$sFileName&'",'&$sOutputDirPath&','&$iOverWrite&')'&@CRLF&@CRLF
	If $iUbound=1 Then
		$sString&='Func _'&$sFuncName&'($sFileName,$sOutputDirPath,$iOverWrite=0)'&@CRLF&'    Local $sFileBin="'&StringStripCR($aRet[0])&'"'&@CRLF
	ElseIf $iUbound>1 Then
		$sString&='Func _'&$sFuncName&'($sFileName,$sOutputDirPath,$iOverWrite=0)'&@CRLF&'    Local $sFileBin="'&StringStripCR($aRet[0])&'"'&@CRLF
		For $i=1 To $iUbound-2
			$sString&='    $sFileBin&="'&StringStripCR($aRet[$i])&'"'&@CRLF
		Next
		$sString&='    $sFileBin&="'&$aRet[$iUbound-1]&'"'&@CRLF
	EndIf
	If $iOpenInScite<>0 Then
		If ($iOpenInScite=1 Or $iOpenInScite=4 Or $iOpenInScite=6 Or $iOpenInScite=7) And $iAddFuncB64 Then $sString&='    $sFileBin=Binary(_Base64Decode($sFileBin))'&@CRLF
		If ($iOpenInScite=1 Or $iOpenInScite=3 Or $iOpenInScite=5 Or $iOpenInScite=7) And $iAddFuncLzma Then $sString&='    $sFileBin=Binary(_LZMADec($sFileBin))'&@CRLF
		If ($iOpenInScite=1 Or $iOpenInScite=2 Or $iOpenInScite=5 Or $iOpenInScite=6) And $iAddFuncLznt Then $sString&='    $sFileBin=Binary(_LzntDecompress($sFileBin))'&@CRLF
	EndIf
	If $iUbound>0 Then
		$sString&='    If Not FileExists($sOutputDirPath) Then DirCreate($sOutputDirPath)'&@CRLF
		$sString&="    If StringRight($sOutputDirPath,1)<>'\' Then $sOutputDirPath&='\'"&@CRLF
		$sString&='    Local $sFilePath=$sOutputDirPath&$sFileName'&@CRLF
		$sString&='    If FileExists($sFilePath) Then'&@CRLF
		$sString&='        If $iOverWrite=1 Then'&@CRLF
		$sString&='            If Not Filedelete($sFilePath) Then Return SetError(2,0,$sFileBin)'&@CRLF
		$sString&='        Else'&@CRLF
		$sString&='            Return SetError(0,0,$sFileBin)'&@CRLF
		$sString&='        EndIf'&@CRLF
		$sString&='    EndIf'&@CRLF
		$sString&='    Local $hFile=FileOpen($sFilePath,16+2)'&@CRLF
		$sString&='    If $hFile=-1 Then Return SetError(3,0,$sFileBin)'&@CRLF
		$sString&='    FileWrite($hFile,$sFileBin)'&@CRLF
		$sString&='    FileClose($hFile)'&@CRLF
		$sString&='    Return SetError(0,0,$sFileBin)'&@CRLF
		$sString&='EndFunc'&@CRLF
	EndIf
	If $iOpenInScite<>0 Then
		If($iOpenInScite=1 Or $iOpenInScite=4 Or $iOpenInScite=6 Or $iOpenInScite=7) And $iAddFunc And $iAddFuncB64 Then $sString&=_StringAddBase64Decode()
		If($iOpenInScite=1 Or $iOpenInScite=3 Or $iOpenInScite=5 Or $iOpenInScite=7) And $iAddFunc And $iAddFuncLzma Then $sString&=_StringAddLzmaDec()
		If($iOpenInScite=1 Or $iOpenInScite=2 Or $iOpenInScite=5 Or $iOpenInScite=6) And $iAddFunc And $iAddFuncLznt Then $sString&=_StringAddLzntDecompress()
	EndIf
	If $iOpenInScite=1 Then
		Local $sScriptFilePath=@TempDir&'\'&$sFuncName&'.au3'
		$sScriptFilePath=_FilePathFindFree($sScriptFilePath)
		FileWrite($sScriptFilePath,$sString)
		Local $sScitePath=@ProgramFilesDir&'\AutoIt3\SciTE\scite.exe'
		If Not FileExists($sScitePath) Then $sScitePath=RegRead('HKLM\SOFTWARE\AutoIt v3\AutoIt','InstallDir')&'\SciTE\scite.exe'
		If Not FileExists($sScitePath) Then
			$sScitePath=RegRead($sRegKeySettings,'SciTEPath')
			If @error Or Not FileExists($sScitePath) Then
				$sScitePath=FileOpenDialog('SciTE Path',@ProgramFilesDir,'(*.exe)',1+2,'SciTE.exe',_OnTop())
				If StringRight($sScitePath,9)<>'SciTE.exe' Then
					$sScitePath=''
				Else
					RegWrite($sRegKeySettings,'SciTEPath','REG_SZ',$sScitePath)
				EndIf
			EndIf
		EndIf
		If FileExists($sScitePath) Then
			If $iCopy=0 Then
				Run($sScitePath&' "'&$sScriptFilePath&'"')
			Else
				ClipPut($sString)
				_TrayTip($sSoftTitle,'Script was Copied to the Clipboard!',1,3000)
			EndIf
		Else
			MsgBox(262144+4096+16,'Error',"SciTE Editor was not found.",5)
			ClipPut($sString)
			_TrayTip($sSoftTitle,'Script was Copied to the Clipboard!',1,3000)
		EndIf
	Else
		Return StringLen($sString)
	EndIf
EndFunc ;==> _BinaryToAu3()

Func _Exit()
	If $LzmaInit=True Then MemoryDllClose($pLzmaDll)
	Exit
EndFunc ;==> _Exit()

Func _FilePathFindFree($sPath)
	Local $i,$sNewPath
	Do
		$sNewPath=_FilePathInsertBetweenNameAndExt($sPath,$i)
		$i+=1
	Until Not FileExists($sNewPath)
	Return $sNewPath
EndFunc ;==> _FilePathFindFree()

Func _FilePathInsertBetweenNameAndExt($sPath,$sStringToInsert)
	Local $szDrive,$szDir,$szFName,$szExt,$TestPath
	$TestPath=_PathSplit($sPath,$szDrive,$szDir,$szFName,$szExt)
	Return $szDrive&$szDir&$szFName&$sStringToInsert&$szExt
EndFunc ;==> _FilePathInsertBetweenNameAndExt()

Func _FuncGetValidName($sString,$sPatern='[*?\\/|):<>"]',$sReplace='_')
	If StringStripWS($sString,8)='' Then Return $sString
	$sString=StringRegExpReplace($sString,$sPatern,$sReplace)
	Return _StringProper(StringStripWS($sString,7))
EndFunc ;==> _FuncGetValidName()

Func _GetDroppedItem()
	$sFilePath=@GUI_DRAGFILE
	If _IsDirectory($sFilePath) Then
		$sFilePath=''
		MsgBox(262144+4096+16,'Error',"It's Not a File !",4)
	Else
		_TrayTip($sSoftTitle,$sFilePath&' has been drag&drop on the Gui !',1,3000)
		_ScriptEvaluateFuturSize($sFilePath)
	EndIf
EndFunc ;==> _GetDroppedItem()

Func _GetInput()
	If _IsPressed('10') Then ; Left Shift key
		$iCopy=1
	Else
		$iCopy=0
	EndIf
	Local $sInputRead=StringReplace(GUICtrlRead($idInput),'"','')
	If $sInputRead='FolderName' Then $sInputRead=''
	Local $sComboSel=_GUICtrlComboBoxEx_GetCurSel($hCombo)
	If $sComboSel<>-1 Then
		If $sComboSel='' Then
			$sComboSel='@TempDir'
		Else
			$sComboSel=$aMacros[$sComboSel]
		EndIf
	Else
		_GUICtrlComboBoxEx_GetEditControl($hCombo)
		Return
	EndIf
	Local $sOutputDirPath=$sComboSel&'&"\'&$sInputRead&'"'
	Local $iOverWrite=GUICtrlRead($idCheckBoxOverWrite)
	If $iOverWrite=4 Then $iOverWrite=0
	If $sFilePath Then _BinaryToAu3($sFilePath,$sOutputDirPath,$iOverWrite)
EndFunc ;==> _GetInput()

Func _Gui()
	Local $sGuiHeight=560
	$hGui=GUICreate($sSoftTitle,320,$sGuiHeight,10,-1,-1,BitOR(0x00000010,0x00000008)) ; $WS_EX_ACCEPTFILES,$WS_EX_TOPMOST
	If Not FileExists($sTempDir&'\Win.ico') Then _Winico('Win.ico',$sTempDir)
	GUISetIcon($sTempDir&'\Win.ico')
	GUISetFont(9,800)
	GUISetOnEvent(-3,'_Exit') ; $GUI_EVENT_CLOSE
	GUISetOnEvent(-13,'_GetDroppedItem') ; $GUI_EVENT_DROPPED
	If Not FileExists($sTempDir) Then DirCreate($sTempDir)
	Local $sPicPath=$sTempDir&'\Convert.jpg'
	If Not FileExists($sPicPath) Then _SetJpgFile('Convert.jpg',$sTempDir)
	$idLabelFilePath=GUICtrlCreateLabel("Drag'n drop a file on the pic for test all compressions",10,$sGuiHeight -400,300,20,0x01) ; $SS_CENTER
	GUICtrlSetColor(-1,0x0000FF)
	GUICtrlCreateLabel('Compression Type',10,$sGuiHeight -370,110,20)
	GUICtrlCreateLabel('Script Size',160,$sGuiHeight -370,80,20) ; Script Binary Length.
	GUICtrlSetColor(-1,0xFF0000)
	GUICtrlCreateLabel('Ratio %',260,$sGuiHeight -370,50,20,0x01) ; $SS_CENTER
	Local $aTextLabels[7]=[ 'None','Lznt','Lzma','Base64','Lznt+Lzma','Lznt+Base64','Lzma+Base64' ]
	For $i=0 To UBound($aTextLabels) -1
		GUICtrlCreateLabel($aTextLabels[$i],10,$sGuiHeight -345+$i*22,100,20)
		GUICtrlSetFont(-1,8,600)
		If $i Then
			$idlabelFunc[$i]=GUICtrlCreateLabel('+ Func',115,$sGuiHeight -345+$i*22,40,20,0x01) ; $SS_CENTER
			GUICtrlSetColor(-1,0xFF0000)
			GUICtrlSetFont(-1,8,600)
		EndIf
		$idEditLength[$i]=GUICtrlCreateEdit('',160,$sGuiHeight -346+$i*22,90,18,BitOR(2048,2)) ; $ES_READONLY,$ES_RIGHT
		GUICtrlSetBkColor(-1,0xFFFFFF)
		GUICtrlSetFont(-1,8,600)
		If $i Then
			$idEditRatio[$i]=GUICtrlCreateEdit('',260,$sGuiHeight -345+$i*22,50,18,2048) ; $ES_READONLY
			GUICtrlSetBkColor(-1,0xFFFFFF)
			GUICtrlSetColor(-1,0xFF0000)
			GUICtrlSetFont(-1,8,600)
		EndIf
	Next
	GUICtrlCreateGroup('Compression',10,$sGuiHeight-190,300,50)
	$idCheckBoxLznt=GUICtrlCreateCheckbox(' Lznt',30,$sGuiHeight-173,-1,-1,$BS_AUTOCHECKBOX)
	$idCheckBoxLzma=GUICtrlCreateCheckbox(' Lzma',120,$sGuiHeight-173,-1,-1,$BS_AUTOCHECKBOX)
	$idCheckBoxBase64=GUICtrlCreateCheckbox(' Base64',215,$sGuiHeight-173,-1,-1,$BS_AUTOCHECKBOX)
	GUICtrlCreateGroup('Settings',10,$sGuiHeight-140,300,50)
	$idCheckBoxAddFunc=GUICtrlCreateCheckbox(' Include Decompress Func',30,$sGuiHeight-123,-1,-1,$BS_AUTOCHECKBOX)
	GUICtrlSetOnEvent(-1,'_GuiCtrlSetDatas')
	GUICtrlSetState($idCheckBoxAddFunc,1) ; $GUI_CHECKED
	$idCheckBoxOverWrite=GUICtrlCreateCheckbox(' OverWrite',215,$sGuiHeight-123,-1,-1,$BS_AUTOCHECKBOX)
	GUICtrlCreateLabel('Choose an Output Path',10,$sGuiHeight-85,300,20,0x01) ; $SS_CENTER
	GUICtrlSetFont(-1,11,600)
	GUICtrlSetColor(-1,0xFF0000)
	GUICtrlSetTip(-1,'Choose Directory'&@Crlf&'where embedded file'&@Crlf&'will be extracted',' ',1,1)
	$hCombo=_GUICtrlComboBoxEx_Create($hGui,'',5,$sGuiHeight-64,150,200)
	_GUICtrlComboBoxEx_BeginUpdate($hCombo)
	For $i=0 To UBound($aMacros) -1
		_GUICtrlComboBoxEx_AddString($hCombo,$aMacros[$i]&'&"\')
	Next
	_GUICtrlComboBoxEx_EndUpdate($hCombo)
	_GUICtrlComboBoxEx_SetCurSel($hCombo,'@TempDir')
	$idInput=GUICtrlCreateInput('FolderName"',171,$sGuiHeight-64,142,22)
	GUICtrlCreatePic($sPicPath,0,0,320,150)
	GUICtrlSetState(-1,8) ; $GUI_DROPACCEPTED
	GUICtrlSetTip(-1,'Drag a File here'&@Crlf&'Check wanted Compression'&@Crlf& _
		'Select an output directory'&@Crlf&'and Click on Create button',' ',1,1)
	$idButtonCreate=GUICtrlCreateButton('Create au3 Script ',5,$sGuiHeight-35,310,30)
	GUICtrlSetOnEvent(-1,'_GetInput')
	GUICtrlSetTip(-1,'Click here'&@Crlf&'for create script and open it in SciTE Editor'&@CRLF& _
		'Or'&@Crlf&'Hold Left Shift Key and Click for copy script to the Clipboard.',' ',1,1)
	$idProg=GUICtrlCreateProgress(5,$sGuiHeight-35,310,30,0x01) ; $PBS_SMOOTH
	GUICtrlSetState(-1,32) ; $GUI_HIDE
	GUICtrlSetState($idInput,256) ; $GUI_FOCUS
	GUISetState()
EndFunc ;==> _Gui()

Func _GuiAutoCheckBestResult($iIndex)
	GUICtrlSetState($idCheckBoxLznt,1+3*(StringInStr('0236',$iIndex)<>0)) ; $GUI_CHECKED / $GUI_UNCHECKED
	GUICtrlSetState($idCheckBoxLzma,1+3*(StringInStr('0135',$iIndex)<>0))
	GUICtrlSetState($idCheckBoxBase64,1+3*(StringInStr('0124',$iIndex)<>0))
EndFunc ;==> _GuiAutoCheckBestResult()

Func _GuiBestResultEditFlash()
	$iFlash=Not $iFlash
	If $iFlash Then
		GUICtrlSetColor($idEditLength[$iBestResult],0xFF0000)
	Else
		GUICtrlSetColor($idEditLength[$iBestResult],0xFFFFFF)
	EndIf
EndFunc ;==> _GuiBestResultEditFlash()

Func _GuiCtrlSetDatas()
	AdlibUnRegister('_GuiBestResultEditFlash')
	Local $iAddFunc=Int(_IsChecked($idCheckBoxAddFunc))
	Local $iState
	If $iAddFunc Then
		$iState=16 ; $GUI_SHOW
	Else
		$iAddFunc=-1
		$iState=32 ; $GUI_HIDE
	EndIf
	Local $j,$iRatio
	For $i=0 To UBound($idEditLength)-1
		If $i Then GUICtrlSetState($idlabelFunc[$i],$iState)
		$j=GUICtrlRead($idEditLength[$i])
		If $j Then
			Switch $i
				Case 1
					$j+=$iBinaryLenLzntFunc*$iAddFunc
				Case 2
					$j+=$iBinaryLenLzmaFunc*$iAddFunc
				Case 3
					$j+=$iBinaryLenBase64Func*$iAddFunc
				Case 4
					$j+=($iBinaryLenLzntFunc+$iBinaryLenLzmaFunc)*$iAddFunc
				Case 5
					$j+=($iBinaryLenLzntFunc+$iBinaryLenBase64Func)*$iAddFunc
				Case 6
					$j+=($iBinaryLenLzmaFunc+$iBinaryLenBase64Func)*$iAddFunc
			EndSwitch
			$iBinaryLen[$i]=$j
		EndIf
		GUICtrlSetData($idEditLength[$i],$j)
		GUICtrlSetColor($idEditLength[$i],0x0000FF)
		If $i And $j Then
			$iRatio=Round($iBinaryLen[$i]/$iBinaryLen[0],4)*100
			If $iRatio>100 Then $iRatio='> 100'
			GUICtrlSetData($idEditRatio[$i],$iRatio)
		EndIf
	Next
	If Not $j Then Return
	Local $iIndex=_ArrayMinIndex($iBinaryLen,1,0)
	$iBestResult=$iIndex
	_GuiAutoCheckBestResult($iBestResult)
;~  Flash best compression.
	GUICtrlSetColor($idEditLength[$iIndex],0xFF0000)
	$iFlash=True
	AdlibRegister('_GuiBestResultEditFlash',1000)
EndFunc ;==> _GuiCtrlSetDatas()

Func _IsChecked($idCtrl)
	Return BitAND(GUICtrlRead($idCtrl),1)=1 ; $GUI_CHECKED
EndFunc ;==> _IsChecked()

Func _IsDirectory($sFilePath)
	If StringInStr(FileGetAttrib($sFilePath),'D') Then Return 1
EndFunc ;==> _IsDirectory()

Func _IsPressed($sHexKey,$vDLL='user32.dll')
	Local $a_R=DllCall($vDLL,'short','GetAsyncKeyState','int','0x'&$sHexKey)
	If @error Then Return SetError(@error,@extended,False)
	Return BitAND($a_R[0],0x8000)<>0
EndFunc ;==> _IsPressed()

Func MemoryDllOpen($DllBinary)
	Local $Call=__MemoryDllCore(0,$DllBinary)
	Return SetError(@error,0,$Call)
EndFunc   ;==>MemoryDllOpen

Func MemoryDllGetFuncAddress($hModule,$sFuncName)
	Local $Call=__MemoryDllCore(1,$hModule,$sFuncName)
	Return SetError(@error,0,$Call)
EndFunc   ;==>MemoryDllGetFuncAddress

Func MemoryDllClose($hModule)
	__MemoryDllCore(2,$hModule)
	Return SetError(@error)
EndFunc   ;==>MemoryDllClose

Func __MemoryDllCore($iCall,ByRef $Mod_Bin,$sFuncName=0)
	Local Static $_MDCodeBuffer,$_MDLoadLibrary,$_MDGetFuncAddress,$_MDFreeLibrary,$GetProcAddress,$LoadLibraryA,$fDllInit=False
	If Not $fDllInit Then
		If @AutoItX64 Then Exit(MsgBox(16,'Error-x64','x64 Not Supported! '&@LF&@LF&'Download newest version for x64 support'))
		Local $Opcode='0xFFFFFFFFFFFFFFFFB800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE05589E55156578B7D088B750C8B4D10FCF3A45F5E595DC35589E5578B7D088A450C8B4D10F3AA5F5DC359585A5153E8000000005B81EBAB114000898300114000899304114000E8000000005981E9C3114000518B9100114000E80B0000007573657233322E646C6C005850FFD2598B9104114000E80C0000004D657373616765426F784100595150FFD2898372114000E8000000005981E90D124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80A0000006C737472636D70694100595150FFD2898309114000E8000000005981E957124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D0000005669727475616C416C6C6F6300595150FFD2898310114000E8000000005981E9A4124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C0000005669727475616C4672656500595150FFD2898317114000E8000000005981E9F0124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F0000005669727475616C50726F7465637400595150FFD289831E114000E8000000005981E93F134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80E00000052746C5A65726F4D656D6F727900595150FFD2898325114000E8000000005981E98D134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D0000004C6F61644C6962726172794100595150FFD289832C114000E8000000005981E9DA134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F00000047657450726F634164647265737300595150FFD2898333114000E8000000005981E929144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D00000049734261645265616450747200595150FFD289833A114000E8000000005981E976144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F00000047657450726F636573734865617000595150FFD2898341114000E8000000005981E9C5144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80A00000048656170416C6C6F6300'
		$Opcode&='595150FFD2898348114000E8000000005981E90F154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E809000000486561704672656500595150FFD289834F114000E8000000005981E958154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C000000476C6F62616C416C6C6F6300595150FFD2898356114000E8000000005981E9A4154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80E000000476C6F62616C5265416C6C6F6300595150FFD2898364114000E8000000005981E9F2154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80B000000476C6F62616C4672656500595150FFD289835D114000E8000000005981E93D164000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C000000467265654C69627261727900595150FFD289836B1140005B59585150E80E04000059C35990585A515250E8CC0500005A5AC35A585250E88E06000059C35589E557565383EC1C8B45108B40048945EC8B55108B020FB750148D740218C745F00000000066837806000F84B0000000837E1000754C8B450C8B583885DB0F8E84000000C744240C04000000C744240800100000895C24048B45EC03460C890424E8FEF9FFFF83EC10894608895C2408C744240400000000890424E864FAFFFFEB46C744240C04000000C7442408001000008B4610894424048B45EC03460C890424E8BDF9FFFF83EC1089C78B55080356148B46108944240889542404893C24E808FAFFFF897E08FF45F083C6288B55108B020FB740063B45F00F8F50FFFFFF8D65F45B5E5F5DC35589E557565383EC1C8B55088B020FB750148D5C0218BF0000000066837806000F84E80000008B432489C2C1EA1D89D683E60189C2C1EA1E83E20189C1C1E91FA9000000027422C7442408004000008B4310894424048B4308890424E822F9FFFF83EC0CE99000000085F6741E85D2740D83F90119D283E2E083C240EB2983F90119D283E29083EA80EB1C85D2740D83F90119D283E2FE83C204EB0B83F90119D283E2F983C208F6432704740681CA000200008B4B1085C97522F6432440740A8B4D088B018B4820EB0EF643248074088B4D088B018B482485C9741D8D45F08944240C89542408894C24048B4308890424E894F8FFFF83EC104783C3288B55088B020FB7400639F80F8F18FFFFFF8D65F45B5E5F5DC35589E557565383EC048B45088B50048955F08B0083B8A400000000745789D30398A0000000833B00744A8B7DF0033B8D4B08BE000000008B430483E808D1E883F80076280FB70189C2C1EA0C25FF0F000083FA037506'
		$Opcode&='8B550C0114074683C1028B430483E808D1E839F077D8035B04833B0075B683C4045B5E5F5DC35589E557565383EC1CC745F0010000008B45088B40048945EC8B55088B0283B884000000000F84410100008B7DEC03B880000000E9120100008B45EC03470C890424E8BFF7FFFF83EC048945E883F8FF750CC745F000000000E90E0100008B4D0883790800742EC7442408400000008B410C8D048504000000894424048B4108890424E8B6F7FFFF83EC0C8B550889420885C075268B4D088B410C8D04850400000089442404C7042440000000E87EF7FFFF83EC088B55088942088B4D088B510C8B41088B4DE8890C908B4508FF400C833F0074168B5DEC031F8B75EC037710EB11C745F000000000EB578B5DEC035F1089DE833B00744A833B0079190FB703894424048B55E8891424E8FEF6FFFF83EC088906EB1C8B45EC030383C002894424048B4DE8890C24E8E0F6FFFF83EC088906833E0074AB83C30483C604833B0075B6837DF000742483C714C744240414000000893C24E8B9F6FFFF83EC0885C0750A837F0C000F85CDFEFFFF8B45F08D65F45B5E5F5DC35589E557565383EC1C8B45088945F0B8000000008B550866813A4D5A0F85A20100008B75088B45F003703CB800000000813E504500000F8588010000C744240C04000000C7442408002000008B4650894424048B4634890424E815F6FFFF83EC1089C785C07535C744240C04000000C7442408002000008B465089442404C7042400000000E8E9F5FFFF83EC1089C7B80000000085FF0F8428010000E803F6FFFFC744240814000000C744240400000000890424E8F2F5FFFF83EC0C89C3897804C7400C00000000C7400800000000C7401000000000C744240C04000000C7442408001000008B465089442404893C24E87EF5FFFF83EC10C744240C04000000C7442408001000008B465489442404893C24E85CF5FFFF83EC108945EC8B55F08B423C03465489442408895424048B45EC890424E8A3F5FFFF8B45EC8B55F003423C8903897834895C2408897424048B4508890424E8B4FAFFFF89F82B4634740C89442404891C24E8A0FCFFFF891C24E814FDFFFF85C0743E891C24E876FBFFFF8B0383782800742A89FA0350287427C744240800000000C744240401000000893C24FFD283EC0C85C0740BC743100100000089D8EB0D891C24E8DB000000B8000000008D65F45B5E5F5DC35589E583EC28895DF48975F8897DFC8B45088B50048955F0C745ECFFFFFFFF8B1083C278B800000000837A04000F848E0000008B5DF0031A837B18007406837B1400750FB800000000EB760FB73F897DECEB458B75F00373208B7DF0037B24C745E800000000837B1800762C8B45F00306894424048B450C890424E820F4FFFF83EC0885C074C4FF45E883C60483C7028B55E839531877'
		$Opcode&='D4B800000000837DECFF741EB8000000008B55EC3B531477118B45ECC1E00203431C8B55F003141089D08B5DF48B75F88B7DFC89EC5DC35589E5565383EC108B750885F60F84AC000000837E1000742A8B068B56048B48288D040AC744240800000000C744240400000000891424FFD083EC0CC7461000000000837E08007436BB00000000837E0C007E1D8B4608833C98FF740E8B0498890424E8CCF3FFFF83EC0443395E0C7FE38B4608890424E8AAF3FFFF83EC04837E0400741EC744240800800000C7442404000000008B4604890424E840F3FFFF83EC0CE862F3FFFF89742408C744240400000000890424E85CF3FFFF83EC0C8D65F85B5E5DC3'
		$_MDCodeBuffer=DllStructCreate("byte["&BinaryLen($Opcode)&"]")
		DllCall("kernel32.dll","bool","VirtualProtect","struct*",$_MDCodeBuffer,"dword_ptr",DllStructGetSize($_MDCodeBuffer),"dword",0x00000040,"dword*",0) ; PAGE_EXECUTE_READWRITE
		DllStructSetData($_MDCodeBuffer,1,$Opcode)
		Local $pMDCodeBuffer=DllStructGetPtr($_MDCodeBuffer)
		$_MDLoadLibrary=$pMDCodeBuffer+(StringInStr($Opcode,"59585A51")-1) / 2-1
		$_MDGetFuncAddress=$pMDCodeBuffer+(StringInStr($Opcode,"5990585A51")-1) / 2-1
		$_MDFreeLibrary=$pMDCodeBuffer+(StringInStr($Opcode,"5A585250")-1) / 2-1
		Local $Ret=DllCall("kernel32.dll","hwnd","LoadLibraryA","str","kernel32.dll")
		$GetProcAddress=DllCall("kernel32.dll","uint","GetProcAddress","hwnd",$Ret[0],"str","GetProcAddress")
		$LoadLibraryA=DllCall("kernel32.dll","uint","GetProcAddress","hwnd",$Ret[0],"str","LoadLibraryA")
		$fDllInit=True
	EndIf
	Switch $iCall
		Case 0; DllOpen
			Local $DllBuffer=DllStructCreate("byte["&BinaryLen($Mod_Bin)&"]")
			DllCall("kernel32.dll","bool","VirtualProtect","struct*",$DllBuffer,"dword_ptr",DllStructGetSize($DllBuffer),"dword",0x00000040,"dword*",0) ; PAGE_EXECUTE_READWRITE
			DllStructSetData($DllBuffer,1,$Mod_Bin)
			Local $Module=DllCallAddress('uint',$_MDLoadLibrary,"uint",$LoadLibraryA[0],"uint",$GetProcAddress[0],"struct*",$DllBuffer)
			If $Module[0]=0 Then Return SetError(1,0,0)
			Return $Module[0]
		Case 1; MemoryDllGetFuncAddress
			Local $Address=DllCallAddress("uint",$_MDGetFuncAddress,"uint",$Mod_Bin,"str",$sFuncName)
			If $Address[0]=0 Then Return SetError(1,0,0)
			Return $Address[0]
		Case 2; DllClose
			Return DllCallAddress('none',$_MDFreeLibrary,"uint",$Mod_Bin)
	EndSwitch
EndFunc   ;==>__MemoryDllCore

Func _LzmaInit()
	If Not $LzmaInit=True Then
		$bLzmaDll="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"
		$bLzmaDll&="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"
		$bLzmaDll&="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"
		$bLzmaDll&="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"
		$bLzmaDll&="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"
		$bLzmaDll&="d1tmCNP2LNSAA7QGPAHeYisqwIgIlojIwLatfdcNHdEAyCjDBuIGJpXiBjB5ASiJwvold4N0wOp2Y0YIiNDAXLR1m6HQKHPBDgT+hIYj2Oy5hrofrNMFsa8Y2akeQkTxizKMeG00cQHxeUsrsOVIw38phAU5c1R0J4l8ERygHWE7PCR4NlYXiRyVAj6kHxB0AuXIlUXQVtDfKDNCcPKNXehEPxxJCJq+V6x5CjvXQyIeoW1lbCLhTHRU464Gitk0t2zOo+4F9Awz6LEyJBS/OG8Cu4yg2GgUdbUGEsX0/yrQZM7feXbif2N/wRm0JwpeKHQZifobZLtmcI9MJSsEIB0piZGRZyuh2NzgEYadkeT0YUwgHKSTNLjrZn6fcu97fIHsuGK5FK+fiIZEZ3LCPq0MxYtYmYmSW6xC8dkTBnY1ARic7QTwKI2sD4ghn40Bvxz9GIkUhaSg5mXcEE+ziHayPQiJTfYhAQ/WRaAiPIk+HTBJQNcgEAwhCJb1jgWbjYU68r7pBLRVabskgzoDdJYl+7rEnMsCo46/M/c6WtiJj4y71uvNwJ27sJAAiy23AzPAtY3iTX9oPP8VIxARe2QnEHzDH4tM/YnI0JqM1AVa/Yu1dlFSAwE0GhxQiQHsyTrYe2gsDcNfav9QISddYXYUww92XwZQjC27fC6MBMOPE8zWPdCaE/kGghJEbcJfdxg7ByA8XsOpmoYOLGsJz4+p2E1EaxSWKcBQUZ/JIFs3HBoEnwIEW767LV5MGGoBURn8DE3bfYMtvwCRaTQIwy83OUouAFzvtmRsbAhRgSDsTC/CCplsHyQlxdxISB8P71kCOcxz6ChPZOy/dwwfM1CLAlFQeQC/95atL+/T72oc2fkcIAFqTK9LwMZHVYvsDmgWgI/0h3cEl3BkocFQZIklh+wIU0kUC/FWV4llG/x8FB65s58sEJbVjX+2UjMsDV9eW4vl1sVeLBimMyIPgEGylCWvz42YQcdMVAbC0IglBwbcMGEQjTFvXbJ/ozi0KaYMXbSvijARK4RNwTZQ9P4pyD+kKYUVLNtQCAIEDM+6reOyjzjZYIloBlm2v24NND9TBD8DKdEJMFPbaAtQQ/zQUP8Wm4t4Rfh0OV0RNIRjEwrX+BmvOR/m2tZtbfjXHjMMLkIVB36JrR7BCDtDRHa0z4Qj1WbV4kLr8Q8niBMxLxSi7tXaU0BkOYJ60HvbyS83QzByCkCMFrGd7GwDR2bvSjDyPClHbws3Cj07QkTuBOFrs5f/HxvcDRXBGdwOOSFzBl9dAC0BfjBrrM+ebBGebcdGhgYgLCAjtwNEsBtIBEwcgXgnVAbP2rlAScBAFf/+/wKwduJkSvfSgeIgg7jtMcJJeeuWpYAXM55sQ9MAzi9SQifVH+/iIDmQICAItC9ceQN0uPbwhMBskV3tbTwZiywB6GeA5hyQjx28jxzJ04GG0BhjN8RSgX94+dHpEoAjwwNtDy+YFG9FQZTtrfDFjYwIegjeXWitiDijjAHyG1NEjTTCryMavUzXDUFzPMgt1or4SI13AbY/veBLxZFc+QJtdDKNV2yDXL0rR7gCBu735eQECNHqgco3gfqD6e7+lgELUVMoQj12B4FJBKFJ8+wDCwABBBil1hyBngl8e7EtUKl7j/1gOGC4EbShuQRzUAYCAUCr2LrXZKsC9QSOmjonVfHcwQGa6nHykccW8R7Btz2NDLW1g+C7Ad3IpjnalgCKIFso5pa4WVs2O4JTFAGaaySTJG8Jm8oF1sltzabZDz2IF3c8dBxb6B0Mh4YirxABbq8jfIkkf8b+ALHsl8XQbWwxyVuCu8LvX/p0ByNhblG6N9kp5s8JjkzCEjAujIr/DCEoFsBFrZkE6K025b9P8/dbwjnaBN14qafTi3kOQUREt0EsTfLNC+IJTbZhI6ECIB0cItqWwAyOEPkeeMKdYWBei1bjZnpIxaMfAUtg4TKWOnMasSDfxzDUhUhU0UB380jRdpjGIwloHPBric44rRg5QwTauSKeMKxaHtdvjMQJ0cjvHxADiXYvhVM58nVzHS9Pt839BJE52HcOlQhCH3Lvbil5qHC/2A3r8Jb/GNpY2tHUg3htdEBGbb9dzi1GXgQrOUZEdC8MGD1yPLQHFF/4T5+W1VmajvsUVo8mUMwWYXL+gY61RRvC67z/WFiLVmDwsxYWfGR6S+aB4wD8XlYv2fdGIHBstGuMJdSD7FBwwCzrsZ8BaCwirwjhcNgADV48ggWidtRfSU4p+YKEkN5TXOqsTeaDhygMKd1eYAmPyw+NFIcYFHbMBrvWQRiTDIs6MySPXUaKTCR1tw4COAP3DXbGda0YE19FJQIiHrW3/wZCO1Xwde45MHOJiQRTbrR2qDkHOwFB/6M5+o8m8IPCBDlzEO4LFtBzYf8gwU+QCYY1n1VFDehD2XJPgIJW/Om3bdGNWASeoI2Y0HsGcyR/4w0a03Xf84N9/XRuO10gc/tWcKZpRcu6DByNPMLY7pprsE0gGwkHV+Qp2Rx1i9io6OB2A0t3pl4iF7YMMpvHMjjBbeuo23RlA3NJx3VjT2zl3K7cTeziB38EZ23IuZMtuAxtdZIk1LINEswHxyjRFNa192APYTGyfQI2bKr2M4sHuftybCsIdMILrR06eYg9CnRFN4WlyvYsc1EuLEtDLODWue0Wg8Z8BgQoiRJ0SfF1u4ZAXaQMAjUaRL+/3XPOv7dAR0R1u1Z1655tEHZKcrWfXTV1GsIELfYjNYTIVt/W0KGPR2IBE/2vUTwrBk9NEB5MkONZI6x6UGpRwVA3ihMbBmOMutxhTwYp8ceOhVbFfmpgc2VZjgUcy1XIVG7CV0HD4ZZd2Al0bjvODksbO3u2GVeIRdrdmoDbejgGdGwEcz8NtwAFZGtPpkE5wl2AjX12BHVqkag9rGZpdZYPe9AyYsJ2N3oC1+2AQ8BbdejkFsftPQ475HPuj8ZreHulHO11HUGHr9xJ2DesC6oBqwJEG3aRkW105KAcXUR0PLaipoRvwpZA1uJSK/3TBEB6oz2L1uBCBGk+V3CsSwfyFT84dxX+YcAn6AF3Fox07E5XdQNqZ08gZCfXgTYDExTA1Spi1AypCFuWbhvZvyQgFSwGHBjJH2BpGBTLRySJXEnRB7g1JvAju3vXPXI8/yfDQf8HKcMhwfsCt0KAlmVHRw9wS+jm3qLDFevoH2iFTGDPAqkXu7VRAlMCzNjNopDbYIfWyuUQACATduffAhQfGmP/TEtGEObg409A6A+G5eg+DsGLyDTbB8RXhnMQPwxx4f90ykcC1E0gapDG7DEM8Xdv/VYoIQQgKxyKi4yCt7G3Frm5oC3kiZwPdrzfBVYcgotOGLv4cXYSLnVLHKtmwmY454SOWGpqHu9cXYkMg5oPJhpF9Yrv8hzJIMvJi0ZGfEZwiF+4YxNd6OgRdsvz9UZ9BiIp+/XIRlmWRkYd9ExyEVrUZovFEC0fBAtkvXDaBZRoZ087UdFvTcNoHA8XO6l1B0Pr3HO7Qhl18f/Kxa9IEt4m97SJGhAI4w53TrtscvLFsL4QDLf3QLjoRt+U5LZxWHNmc7wTtKwKWhbsiyNLspkQzdKwBF+/fUcDsbaaI/UBFwjgdSgsl4USwkFcl9gTl40jlH/CXdilUeII2HIblzG38tfcI6NP0yzcWEJEronO0AVXwtuHy1c0msZ18BcrtJrIEbHtIc8ERIwGEYrbyzipIl3kNlAFgt+MsiUx9j0PqZq6YjlXa7WBdBvPQ+ylOcB2Fouc+gFd6KIYRZbRv6KdoEF3JeciWXhDaKIDf8+CC0v85S7uBB5csPhihU5OxnohJBQQDA8AH3Qu4HRHtVwbCXUlEyBDLLZgGILt42V4b+dgeoQ5NinKeaoHMUaWyDXwxOwIDa9ESA4Jrb6aOIxvPHkpg253BbsDzk2Dl8jqy7HBqroePaxXyMR15MBnBiznpKrHdSIZA1YJkMcb0ScXxmuVz/jcCQfFDHyQ"
		$bLzmaDll&="h+RaqcRtSGOyBG3D3RLgw/qwTPrw67VvyIWMEV88yzKUTAWTMxcPkVyddWf/kxyHhg4qV9Hkrt7IZDQ4NpcfOemVMauFfzzDPZiQR8lXe4kcExmPEQmyL9pNjheTLExVKzWj4QLJcWykODXJg5ALPHusComzK498Ey9qFvqWlheLXyDmSACutRUse6xUha8S7cSDMXA08y6jhHPIixwOJbQguAcFDZ4JYQSyCAf/0oPtzBw76wrGTnR1DsvBNjEBzHbrw0IBCghs5iJhs6PYAyzHEYl1l4sMqhM8TnWQD99jyGAjnw6JrTzfYYG2owLnnCeX0FDgAmRc2VdlS3C8Z7ODkiPsJICQryyinQG5seyWlJBm6X4CUocsDHWwUw+uAlR5W7yq51eUsmqBIZEtJ/CByfXRALlsTMnszDYsFhfNDV4EsoWkD98sOrMcctED6MIRONoGJJjC7igiZxuQT5tV8Mru7MORSBKdmyHYtCtTJDbyg4btOmvvMraMk/hVDJMqFRLkCoRYHwXowJuQCz84DW2OsCA//wzrf7Jsmwpf33co6BBAvZU1zUzID+ffcCHJtuva4iDVBCH4EBu76LSB4pQG1ZSZ05FoR+YUgR85NJBsEp++3Re0QEKwF9Ej/3JLxKWKKH8QJ3mN2B1mvYUVdephFgZNWOPUH6Remcu/TJ/SUidtj0OJFXQ78tVvYKYONJHPkY8LmKd7jowfEgWwQEcyYIju2A2wQJO/RbhQ5XAaMRYAvmtZBZut2QgIgAYMUHV+UG0oaAd64C+BEJeCPikvi1JILnQYOVZoBaYEIXiAI8ecGYBfEnUQfURHjpXgD3bAfzBBFQOCf1/JydmQexAGFBiBzsnJHCAk36jIVwteEPsVDerZbktJXhgJ6pxsbwQiBgwI8s3iT79prI1GHPgKFFm+zQ2MHTgwFcwkxdmePWp8M5dUWizmIlUvjY1l+J8tHWLu1w5a/3gZRiAmaQEMwM49bEhQHYCQf5YWAG4n4H7cXkiddOW2qqX0BB1tz3QlgA8TViyjXSDBYcsMfmvVzLCifrtdQzuRdCmNfiTvni07GzyJizModeUqIcXZVwQP2WSbsP9G7ATjLbBNvMGahB2/thTbzjU+RhCCFLhUCU22Z90oBn2CadxNGMkgXPIKHCA4jEgra3GMxIxVcTZ3iseGvAhgTxaOA3U0lRBonAdkuezYvHx0g8JOKCHpwQbPlozrwq/gallQv3GiK8DLkFj5ThHCP5a5p5MPQzC+DPwhe9ZdnCQXgoSsLLrDGOHHQyhvQ318utNAlgHZDhjEHA6wOWi1bxIg3qLFac4W7J71oQ3YdjkcJBiFY9Nns8AUcrgjEJ0RlCdoXHMDCNmP4CZyhZv/hIDYiTJGbxgEdLB8HHWF+HWj8esutInPYoBWl4lDO8ZBxyuagDf3KzyQUTi0dc0RQMcKf06TDVa8eZd10KNmTwzN0bM8TV1AyjGe+A+UIL8BMxSHid+OQWG7ExeG7EOQXBQhYbBhjQzsvvtf3kgO5ARIXWzuH8RYJkGLBIdNaAUU0JaCICtS69oS3VcHg8dAiQkeQ2eylBQctliPz2zZArlJcdgxZADkELWPXzUkDzyVCAVSxCJMxIHCV69uxjoTohZAENyDwlwJMXYrdQVYEORfEMzqgLcUNq9eQcCgDDbCg4BbwXoItIWNPNs9qOUMhdZvsHhFmqMh0ZqyWYyG6PVH4jnspMVI9NwNCn5M3bATNTrDexGgKbDedwXdKRopmhhRY5nDxloXQhQN8BBsCJ6MhHNMZfQCroAgyKViKu46G46MCT3/30TNIppwmU50a1Etj16kBYr4FKlv//bnB8HnD3cBz8cH99+2aGsMMkjbTxONWwGBwGsA4Pv+H/W7BhNfbS0lFDhsE41yjRh5CGkoXJBHE8JRtGu7AZsb3AaKHf+QdAEfWG2pXPTuHqPN9wzadGxliHxPXlix6AGxRCmaWI0Hb9a9oFxAUF2Sdm4WvWDJZT6JQxaADzkQikJIEcCFpO+wI4xZW7+T8GxAvgQoW4MBh4cbm4NwxIsKLtCFEksL4A15g/xCXSQAChoDABd65e+JkwiNUAIXOIEEUkbDbBsE9H9AU4Ap3x1AYDACOMq3hrX2GfGpwwHAKR8RtFU04j/CBTnLXqtqdz5hr31nQHQy/D2GfDm+vW+hCOyqqZZKxtiLvhTRotdx1pZKk6v4rcC7SPuLjhwBT0rAGPF3A5eJXt7mboUiGnMDH04gPyxZ66jz1BYVhbagLxrm+eT3/05289xu2QAY6yCQFQ4BAtxrw5xoSqJdGaIZuNt8CYYoDTRFTUheJPMBb/sHIBEkJk7UqrM1PnxMSBcI3LNFbOH5R3IQVfC9CLYfiysMkLdAbApCvOJs0p+istVWme3BvQHgupGakoYqE8JAw2Fmesy8EA+CShqiIUiAOzyLnjCrTxBt7YQ++ElG8D2KmNvu3DmdKOmHrctEoCdVqpZOgTO3CSBUZf7rrAUjXJwKgWS2TrqlSuuegIqQvsLhV8QYuQH48vtVXIgwOyhy+/0Cj1owY2GLEFddnR2Ii0xBkUoY2bMW25V13ncggdCMPy9AdQRgbxa+7jd99AJHDz4wg+M/weMQmKLXDtIBw2SKnGqxoprdtkG/h3deK4aiQ8JJL1gPWWhZkbdH66iTZsJmhh9aAHU9IWFJKYnTbcCXVTMi2AKfKSA3qAg/L41j6lsmSH97QI1fLBemajs8R0QFKI/gIYdABLbs6yqBRhOF+vwyiBWYxVIs6kbh3Zas1qwXiSkI988B64dQ6XNIjYcm4LAti+x+Vo8PRytYDx9RFrGVM/qsV4PDLHiCIhKvqxkg6QrfCcG7jJ+DMIYgVgEie4AyigmHh29vO7Ss5wgMt0OQotqhWWdOGwiSHRDy65Q/qkKPPYgliBzJFy6iDYyPDkFDwTNFa29fQw6WZHj+No38S8AbCH/BGIcA71useImkVyC6Bc+iDRZ4JEACbz8Ahtc2hGkg01Zt2YoyNm0gxgOCXMSDEUYLRCRX4Vf/9wUPDnxpBMnmcGs4WVd0Iq26B48wFRxenZC+vMUAYfhs/oV0N7VsICeTl0Qcij/YAHd01qbjRzmPufLdcBSip7tAUFyN4MW+ZFBVTzYAh4QEby8djsHhYZAZi7MATgHEwBctOyTxkvoGCI5v/OzOAraAeSCWQCMTUCoFluATjcBB2LlR7dRFjYmsgw4IGVlGlhwMSBAE2Ua2ZxQGEBgUCBwDZWQZGCAsZ1AwKYCeA9pj4S/FLH6z74QiCcQP4/FQHVp+KGggOdPBVGvwgadIWcHjoIo/xCaS8e15PEN0ZpYmClo2Pw779E0UglwwgXsQ/r8kPtEQ9ww0UwgxaVjBW/x3CllmHIOYcaRbkTzvjw6CYClvBhJbqWhYf0BabzHYs1pLkXwVkFeGVQa/u7UbgRy5JUkyUC+Ntl99MItYGMdQJDYOltwQHZdGBIqGJTiLDIPQiA1ujoM72HIXXf0SsHvKbinaOAQW7/gTKjUkKe8/F6kuUxqQSCMjJICZOSglT2zPuXIUj4mYiUizVLdtEXiRQIkeIFYeVQpcmJAjSoAhPqn8FJklCD07KUxDiLwGPJkO3M3V+zn+vHINrlAYKtPbKfmsDnRJr/X2JcxUgrUkVdEhaoDM+jcQIQK6QxBaK/CW6qpqascQAisEUeAAWBDz/c9B15fQGEjHmzhEDgJ0GZ3b3Is7/Gk+CGxBcqFYUImQA7iZco0s+gjrhO9KGoYWXVGLV+8pKgGw8CXxizH/T2/BeylqbyUyAYkXOxeLAQ/N7RaafwQDCcMEDAleeClwB3Hl/0fG8P8HoSakAL8MP20BaNsCV0QBEyq4iVZuTEQQEUfWdU8bD9WNOY1CzUeOD2YNq2BBSoTkaoShfosdG0WiKh+U4sa3/ZhzKR0qKcZbwf6P8DHyuYe5rjRTBDc00MJLCB3Cz7VJ+xcruAZLCQfuAnXnlRAs63Tr"
		$bLzmaDll&="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"
		$bLzmaDll=Binary(_Base64Decode($bLzmaDll))
		$LzmaInit=True
		$pLzmaDll=MemoryDllOpen($bLzmaDll)
	EndIf
EndFunc

Func _LzmaDec($Source) ; by Ward
	If Not IsBinary($Source) Or BinaryLen($Source)<9 Then Return SetError(1,0,$Source) ; 9 is the size of header
	If $LzmaInit=False Then _LzmaInit()
	Local $pLzmaDllDecGetSize=MemoryDllGetFuncAddress($pLzmaDll,'LzmaDecGetSize')
	Local $pLzmaDllDec=MemoryDllGetFuncAddress($pLzmaDll,'LzmaDec')
	Local $Src=DllStructCreate('byte['&BinaryLen($Source)&']'),$Ret
	DllStructSetData($Src,1,$Source)
	$Ret=DllCallAddress('uint:cdecl',$pLzmaDllDecGetSize,'ptr',DllStructGetPtr($Src))
	If @Error Then Return SetError(1,0,$Source)
	Local $DestSize=$Ret[0]
	If $DestSize=0 Then Return SetError(2,0,$Source)
	Local $Dest=DllStructCreate('byte['&$DestSize&']')
	$Ret=DllCall('int:cdecl',$pLzmaDllDec,'ptr',DllStructGetPtr($Dest),'uint*',$DestSize,'ptr',DllStructGetPtr($Src),'uint',BinaryLen($Source))
	If Not @Error Then
		Return SetExtended($Ret[0],DllStructGetData($Dest,1))
	Else
		Return SetError(3,0,$Source)
	EndIf
EndFunc ;==> _LzmaDec()

Func _LzmaEnc($Source,$Setting=5)
	$Source=Binary($Source)
	Local Const $SZ_OK=0,$SZ_ERROR_MEM=2,$SZ_ERROR_PARAM=5,$SZ_ERROR_OUTPUT_EOF=7
	If Not IsBinary($Source) Then Return SetError(1,0,$Source)
	Local $Src=DllStructCreate('byte['&BinaryLen($Source)&']')
	Local $Dest=DllStructCreate('byte['&Int(BinaryLen($Source)*1.1+4096)&']')
	If $LzmaInit=False Then _LzmaInit()
	Local $pLzmaDllEnc=MemoryDllGetFuncAddress($pLzmaDll,'LzmaEnc')
	DllStructSetData($Src,1,$Source)
	If IsNumber($Setting) Then
		$Setting=_LzmaEncSetting(Int($Setting))
	ElseIf Not IsDllStruct($Setting) Then
		$Setting=_LzmaEncSetting()
	EndIf
	Local $Ret=DllCallAddress('int:cdecl',$pLzmaDllEnc,'ptr',DllStructGetPtr($Dest),'uint*',DllStructGetSize($Dest),'ptr',DllStructGetPtr($Src),'uint',DllStructGetSize ($Src),'ptr',DllStructGetPtr($Setting),'ptr',0)
	If Not @Error Then
		Switch $Ret[0]
			Case $SZ_OK
				Return BinaryMid(DllStructGetData($Dest,1),1,$Ret[2])
			Case $SZ_ERROR_MEM
				Return SetError(2,$Ret[0],$Source)
			Case $SZ_ERROR_PARAM
				Return SetError(3,$Ret[0],$Source)
			Case $SZ_ERROR_OUTPUT_EOF
				Return SetError(4,$Ret[0],$Source)
		EndSwitch
		Return SetError(5,$Ret[0],$Source)
	EndIf
	Return SetError(6,-1,$Source)
EndFunc

Func _LzmaEncSetting($Level=5,$DictSize=0,$LC=-1,$LP=-1,$PB=-1,$ALGO=-1,$FB=-1,$BtMode=-1,$NumHashBytes=-1,$MC=0,$NumThreads=-1); by Ward
	Local $LzmaEncSet=DllStructCreate('int level;uint dictSize;int lc;int lp;int pb;int algo;int fb;int btMode;int numHashBytes;uint mc;uint writeEndMark;int numThreads')
	DllStructSetData($LzmaEncSet,'level',$Level)
	DllStructSetData($LzmaEncSet,'dictSize',$DictSize)
	DllStructSetData($LzmaEncSet,'lc',$LC)
	DllStructSetData($LzmaEncSet,'lp',$LP)
	DllStructSetData($LzmaEncSet,'pb',$PB)
	DllStructSetData($LzmaEncSet,'algo',$ALGO)
	DllStructSetData($LzmaEncSet,'fb',$FB)
	DllStructSetData($LzmaEncSet,'btMode',$BtMode)
	DllStructSetData($LzmaEncSet,'numHashBytes',$NumHashBytes)
	DllStructSetData($LzmaEncSet,'mc',$MC)
	DllStructSetData($LzmaEncSet,'writeEndMark',0)
	DllStructSetData($LzmaEncSet,'numThreads',$NumThreads)
	Return $LzmaEncSet
EndFunc ;==> _LzmaEncSetting()

Func _LzntCompress($vInput,$iCompressionFormatAndEngine=258); by trancexx
	If Not($iCompressionFormatAndEngine=258) Then $iCompressionFormatAndEngine=2
	Local $bBinary=Binary($vInput)
	Local $tInput=DllStructCreate('byte['&BinaryLen($bBinary)&']')
	DllStructSetData($tInput,1,$bBinary)
	Local $a_Call=DllCall('ntdll.dll','int','RtlGetCompressionWorkSpaceSize','ushort',$iCompressionFormatAndEngine,'dword*',0,'dword*',0)
	If @error Or $a_Call[0] Then Return SetError(1,0,'') ; error determining workspace buffer size
	Local $tWorkSpace=DllStructCreate('byte['&$a_Call[2]&']') ; workspace is needed for compression
	Local $tBuffer=DllStructCreate('byte['&16*DllStructGetSize($tInput)&']') ; initially oversizing buffer
	Local $a_Call=DllCall('ntdll.dll','int','RtlCompressBuffer','ushort',$iCompressionFormatAndEngine,'ptr',DllStructGetPtr($tInput),'dword',DllStructGetSize($tInput),'ptr',DllStructGetPtr($tBuffer),'dword',DllStructGetSize($tBuffer),'dword',4096,'dword*',0,'ptr',DllStructGetPtr($tWorkSpace))
	If @error Or $a_Call[0] Then Return SetError(2,0,'') ; error compressing
	Local $tOutput=DllStructCreate('byte['&$a_Call[7]&']',DllStructGetPtr($tBuffer))
	Return SetError(0,0,DllStructGetData($tOutput,1))
EndFunc ;==> _LzntCompress()

Func _LzntDecompress($bBinary); by trancexx
	$bBinary=Binary($bBinary)
	Local $tInput=DllStructCreate('byte['&BinaryLen($bBinary)&']')
	DllStructSetData($tInput,1,$bBinary)
	Local $tBuffer=DllStructCreate('byte['&16*DllStructGetSize($tInput)&']') ; initially oversizing buffer
	Local $a_Call=DllCall('ntdll.dll','int','RtlDecompressBuffer','ushort',2,'ptr',DllStructGetPtr($tBuffer),'dword',DllStructGetSize($tBuffer),'ptr',DllStructGetPtr($tInput),'dword',DllStructGetSize($tInput),'dword*',0)
	If @error Or $a_Call[0] Then Return SetError(1,0,'') ; error decompressing
	Local $tOutput=DllStructCreate('byte['&$a_Call[6]&']',DllStructGetPtr($tBuffer))
	Return SetError(0,0,DllStructGetData($tOutput,1))
EndFunc ;==> _LzntDecompress()

Func _OnAutoItExit()
	AdlibUnRegister('_GuiBestResultEditFlash')
	Opt('TrayIconHide',0)
	TrayTip($sSoftTitle,'by wakillon',4,1)
	GUISetState(@SW_HIDE,$hGui)
	GUIDelete($hGui)
	$aMacros=0
	$idlabelFunc=0
	$idEditLength=0
	$iBinaryLen=0
	$idEditRatio=0
	$iBinaryLenLzntFunc=0
	Sleep(2000)
	TrayTip('','',1,1)
EndFunc ;==> _OnAutoItExit()

Func _OnTop()
    Local $sHandle=WinGetHandle(AutoItWinGetTitle())
    WinSetOnTop($sHandle,'',1)
    Return $sHandle
EndFunc ;==> _OnTop()

Func _PathSplit($szPath,ByRef $szDrive,ByRef $szDir,ByRef $szFName,ByRef $szExt)
	Local $drive='',$dir='',$fname='',$ext='',$pos,$array[5]
	$array[0]=$szPath
	If StringMid($szPath,2,1)=':' Then
		$drive=StringLeft($szPath,2)
		$szPath=StringTrimLeft($szPath,2)
	ElseIf StringLeft($szPath,2)='\\' Then
		$szPath=StringTrimLeft($szPath,2)
		$pos=StringInStr($szPath,'\')
		If $pos=0 Then $pos=StringInStr($szPath,'/')
		If $pos=0 Then
			$drive='\\'&$szPath
			$szPath=''
		Else
			$drive='\\'&StringLeft($szPath,$pos-1)
			$szPath=StringTrimLeft($szPath,$pos-1)
		EndIf
	EndIf
	Local $nPosForward=StringInStr($szPath,'/',0,-1)
	Local $nPosBackward=StringInStr($szPath,'\',0,-1)
	If $nPosForward >= $nPosBackward Then
		$pos=$nPosForward
	Else
		$pos=$nPosBackward
	EndIf
	$dir=StringLeft($szPath,$pos)
	$fname=StringRight($szPath,StringLen($szPath)-$pos)
	If StringLen($dir)=0 Then $fname=$szPath
	$pos=StringInStr($fname,'.',0,-1)
	If $pos Then
		$ext=StringRight($fname,StringLen($fname) -($pos-1))
		$fname=StringLeft($fname,$pos-1)
	EndIf
	$szDrive=$drive
	$szDir=$dir
	$szFName=$fname
	$szExt=$ext
	$array[1]=$drive
	$array[2]=$dir
	$array[3]=$fname
	$array[4]=$ext
	Return $array
EndFunc ;==> _PathSplit()

Func _ScriptEvaluateFuturSize($sFilePath)
	AdlibUnRegister('_GuiBestResultEditFlash')
	GUICtrlSetState($idButtonCreate,32) ; $GUI_HIDE
	ReDim $iBinaryLen[7]
	Local $iAddFunc=Int(_IsChecked($idCheckBoxAddFunc)),$iRatio
	Local $aRet=DllCall('shlwapi.dll','int','PathCompactPathExW','wstr','','wstr',$sFilePath,'uint',50,'dword',0)
	If Not @error Then GUICtrlSetData($idLabelFilePath,$aRet[1])
	For $i=0 To UBound($idEditLength) -1
		GUICtrlSetData($idEditLength[$i],'')
		GUICtrlSetColor($idEditLength[$i],0x0000FF)
		If $i Then GUICtrlSetData($idEditRatio[$i],'')
	Next
	GUICtrlSetState($idProg,16) ; $GUI_SHOW
	For $i=0 To UBound($iBinaryLen) -1
		$iBinaryLen[$i]=_BinaryToAu3($sFilePath,@TempDir,1,$i +(1*$i<>0))
		If @error Then ExitLoop
		GUICtrlSetData($idEditLength[$i],$iBinaryLen[$i])
		GUICtrlSetData($idProg,($i+1)*15)
		If $i Then
			$iRatio=Round($iBinaryLen[$i]/$iBinaryLen[0],4)*100 ; ratio
			If $iRatio>100 Then $iRatio='> 100'
			GUICtrlSetData($idEditRatio[$i],$iRatio)
		EndIf
	Next
	If $iBinaryLen[0] Then
		Local $iIndex=_ArrayMinIndex($iBinaryLen,1,0)
;~      Flash best compression.
		GUICtrlSetColor($idEditLength[$iIndex],0xFF0000)
		$iBestResult=$iIndex
		_GuiAutoCheckBestResult($iBestResult)
		$iFlash=True
		AdlibRegister('_GuiBestResultEditFlash',1000)
	EndIf
	GUICtrlSetState($idProg,32) ; $GUI_HIDE
	GUICtrlSetData($idProg,0)
	GUICtrlSetState($idButtonCreate,16) ; $GUI_SHOW
EndFunc ;==> _ScriptEvaluateFuturSize()

Func _ScriptGetVersion()
	Local $sFileVersion
	If @Compiled Then
		$sFileVersion=FileGetVersion(@ScriptFullPath,'FileVersion')
	Else
		$sFileVersion=_StringBetween(FileRead(@ScriptFullPath),'#AutoIt3Wrapper_Res_Fileversion=',@CR)
		If Not @error Then
			$sFileVersion=$sFileVersion[0]
		Else
			$sFileVersion='0.0.0.0'
		EndIf
	EndIf
	Return $sFileVersion
EndFunc ;==> _ScriptGetVersion()

Func _SetJpgFile($sFileName,$sOutputDirPath,$iOverWrite=0)
	Local $sFileBin="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"
	$sFileBin&="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"
	$sFileBin&="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"
	$sFileBin=Binary(_Base64Decode($sFileBin))
	$sFileBin=Binary(_LZMADec($sFileBin))
	If Not FileExists($sOutputDirPath) Then DirCreate($sOutputDirPath)
	If StringRight($sOutputDirPath,1)<>'\' Then $sOutputDirPath&='\'
	Local $sFilePath=$sOutputDirPath&$sFileName
	If FileExists($sFilePath) Then
		If $iOverWrite=1 Then
			If Not Filedelete($sFilePath) Then Return SetError(2,0,$sFileBin)
		Else
			Return SetError(0,0,$sFileBin)
		EndIf
	EndIf
	Local $hFile=FileOpen($sFilePath,16+2)
	If $hFile=-1 Then Return SetError(3,0,$sFileBin)
	FileWrite($hFile,$sFileBin)
	FileClose($hFile)
	Return SetError(0,0,$sFileBin)
EndFunc ;==> _SetJpgFile()

Func _Singleton($sOccurenceName,$iFlag=0)
	Local Const $ERROR_ALREADY_EXISTS=183
	Local Const $SECURITY_DESCRIPTOR_REVISION=1
	Local $tSecurityAttributes=0
	If BitAND($iFlag,2) Then
		Local $tSecurityDescriptor=DllStructCreate('byte;byte;word;ptr[4]')
		Local $aRet=DllCall('advapi32.dll','bool','InitializeSecurityDescriptor','struct*',$tSecurityDescriptor,'dword',$SECURITY_DESCRIPTOR_REVISION)
		If @error Then Return SetError(@error,@extended,0)
		If $aRet[0] Then
			$aRet=DllCall('advapi32.dll','bool','SetSecurityDescriptorDacl','struct*',$tSecurityDescriptor,'bool',1,'ptr',0,'bool',0)
			If @error Then Return SetError(@error,@extended,0)
			If $aRet[0] Then
				$tSecurityAttributes=DllStructCreate($tagSECURITY_ATTRIBUTES)
				DllStructSetData($tSecurityAttributes,1,DllStructGetSize($tSecurityAttributes))
				DllStructSetData($tSecurityAttributes,2,DllStructGetPtr($tSecurityDescriptor))
				DllStructSetData($tSecurityAttributes,3,0)
			EndIf
		EndIf
	EndIf
	Local $handle=DllCall('kernel32.dll','handle','CreateMutexW','struct*',$tSecurityAttributes,'bool',1,'wstr',$sOccurenceName)
	If @error Then Return SetError(@error,@extended,0)
	Local $lastError=DllCall('kernel32.dll','dword','GetLastError')
	If @error Then Return SetError(@error,@extended,0)
	If $lastError[0]=$ERROR_ALREADY_EXISTS Then
		If BitAND($iFlag,1) Then
			Return SetError($lastError[0],$lastError[0],0)
		Else
			Exit -1
		EndIf
	EndIf
	Return $handle[0]
EndFunc ;==> _Singleton()

Func _StringAddBase64Decode()
	Local $sString=@CRLF
	$sString&='Func _Base64Decode($input_string) ; by trancexx'&@CRLF
	$sString&="     Local $struct=DllStructCreate('int')"&@CRLF
	$sString&="     Local $a_Call=DllCall('Crypt32.dll','int','CryptStringToBinary','str',$input_string,'int',0,'int',1,'ptr',0,'ptr',DllStructGetPtr($struct,1),'ptr',0,'ptr',0)"&@CRLF
	$sString&="     If @error Or Not $a_Call[0] Then Return SetError(1,0,'')"&@CRLF
	$sString&="     Local $a=DllStructCreate('byte['&DllStructGetData($struct,1)&']')"&@CRLF
	$sString&="     $a_Call=DllCall('Crypt32.dll','int','CryptStringToBinary','str',$input_string,'int',0,'int',1,'ptr',DllStructGetPtr($a),'ptr',DllStructGetPtr($struct,1),'ptr',0,'ptr',0)"&@CRLF
	$sString&="     If @error Or Not $a_Call[0] Then Return SetError(2,0,'')"&@CRLF
	$sString&='     Return DllStructGetData($a,1)'&@CRLF
	$sString&='EndFunc ;==> _Base64Decode()'&@CRLF
	Return $sString
EndFunc ;==> _StringAddBase64Decode()

Func _StringAddLzmaDec()
	Local $sString=@CRLF
	$sString &='Func _LzmaDec($Source)'&@CRLF
	$sString &='	If Not IsBinary($Source) Or BinaryLen($Source)<9 Then Return SetError(1,0,$Source)'&@CRLF
	$sString &='	Local $bLzmaDll="TVqQAAMAAAAEAAAA//8AALgAAAAAAAAAQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA0AAAAA4fug4AtAnNIbgBTM0hVGhpcyBwcm9ncmFtIGNhbm5vdCBiZSBydW4gaW4gRE9TIG1vZGUuDQ0KJAAAAAAAAACjQ7ja5yLWieci1onnItaJZD7YieYi1omIPdKJ5SLWieci14n0ItaJaT3CieYi1onnItaJ7yLWiWk9xYnjItaJUmljaOci1okAAAAAAAAAAFBFAABMAQMARI2vSwAAAAAAAAAA4AAOIQsBBQwAYAAAABAAAACAAACQ4QAAAJAAAADwAAAAAAAQABAAAAACAAAEAAAAAAAAAAQAAAAAAAAAAAABAAAQAAAAAAAAAgAAAAAAEAAAEAAAAAAQAAAQAAAAAAAAEAAAAMjwAABwAAAAAPAAAMgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA48QAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAVVBYMAAAAAAAgAAAABAAAAAAAAAABAAAAAAAAAAAAAAAAAAAgAAA4FVQWDEAAAAAAGAAAACQAAAAVAAAAAQAAAAAAAAAAAAAAAAAAEAAAOBVUFgyAAAAAAAQAAAA8AAAAAIAAABYAAAAAAAAAAAAAAAAAABAAADAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMy4wMwBVUFghDQkCCBBuYrJ+5EEhOMMAAINRAAAApAAAJgMAMP//d//IAAEAU7KMuQYAiMgsAVFqCFnQ6HMCMNDi+FmI/////4QN//7//+Lmi10Ii00MikUQhdt0E+MRihMwwg+20jKE////2xUAHf9D4u9bycIMAFWJ5f91DOgDAJdCg8QEXcP97chlD0jIEGJTagWPRfjd/v+/TgyDOwpzCIMjAGoHWOtagysKx0XwHQBL29ttswb0W40NUFA8HGoACfjty7J1CAgCGBQQU4tFNtt//+7AClBWR/yJRfyDAwqcRRSJQwUtamvbdvcJU+gqkohDCXIsFfyYdv2cbGUUXezwg20U3W7/vzRNEItVDIsCOUEFcwWLBIkCaexQnu22uwP0UEUFUQgUUGkQUnP/Z+d+bWcMxCSDffQCdQW2WfLMfV1fyeVTgXuu/nd728o4H4uN6w9oawFu//3/ws08McBbAkNSQyBFcnJvcg0KAMyuYXOPAFW4AZJDXUCQAIy9u3NO4ccABRXHQCQABgTJydadLNn/BiAcycnJyRgUEAwP397JCCg+fJCNdCakVn8vLGyvVTEayg+I7nsai0I99u7/BIXAdSWD+wUPj4wRjUwbDpbT4ImyvV+7Go20NRS8JwYrCOf5fLc4FQEKDP4AEJY/y5/nchSF9stKGIXJqe0y9n1aHG+OKyB4Z3Rt+7ebJA7R+ReNQRB1AtH4ayQbFYK1mywrW16tdjboHrq/lgYPlcBIJQz+FQST6XfriF1UAizPkAlvuAIYgLUJBXVLQz/eYB/ax20965APu0Jrd2PvPgH+jbZf262Vw4mfU2v/cvZukG+fg+DgjUhAicIX126Y7WMUBPPwid4QCuV721hXEHMLTbvCIJfBC0IIAzdvG99/I6Tlg+w8iXX4uSSLS4mF7t/4ffyNfchgyPOliQQk6Irs8SXMLrfMGPiLiey4b7f7bu9VumZDV7/bVj9TuxENC//txgYCRgEBkInZifhDSanBwtv/b7rrBpCIHDJAQjnIcvdDshV+4Qn5YsfcX1Hpjb9Pjhi98beZiXMQiV30i0YPHznYe7vQLvWJwwpfXCQaRCQEldvlHW8MoL9gKV4IAV4aH2t8l7mLLap2T1dQUjUezn0cu0hIpzpcwfdvb78hCIHCgMM8BRAsBIkUJIHHGL0Id6+LOVdRJbkxKolMJJJFLncryAsEWHQlubu/k7AAUoJIGRuHCJfJ7e+2gM+P8ELB4wWNNDsBkKN9t7dOtYOsJSiNkwWJzNuyLEu3iUEFCAgMDMuyLMsQEBQUGBi/trktHC+MJ0EcPgiNjhcCe93kAc2GBUE72+m3Wv+tHfALD45ndgwDQnv3CfCNn2QJgcYMKQavd+u723TauIAYg+6AiRxN64Dse2v9SAj/TfB54Jcvl2QFOMjI97eBLJGHhAELMIjIyMjINIw4kMjIyMg8lECYyMjIyEScSKDIyMjITKRQqMjIyMhUrFiwyMjIyFy0YLjIyMjIZLxowMjIyMhsxHDIyMjIyHTMeNDIyMjIfNSA2MPIyMiE3IjgnDhOx/jIBQwrLbnkIUTvRmNgXM8x8CssGRnZykgGC/RM+BwZGRlQ/FQALDIyMvJYBFwIOTIyMmAMZDgZyMjI8/iWPPxAl5+R5wCXRASKoLy4AJ2OP3Q60+aLkagl7RyRNgiyulQpHLNzImlYr18QLNNTAmSAw1oFZJ5OA6RfVmWJKn2EdF8DAfsXljZocFbcFFMUhkVKgfQLX1C9kdo7XwhHboYFjCxDJV9dt8MpdluA5L7k8lgysp3a72QLiDAyMjIyjDSQODIyMjKUPJhAMjIyMpxEoEgyMjIypEyoUDIyMjKsVLBYMjIyMrRcuGAyMjIyvGTAaDIyMjLEbMhwMjIyMsx00HgyMjIy1HzYgDMyMjLchOCITJbM1lWHh1h0pxlBakFuXlbHkc54JNWJa4ua0ZHuNNKLZYlxC1CRkZGR+FT8WCMjI88ALFwEYAifIyMjZAz4ljgZeY6MPPw8AJdA0+kZGQREF2dciRNIpWpeifZfwsRIDJ9MBI1IdHSfbrgbgxiQOIldqLilTY/BQrcb+QgiyZHEg/r9NH+2BAu9dciD/rFFvD1r+czNBiWHowpAmJ/+fcn0gwCetdyJuwQIRdCD+Fe2+N0zho8lEQG8dgYNL+G2JjC+a4mTmEq6b7hfvwQ5i5Qns5wF/swAD9t1v7eUHYOkvEPUhQrsNnQPULrE7WXYAX5MBAN/xsKJ53YETm+7cUXgVuC8nM1Faz8Wxw74CYlDXy+4D9Q6Fr94Eb8Li3rrtHL0IcwOL4tQIK2jke05Ww0GDAB9dn3GBgETFMZAalAYzskWjH0GLDDosngvOE+PXYVusVD9k3WOcDCOUhvZtnR5XYx1kBH8PI51o/GLU7Mpxo31h/53g/8SOfB0B8dDMAnC0gFzKNGyrb6TIBFTLAQYOwW62JbvYRDZcAWOWuG7/qb+djCLSN+5fv9Wi7UpQsBfbksUg8IBg9F2tWztAMHmYQ6JiaDEEG8Vco9LL/r0iEX3bbvb3OsJGCoMIQBN93QYF4dtd/9V94gQQDlDHHt0QcYi/0z/NuwbLP+lCdB1zGVQI2uT/YnwwegYZ4hTah0QeMeJ2GsMfOu2/4nXNloL88IMTICG8FGr/xcjiQt0RYsD"'&@CRLF
	$sString &='	$bLzmaDll&="Tonx0eiWDb/wrZTyVfDT6OQB99gh0A9D/a7AhQgMDIEr7gB3zsFl8IPtrCunJQNc3D51X2EkGyRvDC3wkenGDYnGEyE4Nbz9N/8PtxqJ+cHpC4lmD6/LOCsrtN0sXwjKKdjPBXddSxj/t4H5bGaJGHYyiRZQj/t+961O+NgRVgwrifopwynKjdExA9vQJaHhGYkONtPhY7/pqWaQ/8dWidYBlLdlOGCBy6k/V4naNt3abVYH+sHqsRRWrAHbt7bQFQ/nDgD7X+N23JsYjCEPVztWvsFjS7mhPEoIQjHJuoUXaO9LH95jyesDVrS39t9BPTx39kp57GGcg8MQYNgt122AyFMHMmp2yFO3s8W2T9FRmMl/xlNoh71WUkifyJ1baO9tPhRGCKZdoyVDh0Lb+jHCwUGLSD0IEtKsdafUiKZvhteexV9cMf+2BwrWFQqvBJ9EH+zIn+kM2+4h8mUB0P8wWW1Q7s5UAM5wAzyQ7zMKB/vI99Ahxna9Wi4COBdjCB9t0mAI8MYDUYXGVex0b5RgV4sGT+xPwRj4ZmsQbgbT64PjAWkybhcicigJ2C512VYO3HJYTxwMRTE87LsSuCkQdTlV6F99NO1/tiTPXxyJ/oPmAdHvYK2NuRuyNCRjW/84uoAJ7NwJ8EI7fNbKHY7DSC8vMbRWhP+AwjH24MbjCcPrKFb4C7vCK63R6iMEV/fbgeMLG1twGtkxxvhSHBmvbf+BAd6J04P7Ab9byFt/5Np3gHrECB2zRwMv2IWF0lEdKsrbS8P28YPhU+53eAH/96TPrVBICHPkpi5pIUvuS3XU2W8IHW2BAlthZhdqBAXtDba/AAREUAQGQl1/dvMbmGtN25C5CwAjjBSEFVwWMMrtXx8CWrZg2IH60dLqX6NL800/vCBVgAQV9oatkM+UTd/sjQQTtr1t7v8XweAGic6NhDgESxToEcKB8m+Oje3ACNJGBPfBgYsMbc5st5EOVwIe5BUShsK23ZYkIQHIGeATlnP6SeKliIlN3F87dewPgwcijXBryAhnyrGx8PGNRDsEB8zO5LiL0dtL3AwEskZGB3bOBA93PQPsHM52oxY/c2UUtbXSbEb4O9+oOgHm3MEi8UFN4D+AQY89/D0PdswzMY2fEZA68LoI5Ju5Ji01d9zw6GKXMHLWP0gMCWTDvc6EjwgJXyCBUisCH6jlJMEuGPjWOfMjYHMbJrdf71Nv2kNqgxHcH3LsG9gTAg3rDZAAT8k5HhgoasMsS3c0+NjeWJoQa0VIo91gKmQ4lndWx1bDtw1MOokR9Yl8z8Hi8TvdCylUGgQdAxsQDPvdXcBrp3QWIouEk89IiQekS1g3FXqRVQEVbKENcIAoas+2ly3nAmuNR5dEbpQaXcLeD4LrjJA8JxAIA++wPUcuk4ExyyHYNmkTzn+W6HkoGYcDrtiH6iivbrrpMMERYXUEyX8BkDQvt6ABQVSOQBj/URQCQsBoFv8/FWivHTZXJqoqTXf39itTYoOYBoyDnBBERENxQyUidDnGdBm0Wyi2/oWUDZQgObvGSmw6fBV0Grt2+BiWEB5hMi1B2124ZBA9SP9cE5g6i5NntelQ6UB/xCN3Km6x4bYJKwY517dzsiQEBzPctpdcD3Wpz0cSc6IEEmLC7wd07+uUujPrzx+rUqm5TspT0FHbpQbHTW0Bb+kEEoS+T+3PU4yUi5wOBoGEgwlbeBgYNcbPDwzNQgsGBUGJLnzXnNsmA5wGdUZVlEhbrg5KbT4MqvXqzu/0fFdGNctVnIYNXBfbXJYGQItMpMju0AysRgAwSER2B9sKkwEzdDRMTlw9ReRAlJ4pJWF2G57TgU50AE2+N+zrljNqf4wXC0vydMvfn8tRgUr8nzfHPpMb48OW46VDB8s0jfQNRp1IeAPy8O4VwWEYvVQzDBowThNtIF9LUhDqjQI75ARbDuCEMKDL4X784HgUT56ICxePNrbhmR4B8NcFkBXkIWpgeNMUU1aNDH9YstMQyN15gpwYoA3zvRumDpCCtFEvGLu7KVcme+eEDnQVgcFwBbPdBO/CcwNEMRQGEL2RulsYT3+J4+x0Mh+1jVa8O4t6GJfr7Aje3Y4bOVoULoVlaouGuD5Xgtc6sQIKa18F0JbFI1hW72+oAW6UgPyy5cZBi4LY7U6lcwsJOa2YC7i/Vxbgsae8BRQYuZWwMJ8BivSfD6GTdS8JLuu6r42wn98XuKgPtwFNmPSI4ItXSz3JdrvYTzj7odet6Et59gl8t65ZmNaPFRfhsKQXtNcUzZ9Nt5w2KhwscCHWhnj4O+spFhNw6NijlyFM8LDaDLyUV94U4wvOGofZl1utV5z99aBgiRKHoGBPDfAWBNKDv1cAPYkBtwCz3kRuwhzU8G26nUYTfBQGuD9el32NPVxxen4Q+hqaXcMYT7qNAy8NnATdgRx5D/ArXOEYvx8rg3IPj42AK1ONGTU4vb6v0ApWAw9op8sLGPrI8MKDYy+EnkwEuV0bFPH83/m+jA1/I2wIgV9YU4HsWt4OhjT0jbWF3P2Q7apr3JeUHr6m0FmV1IGtFtgSjXgM4rDK4KlGx3750+KLjRIEVlgLaPP9WgwyBQrVTNkpcwdbWnsMcPqUnegdlHs7vIWyqo2GKs1MHQNo3xappti4cLcZEOTdS7mP/b2QtYmJjeANg9i3RYv4xQSVX4sQ3OGD2Is1B7qAZ2dL7yTFlRzmkz5Cs1/9sYkPOdB3w7oO3fgOEZW2ZNvrJEDgTNqDvfs92zrGbUFvOY4+d9p/cfhvbYsTTo9Bg/kDdvS5GAKnYSH/Hw4frTZr343eA3kt5JdQ6Km/raKAgcOjgcwmx1/BWSnaD4kfEOxw0mHHhvBegcRzknYfHTEYn0DHg+WNz/cS6rOcAfogAO00bI74WPC8jUMgjI6MibODT+rx7I11yBsBjLSFCvyQ7tlrSaIqA5wNDsfPNfcO7IZn6wcYvSdblATKQA9vKDC86MpUBJMUy3DT2U887i/DdAhEG6RFQcpVFKwfUTBV80/8XdmJuS0xWdcEJwQPGL3GGhoDx+SeI47BI0nwGbDfewjDYA/0EIkQ9IPF4NAW1P7s4A6yewvXAQBtbGB1D9KheUAWHDyLODyJ1wqddVccDN7KzsGQLW/4TbyCI9xgyFxpNlvt3YgyHA9LBKWUKWSwc647/+E/SQ38PlEAgAjrVbBRG7BwideLlvSGdDsC/EFjxIv4In6GGmZj8fJGShYoFY5YBnTxPfnP32DrChwVB0/AReh29UV7BZZppKzoRaid7AbPEwnBAZ4AUFYIwI5t0C4VCKw8GEx4d4dSe41VxBR2JxoUvImEQCvEnaATUzfAWWCDawVXMrZZwJw6hjQcoSAModUboRieEuhcS4dt2HQIltQgwL6/V3IObVc+nP+OMf89ey3XsCgBeaOJvTBct+oiNoRaC3/MfAfaX4IVeG3bSZzfDZgGcZwIlJxPbCO8cphqRcD0S+EudqC65ySgAQ+Gc7H2FO2ECVsHIQgUY9thqgwPmGy+djvS9m3JDpTiWP+9QP+YREvdzbCIhasFkOeO/lgD+ObaKfESjXr/OkL/VBir3JGCBCbcaeD2frRjnmE5lTl77wjQdqOZrIefdm8cvNz+X6IhkHyT/HY/i0ST8EA7v3U1S9AgWc/rqDsUb+tvF/R2IY1C/q8C1Svxja3FMINtTZx2C681KEX3ZYM5yHTUUAL94tT+O6f/fw+XwoXQdBG5A9cu2xIPdJRai9Bn0u/O9Q+DGmoMg8ACDpPC9ezt5tqBoDE+wIXQhfsBHmaSARkDf9zZ/kIGP9QPlsCKoN6FCH+WwgnQqAFzDtMJhoalGDv7pIscY6zLGrZvlyUhxyykAXUKBcA18S0KEob4wlRYaIsZJuMzrz+M2iXZchorAw9GidmwR5oxLtbYZbtkVkWowKYDKSzJgQwARB49cjta4NwB8mvzbO/C+JgPla8MFFEFjBkv4/ig4PKQVzrs7YvkKdCJ"'&@CRLF
	$sString &='	$bLzmaDll&="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"'&@CRLF
	$sString &='	$bLzmaDll&="ncbRbGt2dMsU6EiN9AjD2Gt3Wxj2O120SvD5uDGh9rNcfJ/BgnHhuU7bF6P+I4wRxq1JKfkHBAKDwMMXZwmWBozVrUh0hcxkhBuLNSyEIQXIrxKdC5HLsoUq4tqUVmfAyKXqHZyW2a6NgoWTh8QYjRSIjmFd7Ma2wBUhyDPgG47fseBcOasrjRvT+374bY8HiG00qFzgCbqBCa6RMpC2DB+eBRev6y9ayL1ZO3b2a7whqAHH0KqkZkFg19BA2smURP+Mz5SBlDTxI/lOzhMCh+es17bOK5P0aaSLQwUIZpDvg0IsBGIVyaEOvAm8ks9rykAECsxQ0Nu8QBaI1c84+P2SwGwIyY3PkEpvkHgBa3MI9TTSQNkBEIxCXZ5gA6c2lWlHkPo85AlcOGl9FP+W0TifRzt9vt/g9BKFsEAfdOXlss1q9dby+f2Ap3sBG/sTBoTBxhNmKQh326QIFnvMkkz+fP4KbPUIzAye8SBq1tyKnwT/CeKsF2NbEzk4/FoWINYglGpUFy3Rndb3JkMfsXEMnS2VzlqaTzNYpSXqzaAeoZZ73zaDCwd1BvgF+GqOFCgwVpzC+bueSy9YcwfMlfhGg3XC2T4IKr0KGXbYuzQfKf9CKhskS8OysVCdKlUZOen1Zo10VWuEkPFKRp+efczo+MiHJbSVgDUIxgSnr/N9pfQ5hbDwDUjDhJGGwiwmnPLUyNmLKr3Z7tA7ECkG/xoeTafY0sPs/bnDB+nUIm0X8L0R4cFkSjpbH+jH6GkMHjGINQnVgfQmDcn+x9M5i7WQabmOwTaZpL+qQiHKvvRwzVZWvAhUvZA04SG8Ad/143CBGIQmz76dlI4hI402+MwDznBAhpKEOXLbE/HaUwvwvJWVJL1ShOPI3MvSe0tOEPeKr9GEThFaAsql0KePtMtaEIl6yDN5GhCjh2ZB/P1lJpVkA0gcfQGufoT8OUMYcwsNkEt62NZW82o0cjhvBxh5jIuV0GuggizzYofRMwsvQ5pMIAYBYUsCCEK7B6dsMDY/Aay+JxxgfidB936GV+6bUEOJBhGI17HgMvf6ifoRZFsGcYKqmGQwmyFaB7NGUBKAx0lTjJrZ74UR/lokHgMROWx2EDNPlmMHMdK0uLgN3RnxZqRLg+kEKMjBK1mNceT2i5UUlXKVxIBfwGrc2T1WKZa1xqVHzMF4MM0xqkB7iuyMo9zbWYGMDA+D9xWCxgwbBWNFcBpV1rU9bdzs3ohDjBEQCcWXddSMj9w7gjjsSThhIEQt2iNddtSQjLDh6IbMML+n4O5k6PC+1N0xgaaYpEqfjVXAU5SKWUavdQErzICRYdShYpGttK48NKKq/wsYnnY8JOu9iU3AZxCAVkBFLZAdoIAUj89AreJUpiD1USbiheRoQ9EMwV1U8Y2GAhy5iHYH7CyJ2S407lhIQr/oEc8PZse1n9+T7gAECYwnduO4BIoAnQDxuvab+WwsRbgMjF5EB5TuTOXOXlwcC3ULdpfalGuzxTVHioaYbrHg/3TB0+I503MRw2YEWB2AdttGQxBy9SAsCyydw7hmF0JAoD8J4b7bdvRK6oDD5trfgEd+s3trDCtxdu0Wq54duuERfDgKWjmZLCrwD2JVkOrdmJwlLClUGCkiJ1DCeSAC31wEponRSYkohygUWYyYzaRAEwjQW15PGAK6gidHXfRCj1/Eg3+TyXRai4fakI3VxhuBtx6PfFdIWMRjC+m8aIcUdBL33qdg/BMsJBPHCi64gjja0+N6s4rWQzW8I+izQzV4CQaM65aHUbys3zHJYSyJYDdBf5AAvYPlAnSDXCasGncJH13Qt9M5wnfyVRAECVPwIBxG0asreAWHF0LSritegSwIz0N5CjYAjewBN/hbQGtBSW9XHLALJgVGY4XS3c46WF90BcJOHr6YgweP9vjKJha6hBANqMUNL/5+bziTLQw5vqBRhJtdTQi7YahwolATzIMtIgJeDuPge+1BHEUIIaFFET0bZRlNDFmWhb0ugM/JU3RkSC0BDwjSRETIaryCC6qJ0J4i7g17hZAcVB/GFIi9FRF02QUclRy2YzdxQbuJnYtWyo5QiA2wEbj5NA+X/9BEmGUZgUg7RfBydyoELBCBf+vqoPuJX41eIF4QuRSeCXKz8w0q1ZHbTaqKl498ckkifm3HYwNeGFozfrjcloy8Zds/TCFz5gnbQMyL6KOe7M3Lu7kN1BMpyPxcdYF+VfYgJp6ygZBteOVtnPt/3v6EGga04YJMAUMsL7ogQyO/Li+IrbXmID8OKxEFm5BdlxQIXZ9BXLk0tW+DcgPwERArVSJEbDazNQwPFMOQaJOIk39FFIK7FekL2u4cixBXeP8oDKDBQ+yNgzsjQa+rcoN60HVNoEqnDB5+x/gNJOqB76xQHBYtYoPmA3ZuiAPH2iBap5EsBtACOLJPEJyAWLwFmgnHRhHKEJ0toVYtuQWwrMmhidgGdllETbZvJMK1rSNIIO24NIFaNo9ONX5NEtiTdVkpkltylxW/LP2d2DAcqIVgREoUHERv6xqv6QIU5Efdoepo/QCHZgf0fFqiIqeHtnVuKloxHD0qRnl78PjJnzABVk0cjfG1mEXSfBsBtTTWm/+MTx1pwm2Gd6+5MCsp2IkB2q7gATL0rCcL5LjxVMcbRqkCQ3ptoEXlc+3riL+NwYH4gdHQQ3WVFA+IhCjoL3cDrdngD37z43dlxx4Oyl6Gj0UckDsgw4k/ziWBxKVZFXtQbmcVUbyzFKtctfjuUNoxdV+eCp5Vhf901mEFASvRziyiaVogDBDxP4pQDMp//xfsIRV3gIq7ChlEbI3NSEjUQO8DgeFRzgLw8euN4ghWR1OLmjKDOQ98VC9RaMcB/4Lii+ANjdSymMGAZgTAAoIBPXx6Gr6DugsoBxAbBp6viNGrkDLRbmLspQonsR5+5f1H38D55gzV0OiIRBcBm9hgQuF+64OWrNuj8Dip7zBwUkpwNpb0dRBPYehwsnHrfBGLBlv08GZtp+qFwwgoJb7KVyqdBhDRDEFqX5OJPY1DFdEEsFBDwr8GokzI0ikG9DCZRjqkvzjXLOwg2M4w+DwcgcaK5wxPV3QqZaxVA/BVvF4LJgq052QBzTAI/MV9sZFUXzqhCJLm8+zCQUbcdb4cpJtsbyDZ1hjdFIOcbOcQQgwIR0mqdrVsQDNINh+qLkSXEEBIj0g9BnWj7od3eIs6SyRfG2H4hz9DOItzFFQiyLbWwfY50HJjEDCOFwZbe1UDutD4Min4NNW6m6E0OxjrAxMpN3eUo1pHeH5I6yD9trUZVdpCyCw7TexzBUvU2KALafgshIiI2pfoBDFBaf914Ilxn6wLQXB865k/aItwJAaqiXiHMOyUIBy4Dd9SMHghbfugXpKFXgp7KRhRkbWl2LZZfdqOduMWHNkW2ruRXbQwHJ+4NvAK7VhXiLCLSTTxu26JOtCogARNG/bbdq88lyRJQBfYNkBEGqEg1PXUi0qv0FVPNrRs3RlJF8wETIsK21YI2BzIbj0oE8R3K3AAoNB9rE9Jqu3CWZZ5HICoz8R2y7V1NI/tIfMK5LcmR31fgYs3RjmkD9uFb/+3EHcUwWWoCDyswecIGgFBUqxU+ybgCUWo5AsPr8I5Cu1VPbH+6QTHQkxb1SsUSklG0JW6ffSBxmwOIgNfkAuKbWutve+kdEFCkiSeVXTe2rb2dcAh2rxZuA+8UY1EMwwlmlsHDQiRg81U2wmPGcSZjEK/TYICiZKDfeAGD9f2jYWLvf27devTg4i1xseseHW9AKXqW3IESgHJEIVqtnVYXGik09Gy7WSwTs51BuR1zu3X3R5ytCkEKcc0iU8pwkwEetZuNY1Mek52sR9xia4NbL3AchpCbWu77msMVVvg/+xJuF4BWgh2KaFgRDm74hnVWhUIF4WG0wJh5gOSXeXAsL25BZqJexxRsBQchfYEQ3MYFEf8rVFYAElT6BILNUyGjjTzOVwaGLxt27IgLNAaPA5A"'&@CRLF
	$sString &='	$bLzmaDll&="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"'&@CRLF
	$sString &='	$bLzmaDll&="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"'&@CRLF
	$sString &='	$bLzmaDll&="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"'&@CRLF
	$sString &='	$bLzmaDll&="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"'&@CRLF
	$sString &='	$bLzmaDll=Binary(_Base64Decode($bLzmaDll))'&@CRLF
	$sString &='	Local $pLzmaDll=MemoryDllOpen($bLzmaDll)'&@CRLF
	$sString &='	Local $pLzmaDllDecGetSize=MemoryDllGetFuncAddress($pLzmaDll,"LzmaDecGetSize")'&@CRLF
	$sString &='	Local $pLzmaDllDec=MemoryDllGetFuncAddress($pLzmaDll,"LzmaDec")'&@CRLF
	$sString &='	Local $Src=DllStructCreate("byte["&BinaryLen($Source)&"]"),$Ret'&@CRLF
	$sString &='	DllStructSetData($Src,1,$Source)'&@CRLF
	$sString &='	$Ret=DllCallAddress("uint:cdecl",$pLzmaDllDecGetSize,"ptr",DllStructGetPtr($Src))'&@CRLF
	$sString &='	If @Error Then Return SetError(1,0,$Source)'&@CRLF
	$sString &='	Local $DestSize=$Ret[0]'&@CRLF
	$sString &='	If $DestSize=0 Then Return SetError(2,0,$Source)'&@CRLF
	$sString &='	Local $Dest=DllStructCreate("byte["&$DestSize&"]")'&@CRLF
	$sString &='	$Ret=DllCallAddress("int:cdecl",$pLzmaDllDec,"ptr",DllStructGetPtr($Dest),"uint*",$DestSize,"ptr",DllStructGetPtr($Src),"uint",BinaryLen($Source))'&@CRLF
	$sString &='	MemoryDllClose($pLzmaDll)'&@CRLF
	$sString &='	If Not @Error Then'&@CRLF
	$sString &='		Return SetExtended($Ret[0],DllStructGetData($Dest,1))'&@CRLF
	$sString &='	Else'&@CRLF
	$sString &='		Return SetError(3,0,$Source)'&@CRLF
	$sString &='	EndIf'&@CRLF
	$sString &='EndFunc'&@CRLF
	$sString&=@CRLF
	$sString &='Func MemoryDllOpen($DllBinary)'&@CRLF
	$sString &='	Local $Call=__MemoryDllCore(0,$DllBinary)'&@CRLF
	$sString &='	Return SetError(@error,0,$Call)'&@CRLF
	$sString &='EndFunc'&@CRLF
	$sString&=@CRLF
	$sString &='Func MemoryDllGetFuncAddress($hModule,$sFuncName)'&@CRLF
	$sString &='	Local $Call=__MemoryDllCore(1,$hModule,$sFuncName)'&@CRLF
	$sString &='	Return SetError(@error,0,$Call)'&@CRLF
	$sString &='EndFunc'&@CRLF
	$sString&=@CRLF
	$sString &='Func MemoryDllClose($hModule)'&@CRLF
	$sString &='	__MemoryDllCore(2,$hModule)'&@CRLF
	$sString &='	Return SetError(@error)'&@CRLF
	$sString &='EndFunc'&@CRLF
	$sString&=@CRLF
	$sString &='Func __MemoryDllCore($iCall,ByRef $Mod_Bin,$sFuncName=0)'&@CRLF
	$sString &='	Local Static $_MDCodeBuffer,$_MDLoadLibrary,$_MDGetFuncAddress,$_MDFreeLibrary,$GetProcAddress,$LoadLibraryA,$fDllInit=False'&@CRLF
	$sString &='	If Not $fDllInit Then'&@CRLF
	$sString &="		If @AutoItX64 Then Exit(MsgBox(16,'Error-x64','x64 Not Supported! '&@LF&@LF&'Download newest version for x64 support'))"&@CRLF
	$sString &='		Local $Opcode="0xFFFFFFFFFFFFFFFFB800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE0B800000000FFE05589E55156578B7D088B750C8B4D10FCF3A45F5E595DC35589E5578B7D088A450C8B4D10F3AA5F5DC359585A5153E8000000005B81EBAB114000898300114000899304114000E8000000005981E9C3114000518B9100114000E80B0000007573657233322E646C6C005850FFD2598B9104114000E80C0000004D657373616765426F784100595150FFD2898372114000E8000000005981E90D124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80A0000006C737472636D70694100595150FFD2898309114000E8000000005981E957124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D0000005669727475616C416C6C6F6300595150FFD2898310114000E8000000005981E9A4124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C0000005669727475616C4672656500595150FFD2898317114000E8000000005981E9F0124000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F0000005669727475616C50726F7465637400595150FFD289831E114000E8000000005981E93F134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80E00000052746C5A65726F4D656D6F727900595150FFD2898325114000E8000000005981E98D134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D0000004C6F61644C6962726172794100595150FFD289832C114000E8000000005981E9DA134000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F00000047657450726F634164647265737300595150FFD2898333114000E8000000005981E929144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80D00000049734261645265616450747200595150FFD289833A114000E8000000005981E976144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80F00000047657450726F636573734865617000595150FFD2898341114000E8000000005981E9C5144000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80A00000048656170416C6C6F6300"'&@CRLF
	$sString &='		$Opcode&="595150FFD2898348114000E8000000005981E90F154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E809000000486561704672656500595150FFD289834F114000E8000000005981E958154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C000000476C6F62616C416C6C6F6300595150FFD2898356114000E8000000005981E9A4154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80E000000476C6F62616C5265416C6C6F6300595150FFD2898364114000E8000000005981E9F2154000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80B000000476C6F62616C4672656500595150FFD289835D114000E8000000005981E93D164000518B9100114000E80D0000006B65726E656C33322E646C6C005850FFD2598B9104114000E80C000000467265654C69627261727900595150FFD289836B1140005B59585150E80E04000059C35990585A515250E8CC0500005A5AC35A585250E88E06000059C35589E557565383EC1C8B45108B40048945EC8B55108B020FB750148D740218C745F00000000066837806000F84B0000000837E1000754C8B450C8B583885DB0F8E84000000C744240C04000000C744240800100000895C24048B45EC03460C890424E8FEF9FFFF83EC10894608895C2408C744240400000000890424E864FAFFFFEB46C744240C04000000C7442408001000008B4610894424048B45EC03460C890424E8BDF9FFFF83EC1089C78B55080356148B46108944240889542404893C24E808FAFFFF897E08FF45F083C6288B55108B020FB740063B45F00F8F50FFFFFF8D65F45B5E5F5DC35589E557565383EC1C8B55088B020FB750148D5C0218BF0000000066837806000F84E80000008B432489C2C1EA1D89D683E60189C2C1EA1E83E20189C1C1E91FA9000000027422C7442408004000008B4310894424048B4308890424E822F9FFFF83EC0CE99000000085F6741E85D2740D83F90119D283E2E083C240EB2983F90119D283E29083EA80EB1C85D2740D83F90119D283E2FE83C204EB0B83F90119D283E2F983C208F6432704740681CA000200008B4B1085C97522F6432440740A8B4D088B018B4820EB0EF643248074088B4D088B018B482485C9741D8D45F08944240C89542408894C24048B4308890424E894F8FFFF83EC104783C3288B55088B020FB7400639F80F8F18FFFFFF8D65F45B5E5F5DC35589E557565383EC048B45088B50048955F08B0083B8A400000000745789D30398A0000000833B00744A8B7DF0033B8D4B08BE000000008B430483E808D1E883F80076280FB70189C2C1EA0C25FF0F000083FA037506"'&@CRLF
	$sString &='		$Opcode&="8B550C0114074683C1028B430483E808D1E839F077D8035B04833B0075B683C4045B5E5F5DC35589E557565383EC1CC745F0010000008B45088B40048945EC8B55088B0283B884000000000F84410100008B7DEC03B880000000E9120100008B45EC03470C890424E8BFF7FFFF83EC048945E883F8FF750CC745F000000000E90E0100008B4D0883790800742EC7442408400000008B410C8D048504000000894424048B4108890424E8B6F7FFFF83EC0C8B550889420885C075268B4D088B410C8D04850400000089442404C7042440000000E87EF7FFFF83EC088B55088942088B4D088B510C8B41088B4DE8890C908B4508FF400C833F0074168B5DEC031F8B75EC037710EB11C745F000000000EB578B5DEC035F1089DE833B00744A833B0079190FB703894424048B55E8891424E8FEF6FFFF83EC088906EB1C8B45EC030383C002894424048B4DE8890C24E8E0F6FFFF83EC088906833E0074AB83C30483C604833B0075B6837DF000742483C714C744240414000000893C24E8B9F6FFFF83EC0885C0750A837F0C000F85CDFEFFFF8B45F08D65F45B5E5F5DC35589E557565383EC1C8B45088945F0B8000000008B550866813A4D5A0F85A20100008B75088B45F003703CB800000000813E504500000F8588010000C744240C04000000C7442408002000008B4650894424048B4634890424E815F6FFFF83EC1089C785C07535C744240C04000000C7442408002000008B465089442404C7042400000000E8E9F5FFFF83EC1089C7B80000000085FF0F8428010000E803F6FFFFC744240814000000C744240400000000890424E8F2F5FFFF83EC0C89C3897804C7400C00000000C7400800000000C7401000000000C744240C04000000C7442408001000008B465089442404893C24E87EF5FFFF83EC10C744240C04000000C7442408001000008B465489442404893C24E85CF5FFFF83EC108945EC8B55F08B423C03465489442408895424048B45EC890424E8A3F5FFFF8B45EC8B55F003423C8903897834895C2408897424048B4508890424E8B4FAFFFF89F82B4634740C89442404891C24E8A0FCFFFF891C24E814FDFFFF85C0743E891C24E876FBFFFF8B0383782800742A89FA0350287427C744240800000000C744240401000000893C24FFD283EC0C85C0740BC743100100000089D8EB0D891C24E8DB000000B8000000008D65F45B5E5F5DC35589E583EC28895DF48975F8897DFC8B45088B50048955F0C745ECFFFFFFFF8B1083C278B800000000837A04000F848E0000008B5DF0031A837B18007406837B1400750FB800000000EB760FB73F897DECEB458B75F00373208B7DF0037B24C745E800000000837B1800762C8B45F00306894424048B450C890424E820F4FFFF83EC0885C074C4FF45E883C60483C7028B55E839531877"'&@CRLF
	$sString &='		$Opcode&="D4B800000000837DECFF741EB8000000008B55EC3B531477118B45ECC1E00203431C8B55F003141089D08B5DF48B75F88B7DFC89EC5DC35589E5565383EC108B750885F60F84AC000000837E1000742A8B068B56048B48288D040AC744240800000000C744240400000000891424FFD083EC0CC7461000000000837E08007436BB00000000837E0C007E1D8B4608833C98FF740E8B0498890424E8CCF3FFFF83EC0443395E0C7FE38B4608890424E8AAF3FFFF83EC04837E0400741EC744240800800000C7442404000000008B4604890424E840F3FFFF83EC0CE862F3FFFF89742408C744240400000000890424E85CF3FFFF83EC0C8D65F85B5E5DC3"'&@CRLF
	$sString &='		$_MDCodeBuffer=DllStructCreate("byte["&BinaryLen($Opcode)&"]")'&@CRLF
	$sString &='		DllCall("kernel32.dll","bool","VirtualProtect","struct*",$_MDCodeBuffer,"dword_ptr",DllStructGetSize($_MDCodeBuffer),"dword",0x00000040,"dword*",0)'&@CRLF
	$sString &='		DllStructSetData($_MDCodeBuffer,1,$Opcode)'&@CRLF
	$sString &='		Local $pMDCodeBuffer=DllStructGetPtr($_MDCodeBuffer)'&@CRLF
	$sString &='		$_MDLoadLibrary=$pMDCodeBuffer+(StringInStr($Opcode,"59585A51")-1)/2-1'&@CRLF
	$sString &='		$_MDGetFuncAddress=$pMDCodeBuffer+(StringInStr($Opcode,"5990585A51")-1)/2-1'&@CRLF
	$sString &='		$_MDFreeLibrary=$pMDCodeBuffer+(StringInStr($Opcode,"5A585250")-1)/2-1'&@CRLF
	$sString &='		Local $Ret=DllCall("kernel32.dll","hwnd","LoadLibraryA","str","kernel32.dll")'&@CRLF
	$sString &='		$GetProcAddress=DllCall("kernel32.dll","uint","GetProcAddress","hwnd",$Ret[0],"str","GetProcAddress")'&@CRLF
	$sString &='		$LoadLibraryA=DllCall("kernel32.dll","uint","GetProcAddress","hwnd",$Ret[0],"str","LoadLibraryA")'&@CRLF
	$sString &='		$fDllInit=True'&@CRLF
	$sString &='	EndIf'&@CRLF
	$sString &='	Switch $iCall'&@CRLF
	$sString &='		Case 0'&@CRLF
	$sString &='			Local $DllBuffer=DllStructCreate("byte["&BinaryLen($Mod_Bin)&"]")'&@CRLF
	$sString &='			DllCall("kernel32.dll","bool","VirtualProtect","struct*",$DllBuffer,"dword_ptr",DllStructGetSize($DllBuffer),"dword",0x00000040,"dword*",0)'&@CRLF
	$sString &='			DllStructSetData($DllBuffer,1,$Mod_Bin)'&@CRLF
	$sString &='			Local $Module=DllCallAddress("uint",$_MDLoadLibrary,"uint",$LoadLibraryA[0],"uint",$GetProcAddress[0],"struct*",$DllBuffer)'&@CRLF
	$sString &='			If $Module[0]=0 Then Return SetError(1,0,0)'&@CRLF
	$sString &='			Return $Module[0]'&@CRLF
	$sString &='		Case 1'&@CRLF
	$sString &='			Local $Address=DllCallAddress("uint",$_MDGetFuncAddress,"uint",$Mod_Bin,"str",$sFuncName)'&@CRLF
	$sString &='			If $Address[0]=0 Then Return SetError(1,0,0)'&@CRLF
	$sString &='			Return $Address[0]'&@CRLF
	$sString &='		Case 2'&@CRLF
	$sString &='			Return DllCallAddress("none",$_MDFreeLibrary,"uint",$Mod_Bin)'&@CRLF
	$sString &='	EndSwitch'&@CRLF
	$sString &='EndFunc'&@CRLF
	Return $sString
EndFunc ;==> _StringAddLzmaDec()

Func _StringAddLzntDecompress()
	Local $sString=@CRLF
	$sString&='Func _LzntDecompress($bBinary); by trancexx'&@CRLF
	$sString&='    $bBinary=Binary($bBinary)'&@CRLF
	$sString&="    Local $tInput=DllStructCreate('byte['&BinaryLen($bBinary)&']')"&@CRLF
	$sString&='    DllStructSetData($tInput,1,$bBinary)'&@CRLF
	$sString&="    Local $tBuffer=DllStructCreate('byte['&16*DllStructGetSize($tInput)&']')"&@CRLF ; initially oversizing buffer
	$sString&="    Local $a_Call=DllCall('ntdll.dll','int','RtlDecompressBuffer','ushort',2,'ptr',DllStructGetPtr($tBuffer),'dword',DllStructGetSize($tBuffer),'ptr',DllStructGetPtr($tInput),'dword',DllStructGetSize($tInput),'dword*',0)"&@CRLF
	$sString&="    If @error Or $a_Call[0] Then Return SetError(1,0,'')"&@CRLF ; error decompressing
	$sString&="    Local $tOutput=DllStructCreate('byte['&$a_Call[6]&']',DllStructGetPtr($tBuffer))"&@CRLF
	$sString&='    Return SetError(0,0,DllStructGetData($tOutput,1))'&@CRLF
	$sString&='EndFunc ;==> _LzntDecompress()'&@CRLF
	Return $sString
EndFunc ;==> _StringAddLzntDecompress()

Func _StringBetween($s_String,$s_Start,$s_End,$v_Case=-1)
	Local $s_case=''
	If $v_Case=Default Or $v_Case=-1 Then $s_case='(?i)'
	Local $s_pattern_escape='(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
	$s_Start=StringRegExpReplace($s_Start,$s_pattern_escape,'\\$1')
	$s_End=StringRegExpReplace($s_End,$s_pattern_escape,'\\$1')
	If $s_Start='' Then $s_Start='\A'
	If $s_End='' Then $s_End='\z'
	Local $a_ret=StringRegExp($s_String,'(?s)'&$s_case&$s_Start&'(.*?)'&$s_End,3)
	If @error Then Return SetError(1,0,0)
	Return $a_ret
EndFunc ;==> _StringBetween()

Func _StringProper($s_String)
	Local $iX=0,$CapNext=1,$s_nStr='',$s_CurChar
	For $iX=1 To StringLen($s_String)
		$s_CurChar=StringMid($s_String,$iX,1)
		Select
			Case $CapNext=1
				If StringRegExp($s_CurChar,'[a-zA-ZÀ-ÿšœžŸ]') Then
					$s_CurChar=StringUpper($s_CurChar)
					$CapNext=0
				EndIf
			Case Not StringRegExp($s_CurChar,'[a-zA-ZÀ-ÿšœžŸ]')
				$CapNext=1
			Case Else
				$s_CurChar=StringLower($s_CurChar)
		EndSelect
		$s_nStr&=$s_CurChar
	Next
	Return $s_nStr
EndFunc ;==> _StringProper()

Func _TrayMenuSet()
	TraySetIcon($sTempDir&'\Win.ico')
	TraySetClick(16)
	TraySetState(4)
	TraySetToolTip($sSoftTitle)
EndFunc

Func _TrayTip($sTitle= ' ',$sTexte= '...',$iIcon=0,$iTimeout=3000)
	TrayTip($sTitle,$sTexte,$iTimeout,$iIcon)
	AdlibRegister('_TrayTipTimer',$iTimeout)
EndFunc

Func _TrayTipTimer()
	TrayTip('','',1,1)
	AdlibUnRegister('_TrayTipTimer')
EndFunc

Func _Winico($sFileName,$sOutputDirPath,$iOverWrite=0)
	Local $sFileBin="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"
	$sFileBin&="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"
	$sFileBin&="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"
	$sFileBin&="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"
	$sFileBin&="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"
	$sFileBin=Binary(_Base64Decode($sFileBin))
	$sFileBin=Binary(_LZMADec($sFileBin))
	If Not FileExists($sOutputDirPath) Then DirCreate($sOutputDirPath)
	If StringRight($sOutputDirPath,1)<>'\' Then $sOutputDirPath&='\'
	Local $sFilePath=$sOutputDirPath&$sFileName
	If FileExists($sFilePath) Then
		If $iOverWrite=1 Then
			If Not Filedelete($sFilePath) Then Return SetError(2,0,$sFileBin)
		Else
			Return SetError(0,0,$sFileBin)
		EndIf
	EndIf
	Local $hFile=FileOpen($sFilePath,16+2)
	If $hFile=-1 Then Return SetError(3,0,$sFileBin)
	FileWrite($hFile,$sFileBin)
	FileClose($hFile)
	Return SetError(0,0,$sFileBin)
EndFunc ;==> _Winico()