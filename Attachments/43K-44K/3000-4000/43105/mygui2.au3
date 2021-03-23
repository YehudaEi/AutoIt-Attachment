#include <GUIConstantsEx.au3>
#include <EditConstants.au3> 
#include <EditConstants.au3>
#include <GuiButton.au3>
#include <Timers.au3>
#include <ButtonConstants.au3>
#include <Misc.au3>
#include <GUIListView.au3>
#include <File.au3>
#include <IE.au3>
#include <SliderConstants.au3>
#include <GuiAVI.au3>
#include <GuiIPAddress.au3>
#include <GuiEdit.au3>
#include <ScreenCapture.au3>
#include "GUIEnhance.au3"
Opt("TrayMenuMode",1)
Opt("GUIOnEventMode", 1)
Opt("WinTitleMatchMode", 5)
Opt("WinTitleMatchMode", 1)
Local $font, $msg , $PROCESS, $Handle, $musiclabel, $Value, $Edit1, $GUIActiveX, $obj, $hAVI, $WinList, $GUI, $bgcolor
Local $aiTemp[2] = [0, 0]
Global $bgcolor = PixelGetColor($aiTemp[0], $aiTemp[1])
ClientToScreen($GUI, $aiTemp[0], $aiTemp[1])

HotKeySet("!{f1}", "CPUUSAGE")
HotKeySet("{f2}", "list")
HotKeySet("{f3}", "ScreenCaptureF")
HotKeySet("{f4}", "GUISCHEME")
HotKeySet("{f7}", "Deleteobj")
HotKeySet("{f8}", "gif_")
HotKeySet("!{1}", "showgui")
HotKeySet("!{f3}", "ScreenCaptureR")




;FIRST PROGRESS ====================================================================================================================================
ShellExecute(@ScriptDir & "\Animations\_GDIPlus_IncreasingBalls.exe")
Sleep(5500)
;END OF PROGRESS ===========================================================================================================================================






;GUI ============================================================================================================================
$GUI = GUICreate("", 1100, 500, 1, 1)
$guipic = GUICtrlCreatePic(@ScriptDir & "\Wallpapers\Iron Man_2.jpg", 1, 1, 600,500)
GUICtrlSetCursor(-1, 4)
GUISetBkColor(0x000000)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $GUI, "int", 1000, "long", 0x0040008)
GUISetIcon(@ScriptDir & "\Icons\im.ico")
$font = "Arial"
GUISetFont(9, 400, 2, $font)
GUISetState(@SW_DISABLE)
Local $font, $msg 
;START SECTION OF TRAY(TRAY ICON AUTO CHANGE AT EVERY START!) ==========================================================================================================
$despre = TrayCreateItem("Despre")
TrayCreateItem("")
TraySetToolTip("Icon Tray is changing at every start!"& @CRLF & "CREATED BY FLORYNYUS")
Local $start = 0
Local $msg = TrayGetMsg()
Local $diff = TimerDiff($start)
    If $diff > 1000 Then
        Local $num = -Random(0, 100, 1) ; negative to use ordinal numbering
        TraySetIcon("Shell32.dll", $num)
        $start = TimerInit()
    EndIf
TraySetState(@SW_SHOW)
;END SECTION OF TRAY ======================================================================================================================================================
GUICtrlSetBkColor(-1, 0x0fffff)
Local $oIE = _IECreateEmbedded()
_GUIEnhanceAnimateTitle ($GUI, "FLORYNYUS PERSONAL GUI", $GUI_EN_TITLE_DROP)
Call("LoveDay")
;End OF GUI INF =====================================================================================================================









;Buttons & Menus ==========================================================================================================
$Meniu = GUICtrlCreateMenu("&Meniu")
GUICtrlSetState(-1, $GUI_Disable);Disable menu
$helpmenu = GUICtrlCreateMenu("INFO")
$infoitem = GUICtrlCreateMenuItem("PROGRAM CREATED BY FLORYNYUS", $helpmenu)
$infoitem1 = GUICtrlCreateMenuItem("PRESS F1 TO OPEN A WEBPAGE", $helpmenu)
$infoitem2 = GUICtrlCreateMenuItem("PRESS F2 FOR YAHOO LIST CHECK", $helpmenu)
$infoitem10 = GUICtrlCreateMenuItem("PRESS F3 FOR SCREEN CAPTURE(FULL SCREEN)", $helpmenu)
$infoitem3 = GUICtrlCreateMenuItem("PRESS F4 FOR GUISCHEME", $helpmenu)
$infoitem4 = GUICtrlCreateMenuItem("PRESS F6 AND CHECK YOUR WINAMP SONG", $helpmenu)
$infoitem4 = GUICtrlCreateMenuItem("PRESS F7 TO CLOSE THE WEB PAGE AND SET THE IMAGE BACK", $helpmenu)
$infoitem5 = GUICtrlCreateMenuItem("PRESS F8 FOR GIF WITH  YGF", $helpmenu)
$infoitem6 = GUICtrlCreateMenuItem("PRESS F9 TO CLOSE  YGF GIF", $helpmenu)
$infoitem7 = GUICtrlCreateMenuItem("PRESS F11 FOR A SPEED TEST", $helpmenu)
$infoitem8 = GUICtrlCreateMenuItem("PRESS F12 FOR MOUSE TRAP", $helpmenu)
$infoitem9 = GUICtrlCreateMenuItem("PRESS ALT+1 TO ENABLE AND SHOW GUI", $helpmenu)
$infoitem11 = GUICtrlCreateMenuItem("PRESS ALT+F3 FOR SCREEN CAPTURE(REGION SCREEN)", $helpmenu)
$infoitem11 = GUICtrlCreateMenuItem("PRESS ALT+F1 TO SEE CPU USAGE", $helpmenu)
GUICtrlCreateMenuItem("Tort", $Meniu)
GUICtrlCreateMenuItem("Ciorba", $Meniu)
GUICtrlCreateMenuItem("Fasole", $Meniu)
$WinList = GUICtrlCreateButton("WinList", 600, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
Local $num2 = -Random(0, 100, 1) ; negative to use ordinal numbering
GUICtrlSetImage(-1, "shell32.dll", $num2)
GUICtrlSetTip(-1, "WinList")
_GUiEnhanceCtrlDrift ($GUI, $WinList, 550, 0, 1)
_GUiEnhanceCtrlDrift ($GUI, $WinList, 600, 0, 1)
$HidePictures = GUICtrlCreateButton("HidePictures", 640 , 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 25)
GUICtrlSetTip(-1, "HidePictures")
_GUiEnhanceCtrlDrift ($GUI, $HidePictures, 640, 0, 1)
$GFGPictures = GUICtrlCreateButton("GFGPictures", 680 , 0,40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 3)
GUICtrlSetTip(-1, "GFGPictures")
$EFreeSMS = GUICtrlCreateButton("EFreeSMS", 720, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 14)
GUICtrlSetTip(-1, "EFreeSMS")
$FBLogin = GUICtrlCreateButton("FBLogin", 760, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 15)
GUICtrlSetTip(-1, "FBLogin")
$Ping_ = GUICtrlCreateButton("Ping_", 800, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 18)
GUICtrlSetTip(-1, "Ping")
$HideAll = GUICtrlCreateButton("HideAll", 840, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 22)
GUICtrlSetTip(-1, "HideAll")
$TransAll = GUICtrlCreateButton("TransAll", 880, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 35)
GUICtrlSetTip(-1, "TransAll")
$HideDesk = GUICtrlCreateButton("HideDesk", 920, 0, 40, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetImage(-1, "shell32.dll", 16)
GUICtrlSetTip(-1, "HideDesk")
$AcountsInfo = GUICtrlCreateButton("AcountsInfo", 965, 0, 30, 30, $BS_ICON)
GUICtrlSetCursor(-1, 7)
GUICtrlSetTip(-1, "All Acounts INFO")
GUICtrlSetImage(-1, "shell32.dll", 20)
$Block_ = GUICtrlCreateButton("Block_", 1050, 0, 45, 45, $BS_ICON)
GUICtrlSetImage(-1, @ScriptDir & "\Icons\Deleket-Sleek-Xp-Software-Windows-Close-Program.ico")
GUICtrlSetCursor(-1, 7)
GUICtrlSetTip(-1, "Block All Buttons")
$ShutDown_ = GUICtrlCreateButton("ShutDown_", 1000, 0, 45, 45, $BS_ICON)
GUICtrlSetImage(-1, @ScriptDir & "\Icons\Deleket-Sleek-Xp-Software-Windows-Turn-Off.ico")
GUICtrlSetCursor(-1, 7)
GUICtrlSetTip(-1, "ShutDown Your PC")
$slider1 = GUICtrlCreateSlider(600, 460, 200, 20)
GUICtrlSetLimit(-1, 250, 0)
GUICtrlSetData($slider1, 70)
GUICtrlSetBkColor(-1, 0x000000)
$value = GUICtrlCreateButton("Value", 935, 450, 25, 30, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", 47)
GUICtrlSetCursor(-1, 7)
GUICtrlSetTip(-1, "SET TRANSPARENCY") 
$ImageViewer = GUICtrlCreateButton("ImageViewer", 1040, 60, 40, 30, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", 23)
GUICtrlSetCursor(-1, 7)
GUICtrlSetTip(-1, "Open a ImageViewer") 
$Edit1 = GUICtrlCreateInput("Window Name Here!!!", 800, 460, 135, 20)
$label = GUICtrlCreateLabel("STARK INDUSTRIES", 970, 460, -1, 16)
_GUIEnhanceCtrlFade ($label, 1000, False, True, $bgcolor, 0x000000)
_GUIEnhanceCtrlFade ($label, 1000, True, False, 0x000000, 0xFF0000)
_GUIEnhanceCtrlFade ($label, 1000, False, True, 0x000000, $bgcolor)
_GUIEnhanceCtrlFade ($label, 1000, False, True, $bgcolor, 0x000000)
$sFile = @ScriptDir & "\avi\sampleAVI.avi"
$hIPAddress = _GUICtrlIpAddress_Create($GUI, 955, 95)
;END OF Buttons =================================================================================================






;CREATE  COMBO1 =====================================================================================================================
$combo = GUICtrlCreateCombo("APPS", 600, 35, 350, 25)
GUICtrlSetData(-1, "Block GUI|Chiavetta Internet|Check Yahoo Statuss|Yahoo List Check|Yahoo! Messenger|Winamp|Skype|Mozila|Utorrent|Action!|VirtualDj|MK4")
;END OF COMBO1 =============================================================================================================



;CREATE COMBO2 ============================================================================================================================================================================================================================================
$combo2 = GUICtrlCreateCombo("Folder", 600, 65, 350, 25)
GUICtrlSetData(-1, "C:|APPS|Folders(Desktop Folder)|Music(MOM)|Music(FLORYNYUS)|Pictures(FLORYNYUS)|Pictures(MOM)|Scurtaturi|Video!|Doc|Desktop|Aqua|Heroes|Everest|MK4|Sounds Notifications|Downloads|Pictures(From Downloads Folder)|Filme|IGO|StartUp")
;END OF COMBO2 ==============================================================================================================================================================================================================================================



;CREATE COMBO3 ============================================================================================================================================================================================================================================
$combo3 = GUICtrlCreateCombo("Links", 600, 95, 350, 25)
GUICtrlSetData(-1, "Google(RO)|E-FreeSMS(I)|Filelist|Facebook(L)|E-Drpciv|PhotoBucket|SpeedTest|Youtube|YahooMail(F)|VPlay|")
;END OF COMBO3






;Events==========================================================================================================
GUICtrlSetOnEvent($WinList, "WinList")
GUICtrlSetOnEvent($Hidepictures, "HidePictures")
GUICtrlSetOnEvent($GFGPictures, "GFGPictures")
GUICtrlSetOnEvent($EFreeSMS, "EFreeSMS")
GUICtrlSetOnEvent($FBLogin, "FBLogin")
GUICtrlSetOnEvent($Ping_, "Ping_")
GUICtrlSetOnEvent($HideAll, "HideAll")
GUICtrlSetOnEvent($TransAll, "TransAll")
GUICtrlSetOnEvent($HideDesk, "HideDesk")
GUICtrlSetOnEvent($AcountsInfo, "AcountsInfo")
GUICtrlSetOnEvent($Block_, "Block_")
GUICtrlSetOnEvent($ShutDown_, "ShutDown_")
GUICtrlSetOnEvent($Value, "Value")
GUICtrlSetOnEvent($ImageViewer, "ImageViewer")
GUISetOnEvent($GUI_EVENT_CLOSE, "ExitGUI")
;END OF Events ===========================================================================================================








;SWITCHER FOR HOUR MSG ====================================================================================================================================================================
Switch @HOUR
Case 6 To 10
	$msg12 = "GOOD MORNING SIR"
Case 10 To 17
	$msg12 = "GOOD EVENING SIR"
Case 17 To 20
	$msg12 = "GOOD AFTERNOON SIR"
Case Else
	$msg12 = "GO TO SLEEP SIR"
EndSwitch
		
TrayTip("JARVIS",$msg12, 10)
Sleep(1000)
GUISetState(@SW_Hide)
;END OF SWITCHER ==================================================================================================================================================================














;WHILE =====================================================================================================================================================
while 1
   $guimsg = GUIGetMsg()
  
  ;SET @IPAddress1 TO _GUICtrlIpAddress_Create =============================================================================================================
  _GUICtrlIpAddress_Set($hIPAddress, @IPAddress1)
  ;END OF SET ============================================================================================================================================
	
	   
	   
	   

				
				
				;IF _IsPRESSED ENABLE/DISABLE GUI OR BUTTON =========================================================
					 If _IsPressed("02", "user32.dll") Then
				    GUISetState(@SW_ENABLE)
				   _GUICtrlButton_Enable($WinList, True)
				   _GUICtrlButton_Enable($HidePictures, True)
				   _GUICtrlButton_Enable($GFGPictures, True)
				   _GUICtrlButton_Enable($EFreeSMS, True)
                   _GUICtrlButton_Enable($HideAll, True)
                   _GUICtrlButton_Enable($HideDesk, True)
                   _GUICtrlButton_Enable($Ping_, True)
                   _GUICtrlButton_Enable($TransAll, True)
                   _GUICtrlButton_Enable($FBLogin, True)
				   _GUICtrlButton_Enable($ShutDown_, True)
				   _GUICtrlButton_Enable($Value, True)
				   GUICtrlDelete($musiclabel)
                     EndIf
                ;END OF  ENABLE/DISABLE =======================================================================================================


               


		 ;START OF GUICTRLREAD($COMBO) ==============================================================================================================
				   IF GUICtrlRead($combo) = "Chiavetta Internet" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Chiavetta Internet\Chiavetta Internet.exe")
				    EndIf
				 
				 
				 
				 
				 IF GUICtrlRead($combo) = "Check Yahoo Statuss" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    call("yahoosts")
				    EndIf
				 
				 
				 
				 
				 IF GUICtrlRead($combo) = "Yahoo List Check" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    call("list")
				    EndIf
				 
				 
				 
				 
				 
				 
				 
    
				   IF GUICtrlRead($combo) = "Yahoo! Messenger" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Yahoo!\Messenger\YahooMessenger.exe")
			
					EndIf
			
                 
					 IF GUICtrlRead($combo) = "Skype" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Skype\Phone\Skype.exe")
					EndIf
				
				
					IF GUICtrlRead($combo) = "Utorrent" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\uTorrent\uTorrent.exe")
				 EndIf
				 
				 
					IF  GUICtrlRead($combo) = "Mozila" And _IsPressed("01", "user32.dll") then 
					   Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Mozilla Firefox\firefox.exe")
					Sleep(500)
					EndIf
					
					IF GUICtrlRead($combo) = "MK4" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\[REQ]Mortal Kombat 4.PC.Rip-BsT\MORTAL KOMBAT 4 .EXE")
				 EndIf
				 
					IF GUICtrlRead($combo) = "Action!" And _IsPressed("01", "user32.dll") then 
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Mirillis\Action!\Action.exe")
					EndIf
					
					
				IF GUICtrlRead($combo) = "VirtualDj" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\VirtualDJ\virtualdj_pro.exe")
				 EndIf
				 
				 IF GUICtrlRead($combo) = "Winamp" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Run("C:\Program Files (x86)\Winamp\winamp.exe")
				 EndIf
				 
				 
				 IF GUICtrlRead($combo) = "Block GUI" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    GUISetState(@SW_DISABLE)
				 EndIf

  
  
  
  
  
		    IF _Ispressed("75", "user32.dll") then
              $font3 = "Comic Sans MS"   
			   WinWait("Winamp")
              Local $sText = ControlGetText("[CLASS:BaseWindow_RootWnd]", "", "")
			  $musiclabel = GUICtrlCreateLabel("Winamp Song: " & $sText, 10, 430)
			   GUICtrlSetColor(-1, 0x00ff00)
			   GUICtrlSetFont(-1, 9.5, 400, 4, $font3)
			   Sleep(5000)
	          GUICtrlDelete($musiclabel)
			EndIf
			
			
			
			
			
			IF _Ispressed("70", "user32.dll") then
			   GUICtrlDelete($guipic)
			   $hAVI = _GUICtrlAVI_Create($GUI, $sFile, -1, 955, 60)
				Local $txt_ = InputBox ("Jarvis", "IP" & @IPAddress1, "www.google.com","",150,120, 1175, 620)
				FileRead($txt_)
                $obj = GUICtrlCreateObj($oIE, 0, 0, 590, 480)
				_GUICtrlAVI_Play($hAVI)
              _IENavigate($oIE, $txt_)
		   EndIf
		   
		   
		   
		   IF _Ispressed("7A", "user32.dll") then
			   GUICtrlDelete($guipic)
			   $hAVI = _GUICtrlAVI_Create($GUI, $sFile, -1, 955, 60)
				Local $txt_ = "http://www.speedtest.net/"
				FileRead($txt_)
                $obj = GUICtrlCreateObj($oIE, 0, 0, 590, 480)
				_GUICtrlAVI_Play($hAVI)
              _IENavigate($oIE, $txt_)
			EndIf
			
			
			
			
			
			IF _Ispressed("76", "user32.dll") then
			   GUICtrlDelete($obj)
			   Sleep(500)
				$guipic = GUICtrlCreatePic(@ScriptDir & "\Wallpapers\Iron Man_2.jpg", 1, 1, 600,500)
			EndIf
			
			
			
			iF _Ispressed("78", "user32.dll") then
			   GUICtrlDelete($GUIActiveX)
			EndIf
			
			
			if _Ispressed("7B", "user32.dll") Then
			    $coords = WinGetPos($GUI)
                 _MouseTrap($coords[0], $coords[1], $coords[0] + $coords[2], $coords[1] + $coords[3])
		        EndIf
		 ;END OF GUICTRLREAD($COMBO) ======================================================================================================================
				 
				 
				 
				 
				 
				 
			













		 ;START OF GUICTRLREAD($COMBO2) ==================================================================================================================================		 
				 IF GUICtrlRead($combo2) = "C:" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("c:\")
					EndIf
				

                    IF GUICtrlRead($combo2) = "APPS" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\APPS")
				 EndIf
				 
				

				  IF GUICtrlRead($combo2) = "Folders(Desktop Folder)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Music(MOM)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\muzica")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Music(FLORYNYUS)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\muzica\muzica florin")
				 EndIf
				 
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Pictures(FLORYNYUS)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\poze\FLORYNYUS")
					EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Pictures(MOM)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\poze\")
				 EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Scurtaturi" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\scurtaturi")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Video!" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Video")
					EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Doc" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Doc")
					EndIf
				 
				 IF GUICtrlRead($combo2) = "Desktop" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Desktop")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Aqua" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Aqua2")
				 EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Heroes" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Heroes")
				 EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Everest" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\everest")
					EndIf
				 
				  
				  IF GUICtrlRead($combo2) = "MK4" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\[REQ]Mortal Kombat 4.PC.Rip-BsT")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Sounds Notifications" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Sounds Notifications")
				 EndIf
				 
				 
				  IF GUICtrlRead($combo2) = "Sounds Notifications" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Sounds Notifications")
					EndIf
				 
				  IF GUICtrlRead($combo2) = "Downloads" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
					$pass = InputBox ("Jarvis", "Password Please", "","*",150,120, 1175, 620)
					FileRead($pass)
					if $pass = 1 then 
                    ShellExecute("C:\Downloads")
				 Else
					Sleep(500)
					EndIf
				 EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "Pictures(From Downloads Folder)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
					$pass = InputBox ("Jarvis", "Password Please", "","*",150,120, 1175, 620)
					FileRead($pass)
					if $pass = 1 then
                    ShellExecute("C:\Downloads\pictures")
				 Else
					Sleep(500)
					EndIf
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "Filme" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Filme")
				 EndIf
				 
				 
				 IF GUICtrlRead($combo2) = "IGO" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\Desktop\Folders\Desktop\iGO")
				 EndIf
				 
				 
				 
				 IF GUICtrlRead($combo2) = "StartUp" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("C:\Users\michela\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup")
					EndIf
		 ;END OF GUICTRLREAD($COMBO2) ================================================================================================================================================================		 
				 
				 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 ;Start Of GUICTRLREAD($COMBO3) ======================================================================================================================================================================================
		
	  IF GUICtrlRead($combo3) = "Google(RO)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("http://www.google.ro")
				 EndIf
				 
				 
	  IF GUICtrlRead($combo3) = "E-FreeSMS(I)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                   Global $oIE = _IECreate ("                                ")
                  Local $country = _IEGetObjByName ($oIE, "country45367928")
                  Local $countrycode = _IEGetObjByName ($oIE, "countrycode45367928")
                  Local $number = _IEGetObjByName ($oIE, "number45367928")

			      _IEFormElementSetValue ($country, "40")
                  _IEFormElementSetValue ($countrycode, "40")
				  _IEFormElementSetValue ($number, "762474467")
					EndIf 
				 
				 
	  IF GUICtrlRead($combo3) = "Filelist" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    Global $oIE = _IECreate ("http://filelist.ro/login.php")
              Local $username = _IEGetObjByName ($oIE, "username")
              Local $password = _IEGetObjByName ($oIE, "password")

               _IEFormElementSetValue ($username, "spider222")
               _IEFormElementSetValue ($password, "gigolo20588896")
					EndIf 		 
				 
		
		
	  IF GUICtrlRead($combo3) = "Facebool(L)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("http://www.facebook.com")
					EndIf		 
				 
				 
				 
				 
	  IF GUICtrlRead($combo3) = "E-Drpciv" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("http://www.e-drpciv.ro")
					EndIf		 
				 
		

	  IF GUICtrlRead($combo3) = "PhotoBucket" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                 
                 Global $oIE = _IECreate ("                                            ")
                 Local $username = _IEGetObjByName ($oIE, "username")
                 Local $password = _IEGetObjByName ($oIE, "password")
			     Local $img = _IEGetObjById($oIE, "signUpBtn")

			   _IEFormElementSetValue ($username, "florynyus406@yahoo.com")
               _IEFormElementSetValue ($password, "gigolo205")
               _IEAction($img, "click")
				 EndIf



      IF GUICtrlRead($combo3) = "SpeedTest" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("http://www.speedtest.net/")
				 EndIf
				 
				 
				 
				 
	  IF GUICtrlRead($combo3) = "Youtube" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("http://www.youtube.com/")
				 EndIf	



      IF GUICtrlRead($combo3) = "YahooMail(F)" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("https://login.yahoo.com/config/mail?&.src=ym&.intl=it")
					EndIf

  
      IF GUICtrlRead($combo3) = "VPlay" And _IsPressed("01", "user32.dll") then 
					Sleep(500)
					Send("{backspace}")
					Sleep(500)
                    ShellExecute("                ")
					EndIf
;END OF GUICTRLREAD($COMBO3) ================================================================================================================================================================				 
				 
				 
		
		Sleep(10)
		WEnd
;END WHILE ===========================================================================================












;While ===================================================================================================================================
While 1
	Sleep(1000); 
	 $msg2 = TrayGetMsg()
    Select
        Case $msg2 = $despre
            Msgbox(64,"Despre","PROGRAM CREATED BY FLORYNYUS")
			
			EndSelect
			Sleep(100)
		WEnd
;END While ==============================================================================================================================










;Functions ====================================================================================================
Func HidePictures()
ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
sleep(3000)
ShellExecute(@ScriptDir & "\APPS\HidePictures.exe")
	EndFunc








Func showgui()
   GUISetState(@SW_ENABLE)
   GUISetState(@SW_SHOW)
   EndFunc







Func GFGPictures()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
	Sleep(3000)
	ShellExecute(@ScriptDir & "\APPS\GFGPictures.exe")
  
EndFunc   






Func CPUUSAGE()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
	Sleep(3000)
	ShellExecute(@ScriptDir & "\cpuusage\Processes_CPUUsageExample.exe")
  
EndFunc 







Func Ping_()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
   Sleep(3000)
	ShellExecute(@ScriptDir & "\APPS\Ping.exe")
EndFunc 












Func EFreeSMS()
   ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
   Sleep(4000)
ShellExecute(@ScriptDir & "\APPS\e free sms.exe")
EndFunc












Func FBLogin()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
      Sleep(3000)
	ShellExecute(@ScriptDir & "\APPS\facebook login.exe")
EndFunc 











Func HideAll()
ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
Sleep(3500)
	ShellExecute(@ScriptDir & "\APPS\Hidde,UnhiddeAll.exe")
EndFunc 











Func TransAll()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
	Sleep(3500)
	ShellExecute(@ScriptDir & "\APPS\TransForAll.exe")
EndFunc 











Func HideDesk()
	ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
	Sleep(3500)
	ShellExecute(@ScriptDir & "\APPS\Hide or Show DESK Items.exe")
EndFunc 











Func ShutDown_()
   ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
   Sleep(3500)
   $pass = InputBox ("Jarvis", "ARE YOU SURE?(PRESS 1 AND OK FOR SHUTDOWN)", "","*", 300, 120, 1070, 620)
					FileRead($pass)
					if $pass = 1 then

	Shutdown(1)
 Else
	Sleep(500)
	EndIf

 EndFunc
 
 
 
 
 
 
 
 



Func AcountsInfo()
   ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
   Sleep(3500)
	ShellExecute(@ScriptDir & "\APPS\AcountsInfo.exe")

EndFunc 









Func ImageViewer()
   ShellExecute(@ScriptDir & "\Animations\_GDIPlus_StripProgressbar1.exe")
   Sleep(3500)
ShellExecute(@ScriptDir & "\GIFANIMEX\Example6_ImageViewer.exe")
EndFunc







Func GUISCHEME()
   ShellExecute(@ScriptDir & "\APPS\GUISCHEME.exe")
   EndFunc














Func Block_()
   _GUICtrlButton_Enable($WinList, False)
   _GUICtrlButton_Enable($HidePictures, False)
   _GUICtrlButton_Enable($GFGPictures, False)
   _GUICtrlButton_Enable($EFreeSMS, False)
   _GUICtrlButton_Enable($HideAll, False)
   _GUICtrlButton_Enable($HideDesk, False)
   _GUICtrlButton_Enable($Ping_, False)
   _GUICtrlButton_Enable($TransAll, False)
   _GUICtrlButton_Enable($FBLogin, False)
    _GUICtrlButton_Enable($ShutDown_, False)
	_GUICtrlButton_Enable($Value, False)
EndFunc 
  
















Func yahoosts()
   $font2 = "Comic Sans MS"
   AutoItSetOption("WinTitleMatchMode", 4)
;
;
WinGetHandle("classname=YahooBuddyMain", "ListView")
If Not @error Then
     $firstlabel = GUICtrlCreateLabel("Yahoo! Messenger is ONLINE", 700, 95)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1, 9.5, 400, 4, $font2)
	$bef = GUICtrlCreateButton("", 870, 90, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "C:\Program Files (x86)\Yahoo!\Messenger\generic_messenger.ico")
	Sleep(5000)
	GUICtrlDelete($firstlabel)
	GUICtrlDelete($bef)
Else
     $secondlabel = GUICtrlCreateLabel("Yahoo! Messenger is OFFLINE", 700, 95)
	GUICtrlSetColor(-1, 0xff0000)
	GUICtrlSetFont(-1, 9.5, 400, 4, $font2)
	$bef = GUICtrlCreateButton("", 870, 90, 40, 40, $BS_ICON)
	GUICtrlSetImage(-1, "C:\Program Files (x86)\Yahoo!\Messenger\generic_messenger.ico")
	Sleep(5000)
	GUICtrlDelete($secondlabel)
	GUICtrlDelete($bef)
 EndIf
 EndFunc



















func list()
   $Handle = Controlgethandle('Yahoo! Messenger', "", '[CLASS:SysListView32; INSTANCE:1]') 
   For $i = 1  To _GUICtrlListView_GetItemCount($Handle) 
   $label = GUICtrlCreateLabel(_GUICtrlListView_GetItemText($Handle,$i), 10, 460)
GUICtrlSetColor(-1, 0x00ff00)
Sleep(3000)
	GUICtrlDelete($label)
Next
   EndFunc





















Func Value()
$input1 = GUICtrlRead($Edit1)   
$etc = GUICtrlRead($slider1)
WinSetTrans($input1, "", $etc)
	 
EndFunc



















Func Deleteobj()
GUICtrlDelete($obj)
_GUICtrlAVI_Close($hAVI)
Sleep(500)
$guipic = GUICtrlCreatePic(@ScriptDir & "\Wallpapers\Iron Man_2.jpg", 1, 1, 600,500)
EndFunc

















Func gif_()
   Local $pheight = 50, $pwidth = 50, $oIE1, $GUIActiveX, $gif
    $gif = @ScriptDir & "\GIF\video3.gif"
    If @error Then Exit
    _GetGifPixWidth_Height($gif, $pwidth, $pheight)
    $oIE1 = ObjCreate("Shell.Explorer.2")
    $GUIActiveX = GUICtrlCreateObj($oIE1, 600, 120, $pwidth, $pheight)
    $oIE1.navigate ("about:blank")
    While _IEPropertyGet($oIE1, "busy")
        Sleep(100)
    WEnd
    $oIE1.document.body.background = $gif
    $oIE1.document.body.scroll = "no"
	 while 1  
		if _ispressed("78", "user32.dll") then 
               GUICtrlDelete($GUIActiveX)
			   ExitLoop
			EndIf
			Sleep(100)
			WEnd
	
EndFunc
Func _GetGifPixWidth_Height($s_gif, ByRef $pwidth, ByRef $pheight)
    If FileGetSize($s_gif) > 9 Then
        Local $sizes = FileRead($s_gif, 10)
        ConsoleWrite("Gif version: " & StringMid($sizes, 1, 6) & @LF)
        $pwidth = Asc(StringMid($sizes, 8, 1)) * 256 + Asc(StringMid($sizes, 7, 1))
        $pheight = Asc(StringMid($sizes, 10, 1)) * 256 + Asc(StringMid($sizes, 9, 1))
        ConsoleWrite($pwidth & " x " & $pheight & @LF)
    EndIf
 EndFunc
 
 
 Func LoveDay()
	ShellExecute(@ScriptDir & "\APPS\HappyAnyverssary.exe")
	EndFunc




Func ClientToScreen($hwnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hwnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
	; release Struct not really needed as it is a local
	$stPoint = 0
EndFunc 





Func ScreenCaptureF()
_ScreenCapture_Capture(@DesktopDir & "\GDIPlus_Image1FullSreen.jpg")
EndFunc





Func ScreenCaptureR()
_ScreenCapture_Capture(@DesktopDir & "\GDIPlus_Image2RegionScreen.jpg", 0, 0, 1120, 540)
EndFunc












Func ExitGUI()
 Sleep(500)
 ProcessClose("mygui2.exe")
	Exit
 EndFunc
 ;END OF Functions =========================================================================================================================