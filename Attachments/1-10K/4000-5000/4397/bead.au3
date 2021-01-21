#include <Crypto.au3>
#include <GUIConstants.au3>
#include <INet.au3>
AutoItSetOption ("TrayIconHide",1)
Opt('RunErrorsFatal', 0)
$gui = GUICreate("Encryption/Decryption Tool v1.5",500,360,-1,-1)
$myedit=GUICtrlCreateinput ("", 5,5,495,300,$ES_MULTILINE+$ES_WANTRETURN+$ES_AUTOVSCROLL+$WS_VSCROLL)
$key = GUICtrlCreateinput ("", 5,310, 160, 20,$ES_PASSWORD)
$label1 = GUICtrlCreateLabel ("Enter your crypt key here",5,335,160,20)
$btn = GUICtrlCreateButton ("Encrypt", 180,310,60,20)
$ckhbox1 = GUICtrlCreateCheckbox ("Email It", 250,310,60,20)
$btn2 = GUICtrlCreateButton ("Decrypt", 180,335, 60, 20)
$ckhbox2 = GUICtrlCreateCheckbox ("From Clipboard", 250, 335, 120, 20)
$btn3 = GUICtrlCreateButton ("Clear", 360,  310, 60, 20)
$btn4 = GUICtrlCreateButton ("Exit", 430,  310, 60, 20)
$Address = ""
$Subject = "A special message for you"



GUISetState ()

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
       $msg = GUIGetMsg()
       Select
           Case $msg = $btn
		ecrypt()
	   Case $msg = $btn2
		dcrypt()
	   Case $msg = $btn3
		clear()
	   Case $msg = $btn4
		byebye()
	   Case $msg = $ckhbox2
		cboard()
       EndSelect
Wend
exit

Func ecrypt()
$string1 = GUICtrlRead($myedit)
$string2 = GUICtrlRead($key)
$woop1 = _EncryptString($string1,$string2)
GUICtrlSetData ($myedit,$woop1)
GUICtrlSetState ($btn,$GUI_DISABLE)
GUICtrlSetState ($btn2,$GUI_ENABLE)
ClipPut($woop1)
$emit = GUICtrlRead($ckhbox1)
If $emit = 1 Then
     _INetMail($address, $subject, $woop1)
   EndIf
   If $emit = 4 Then
      Return
   EndIf
EndFunc

Func dcrypt()
$string3 = GUICtrlRead($myedit)
$string4 = GUICtrlRead($key)
$woop2 = _DecryptString($string3,$string4)
GUICtrlSetData ($myedit,$woop2)
GUICtrlSetState ($btn2,$GUI_DISABLE)
GUICtrlSetState ($btn,$GUI_ENABLE)
EndFunc

Func cboard()
$clipit = GUICtrlRead($ckhbox2)
If $clipit = 1 Then
     $bak = ClipGet()
     GUICtrlSetData ($myedit,$bak)
   EndIf
   If $clipit = 4 Then
      Return
   EndIf
EndFunc

Func clear()
GUICtrlSetData ($myedit,"")
GUICtrlSetData ($key,"")
GUICtrlSetState ($btn,$GUI_ENABLE)
GUICtrlSetState ($btn2,$GUI_ENABLE)
GUICtrlSetState ($ckhbox1,$GUI_UNCHECKED)
GUICtrlSetState ($ckhbox2,$GUI_UNCHECKED)
EndFunc

Func byebye()
exit
EndFunc

