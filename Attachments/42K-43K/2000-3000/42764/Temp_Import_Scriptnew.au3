#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

Dim $hMsg 
Dim $path
Dim $test
Dim $usrname ; get the user name 
Dim $mserver ;get server name
Dim $lpwd ;
Dim $Email
Dim $Empid
Dim $splitsrname
Dim $hButton
Dim $hButton2
Dim $intWindow
Dim $delwindow
Dim  $hInput;Email address

   $hGUI = GUICreate( "Lotus Notes Auto Config", 460, 189, -1, -1)
   $Empid = GUICtrlCreateLabel( "Enter TCS Emp ID :", 33, 30, 140, 27)
   GUICtrlSetFont( -1, 10, 800, 0)
   $hLabel2 = GUICtrlCreateLabel( "Enter Email Address :", 33, 64, 153, 27)
   GUICtrlSetFont( -1, 10, 800, 0)
   $hLabel3 = GUICtrlCreateLabel( "Enter Server Name :", 33, 102, 153, 27)
   GUICtrlSetFont( -1, 10, 800, 0)
   $hInput = GUICtrlCreateInput( "", 220, 30, 221, 27)
   $hInput2 = GUICtrlCreateInput( "", 220, 64, 221, 27)
   $hInput3 = GUICtrlCreateInput( "", 220, 102, 221, 27)
   $hButton = GUICtrlCreateButton( "OK", 82, 146, 96, 26)
   GUICtrlSetFont( -1, 8.5, 800, 0)
   $hButton2 = GUICtrlCreateButton( "Cancle", 228, 146, 98, 26)
   GUICtrlSetFont( -1, 8.5, 800, 0)
   $hLabel4 = GUICtrlCreateLabel( "(Eg.Inblrm06.tcs.com)", 42, 121, 117, 13)
   $hLabel5 = GUICtrlCreateLabel( "(Eg.first.last name@tcs.com )", 34, 85, 144, 17)
   
 
   GUISetState(@SW_SHOW)
While 1 
  $hMsg = GUIGetMsg()
	Select
	Case $hButton
			  $Empid =GUICtrlRead($hInput)
			   $mserver = GUICtrlRead($hInput3)
			   $Email = GUICtrlRead($hInput2)
		 if $Empid ="" or $Email="" or $mserver="" Then
		   MsgBox (4096,"Warning" ,"Empid cannot be blank " & @CRLF & " Try again ")
			Else
			  IDfile()
			EndIf
		 Case $hButton2
			ExitLoop
    EndSelect
   WEnd

Func Idfile()
		 $hGUI1 = GUICreate( "Lotus Notes Auto Config ", 394, 142, -1, -1)
		 $hLabel1 = GUICtrlCreateLabel( "Select Notes ID file ", 98, 16, 142, 27)
		 GUICtrlSetFont( -1, 10, 800, 0)
		 $hButton1 = GUICtrlCreateButton( "Browse", 53, 92, 96, 23)
		 GUICtrlSetFont( -1, 10, 800, 0)
		 $hButton21 = GUICtrlCreateButton( "Cancle", 229, 92, 95, 23)
		 GUICtrlSetFont( -1, 8.5, 800, 0)
		 $path = GUICtrlCreateInput( "", 19, 43, 349, 27)
		 GUISetState()
		 $hMsg1 = 0
		 While $hmsg1 <> $GUI_EVENT_CLOSE
			$hMsg1 = GUIGetMsg()
			Select
			   Case $hmsg1 = $hButton1
			   $File2open = FileOpenDialog ("Browse", "C:\", "ID file  (*.nsf)") ;returns the file path
			   GUICtrlSetData($path, $File2open)				;set input data
			   $test = GUICtrlSetData($path, $File2open) 
			   Case $hMsg1 = $hButton21
			   GUIDelete($delwindow)
			   return
			EndSelect
		 Wend	
EndFunc



