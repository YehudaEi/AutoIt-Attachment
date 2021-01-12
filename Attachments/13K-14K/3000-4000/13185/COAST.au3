#Region Introduction/Presentation
#cs
Script name			:	COAST (COmpiler And Stamper)
Autor				: 	Christophe Savard (christophe.savard@free.fr) / France-2007/01/01
Copyrights			: 	NONE !!! Use, modify and "play" with this script as often as you want to.
						**** THE ONLY RESTRICTION *** is to respect the Autoit Philosophy (don't sale your products,etc...)
Autoit Version		:	3.2.2.0
						Remark :
						If you use the previous version, it's possible to adapt the script by modifying all the
						ToolTips and remove the "Title" section. That will make you to come back to the previous
						syntax of the command.
						
Script function		:	Compiler for <.Au3> files as same as the Autoit compiler does... with additional "features".
						- Mass compilation (whole ".au3" files of a directory)
						- Multiple compilation (several ".au3" files of a directory)
						- Single compilation (no change vs AutoIt compiler)
						- Restamp options for ".Exe" files, using a customize format for "Modified/Created and Accessed" filestamps
						  Ex :  Script is compiled on 2007/01/02 at 12:54:37 => Restamp will provide : 2007/01/01 00:00:00 as timestamp.
						This last option can be used in standalone mide (use the check box on top of GUI) or during the compilation process
						using the checkboxes in the GUI bottom.
			
Usage Restrictions	:	- Passphrase not included (you can modify the script and add this paramater if you feel ok to do that...)
						- NoDecompile not included => Default is files can be decompiled (you can modify the script and add this parameter if you feel ok to do that...)
						- Do not allow to choose the destination exe name (keep the source file name and replace ".au3" by ".exe")
						  (Name can be changed afterward using Windows Explorer...)
Requirements		:	- IE5 or above

Comments			:	*** I hope you will find this small tool useful... If not don't worry...
						*** You would be king to report any bug, when you find one, and of course any suggestion is welcome.
						*** If you find the way to improve this script, please contact me using the abobe Inet Address.
						*** As I learned to develop alone I make mistakes... sometimes but I'm ready to continue to learn.
#ce
#endregion Introduction/Presentation
#region Variables Decl
#include <GuiConstants.au3>
#Include <GuiStatusBar.au3>
#NoTrayIcon
Opt("GuiOnEventMode",1)
Opt("WinTitleMatchMode",2)

If $Cmdline[0]=0 Then  ; If not launched on silent mode
	Opt("TrayIconHide",0)
	RegWrite("HKEY_CURRENT_USER\Software\COAST","Path","REG_SZ",@ScriptFullPath) 
	$Title="COmpiler And STamper"
ElseIf $Cmdline[1]="SILENT" ; Lauched on silent mode
	Call ("Compile")
	;param 1 = SILENT / param 2 = Source / param 3 = Dest /param 4 = Icon / param 5 = Stamp to modify
	Exit
EndIf

Dim $CtrlID,$CtrlStatus,$MassComp,$DistComp,$CompileSelec,$SrceSelec,$TrgtSelec,$IconSelec,$Button_Cancel,$Button_Quit,$Button_Valid,$CompilerVer,$Text
Dim $Button_Browse1B,$Button_Browse2,$Button_Browse3,$Button_Browse4,$Input_1,$Input_1B,$Input_2,$Input_3,$Input_4
Dim $CheckMassComp,$CheckDistComp,$CheckAccess,$CheckCreate,$CheckModif,$CheckRestamp,$Label_1,$Label_1B,$Label_2,$Label_3,$Label_4,$Label_5
Dim $MassComp,$DistComp,$Restamp,$Srce,$Dest,$Icon,$ModifStamp,$CreatStamp,$AccesStamp,$IconStamp,$Count,$FileSearch,$FileNext,$SrceSelect,$search
Dim $SrcPath,$SrcFile,$DestPath,$Destfile,$SrcIco,$FileName,$Flag,$Save,$StatusBar,$time

$Compiler=RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AutoIt3Script\Shell\Compile\Command","")
$Compiler=StringSplit($Compiler,' /',1)
$CompilerVer=FileGetVersion ( $Compiler[1])
$FileType="Au3 Files (*.au3)"
$ModifStamp=""
$CreatStamp=""
$AccesStamp=""
$IconStamp=""
$StampOpt=""
Local $StatusBarSize[3] = [90, 420, -1]
Local $StatusBarText[3] = ["Working...", "Reading line : ", "Writing Line :"]
#endregion Variables Decl
#region Compatibility & Presence Test
If _Singleton(@ScriptName,1) = 0 Then ; Call the test function which check if an other occurence of this program is already running
	MsgBox(48,$Title & " - WARNING !!!", "Application " & @ScriptName & " is already running... !",5); If Yes error message is returned and Exit
	If WinGetState(@ScriptName) = 16 Then
		WinSetState(@ScriptName,"",@SW_RESTORE )
	Else
		WinActivate(@ScriptName)
	EndIf
	Exit
Else
	Opt("TrayIconHide", 0)
EndIf

Switch @OSVersion ; Test if Operating System is at required level
	Case "WIN_2003" Or "WIN_XP"
		$OSValid = "OK"
	Case "WIN_2000" Or "WIN_NT4" Or "WIN_ME" Or "WIN_98" Or "WIN_95"
		$OSValid = "?"
		$msg = "Operating System may not support this software or some of its features." & @LF & "Using it is under your full responsability."
		MsgBox(64+262144,$Title & " - Advertisement !!!",$msg,3)
	Case "WIN_6.0" Or "WIN_6.1"
		$OSValid = "NO"
		$msg = $Title & " is not supported by the current operating system."
		MsgBox(16,$Title & " - Error !!!",$msg,3)
		Exit
EndSwitch
Call ("MainGui")

#endregion Compatibility & Presence Test
#region MainGUI
Func MainGUI()
	$Left=10
	$Top=10
	$Heigh = 20 
	$HeighValidBut = 30
	$Width = 380
	$WithBrowseBut = 50
	$WithValidBut = 90
	$GuiWidth = 550
	$GuiHeigh = 450
	$MainGui=GuiCreate("COmpiler And STamper", $GuiWidth, $GuiHeigh,-1, -1)
	GUISetBkColor (0xE0E0FF)
	GUISetOnEvent($GUI_EVENT_CLOSE,"DelGui")
	$FileMenu= GuiCtrlCreateMenu("&File")
	$FileExitItem = GUICtrlCreateMenuitem ("E&xit",$FileMenu)
	GUICtrlSetOnEvent($FileExitItem, "DelGui")
	$Label_1 = GuiCtrlCreateLabel("Choose the Compilation mode you want to use :", $Left,$Top, $Width, $Heigh)
	$Top=$Top+15
		$CheckMassComp=GUICtrlCreateCheckbox("Mass Compilation",$Left,$Top)
		GUICtrlSetTip(-1,"Compile all <.Au3> scripts from a given directory",GUICtrlRead($CheckMassComp,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
		$Top=$Top+20
		$CheckDistComp=GUICtrlCreateCheckbox("Distinct/Multiple Compilation",$Left,$Top)
		GUICtrlSetTip(-1,"Compile one or several <.Au3> scripts from a given directory",GUICtrlRead($CheckDistComp,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
	$Top=$Top+20	
		$CheckRestamp=GUICtrlCreateCheckbox("Restamp files",$Left,$Top)
		GUICtrlSetTip(-1,"Restamp files only",GUICtrlRead($CheckRestamp,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
		$Top=$Top+30
	$Label_1B = GuiCtrlCreateLabel("Compiler (v-" & $CompilerVer & ")", $Left,$Top, $Width, $Heigh)
		GUICtrlSetTip(-1,"Default compiler is pre-selected, but it's possible to change it",GUICtrlRead($Label_1B),1)
		$Top=$Top+15
		$Input_1B = GuiCtrlCreateInput($Compiler[1], $Left, $Top, $Width, $Heigh)
		GUICtrlSetState(-1,$GUI_DISABLE)
		$Button_Browse1B = GuiCtrlCreateButton("Change", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
		GUICtrlSetTip(-1,"Click here to modify the compiler",GUICtrlRead($Button_Browse1B,1) & " compiler",1)
		GUICtrlSetOnEvent(-1, "Browse")
		$Top=$Top+30
	$Label_2 = GuiCtrlCreateLabel("Source", $Left,$Top, $Width, $Heigh)
		GUICtrlSetTip(-1,"Indicate here the source folder/file files (depending the choosen compilation mode)",GUICtrlRead($Label_2),1)
		$Top=$Top+15
		$Input_2 = GuiCtrlCreateInput("", $Left, $Top, $Width, $Heigh)
		$Button_Browse2 = GuiCtrlCreateButton("Browse", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
		GUICtrlSetTip(-1,"Choose a compilation mode first",GUICtrlRead($Button_Browse2,1) & " source",1)
		GUICtrlSetOnEvent(-1, "Browse")
		$Top=$Top+30
	$Label_3 = GuiCtrlCreateLabel("Target", $Left,$Top, $Width, $Heigh)
		$Text = "- If not indicated then source is used to create the target (All modes)" & @LF & _
		"- Mass/Multiple compilation -> target can only be a folder, <.Au3> names are used to build <.Exe> names" & @LF & _
		"- Single file complitation -> if indicated, the <.Exe> name is used."
		GUICtrlSetTip(-1,$Text,GUICtrlRead($Label_3),1)
		$Top=$Top+15
		$Input_3 = GuiCtrlCreateInput("", $Left, $Top, $Width, $Heigh)
		GUICtrlSetState(-1,$GUI_DISABLE)
		$Button_Browse3 = GuiCtrlCreateButton("Browse", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
		GUICtrlSetTip(-1,"Choose a compilation mode first",GUICtrlRead($Button_Browse3,1) & " target",1)
		GUICtrlSetOnEvent(-1, "Browse")
		$Top=$Top+30
	$Label_4 = GuiCtrlCreateLabel("Icon", $Left,$Top, $Width, $Heigh)
		$Text = "- If not indicated then source is used to create the target (All modes)" & @LF & _
		"- Single mode -> If indicated then the <.ico> name will be used for <.Exe> file." & @LF & _
		"- Multiple/Mass modes -> If indicated the <.ico> name will be used for all <.Exe> files."
		GUICtrlSetTip(-1,$Text,GUICtrlRead($Label_4),1)
		$Top=$Top+15
		$Input_4 = GuiCtrlCreateInput("", $Left, $Top, $Width, $Heigh)
		$Button_Browse4 = GuiCtrlCreateButton("Browse", $Left+$Width+$Heigh, $Top, $WithBrowseBut, $Heigh)
		GUICtrlSetTip(-1,"Choose a compilation mode first",GUICtrlRead($Button_Browse4,1) & " Icon",1)
		GUICtrlSetOnEvent(-1, "Browse")
		$Top=$Top+30
	$Label_5 = GuiCtrlCreateLabel("Customize filestamp(s) :", $Left,$Top, $Width, $Heigh)
	$Top=$Top+20
		$CheckModif=GUICtrlCreateCheckbox("Modified",$Left,$Top,55,20)
		GUICtrlSetTip(-1,"Reset filestamp to :" & @LF & "YYYY = Act Year" & @LF & "MM = Act Month" & @LF & "DD = Act Day" & @LF & "01:01:01 = Hours/Mins/Secs",GUICtrlRead($CheckModif,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
		$CheckCreate=GUICtrlCreateCheckbox("Created",$Left+70,$Top,-1,20)
		GUICtrlSetTip(-1,"Reset filestamp to :" & @LF & "YYYY = Act Year" & @LF & "MM = Act Month" & @LF & "DD = Act Month" & @LF & "00:00:00 = Hours/Mins/Secs",GUICtrlRead($CheckCreate,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
		$CheckAccess=GUICtrlCreateCheckbox("Accessed",$Left+130,$Top,-1,20)
		GUICtrlSetTip(-1,"Reset filestamp to :" & @LF & "YYYY = Act Year" & @LF & "MM = Act Month" & @LF & "DD = Act Day" & @LF & "00:00:00 = Hours/Mins/Secs",GUICtrlRead($CheckAccess,1),1)
		GUICtrlSetOnEvent(-1, "CheckState")
		$Button_Valid=GUICtrlCreateButton("Validate",$Left+100,$GuiHeigh-90,80,30)
		GUICtrlSetTip(-1,"Validate all inputs",GUICtrlRead($Button_Valid),1)
		GUICtrlSetOnEvent(-1, "Validate")
		$Button_Cancel=GUICtrlCreateButton("Cancel",$Left+200,$GuiHeigh-90,80,30)
		GUICtrlSetTip(-1,"Cancel all inputs",GUICtrlRead($Button_Cancel),1)
		GUICtrlSetOnEvent(-1, "Cancel")
		$Button_Quit=GUICtrlCreateButton("Exit",$Left+300,$GuiHeigh-90,80,30)
		GUICtrlSetTip(-1,"Exit the GUI and close the program",GUICtrlRead($Button_Quit),1)
		GUICtrlSetOnEvent(-1, "DelGui")
		$StatusBar=_GUICtrlStatusBarCreate($MainGui,$StatusBarSize,$StatusBarText)
		_GUICtrlStatusBarSetIcon($StatusBar, 0, "shell32.dll", 21)
		_GUICtrlStatusBarSetSimple($StatusBar,True)
		_GUICtrlStatusBarSetText ($StatusBar, "Ready",255)
GUISetState()
EndFunc
#endregion MainGUI

#region Loop
While 1
WEnd
#endregion Loop

#region Shared Functions
Func CheckState ()
	If @GUI_CtrlId= $CheckRestamp And BitAND (GUICtrlRead($CheckRestamp),$GUI_CHECKED) = $GUI_CHECKED Then
		Call ("Cancel")
		$MassComp="0"
		$DistComp="0"
		$Restamp="1"
		GUICtrlSetState(@GUI_CtrlId,$GUI_CHECKED)
		GUICtrlSetTip($Button_Browse2,"Click to browse and choose one" & @LF & "or more <.Exe> file(s) to restamp",GUICtrlRead($Button_Browse2,1) & " for Restamp",1)
		GUICtrlSetState($CheckDistComp,$GUI_UNCHECKED)
		GUICtrlSetState($CheckMassComp,$GUI_UNCHECKED)
		GUICtrlSetState($CheckMassComp,$GUI_DISABLE)
		GUICtrlSetState($CheckDistComp,$GUI_DISABLE)
		GUICtrlSetState($Input_1B,$GUI_DISABLE)
		GUICtrlSetState($Button_Browse1B,$GUI_DISABLE)
		GUICtrlSetState($Button_Browse3,$GUI_DISABLE)
		GUICtrlSetState($Input_4,$GUI_DISABLE)
		GUICtrlSetState($Button_Browse4,$GUI_DISABLE)
	ElseIf @GUI_CtrlId=$CheckRestamp And BitAND(GUICtrlRead($CheckRestamp), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		Call ("Cancel")
		Return
	EndIf
	
	If @GUI_CtrlId= $CheckMassComp And BitAND (GUICtrlRead($CheckMassComp),$GUI_CHECKED) = $GUI_CHECKED Then
		Call ("Cancel")
		$MassComp="1"
		$DistComp="0"
		$Restamp="0"
		GUICtrlSetState(@GUI_CtrlId,$GUI_CHECKED)
		GUICtrlSetData($Label_2,"Source... (no file selection allowed)")
		GUICtrlSetState($Input_2,$GUI_DISABLE)
		GUICtrlSetData($Label_3,"Target... (no file selection allowed)")
		GUICtrlSetData($Label_4,"Icon... (Blank or Icon name)")
		GUICtrlSetTip($Button_Browse2,"Click to browse the directory" & @LF & "where <.Au3> files are located.",GUICtrlRead($Button_Browse2,1) & " Source",1)
		GUICtrlSetTip($Button_Browse3,"Click to browse the directory" & @LF & "where <.Exe> files will be located.",GUICtrlRead($Button_Browse3,1) & " Target",1)
		GUICtrlSetTip($Button_Browse4,"Click to browse and choose an icon",GUICtrlRead($Button_Browse4,1) & " Icon",1)
		GUICtrlSetState($CheckDistComp,$GUI_UNCHECKED)
		If GUICtrlRead($Input_2)<> "" Then GUICtrlSetData($Input_2,"");Reset of the source input
		If GUICtrlRead($Input_3)<> "" Then GUICtrlSetData($Input_3,"");Reset of the target input
		If GUICtrlRead($Input_4)<> "" Then GUICtrlSetData($Input_4,"");Reset of the icon input
	ElseIf @GUI_CtrlId=$CheckMassComp And BitAND(GUICtrlRead($CheckMassComp), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		Call ("Cancel")
		$MassComp="0"
	EndIf

	If @GUI_CtrlId=$CheckDistComp And BitAND(GUICtrlRead($CheckDistComp), $GUI_CHECKED) = $GUI_CHECKED Then
		Call ("Cancel")
		$DistComp="1"
		$MassComp="0"
		$Restamp="0"
		GUICtrlSetState(@GUI_CtrlId,$GUI_CHECKED)
		GUICtrlSetData($Label_2,"Source... (file selection allowed)")
		GUICtrlSetState($Input_2,$GUI_ENABLE)
		GUICtrlSetData($Label_3,"Target... (no file selection allowed)")
		GUICtrlSetData($Label_4,"Icon... (Blank or Icon name)")
		GUICtrlSetState($CheckMassComp,$GUI_UNCHECKED)
		GUICtrlSetTip($Button_Browse2,"Click to browse and choose one" & @LF & "or more <.Au3> file(s) to compile",GUICtrlRead($Button_Browse2,1) & " Source",1)
		GUICtrlSetTip($Button_Browse3,"Click to choose the directory" & @LF & "where <.Exe> file(s) will be located.",GUICtrlRead($Button_Browse3,1) & " Target",1)
		GUICtrlSetTip($Button_Browse4,"Click to browse and choose an icon",GUICtrlRead($Button_Browse4,1) & " Icon",1)
		If GUICtrlRead($Input_2)<> "" Then GUICtrlSetData($Input_2,"");Reset of the source input
		If GUICtrlRead($Input_3)<> "" Then GUICtrlSetData($Input_3,"");Reset of the target input
		If GUICtrlRead($Input_4)<> "" Then GUICtrlSetData($Input_4,"");Reset of the icon input
	ElseIf @GUI_CtrlId=$CheckDistComp And BitAND(GUICtrlRead($CheckDistComp), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		Call ("Cancel")
		$DistComp="0"
	EndIf
	
	If BitAND(GUICtrlRead($CheckMassComp), $GUI_UNCHECKED) = $GUI_UNCHECKED And BitAND(GUICtrlRead($CheckDistComp), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		GUICtrlSetState($CheckRestamp,$GUI_ENABLE)
	Elseif BitAND(GUICtrlRead($CheckMassComp), $GUI_CHECKED) = $GUI_CHECKED Or BitAND(GUICtrlRead($CheckDistComp), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($CheckRestamp,$GUI_DISABLE)
		GUICtrlSetState($CheckRestamp,$GUI_UNCHECKED)
	EndIf
	
	If @GUI_CtrlId= $CheckModif And BitAND(GUICtrlRead($CheckModif), $GUI_CHECKED) = $GUI_CHECKED Then
		$ModifStamp="1"
	ElseIf @GUI_CtrlId=$CheckModif And BitAND(GUICtrlRead($CheckModif), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$ModifStamp="0"
	EndIf
	
	If @GUI_CtrlId= $CheckCreate And BitAND(GUICtrlRead($CheckCreate), $GUI_CHECKED) = $GUI_CHECKED Then
		$CreatStamp="1"
	ElseIf @GUI_CtrlId=$CheckCreate And BitAND(GUICtrlRead($CheckCreate), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$CreatStamp="0"
	EndIf
	
	If @GUI_CtrlId= $CheckAccess And BitAND(GUICtrlRead($CheckAccess), $GUI_CHECKED) = $GUI_CHECKED Then
		$AccesStamp="1"
	ElseIf @GUI_CtrlId=$CheckAccess And BitAND(GUICtrlRead($CheckAccess), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$AccesStamp="0"		
	EndIf
EndFunc

Func Browse()
	Local $LastScriptDir,$LastExeDir,$LastIconDir,$Pos
	;Read Registry Keys to try to get the last folders explored.
	$LastScriptDir=RegRead("HKEY_CURRENT_USER\Software\COAST","LastScriptDir" )
	If $LastScriptDir="" Then $LastScriptDir="::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	$LastExeDir=RegRead("HKEY_CURRENT_USER\Software\COAST","LastExeDir")
	If $LastExeDir="" Then $LastExeDir="::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	$LastIconDir=RegRead("HKEY_CURRENT_USER\Software\COAST","LastIconDir")
	If $LastIconDir="" Then $LastIconDir="::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
	
	
	If @GUI_CtrlId=$Button_Cancel Then
		GUICtrlSetState($CheckMassComp,$GUI_UNCHECKED)
		GUICtrlSetState($CheckDistComp,$GUI_UNCHECKED)		
		GUICtrlSetData($Label_2,"Source")
		GUICtrlSetState($Input_2,$GUI_ENABLE)
		GUICtrlSetData($Label_3,"Target")
		If GUICtrlRead($Input_2)<> "" Then GUICtrlSetData($Input_2,"");Reset of the source input
		If GUICtrlRead($Input_3)<> "" Then GUICtrlSetData($Input_3,"");Reset of the target input
		If GUICtrlRead($Input_4)<> "" Then GUICtrlSetData($Input_4,"");Reset of the icon input
	EndIf
	If @GUI_CtrlId=$Button_Quit Then
		Guidelete(@GUI_WinHandle)
		Exit
	EndIf
	
	If @GUI_CtrlId=$Button_Browse1B Then
		$CompileSelec=FileOpenDialog ( "Select the AUT2EXE.exe you want to use :",GuiCtrlread($Input_1B), "Aut2exe (*.*)" , 1, "")
		If $CompileSelec <> "" Then GUICtrlSetData($Input_1B,$CompileSelec)
	EndIf
	
	If $MassComp=1 Then
		Switch @GUI_CtrlId
			Case $Button_Browse2
				$SrceSelec=FileSelectFolder ( "Select the source directory :", "" , 1+2, $LastScriptDir)
				If $SrceSelec <> "" Then
					GUICtrlSetData($Input_2,$SrceSelec)
					RegWrite("HKEY_CURRENT_USER\Software\COAST","LastScriptDir" ,"REG_SZ",$SrceSelec)
				Else
					GUICtrlSetData($Input_2,"")
				EndIf
			Case $Button_Browse3
				$TrgtSelec=FileSelectFolder ( "Select the destination directory :", "" , 1+2, $LastExeDir)
				If $TrgtSelec <> "" Then
					GUICtrlSetData($Input_3,$TrgtSelec)
					RegWrite("HKEY_CURRENT_USER\Software\COAST","LastExeDir" ,"REG_SZ",$TrgtSelec)
				Else
					GUICtrlSetData($Input_3,"")
				EndIf
			Case $Button_Browse4
				$IconSelec=FileOpenDialog ( "Select an icon",$LastIconDir, "icon files (*.ico)" , 1, "")
				If $IconSelec <> "" Then
					GUICtrlSetData($Input_4,$IconSelec)
					RegWrite("HKEY_CURRENT_USER\Software\COAST","LastIconDir" ,"REG_SZ",$IconSelec)
				Else
					GUICtrlSetData($Input_4,"")
				EndIf
		EndSwitch
	EndIf
		
	If $DistComp =1 Then
		Switch @GUI_CtrlId
			
			Case $Button_Browse2
				$SrceSelec=FileOpenDialog ( "Select the source file(s)",$LastScriptDir, $FileType , 4, "")
				If $SrceSelec <> "" Then
					GUICtrlSetData($Input_2,$SrceSelec)
					$Pos=StringSplit($SrceSelec,"|",1)
					If $Pos[0] = 1 Then ; Single choice done 
						RegWrite("HKEY_CURRENT_USER\Software\COAST","LastScriptDir" ,"REG_SZ",Stringleft($Pos[1],StringInStr($Pos[1],"\",0,-1)-1))
					Else ; Mutliple choice done
						RegWrite("HKEY_CURRENT_USER\Software\COAST","LastScriptDir" ,"REG_SZ",$Pos[1])
					EndIf
				Else
					GUICtrlSetData($Input_2,"")
				EndIf
				
			Case $Button_Browse3
				$TrgtSelec=FileSelectFolder ( "Select the destination directory :","", 1+2, $LastExeDir)
				If $TrgtSelec <> "" Then
					GUICtrlSetData($Input_3,$TrgtSelec)
					RegWrite("HKEY_CURRENT_USER\Software\COAST","LastExeDir" ,"REG_SZ",$TrgtSelec)
				Else
					GUICtrlSetData($Input_3,"")
				EndIf
				
			Case $Button_Browse4
				$IconSelec=FileOpenDialog ( "Select an icon",$LastIconDir, "icon files (*.ico)" , 1, "")
				If $IconSelec <> "" Then
					GUICtrlSetData($Input_4,$IconSelec)
					RegWrite("HKEY_CURRENT_USER\Software\COAST","LastIconDir" ,"REG_SZ",$IconSelec)
				Else
					GUICtrlSetData($Input_4,"")
				EndIf
				
		EndSwitch
	EndIf
	
	If @GUI_CtrlId=$Button_Browse2 And BitAND (GUICtrlRead($CheckRestamp),$GUI_CHECKED) = $GUI_CHECKED Then ; only when restamp option is selected
		$SrceSelec=FileOpenDialog ( "Select the source file(s)","::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "Exe Files (*.exe)" , 1+2, "")
		GUICtrlSetData($Input_2,$SrceSelec)
	EndIf
	
EndFunc	

Func Validate()
	_GUICtrlStatusBarSetSimple($StatusBar, False)
	_GUICtrlStatusBarSetText ($StatusBar, "Working...", 0)
	_GUICtrlStatusBarSetText ($StatusBar, "Validating data, please wait...", 1)
	_GUICtrlStatusBarSetText ($StatusBar, "", 2)
	If GUICtrlRead($CheckMassComp,$GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$MassComp="0"
	ElseIf GUICtrlRead($CheckMassComp,$GUI_CHECKED) = $GUI_CHECKED Then
		$MassComp="1"
	EndIf
	If GUICtrlRead($CheckDistComp, $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		$DistComp="0"
	ElseIf GUICtrlRead($CheckDistComp, $GUI_CHECKED) = $GUI_CHECKED Then
		$DistComp="1"
	EndIf
	If $ModifStamp="" Then $ModifStamp="0"
	If $CreatStamp="" Then $CreatStamp="0"
	If $AccesStamp="" Then $AccesStamp="0"
	If $IconStamp="" Then $IconStamp="0"
	If $Restamp="" Then $Restamp="0"
	$Icon=GUICtrlRead($Input_4)
	$StampOpt=$ModifStamp&$CreatStamp&$AccesStamp
	$Srce=$SrceSelec

	;=========== Preprare source data for compile loop
	If $DistComp=1 then ; Test if user choice is to do distinct compile (only one or several files)
		$Count=StringSplit($Srce,"|",1)
	ElseIf $MassComp =1 Then ; Mass compile has been selected.
		$FileSearch=FileFindFirstFile($Srce & "\*.au3")
		If $search = -1 Then
			MsgBox(64, "Error !", "No files/directories matched the search pattern")
			Return
		EndIf
		
		While 1 ; Get the name of all ".au3" files
			$FileNext=FileFindNextFile($FileSearch)
			If @error =1 Then
				ExitLoop ; Last file found
			Else
				$Srce=$Srce & "|" & $FileNext   ; Build the source until end of list
			EndIf
		WEnd
		FileClose($FileSearch)
		$Count=StringSplit($Srce,"|",1)
	EndIf
	
	If $Restamp=1 Then ; Stamp files only
		$Dest=Guictrlread($Input_2)
		Call ("Restamp")
		Call ("Cancel")
	Else ; compile and stamp if needed
		Call ("Compile")
	EndIf
EndFunc

Func Cancel()
	;Reset all crontrol contents
	GUICtrlSetData($Input_1B,$Compiler[1])
	GUICtrlSetData($Input_2,"")
	GUICtrlSetData($Input_3,"")
	GUICtrlSetData($Input_4,"")
	;Reset all control Labels
	GUICtrlSetState($CheckDistComp,$GUI_ENABLE)
	GUICtrlSetState($CheckMassComp,$GUI_ENABLE)
	GUICtrlSetState($CheckRestamp,$GUI_ENABLE)
	GUICtrlSetState($Input_1B,$GUI_DISABLE)
	GUICtrlSetState($Button_Browse1B,$GUI_ENABLE)
	GUICtrlSetData($Label_2,"Source")
	GUICtrlSetState($Input_2,$GUI_ENABLE)
	GUICtrlSetData($Label_3,"Target")
	GUICtrlSetState($Button_Browse3,$GUI_ENABLE)
	GUICtrlSetData($Label_4,"Icon")
	GUICtrlSetState($Input_4,$GUI_ENABLE)
	GUICtrlSetState($Button_Browse4,$GUI_ENABLE)
	GUICtrlSetState($CheckMassComp,$GUI_UNCHECKED)
	GUICtrlSetState($CheckDistComp,$GUI_UNCHECKED)
	GUICtrlSetState($CheckRestamp,$GUI_UNCHECKED)
	GUICtrlSetState($CheckModif,$GUI_UNCHECKED)
	GUICtrlSetState($CheckCreate,$GUI_UNCHECKED)
	GUICtrlSetState($CheckAccess,$GUI_UNCHECKED)
	;Reset Tips
	GUICtrlSetTip($Button_Browse2,"Choose a compilation mode first",GUICtrlRead($Button_Browse2,1) & " Source",1)
	GUICtrlSetTip($Button_Browse3,"Choose a compilation mode first",GUICtrlRead($Button_Browse3,1) & " Targer",1)
	GUICtrlSetTip($Button_Browse4,"Choose a compilation mode first",GUICtrlRead($Button_Browse4,1) & " Icon",1)
	;Reset all variables
	$MassComp=""
	$DistComp=""
	$Restamp=""
	$ModifStamp=""
	$CreatStamp=""
	$AccesStamp=""
	$IconStamp=""
	$Srce=""
	$Dest=""
	$Icon=""
	$StampOpt=""
	_GUICtrlStatusBarSetSimple($StatusBar,True)
	_GUICtrlStatusBarSetText ($StatusBar, "Ready",255)
EndFunc

Func DelGui()
	Guidelete(@GUI_WinHandle)
	Exit
EndFunc

#endregion MainGUI Functions
#region Compile

Func Compile()
	Local $Filecounter
	If $Cmdline[0]=0 Then  ; if programm called in silent mode
		If $Count[0] = 1 Then ; Only one file selected
		$CountStart=1
		$FileToCompile=1
			Elseif $Count[0] > 1 Then; Multiple files selected/found
		$CountStart=2
		$FileToCompile=$Count[0]-1
		EndIf
		$FileCounter=0
		;================== COMPILING LOOP =====================================
		For $i = $CountStart To $Count[0]
			
			If $Count[0] > 1 Then ; Multiple files selected
				;===== SOURCE REBUILD ========
				$SrcPath=$Count[1] & "\"
				$FileName=StringSplit($Count[$i],".au3",1)
				$SrcFile = $Filename[1] & ".au3"
				$Src = $SrcPath & $SrcFile ; Fullpath for Source
				;====== DESTINATION BUILD ===
				If GUICtrlRead($Input_3) = "" Then
					$DestPath=$SrcPath ; Same path for destination
				Else
					$DestPath=GUICtrlRead($Input_3) & "\"
				EndIf
				$Destfile=$Filename[1] & ".exe" ; Final ".exe" name
				$Dest=$DestPath & $Destfile ; Fullpath for Destination
				;====== ICON SOURCE ==========
				If GUICtrlRead($Input_4)="" Then 
					If FileExists($SrcPath & $FileName[1]&".ico") Then
						$SrcIco= $SrcPath & $FileName[1]&".ico" ; Full path to ico if not indidcated in the input box but existing in the source directory
					Else
						$SrcIco="" ; default Autoit icon will be used
					EndIf
				Else
					$SrcIco=GUICtrlRead($Input_4); Full path to ico if indicated in the input box
				EndIf
			ElseIf $Count[0]=1 Then
				;===== SOURCE REBUILD ========
				$SrcPath = Stringleft($Srce,StringInStr($Srce,"\",0,-1)) ; Path to source filename (with trailing back slash)
				$FileName=StringSplit($Srce,"\",1)
				$FileName=StringSplit($FileName[$FileName[0]],".au3",1)
				$FileName=$FileName[1] ; Source script name (without extension)
				$SrcFile = $Filename & ".au3"
				$Src = $SrcPath & $SrcFile ; Fullpath for Source
				;====== DESTINATION BUILD ===
				If GUICtrlRead($Input_3) = "" Then 
					$DestPath=$SrcPath ; Same path for destination
				Else
					$DestPath=GUICtrlRead($Input_3) & "\"
				EndIf
				$Destfile=$Filename & ".exe" ; Final ".exe" name
				$Dest=$DestPath & $Destfile ; Fullpath for Destination
				;====== ICON SOURCE ==========
				If GUICtrlRead($Input_4) = "" Then
					If FileExists($SrcPath & $FileName&".ico") Then
						$SrcIco= $SrcPath & $FileName&".ico" ; Full path to ico if not indidcated in the input box but existing in the source directory
					Else
						$SrcIco="" ; default Autoit icon will be used
					EndIf
				Else
					$SrcIco=GUICtrlRead($Input_4); Full path to ico if indicated in the input box
				EndIf
			EndIf
			;========= BACKUP PREVIOUS VERSION IF EXISTING ===================================
			If FileExists($Dest) Then 
				$Save=$Dest & ".old" ; Give a new name
				FileCopy ($Dest,$Save,1) ; Backup previous version of the Exe
				FileDelete($Dest) ; Deletes previous version of the Exe file
			EndIf
			;==================================================================================
			$FileCounter = $FileCounter+1
			_GUICtrlStatusBarSetText ($StatusBar, "Compiling...", 0)
			_GUICtrlStatusBarSetText ($StatusBar, "From : " & $SrcPath & $SrcFile & "   To : " & $DestPath & $Destfile, 1)
			_GUICtrlStatusBarSetText ($StatusBar, "File " & $FileCounter & " of " & $FileToCompile, 2)
			
			If Not FileExists($SrcIco) then ; Icon not found
				RunWait($Compiler[1] & ' /in ' &'"'&$Src&'"' & ' /out ' & '"'&$Dest&'"' & ' /comp 4')
				Call("Restamp")
				Call ("ChkFlag",$Flag)
			Else ; Icon found
				RunWait($Compiler[1] & ' /in ' &'"'&$Src&'"' & ' /out ' & '"'& $Dest &'"' & ' /icon ' & '"' & $SrcIco & '"' & ' /comp 4')
				Call ("Restamp")
				Call ("ChkFlag",$Flag)
			EndIf
		Next
		_GUICtrlStatusBarSetText ($StatusBar, "Done.", 0)
		_GUICtrlStatusBarSetText ($StatusBar, "Final compiled scipts : " & $FileCounter & " of " & $FileToCompile, 1)
		_GUICtrlStatusBarSetText ($StatusBar, "", 2)
		Sleep(2000)
		Call("Cancel") ; Back to start GUI
	;===================== SILENT MODE START =======================================
	;$Cmdline[1]= Silent flag(allways set at "SILENT")
	;$Cmdline[2]=Source full path
	;$Cmdline[3]=Destination full path
	;$Cmdline[4]=Icon full path
	;$Cmdline[5]=Stamp flag (0=Modified 1=Created 2=Accessed)
	ElseIf $Cmdline[1]="SILENT"
		If StringRight($Cmdline[2],4)=".au3" Then ;check if it's a compilation and restamp
			;=============== BACKUP ========================
			If FileExists($Cmdline[3]) Then 
				$Save=$Cmdline[3] & ".old" ; Give a new name
				FileCopy ($Cmdline[3],$Save,1) ; Backup previous version of the Exe
				FileDelete($Cmdline[3]) ; Deletes previous version of the Exe file
			EndIf
			;=============== COMPILE & RESTAMP =======================
			If Not FileExists($Cmdline[4]) then ; Icon not found
				RunWait($Compiler[1] & ' /in ' &'"'& $Cmdline[2] &'"' & ' /out ' & '"'&$Cmdline[3]&'"' & ' /comp 4')
			Else ; Icon found
				RunWait($Compiler[1] & ' /in ' &'"'& $Cmdline[2] &'"' & ' /out ' & '"'& $Cmdline[3] &'"' & ' /icon ' & '"' & $Cmdline[4] & '"' & ' /comp 4')
			EndIf
			
			If $Cmdline[5]="0" or $Cmdline[5]="1" Then ; Restamp sarts here
				$time="000000"
				If $Cmdline[5]="0" Then FileSetTime ( $Dest,@YEAR & @MON & @MDAY & $time, $i)
				If $Cmdline[5]="1" Then FileSetTime ( $Dest,@YEAR & @MON & @MON & $time, $i)
			ElseIf $Cmdline[5]="2" Then
				$time=""
				FileSetTime ( $Cmdline[2],@YEAR & @MON & @MDAY & $time, $i)
			EndIf ; Restamp ends here
			Sleep (250)
			FileDelete($Save) ; delete backup if existing
			;=============== RETSAMP ONLY =======================
		Elseif StringRight($Cmdline[2],4)=".exe" Then; or if it's only a restamp
			If $Cmdline[5] <> "2" Then 
				$time="000000"
				If $Cmdline[5]="0" or $Cmdline[5]= "" Then FileSetTime ( $Dest,@YEAR & @MON & @MDAY & $time, $i)
				If $Cmdline[5]="1" Then FileSetTime ( $Dest,@YEAR & @MON & @MON & $time, $i)
			ElseIf $Cmdline[5]="2" Then
				$time=""
				FileSetTime ( $Cmdline[2],@YEAR & @MON & @MDAY & $time, $i)
			EndIf
			Sleep (250)
		EndIf
		Return ; returns to top of code (firtst test)
	;===================== SILENT MODE STOP =========================================
	EndIf
EndFunc

Func Restamp ()
	Local $CounterMin,$CounterMax,$Step
	If $StampOpt = "000" Then ; No stamp to moidify => Exit function using Return
		$Flag="OK"
	Else
		If $StampOpt = "001" Then ; Only Accessed stamp is modified => counter =3 to 3
			$CounterMin=3
			$CounterMax=3
			$Step=1
		EndIf
		
		If $StampOpt = "010" Then ; Only Created stamp is modified => counter = 1 to 1
			$CounterMin=1
			$CounterMax=1
			$Step=1
		EndIf
		
		If $StampOpt = "100" Then ; Only Modified stamp is modified => counter = 0 to 0
			$CounterMin=0
			$CounterMax=0
			$Step=1
		EndIf
		
		If $StampOpt = "110" Then ; Only Modified and cretaed stamps are modified => counter = 0 to 1
			$CounterMin=0
			$CounterMax=1
			$Step=1
		EndIf
		
		If $StampOpt = "111" then ; All stamps are modified => counter=0 to 2
			$CounterMin=0
			$CounterMax=2
			$Step=1
		EndIf
		
		If $StampOpt = "101" Then ; Only Modified and Accessed stamps are modified => counter = 0 to 2 step 2
			$CounterMin=0
			$CounterMax=2
			$Step=2
		EndIf
		
		If $StampOpt = "011" then ; Only Created & Accesses stamps are modified => counter =1 to 2
			$CounterMin=1
			$CounterMax=2
			$Step=1
		EndIf
		_GUICtrlStatusBarSetText ($StatusBar, "Restamping...", 0)
		_GUICtrlStatusBarSetText ($StatusBar, $Dest, 1)
		;_GUICtrlStatusBarSetText ($StatusBar, "", 2)
		
		For $i=$CounterMin to $CounterMax Step $Step ; The timestamp to change: 0 = Modified, 1 = Created, 2 = Accessed
			If $i=0 or $i=1 Then 
				$time="000000"
				If $i=0 Then FileSetTime ( $Dest,@YEAR & @MON & @MDAY & $time, $i)
				If $i=1 Then FileSetTime ( $Dest,@YEAR & @MON & @MON & $time, $i)
			ElseIf $i=2 Then
				$time=""
				FileSetTime ( $Dest,@YEAR & @MON & @MDAY & $time, $i)
			EndIf
			Sleep (250)
		Next
		$Flag = "OK"
	EndIf
	Return $Flag
EndFunc

Func ChkFlag($Flag)
	If $Flag="OK" Then 
		FileDelete($Save) ; Backup file is deleted if process successful
	Else
		$Back=Stringsplit($Save,".old",1)
		$Back=$Back[1]
		FileMove ( $Save, $Back ,1 ) ; Restore previous version if problem occured during process
		MsgBox(16+0+262144," ***** Error during Compilation ***** ","File could not be compiled !!!" & @LF & "If a previous version was existing, it has been restored.")
	EndIf
EndFunc
#endregion Compile
