#include <GUICONSTANTS.au3>
#notrayicon
Global $enter
Global $password
Global $password2

If Not FileExists(@ScriptDir & "\notes.au3.ini") Then	
	IniWrite(@ScriptDir & "\data\notes.ini","Notes","Notes","5")
	FileWrite(@ScriptDir & "\data\notes.txt","Empty")
	
	IniWrite(@ScriptDir & "\data\notes.ini","Notes","Sites","5")
	FileWrite(@ScriptDir & "\data\sites.txt","Empty")
	
	IniWrite(@ScriptDir & "\data\notes.ini","Notes","Passwords","5")
	FileWrite(@ScriptDir & "\data\passwords.txt","Empty")
	
	IniWrite(@ScriptDir & "\data\notes.au3.ini","Notes","Numbers","5")
	FileWrite(@ScriptDir & "\data\numbers.txt","Empty")
EndIf

;$Previous="Notes"

Opt ("GUICoordMode",1)

$GUI = GUICreate("Note Manager",413,374, -1, -1,0x04CF0000)
	$NotesT1=GUICtrlCreateTab(10,10,390,351)
		$NotesT=GUICtrlCreateTabItem("Notes")
			$Notes=FileRead(@ScriptDir & "\data\notes.txt",IniRead(@ScriptDir & "\data\notes.ini","Notes","Notes","error"))
			$Notes=GUICtrlCreateEdit($Notes,20,40,370,310)
		$SitesT=GUICtrlCreateTabItem("Sites")
			$Sites=FileRead(@ScriptDir & "\data\sites.txt",IniRead(@ScriptDir & "\data\notes.ini","Notes","Sites","error"))
			$Sites=GUICtrlCreateEdit($Sites,20,40,370,310)
		$PasswordsT=GUICtrlCreateTabItem("Passwords")
			$Passwords=FileRead(@ScriptDir & "\data\passwords.txt",IniRead(@ScriptDir & "\data\notes.ini","Notes","Passwords","error"))
			$Passwords=GUICtrlCreateEdit($Passwords,20,40,370,310)
				GUICtrlSetState($Passwords,32)
			$epcT = GUICtrlCreateLabel ( "Please enter the passcode", 20, 40, 370, 15 )
			GUICtrlSetState ( $epcT, 32 )
			$password = GUICtrlCreateInput ( "", 20, 55, 300, 20, 0x0020 )
			GUICtrlSetState ( $password, 32 )
			$enter = GUICtrlCreateButton ( "Enter", 20, 75, 300, 25 )
			GUICtrlSetState ( $enter, 32 )
			$password2 = IniRead ( @ScriptDir & "\data\notesp.ini", "Notes", "Password", "error" )
			$penpT = GUICtrlCreateButton("Set Password",20,75,300,25)
			GUICtrlSetState ( $penpT, 32)
			$Password1=GUICtrlCreateInput("",20,55,300,20,0x0020)
			GUICtrlSetState ( $Password1, 32)
			$Set=GUICtrlCreateButton("Set Password",20,75,300,25)
			GUICtrlSetState ( $Set, 32 )
			If FileExists ( @ScriptDir & "\data\notesp.ini" ) Then
				GUICtrlSetState ( $epcT, 16 )
				GUICtrlSetState ( $password, 16 )
				GUICtrlSetState ( $enter, 16 )
				GUICtrlSetState ( $password2, 16 )
			Else
				GUICtrlSetState ( $penpT, 16 )
				GUICtrlSetState ( $Password1, 16 )
				GUICtrlSetState ( $Set, 16 )
			EndIf
		$NumbersT=GUICtrlCreateTabItem("Numbers")
			$Numbers=FileRead(@ScriptDir & "\data\numbers.txt",IniRead( @ScriptDir & "\data\notes.ini","Notes","Numbers","error"))
			$Numbers=GUICtrlCreateEdit($Numbers,20,40,370,310)
		$tab_close=GUICtrlCreateTabItem("")
GUISetState()

While 1
	$msg=GUIGetMsg()
	
	Select
		
		Case $msg=$Set
			IniWrite(@ScriptDir & "\data\notesp.ini","Notes","Passwords",GuiCtrlRead($Password1))
			GuiCtrlSetState($Passwords,16)
			GuiCtrlSetState($Password1,32)
			GuiCtrlSetState($Set,32)
			GuiCtrlSetState($penpT,32)
		Case $msg = $enter
			If GUICtrlRead ( $password ) = IniRead ( @ScriptDir & "\data\notesp.ini", "Notes", "Passwords", "error" ) Then
				GUICtrlSetState ( $Passwords, 16 )
				GUICtrlSetState ( $epcT, 32 )
				GUICtrlSetState ( $password, 32 )
				GUICtrlSetState ( $enter, 32 )
				GUICtrlSetState ( $password2, 32 )
			EndIf
		Case $msg=$GUI_EVENT_CLOSE
			GUISetState ( @SW_HIDE )
			IniWrite(@ScriptDir & "\data\notes.ini","Notes","Notes",StringLen(GUICtrlRead($Notes)))
			$n=FileOpen(@ScriptDir & "\data\notes.txt",2)
			FileWrite($n,GUICtrlRead($Notes))
			
			IniWrite(@ScriptDir & "\data\notes.ini","Notes","Sites",StringLen(GUICtrlRead($Sites)))
			$s=FileOpen(@ScriptDir & "\data\sites.txt",2)
			FileWrite($s,GUICtrlRead($Sites))
			
			If IsDeclared("Passwords") Then
				IniWrite(@ScriptDir & "\data\notes.ini","Notes","Passwords",StringLen(GUICtrlRead($Passwords)))
				$p=FileOpen(@ScriptDir & "\data\passwords",2)
				FileWrite($p,GUICtrlRead($Passwords))
			EndIf
			
			IniWrite("C:\Windows\notes.ini","Notes","Numbers",StringLen(GUICtrlRead($Numbers)))
			$ph=FileOpen(@ScriptDir & "\data\numbers.txt",2)
			FileWrite($ph,GUICtrlRead($Numbers))
			
			Exit
			
		Case $msg=$enter
			
			If GUICtrlRead($password)==$password2 Then
				GUICtrlSetState($Passwords,16)
				GUICtrlSetState($password,32)
				GUICtrlSetState($enter,32)
				GUICtrlSetState($epcT,32)
			EndIf
			
	EndSelect
WEnd
Exit
