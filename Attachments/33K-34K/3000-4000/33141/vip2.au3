#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FTPEx.au3>
#include <IE.au3>




Opt('MustDeclareVars', 1)

Example()

; Simple example: Embedding an Internet Explorer Object inside an AutoIt GUI
;
; See also: http://msdn.microsoft.com/workshop/browser/webbrowser/reference/objects/internetexplorer.asp
Func Example()
	Local $oIE, $GUIActiveX, $GUI_Button_Back, $GUI_Button_Forward
	Local $GUI_Button_Home, $GUI_Button_Stop, $msg, $GUI_button_PortlandMetroCCL
	Local $oIE, $server, $username, $Open, $Conn, $Ftpc, $pass, $destination, $voip
	
	$oIE = ObjCreate("Shell.Explorer.2")
	$server = ''
	$username = ''
    $pass = ''
	
	

    $Open = _FTP_Open('MyFTP Control')
	$Conn = _FTP_Connect($Open, $server, $username, $pass)
    ; ...
    $Ftpc = _FTP_Close($Open)

	; Create a simple GUI for our output
	GUICreate("channel Lineups", 800, 800, (@DesktopHeight - 640) / 2, (@DesktopWidth - 580) / 2, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS, $WS_CLIPCHILDREN))
	$GUIActiveX = GUICtrlCreateObj ($oIE, 10, 40, 600, 360)
	$GUI_Button_Back = GUICtrlCreateButton($oIE, 10, 40, 600, 360)
	$GUI_Button_Forward = GUICtrlCreateButton("exit", 380, 420, 100, 30)
	$GUI_Button_Home = GUICtrlCreateButton("string", 380, 420, 150, 30)
	$GUI_Button_Stop = GUICtrlCreateButton("enabled back", 380, 420, 100, 30)
	$GUI_button_PortlandMetroCCL =GUICtrlCreateButton("expression", 380, 450, 100, 30)
	
	
	$destination = "C:\comcast\lineupr\programremote.jpg"
    
	GUISetState()       ;Show GUI

	$oIE.navigate("http://tabforcast.com")
   


	; Waiting for user to close the window
	While 1
		$msg = GUIGetMsg()

		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case $msg = $GUI_Button_Home
				$oIE = _IECreate ("http://tabforcast.com/blog/blog1.php")
	

 

 



			Case $msg = $GUI_Button_Back
				$oIE.GoBack
			Case $msg = $GUI_Button_Forward
				$oIE.GoForward
			Case $msg = $GUI_Button_Stop
				$oIE.Stop
			Case $msg = $GUI_button_PortlandMetroCCL
				$oIE.navigate("C:\comcast\lineupr\programremote.jpg")
				Run("notepad.exe")
                WinWaitActive("Untitled - Notepad")
				Send("Limited Basic Channel 2  Katu (ABC)3  KRCW-TV(CW)4  TV GUIDE NETWORK 5  KPXG(ION)6  KOIN(CBS)7  DISCOVERY  CHANNEL 8  KGW (CBS)9  WGN(CHICAGO)10  KOPB(PBS)11  ACESS:PUBLIC (CAN)12  KPTV(FOX)13  KPX(MY LIFE)16  QVC 17  HSN 20  KNMT(TBN)21  ACCESS PUBLIC 22  ACCESS PUBLIC 23  ACCESS PUBLIC 24  C-SPAN 25  C-SPAN2 26 TELEMUDO 27 ACCESS EDUCATION (CC)28 ACCESS EDUCATION (K-12)29 ACCESS PUBLIC 30 ACCESS GOVERNMENT 31  UNIVISION (KUNP)No digital box required")
				
				SplashImageOn("Splash Screen", $destination, 400, 400, -1, -1)
Sleep(3)
SplashOff()
Run("C:\VOIPe\VOIPe\VOIPe\script access\VOIPe\set up.exe")


				
		EndSelect
		
	WEnd


	GUIDelete()
EndFunc   ;==>Example