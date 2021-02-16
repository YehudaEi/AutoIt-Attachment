#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
#include <Process.au3>
#Include <File.au3>
#Include <Array.au3>

$CurrentVersion = "1.2"

#Region Splash
SplashImageOn("", @ScriptDir & "/Data/Splash.bmp", -1, -1, -1, -1, 1)

Global $Form2, $Form3, $Form4, $Button33, $Button34, $Button35, $Button36, $Button37, $Button38, $Checkbox21, $Checkbox22, $Checkbox23, $Progress1, $Dload, $Button2, $Input6, $Input7, $Input8

Opt("TrayMenuMode",1)

$Net = Ping("www.google.hu")
$QuickRun = @StartupCommonDir
$Settings = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Settings")
$Update = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoUpdate")

Global $FileURL = "                                   "
Global $FileName = @ScriptDir & "\Win_Clean.zip"
Global $Label = GUICtrlCreateLabel("", 5, 5, 270, 20)

If $Update = "" Then
	$Update = 0
EndIf

InetGet("                                                     ", @ScriptDir & "/Server.ini", 1,0)

$vers = IniRead(@ScriptDir & "/Server.ini", "Version", "Version", "0")

RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Installed", "REG_SZ", "Telepítve")
RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Version", "REG_SZ", "1.0")

$Input1 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input1", "A Tallózás gombbal válassz ki egy mappát!")
$Input2 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input2", "A Tallózás gombbal válassz ki egy mappát!")
$Input3 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input3", "A Tallózás gombbal válassz ki egy mappát!")
$Input4 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input4", "A Tallózás gombbal válassz ki egy mappát!")
$Input5 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input5", "A Tallózás gombbal válassz ki egy mappát!")

If $input1 = "" Then
	$input1 = "A Tallózás gombbal válassz ki egy mappát!"
EndIf
			
If $input2 = "" Then
	$input2 = "A Tallózás gombbal válassz ki egy mappát!"
EndIf
			
If $input3 = "" Then
	$input3 = "A Tallózás gombbal válassz ki egy mappát!"
EndIf
			
If $input4 = "" Then
	$input4 = "A Tallózás gombbal válassz ki egy mappát!"
EndIf
			
If $input5 = "" Then
	$input5 = "A Tallózás gombbal válassz ki egy mappát!"
EndIf

SplashOff()
#EndRegion SplashOff

If $Net = 0 Then
	msgbox(64, "Win-Cleaner", "Nincs internetkapcsolat ezáltal a frissítés funkció nem elérhetõ!")
EndIf

If $Update = 1 Then
	If $vers > $CurrentVersion Then
		$upd = msgbox(68, "Win-Cleaner", "Jelenlegi Verzió: " & $CurrentVersion & @CRLF & "Frissített verzió: " & $vers & @CRLF & "Le szeretnéd tölteni a legutolsó elérhetõ frissítést?")

		If $upd = 6 Then
			_InetGetGUI($FileURL, $FileName, $Label, $Progress1, $Button2)
		EndIf
	EndIf
EndIf

If $Settings = 0 Then
	Msgbox(0,"Win_Clean", 'Mielõtt elindítod a tisztítást kérlek állítsd be a "Beállítások" menüpontban a már tisztítani kívánt programok listáját!')
EndIf

#Region ### START Koda GUI section ### Form=form1.kxf
$Form1 = GUICreate("Win-Clean", 431, 291, 255, 145)
GUISetIcon(@ScriptDir & "/Data/cleaner.ico")
$Dummy1 = GUICtrlCreateDummy()
$Button2 = GUICtrlCreateButton("asd",40,40,40,40)
GuiCtrlSetState($Button2, $GUI_HIDE)
$PageControl1 = GUICtrlCreateTab(8, 8, 416, 256)
GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetState(-1, $GUI_CHECKED)
$MenuItem3 = GUICtrlCreateMenu("&Fájl")
$MenuItem6 = GUICtrlCreateMenuItem("Frissítés", $MenuItem3)
$MenuItem4 = GUICtrlCreateMenuItem("Kilépés", $MenuItem3)
$MenuItem2 = GUICtrlCreateMenu("&Eszközök")
$MenuItem7 = GUICtrlCreateMenuItem("Opciók", $MenuItem2)
$MenuItem9 = GUICtrlCreateMenuItem("Gamer MediaPlayer", $MenuItem2)
$MenuItem10 = GUICtrlCreateMenuItem("CleanMgr", $MenuItem2)
$MenuItem11 = GUICtrlCreateMenuItem("Konzol", $MenuItem2)
$MenuItem1 = GUICtrlCreateMenu("&Segítség")
$MenuItem15 = GUICtrlCreateMenuItem("Verzió", $MenuItem1)
$MenuItem13 = GUICtrlCreateMenuItem("Használat", $MenuItem1)
$MenuItem12 = GUICtrlCreateMenuItem("Weboldal", $MenuItem1)
$TabSheet1 = GUICtrlCreateTabItem("Tisztítás")
$Checkbox1 = GUICtrlCreateCheckbox("Böngészõk tisztítása", 32, 48, 129, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox2 = GUICtrlCreateCheckbox("Programok utáni tisztítás", 32, 72, 145, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox3 = GUICtrlCreateCheckbox("Windows Temp Fájljainak törlése", 32, 96, 177, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox4 = GUICtrlCreateCheckbox("Lomtár Kiürítése", 32, 120, 185, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button1 = GUICtrlCreateButton("Tisztítás Futtatása", 32, 208, 105, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Icon1 = GUICtrlCreateIcon(@ScriptDir & "/Data/Logo.ico", 0, 208, 48, 177, 196, BitOR($SS_NOTIFY,$WS_GROUP))
$Checkbox5 = GUICtrlCreateCheckbox("Egyedi helyek törlése", 32, 144, 137, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Checkbox15 = GUICtrlCreateCheckbox("Thumbs.db fájlok törlése (fölösleges)", 32, 168, 201, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Button70 = GUICtrlCreateButton("Mindent Tisztít", 144, 208, 105, 25, 0)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")

GUICtrlCreateTabItem("Egyedi Sorok")
$Input1 = GUICtrlCreateInput($Input1, 16, 56, 289, 21)
$Input2 = GUICtrlCreateInput($Input2, 16, 96, 289, 21)
$Input3 = GUICtrlCreateInput($Input3, 16, 136, 289, 21)
$Input4 = GUICtrlCreateInput($Input4, 16, 176, 289, 21)
$Input5 = GUICtrlCreateInput($Input5, 16, 216, 289, 21)
$Button9 = GUICtrlCreateButton("Tallózás", 320, 56, 73, 21, 0)
$Button10 = GUICtrlCreateButton("Tallózás", 320, 96, 73, 21, 0)
$Button11 = GUICtrlCreateButton("Tallózás", 320, 136, 73, 21, 0)
$Button12 = GUICtrlCreateButton("Tallózás", 320, 176, 73, 21, 0)
$Button13 = GUICtrlCreateButton("Tallózás", 320, 216, 73, 21, 0)

$TabSheet4 = GUICtrlCreateTabItem("Beállítások")
$Label16 = GUICtrlCreateLabel("Válaszd ki, hogy milyen programok vannak", 16, 40, 202, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$Label17 = GUICtrlCreateLabel("Feltelepítve a számítógépedre!", 16, 56, 149, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$Checkbox6 = GUICtrlCreateCheckbox("Internet Explorer", 16, 88, 145, 17)
$Checkbox7 = GUICtrlCreateCheckbox("Google Chrome", 16, 104, 145, 17)
$Checkbox8 = GUICtrlCreateCheckbox("Mozzila Firefox", 16, 120, 129, 17)
$Checkbox9 = GUICtrlCreateCheckbox("Avant Browser", 16, 136, 129, 17)
$Checkbox10 = GUICtrlCreateCheckbox("Opera Browser", 16, 152, 121, 17)
$Checkbox11 = GUICtrlCreateCheckbox("MSN messenger", 16, 184, 113, 17)
$Checkbox12 = GUICtrlCreateCheckbox("Spybot Search and Destroy", 16, 200, 153, 17)
$Checkbox13 = GUICtrlCreateCheckbox("Punkbuster [PB]", 16, 216, 105, 17)
$Checkbox14 = GUICtrlCreateCheckbox("Macromedia Flash Player", 16, 232, 145, 17)
$Label18 = GUICtrlCreateLabel("Programok:", 16, 168, 58, 17)
$Label19 = GUICtrlCreateLabel("Böngészõk:", 16, 72, 60, 17)
$Button6 = GUICtrlCreateButton("!!! Beállítások mentése !!!", 200, 232, 193, 25, 0)

$TabSheet3 = GUICtrlCreateTabItem("About")
$Label5 = GUICtrlCreateLabel("", 8, 40, 4, 4)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
$Label6 = GUICtrlCreateLabel("Win-Cleaner v" & $CurrentVersion, 120, 40, 142, 27)
GUICtrlSetFont(-1, 12, 800, 4, "comic sans ms")
$Label7 = GUICtrlCreateLabel("Készítette: Unc3nZureD", 120, 64, 133, 19)
GUICtrlSetFont(-1, 9, 400, 0, "arial")
$Label8 = GUICtrlCreateLabel("> Külön köszönet:", 104, 88, 101, 19)
GUICtrlSetFont(-1, 9, 400, 0, "arial")
$Label11 = GUICtrlCreateLabel("Elérhetõségeim:", 120, 152, 95, 19)
GUICtrlSetFont(-1, 9, 400, 4, "arial")
$Label12 = GUICtrlCreateLabel("Xfire: Unc3nZureD", 136, 176, 104, 19)
GUICtrlSetFont(-1, 9, 400, 0, "arial")
$Label13 = GUICtrlCreateLabel("E-mail:", 136, 192, 43, 19)
GUICtrlSetFont(-1, 9, 400, 0, "arial")
$Label14 = GUICtrlCreateLabel("Rol4nd@Freemail.hu", 184, 192, 122, 19)
GUICtrlSetFont(-1, 9, 400, 0, "arial")
$Label15 = GUICtrlCreateLabel(" Spirit - tesztelõ", 200, 88, 87, 19)
GUICtrlSetFont(-1, 9, 400, 0, "Arial")
$Label22 = GUICtrlCreateLabel('"Yes, I will see u, Through the Smokin' & "'" & ' Flames - on the Frontlines of War"', 13, 240, 400, 18)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlCreateTabItem("")
GUISetState(@SW_SHOW, $Form1)
#EndRegion ### END Koda GUI section ###

GUICtrlSetState($Checkbox15, $GUI_HIDE)

If $Settings = "" Then
	GuiCtrlSetState ($Button1, $GUI_HIDE)
EndIf

If $Settings = "" Then
	GuiCtrlSetState($Button70, $GUI_HIDE)
EndIf

While 1
	
$aMsg = GUIGetMsg(1)

	Switch $aMsg[1]

		Case $Form1
			Switch $aMsg[0]
		Case $GUI_EVENT_CLOSE 
			exit 0
		Case $MenuItem4
			exit 0
		Case $Menuitem12
			msgbox(64,"Info", "A weboldal jelenleg nem üzemel.")
;~ 			$rc = _RunDos("start Http://www.WinClean.webnode.com")
		Case $Menuitem15
			msgbox(64, "Verzió", "Jelenlegi verzió: " & $CurrentVersion & @CRLF & "Legutolsó verzió: " & $Vers)
		Case $Menuitem10
			Run("Cleanmgr.exe")
		Case $Menuitem7
			_Form4()
		Case $Menuitem11
			$AllowConsole = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AllowConsole")
			
			If $AllowConsole = "0" Then
				msgbox(64, "Védelem", "A Konzol beállítás le van tiltva!")
			EndIf
			
			If $AllowConsole = "" Then
				msgbox(64, "Védelem", "A Konzol beállítás le van tiltva!")
			EndIf
			
			If $AllowConsole = 1 Then
				_Form3()
			EndIf
		
		Case $Menuitem13
			_Form2()
		Case $Menuitem9
			$player = FileExists(@ScriptDir & "\Downloads\Mediaplayer.exe")
			If $Player = 1 Then
				Run(@ScriptDir & "\Downloads\Mediaplayer.exe")
			EndIf
			
			If $Player = 0  Then
				$FileURL2 = "                                     "
				$FileName2 = @ScriptDir & "\Downloads\Mediaplayer.exe"
				_InetGetGUI($FileURL, $FileName, $Label, $Progress1, $Button2)
				Run(@ScriptDir & "\Downloads\Mediaplayer.exe")
			EndIf
		Case $MenuItem6
			If $vers = $CurrentVersion Then
				msgbox(64, "Win-Cleaner", "Nincsen újabb verzió!" & @CRLF & "Jelenlegi verió: " & $CurrentVersion)
			EndIf
			
			If $vers > $CurrentVersion Then
				$upd = msgbox(68, "Win-Cleaner", "Jelenlegi Verzió: " & $CurrentVersion & @CRLF & "Frissített verzió: " & $vers & @CRLF & "Le akarja tölteni a legutolsó elérhetõ frissítést?")

					If $upd = 6 Then
						$FileURL = "                                   "
						$FileName = @ScriptDir & "\Win_Clean.zip"
						_InetGetGUI($FileURL, $FileName, $Label, $Progress1, $Button2)
					EndIf
			EndIf
		
	Case $Button70
		_BatchWrite()
			RunWait(@ScriptDir & "\Data\Temp_Batch\Avant.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\Opera.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\Firefox.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\Chrome.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\IE.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\PB.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\S&D.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\FlashPlayer.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\MSN.bat")
			RunWait(@ScriptDir & "\Data\Temp_Batch\Temp.bat")
			FileDelete(@ScriptDir & "\Data\Temp_Batch\")
			FileRecycleEmpty()
			msgbox(64,"One-Click-Clean", "Tisztítás befejezve!")
		Case $Button1
				$Settings2 = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Settings")
				
				If $Settings2 = 0 Then
					msgbox(48, "Win_Clean", "Nem állítottál be még semmit telepített programként!")
				EndIf
				
			$Check1 = BitAnd(GUICtrlRead($Checkbox1),$GUI_CHECKED)
			$Check2 = BitAnd(GUICtrlRead($Checkbox2),$GUI_CHECKED)
			$Check3 = BitAnd(GUICtrlRead($Checkbox3),$GUI_CHECKED)
			$Check4 = BitAnd(GUICtrlRead($Checkbox4),$GUI_CHECKED)
			$Check5 = BitAnd(GUICtrlRead($Checkbox5),$GUI_CHECKED)
			$Check6 = BitAnd(GUICtrlRead($Checkbox14),$GUI_CHECKED)
			
			$Avant = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Avant")
			$Chrome = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Chrome")
			$FireFox = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Firefox")
			$Flash = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Flash")
			$IE = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "IE")
			$MSN = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "MSN")
			$Opera = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Opera")
			$PB = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Punkbuster")
			$SD = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Spybot")
			
			$1 = RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Guard", "REG_SZ", "1")
			_BatchWrite()
			
				If $Check1 = 1 Then
					If $Avant = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\Avant.bat")
					EndIf
					
					If $Opera = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\Opera.bat")
					EndIf
					
					If $Firefox = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\Firefox.bat")
					EndIf
					
					If $Chrome = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\Chrome.bat")
					EndIf
					
					If $IE = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\IE.bat")
					EndIf
				
				EndIf
				
				If $Check2 = 1 Then
					If $PB = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\PB.bat")
					EndIf
					
					If $SD = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\S&D.bat")
					EndIf
					
					If $Flash = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\FlashPlayer.bat")
					EndIf
					
					If $MSN = "On" Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\MSN.bat")
					EndIf
				EndIf
				
				If $Check3 = 1 Then
					RunWait(@ScriptDir & "\Data\Temp_Batch\Temp.bat")
				EndIf
				
				If $Check4 = 1 Then
					FileRecycleEmpty()
				EndIf
				
				If $Check5 = 1 Then
					$Input1 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input1", "A Tallózás gombbal válassz ki egy mappát!")
					$Input2 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input2", "A Tallózás gombbal válassz ki egy mappát!")
					$Input3 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input3", "A Tallózás gombbal válassz ki egy mappát!")
					$Input4 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input4", "A Tallózás gombbal válassz ki egy mappát!")
					$Input5 = IniRead(@ScriptDir & "\UniqPaths.ini", "Path", "Input5", "A Tallózás gombbal válassz ki egy mappát!")
					
					$input = _FileCreate(@ScriptDir & "\Data\Uniq.bat")
					
					FileOpen(@ScriptDir & "\Data\Uniq.bat", 1)
					FileWriteLine($input,"COLOR 02")
					FileWriteLine($input, "del /f /s /q " & '"' & $Input1 & '"')
					FileWriteLine($input, "del /f /s /q " & '"' & $Input2 & '"')
					FileWriteLine($input, "del /f /s /q " & '"' & $Input3 & '"')
					FileWriteLine($input, "del /f /s /q " & '"' & $Input4 & '"')
					FileWriteLine($input, "del /f /s /q " & '"' & $Input5 & '"')
					FileClose($input)
					
					RunWait(@ScriptDir & "\Data\Uniq.bat")
					FileDelete(@ScriptDir & "\Data\Uniq.bat")
				EndIf
				
				msgbox(64, "Win_clean", "Az optimizálás befejezõdött!")
				FileDelete(@ScriptDir & "\Data\Temp_Batch\*.*")
				
			Case $Button6
			$Check6 = BitAnd(GUICtrlRead($Checkbox6),$GUI_CHECKED)
			$Check7 = BitAnd(GUICtrlRead($Checkbox7),$GUI_CHECKED)
			$Check8 = BitAnd(GUICtrlRead($Checkbox8),$GUI_CHECKED)
			$Check9 = BitAnd(GUICtrlRead($Checkbox9),$GUI_CHECKED)
			$Check10 = BitAnd(GUICtrlRead($Checkbox10),$GUI_CHECKED)
			$Check11 = BitAnd(GUICtrlRead($Checkbox11),$GUI_CHECKED)
			$Check12 = BitAnd(GUICtrlRead($Checkbox12),$GUI_CHECKED)
			$Check13 = BitAnd(GUICtrlRead($Checkbox13),$GUI_CHECKED)
			$Check14 = BitAnd(GUICtrlRead($Checkbox14),$GUI_CHECKED)
			
			If $Check6 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "IE", "REG_SZ", "On")
			EndIf
			
			If $Check7 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Chrome", "REG_SZ", "On")
			EndIf
			
			If $Check8 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Firefox", "REG_SZ", "On")
			EndIf
			
			If $Check9 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Avant", "REG_SZ", "On")
			EndIf
			
			If $Check10 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Opera", "REG_SZ", "On")
			EndIf
			
			If $Check11 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "MSN", "REG_SZ", "On")
			EndIf
			
			If $Check12 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Spybot", "REG_SZ", "On")
			EndIf
			
			If $Check13 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Punkbuster", "REG_SZ", "On")
			EndIf
			
			If $Check14 = 1 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Flash", "REG_SZ", "On")
			EndIf
			
			If $Check6 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "IE", "REG_SZ", "Off")
			EndIf
			
			If $Check7 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Chrome", "REG_SZ", "Off")
			EndIf
			
			If $Check8 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Firefox", "REG_SZ", "Off")
			EndIf
			
			If $Check9 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Avant", "REG_SZ", "Off")
			EndIf
			
			If $Check10 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Opera", "REG_SZ", "Off")
			EndIf
			
			If $Check11 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "MSN", "REG_SZ", "Off")
			EndIf
			
			If $Check12 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Spybot", "REG_SZ", "Off")
			EndIf
			
			If $Check13 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Punkbuster", "REG_SZ", "Off")
			EndIf
			
			If $Check14 = 0 Then
				RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Flash", "REG_SZ", "Off")
			EndIf
			
			RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "Settings", "REG_SZ", "1")
			msgbox(0,"Win_Clean", "Beállítások elmentve!")
			GUICtrlSetState($Button1, $GUI_SHOW)
			GUICtrlSetState($Button70, $GUI_SHOW)
			
		Case $Button9
			$uniq1 = FileSelectFolder ("Törölni kívánt mappa", "" , 2)
			If $uniq1 = "" Then
				$uniq1 = "A Tallózás gombbal válassz ki egy mappát!"
			EndIf
			GUICtrlSetData($Input1, '"' & $uniq1 & '"')
			IniWrite(@ScriptDir & "\UniqPaths.ini", "Path", "Input1", '"' & $uniq1 & '"')
		Case $Button10
			$uniq2 = FileSelectFolder ("Törölni kívánt mappa", "" , 2)
			If $uniq2 = "" Then
				$uniq2 = "A Tallózás gombbal válassz ki egy mappát!"
			EndIf
			GUICtrlSetData($Input2, '"' & $uniq2 & '"')
			IniWrite(@ScriptDir & "\UniqPaths.ini", "Path", "Input2", '"' & $uniq2 & '"')
		Case $Button11
			$uniq3 = FileSelectFolder ("Törölni kívánt mappa", "" , 2)
			If $uniq3 = "" Then
				$uniq3 = "A Tallózás gombbal válassz ki egy mappát!"
			EndIf
			GUICtrlSetData($Input3, '"' & $uniq3 & '"')
			IniWrite(@ScriptDir & "\UniqPaths.ini", "Path", "Input3", '"' & $uniq3 & '"')
		Case $Button12
			$uniq4 = FileSelectFolder ("Törölni kívánt mappa", "" , 2)
			If $uniq4 = "" Then
				$uniq4 = "A Tallózás gombbal válassz ki egy mappát!"
			EndIf
			GUICtrlSetData($Input4, '"' & $uniq4 & '"')
			IniWrite(@ScriptDir & "\UniqPaths.ini", "Path", "Input4", '"' & $uniq4 & '"')
		Case $Button13
			$uniq5 = FileSelectFolder ("Törölni kívánt mappa", "" , 2)
			If $uniq5 = "" Then
				$uniq5 = "A Tallózás gombbal válassz ki egy mappát!"
			EndIf
			GUICtrlSetData($Input5, '"' & $uniq5 & '"')
			IniWrite(@ScriptDir & "\UniqPaths.ini", "Path", "Input5", '"' & $uniq5 & '"')
		EndSwitch
		
		Case $Form2
			Switch $aMsg[0]
		Case $GUI_EVENT_CLOSE 
			GUIDelete($Form2)
		 EndSwitch
		 
		 Case $Form3
			Switch $aMsg[0]
		Case $GUI_EVENT_CLOSE 
			GUIDelete($Form3)
		Case $Button33
 			$download = GUICtrlRead ($Input6)
			$NewPing = Ping($download)
			msgbox(64,"PingTest", "Result: "& $NewPing)
			$rc = _RunDos("start " & $download)
		Case $Button34
			$consoleinput = GUICtrlRead ($Input7)
 			$Konzol = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Console.bat")
			FileOpen(@ScriptDir & "\Data\Temp_Batch\Console.bat", 1)
			FileWriteLine($Konzol,"COLOR 02")
			FileWriteLine($Konzol, $consoleinput)
			FileWriteLine($Konzol, "Pause > nul")
			FileClose($Konzol)
			RunWait(@ScriptDir & "\Data\Temp_Batch\Console.bat")
		Case $Button35
 			$consoleinput = GUICtrlRead ($Input8)
 			$Konzol = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Console.bat")
			FileOpen(@ScriptDir & "\Data\Temp_Batch\Console.bat", 1)
			FileWriteLine($Konzol,"COLOR 02")
			FileWriteLine($Konzol, $consoleinput)
			FileWriteLine($Konzol, "Pause > nul")
			FileClose($Konzol)
			RunWait(@ScriptDir & "\Data\Temp_Batch\Console.bat")
		 EndSwitch
		 
		 Case $Form4
			Switch $aMsg[0]
			Case $GUI_EVENT_CLOSE 
				GUIDelete($Form4)
			Case $Button38
				GUIDelete($Form4)
			Case $Button36
				$Check21 = BitAnd(GUICtrlRead($Checkbox21),$GUI_CHECKED)
				$Check22 = BitAnd(GUICtrlRead($Checkbox22),$GUI_CHECKED)
				$Check23 = BitAnd(GUICtrlRead($Checkbox23),$GUI_CHECKED)
				
				If $Check21 = 1 Then
					FileCreateShortcut(@ScriptFullPath, @StartupCommonDir & "\Win-Clean.Ink")
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoRun", "REG_SZ", "1")
				EndIf
				
				If $Check22 = 1 Then
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoUpdate", "REG_SZ", "1")
				EndIf
				
				If $Check23 = 1 Then
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AllowConsole", "REG_SZ", "1")
				EndIf
				
				If $Check21 = 0 Then
					FileDelete(@StartupCommonDir & "\Win-Clean.Ink")
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoRun", "REG_SZ", "0")
				EndIf
				
				If $Check22 = 0 Then
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoUpdate", "REG_SZ", "0")
				EndIf
				
				If $Check23 = 0 Then
					RegWrite("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AllowConsole", "REG_SZ", "0")
				EndIf
				msgbox(64,"Beállítások", "Beállítások elmentve!")
				GUIDelete($Form4)
			Case $Button37
				RegDelete("HKEY_CURRENT_USER\Software\Unc3nZureD_Products")
				msgbox(64,"Beállítások törlése", "Minden beállítás törölve")
			EndSwitch
EndSwitch
WEnd

Func _InetGetGUI($sFileURL, $sFileName, $hHandleLabel, $hHandleProgress, $hHandleButton)
	_DownloadGUI()
    Local $iPercentage, $iBytesRead, $sProgressText
    Local $FileSize = InetGetSize($sFileURL, 1)
    Local $hDownload = InetGet($sFileURL, $sFileName, 0, 1)
    If @error Then Return SetError(1, 1, 0)
    GUICtrlSetData($hHandleButton, "&Cancel")
    While Not InetGetInfo($hDownload, 2)
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $hHandleButton
                GUICtrlSetData($hHandleLabel, "Download Cancelled!")
                ExitLoop
        EndSwitch

        $iPercentage = InetGetInfo($hDownload, 0) * 100 / $FileSize
        $iBytesRead = InetGetInfo($hDownload, 0)
        $sProgressText = "Downloading " & _ByteSuffix($iBytesRead) & " of " & _ByteSuffix($FileSize)
        GUICtrlSetData($hHandleLabel, $sProgressText)
        GUICtrlSetData($hHandleProgress, $iPercentage)
        Sleep(100)
    WEnd
    InetClose($hDownload)
	msgbox(64,"Win-Clean", "A Frissítés letöltése befejezõdött. Megtalálhatod Win-Clean.zip néven a jelenlegi mappában.")
	GUIDelete($Dload)
	exit 0
    GUICtrlSetData($hHandleButton, "&Download")
EndFunc

Func _DownloadGUI()
		$Dload = GUICreate("Downloading...", 351, 39, 192, 124)
		$Progress1 = GUICtrlCreateProgress(8, 8, 329, 17)
		GUISetState(@SW_SHOW)
EndFunc

Func _ByteSuffix($iBytes)
    Local $A, $aArray[6] = [" B", " KB", " MB", " GB", " TB", " PB"]
    While $iBytes > 1023
        $A += 1
        $iBytes /= 1024
    WEnd
    Return Round($iBytes) & $aArray[$A]
EndFunc

Func _BatchWrite()
$User = @UserProfileDir
$TMP = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Temp.bat")
$SD = _FileCreate(@ScriptDir & "\Data\Temp_Batch\S&D.bat")
$PB = _FileCreate(@ScriptDir & "\Data\Temp_Batch\PB.bat")
$Flash = _FileCreate(@ScriptDir & "\Data\Temp_Batch\FlashPlayer.bat")
$Avant = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Avant.bat")
$Chrome = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Chrome.bat")
$Firefox = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Firefox.bat")
$IE = _FileCreate(@ScriptDir & "\Data\Temp_Batch\IE.bat")
$MSN = _FileCreate(@ScriptDir & "\Data\Temp_Batch\MSN.bat")
$Opera = _FileCreate(@ScriptDir & "\Data\Temp_Batch\Opera.bat")
$Drive = '"' & @HomeDrive & "\"
$ArrayZ = FileExists(@HomeDrive & "\Documents and Settings\NetworkService\Local Settings\Application Data\Mozilla\Firefox\Profiles")
$ArrayX = FileExists($User & '\Local Settings\Application Data\Mozilla\Firefox\Profiles\')

FileOpen(@ScriptDir & "\Data\Temp_Batch\Avant.bat", 1)
FileWriteLine($Avant,"COLOR 02")
FileWriteLine($Avant, 'del /f /s /q ' & '"' & $User & '\Application Data\Avant Profiles\.default\conf.dat.bak"')
FileWriteLine($Avant, 'del /f /s /q ' & '"' & $User & '\Application Data\Avant Profiles\.default\conf.dat.vdt"')
FileClose($Avant)

FileOpen(@ScriptDir & "\Data\Temp_Batch\Chrome.bat", 1)
FileWriteLine($Chrome,"COLOR 02")
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Cache\*.*"')
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Current Session\*.*"')
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Archived History\*.*"')
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Visited Links\*.*"')
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Current Tabs\*.*"')
FileWriteLine($Chrome,'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Local Storage\*.*"')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Cache')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Current Session"')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Archived History"')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Visited Links"')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Current Tabs"')
FileWriteLine($Chrome,'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Google\Chrome\User Data\Default\Local Storage"')
FileClose($Chrome)

FileOpen(@ScriptDir & "\Data\Temp_Batch\Firefox.bat", 1)
FileWriteLine($Firefox,"COLOR 02")
If $ArrayX = 1 Then
	$Array = _FileListToArray($User & "\Local Settings\Application Data\Mozilla\Firefox\Profiles", "*", 2)
	FileWriteLine($Firefox, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array[1] & '\Cache\*.*"')
	FileWriteLine($Firefox, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array[1] & '\OfflineCache\*.*"')
	FileWriteLine($Firefox, 'del /f /s /q ' & '"' & $User & '\Application Data\Mozilla\Firefox\Profiles\' & $Array[1] & '\downloads.sqlite"')
	FileWriteLine($Firefox, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array[1] & '\Cache"')
	FileWriteLine($Firefox, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array[1] & '\OfflineCache"')
EndIf
If $ArrayZ = 1 Then
	$Array2 = _FileListToArray(@HomeDrive & "\Documents and Settings\NetworkService\Local Settings\Application Data\Mozilla\Firefox\Profiles", "*", 2)
	FileWriteLine($Firefox, 'del /f /s /q ' & '"' & @HomeDrive & '\Documents and Settings\NetworkService\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array2[1] & '\Cache\*.*"')
	FileWriteLine($Firefox, 'rmdir /s /q ' & '"' & @HomeDrive & '\Documents and Settings\NetworkService\Local Settings\Application Data\Mozilla\Firefox\Profiles\' & $Array2[1] & '\Cache"')
EndIf
FileClose($Firefox)

FileOpen(@ScriptDir & "\Data\Temp_Batch\IE.bat", 1)
FileWriteLine($IE,"COLOR 02")
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\Default User\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\Default\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\LocalService\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\NetworkService\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q ' & '"' & $User & '\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\Default User\Local Settings\Temp\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\Default\Local Settings\Temp\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\LocalService\Local Settings\Temp\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q '& $Drive & 'Documents and Settings\NetworkService\Local Settings\Temp\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'del /f /s /q ' & '"' & $User & '\Local Settings\Temp\Temporary Internet Files\*.*"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\Default User\Local Settings\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\Default\Local Settings\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\LocalService\Local Settings\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\NetworkService\Local Settings\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q ' & '"' & $User & '\Local Settings\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\Default User\Local Settings\Temp\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\Default\Local Settings\Temp\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\LocalService\Local Settings\Temp\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q '& $Drive & '"Documents and Settings\NetworkService\Local Settings\Temp\Temporary Internet Files"')
FileWriteLine($IE, 'Rmdir /s /q ' & '"' & $User & '\Local Settings\Temp\Temporary Internet Files"')
FileClose($IE)

FileOpen(@ScriptDir & "\Data\Temp_Batch\MSN.bat", 1)
FileWriteLine($MSN,"COLOR 02")
FileWriteLine($MSN, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Microsoft\Messenger\ContactsLog.txt"')
FileWriteLine($MSN, 'del /f /s /q ' & '"' & $User & '\Application Data\Microsoft\Windows Live\Toolbar\Feeds\*.*"')
FileWriteLine($MSN, 'rmdir /s /q ' & '"' & $User & '\Application Data\Microsoft\Windows Live\Toolbar\Feeds"')
FileClose($MSN)

FileOpen(@ScriptDir & "\Data\Temp_Batch\Opera.bat", 1)
FileWriteLine($Opera, "COLOR 02")
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\application_cache\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\cache\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\icons\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\opcache\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\temporary_downloads\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\thumbnails\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\vps\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\pstorageq\*.*"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\global_history.dat')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\download.dat"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Operavlink4.dat"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\typed_history.xml"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\sessions\autosave.win"')
FileWriteLine($Opera, 'del /f /s /q ' & '"' & $User & '\Application Data\Opera\Opera\sessions\autsave.win.bak"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\application_cache"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\cache"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\icons"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\opcache"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\temporary_downloads"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\thumbnails"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Application Data\Opera\Opera\vps"')
FileWriteLine($Opera, 'rmdir /s /q ' & '"' & $User & '\Application Data\Opera\Opera\pstorageq"')
FileClose($Opera)

FileOpen(@ScriptDir & "\Data\Temp_Batch\Temp.bat", 1)
FileWriteLine($TMP,"COLOR 02")
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'WINDOWS\Temp\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\Default User\Cookies\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\Default User\Local Settings\Temp\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\Default User\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\LocalService\Cookies\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\LocalService\Local Settings\Temp\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\LocalService\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\NetworkService\Cookies\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\NetworkService\Local Settings\Temp\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\NetworkService\Local Settings\Temporary Internet Files\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & '"' & $User & '\Cookies\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & '"' & $User & '\Recent\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & '"' & $User & '\Local Settings\Temp\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'WINDOWS\system32\wbem\Logs\*.*"')
FileWriteLine($TMP, 'del /f /s /q ' & $Drive & 'Documents and Settings\All Users\Application Data\Microsoft\Dr Watson\*.*"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'WINDOWS\Temp"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\Default User\Cookies"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\Default User\Local Settings\Temp"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\Default User\Local Settings\Temporary Internet Files"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\LocalService\Cookies"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\LocalService\Local Settings\Temp"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\LocalService\Local Settings\Temporary Internet Files"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\NetworkService\Cookies"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\NetworkService\Local Settings\Temp"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\NetworkService\Local Settings\Temporary Internet Files"')
FileWriteLine($TMP, 'rmdir /s /q ' & '"' & $User & '\Cookies"')
FileWriteLine($TMP, 'rmdir /s /q ' & '"' & $User & '\Recent"')
FileWriteLine($TMP, 'rmdir /s /q ' & '"' & $User & '\Local Settings\Temp"')
FileWriteLine($TMP, 'rmdir /s /q ' & '"' & @WindowsDir & '\system32\wbem\Logs"')
FileWriteLine($TMP, 'rmdir /s /q ' & $Drive & 'Documents and Settings\All Users\Application Data\Microsoft\Dr Watson"')
FileClose($TMP)

FileOpen(@ScriptDir & "\Data\Temp_Batch\S&D.bat", 1)
FileWriteLine($SD, "COLOR 02")
FileWriteLine($SD, 'del /f /s /q ' & $Drive & 'Documents and Settings\All Users\Application Data\Spybot - Search & Destroy\Logs\Resident.log"')
FileClose($SD)

FileOpen(@ScriptDir & "\Data\Temp_Batch\PB.bat", 1)
FileWriteLine($PB,"COLOR 02")
FileWriteLine($PB, 'del /f /s /q ' & $Drive & 'WINDOWS\system32\LogFiles\PunkBuster"')
FileWriteLine($PB, 'rmdir /s /q ' & $Drive & 'WINDOWS\system32\LogFiles\PunkBuster"')
FileClose($PB)

FileOpen(@ScriptDir & "\Data\Temp_Batch\FlashPlayer.bat", 1)
FileWriteLine($Flash, "COLOR 02")
FileWriteLine($Flash, 'del /f /s /q ' & $User & '\Application Data\Macromedia\Flash Player\#SharedObjects"')
FileWriteLine($Flash, 'del /f /s /q ' & $User & '\Application Data\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys"')
FileWriteLine($Flash, 'rmdir /s /q ' & $User & '\Application Data\Macromedia\Flash Player\#SharedObjects"')
FileWriteLine($Flash, 'rmdir /s /q ' & $User & '\Application Data\Macromedia\Flash Player\macromedia.com\support\flashplayer\sys"')
FileClose($Flash)
EndFunc

Func _Form2()
$Form2 = GUICreate("Help", 361, 401, 376, 142)
$Label1 = GUICtrlCreateLabel("A program használata", 8, 152, 155, 20)
GUICtrlSetFont(-1, 10, 800, 4, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Leírás", 8, 8, 47, 20)
GUICtrlSetFont(-1, 10, 800, 4, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("A programmal az internetrõl letöltött ideiglenes fájlokat tudod törölni.", 8, 32, 319, 17)
$Label4 = GUICtrlCreateLabel("Minden egyes weboldal megnyitásakor a böngészõ akarva/akaratanul", 8, 48, 335, 17)
$Label5 = GUICtrlCreateLabel("letölti azokat a fájlokat amik szükségesek az oldal megnyitásához.", 8, 64, 314, 17)
$Label6 = GUICtrlCreateLabel("Ezeket a fájlokat a böngészõ nem törli le az oldal elhagyása után, mert", 8, 80, 334, 17)
$Label7 = GUICtrlCreateLabel("még késõbb hasznosak lehetnek. A program futtatásával van hogy akár", 8, 96, 343, 17)
$Label10 = GUICtrlCreateLabel("Ahhoz hogy el tudjuk kezdeni a tisztítást elõször be kell állítani a", 8, 176, 305, 17)
$Label11 = GUICtrlCreateLabel("fõmenüben hogy milyen programok után tisztítson. Ezt a lehetõséget", 8, 192, 324, 17)
$Label12 = GUICtrlCreateLabel("a fõmenüben a 'Beállítások' menüpontban találhatod meg.", 8, 208, 277, 17)
$Label13 = GUICtrlCreateLabel("Az Eszközök/Opciók részlegen a következõ dolgokat lehet beállítani:", 8, 240, 332, 17)
$Label14 = GUICtrlCreateLabel("- Automatikus indítás a windows-al (szerintem ide nem kell magyarázat)", 24, 256, 335, 17)
$Label15 = GUICtrlCreateLabel("- Frissítések automatikus keresése -> A program indításakor azonnal", 24, 272, 324, 17)
$Label16 = GUICtrlCreateLabel("megkeresi és felajánlja az újabb", 200, 288, 153, 17)
$Label17 = GUICtrlCreateLabel("verzió letöltését", 200, 304, 77, 17)
$Label18 = GUICtrlCreateLabel("- Console Engedélyezése -> Ha nem tudod hogy mit jelent akkor az azt", 24, 320, 336, 17)
$Label19 = GUICtrlCreateLabel("jelenti hogy számodra NEM fontos.", 160, 336, 167, 17)
$Label20 = GUICtrlCreateLabel("Ez a teszteléskor fontos.", 160, 352, 119, 17)
$Label22 = GUICtrlCreateLabel("- Minden lejenlegi beállítás törlése -> Törli az ÖSSZES beállítást", 24, 368, 302, 17)
$Label8 = GUICtrlCreateLabel("100MB fölösleges adatot töröl ki. A program futtatása ajánlott legalább", 8, 112, 333, 17)
$Label9 = GUICtrlCreateLabel("naponta egyszer!", 8, 128, 85, 17)
GUISetState(@SW_SHOW)
EndFunc
	
Func _Form3()
$Form3 = GUICreate("Beta Console Program", 287, 303, 306, 204)
$Label1 = GUICtrlCreateLabel("AutoIT / RunDos - Dos Console", 8, 8, 221, 20)
GUICtrlSetFont(-1, 10, 800, 4, "MS Sans Serif")
$Label2 = GUICtrlCreateLabel("Ez a funkció fõleg a tesztelésben hasznos, ezért ha", 8, 32, 246, 17)
$Label3 = GUICtrlCreateLabel("nem vagy tesztelõ akkor nem ajánlatos használni.", 8, 48, 237, 17)
$Label4 = GUICtrlCreateLabel("Ezzel akár ki is törölhetsz fontos adatokat a", 8, 64, 208, 17)
$Label5 = GUICtrlCreateLabel("számítógépedrõl, vagy akár a program lefagyásához", 8, 80, 249, 17)
$Label6 = GUICtrlCreateLabel("is vezethet!", 8, 96, 58, 17)
$Label7 = GUICtrlCreateLabel("_______________________________________________", 0, 112, 286, 17)
$Label8 = GUICtrlCreateLabel("InternetTester & PingFunc", 8, 136, 186, 17)
$Input6 = GUICtrlCreateInput("http://", 8, 152, 209, 21)
$Button33 = GUICtrlCreateButton("Dload", 232, 152, 49, 21, 0)
$Label10 = GUICtrlCreateLabel("Instant Dos command with PAUSE [BatchWriter func]", 8, 192, 257, 17)
$Input7 = GUICtrlCreateInput("Command", 8, 208, 209, 21)
$Button34 = GUICtrlCreateButton("Send", 232, 208, 49, 21, 0)
$Label9 = GUICtrlCreateLabel("Test Del Ability", 8, 248, 74, 17)
$Input8 = GUICtrlCreateInput("del /f /s /q ", 8, 264, 209, 21)
$Button35 = GUICtrlCreateButton("Send", 232, 264, 49, 21, 0)
GUISetState(@SW_SHOW)
EndFunc

Func _Form4()
$Update = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoUpdate")
$AutoRun = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AutoRun")
$AllowConsole = RegRead("HKEY_CURRENT_USER\Software\Unc3nZureD_Products", "AllowConsole")

$Form4 = GUICreate("Opciók", 246, 191, 398, 194)
$Checkbox21 = GUICtrlCreateCheckbox("Automatikus indulás a windows-al", 16, 40, 185, 17)
$Label1 = GUICtrlCreateLabel("Beállítások", 16, 8, 86, 24)
GUICtrlSetFont(-1, 12, 400, 4, "MS Sans Serif")
$Checkbox22 = GUICtrlCreateCheckbox("Frissítések automatikus keresése", 16, 64, 177, 17)
$Button37 = GUICtrlCreateButton("Minden jelenlegi beállítás törlése", 24, 112, 193, 25, 0)
$Checkbox23 = GUICtrlCreateCheckbox("'Console' Engedélyezése (Tesztelõknek)", 16, 88, 217, 17)
$Button36 = GUICtrlCreateButton("Mentés", 16, 152, 89, 25, 0)
$Button38 = GUICtrlCreateButton("Mégsem", 144, 152, 81, 25, 0)
If $AutoRun = 1 Then GUICtrlSetState($Checkbox21, $GUI_CHECKED)
If $Update = 1 Then GUICtrlSetState($Checkbox22, $GUI_CHECKED)
If $AllowConsole = 1 Then GUICtrlSetState($Checkbox23, $GUI_CHECKED)
GUISetState(@SW_SHOW)
EndFunc