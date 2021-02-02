#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=snowman.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <resources.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ButtonConstants.au3>
#include <inet.au3>

HotKeySet('{ESC}', 'Close')
HotKeySet('{F9}', 'secretfunc')
Opt('GUIOnEventMode', 1)


Global $hGUI, $FlashCtrl
Global $oFlash
Global $fError = False
Global $button
Global $edit2 = GuiCtrlCreateEdit("", 150, 620, 700, 90, BitOR($ES_LEFT,$ES_NOHIDESEL))
Global $button2
Global $button3



;main GUI
$gui = GuiCreate ("Happy New 2010 YEAR!!!", 1000, 720)
GuiSetBkColor (0xffffff, $gui)


;Install source
FileInstall ("ny.swf", @TempDir & "\ny.swf")
FileInstall ("imover18.jpg", @TempDir & "\imover18.jpg")
FileInstall ("under18.jpg", @TempDir & "\under18.jpg")
FileInstall ("santa.jpg", @TempDir & "\santa.jpg")
FileInstall ("snowman_l.jpg", @TempDir & "\snowman_l.jpg")
FileInstall ("snowman_r.jpg", @TempDir & "\snowman_r.jpg")
FileInstall ("toplogo1.jpg", @TempDir & "\toplogo1.jpg")

;Adding other pictures to GUI
$logopic = GuiCtrlCreatePic(@TempDir & "\toplogo1.jpg", 245, 0, 474, 210)
$snowmanL = GuiCtrlCreatePic(@TempDir & "\snowman_l.jpg", 20, 60, 96, 158)
$snowmanR = GuiCtrlCreatePic(@TempDir & "\snowman_r.jpg", 882, 60, 98, 154)
$snegurkakids = GuiCtrlCreatePic(@TempDir & "\under18.jpg", 800, 260, 200, 322)
$santa = GuiCtrlCreatePic(@TempDir & "\santa.jpg", 20, 310, 209, 277)

$edit = GuiCtrlCreateEdit("Дорогие друзья! Поздравляю Вас всех с еовым 2010 годом!" & @CRLF &  "Хочется от всего сердца пожелать Вам всем крепкого здоровья, счастья в Новом Году и не унывать в этой унылой стране. Не забудте положить денежку  в карман в самый канун нового года! Желаю Всем НАМ  никогда не забывать друг о друге. Ведь мы же - ДРУЗЬЯ!!!" & @CRLF & "За всех нас, ребята!!! С НОВЫМ ГОДОМ!!!!!!! УРА!", 150, 620, 700, 90, $ES_READONLY)
$button2 = GuiCtrlCreateButton ("Ответить?", 880, 620, 100, 90)
GuiCtrlSetOnEvent($button2, "respondme")

Func secretfunc()
$button = GuiCtrlCreateButton ("I'm over 18 :)", 800, 587, 200, 20)
GUICtrlSetOnEvent($button, "snegurkaadult")
EndFunc

Func respondme()
	GuiCtrlDelete($button2)
	$button3 = GuiCtrlCreateButton ("Отправить", 880, 620, 100, 90)
	GuiCtrlSetOnEvent($button3, "nowsend")
	GuiCtrlDelete($edit)
	Sleep(50)
	$edit2 = GuiCtrlCreateEdit("", 150, 620, 700, 90, BitOR($ES_LEFT,$ES_NOHIDESEL))
EndFunc

Func nowsend()

$s_SmtpServer = "a.mx.inbox.lv"
$s_FromName = InputBox("Who are you?", "Type your name :)", "", "", 100, 40)
$s_FromAddress = "happynew2010@someone.lv"
$s_ToAddress = "zed8@inbox.lv"
$s_Subject = "Happy NEW 2010 YEAR!!!"
Dim $as_Body[1]
$as_Body[0] = GuiCtrlRead($edit2)
$Response = _INetSmtpMail ($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject, $as_Body)

GuiCtrlDelete($edit2)
GuiCtrlDelete($button3)
MsgBox (64, ":)", "Thank you! :)", 10)
EndFunc


;Now adding flash to the GUI
$oFlash = ObjCreate("ShockwaveFlash.ShockwaveFlash.10")
$oAutoItError = ObjEvent("AutoIt.Error", "COMError")

$FlashCtrl = GUICtrlCreateObj($oFlash, 285, 260, 440, 330)
GUISetOnEvent($GUI_EVENT_CLOSE, "Close")


Func snegurkaadult()
GuiCtrlDelete($snegurkakids)
Sleep(100)
GuiCtrlCreatePic(@TempDir & "\imover18.jpg", 800, 300, 200, 322)
GuiCtrlDelete($button)
EndFunc

With $oFlash
	.Movie = @TempDir & "\ny.swf"
	.wmode = "opaque"
	.allowScriptAccess = "Always"
	.Playing = True
EndWIth

GuiSetState()

While 1
	Sleep (10)
WEnd

Func Close()
	$oFlash.Stop()
	$oFlash = 0
	GuiDelete()
	Exit
EndFunc

Func COMError()
	$fError = True
EndFunc


