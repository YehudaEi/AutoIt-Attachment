#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=D:\wmi\icons\network.ico
#AutoIt3Wrapper_outfile=c_whois.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=MicroWorld
#AutoIt3Wrapper_Res_Description=Whois Client
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright � MicroWorld Technologies INC
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=CompanyName|MicroWorld Technologies INC
#AutoIt3Wrapper_Res_Field=ProductName|Whois Client
#AutoIt3Wrapper_Res_Field=InternalName|Whois Client
#AutoIt3Wrapper_Res_Field=ProductVersion|1.0.0
#AutoIt3Wrapper_Res_Field=LegalTrademarks|
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>
#include "_WhoIs.au3"
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <Date.au3>

Opt("TCPTimeout", 100)
resource()
#region ### START Koda GUI section ###
Global $Form1 = GUICreate("WhoIs", 404, 445, -1, -1)
Global $Label1 = GUICtrlCreateLabel("Domain:", 5, 7, 43, 17)
Global $txtDomain = GUICtrlCreateInput("", 48, 4, 273, 21)
Global $btnSearch = GUICtrlCreateButton("Search", 332, 4, 65, 25, $BS_DEFPUSHBUTTON)
Global $btnExit = GUICtrlCreateButton("Exit", 332, 48, 65, 25)
Global $txtResults = GUICtrlCreateEdit("", 4, 80, 393, 357, BitOR($ES_AUTOVSCROLL, $WS_VSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
GUICtrlSetData(-1, "")
GUICtrlSetFont(-1, 8, 400, 0, "Courier")
Global $Label2 = GUICtrlCreateLabel("Query Time :", 5, 32, 312, 17)
Global $Label3 = GUICtrlCreateLabel("Domain Analysis :", 4, 56, 152, 17)
Global $Label4 = GUICtrlCreateLabel("Domain Created on :", 164, 56, 156, 17)
#endregion ### END Koda GUI section ###
GUISetState(@SW_SHOW)
_setOriginalGUI()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btnExit
			Exit
		Case $btnSearch
			_setBusyGUI()
			$begin = TimerInit()
			$retWhoIS = _WhoIs(GUICtrlRead($txtDomain))
			If StringInStr($retWhoIS, 'Last update', 2) <> 0 Then
				$string = StringMid($retWhoIS, StringInStr($retWhoIS, 'Last update', 2))
				$string = StringMid($string,1,StringInStr($string,@CR))
				$retWhoIS=StringReplace($retWhoIS,$string&@LF,'')
			EndIf
			$test = StringRegExp($retWhoIS, '([\d]{4}(-|/|\.|\. )[\d]{2}(-|/|\.|\. )[\d]{2})', 3)
			If IsArray($test) Then
				date_strip($test, 2, 3, 1, 0)
			Else
				$test = StringRegExp($retWhoIS, '([\d]{4}(-|/|\.)[\D]{3}(-|/|\.)[\d]{2})', 3)
				If IsArray($test) Then
					date_strip($test, 0, 2, 1, 3)
				Else
					$test = StringRegExp($retWhoIS, '([\d]{2}(-|/|\.| )[\D]{3}(-|/|\.| )[\d]{4})', 3)
					If IsArray($test) Then
						date_strip($test, 0, 2, 3, 1)
					Else
						$test = StringRegExp($retWhoIS, '([\d]{2}(-|/|\.)[\D]{3}(-|/|\.)[\d]{2})', 3)
						If IsArray($test) Then
							date_strip($test, 0, 2, 0, 0)
						Else
							$test = StringRegExp($retWhoIS, '([\d]{2}(-|/|\.)[\d]{2}(-|/|\.)[\d]{4})', 3) ;(!\+)
							If IsArray($test) Then
								date_strip($test, 1, 2, 3, 0)
							Else
								$test = StringRegExp($retWhoIS, '([\D]{3}( |,)[\d]{2}(, | )[\d]{4})', 3)
								If IsArray($test) Then
									$i = 0
									While $i <= UBound($test) - 1
										$test[$i] = StringReplace($test[$i], ',', '')
										$i += 1
									WEnd
									date_strip($test, 0, 1, 3, 2)
								Else
									$test = StringRegExp(StringReplace($retWhoIS, ' GMT ', ''), '([\D]{3}(-| )[\d]{2}(-| )[\d]{4})', 3) ;(!\+)
									If IsArray($test) Then
										date_strip($test, 0, 1, 3, 2)
									Else
										If StringInStr($retWhoIS, 'found', 2) == 0 And StringInStr($retWhoIS, 'match', 2) == 0 And StringInStr($retWhoIS, 'invalid', 2) == 0 Then
											GUICtrlSetData($Label3, 'Domain Analysis : 0')
											GUICtrlSetData($Label4, 'Domain Created on : NA')
										Else
											GUICtrlSetData($Label3, 'Domain Analysis : NF')
											GUICtrlSetData($Label4, 'Domain Created on : NF')
										EndIf
									EndIf
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			GUICtrlSetData($Label2, "Query Time : " & TimerDiff($begin) / 1000 & ' secs')

			GUICtrlSetData($txtResults, $retWhoIS)
			GUICtrlSetState($txtResults, $GUI_ENABLE)
			GUICtrlSetState($btnExit, $GUI_ENABLE)
	EndSwitch
	If GUICtrlRead($txtDomain) <> "" And GUICtrlGetState($btnSearch) = 144 Then
		GUICtrlSetState($btnSearch, $GUI_ENABLE)
	EndIf
WEnd

Func date_strip($test, $j, $k, $m, $z) ; need the date format
	Local $i = 0, $n = 0, $o = 0, $delimit, $y = 0
	Local $test_ar
	Dim $test_temp[1]
	Dim $dateformat[3]
	Dim $month[12] = ["jan", "feb", "mar", "apr", "may", "jun", 'jul', 'aug', 'sep', 'oct', 'nov', 'dec']
	While $i <= UBound($test) - 1
		If StringLen($test[1]) == 2 Then
			$test_ar = StringSplit($test[$i], StringStripWS($test[1], 8), 1)
		ElseIf StringLen($test[1]) == 1 Then
			$test_ar = StringSplit($test[$i], $test[$i + 1], 1)
		Else
		EndIf
		If $j <> 0 And $m <> 0 Then
			If $test_ar[$j] > 12 Then
				ReDim $test_temp[$o + 1]
				$date = StringStripWS($test_ar[$m], 8) & '/' & StringStripWS($test_ar[$k], 8) & '/' & StringStripWS($test_ar[$j], 8)
				$test_temp[$o] = $date
				$o += 1
				$dateformat[$k - 1] = 'mm'
				$dateformat[$j - 1] = 'dd'
				$dateformat[$m - 1] = 'yyyy'
				$delimit = $test[1]
			ElseIf $test_ar[$k] > 12 Then
				ReDim $test_temp[$o + 1]
				$date = StringStripWS($test_ar[$m], 8) & '/' & StringStripWS($test_ar[$j], 8) & '/' & StringStripWS($test_ar[$k], 8)
				$test_temp[$o] = $date
				$o += 1
				$dateformat[$j - 1] = 'mm'
				$dateformat[$k - 1] = 'dd'
				$dateformat[$m - 1] = 'yyyy'
				$delimit = $test[1]
			Else
				ReDim $test_temp[$o + 1]
				$date = StringStripWS($test_ar[$m], 8) & '/' & StringStripWS($test_ar[$j], 8) & '/' & StringStripWS($test_ar[$k], 8)
				$test_temp[$o] = $date
				$o += 1
				$dateformat[$j - 1] = 'mm'
				$dateformat[$k - 1] = 'dd'
				$dateformat[$m - 1] = 'yyyy'
				$delimit = $test[1]
			EndIf
		ElseIf $j == 0 And $m <> 0 Then ; 'mon'
			$dateformat[$m - 1] = 'yyyy'
			$dateformat[$k - 1] = 'mon'
			$dateformat[$z - 1] = 'dd'
			ReDim $test_temp[$o + 1]
			$date = StringStripWS($test_ar[$m], 8) & '/' & _ArraySearch($month, StringStripWS($test_ar[$k], 8), '', '', 0) + 1 & '/' & StringStripWS($test_ar[$z], 8)
			$test_temp[$o] = $date
			$delimit = $test[1]
			$o += 1
		ElseIf $j == 0 And $m == 0 Then
			ReDim $test_temp[$o + 1]
			$date = StringStripWS($test_ar[1], 8) & '/' & _ArraySearch($month, StringStripWS($test_ar[2], 8), '', '', 0) + 1 & '/' & StringStripWS($test_ar[3], 8)
			$test_temp[$o] = $date
			$o += 1
			$dateformat[0] = 'dd'
			$dateformat[1] = 'mon'
			$dateformat[2] = 'yy'
			$delimit = $test[1]
			$y = 1
		EndIf
		$i += 3
	WEnd
	If $y = 1 Then
		Dim $test_index[UBound($test_temp)]
		$i = 0
		While $i <= UBound($test_temp) - 1
			$test_index[$i] = StringLeft($test_temp[$i], StringInStr($test_temp[$i], '/', 2, 2) - 1)
			$i += 1
		WEnd
		$index = _ArraySearch($test_index, $test_index[0], 1)
		If $index <> -1 Then
			$dateformat[0] = 'dd'
			$dateformat[1] = 'mon'
			$dateformat[2] = 'yy'
			$i = 0
			While $i <= UBound($test_temp) - 1
				$test_temp[$i] = '20' & StringRight($test_temp[$i], 2) & StringMid($test_temp[$i], StringInStr($test_temp[$i], '/', 2, 1), StringInStr($test_temp[$i], '/', 2, 1)) & '/'&StringLeft($test_temp[$i], 2)
				$i += 1
			WEnd
			$j = 1
		Else
			$i = 0
			Dim $test_index_micro[UBound($test_index)]
			While $i <= UBound($test_index) - 1
				$test_index_micro[$i] = StringLeft($test_index[$i], StringInStr($test_index[$i], '/') - 1)
				$i += 1
			WEnd
			$m = 0
			For $k = -2 To 2 Step 1
				$index = _ArraySearch($test_index, ($test_index_micro[0] + $k) & StringRight($test_index[0], StringInStr($test_index[0], '/') - 1), 1)
				$m += 1
				If $index <> -1 Then
					$dateformat[0] = 'dd'
					$dateformat[1] = 'mon'
					$dateformat[2] = 'yy'
					$i = 0
					While $i <= UBound($test_temp) - 1
						$test_temp[$i] = '20' & StringRight($test_temp[$i], 2) & StringMid($test_temp[$i], StringInStr($test_temp[$i], '/', 2, 1), StringInStr($test_temp[$i], '/', 2, 1)) & StringLeft($test_temp[$i], 2)
						$i += 1
					WEnd
					$j = 1
					ExitLoop
				Else
					$j = 0
				EndIf
			Next
		EndIf
		If $j == 0 Then
			$i = 0
			While $i <= UBound($test_temp) - 1
				$test_index[$i] = StringRight($test_temp[$i], StringInStr($test_temp[$i], '/', 2, 2) - 1)
				$i += 1
			WEnd
			$index = _ArraySearch($test_index, $test_index[0], 1)
			If $index <> -1 Then
				$dateformat[0] = 'yy'
				$dateformat[1] = 'mon'
				$dateformat[2] = 'dd'
				$i = 0
				While $i <= UBound($test_temp) - 1
					$test_temp[$i] = '20' & $test_temp[$i]
					$i += 1
				WEnd
			Else
				$i = 0
				Dim $test_index_micro[UBound($test_index)]
				While $i <= UBound($test_index) - 1
					$test_index_micro[$i] = StringLeft($test_index[$i], StringInStr($test_index[$i], '/') - 1)
					$i += 1
				WEnd
				$m = 0
				For $k = -2 To 2 Step 1
					$index = _ArraySearch($test_index, ($test_index_micro[0] + $k) & StringLeft($test_index[0], StringInStr($test_index[0], '/') - 1), 1)
					$m += 1
					If $index <> -1 Then
						$dateformat[0] = 'dd'
						$dateformat[1] = 'mon'
						$dateformat[2] = 'yy'
						$i = 0
						While $i <= UBound($test_temp) - 1
							$test_temp[$i] = '20' & $test_temp[$i]
							MsgBox(0, '', $test_temp[$i])
							$i += 1
						WEnd
						$j = 1
						ExitLoop
					EndIf
				Next
			EndIf
		EndIf
	Else
		_ArraySort($test_temp)
	EndIf
	If IsArray($test_temp) Then
		GUICtrlSetData($Label4, 'Domain Created on ' & $test_temp[0])
		$date_diff = _DateDiff('M', $test_temp[0], @YEAR & '/' & @MON & '/' & @MDAY)
		If @error == 0 Then
			Select
				Case $date_diff <= 6
					GUICtrlSetData($Label3, 'Domain Analysis : 10 ');& $date_diff)
				Case $date_diff > 6 And $date_diff <= 12
					GUICtrlSetData($Label3, 'Domain Analysis : 20 ');& $date_diff)
				Case $date_diff > 12
					GUICtrlSetData($Label3, 'Domain Analysis : 30 ');& $date_diff)
			EndSelect
		Else
			GUICtrlSetData($Label3, 'Domain Analysis : 0 ')
			GUICtrlSetData($Label4, 'Domain Created on : 0/0/0')
		EndIf
	Else
		GUICtrlSetData($Label4, 'Domain Created on : Confusion')
	EndIf
EndFunc   ;==>date_strip

Func _setOriginalGUI()
	GUICtrlSetState($btnSearch, $GUI_DISABLE)
	GUICtrlSetState($txtResults, $GUI_DISABLE)
	GUICtrlSetState($txtDomain, $GUI_FOCUS)
EndFunc   ;==>_setOriginalGUI

Func _setBusyGUI()
	GUICtrlSetState($btnSearch, $GUI_DISABLE)
	GUICtrlSetState($txtResults, $GUI_DISABLE)
	GUICtrlSetState($btnExit, $GUI_DISABLE)
	GUICtrlSetData($Label3, 'Domain Analysis : ')
	GUICtrlSetData($Label4, 'Domain Created on : ')
	GUICtrlSetData($Label2, 'Query Time : ')
EndFunc   ;==>_setBusyGUI

Func resource()
	_Crypt_Startup()
	$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
	If StringCompare($hash, IniRead('hash.ini', 'md5', 'sTLD.ini', 0)) <> 0 Then
		SplashTextOn('', 'Creating sTLD Database', 200, 50)
		RunWait(@ComSpec & ' /c wget                                                                                         -O sTLD.txt', @ScriptDir, @SW_HIDE)
		$hash = _Crypt_HashFile('sTLD.txt', $CALG_MD5)
		If StringCompare($hash, IniRead('hash.ini', 'md5', 'sTLD.txt', 0)) <> 0 Or StringCompare($hash, IniRead('hash.ini', 'md5', 'sTLD.ini', 0)) <> 0 Then ;FileExists('sTLD.ini') == 0  Then
			FileDelete('stld.ini')
			IniWrite('hash.ini', 'md5', 'sTLD.txt', $hash)
			$f_count = _FileCountLines('sTLD.txt')
			$file = FileOpen('sTLD.txt', 16384)
			$line_count = 1
			While $line_count <= $f_count
				$line = StringStripWS(FileReadLine($file, $line_count), 8)
				$str = StringLeft($line, 1)
				Select
					Case $str = '/'
					Case $str = '*'
						$str_arr = StringSplit(StringTrimLeft($line, 1), '.', 1)
						IniWrite('stld.ini', $str_arr[$str_arr[0]], StringTrimLeft($line, 2), '*')
					Case $str = '!'
						$str_arr = StringSplit(StringTrimLeft($line, 1), '.', 1)
						IniWrite('stld.ini', $str_arr[$str_arr[0]], StringTrimLeft($line, 2), '!')
					Case Else
						$str_arr = StringSplit($line, '.', 1)
						If $str_arr[$str_arr[0]] <> '' Then
							IniWrite('stld.ini', $str_arr[$str_arr[0]], $line, '0')
						EndIf
				EndSelect
				$line_count += 1
			WEnd
			FileClose($file)
		EndIf
		RunWait(@ComSpec & ' /c wget                                              -O domainroots.txt', @ScriptDir, @SW_HIDE)
		$hash = _Crypt_HashFile('domainroots.txt', $CALG_MD5)
		If StringCompare($hash, IniRead('hash.ini', 'md5', 'domainroots.txt', 0)) <> 0 Then
			IniWrite('hash.ini', 'md5', 'domainroots.txt', $hash)
			$f_count = _FileCountLines('domainroots.txt')
			$file = FileOpen('domainroots.txt', 16384)
			$line_count = 1
			While $line_count <= $f_count
				$line = StringStripWS(FileReadLine($file, $line_count), 8)
				$str_arr = StringSplit($line, '.', 1)
				If $str_arr[$str_arr[0]] <> 'com' Then
					If IniRead('stld.ini', $str_arr[$str_arr[0]], $line, '') == '' Then
						IniWrite('stld.ini', $str_arr[$str_arr[0]], $line, '!')
					EndIf
				EndIf
				$line_count += 1
			WEnd
			FileClose($file)
		EndIf
		$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
		IniWrite('hash.ini', 'md5', 'sTLD.ini', $hash)
		_Crypt_Shutdown()
		FileDelete('sTLD.txt')
		FileDelete('domainroots.txt')
		SplashOff()
	EndIf
EndFunc   ;==>resource