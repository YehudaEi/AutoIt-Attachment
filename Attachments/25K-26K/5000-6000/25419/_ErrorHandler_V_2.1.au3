
#region;------- Autoit Error Handler launcher

;############################################################################
;   1st part (launcher) copy in first line of your program
;############################################################################

If StringInStr($cmdlineraw,"*")=0 Then
    Opt("TrayIconHide",1)
    If @Compiled Then
        $x=Run(@ScriptName&" *")
    Else
        $x=Run('"Autoit3.exe" "'&@ScriptFullPath&'" *')
    EndIf
    ProcessWait($x,5)
    While ProcessExists($x)
        If WinActive("AutoIt Error") Then _OnAutoItError(WinGetText("AutoIt Error"))
        Sleep(20)
    WEnd
    Exit
EndIf
 
#endregion;-------launcher

Msgbox() ; this will trigger the error !

;#=#INDEX#==================================================================#
;#  Title .........: AutoIt3 Error Handler                          #
;#  Date ..........: 4.4.2009                                       #
;#  Date ..........: 4.9.2008                                       #
;#  Author ........: rajesh v r  (rajeshwithsoftwareatgmaildotcom)  #
;#==========================================================================#
; Code entirely based on Jennico's Error Handler derived from MadExcept Option
; 


Func _OnAutoItError($txt)
	Send("{ENTER}")  
	
	Local $ShowError = False
	
  ; an error has occured, stop the progress bar first (if it is there)
   
  #include <GUIConstantsEx.au3>
  #include <WindowsConstants.au3>
  #include <EditConstants.au3>
  
	opt("GUIResizeMode",802)   ;~ 	$GUI_DOCKALL
		
;~ 	GUICreate(@ScriptName,385,90)
	GUICreate(@SCriptName,385,225)
	GUISetIcon("")
    GUISetBkColor(0xE0DFE2)
        
		GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,383,1),0x41689E)
        GUICtrlSetResizing(-1,802)
		GUICtrlSetBkColor(GUICtrlCreateLabel("",1,88,383,1),0x41689E)
		GUICtrlSetResizing(-1,802)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",1,1,1,88),0x41689E)
		GUICtrlSetResizing(-1,802)
        GUICtrlSetBkColor(GUICtrlCreateLabel("",383,1,1,88),0x41689E)
		GUICtrlSetResizing(-1,802)    
		GUICtrlCreateIcon("user32.dll",103,11,11,32,32)
	    GUICtrlSetBkColor(GUICtrlCreateLabel("An error occurred in the application.",52,22,175,15),-2)
	    GUICtrlSetBkColor(GUICtrlCreateLabel("",10,60,110,22),0x706E63)
		GUICtrlSetState(-1,128)
	
		$send=GUICtrlCreateLabel("   send bug report",28,64,92,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetColor(-1,0xFFFFFF)
			GUICtrlSetCursor(-1,0)
        $sen=GUICtrlCreateIcon("shell32.dll",25,13,63,16,16)
            GUICtrlSetCursor(-1,0)
			GUICtrlSetBkColor(GUICtrlCreateLabel("",124,60,114,22),0xEFEEF2)
            GUICtrlSetState(-1,128)
        $show=GUICtrlCreateLabel("   show bug report",143,64,95,15)
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
        $sho=GUICtrlCreateIcon("shell32.dll",23,127,63,16,16)
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
		$rep=GUICtrlCreateEdit($txt & @CRLF ,8,95,370,120,BitOR($ES_MULTILINE,$ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$WS_VSCROLL,$WS_HSCROLL))
            GUICtrlSetBkColor(-1,-2)
            GUICtrlSetCursor(-1,0)
			ConsoleWrite($txt)
	
	If NOT $ShowError Then WinMove ( @ScriptName, "", Default , Default , 391,125) ; hiding the error message detail at startup 
	
	GUISetState() ; show the GUI Window
	
	WinSetOnTop(@ScriptName,"",1)
	
    
	Do
        $msg=GUIGetMsg()
	
        If $msg=$cont Or $msg=$con Then MsgBox(270400,"Continue Application", _
            "Sorry ! Cannot continue until the Bug is fixed by the Author!     ")
        If $msg=$show Or $msg=$sho Then
			
			$ShowError  = NOT($ShowError)
			
			If $ShowError Then 
				MsgBox(270400,"Show Bug Report",$txt)
				
				WinMove ( @ScriptName , "",Default,Default,391,257) ;something causes original GUI to be created 391 and not 385 
				GUICtrlSetData($show,"   hide bug report")
			Else 
				WinMove ( @ScriptName, "", Default , Default , 391,125) 
				GUICtrlSetData($show,"   show bug report")
			EndIf
	
		EndIf
	

		If $msg=$send Or $msg=$sen Then
            ;#include <INet.au3>    ;   use email
            ;_INetSmtpMail ( $s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress [,$s_Subject&_
            ;[,$as_Body [,$s_helo, [,$s_first [,$b_trace]]]]])
            MsgBox(270400,"Send Email","Feature Not Available")
        EndIf
    
	Until $msg=-3 Or $msg=$close Or $msg=$clos Or $msg=$rest Or $msg=$res 
    
	If $msg=$rest Or $msg=$res Then
        If @Compiled Then
            $x=Run(@ScriptName)
        Else
        ;   $x=Run("Autoit3.exe "&@ScriptFullPath)
            $x=Run('"Autoit3.exe" "'&@ScriptFullPath&'"')
        EndIf
    EndIf
	
    Exit
EndFunc

;   apologize option
Func _OnAutoItError1($txt)
    Send("{ENTER}")
    MsgBox(270336," :-(      So Sorry  --- ","Script  <"& _
        @ScriptName&">  terminated."&@CRLF&@CRLF&"Error Message:"&@CRLF&@CRLF& _
        $txt&@CRLF&@CRLF&"The Author deeply apologizes for the inconvenience !"&@CRLF&@CRLF)
    ; or make a logfile or restart the script or whatever ......
    Exit
EndFunc
 