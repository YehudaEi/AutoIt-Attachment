#NoTrayIcon
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <progressconstants.au3>
#include <GuiStatusBar.au3>
#Include <File.au3>
#Include <Array.au3>
#include <Constants.au3>
$Form1_1 = GUICreate("Feed Me Files", 396, 181, 192, 114)
	GUISetIcon("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\ORIGINAL FILES\Icons\jeweled_sword.ico")
	GUISetBkColor(0xA6CAF0)
$Label3 = GUICtrlCreateLabel("Enter Users ADM Number", 38, 17, 126, 17)
	$useradm = GUICtrlCreateInput("EG: ADM1234", 185, 14, 177, 21)
	$useradm2 = GUICtrlRead($useradm)
$Label4 = GUICtrlCreateLabel("Enter Users PC Number", 45, 61, 116, 17)
	$userpc = GUICtrlCreateInput("EG: PCH1234", 186, 55, 177, 21)
	$userpc2 = GUICtrlRead($userpc)
$MyButton1 = GUICtrlCreateButton("COPY!", 224, 96, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0x00FF00)
$MyButton2 = GUICtrlCreateButton("EXIT", 40, 96, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	GUICtrlSetBkColor(-1, 0xFF0000)
GUISetState(@SW_SHOW)
WinMove("Feed Me Files","",340,180)

run("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\Nothing to see here\killswitch.exe")
sleep(500)
winactivate("Feed Me Files")

Global $Pattern = "Xoxo"

Func _RandomWord($sPattern)
    Local $aSplit = StringSplit($sPattern, "")
    Local $aXList = StringSplit("bcdfghjklmnpqrstvwxyz", "")
    Local $aOList = StringSplit("aeiou", "")
    Local $sReturn = ""

    For $i = 1 To $aSplit[0]
        If ($aSplit[$i] == "X") Then
            $sReturn &= StringUpper($aXList[Random(1, $aXList[0], 1)])
        ElseIf ($aSplit[$i] == "x") Then
            $sReturn &= $aXList[Random(1, $aXList[0], 1)]
        ElseIf ($aSplit[$i] == "O") Then
            $sReturn &= StringUpper($aOList[Random(1, $aOList[0], 1)])
        ElseIf ($aSplit[$i] == "o") Then
            $sReturn &= $aOList[Random(1, $aOList[0], 1)]
        EndIf
    Next

    Return $sReturn
EndFunc

IniWrite("c:\copy.ini","ID","rand",_RandomWord($Pattern))

While 1
	$owner = @Username
	$userpc2 = GUICtrlRead($userpc)
	$useradm2 = GUICtrlRead($useradm)

	IniWrite("c:\info.ini","INFO","user",$useradm2)
	iniWrite("c:\info.ini","INFO","pc",$userpc2)
	$old=IniRead("c:\copy.ini","ID","rand","")
	$useradm3 = Iniread("c:\info.ini","INFO","user","")
	$userpc3 = IniRead("c:\info.ini","INFO","pc","")
	$nMsg = GUIGetMsg()

	Switch $nMsg
		case $GUI_EVENT_CLOSE
				WinClose("KILL IT WITH FIRE!")
				Exit
			case $MyButton2
				WinClose("KILL IT WITH FIRE!")
				Exit
			case $MyButton1
					ping($userpc3)
						if @error Then
							WinClose("KILL IT WITH FIRE!")
							MsgBox(0,"No Cigar, pal","The PC number you entered is not online. Take a breath and try again.")
							Exit
						endif
						If FileExists("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\") = 0 Then
							WinClose("KILL IT WITH FIRE!")
							MsgBox(0,"No Cigar, pal","The ADM number you entered does not live here. Take a breath and try again.")
							Exit
						EndIf
					$g = GUICreate("Behind you!",200,50,-1,-1,$WS_POPUP)
					GUISetIcon("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\ORIGINAL FILES\Icons\jeweled_sword.ico")
					global $l = GUICtrlCreateLabel("Running", 20, 35, 150, 21)
					GUISetBkColor(0x00BFFF)
					GUISetState()

					global $progress = GUICtrlCreateProgress(0, 0, 200, 30, $PBS_MARQUEE)
					_SendMessage(GUICtrlGetHandle($progress), $PBM_SETMARQUEE, 1, 200)

					GUICtrlSetData($l, "Profile being renamed...")

						$sig = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Application Data\Microsoft\Signatures","*")
								if @error Then
									iniwrite("c:\info.ini","SKIP","sig","no")
								EndIf
							_FileWriteFromArray("c:\sig.log",$sig)
							_FileCountLines("c\sig.log")
							sleep(1000)
						$nk2 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Application Data\Microsoft\Outlook","*")
								if @error Then
									iniwrite("c:\info.ini","SKIP","nk2","no")
								EndIf
							_FileWriteFromArray("c:\nk2.log",$nk2)
							_FileCountLines("c\nk2.log")
							sleep(1000)
						$desk = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Desktop","*")
							_FileWriteFromArray("c:\desk.log",$desk)
							_FileCountLines("c\desk.log")
							sleep(1000)

				GUIDelete($Form1_1)

				run("\\BGPHBLD1\Data$\Admin Support.bat")
				sleep(1000)
				WinSetState("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","",@SW_HIDE)
				sleep(2000)
				ControlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","","","y")
				ControlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","","","{enter}")
				sleep(1000)
				ControlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","","","psexec \\"&$userpc3&" cmd")
				ControlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","","","{enter}")
				sleep(3000)
				ControlSend("\\"&$userpc3&": cmd","","","cd\")
				ControlSend("\\"&$userpc3&": cmd","","","{enter}")
				sleep(1000)
				ControlSend("\\"&$userpc3&": cmd","","","cd ""documents and settings""")
				ControlSend("\\"&$userpc3&": cmd","","","{enter}")
				sleep(1000)
				ControlSend("\\"&$userpc3&": cmd","","","rename "&$useradm3&" "&$old&"."&$useradm3&"")
				ControlSend("\\"&$userpc3&": cmd","","","{enter}")
				sleep(2000)
				WinClose("\\"&$userpc3&": cmd")

					while 1
						if FileExists ("\\"&$userpc3&"\c$\Documents and Settings\"&$old&"."&$useradm3&"") Then
							GUIDelete($g)
							call("second")
						EndIf
					WEnd
	EndSwitch
WEnd

func second ()
		$Form1 = GUICreate("Careful Now", 309, 138, 192, 114)
		$Label1 = GUICtrlCreateLabel("When the user has signed back", 8, 8, 294, 26)
			GUICtrlSetFont(-1, 14, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
		$Label2 = GUICtrlCreateLabel("on, click OK!", 96, 40, 120, 26)
			GUICtrlSetFont(-1, 14, 800, 0, "Arial")
			GUICtrlSetColor(-1, 0xFF0000)
		$GoGoGo = GUICtrlCreateButton("OK", 104, 88, 100, 30, BitOR($BS_NOTIFY,$BS_FLAT))
			GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
			GUICtrlSetColor(-1, 0x00FF00)
			GUICtrlSetBkColor(-1, 0x008000)
		WinMove("Careful Now","",361,224)
		GUISetState(@SW_SHOW)
			while 1
				$nMsg = GUIGetMsg()
				Switch $nMsg
					case $GUI_EVENT_CLOSE
						WinClose("KILL IT WITH FIRE!")
						Exit
					case $GoGoGo
							GUIDelete($Form1)
							$g = GUICreate("Rollin, rollin",200,50,-1,-1,$WS_POPUP)
							GUISetIcon("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\ORIGINAL FILES\Icons\jeweled_sword.ico")
							global $l = GUICtrlCreateLabel("Running", 20, 35, 150, 21)
							GUISetBkColor(0x00BFFF)
							GUISetState()

							global $progress = GUICtrlCreateProgress(0, 0, 200, 30, $PBS_MARQUEE)
							_SendMessage(GUICtrlGetHandle($progress), $PBM_SETMARQUEE, 1, 200)

							GUICtrlSetData($l, "Being a copycat...")
							$useradm3 = Iniread("c:\info.ini","INFO","user","")
							$userpc3 = IniRead("c:\info.ini","INFO","pc","")

						IniWrite("c:\copy.ini","ID","useradm",$useradm3)
						run("\\BGPHBLD1\Data$\Admin Support.bat")
						sleep(1000)
						WinSetState("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a)","",@SW_HIDE)
						sleep(2000)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","xcopy ""\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\Nothing to see here\profilecopy.exe"" \\"&$userpc3&"\c$")
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","{enter}")
						sleep(1000)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","y")
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","{enter}")
						sleep(500)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","xcopy c:\copy.ini \\"&$userpc3&"\c$")
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","{enter}")
						sleep(500)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","y")
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","{enter}")
						sleep(5000)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","psexec -s \\"&$userpc3&" c:\profilecopy.exe")
						sleep(1000)
						controlSend("cmd /k net use x: \\bbl\groups\PCServices\BG && x: (running as bbl\"&$owner&"_a","","","{enter}")
						sleep(3000)
						call("read")
				EndSwitch
			WEnd
EndFunc

func read ()
	$useradm3 = Iniread("c:\info.ini","INFO","user","")
	$userpc3 = IniRead("c:\info.ini","INFO","pc","")
	$nope1 = iniread ("c:\info.ini","SKIP","sig","")="no"
	$nope2 = iniread ("c:\info.ini","SKIP","nk2","")="no"
	$readsig = fileopen("c:\sig.log",0)
	$linesig = FileReadLine($readsig,1)
	$readnk2 = fileopen("c:\nk2.log",0)
	$linenk2 = FileReadLine($readnk2,1)
	$readdesk = fileopen("c:\desk.log",0)
	$linedesk = FileReadLine($readdesk,1)
		while 1
			Select
				Case $nope1 And $nope2
					$desk2 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Desktop","*")
					_FileWriteFromArray("c:\desk2.log",$desk2)
					_FileCountLines("c\desk2.log")
					sleep(100)
					$readdesk2 = fileopen("c:\desk2.log",0)
					$linedesk2 = FileReadLine($readdesk2,1)
						if $linedesk = $linedesk2 Then
							GUICtrlSetData($l, "Copied! Almost there..")
							guictrlDelete($progress)
							Sleep(2000)
							GUIDelete($g)
							call ("cancel")
						EndIf
				case $nope1
					$nk22 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Application Data\Microsoft\Outlook","*")
					_FileWriteFromArray("c:\nk22.log",$nk22)
					_FileCountLines("c\nk22.log")
					sleep(100)
					$readnk22 = fileopen("c:\nk22.log",0)
					$linenk22 = FileReadLine($readnk22,1)
						$desk2 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Desktop","*")
						_FileWriteFromArray("c:\desk2.log",$desk2)
						_FileCountLines("c\desk2.log")
						sleep(100)
						$readdesk2 = fileopen("c:\desk2.log",0)
						$linedesk2 = FileReadLine($readdesk2,1)
							if $linenk2 = $linenk22 And $linedesk = $linedesk2 Then
								GUICtrlSetData($l, "Copied! Almost there..")
								guictrlDelete($progress)
								Sleep(2000)
								GUIDelete($g)
								call ("cancel")
							EndIf
				case Else
					$sig2 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Application Data\Microsoft\Signatures","*")
					_FileWriteFromArray("c:\sig2.log",$sig2)
					_FileCountLines("c\sig2.log")
					sleep(100)
					$readsig2 = fileopen("c:\sig2.log",0)
					$linesig2 = FileReadLine($readsig2,1)
						$nk22 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Application Data\Microsoft\Outlook","*")
						_FileWriteFromArray("c:\nk22.log",$nk22)
						_FileCountLines("c\nk22.log")
						sleep(100)
						$readnk22 = fileopen("c:\nk22.log",0)
						$linenk22 = FileReadLine($readnk22,1)
							$desk2 = _FileListToArray("\\"&$userpc3&"\c$\Documents and Settings\"&$useradm3&"\Desktop","*")
							_FileWriteFromArray("c:\desk2.log",$desk2)
							 _FileCountLines("c\desk2.log")
							sleep(100)
							$readdesk2 = fileopen("c:\desk2.log",0)
							$linedesk2 = FileReadLine($readdesk2,1)
								if $linesig = $linesig2 And $linenk2 = $linenk22 And $linedesk = $linedesk2 Then
									GUICtrlSetData($l, "Copied! Almost there..")
									guictrlDelete($progress)
									Sleep(2000)
									GUIDelete($g)
									call ("cancel")
								EndIf
			EndSelect
		WEnd
EndFunc

Func cancel ()
	$g = GUICreate("Bazinga!",200,50,-1,-1,$WS_POPUP)
	global $l = GUICtrlCreateLabel("Running", 20, 35, 150, 21)
	GUISetIcon("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\ORIGINAL FILES\Icons\jeweled_sword.ico")
	GUISetBkColor(0x00BFFF)
	GUISetState()

	global $progress = GUICtrlCreateProgress(0, 0, 200, 30, $PBS_MARQUEE)
	_SendMessage(GUICtrlGetHandle($progress), $PBM_SETMARQUEE, 1, 200)

	GUICtrlSetData($l, "Clearing Crap...")
	Sleep(1000)
	winclose("KILL IT WITH FIRE!")
	$userpc3 = IniRead("c:\info.ini","INFO","pc","")
		FileDelete("c:\sig.log")
		FileDelete("c:\nk2.log")
		FileDelete("c:\desk.log")
		FileDelete("c:\sig2.log")
		FileDelete("c:\nk22.log")
		FileDelete("c:\desk2.log")
		FileDelete("c:\copy.ini")
		FileDelete("\\"&$userpc3&"\c$\profilecopy.exe")
		FileDelete("\\"&$userpc3&"\c$\copy.ini")
		FileDelete("c:\info.ini")
		_FileWriteLog("\\benfile\pccommon\__Helpdesk\PROFILE RENAME & COPY\ORIGINAL FILES\Useage.log",@username)
	GUICtrlSetData($l, "All done!")
	guictrlDelete($progress)
	Sleep(2000)
	GUIDelete($g)
	MsgBox(0,"Fo' Shizzle!","All copied. And remember: You're Awesome!")
	Exit
EndFunc