#include "GUIConstants.au3"
$dll = DLLOpen("cwebpage.dll")
$u="No Message"
$b="1"
$hwnd = GUICreate("JAK Webbrowser 1.0...",800,600,-1,-1, -1)
$pos = WinGetClientSize($hwnd)
$u=GUICtrlCreateInput ( "www.autoitscript.com", 280, 510, 120,20 )
$b=GUICtrlCreateButton ( "Go!", 400 , 510, 60, 20)
$word=GUICtrlCreateInput ( "www.autoitscript.com", 480, 510, 120,20 )
$search=GUICtrlCreateButton ( "Search!",600 , 510, 60, 20)
$back=GUICtrlCreateButton ( "<Back", 270, 535, 60, 20)
$for=GUICtrlCreateButton ( "Forward>", 345 , 535, 60, 20)
$re=GUICtrlCreateButton ( "@Reload", 420 , 535, 60, 20)
DLLCall($dll,"long","EmbedBrowserObject","hwnd",$hwnd)
GUISetState()
 DLLCall($dll,"long","DisplayHTMLPage","hwnd",$hwnd,"str", "http://www.autoitscript.com" )
DLLCall($dll,"none","ResizeBrowser","hwnd",$hwnd,"int", 800, "int", 500 )

While 1
$msg = GUIGetMsg()
If $msg = -3 Then ExitLoop
   If $msg= $b then  DLLCall($dll,"long","DisplayHTMLPage","hwnd",$hwnd,"str", GuiCtrlRead($u) )
  If $msg= $back then DLLCall($dll,"none","DoPageAction","hwnd",$hwnd,"int", 0)
      If $msg= $for then DLLCall($dll,"none","DoPageAction","hwnd",$hwnd,"int", 1)
 If $msg= $search then  DLLCall($dll,"long","DisplayHTMLPage","hwnd",$hwnd,"str",  "http://www.google.com/search?q=" & GuiCtrlRead($word) )
    If $msg=$re then DLLCall($dll,"none","DoPageAction","hwnd",$hwnd,"int", 4)
WEnd

Func OnAutoItExit()
DLLCall($dll,"long","UnEmbedBrowserObject","hwnd", $hwnd)
DLLClose($dll)

EndFunc
