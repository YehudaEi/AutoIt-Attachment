#RequireAdmin
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("TrayMenuMode", 1)
HotKeySet("{esc}", "_Quit")
#Region ### START Koda GUI section ### Form=c:\users\celal\desktop\yeni program downloader\form1.kxf
$Form1 = GUICreate("Program Downloader", 544, 362, 192, 124)
$MenuItem1 = GUICtrlCreateMenu("&Menu")
$MenuItem2 = GUICtrlCreateMenuItem("Çýkýþ", $MenuItem1)
$MenuItem3 = GUICtrlCreateMenu("&Gui")
$MenuItem4 = GUICtrlCreateMenuItem("Tray Al", $MenuItem3)
$MenuItem5 = GUICtrlCreateMenu("Transparency", $MenuItem3)
$MenuItem6 = GUICtrlCreateMenuItem("%100", $MenuItem5)
$MenuItem7 = GUICtrlCreateMenuItem("%90", $MenuItem5)
$MenuItem8 = GUICtrlCreateMenuItem("%80", $MenuItem5)
$MenuItem9 = GUICtrlCreateMenuItem("%70", $MenuItem5)
$MenuItem10 = GUICtrlCreateMenuItem("%60", $MenuItem5)
$MenuItem11 = GUICtrlCreateMenuItem("%50", $MenuItem5)
$MenuItem12 = GUICtrlCreateMenuItem("%40", $MenuItem5)
$MenuItem13 = GUICtrlCreateMenuItem("%30", $MenuItem5)
$MenuItem14 = GUICtrlCreateMenuItem("%20", $MenuItem5)
$MenuItem15 = GUICtrlCreateMenuItem("%10", $MenuItem5)
$MenuItem16 = GUICtrlCreateMenu("&Yardým")
$MenuItem17 = GUICtrlCreateMenuItem("Silkroadmax.org", $MenuItem16)
$MenuItem29 = GUICtrlCreateMenuItem("Güncelleme Kontrol", $MenuItem16)
$MenuItem18 = GUICtrlCreateMenuItem("Hakkýnda", $MenuItem16)
GUISetFont(11, 400, 0, "Arial Narrow")
GUISetBkColor(0xFFFFFF)
$Pic1 = GUICtrlCreatePic(@ScriptDir & "\Pictures\silkroadmax.jpg", 0, 0, 537, 66, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$Label1 = GUICtrlCreateLabel("Select Program : ", 8, 96, 99, 24)
$Combo1 = GUICtrlCreateCombo("Loader", 128, 96, 145, 25)
GUICtrlSetData(-1, "SrProxy|agBot|ÝsroBot|Sbot|Tbot|Ýbot|SroKing")
$Button1 = GUICtrlCreateButton("Load Ýnformation", 288, 96, 139, 25, $WS_GROUP)
$Pic2 = GUICtrlCreatePic("", 8, 160, 169, 169, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$Label2 = GUICtrlCreateLabel("File Name :", 208, 160, 68, 24)
$Label3 = GUICtrlCreateLabel("File Size :", 208, 192, 57, 24)
$Label4 = GUICtrlCreateLabel("Version :", 208, 224, 51, 24)
$Button2 = GUICtrlCreateButton("Download", 208, 296, 75, 25, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Go Download Page", 304, 296, 147, 25, $WS_GROUP)
$Label5 = GUICtrlCreateLabel("Label5", 280, 160, 250, 24)
$Label6 = GUICtrlCreateLabel("Label6", 272, 192, 266, 24)
$Label7 = GUICtrlCreateLabel("Label7", 272, 224, 258, 24)
GUICtrlSetFont(-1, 11, 400, 4, "Arial Narrow")
GUICtrlSetColor(-1, 0x800000)
TraySetClick("9")
$MenuItem19 = TrayCreateMenu("Download")
$MenuItem20 = TrayCreateItem("Loader", $MenuItem19)
$MenuItem21 = TrayCreateItem("SrProxy", $MenuItem19)
$MenuItem22 = TrayCreateItem("agBot", $MenuItem19)
$MenuItem23 = TrayCreateItem("Ýsrobot", $MenuItem19)
$MenuItem24 = TrayCreateItem("Sbot", $MenuItem19)
$MenuItem25 = TrayCreateItem("Tbot", $MenuItem19)
$MenuItem27 = TrayCreateItem("Ýbot", $MenuItem19)
$MenuItem28 = TrayCreateItem("SroKing", $MenuItem19)
$MenuItem26 = TrayCreateItem("Kapat")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

		Case $Button1
			_LoadBotInfo()

	EndSwitch
WEnd


Func _LoadBotInfo()
	If GUICtrlRead($Combo1) = "Loader" Then
		$Loader = GETSOURCE("http://recyfer.info/testosterone.htm")
		$LoaderVersiyon = StringRegExp($Loader, "Last version (.*?)<", 3)
		$LoaderBoyut = InetGetSize( "http://recyfer.info/files/C19H28O2.v" & $LoaderVersiyon[0] & ".zip" )
		GUICtrlSetData( $Label5  ,"C19H28O2.v" & $LoaderVersiyon[0] & ".zip")
		GUICtrlSetData( $Label6  ,  Int($LoaderBoyut / 1024) & "  kb ")
		GUICtrlSetData( $Label7  ,$LoaderVersiyon[0] )
	ElseIf GUICtrlRead($Combo1) = "SrProxy" Then
		$SrProxy = GETSOURCE("http://recyfer.info/srproxy.htm")
		$SrProxyVersiyon = StringRegExp($SrProxy, "Last version (.*?)<", 3)
		$SrProxyBoyut = InetGetSize( "http://recyfer.info/files/SrProxy.v" & $SrProxyVersiyon[0] & ".zip" )
		GUICtrlSetData( $Label5  ,"SrProxy.v" & $SrProxyVersiyon[0] & ".zip")
		GUICtrlSetData( $Label6  ,  Int($SrProxyBoyut  / 1024) & "  kb ")
		GUICtrlSetData( $Label7  ,$SrProxyVersiyon[0] )
	ElseIf GUICtrlRead($Combo1) = "agBot" Then
		$agBot = GETSOURCE("http://www.agbot.net/")
		$agBotVersiyon = StringRegExp($agBot, ">Package(.*?).nomap.zip<", 3)
		$agBotBoyut = InetGetSize( "http://www.agbot.net/f/Package" & $agBotVersiyon[0] & ".nomap.zip" )
		GUICtrlSetData( $Label5  ,"Package" & $agBotVersiyon[0] & ".nomap.zip")
		GUICtrlSetData( $Label6  ,  Int($agBotBoyut / 1024) & "  kb ")
		GUICtrlSetData( $Label7  ,$agBotVersiyon[0] )
	ElseIf GUICtrlRead($Combo1) = "ÝsroBot" Then
		$Isrobot = GETSOURCE("                                                                                               ")
		$IsrobotVersiyon = StringRegExp($Isrobot, "Silkroad Online Bot v(.*?)<", 3)
		$BoyutIsrobot = InetGetSize("                                       " & StringLower($IsrobotVersiyon[UBound($IsrobotVersiyon) - 1]) & ".exe")
		GUICtrlSetData( $Label5  ,"SROBotEn" & StringLower($IsrobotVersiyon[UBound($IsrobotVersiyon) - 1]) & ".exe")
		GUICtrlSetData( $Label6  ,  Int($BoyutIsrobot / 1024) & "  kb ")
		GUICtrlSetData( $Label7  ,StringLower($IsrobotVersiyon[UBound($IsrobotVersiyon) - 1]) )
	ElseIf GUICtrlRead($Combo1) = "Sbot" Then
	EndIf
EndFunc   ;==>_LoadBotInfo

Func GETSOURCE($URL)
	$HTTPOBJ = ObjCreate("winhttp.winhttprequest.5.1")
	$HTTPOBJ.open("GET", $URL)
	$HTTPOBJ.send()
	Return $HTTPOBJ.Responsetext
EndFunc   ;==>GETSOURCE
;---------------------------------------------------------------------------------------------------------------------------------------------------------------
Func _Quit()
	Exit
EndFunc   ;==>_Quit
;---------------------------------------------------------------------------------------------------------------------------------------------------------------
Func _ShowGui()
	GUISetState(@SW_SHOW)
EndFunc   ;==>_ShowGui
;---------------------------------------------------------------------------------------------------------------------------------------------------------------
Func _About()
	MsgBox(64, "Hakkýnda", "Anchen tarafýndan Kodlanmýþtýr.")
EndFunc   ;==>_About
;---------------------------------------------------------------------------------------------------------------------------------------------------------------
