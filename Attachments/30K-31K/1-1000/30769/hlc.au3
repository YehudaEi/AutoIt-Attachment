#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <IE.au3>
#include <GUIStatusBar.au3>
#include <File.au3>
#Include <GuiListBox.au3>

SplashImageOn("Splash", "splash.jpg")
sleep(3000)
SplashOff()
$main = GuiCreate("Autoclicker",350,358,338,213)
$button1=GuiCtrlCreateButton("Start",260,55,86,18)
$button2=GuiCtrlCreateButton("About",260,77,86,18)
$button3=GuiCtrlCreateButton("Stop",260,98,86,18)
$input1=GuiCtrlCreateInput("",15,29,237,20)
$input2=GuiCtrlCreateedit("",15,88,105,100)
$input3=guictrlcreateinput("3000",260,29,40,20)
$label0=guictrlcreatelabel("Delay(MS)",260,14,58,15)
$label1=GuiCtrlCreateLabel("Link",16,14,58,15)
$label2=GuiCtrlCreateLabel("Proxies",16,71,50,15)
$donate=GUICtrlCreatePic("donate.gif",130,55,122,47)
$menu=GUICtrlCreateMenu("App")
$proxmenu=GUICtrlCreateMenu("Proxies")
$pmenu2=guictrlcreatemenuitem("Clear Proxy List",$proxmenu)
$group1=GUICtrlCreateGroup("Statistics",150,120,120,50)
$stat="Idle"
$status=GuiCtrlCreateLabel($stat, 164,135,58,18)
$stat2=0
$status2=GuiCtrlCreateLabel("Times Clicked: " & $stat2,164,150,100,18)
$ie=_IECreateEmbedded()
$oie=guictrlcreateobj($ie,16,200,320,150)
$dlink="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=rwildenhaus1%40gmail%2ecom&lc=US&item_name=Bots&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHostedGuest"
$status=_GUICtrlStatusBar_Create($main)
_GUictrlstatusbar_settext($status,"Created by RvBFreak")
$going=0
GuiSetState(@sw_show)

While 1
$msg=GuiGetMsg()
If $msg=-3 Then Exit
If $msg=$button1 Then button1()
If $msg=$button2 Then button2()
If $msg=$button3 Then button3()
If $msg=$donate Then donate()
if $msg=$pmenu2 then clearproxy()
Wend




Func button1()
$going=1
Do
		guictrlsetdata($status,"Running")
		$count = _GUICTRLLISTBOX_GETCOUNT(1)
		For $var = 0 To $count - 1
			$usingproxy=_GUICTRLEDIT_GETLINE($input2, $var)
			FtpSetProxy(2,$usingproxy)
			$read=guictrlread($input1)
			guictrlsetdata($stat2, $num)
		    $num=$stat2 + 1
			_IENavigate($ie,$read)
			sleep($delay)
		Next
Until $going=0
EndFunc

Func button2()
	MsgBox(0,"About","Made by RvBfreak" & @LF & "Coded with AutoIt v3")
EndFunc

Func button3()
	$going=0
	guictrlsetdata($status,"Idle")
EndFunc

Func donate()
	_IENavigate($ie,$dlink)
endfunc

Func clearproxy()
	GuiCtrlSetData($input2,"")
endfunc
