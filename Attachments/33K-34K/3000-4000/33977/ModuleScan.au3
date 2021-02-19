#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=..\..\..\..\My Documentss\Documents.ico
#AutoIt3Wrapper_Res_Comment=VZ Software Development
#AutoIt3Wrapper_Res_Description=Windows Utilities
#AutoIt3Wrapper_Res_Field=Version|2.0.0.0
#AutoIt3Wrapper_Res_Field=Update|17/5/2011
#AutoIt3Wrapper_Res_Field=Tac gia|VZ Software Development
#AutoIt3Wrapper_Res_Field=Lien lac|wuhelp@yahoo.com.vn
#AutoIt3Wrapper_Res_Field=Website|                  -                     
#AutoIt3Wrapper_Res_Field=Module|ModuleScan.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
FileInstall('language.txt',@ScriptDir&'\language.txt',1)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text11',''))
_ReduceMemory()
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListView.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <_ControlHover.au3>
#include <Icons.au3>
#include <File.au3>
#include <INet.au3>
#include <Crypt.au3>
#include <Misc.au3>
if _Singleton("WU Scan",1) = 0 Then
    Exit
EndIf
DirCreate(@ScriptDir&'\Data\Picture')
FileInstall('AutoGUI.bmp',@ScriptDir&'\Data\Picture\AutoGUI.bmp',1)
FileInstall('B1.gif',@ScriptDir&'\Data\Picture\B1.gif',1)
FileInstall('B2.gif',@ScriptDir&'\Data\Picture\B2.gif',1)
FileInstall('B3.gif',@ScriptDir&'\Data\Picture\B3.gif',1)
FileInstall('BQ.png',@ScriptDir&'\Data\Picture\BQ.png',1)
FileInstall('Check.png',@ScriptDir&'\Data\Picture\Check.png',1)
FileInstall('EM.png',@ScriptDir&'\Data\Picture\EM.png',1)
FileInstall('EXIT1.bmp',@ScriptDir&'\Data\Picture\EXIT1.bmp',1)
FileInstall('EXIT2.bmp',@ScriptDir&'\Data\Picture\EXIT2.bmp',1)
FileInstall('MB.png',@ScriptDir&'\Data\Picture\MB.png',1)
FileInstall('menu1-1.png',@ScriptDir&'\Data\Picture\menu1-1.png',1)
FileInstall('menu1.png',@ScriptDir&'\Data\Picture\menu1.png',1)
FileInstall('Menu2-1.png',@ScriptDir&'\Data\Picture\Menu2-1.png',1)
FileInstall('Menu2.png',@ScriptDir&'\Data\Picture\Menu2.png',1)
FileInstall('Menu3-1.png',@ScriptDir&'\Data\Picture\Menu3-1.png',1)
FileInstall('Menu3.png',@ScriptDir&'\Data\Picture\Menu3.png',1)
FileInstall('Menu4-1.png',@ScriptDir&'\Data\Picture\Menu4-1.png',1)
FileInstall('Menu4.png',@ScriptDir&'\Data\Picture\Menu4.png',1)
FileInstall('MMZ1.bmp',@ScriptDir&'\Data\Picture\MMZ1.bmp',1)
FileInstall('MMZ2.bmp',@ScriptDir&'\Data\Picture\MMZ2.bmp',1)
FileInstall('protect.png',@ScriptDir&'\Data\Picture\protect.png',1)
FileInstall('S1.png',@ScriptDir&'\Data\Picture\S1.png',1)
FileInstall('S2.png',@ScriptDir&'\Data\Picture\S2.png',1)
FileInstall('S3.png',@ScriptDir&'\Data\Picture\S3.png',1)
FileInstall('Search-icon.gif',@ScriptDir&'\Data\Picture\Search-icon.gif',1)
FileInstall('Search-icon.png',@ScriptDir&'\Data\Picture\Search-icon.png',1)
FileInstall('SettigSca.bmp',@ScriptDir&'\Data\Picture\SettigSca.bmp',1)
FileInstall('Skin.bmp',@ScriptDir&'\Data\Picture\Skin.bmp',1)
FileInstall('Status1.bmp',@ScriptDir&'\Data\Picture\Status1.bmp',1)
FileInstall('Status2.bmp',@ScriptDir&'\Data\Picture\Status2.bmp',1)
FileInstall('StatusGUI.bmp',@ScriptDir&'\Data\Picture\StatusGUI.bmp',1)
FileInstall('TopSkin.bmp',@ScriptDir&'\Data\Picture\TopSkin.bmp',1)
FileInstall('UD.png',@ScriptDir&'\Data\Picture\UD.png',1)
FileInstall('Uncheck.png',@ScriptDir&'\Data\Picture\Uncheck.png',1)
FileInstall('UT.png',@ScriptDir&'\Data\Picture\UT.png',1)
FileInstall('Text.txt',@ScriptDir&'\Data\EditScan.dll',1)
$AutoGUI_OK=0
$ScanErrorfin=0
$ScanErrorfix=0
If IniRead(@ScriptDir&'\Data\DataStatus.dll','TypeScan','AutoScan','') = 1 Or RegRead('HKEY_LOCAL_MACHINE\SOFTWARE\WU','AutoScan') = 1 Then
$AutoScan = 1
Else
$AutoScan = 0
EndIf
If IniRead(@ScriptDir&'\Data\DataScan.dll','Scan','Scan','') <> 1 Then
While $AutoScan = 1
$timecu = @HOUR * 60 + @MIN
VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text14','')&' '&@MDAY&'/'&@MON&'/'&@YEAR&' - '&@HOUR&':'&@MIN)

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text11',''))

$Place1_SS1 = 1
$Place1_SS2 = 0
$Place1_SS3 = 1
$Place1_SS4 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','AutoScanType','')
$Place1_SS5 = ''
$Place1_SS6 = 0
$Place1_SS7 = 0

$VinhScan_Soluong = 0
If $Place1_SS1 = 1 Then
If $Place1_SS4 = 1 Then
$VinhScan_Soluong=0
If FileExists('C:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('D:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('E:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('F:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('G:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('H:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('I:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('Z:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('J:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
EndIf



If $Place1_SS4 = 2 Then

$VinhScan_Soluong=0
If FileExists('C:') Then
$VinhScan_Demfile = DirGetSize('C:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('D:') Then
$VinhScan_Demfile = DirGetSize('D:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('E:') Then
$VinhScan_Demfile = DirGetSize('E:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('F:') Then
$VinhScan_Demfile = DirGetSize('F:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('G:') Then
$VinhScan_Demfile = DirGetSize('G:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('H:') Then
$VinhScan_Demfile = DirGetSize('H:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('I:') Then
$VinhScan_Demfile = DirGetSize('I:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('Z:') Then
$VinhScan_Demfile = DirGetSize('Z:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('J:') Then
$VinhScan_Demfile = DirGetSize('J:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf

EndIf

If $Place1_SS4 = 3 Then
	$VinhScan_Soluong=0
	If FileExists($Place1_SS5) Then
		$VinhScan_Demfile = DirGetSize($Place1_SS5,1)
		$VinhScan_Soluong=$VinhScan_Demfile[1]
	Else

		$Place1_SS4 = 1
		$Place1_SS4 = 0
	EndIf

EndIf

Else
$VinhScan_Soluong=0
EndIf



IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [1/16]')
_Debugger()
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [2/16]')
_DebuggerEx()
$i = 0
$aDim = 0
$BreaK = 0
While 1
	$i = $i + 1
	If $i = 13 Then ExitLoop

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' ['&$i+2&'/16]')

			If $i == 1 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\Help"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If Not FileExists($Enum_Val2 & $Enum_Val1) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Missing File')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)
	EndIf




					EndIf
				WEnd

				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\HTML Help"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If StringInStr($Enum_Val2, "%SystemRoot%") Then $Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					If StringRight($Enum_Val2, 1) <> "\" Then $Enum_Val2 = $Enum_Val2 & "\"
					If Not FileExists($Enum_Val2 & $Enum_Val1) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Missing File')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
				WEnd
				$aDim = ""

			ElseIf $i ==2 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					If Not StringInStr(FileGetAttrib($Enum_Val1), "D") Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 3 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead("HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" & "\" & $Enum_Val1, "")

					If @error = 1 Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 4 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If StringInStr($Enum_Val2, ":\") Then
						If Not FileExists($Enum_Val2) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
					Else
						If Not FileExists(@WindowsDir & "\fonts\" & $Enum_Val2) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
					EndIf
				WEnd
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Fonts"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If Not FileExists(@WindowsDir & "\fonts\" & $Enum_Val2) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 5 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\SharedDLLs"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					If Not FileExists($Enum_Val1) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 6 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey & "\" & $Enum_Val1, "")
					If StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%SystemRoot%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					ElseIf StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%ProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%ProgramFiles%", @ProgramFilesDir)
					ElseIf StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%CommonProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
					ElseIf StringInStr($Enum_Val2, '"') Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
					ElseIf StringInStr($Enum_Val2, "%SystemRoot%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					ElseIf StringInStr($Enum_Val2, "%ProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%ProgramFiles%", @ProgramFilesDir)
					ElseIf StringInStr($Enum_Val2, "%CommonProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
					ElseIf $Enum_Val2 = "" Then
						ContinueLoop
					Else
						If Not FileExists($Enum_Val2) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 7 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error <> 0 Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				;, 45)
				$aDim = ""

			ElseIf $i == 8 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKCU\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				;, 50)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
						EndIf
					EndIf
				WEnd
				;, 55)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKU\.DEFAULT\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				;, 60)
				$aDim = ""

			ElseIf $i == 9 Then
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumKey("HKCR", $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey("HKCR\" & $Enum_Val1, 1)
					If @error <> 0 Then
						$AddVal = RegEnumVal("HKCR\" & $Enum_Val1, 1)
						If @error <> 0 Then
							$bDim = RegRead("HKCR\" & $Enum_Val1, "")
							If $bDim = "" Then


		VinhAutoDeleteGUI("HKCR\" & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
						RegDelete( "HKCR\" & $Enum_Val1)
					RegDelete("HKCR\", $Enum_Val1)
               VinhSaveText("[Empty Key] HKCR\ | " & $Enum_Val1)

		   EndIf


					EndIf
						EndIf
					EndIf
				WEnd
				;, 65)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumKey("HKLM\Software\Classes", $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey("HKLM\Software\Classes\" & $Enum_Val1, 1)
					If @error <> 0 Then
						$AddVal = RegEnumVal("HKLM\Software\Classes\" & $Enum_Val1, 1)
						If @error <> 0 Then
							$bDim = RegRead("HKLM\Software\Classes\" & $Enum_Val1, "")

							If $bDim = "" Then


		VinhAutoDeleteGUI("HKLM\Software\Classes\ | "&$Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
		RegDelete("HKLM\Software\Classes\" & $Enum_Val1)
					RegDelete("HKLM\Software\Classes\", $Enum_Val1)
               VinhSaveText("[Empty Key] HKLM\Software\Classes\ | "&$Enum_Val1)

		   EndIf




					EndIf
						EndIf
					EndIf
				WEnd
				;, 70)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf










						EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf



						EndIf
					EndIf
				WEnd
				;, 75)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKCU\Software\Microsoft\Windows\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else
		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					EndIf
				WEnd
				;, 80)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKU\.DEFAULT\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKU\.DEFAULT\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					EndIf
				WEnd
				;, 85)
				$aDim = ""

			ElseIf $i == 10 Then
While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Classes\CLSID"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$RegK = RegRead($Rkey & "\" & $Enum_Val1 & "\InprocServer32", "")
					If @error <> 0 Then ContinueLoop
					If StringInStr($RegK, '"') Then
						$RegK = StringReplace($RegK, '"', '')
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, ":\") Then
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%SystemRoot%") Then
						$RegK = StringReplace($RegK, "%SystemRoot%", @WindowsDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "rundll32.exe %SystemRoot") Then
						$RegK = StringReplace($RegK, "rundll32.exe %SystemRoot", @WindowsDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%ProgramFiles%") Then
						$RegK = StringReplace($RegK, "%ProgramFiles%", @ProgramFilesDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%CommonProgramFiles%") Then
						$RegK = StringReplace($RegK, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%windir%") Then
						$RegK = StringReplace($RegK, "%windir%", @WindowsDir)
						If Not FileExists($RegK) Then
							VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "~") Then
						$RegK = FileGetLongName($RegK)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
		   EndIf
					Else
						If Not FileExists(@SystemDir & "\" & $RegK) Then
				VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					EndIf

			WEnd
				;, 90)
				$aDim = ""





		ElseIf $i == 11 Then
				While $BreaK = 0
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\UserData"
					$Enum_Val1 = RegEnumKey($Rkey, 1)
					$aDim += 1
					$Enum_Val2 = RegEnumKey($Rkey & "\" & $Enum_Val1 & "\" & "Components", $aDim)
					If @error <> 0 Then ExitLoop
					$RegK1 = RegEnumVal($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & $Enum_Val2, 1)

					If @error <> 0 Then


		VinhAutoDeleteGUI($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2,'Registry Error')
	If $AutoGUI_OK = 1 Then
													RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\"&"\" & $Enum_Val2)
					RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\", $Enum_Val2)
               VinhSaveText("[Invalid key] "&$Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2)
		   EndIf



					EndIf
					$RegK2 = RegRead($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & $Enum_Val2, $RegK1)
					If StringInStr($RegK2, "?") Then
						$RegK2 = StringReplace($RegK2, "?", ":")
					EndIf
					If StringInStr($RegK2, '"') Or _
						StringInStr($RegK2, "00:") Or _
						StringInStr($RegK2, "01:") Or _
						StringInStr($RegK2, "02:") Then ContinueLoop
					If StringInStr($RegK2, ".") Then
						If Not FileExists($RegK2) Then
		VinhAutoDeleteGUI($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2,'Registry Error')


	If $AutoGUI_OK = 1 Then
													RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\"&"\" & $Enum_Val2)
					RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\", $Enum_Val2)
               VinhSaveText("[Invalid key] "&$Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2)
		   EndIf


					EndIf
				EndIf
				WEnd
				;, 95)
				$aDim = ""

			ElseIf $i == 12 Then
				While $BreaK = 0
					$Rkey = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Drivers32"
					$Enum_Val1 = RegEnumKey($Rkey, 1)
					If @error <> 0 Then ExitLoop
					$aDim += 1
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then
						ExitLoop
					Else
						$RegK = RegRead($Rkey, $Enum_Val1)
						If StringInStr($RegK, ":\") Then

							If Not FileExists($RegK) Then


		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
														RegDelete($Rkey &"\" & $Enum_Val2)
					RegDelete($Rkey, $Enum_Val2)
               VinhSaveText("[Invalid Value] "&$Rkey & " | " & $Enum_Val1)
		   EndIf



					EndIf
						Else
							If Not FileExists(@SystemDir & "\" & $RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
														RegDelete($Rkey &"\" & $Enum_Val2)
					RegDelete($Rkey, $Enum_Val2)
               VinhSaveText("[Invalid Value] "&$Rkey & " | " & $Enum_Val1)
		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				$aDim = ""
			EndIf


WEnd


IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [15/16]')
$count2 = 0
If RegRead('HKEY_CLASSES_ROOT\.exe', '') <> 'exefile' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\.exe', 'Content Type') <> 'application/x-msdownload' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '') <> '{098f2470-bae0-11cd-b579-08002b30bfeb}' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', '') <> '"%1" %*' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '') <> '"%1" %*' Then
$count2 += 1
EndIf


If (@OSVersion = 'WIN_VISTA') Or (@OSVersion = 'WIN_7') Then
If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand') <> '"%1" %*' Then
$count2 += 1
EndIf
If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand') <> '"%1" %*' Then
$count2 += 1
EndIf

EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '') <> '{86C86720-42A0-1069-A2E8-08002B30309D}' Then
$count2 += 1

EndIf


If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList', 1) Then
$count2 += 1
EndIf


If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 1) <> 'exefile' Then
$count2 += 1
EndIf


If RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile') <> '' Then
$count2 += 1
EndIf



If $count2 > 0 Then
		VinhAutoDeleteGUI($count2&' error key','Registry Error')
		If $AutoGUI_OK = 1 Then
    If @OSVersion = 'WIN_XP' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'InfoTip', 'REG_SZ', 'prop:FileDescription;Company;FileVersion;Create;Size')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'TileInfo', 'REG_SZ', 'prop:FileDescription;Company;FileVersion')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\PifProps', '', 'REG_SZ', '{86F19A00-42A0-1069-A2E9-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\{B41DB860-8EE4-11D2-9906-E49FADC173CA}', '', 'REG_SZ', '')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_VISTA' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_7' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas', 'HasLUAShield', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', '', 'REG_SZ', '@shell32.dll,-50944')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'Extended', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'SuppressionPolicyEx', 'REG_SZ', '{F211AA05-D4DF-4370-A2A0-9F19C09756A7}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser\command', 'DelegateExecute', 'REG_SZ', '{ea72d00e-4960-42fa-ba92-7792a7944c1d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers', '', 'REG_SZ', 'Compatibility')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers\Compatibility', '', 'REG_SZ', '{1d27f844-3a1f-4410-85ac-14651078412d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    EndIf
	VinhSaveText('[Regedit Error] '&$count2&' error.')

        Else
	VinhSaveText('[Regedit Error] '&$count2&' error.')

        EndIf
EndIf

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [16/16]')
$Bieni = 0
$Modum_Scan_Dem = _FileCountLines(@ScriptDir&'\Data\DataRegistry.dbs')
While $Modum_Scan_Dem > $Bieni
$Bieni = $Bieni + 1
$Modum_Scan_Data= StringSplit(FileReadLine(@ScriptDir&'\Data\DataRegistry.dbs',$Bieni),'|')
If $Modum_Scan_Data[0] = 4 Then

If RegRead($Modum_Scan_Data[1],$Modum_Scan_Data[2]) <> $Modum_Scan_Data[3] Then
VinhAutoDeleteGUI($Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2],'Registry Error')
If $AutoGUI_OK = 1 Then
If RegWrite($Modum_Scan_Data[1], $Modum_Scan_Data[2],$Modum_Scan_Data[4],$Modum_Scan_Data[3]) Then
VinhSaveText("[Registry Error] "&$Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2])
Else
VinhSaveText("[Registry Error] "&$Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2]&' '&IniRead(@ScriptDir&'\language.txt','VI','Text13',''))
EndIf
EndIf
EndIf

EndIf

WEnd


If $VinhScan_Soluong = 0 Then
Else
$modum_scan_sl = 0
$modum_scan_sl1 = 0
Dim $dbpath = @ScriptDir & '\Data\Database.3db'
Dim $read = FileRead($dbpath)
Dim $split2 = StringReplace($read, @CRLF, @TAB)
Dim $split = StringSplit($split2, @TAB)
Dim $size1 = '',$size2 = '',$terminate = False

Dim $dbpath2 = @ScriptDir & '\Data\FileData.dbs'
Dim $read2 = FileRead($dbpath2)
Dim $split22 = StringReplace($read2, @CRLF, @TAB)
Dim $split2 = StringSplit($split22, @TAB)
Dim $size1 = '',$size2 = '',$terminate = False

If $Place1_SS4 = 3 Then
$modum_scan_sl1 = 0
If FileExists($Place1_SS5) Then Go($Place1_SS5)
Else
$modum_scan_sl1 = 0
If FileExists('C:') Then Go('C:')
$modum_scan_sl1 = 0
If FileExists('D:') Then Go('D:')
$modum_scan_sl1 = 0
If FileExists('E:') Then Go('E:')
$modum_scan_sl1 = 0
If FileExists('F:') Then Go('F:')
$modum_scan_sl1 = 0
If FileExists('G:') Then Go('G:')
$modum_scan_sl1 = 0
If FileExists('H:') Then Go('H:')
$modum_scan_sl1 = 0
If FileExists('I:') Then Go('I:')
$modum_scan_sl1 = 0
If FileExists('Z:') Then Go('Z:')
$modum_scan_sl1 = 0
If FileExists('J:') Then Go('J:')
EndIf

EndIf

VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text19','')&' '&$ScanErrorfin)
VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text20','')&' '&$ScanErrorfix)

VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text17','')&' '&(@HOUR*60+@MIN) - $timecu&' '&IniRead(@ScriptDir&'\language.txt','VI','Text18',''))
VinhSaveText('--------------------------------------------------')






















IniWrite(@ScriptDir&'\Data\DataStatus.dll','StatusScan','LastScan',@MDAY&'|'&@MON&'|'&@YEAR)
$oldFile = FileRead(@ScriptDir&'\DataDiary.dll')
FileInstall('Text.txt',@ScriptDir&'\DataDiary.dll',1)
FileWrite(@ScriptDir&'\DataDiary.dll',FileRead(@ScriptDir&'\Data\EditScan.dll')&@CRLF)
FileWrite(@ScriptDir&'\DataDiary.dll',$oldFile)
if $Place1_SS6 = 1 Then

$LangQuit = StringSplit(IniRead(@ScriptDir&'\language.txt','VI','Text27',''),'|')
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 9 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 8 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 7 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 6 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 5 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 4 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 3 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 2 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 1 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 0 '&$LangQuit[2]&' - '&$LangQuit[3])
Shutdown(1)
EndIf
Exit
WEnd
Else

While IniRead(@ScriptDir&'\Data\DataScan.dll','Scan','Scan','') = 1
$timecu = @HOUR * 60 + @MIN
VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text14','')&' '&@MDAY&'/'&@MON&'/'&@YEAR&' - '&@HOUR&':'&@MIN)

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text11',''))

$Place1_SS1 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS1','')
$Place1_SS2 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2','')
$Place1_SS3 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS3','')
$Place1_SS4 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS4','')
$Place1_SS5 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS5','')
$Place1_SS6 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS6','')
$Place1_SS7 = IniRead(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7','')

FileDelete(@WindowsDir&'\CheckInternet.ini')
InetGet('https://sites.google.com/site/vzsoft001/update/CheckInternet.txt?attredirects=0&d=1',@WindowsDir&'\CheckInternet.ini')
If FileRead(@WindowsDir&'\CheckInternet.ini') = 'INTERNET CHECK OK' Then
	FileDelete(@SystemDir&'\BQWU.wu')
	InetGet('https://sites.google.com/site/vzsoft001/banquyen/'&DriveGetSerial(@HomeDrive)&'.bq?attredirects=0&d=1',@SystemDir&'\BQWU.wu')
If FileExists(@SystemDir&'\BQWU.wu') Then

	FileDelete(@ScriptDir&'\BQWU.txt')
	_Crypt_DecryptFile(@SystemDir&'\BQWU.wu',@ScriptDir&'\BQWU.txt',4561684,$CALG_3DES)
	FileDelete(@ScriptDir&'\CheckBT.ini')
	FileDelete(@ScriptDir&'\CheckBQ.ini')
	InetGet('https://sites.google.com/site/vzsoft001/update/Data.txt?attredirects=0&d=1',@ScriptDir&'\CheckBT.ini')
	_Crypt_DecryptFile(@ScriptDir&'\CheckBT.ini',@ScriptDir&'\CheckBQ.ini',4561684,$CALG_3DES)
	FileDelete(@ScriptDir&'\CheckBT.ini')

	if IniRead(@ScriptDir&'\CheckBQ.ini',IniRead(@ScriptDir&'\BQWU.txt','Banquyen','Makhachhang',''),'Check','') = '' Then
		$place1_ss7 = 0
		IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7',0)
		Else
	If DriveGetSerial(@HomeDrive) <> IniRead(@ScriptDir&'\CheckBQ.ini',IniRead(@ScriptDir&'\BQWU.txt','Banquyen','Makhachhang',''),'Check','') Then
	MsgBox(16,IniRead(@ScriptDir&'\language.txt','VI','thongbao',''),IniRead(@ScriptDir&'\language.txt','VI','Text38',''))
	$place1_ss7 = 0
	IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7',0)
	FileDelete(@SystemDir&'\BQWU.wu')
	FileDelete(@ScriptDir&'\CheckBQ.ini')
	FileDelete(@ScriptDir&'\CheckBQ.ini')
Else



	If StringLeft(IniRead(@ScriptDir&'\BQWU.txt','Banquyen','Makhachhang',''),4) <> 'FREE' Then

	Else
		$place1_ss7 = 0
		IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7',0)
	EndIf

	EndIf
	EndIf

Else
$place1_ss7 = 0
IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7',0)
EndIf




Else
$place1_ss7 = 0
IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS7',0)
EndIf

FileDelete(@ScriptDir&'\CheckBT.ini')
FileDelete(@ScriptDir&'\CheckBQ.ini')

IniWrite(@ScriptDir&'\Data\DataStatus.dll','TypeScan','SS7',$place1_ss7)
$VinhScan_Soluong = 0
If $Place1_SS1 = 1 Then
If $Place1_SS4 = 1 Then
$VinhScan_Soluong=0
If FileExists('C:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('D:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('E:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('F:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('G:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('H:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('I:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('Z:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
If FileExists('J:') Then $VinhScan_Soluong=$VinhScan_Soluong+300
EndIf



If $Place1_SS4 = 2 Then

$VinhScan_Soluong=0
If FileExists('C:') Then
$VinhScan_Demfile = DirGetSize('C:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('D:') Then
$VinhScan_Demfile = DirGetSize('D:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('E:') Then
$VinhScan_Demfile = DirGetSize('E:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('F:') Then
$VinhScan_Demfile = DirGetSize('F:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('G:') Then
$VinhScan_Demfile = DirGetSize('G:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('H:') Then
$VinhScan_Demfile = DirGetSize('H:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('I:') Then
$VinhScan_Demfile = DirGetSize('I:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('Z:') Then
$VinhScan_Demfile = DirGetSize('Z:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf
If FileExists('J:') Then
$VinhScan_Demfile = DirGetSize('J:',1)
$VinhScan_Soluong=$VinhScan_Demfile[1]+$VinhScan_Soluong
EndIf

EndIf

If $Place1_SS4 = 3 Then
	$VinhScan_Soluong=0
	If FileExists($Place1_SS5) Then
		$VinhScan_Demfile = DirGetSize($Place1_SS5,1)
		$VinhScan_Soluong=$VinhScan_Demfile[1]
	Else

		$Place1_SS4 = 1
		$Place1_SS4 = 0
	EndIf

EndIf

Else
$VinhScan_Soluong=0
EndIf



IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [1/16]')
_Debugger()
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [2/16]')
_DebuggerEx()
$i = 0
$aDim = 0
$BreaK = 0
While 1
	$i = $i + 1
	If $i = 13 Then ExitLoop

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' ['&$i+2&'/16]')

			If $i == 1 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\Help"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If Not FileExists($Enum_Val2 & $Enum_Val1) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Missing File')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)
	EndIf




					EndIf
				WEnd

				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\HTML Help"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If StringInStr($Enum_Val2, "%SystemRoot%") Then $Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					If StringRight($Enum_Val2, 1) <> "\" Then $Enum_Val2 = $Enum_Val2 & "\"
					If Not FileExists($Enum_Val2 & $Enum_Val1) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Missing File')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
				WEnd
				$aDim = ""

			ElseIf $i ==2 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\Folders"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					If Not StringInStr(FileGetAttrib($Enum_Val1), "D") Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 3 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\App Management\ARPCache"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead("HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall" & "\" & $Enum_Val1, "")

					If @error = 1 Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 4 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If StringInStr($Enum_Val2, ":\") Then
						If Not FileExists($Enum_Val2) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
					Else
						If Not FileExists(@WindowsDir & "\fonts\" & $Enum_Val2) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf


					EndIf
					EndIf
				WEnd
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Fonts"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey, $Enum_Val1)
					If Not FileExists(@WindowsDir & "\fonts\" & $Enum_Val2) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 5 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\SharedDLLs"
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					If Not FileExists($Enum_Val1) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 6 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\App Paths"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegRead($Rkey & "\" & $Enum_Val1, "")
					If StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%SystemRoot%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					ElseIf StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%ProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%ProgramFiles%", @ProgramFilesDir)
					ElseIf StringInStr($Enum_Val2, '"') And StringInStr($Enum_Val2, "%CommonProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
						$Enum_Val2 = StringReplace($Enum_Val2, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
					ElseIf StringInStr($Enum_Val2, '"') Then
						$Enum_Val2 = StringReplace($Enum_Val2, '"', '')
					ElseIf StringInStr($Enum_Val2, "%SystemRoot%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%SystemRoot%", @WindowsDir)
					ElseIf StringInStr($Enum_Val2, "%ProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%ProgramFiles%", @ProgramFilesDir)
					ElseIf StringInStr($Enum_Val2, "%CommonProgramFiles%") Then
						$Enum_Val2 = StringReplace($Enum_Val2, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
					ElseIf $Enum_Val2 = "" Then
						ContinueLoop
					Else
						If Not FileExists($Enum_Val2) Then

		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
					EndIf
				WEnd
				$aDim = ""

			ElseIf $i == 7 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error <> 0 Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
				WEnd
				;, 45)
				$aDim = ""

			ElseIf $i == 8 Then
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKCU\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				;, 50)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf

					EndIf
						EndIf
					EndIf
				WEnd
				;, 55)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Rkey = "HKU\.DEFAULT\Software"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					RegEnumKey($Rkey & "\" & $Enum_Val1, 1)
					If @error Then
						RegEnumVal($Rkey & "\" & $Enum_Val1, 1)
						If @error Then
							$bDim = RegRead($Rkey & "\" & $Enum_Val1, "")
							If $bDim = "" Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				;, 60)
				$aDim = ""

			ElseIf $i == 9 Then
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumKey("HKCR", $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey("HKCR\" & $Enum_Val1, 1)
					If @error <> 0 Then
						$AddVal = RegEnumVal("HKCR\" & $Enum_Val1, 1)
						If @error <> 0 Then
							$bDim = RegRead("HKCR\" & $Enum_Val1, "")
							If $bDim = "" Then


		VinhAutoDeleteGUI("HKCR\" & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
						RegDelete( "HKCR\" & $Enum_Val1)
					RegDelete("HKCR\", $Enum_Val1)
               VinhSaveText("[Empty Key] HKCR\ | " & $Enum_Val1)

		   EndIf


					EndIf
						EndIf
					EndIf
				WEnd
				;, 65)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumKey("HKLM\Software\Classes", $aDim)
					If @error <> 0 Then ExitLoop
					$Enum_Val2 = RegEnumKey("HKLM\Software\Classes\" & $Enum_Val1, 1)
					If @error <> 0 Then
						$AddVal = RegEnumVal("HKLM\Software\Classes\" & $Enum_Val1, 1)
						If @error <> 0 Then
							$bDim = RegRead("HKLM\Software\Classes\" & $Enum_Val1, "")

							If $bDim = "" Then


		VinhAutoDeleteGUI("HKLM\Software\Classes\ | "&$Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
		RegDelete("HKLM\Software\Classes\" & $Enum_Val1)
					RegDelete("HKLM\Software\Classes\", $Enum_Val1)
               VinhSaveText("[Empty Key] HKLM\Software\Classes\ | "&$Enum_Val1)

		   EndIf




					EndIf
						EndIf
					EndIf
				WEnd
				;, 70)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf










						EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf



						EndIf
					EndIf
				WEnd
				;, 75)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKCU\Software\Microsoft\Windows\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else
		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					EndIf
				WEnd
				;, 80)
				$aDim = ""
				While $BreaK = 0
					$aDim += 1
					$Enum_Val1 = RegEnumVal("HKU\.DEFAULT\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $aDim)
					If @error <> 0 Then ExitLoop
					$bDim = RegRead("HKU\.DEFAULT\Software\Microsoft\Windows NT\CurrentVersion\Extensions", $Enum_Val1)
					If StringInStr(StringLeft($bDim, "2"), ":") Then
						$cDim = StringSplit($bDim, "^")
						If Not FileExists($cDim[1]) Then

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					Else
						$cDim = StringSplit($bDim, "^")
						If FileExists(@WindowsDir & "\" & $cDim[1]) Or FileExists(@SystemDir & "\" & $cDim[1]) Then
							ContinueLoop
						Else

		VinhAutoDeleteGUI("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1,'Registry Error')


	If $AutoGUI_OK = 1 Then
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & $Enum_Val1)
					RegDelete("HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\", $Enum_Val1)
               VinhSaveText("[Invalid Value] HKCU\Software\Microsoft\Windows NT\CurrentVersion\Extensions\" & " | " & $Enum_Val1)
		   EndIf
						EndIf
					EndIf
				WEnd
				;, 85)
				$aDim = ""

			ElseIf $i == 10 Then
While $BreaK = 0
					$aDim += 1
					$Rkey = "HKLM\Software\Classes\CLSID"
					$Enum_Val1 = RegEnumKey($Rkey, $aDim)
					If @error <> 0 Then ExitLoop
					$RegK = RegRead($Rkey & "\" & $Enum_Val1 & "\InprocServer32", "")
					If @error <> 0 Then ContinueLoop
					If StringInStr($RegK, '"') Then
						$RegK = StringReplace($RegK, '"', '')
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, ":\") Then
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%SystemRoot%") Then
						$RegK = StringReplace($RegK, "%SystemRoot%", @WindowsDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "rundll32.exe %SystemRoot") Then
						$RegK = StringReplace($RegK, "rundll32.exe %SystemRoot", @WindowsDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%ProgramFiles%") Then
						$RegK = StringReplace($RegK, "%ProgramFiles%", @ProgramFilesDir)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%CommonProgramFiles%") Then
						$RegK = StringReplace($RegK, "%CommonProgramFiles%", @ProgramFilesDir & "\Common Files")
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "%windir%") Then
						$RegK = StringReplace($RegK, "%windir%", @WindowsDir)
						If Not FileExists($RegK) Then
							VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					ElseIf StringInStr($RegK, "~") Then
						$RegK = FileGetLongName($RegK)
						If Not FileExists($RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
		   EndIf
					Else
						If Not FileExists(@SystemDir & "\" & $RegK) Then
				VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
		If $AutoGUI_OK = 1 Then
					RegDelete($Rkey & "\" & $Enum_Val1)
					RegDelete($Rkey, $Enum_Val1)
               VinhSaveText("[Missing File] "&$Rkey & " | " & $Enum_Val1)

		   EndIf
					EndIf
					EndIf

			WEnd
				;, 90)
				$aDim = ""





		ElseIf $i == 11 Then
				While $BreaK = 0
					$Rkey = "HKLM\Software\Microsoft\Windows\CurrentVersion\Installer\UserData"
					$Enum_Val1 = RegEnumKey($Rkey, 1)
					$aDim += 1
					$Enum_Val2 = RegEnumKey($Rkey & "\" & $Enum_Val1 & "\" & "Components", $aDim)
					If @error <> 0 Then ExitLoop
					$RegK1 = RegEnumVal($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & $Enum_Val2, 1)

					If @error <> 0 Then


		VinhAutoDeleteGUI($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2,'Registry Error')
	If $AutoGUI_OK = 1 Then
													RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\"&"\" & $Enum_Val2)
					RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\", $Enum_Val2)
               VinhSaveText("[Invalid key] "&$Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2)
		   EndIf



					EndIf
					$RegK2 = RegRead($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & $Enum_Val2, $RegK1)
					If StringInStr($RegK2, "?") Then
						$RegK2 = StringReplace($RegK2, "?", ":")
					EndIf
					If StringInStr($RegK2, '"') Or _
						StringInStr($RegK2, "00:") Or _
						StringInStr($RegK2, "01:") Or _
						StringInStr($RegK2, "02:") Then ContinueLoop
					If StringInStr($RegK2, ".") Then
						If Not FileExists($RegK2) Then
		VinhAutoDeleteGUI($Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2,'Registry Error')


	If $AutoGUI_OK = 1 Then
													RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\"&"\" & $Enum_Val2)
					RegDelete($Rkey & "\" & $Enum_Val1 & "\" & "Components\", $Enum_Val2)
               VinhSaveText("[Invalid key] "&$Rkey & "\" & $Enum_Val1 & "\" & "Components\" & " | " & $Enum_Val2)
		   EndIf


					EndIf
				EndIf
				WEnd
				;, 95)
				$aDim = ""

			ElseIf $i == 12 Then
				While $BreaK = 0
					$Rkey = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Drivers32"
					$Enum_Val1 = RegEnumKey($Rkey, 1)
					If @error <> 0 Then ExitLoop
					$aDim += 1
					$Enum_Val1 = RegEnumVal($Rkey, $aDim)
					If @error <> 0 Then
						ExitLoop
					Else
						$RegK = RegRead($Rkey, $Enum_Val1)
						If StringInStr($RegK, ":\") Then

							If Not FileExists($RegK) Then


		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
														RegDelete($Rkey &"\" & $Enum_Val2)
					RegDelete($Rkey, $Enum_Val2)
               VinhSaveText("[Invalid Value] "&$Rkey & " | " & $Enum_Val1)
		   EndIf



					EndIf
						Else
							If Not FileExists(@SystemDir & "\" & $RegK) Then
		VinhAutoDeleteGUI($Rkey & " | " & $Enum_Val1,'Registry Error')
	If $AutoGUI_OK = 1 Then
														RegDelete($Rkey &"\" & $Enum_Val2)
					RegDelete($Rkey, $Enum_Val2)
               VinhSaveText("[Invalid Value] "&$Rkey & " | " & $Enum_Val1)
		   EndIf
					EndIf
						EndIf
					EndIf
				WEnd
				$aDim = ""
			EndIf


WEnd


IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [15/16]')
$count2 = 0
If RegRead('HKEY_CLASSES_ROOT\.exe', '') <> 'exefile' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\.exe', 'Content Type') <> 'application/x-msdownload' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '') <> '{098f2470-bae0-11cd-b579-08002b30bfeb}' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', '') <> '"%1" %*' Then
$count2 += 1
EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '') <> '"%1" %*' Then
$count2 += 1
EndIf


If (@OSVersion = 'WIN_VISTA') Or (@OSVersion = 'WIN_7') Then
If RegRead('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand') <> '"%1" %*' Then
$count2 += 1
EndIf
If RegRead('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand') <> '"%1" %*' Then
$count2 += 1
EndIf

EndIf


If RegRead('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '') <> '{86C86720-42A0-1069-A2E8-08002B30309D}' Then
$count2 += 1

EndIf


If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList', 1) Then
$count2 += 1
EndIf


If RegEnumVal('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 1) <> 'exefile' Then
$count2 += 1
EndIf


If RegRead('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile') <> '' Then
$count2 += 1
EndIf



If $count2 > 0 Then
		VinhAutoDeleteGUI($count2&' error key','Registry Error')
		If $AutoGUI_OK = 1 Then
    If @OSVersion = 'WIN_XP' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'InfoTip', 'REG_SZ', 'prop:FileDescription;Company;FileVersion;Create;Size')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'TileInfo', 'REG_SZ', 'prop:FileDescription;Company;FileVersion')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\PifProps', '', 'REG_SZ', '{86F19A00-42A0-1069-A2E9-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\{B41DB860-8EE4-11D2-9906-E49FADC173CA}', '', 'REG_SZ', '')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_VISTA' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    ElseIf @OSVersion = 'WIN_7' Then
        RegWrite('HKEY_CLASSES_ROOT\.exe', '', 'REG_SZ', 'exefile')
        RegWrite('HKEY_CLASSES_ROOT\.exe', 'Content Type', 'REG_SZ', 'application/x-msdownload')
        RegWrite('HKEY_CLASSES_ROOT\.exe\PersistentHandler', '', 'REG_SZ', '{098f2470-bae0-11cd-b579-08002b30bfeb}')
        RegWrite('HKEY_CLASSES_ROOT\exefile', '', 'REG_SZ', 'Application')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'EditFlags', 'REG_BINARY', '0x38070000')
        RegWrite('HKEY_CLASSES_ROOT\exefile', 'FriendlyTypeName', 'REG_EXPAND_SZ', '@%SystemRoot%\System32\shell32.dll,-10156')
        RegWrite('HKEY_CLASSES_ROOT\exefile\DefaultIcon', '', 'REG_SZ', '%1')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open', 'EditFlags', 'REG_BINARY', '0x00000000')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\open\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas', 'HasLUAShield', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', '', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runas\command', 'IsolatedCommand', 'REG_SZ', '"%1" %*')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', '', 'REG_SZ', '@shell32.dll,-50944')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'Extended', 'REG_SZ', '')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser', 'SuppressionPolicyEx', 'REG_SZ', '{F211AA05-D4DF-4370-A2A0-9F19C09756A7}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shell\runasuser\command', 'DelegateExecute', 'REG_SZ', '{ea72d00e-4960-42fa-ba92-7792a7944c1d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers', '', 'REG_SZ', 'Compatibility')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\ContextMenuHandlers\Compatibility', '', 'REG_SZ', '{1d27f844-3a1f-4410-85ac-14651078412d}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\DropHandler', '', 'REG_SZ', '{86C86720-42A0-1069-A2E8-08002B30309D}')
        RegWrite('HKEY_CLASSES_ROOT\exefile\shellex\PropertySheetHandlers\ShimLayer Property Page', '', 'REG_SZ', '{513D916F-2A8E-4F51-AEAB-0CBC76FB1AF8}')
        RegDelete('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithList')
        RegWrite('HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\.exe\OpenWithProgids', 'exefile', 'REG_BINARY', Binary(''))
    EndIf
	VinhSaveText('[Regedit Error] '&$count2&' error.')

        Else
	VinhSaveText('[Regedit Error] '&$count2&' error.')

        EndIf
EndIf

IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text15','')&' [16/16]')
$Bieni = 0
$Modum_Scan_Dem = _FileCountLines(@ScriptDir&'\Data\DataRegistry.dbs')
While $Modum_Scan_Dem > $Bieni
$Bieni = $Bieni + 1
$Modum_Scan_Data= StringSplit(FileReadLine(@ScriptDir&'\Data\DataRegistry.dbs',$Bieni),'|')
If $Modum_Scan_Data[0] = 4 Then

If RegRead($Modum_Scan_Data[1],$Modum_Scan_Data[2]) <> $Modum_Scan_Data[3] Then
VinhAutoDeleteGUI($Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2],'Registry Error')
If $AutoGUI_OK = 1 Then
If RegWrite($Modum_Scan_Data[1], $Modum_Scan_Data[2],$Modum_Scan_Data[4],$Modum_Scan_Data[3]) Then
VinhSaveText("[Registry Error] "&$Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2])
Else
VinhSaveText("[Registry Error] "&$Modum_Scan_Data[1] & " | " & $Modum_Scan_Data[2]&' '&IniRead(@ScriptDir&'\language.txt','VI','Text13',''))
EndIf
EndIf
EndIf

EndIf

WEnd


If $VinhScan_Soluong = 0 Then
Else
$modum_scan_sl = 0
$modum_scan_sl1 = 0
Dim $dbpath = @ScriptDir & '\Data\Database.3db'
Dim $read = FileRead($dbpath)
Dim $split2 = StringReplace($read, @CRLF, @TAB)
Dim $split = StringSplit($split2, @TAB)
Dim $size1 = '',$size2 = '',$terminate = False

Dim $dbpath2 = @ScriptDir & '\Data\FileData.dbs'
Dim $read2 = FileRead($dbpath2)
Dim $split22 = StringReplace($read2, @CRLF, @TAB)
Dim $split2 = StringSplit($split22, @TAB)
Dim $size1 = '',$size2 = '',$terminate = False
If $Place1_SS4 = 3 Then
$modum_scan_sl1 = 0
If FileExists($Place1_SS5) Then Go($Place1_SS5)
Else
$modum_scan_sl1 = 0
If FileExists('C:') Then Go('C:')
$modum_scan_sl1 = 0
If FileExists('D:') Then Go('D:')
$modum_scan_sl1 = 0
If FileExists('E:') Then Go('E:')
$modum_scan_sl1 = 0
If FileExists('F:') Then Go('F:')
$modum_scan_sl1 = 0
If FileExists('G:') Then Go('G:')
$modum_scan_sl1 = 0
If FileExists('H:') Then Go('H:')
$modum_scan_sl1 = 0
If FileExists('I:') Then Go('I:')
$modum_scan_sl1 = 0
If FileExists('Z:') Then Go('Z:')
$modum_scan_sl1 = 0
If FileExists('J:') Then Go('J:')
EndIf

EndIf

VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text19','')&' '&$ScanErrorfin)
VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text20','')&' '&$ScanErrorfix)

VinhSaveText(IniRead(@ScriptDir&'\language.txt','VI','Text17','')&' '&(@HOUR*60+@MIN) - $timecu&' '&IniRead(@ScriptDir&'\language.txt','VI','Text18',''))
VinhSaveText('--------------------------------------------------')






















IniWrite(@ScriptDir&'\Data\DataStatus.dll','StatusScan','LastScan',@MDAY&'|'&@MON&'|'&@YEAR)
$oldFile = FileRead(@ScriptDir&'\DataDiary.dll')
FileInstall('Text.txt',@ScriptDir&'\DataDiary.dll',1)
FileWrite(@ScriptDir&'\DataDiary.dll',FileRead(@ScriptDir&'\Data\EditScan.dll')&@CRLF)
FileWrite(@ScriptDir&'\DataDiary.dll',$oldFile)
if $Place1_SS6 = 1 Then

$LangQuit = StringSplit(IniRead(@ScriptDir&'\language.txt','VI','Text27',''),'|')
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 9 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 8 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 7 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 6 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 5 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 4 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 3 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 2 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 1 '&$LangQuit[2]&' - '&$LangQuit[3])
Sleep(1000)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',$LangQuit[1]&' 0 '&$LangQuit[2]&' - '&$LangQuit[3])
Shutdown(1)
EndIf
Exit
WEnd
EndIf





Func Go($parameter)
    If not FileExists ($parameter) Then
        Return
    EndIf
    $size1 = DriveSpaceTotal  ($parameter) * 1024 * 1024
    ConsoleWrite($size1 & $parameter)
    $timer = TimerInit()
    $terminate = False
    $fileCount = 0

    $searchLocation = $parameter

    If StringRight($searchLocation, 1) = "\" Then $searchLocation = StringTrimRight($searchLocation, 1)

    $searchHandle = FileFindFirstFile($searchLocation & "\*.*")
    If ($searchHandle == -1) Then
        Return
    EndIf

    If (@error == 1) Then
        Return
    EndIf


    $answer = search($searchHandle, $searchLocation)
    If Not $answer Then Return

    FileClose($searchHandle)


    Return


EndFunc

Func _MD5ForFile($sFile)

    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
            "wstr", $sFile, _
            "dword", 0x80000000, _; GENERIC_READ
            "dword", 1, _; FILE_SHARE_READ
            "ptr", 0, _
            "dword", 3, _; OPEN_EXISTING
            "dword", 0, _; SECURITY_ANONYMOUS
            "ptr", 0)

    If @error Or $a_hCall[0] = -1 Then
        Return SetError(1, 0, "")
    EndIf

    Local $hFile = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
            "hwnd", $hFile, _
            "dword", 0, _; default security descriptor
            "dword", 2, _; PAGE_READONLY
            "dword", 0, _
            "dword", 0, _
            "ptr", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
        Return SetError(2, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)

    Local $hFileMappingObject = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
            "hwnd", $hFileMappingObject, _
            "dword", 4, _; FILE_MAP_READ
            "dword", 0, _
            "dword", 0, _
            "dword", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(3, 0, "")
    EndIf

    Local $pFile = $a_hCall[0]
    Local $iBufferSize = FileGetSize($sFile)

    Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
            "dword buf[4];" & _
            "ubyte in[64];" & _
            "ubyte digest[16]")

    DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(4, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Update", _
            "ptr", DllStructGetPtr($tMD5_CTX), _
            "ptr", $pFile, _
            "dword", $iBufferSize)

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(5, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(6, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)

    Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))

    Return SetError(0, 0, $sMD5)

EndFunc;==>_MD5ForFile
Func search($searchHandle, $searchLocation)
    $toReturn = ""
    $terminate = False
    $fileCount = 0
	If $Place1_SS4 = 1 Then

    While $modum_scan_sl1 < 300
        If $terminate = True Then
            $toReturn = ''

            ExitLoop
        EndIf
        $file = FileFindNextFile($searchHandle)
        If @error Then
            ExitLoop
        EndIf

        $toReturn = $toReturn & $searchLocation & "\" & $file



		$fileCount += 1
        $size2 += FileGetSize ($toReturn)
        ProgressSet (($size2 * 100)/$size1,FileGetShortName($toReturn,1))
		$modum_scan_sl = $modum_scan_sl + 1
		$modum_scan_sl1 = $modum_scan_sl1 + 1
        _scanfile($toReturn)

        $toReturn = ''
        $md5 = ''
        $attrib = FileGetAttrib($searchLocation & "\" & $file)
        If StringInStr($attrib, "D") Then
            $search2 = FileFindFirstFile($searchLocation & "\" & $file & "\*.*")
            $toReturn = $toReturn & search($search2, $searchLocation & "\" & $file)
        EndIf

    WEnd

Else

	    While (True)
        If $terminate = True Then
            $toReturn = ''

            ExitLoop
        EndIf
        $file = FileFindNextFile($searchHandle)
        If @error Then
            ExitLoop
        EndIf

        $toReturn = $toReturn & $searchLocation & "\" & $file


$fileCount += 1
        $size2 += FileGetSize ($toReturn)
        ProgressSet (($size2 * 100)/$size1,FileGetShortName($toReturn,1))
		$modum_scan_sl = $modum_scan_sl + 1
        _scanfile($toReturn)


        $toReturn = ''
        $md5 = ''
        $attrib = FileGetAttrib($searchLocation & "\" & $file)
        If StringInStr($attrib, "D") Then
            $search2 = FileFindFirstFile($searchLocation & "\" & $file & "\*.*")
            $toReturn = $toReturn & search($search2, $searchLocation & "\" & $file)
        EndIf

    WEnd
	EndIf
    Return $toReturn

EndFunc
Func _scanfile($parameter)
IniWrite(@ScriptDir&'\Data\DataScan.dll','Scan','Text1',IniRead(@ScriptDir&'\language.txt','VI','Text16','')&' ['&Int(($modum_scan_sl/$VinhScan_Soluong)*100)&'/100%] ['&$modum_scan_sl&'/'&$VinhScan_Soluong&' file]')

    Local $i = 0
    If $terminate = true then
        $toReturn = ''

        Return
    EndIf

    Local $y = 0, $count = 0, $size = 0
    If Not StringInStr(FileGetAttrib($parameter), 'D') Then
        $md5 = _MD5ForFile($parameter)

    Else
        Return
    EndIf

$Thatvirus = 2
For $i = 1 To $split[0]

If $split[$i] = $md5 Then











$AutoGUI_OK = 0
VinhAutoDeleteGUI($parameter,'Virus')
If $AutoGUI_OK = 1 Then
	DirCreate(@ScriptDir&"\Backup")
$PROC_LIST = ProcessList(PathToName($parameter))
If IsArray($PROC_LIST) Then
    For $INDEX = 1 To $PROC_LIST[0][0]
        If ProcessGetPath($PROC_LIST[$INDEX][1]) = $parameter Then
		ProcessClose($PROC_LIST[$INDEX][1])
		EndIf
    Next
EndIf
$NameBackup = 0
If $Place1_SS3 = 1 Then
				$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC
				if FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then
					While 1
						$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC&Random(111,999,1)
						If FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then

					Else
						ExitLoop
						EndIf
					WEnd
				EndIf

                FileCopy ($parameter,@ScriptDir&"\Backup\"&$NameBackup&".bak")

				IniWrite(@ScriptDir&"\Backup\"&$NameBackup&".bak","1","1","1")
EndIf
_RunDOS  ('DEL ' & '"' & $parameter & '" /F /Q')
$Thatvirus = 1
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&': '&$split[$i-1]&' - Backup: '&$NameBackup&".bak")
Else
$NameBackup = 0
$Thatvirus = 1
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&': '&$split[$i-1]&' - Backup: '&$NameBackup&".bak"&' '&IniRead(@ScriptDir&'\language.txt','VI','Text13',''))
EndIf
ExitLoop

Else
EndIf

Next

If $Thatvirus = 2 Then

For $i = 1 To $split2[0]
If $split2[$i] <> '' Then
If $split2[$i] = $md5 Then











$AutoGUI_OK = 0
VinhAutoDeleteGUI($parameter,'Virus')
If $AutoGUI_OK = 1 Then
	DirCreate(@ScriptDir&"\Backup")
$PROC_LIST = ProcessList(PathToName($parameter))
If IsArray($PROC_LIST) Then
    For $INDEX = 1 To $PROC_LIST[0][0]
        If ProcessGetPath($PROC_LIST[$INDEX][1]) = $parameter Then
		ProcessClose($PROC_LIST[$INDEX][1])
		EndIf
    Next
EndIf
$NameBackup = 0
If $Place1_SS3 = 1 Then
				$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC
				if FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then
					While 1
						$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC&Random(111,999,1)
						If FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then

					Else
						ExitLoop
						EndIf
					WEnd
				EndIf

                FileCopy ($parameter,@ScriptDir&"\Backup\"&$NameBackup&".bak")

				IniWrite(@ScriptDir&"\Backup\"&$NameBackup&".bak","1","1","1")
EndIf
_RunDOS  ('DEL ' & '"' & $parameter & '" /F /Q')
$Thatvirus = 1
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&' - Backup: '&$NameBackup&".bak")
Else
$NameBackup = 0
$Thatvirus = 1
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&' - Backup: '&$NameBackup&".bak"&' '&IniRead(@ScriptDir&'\language.txt','VI','Text13',''))
EndIf
ExitLoop

Else
EndIf
EndIf
Next

EndIf

If $Place1_SS7 = 1 And $Thatvirus = 2 Then
$VsHTML = _INetGetSource('http://www.threatexpert.com/report.aspx?md5='&$md5)
StringReplace($VsHTML,'File MD5','Vinh')
If @extended <> 0 Then
$AutoGUI_OK = 0
VinhAutoDeleteGUI($parameter,'Virus')
If $AutoGUI_OK = 1 Then
	DirCreate(@ScriptDir&"\Backup")
$PROC_LIST = ProcessList(PathToName($parameter))
If IsArray($PROC_LIST) Then
    For $INDEX = 1 To $PROC_LIST[0][0]
        If ProcessGetPath($PROC_LIST[$INDEX][1]) = $parameter Then
		ProcessClose($PROC_LIST[$INDEX][1])
		EndIf
    Next
EndIf
$NameBackup = 0
If $Place1_SS3 = 1 Then
				$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC
				if FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then
					While 1
						$NameBackup = @MDAY&@MON&@YEAR&@MIN&@SEC&Random(111,999,1)
						If FileExists(@ScriptDir&"\Backup\"&$NameBackup&".bak") Then

					Else
						ExitLoop
						EndIf
					WEnd
				EndIf

                FileCopy ($parameter,@ScriptDir&"\Backup\"&$NameBackup&".bak")

				IniWrite(@ScriptDir&"\Backup\"&$NameBackup&".bak","1","1","1")
				EndIf
_RunDOS  ('DEL ' & '"' & $parameter & '" /F /Q')
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&': Virus - Backup: '&$NameBackup&".bak")
Else
$NameBackup = 0
VinhSaveText('[Virus] File: '&$parameter&' - '&IniRead(@ScriptDir&'\language.txt','VI','Text5','')&': Virus - Backup: '&$NameBackup&".bak"&' '&IniRead(@ScriptDir&'\language.txt','VI','Text13',''))
EndIf

EndIf
EndIf
    $toReturn = ''
    $md5 = ''
$Thatvirus = 2
EndFunc


Func _ProcessSuspend($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc
Func _ProcessResume($process)
$processid = ProcessExists($process)
If $processid Then
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
    $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
    DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
    If IsArray($i_sucess) Then
        Return 1
    Else
        SetError(1)
        Return 0
    Endif
Else
    SetError(2)
    Return 0
Endif
EndFunc
Func ProcessGetPath($PID)
    Local $PATH = ""
    $OBJ = ObjGet("winmgmts:{impersonationLevel=impersonate,authenticationLevel=pktPrivacy, (Debug)}!\\.\root\cimv2")
    If IsObj($OBJ) Then
        $PROC = $OBJ.ExecQuery("select * from win32_Process where ProcessId = " & $PID)
        If IsObj($PROC) Then
            If $PROC.count <> 0 Then
                For $FIND In $PROC
                    $PATH = $FIND.ExecutablePath
                    If $PATH <> "" Then ExitLoop
                Next
            EndIf
        EndIf
    EndIf
    Return $PATH
EndFunc
Func PathToName($dPath)
    Local $dName
    While StringRight($dPath, 1) = "\"
        $dPath = StringTrimRight($dPath, 1)
    WEnd
    $dName = StringInStr($dPath, "\", -1, -1)
    $dName = StringLen($dPath) - $dName
    $dName = StringRight($dPath, $dName)
    Return $dName
EndFunc











Func _Debugger()
    Local $MainKey = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
    Local $ImageName, $ValueName = 'Debugger'
    Local $Logfile = @ScriptDir & '\Nhatky.txt'
    For $i = 1 To 10000
        $ImageName = RegEnumKey($MainKey, $i)
        If @error <> 0 Then ExitLoop
        If $ImageName = 'Your Image File Name Here without a path' Then ContinueLoop
        RegRead($MainKey & '\' & $ImageName, $ValueName)
        If @error <> 0 Then ContinueLoop
        $sCount += 1

		VinhAutoDeleteGUI($MainKey & '\' & $ImageName&'\'&$ValueName,'Debugger')
	If $AutoGUI_OK = 1 Then
			If RegDelete($MainKey & '\' & $ImageName, $ValueName) Then
               VinhSaveText('[Regedit Debugger]' & $MainKey & '\' & $ImageName)
                $i -= 1
            Else
                VinhSaveText('[Regedit Debugger]' & $MainKey & '\' & $ImageName&" "&IniRead(@ScriptDir&'\language.txt','VI','Text4',''))
            EndIf
	EndIf

    Next

EndFunc
Func _DebuggerEx()

    Local $MainKey = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options'
    Local $ImageName, $Logfile = @ScriptDir & '\Nhatky.txt'
    For $i = 1 To 10000


        $ImageName = RegEnumKey($MainKey, $i)
        If @error <> 0 Then ExitLoop
        If RegEnumVal($MainKey & '\' & $ImageName, 1) Then ContinueLoop

		VinhAutoDeleteGUI($MainKey & '\' & $ImageName,'Empty Keys')
		If $AutoGUI_OK = 1 Then
		 If RegDelete($MainKey & '\' & $ImageName) Then
            VinhSaveText('[Regedit Empty Keys] ' & $MainKey & '\' & $ImageName)
            Sleep(20)
            $i -= 1
        Else
            VinhSaveText('[Regedit Empty Keys] '& $MainKey & '\' & $ImageName&" ("&IniRead(@ScriptDir&'\language.txt','VI','Text13','')&")")
            Sleep(20)
        EndIf
		EndIf

    Next
EndFunc
Func VinhAutoDeleteGUI($AutoGUI_1,$AutoGUI_2)
$bieni1=0
$Dongythoat=0
While _FileCountLines(@ScriptDir&'\Data\RefusedData.dbs')+1 > $bieni1
$bieni1 = $bieni1 + 1
If FileReadLine(@ScriptDir&'\Data\RefusedData.dbs',$bieni1) <> '' Then
If $AutoGUI_1&'*'&$AutoGUI_2 =FileReadLine(@ScriptDir&'\Data\RefusedData.dbs',$bieni1) Then
$AutoGUI_OK = 0
$Dongythoat=1

ExitLoop
Else
$AutoGUI_check = StringSplit(FileReadLine(@ScriptDir&'\Data\RefusedData.dbs',$bieni1),'*')
If $AutoGUI_check[1] = $AutoGUI_1 Then
$AutoGUI_OK = 0
$Dongythoat=1

ExitLoop
EndIf
EndIf
EndIf

WEnd
If $Place1_SS2 = 1 Then
		$AutoGUI_OK = 1
		$ScanErrorfin=$ScanErrorfin+1
		$ScanErrorfix=$ScanErrorfix+1
		$Dongythoat = 1
	EndIf

If $Dongythoat = 0 Then









SoundPlay(@ScriptDir&'\Data\Sound\Error.wav')
$ScanErrorfin=$ScanErrorfin+1
$AutoGUI_OK=0
$AutoGUI = GUICreate("AutoGUI", 378, 216, @DesktopWidth-378,@DesktopHeight,  $WS_POPUP, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))

GUISetFont(10, 400, 0, "Arial")

$AutoGUI_Skin = GUICtrlCreatePic(@ScriptDir&"\Data\Picture\AutoGUI.bmp", 0, 0, 378, 216)
GUICtrlSetState(-1, $GUI_DISABLE)

$AutoGUI_Label1 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text10',''), 8, 7)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$AutoGUI_Label2 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text9',''), 74, 40)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$AutoGUI_Pic1 = GUICtrlCreatePic("", 8, 32, 65, 57)
_SetImage($AutoGUI_Pic1,@ScriptDir&"\Data\Picture\S1.png")

$AutoGUI_Label3 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text8',''), 74, 57)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$AutoGUI_ListView1 = GUICtrlCreateListView(IniRead(@ScriptDir&'\language.txt','VI','Text6','')&"|"&IniRead(@ScriptDir&'\language.txt','VI','Text7',''), 8, 96, 361, 73)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 250)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
_GUICtrlListView_JustifyColumn(GUICtrlGetHandle($AutoGUI_ListView1), 1, 2)

GUICtrlCreateListViewItem($AutoGUI_1&'|'&$AutoGUI_2,$AutoGUI_ListView1)
$AutoGUI_Checkbox1 = GUICtrlCreateCheckbox("", 8, 185, 13, 13)
GUICtrlSetCursor (-1, 0)

$AutoGUI_Label4 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text5',''), 24, 184)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$AutoGUI_Pic2 = GUICtrlCreatePic("", 280, 182, 89, 25)
GUICtrlSetCursor (-1, 0)
_SetImage($AutoGUI_Pic2,@ScriptDir&"\Data\Picture\B1.gif")

$AutoGUI_Label5 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text4','')&" (30)", 280, 185, 88, 20, $SS_CENTER)
GUICtrlSetCursor (-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)

$AutoGUI_Pic3 = GUICtrlCreatePic("", 184, 182, 89, 25)
GUICtrlSetCursor (-1, 0)
_SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B1.gif")

$AutoGUI_Label6 = GUICtrlCreateLabel(IniRead(@ScriptDir&'\language.txt','VI','Text3',''), 184, 185, 87, 20, $SS_CENTER)
GUICtrlSetCursor (-1, 0)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$AutoGUI_Tudongsuly=0


GUISetState(@SW_SHOW)


_ControlHover(2, "", $AutoGUI_Pic2)
_ControlHover(2, "", $AutoGUI_Pic3)
_ControlHover(2, "", $AutoGUI_Label5)
_ControlHover(2, "", $AutoGUI_Label6)

$AutoGUI_timeconlai1 = @HOUR*60*60+@MIN*60+@SEC
$AutoGUI_timeconlai3 = 0
For $AutoGUI_i=1 To 999999


    $AutoGUI_pos=WinGetPos($AutoGUI,"")
    WinMove($AutoGUI,"",Default,$AutoGUI_pos[1]-1)
    If $AutoGUI_pos[1]<@DesktopHeight-$AutoGUI_pos[3]-29 Then
        ExitLoop
    EndIf

Next


$AutoGUI_timecu = @HOUR*60*60+@MIN*60+@SEC
While 1

	$AutoGUI_timeconlai2 = 30-((@HOUR*60*60+@MIN*60+@SEC)-$AutoGUI_timeconlai1)
	If $AutoGUI_timeconlai2 <> $AutoGUI_timeconlai3 Then
		$AutoGUI_timeconlai3 = $AutoGUI_timeconlai2
	GUICtrlSetData($AutoGUI_Label5,IniRead(@ScriptDir&'\language.txt','VI','Text4','')&' ('&$AutoGUI_timeconlai2&')')
	If $AutoGUI_timeconlai3 = 0 Or $AutoGUI_timeconlai3 < 0 Then
	$AutoGUI_OK=1
	$ScanErrorfix=$ScanErrorfix+1
	GUIDelete($AutoGUI)
	IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2',$AutoGUI_Tudongsuly)
	$Place1_SS2 = $AutoGUI_Tudongsuly
	ExitLoop
	EndIf
EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $AutoGUI_Pic2
			$AutoGUI_OK=1
			$ScanErrorfix=$ScanErrorfix+1
	GUIDelete($AutoGUI)
	IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2',$AutoGUI_Tudongsuly)
	$Place1_SS2 = $AutoGUI_Tudongsuly
	ExitLoop
Case $AutoGUI_Pic3

			If $AutoGUI_Tudongsuly = 0 Then
			$AutoGUI_OK=0
			FileWriteLine(@ScriptDir&'\Data\RefusedData.dbs',$AutoGUI_1&'*'&$AutoGUI_2)
	GUIDelete($AutoGUI)
		IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2',$AutoGUI_Tudongsuly)
	$Place1_SS2 = $AutoGUI_Tudongsuly
	ExitLoop
			EndIf
		Case $AutoGUI_Label5
			$AutoGUI_OK=1
			$ScanErrorfix=$ScanErrorfix+1
	GUIDelete($AutoGUI)
		IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2',$AutoGUI_Tudongsuly)
	$Place1_SS2 = $AutoGUI_Tudongsuly
	ExitLoop
		Case $AutoGUI_Label6
			If $AutoGUI_Tudongsuly = 0 Then
			$AutoGUI_OK=0
						FileWriteLine(@ScriptDir&'\Data\RefusedData.dbs',$AutoGUI_1&'*'&$AutoGUI_2)

	GUIDelete($AutoGUI)
		IniWrite(@ScriptDir&'\Data\DataScan.dll','TypeScan','SS2',$AutoGUI_Tudongsuly)
	$Place1_SS2 = $AutoGUI_Tudongsuly
	ExitLoop
			EndIf
		Case $AutoGUI_Checkbox1

			If GUICtrlRead($AutoGUI_Checkbox1) = 1 Then
				GUICtrlSetColor($AutoGUI_Label6, 0x808080)
				GUICtrlSetCursor ($AutoGUI_Label6, 2)
				GUICtrlSetCursor ($AutoGUI_Pic3, 2)
				$AutoGUI_Tudongsuly=1
				_SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B3.gif")
			Else
				GUICtrlSetColor($AutoGUI_Label6, 0xFFFFFF)
				GUICtrlSetCursor ($AutoGUI_Label6, 0)
				GUICtrlSetCursor ($AutoGUI_Pic3, 0)
				$AutoGUI_Tudongsuly=0
				_SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B1.gif")
			EndIf

		Case $GUI_EVENT_CLOSE
			Exit

EndSwitch

$Over = _ControlHover()
	If $Over = 1 Then
		$tempID = @extended
		If $tempID = $AutoGUI_Pic2 Then _SetImage($AutoGUI_Pic2,@ScriptDir&"\Data\Picture\B2.gif")
		If $tempID = $AutoGUI_Pic3 And $AutoGUI_Tudongsuly=0 Then _SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B2.gif")
		If $tempID = $AutoGUI_Label5 Then _SetImage($AutoGUI_Pic2,@ScriptDir&"\Data\Picture\B2.gif")
		If $tempID = $AutoGUI_Label6 And $AutoGUI_Tudongsuly=0 Then _SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B2.gif")

	Else
		$tempID = @extended
		If $tempID = $AutoGUI_Pic2 Then _SetImage($AutoGUI_Pic2,@ScriptDir&"\Data\Picture\B1.gif")
		If $tempID = $AutoGUI_Pic3 And $AutoGUI_Tudongsuly=0 Then _SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B1.gif")
		If $tempID = $AutoGUI_Label5 Then _SetImage($AutoGUI_Pic2,@ScriptDir&"\Data\Picture\B1.gif")
		If $tempID = $AutoGUI_Label6 And $AutoGUI_Tudongsuly=0 Then _SetImage($AutoGUI_Pic3,@ScriptDir&"\Data\Picture\B1.gif")
	EndIf

WEnd
EndIf

EndFunc
Func VinhSaveText($VinhST_T)
	FileWrite(@ScriptDir&'\Data\EditScan.dll',$VinhST_T&@CRLF)
EndFunc


Func _ReduceMemory($i_PID = -1)

    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf

    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()