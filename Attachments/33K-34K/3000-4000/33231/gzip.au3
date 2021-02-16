#include-once
Local $gz_exe=@ScriptDir&'\gzip.exe'
Local $gz_exe_temp=@TempDir&'\gzip.exe'
If Not FileExists($gz_exe) Then $gz_exe = @ScriptDir&'\gzip.dll'
If Not FileExists($gz_exe) Then $gz_exe = @ScriptDir&'\Include\gzip.exe'	
If Not FileExists($gz_exe) Then
	Exit MsgBox(16,'File Missing',$gz_exe)
Else
	FileCopy($gz_exe,$gz_exe_temp,1)
	If FileExists($gz_exe_temp) Then $gz_exe=$gz_exe_temp
EndIf

Func _gzDecompress($gzBinary)
	Local $gz_input
	If StringLeft($gzBinary,2)='0x' Then
		$gz_input=@TempDir&'\~temp'&Random(10000,99999,1)&'.gz'
		FileWrite($gz_input,$gzBinary)
	Else
		Return SetError(1,'',$gzBinary)
	EndIf
	Local $gz_output=StringTrimRight($gz_input,3)
	Local $gz_clean[2]=[FileDelete($gz_output)]
	Local $gz_pid=Run($gz_exe&' -dfq9 '&$gz_input,'',@SW_HIDE)
	Local $gz_init=TimerInit()
		Do
		Until Not ProcessExists($gz_pid) Or Sleep(10)=0 Or TimerDiff($gz_init)>5000
	Local $gz_read=FileRead($gz_output)
	Local $gz_clean[2]=[FileDelete($gz_input),FileDelete($gz_output)]
	If $gz_read='' Then Return SetError(1,'','')
	Return SetError(0,'',$gz_read)
EndFunc