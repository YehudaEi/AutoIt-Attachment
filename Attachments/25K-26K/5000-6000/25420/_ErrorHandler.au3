;#=#INDEX#==================================================================#
;#  Title .........: _Error Handler.au3                                     #
;#  Description....: AutoIt3 Error Handler & Debugger                       #
;#  Date ..........: 4.4.09                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#                   @MrCreatoR                                             #
;#                   MadExcept (GUI inspiration by mrRevoked)               #
;#                   Rajesh V R Just the GUI Modifications :-)              #
;#==========================================================================#

#include-once

_OnAutoItError()

;#=#Function#===============================================================#
;#  Title .........: _OnAutoItError()                                       #
;#  Description....: AutoIt3 Error Handler & Debugger GUI                   #
;#  Parameters.....: (None)                                                 #
;#  Date ..........: 4.4.09                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#                   @MrCreatoR                                             #
;#                   rajeshontheweb (rajeshwithsoftware@gmail.com           #
;#==========================================================================#

;   this function is made to be customized !

Func _OnAutoItError()
    If StringInStr($CmdLineRaw,"/AutoIt3ExecuteScript") Then Return
    Opt("TrayIconHide",1)
    ;   run a second instance
    $iPID=Run(@AutoItExe&' /ErrorStdOut /AutoIt3ExecuteScript "'&@ScriptFullPath&'"',@ScriptDir,0,6)
    ProcessWait($iPID)
    $sErrorMsg=""
    ;   trap the error message
    While 1
        $sErrorMsg&=StdoutRead($iPID)
        If @error Then ExitLoop
        Sleep(1)
    WEnd
    If $sErrorMsg="" Then Exit
;~     GUICreate(@ScriptName,385,90,Default,Default,-2134376448);BitOR($WS_CAPTION,$WS_POPUP,$WS_SYSMENU)
	
	Local $ShowError = False
	
	opt("GUIResizeMode",802)   ;~ 	$GUI_DOCKALL
	Local $ShowError = False ; this will be used to show or hide errors.
	
	
	GUICreate(@SCriptName,385,225)
    GUISetBkColor(0xE0DFE2)
	
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,383,1),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,88,383,1),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,1,88),0x41689E)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",383,1,1,88),0x41689E)
        GUICtrlCreateIcon("user32.dll",103,11,11,32,32)
        GUICtrlSetBkColor(GUICtrlCreateLabel("An error occurred in the application.",52,21,175,15),-2)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",10,60,110,22),0x706E63)
            GUICtrlSetState(-1,128)
        $send=GUICtrlCreateLabel("   send bug report",28,64,92,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetColor(-1,0xFFFFFF)
            GUICtrlSetCursor(-1,0)
        $sen=GUICtrlCreateIcon("explorer.exe",254,13,63,16,16)
            GUICtrlSetCursor(-1,0)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",124,60,114,22),0xEFEEF2)
            GUICtrlSetState(-1,128)
        $show=GUICtrlCreateLabel("   show bug report",143,64,95,15)
            If @Compiled=0 Then GUICtrlSetData(-1,"    De-Bug Script")
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $sho=GUICtrlCreateIcon("shell32.dll",23,127,63,16,16)
            If @Compiled=0 Then GUICtrlSetImage(-1,"shell32.dll",-81)
            GUICtrlSetCursor(-1,0)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",246,8,131,22),0xEFEEF2)
            GUICtrlSetState(-1,128)
        $cont=GUICtrlCreateLabel("   continue application",265,12,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $con=GUICtrlCreateIcon("shell32.dll",290,249,11,16,16)
            GUICtrlSetCursor(-1,0)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",246,34,131,22),0xEFEEF2)
            GUICtrlSetState(-1,128)
        $rest=GUICtrlCreateLabel("    restart application",265,38,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $res=GUICtrlCreateIcon("shell32.dll",255,249,37,16,16)
            GUICtrlSetCursor(-1,0)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",246,60,131,22),0xEFEEF2)
            GUICtrlSetState(-1,128)
        $close=GUICtrlCreateLabel("     close application",265,64,115,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $clos=GUICtrlCreateIcon("shell32.dll",240,249,63,16,16)
			GUICtrlSetCursor(-1,0)
		$rep=GUICtrlCreateEdit($sErrorMsg& @CRLF ,8,95,370,120,BitOR(0x00200000,0x00100000 ,0x0004,0x0040,0x0080,0x0800)) 
		; $WS_VSCROLL 0x00200000 $ES_MULTILINE 0x0004 $ES_AUTOVSCROLL 0x0040 $ES_AUTOHSCROLL 0x0080 $ES_READONLY 0x0800 $WS_HSCROLL 0x00100000 
		    GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
			
	If NOT $ShowError Then WinMove ( @ScriptName, "", Default , Default , 391,125) ; hiding the error message detail at startup 
    
	GUISetState()
    WinSetOnTop(@ScriptName,"",1)
	SoundPlay(@WindowsDir&"\Media\chord.wav")
    
	Opt("TrayIconHide",0)
    Opt("TrayAutoPause",0)
    TraySetToolTip("AutoIt Error Handler and Debugger")
    ;   choose action to be taken
    Do
        $msg=GUIGetMsg()
        If $msg=$cont Or $msg=$con Then MsgBox(270400,"Continue Application", _
            "I am afraid, not possible with AutoIt !     "&@CRLF&@CRLF& _
            "( No GoTo command )      :-( ")
        If $msg=$send Or $msg=$sen Then MsgBox(270400,"Send Bug Report","Email successfully sent !     ")
            ;#include <INet.au3>    ;   use email
            ;_INetSmtpMail ( $s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress [,$s_Subject&_
            ;[,$as_Body [,$s_helo, [,$s_first [,$b_trace]]]]])
        If $msg=$show Or $msg=$sho Then
            If @Compiled=0 Then __Debug($sErrorMsg)
			If @Compiled Then 		
				$ShowError  = NOT($ShowError)
				
				If $ShowError Then 
					MsgBox(270400,"Show Bug Report",$sErrorMsg)
					
					WinMove ( @ScriptName , "",Default,Default,391,257) ;something causes original GUI to be created 391 and not 385 
					GUICtrlSetData($show,"   hide bug report")
				Else 
					WinMove ( @ScriptName, "", Default , Default , 391,125) 
					GUICtrlSetData($show,"   show bug report")
				EndIf
			EndIf
		EndIf
    Until $msg=-3 Or $msg=$close Or $msg=$clos Or $msg=$rest Or $msg=$res
    If $msg=$rest Or $msg=$res Then Run(@AutoItExe&' "'&@ScriptFullPath&'"',@ScriptDir,0,6)
    Exit
EndFunc

;#=#Function#===============================================================#
;#  Title .........: __Debug ( $txt )                                       #
;#  Description....: Debug Function for _ErrorHandler.au3                   #
;#  Parameters.....: $txt = Error Message Text from StdoutRead              #
;#  Date ..........: 7.9.08                                                 #
;#  Authors .......: jennico (jennicoattminusonlinedotde)                   #
;#                   @MrCreatoR                                             #
;#                					                                       	#
;#==========================================================================#

Func __Debug($txt)
    WinSetState(@ScriptName,"",@SW_HIDE)
    $a=StringSplit($txt,@CRLF,1)
    $scitePath=RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\SciTE.exe","")
    Dim $b=StringSplit($a[1],") : ==> ",1),$number=StringMid($b[1],StringInStr($b[1],"(")+1)
    Dim $code="Error Code: "&@TAB&StringTrimRight($b[2],2),$line="Line: "&@TAB&$number&" => "&$a[3]
    Dim $file="File: "&@TAB&StringReplace($b[1]," ("&$number,""),$count=StringLen($code),$height=180
    If StringLen($file)>$count Then $count=StringLen($file)
    If StringLen($line)>$count Then $count=StringLen($line)
    If StringLen($a[2])>$count Then $count=StringLen($a[2])
    If $count*6>@DesktopWidth-50 Then Dim $count=(@DesktopWidth-50)/6,$height=240
    $pid=Run($scitePath&' "'&@ScriptFullPath&'" /goto:'&$number&","&StringLen($a[2])-1)
    $x=InputBox(" Please Correct this line:",$code&@CRLF&@CRLF&$file&@CRLF&@CRLF& _
        $line,StringTrimRight($a[2],1),"",$count*6,$height)
    WinSetState(@ScriptName,"",@SW_SHOW)
    If $x="" Or $x=StringTrimRight($a[2],1) Then Return
    $t=StringSplit(FileRead(@ScriptFullPath),@CRLF,1)
    $t[$number]=StringReplace($t[$number],StringTrimRight($a[2],1),$x)
    $open=FileOpen(@ScriptFullPath,2)
    For $i=1 to $t[0]
        FileWriteLine($open,$t[$i])
    Next
    FileClose($open)
    ControlSend(@ScriptDir,"","ToolbarWindow32","^R")
EndFunc