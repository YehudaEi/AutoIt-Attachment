#include <guiconstants.au3>
#include <Array.au3>
#include <GuiList.au3>
#include <Misc.au3>
#include "WinAnimate.au3"
#include <file.au3>

Fileinstall("C:\Documents and Settings\Neon\Desktop\data\Title.bmp",@ScriptDir & "\data\Title.bmp",1)
Fileinstall("C:\Documents and Settings\Neon\Desktop\data\section_top.bmp",@ScriptDir & "\data\section_top.bmp",1)
Fileinstall("C:\Documents and Settings\Neon\Desktop\data\pt_blank.bmp",@ScriptDir & "\data\pt_blank.bmp",1)

$Title = @ScriptDir & "\data\Title.bmp"
$section_top = @ScriptDir & "\data\section_top.bmp"
$pt_blank = @ScriptDir & "\data\pt_blank.bmp"
Opt("GUIResizeMode", 1)

#NoTrayIcon

Global $Project_Directory = ""

Global $Save_Directory = "Current_Game.jpdat"

$StartWindow = GUICreate("Make Jeopardy! 1.0 Game Runner",300,300)
GUICtrlSetbkColor(-1,0x0000FF)
Guictrlsetcolor(-1, 0xFFFFFF)
$BakPick = GUICtrlCreatePic($Title,0,0,300,300)
GUICtrlSetState(-1,$GUI_DISABLE)

GUICtrlCreateLabel("Open a game or load a saved game.",10,20,280,60)
GUICtrlSetbkColor(-1,0x000000)
Guictrlsetcolor(-1, 0xFFFFFF)
GUICtrlSetFont (-1,12)

$Open_Button = GUICtrlCreateButton("Open Game",75,120,150,22)
$Load_Button = GUICtrlCreateButton("Load Saved Game",75,160,150,22)

GUISetState(@Sw_Show)

While 1
    $msg = GuiGetMsg()
	Select			
	Case $msg = $GUI_EVENT_CLOSE
		WinSetState($StartWindow,"",@SW_DISABLE)
		
		If MsgBox(4,"Are You Sure?","Are you sure you want to exit?") = 6 Then Exit
			
		WinSetState($StartWindow,"",@SW_ENABLE)
		
		WinActivate($StartWindow)
	Case $msg = $Open_Button
		
		WinSetState($StartWindow,"",@SW_DISABLE)
		
		$Open_Project_Path = FileOpenDialog("Open Game.",@ScriptDir & "\","Jeopardy Game (*.jpd)",3)
		If @error = 0 Then
			
			FileChangeDir(@ScriptDir)
			
			If StringInStr($Open_Project_Path,".jpd") = 0 Then $Open_Project_Path = $Open_Project_Path & ".jpd"
			
			$Project_Directory = $Open_Project_Path
			
			Global $Is_Prev_Game = 0
			
			FileDelete($Save_Directory)
			
			GUIDelete($StartWindow)
				
			ExitLoop
		EndIf
		
		WinSetState($StartWindow,"",@SW_ENABLE)
		
		WinActivate($StartWindow)
		
	Case $msg = $Load_Button
		
		WinSetState($StartWindow,"",@SW_DISABLE)
		
		$Open_Project_Path = FileOpenDialog("Open Saved Game.",@ScriptDir & "\","Jeopardy Saved Game (*.jpsav)",3)
		If @error = 0 Then
			
			FileChangeDir(@ScriptDir)
			
			If StringInStr($Open_Project_Path,".jpsav") = 0 Then $Open_Project_Path = $Open_Project_Path & ".jpsav"
			
			$Project_Directory = $Open_Project_Path
			
			$Open_Project = FileOpen($Project_Directory,0)
			
			$Open_Save_File = FileOpen($Save_Directory,2)
			
			While 1
			
				$line = FileReadLine($Open_Project)
                If @error = -1 Then 
					MsgBox(0,"error","Invalid save file.")
					Exit
				EndIf
				
                If StringInStr($line,"#END_GAME") Then ExitLoop
			Wend

			
			While 1
			
				$line = FileReadLine($Open_Project)
                If @error = -1 Then ExitLoop
				
                FileWriteLine($Open_Save_File,$line)
			Wend
			
			Global $Is_Prev_Game = 1
			
			FileClose($Open_Project)
			FileClose($Open_Save_File)
			
			GUIDelete($StartWindow)
				
			ExitLoop
		EndIf
		
		WinSetState($StartWindow,"",@SW_ENABLE)
		
		WinActivate($StartWindow)		
	EndSelect
WEnd

;~  ----------------------Title Screen--------------------------

$Title_Pick = GUICreate("Title",500,350,-1,-1,$WS_POPUP + $WS_BORDER,$WS_EX_TOOLWINDOW)


$BakPick = GUICtrlCreatePic($Title,0,0,500,350)
GUICtrlSetState(-1,$GUI_DISABLE)

GUICtrlCreateLabel("-Game Run- Version 1.0 by Andrew Dunn",10,325,490,30)
GUICtrlSetbkColor(-1,0x000000)
Guictrlsetcolor(-1, 0xFFFFFF)
GUICtrlSetFont (-1,15)

GUISetState(@Sw_Show)
Sleep(3500)

WinRandomAnimation($Title_Pick,0,500)

GUIDelete($Title_Pick)

Global $Amount_Of_Questions = 0

For $i = 1 To 6 Step 1
	$read = IniRead($Project_Directory,"Subjects",$i & "Enable","0")
	
	$Amount_Of_Questions += $read
	
Next

$Amount_Of_Questions = $Amount_Of_Questions * 6

If $Amount_Of_Questions = 0 Then 
	MsgBox(0,"error","No column subjects are enabled. Game play aborted.")
	Exit
EndIf


If $Is_Prev_Game = 0 Then
    IniWrite($Save_Directory,"SaveSettings","Path",$Project_Directory)
    IniWrite($Save_Directory,"SaveSettings","QuestionsTotal",$Amount_Of_Questions)
    IniWrite($Save_Directory,"SaveSettings","QuestionsLeft",$Amount_Of_Questions)


    For $i = 1 To 6 Step 1
	    If IniRead($Project_Directory,"Subjects",$i & "Enable","0") = 1 Then
	        For $ii = 1 To 6 Step 1
		        IniWrite($Save_Directory,"QuestionsEnable",$i & "," & $ii,"1")
		
	        Next
        EndIf
    Next
Else
	$Amount_Of_Questions = IniRead($Save_Directory,"SaveSettings","QuestionsLeft",$Amount_Of_Questions)
EndIf

$Read_All_Teams = IniReadSection($Save_Directory, "PlayersPoints")
If Not @error Then 
    Dim $Team_Names[1]
    $Team_Names[0] = 0
	
	For $i = 1 To $Read_All_Teams[0][0]
		_ArrayAdd ($Team_Names,$Read_All_Teams[$i][0])
		$Team_Names[0] += 1
	Next
Else

;~  ----------------------Team Creator--------------------------

$Team_Win = GUICreate("Create Teams",260,250,-1,-1,)

GUICtrlCreateLabel("Click the ""Add"" button to create as many players or teams as you like.",10,10,240,45)

$PlayerList = GUICtrlCreateList("",10,60,150,150)
$Add_Button = GUICtrlCreateButton("Add",170,112,80,20)
$Del_Button = GUICtrlCreateButton("Delete",170,137,80,20)

$Done_Button = GUICtrlCreateButton("Done",40,220,80,20)
GUICtrlSetState(-1,$GUI_DISABLE)

GUISetState(@Sw_Show)

Dim $Team_Names[1]
$Team_Names[0] = 0

Global $Team_Names_String = ""

While 1
    $msg = GuiGetMsg()
	Select			
	Case $msg = $GUI_EVENT_CLOSE
		WinSetState($Team_Win,"",@SW_DISABLE)
		
		If MsgBox(4,"Are You Sure?","Are you sure you want to exit?") = 6 Then Exit
			
		WinSetState($Team_Win,"",@SW_ENABLE)
		
		WinActivate($Team_Win)
	Case $msg = $Add_Button
		$New_Team_Name = InputBox("Add New Team.","Enter the name of the team/player you want to add.","New Player")
		
		If Not @error Then
			
			If StringStripWS($New_Team_Name,8) = "" Then
				MsgBox(0,"error","You didn't enter anything ...")
			Else
				If IniRead($Save_Directory,"PlayersPoints",$New_Team_Name,"") = "" Then
					IniWrite($Save_Directory,"PlayersPoints",$New_Team_Name,"0")
					_ArrayAdd ($Team_Names,$New_Team_Name)
					GUICtrlSetData($PlayerList,$New_Team_Name,$New_Team_Name)
					
					$Team_Names[0] += 1
					
					If $Team_Names[0] > 0 Then GUICtrlSetState($Done_Button,$GUI_ENABLE)
					
				Else
					MsgBox(0,"error",$New_Team_Name & " already exists.")
				
				EndIf
			EndIf
			
		EndIf
	
	Case $msg = $Del_Button
	
	$Player_Selected = GUICtrlRead($PlayerList)
	If $Player_Selected <> "" Then
		If MsgBox(4,"Delete?","Are you sure you want to delete " & $Player_Selected & "?") = 6 Then
			_GUICtrlListDeleteItem ($PlayerList, _GUICtrlListFindString ($PlayerList, $Player_Selected))
			IniDelete($Save_Directory,"PlayersPoints",$Player_Selected)
			
			$Team_Names[0] -= 1
					
			If $Team_Names[0] < 1 Then GUICtrlSetState($Done_Button,$GUI_DISABLE)
		EndIf
	EndIf
	
    Case $msg = $Done_Button
	    If MsgBox(4,"Continue?","So you're ready to play the game?") = 6 Then 
			GUIDelete($Team_Win)
			ExitLoop
		EndIf
	
	EndSelect
WEnd

EndIf

For $i = 1 To $Team_Names[0] Step 1
	If $i = 1 Then
		$Team_Names_String = $Team_Names[$i]
	Else
		$Team_Names_String = $Team_Names_String & "|" & $Team_Names[$i]
	EndIf
Next


;~ -------------------Read Enabled Sections---------------
$Sect_1_Enable = IniRead($Project_Directory,"Subjects","1Enable","0")
$Sect_2_Enable = IniRead($Project_Directory,"Subjects","2Enable","0")
$Sect_3_Enable = IniRead($Project_Directory,"Subjects","3Enable","0")
$Sect_4_Enable = IniRead($Project_Directory,"Subjects","4Enable","0")
$Sect_5_Enable = IniRead($Project_Directory,"Subjects","5Enable","0")
$Sect_6_Enable = IniRead($Project_Directory,"Subjects","6Enable","0")

$Game_Win = GUICreate("Jeopardy Game Runner - " & IniRead($Project_Directory,"Settings","name","Untitled"),800,700,-1,-1,$WS_MAXIMIZEBOX + $WS_MINIMIZEBOX)

$BakPick = GUICtrlCreatePic($Title,0,0,800,700)
GUICtrlSetState(-1,$GUI_DISABLE)

GUICtrlCreateLabel(IniRead($Project_Directory,"Settings","name","Untitled"),0,25,800,60,$SS_CENTER)
GUICtrlSetbkColor(-1,0x000000)
Guictrlsetcolor(-1, 0xFFFFFF)
GUICtrlSetFont (-1,25)

$Save_Button = GUICtrlCreateButton("Save Current Game",10,2,150,20)

$Scores_Button = GUICtrlCreateButton("Show Current Scores",640,2,150,20)

;~ --------------------------------------------------------------------------------------------------


GUICtrlCreatePic($section_top,13,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_1_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","1Text","(No Text)"),18,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($section_top,144,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_2_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","2Text","(No Text)"),149,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($section_top,275,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_3_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","3Text","(No Text)"),280,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($section_top,406,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_4_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","4Text","(No Text)"),411,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($section_top,537,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_5_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","5Text","(No Text)"),542,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($section_top,668,100,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Secion_6_Title = GUICtrlCreateLabel(@CRLF & IniRead($Project_Directory,"Subjects","6Text","(No Text)"),673,110,100,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,13,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,13,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,13,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,13,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,13,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,13,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,144,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,144,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,144,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,144,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,144,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,144,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,275,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,275,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,275,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,275,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,275,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,275,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,406,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,406,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,406,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,406,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,406,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,406,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,537,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,537,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,537,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,537,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,537,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,537,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

GUICtrlCreatePic($pt_blank,668,180,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,668,260,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)

If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,668,340,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,668,420,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,668,500,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
GUICtrlCreatePic($pt_blank,668,580,118,74)
GUICtrlSetState(-1,$GUI_DISABLE)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_1_Row_1 = GUICtrlCreateLabel(@CRLF & "100",25,190,80,55,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12,-1,4)

If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_1_Row_2 = GUICtrlCreateLabel(@CRLF & "200",25,270,80,50,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetColor(-1,0xFEFE00)
GUICtrlSetBkColor(-1,0x3366FF)
GUICtrlSetFont (-1,12,-1,4)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_1_Row_3 = GUICtrlCreateLabel(@CRLF & "300",18,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_1_Row_4 = GUICtrlCreateLabel(@CRLF & "400",18,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_1_Row_5 = GUICtrlCreateLabel(@CRLF & "500",18,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_1_Row_6 = GUICtrlCreateLabel(@CRLF & "600",18,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_1_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_2_Row_1 = GUICtrlCreateLabel(@CRLF & "100",149,180,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_2_Row_2 = GUICtrlCreateLabel(@CRLF & "200",149,260,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_2_Row_3 = GUICtrlCreateLabel(@CRLF & "300",149,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_2_Row_4 = GUICtrlCreateLabel(@CRLF & "400",149,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_2_Row_5 = GUICtrlCreateLabel(@CRLF & "500",149,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_2_Row_6 = GUICtrlCreateLabel(@CRLF & "600",149,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_2_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_3_Row_1 = GUICtrlCreateLabel(@CRLF & "100",280,180,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_3_Row_2 = GUICtrlCreateLabel(@CRLF & "200",280,260,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_3_Row_3 = GUICtrlCreateLabel(@CRLF & "300",280,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_3_Row_4 = GUICtrlCreateLabel(@CRLF & "400",280,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_3_Row_5 = GUICtrlCreateLabel(@CRLF & "500",280,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_3_Row_6 = GUICtrlCreateLabel(@CRLF & "600",280,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_3_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_4_Row_1 = GUICtrlCreateLabel(@CRLF & "100",411,180,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_4_Row_2 = GUICtrlCreateLabel(@CRLF & "200",411,260,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_4_Row_3 = GUICtrlCreateLabel(@CRLF & "300",411,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_4_Row_4 = GUICtrlCreateLabel(@CRLF & "400",411,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_4_Row_5 = GUICtrlCreateLabel(@CRLF & "500",411,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_4_Row_6 = GUICtrlCreateLabel(@CRLF & "600",411,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_4_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_5_Row_1 = GUICtrlCreateLabel(@CRLF & "100",542,180,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_5_Row_2 = GUICtrlCreateLabel(@CRLF & "200",542,260,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_5_Row_3 = GUICtrlCreateLabel(@CRLF & "300",542,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_5_Row_4 = GUICtrlCreateLabel(@CRLF & "400",542,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_5_Row_5 = GUICtrlCreateLabel(@CRLF & "500",542,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_5_Row_6 = GUICtrlCreateLabel(@CRLF & "600",542,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_5_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

$Col_6_Row_1 = GUICtrlCreateLabel(@CRLF & "100",673,180,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_6_Row_2 = GUICtrlCreateLabel(@CRLF & "200",673,260,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_6_Row_3 = GUICtrlCreateLabel(@CRLF & "300",673,340,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_6_Row_4 = GUICtrlCreateLabel(@CRLF & "400",673,420,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_6_Row_5 = GUICtrlCreateLabel(@CRLF & "500",673,500,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)
$Col_6_Row_6 = GUICtrlCreateLabel(@CRLF & "600",673,580,108,74,$SS_CENTER + $SS_NOTIFY)
GUICtrlSetFont (-1,12,-1,4)
GUICtrlSetColor(-1,0xFEFE00)
If $Sect_6_Enable = 0 Then GUICtrlSetState(-1,$GUI_HIDE)

;~  ---------------Set Button Point Amounts----------------

For $i = 1 to 6 Step 1


	For $ii = 1 to 6 Step 1
		$Read_Quest_Stuff = IniRead($Project_Directory,"Subject" & $i & "Questions",$ii,"")

		If $Read_Quest_Stuff <> "" Then
			$Read_Quest_Stuff = StringSplit($Read_Quest_Stuff,"|")
			
			GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & $Read_Quest_Stuff[1])
		Else
			GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & $ii * 100)
		EndIf

    Next
	
	
Next

;~ ----------------------Disable Answered Questions---------------------

For $i = 1 to 6 Step 1
	
	For $ii = 1 to 6 Step 1
		If IniRead($Save_Directory,"QuestionsEnable",$i & "," & $ii,"1") = 0 Then 
			GUICtrlSetState(Eval("Col_" & $i & "_Row_" & $ii),$GUI_DISABLE)
		EndIf
	Next
Next

GUISetState(@Sw_Show)

While $Amount_Of_Questions > 0
    $msg = GuiGetMsg()
	Select			
	Case $msg = $GUI_EVENT_CLOSE
		WinSetState($Game_Win,"",@SW_DISABLE)
		
		If MsgBox(4,"Are You Sure?","Are you sure you want to exit?") = 6 Then Exit
			
		WinSetState($Game_Win,"",@SW_ENABLE)
		
		WinActivate($Game_Win)

    Case $msg = $Scores_Button
		WinSetState($Game_Win,"",@SW_DISABLE)


		ShowScores()


		WinSetState($Game_Win,"",@SW_ENABLE)
		
		WinActivate($Game_Win)
    Case $msg = $Save_Button
	    WinSetState($Game_Win,"",@SW_DISABLE)
	    If MsgBox(4,"Are you sure?","Are you sure you want to save the current game?") = 6 Then
			$New_Save_Directory = FileSaveDialog("Save Current Game.",@ScriptDir & "\","Jeopardy Saved Game (*.jpsav)",18)
			FileChangeDir(@ScriptDir)
			If Not @error Then
				If StringInStr($New_Save_Directory,".jpsav") = 0 Then $New_Save_Directory = $New_Save_Directory & ".jpsav"
					
				Dim $szDrive, $szDir, $szFName, $szExt
                $New_Save_Directory_Split = _PathSplit($New_Save_Directory, $szDrive, $szDir, $szFName, $szExt)

				FileCopy($Project_Directory,$New_Save_Directory,1)
				
				$SaveFile = FileOpen($Save_Directory,0)
				$SaverFile = FileOpen($New_Save_Directory ,1)
				
				FileWrite($SaverFile,@CRLF & @CRLF & "#END_GAME" & @CRLF & @CRLF)
				
				While 1
					$line = FileReadLine($SaveFile)
					If @error = -1 Then ExitLoop
					FileWriteLine($SaverFile,$line)
				Wend
				
				FileClose($SaveFile)
				FileClose($SaverFile)
			EndIf
			
		EndIf
	    WinSetState($Game_Win,"",@SW_ENABLE)
		
		WinActivate($Game_Win)
	 
	Case $msg >= $Col_1_Row_1 And $msg <= $Col_6_Row_6
		$TotalUp = ($msg - $Col_1_Row_1) + 1
		
		If $TotalUp > 6 Then
			$Cur_Col = Ceiling($TotalUp / 6)
			
			$Cur_Row = $TotalUp - (($Cur_Col - 1) * 6)
		Else
			$Cur_Col = 1
			$Cur_Row = $TotalUp
		EndIf
		
		WinSetState($Game_Win,"",@SW_DISABLE)
		GUICtrlSetState($msg,$GUI_DISABLE)
		
		AskQuestion($Cur_Col,$Cur_Row)
		
		$Amount_Of_Questions = $Amount_Of_Questions - 1
		
		IniWrite($Save_Directory,"SaveSettings","QuestionsLeft",$Amount_Of_Questions)
		
		IniWrite($Save_Directory,"QuestionsEnable",$Cur_Col & "," & $Cur_Row,"0")
		
		WinSetState($Game_Win,"",@SW_ENABLE)
		
		WinActivate($Game_Win)
		
	Case $msg = $GUI_EVENT_MAXIMIZE
		
		WinSetState($Game_Win,"",@SW_DISABLE)
		
		SplashTextOn("Please Wait . . .","Please wait while the window text is updated.",200,200)
		
		For $i = 1 to 6 Step 1
			
			If Eval("Sect_" & $i & "_Enable") = 1 Then
			
			GUICtrlSetData(Eval("Secion_" & $i & "_Title"),@CRLF & IniRead($Project_Directory,"Subjects",$i & "Text","(No Text)"))
			GUICtrlSetFont(Eval("Secion_" & $i & "_Title"),14)

			For $ii = 1 to 6 Step 1
				$Read_Quest_Stuff = IniRead($Project_Directory,"Subject" & $i & "Questions",$ii,"")

				If $Read_Quest_Stuff <> "" Then
					$Read_Quest_Stuff = StringSplit($Read_Quest_Stuff,"|")
					GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & @CRLF & $Read_Quest_Stuff[1])
				Else
					GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & @CRLF & $ii * 100)
				EndIf
				
				GUICtrlSetFont(Eval("Col_" & $i & "_Row_" & $ii),14,-1,4)

			Next
	
			EndIf
		Next
		WinSetState($Game_Win,"",@SW_ENABLE)
		
		SplashOff()
	Case $msg = $GUI_EVENT_RESTORE
		WinSetState($Game_Win,"",@SW_DISABLE)
		
		SplashTextOn("Please Wait . . .","Please wait while the window text is updated.",200,200)
		
		For $i = 1 to 6 Step 1
			
			If Eval("Sect_" & $i & "_Enable") = 1 Then
				
			GUICtrlSetData(Eval("Secion_" & $i & "_Title"),@CRLF & IniRead($Project_Directory,"Subjects",$i & "Text","(No Text)"))
			GUICtrlSetFont(Eval("Secion_" & $i & "_Title"),12)

			For $ii = 1 to 6 Step 1
				$Read_Quest_Stuff = IniRead($Project_Directory,"Subject" & $i & "Questions",$ii,"")

				If $Read_Quest_Stuff <> "" Then
					$Read_Quest_Stuff = StringSplit($Read_Quest_Stuff,"|")
					GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & $Read_Quest_Stuff[1])
				Else
					GUICtrlSetData(Eval("Col_" & $i & "_Row_" & $ii),@CRLF & $ii * 100)
				EndIf
				
				GUICtrlSetFont(Eval("Col_" & $i & "_Row_" & $ii),12,-1,4)

			Next
			
			EndIf
	
		Next
		WinSetState($Game_Win,"",@SW_ENABLE)
	    SplashOff()
	EndSelect
WEnd


;~ --------------------------End Of Game-------------------------

GUIDelete($Game_Win)

ShowFinalScores()

Exit

Func AskQuestion($Col,$Row)
	$dll = DllOpen("user32.dll")
	
	$Read_Question = IniRead($Project_Directory,"Subject" & $Col & "Questions",$Row,100 * $Row & "|20|Your Question Goes Here")
	
	$Read_Question = StringSplit($Read_Question,"|")
	
	$Show_Quest_Win = GUICreate(IniRead($Project_Directory,"Subjects",$Col & "Text","Subject " & $Col) & " For $" & $Read_Question[1],800,700,-1,-1,$WS_CAPTION,-1,$Game_Win)
	GUISetState(@Sw_Show,$Show_Quest_Win)
	
	$BakPick = GUICtrlCreatePic("data\Title.bmp",0,0,800,700)
    GUICtrlSetState(-1,$GUI_DISABLE)

    $Question_Label = GUICtrlCreateLabel($Read_Question[3],20,25,760,90,$SS_CENTER)
    GUICtrlSetColor(-1,0xFFFFFF)
    GUICtrlSetFont (-1,28,-1,4)
	
	$Answer_1_Read = IniRead($Project_Directory,"Subject" & $Col & "Answers",$Row & ",1","1|Answer 1 goes here")
	$Answer_1_Read = StringSplit($Answer_1_Read,"|")
	
	$Answer_2_Read = IniRead($Project_Directory,"Subject" & $Col & "Answers",$Row & ",2","0|Answer 2 goes here")
	$Answer_2_Read = StringSplit($Answer_2_Read,"|")
	
	$Answer_3_Read = IniRead($Project_Directory,"Subject" & $Col & "Answers",$Row & ",3","0|Answer 3 goes here")
	$Answer_3_Read = StringSplit($Answer_3_Read,"|")
	
	$Answer_4_Read = IniRead($Project_Directory,"Subject" & $Col & "Answers",$Row & ",4","0|Answer 4 goes here")
	$Answer_4_Read = StringSplit($Answer_4_Read,"|")
	
	$Answer_Label = GUICtrlCreateLabel("A: " & $Answer_1_Read[2] & @CRLF & @CRLF & "B: " & $Answer_2_Read[2] & @CRLF & @CRLF & "C: " & $Answer_3_Read[2] & @CRLF & @CRLF & "D: " & $Answer_4_Read[2],20,135,760,480)
    GUICtrlSetColor(-1,0x00ff00)
    GUICtrlSetFont (-1,25)
	
	$Timer_Label = GUICtrlCreateLabel($Read_Question[2],500,650,280,50,$SS_RIGHT)
	If $Read_Question[2] < 6 Then
		GUICtrlSetColor($Timer_Label,0xff0000)
	Else
	    GUICtrlSetColor($Timer_Label,0x00ff00)
	EndIf
    GUICtrlSetFont (-1,25)
	
	$Current_Countdown = $Read_Question[2]
	
	$Countdown_Timer = TimerInit()
	
	$Press_Timer = TimerInit()
	
	 While 1
	    		
		If $Current_Countdown < 1 Then
			GUICtrlSetFont ($Question_Label,35)
			GUICtrlSetData($Question_Label,"Times Up!")
			GUICtrlSetColor($Question_Label,0xff0000)
			GUICtrlSetData($Answer_Label,"")
			
			Sleep(1000)
			
			$Total_Answers = ""
			
			If $Answer_1_Read[1] = "1" Then $Total_Answers = "A"

			If $Answer_2_Read[1] = "1" Then 
			    If $Total_Answers <> "" Then 
					$Total_Answers = $Total_Answers & ", B"
				Else
				    $Total_Answers = "B"
				EndIf
			EndIf
			
			If $Answer_3_Read[1] = "1" Then 
				If $Total_Answers <> "" Then 
					$Total_Answers = $Total_Answers & ", C"
				Else
				    $Total_Answers = "C"
				EndIf
			EndIf
			
			If $Answer_4_Read[1] = "1" Then 
				If $Total_Answers <> "" Then 
					$Total_Answers = $Total_Answers & ", D"
				Else
				    $Total_Answers = "D"
				EndIf
			EndIf
			
			If $Total_Answers <> "" Then
			    GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "The Correct Answer(s) was " & $Total_Answers)
			Else
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "There is no Correct Answer!")
			EndIf
				
			Sleep(4000)
			GUIDelete($Show_Quest_Win)
			Return -1
		EndIf
		
		If _IsPressed(41,$dll) Or _IsPressed(31,$dll) Or _IsPressed(61,$dll) Then
			$Time_To_Press = Round(TimerDiff($Press_Timer),-1)
				
			If $Team_Names[0] > 1 Then
			    $Ans_Player = ListBoxDialog("Teams","Select what player answered then click Done.",$Team_Names_String,200,200)
			Else
				$Ans_Player = $Team_Names[1]
			EndIf
			
			GUICtrlSetData($Answer_Label,"")
			If $Answer_1_Read[1] = "1" Then
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Correct!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & $Ans_Player & " got the correct answer in " & $Time_To_Press / 1000 & " seconds. $" & $Read_Question[1] & " earned. Press Enter to continue.")
				
				Do 
					
				Until _IsPressed("0D",$dll)
				
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "Loading ... Please Wait ...")
				
			    GUIDelete($Show_Quest_Win)
				IniWrite($Save_Directory,"PlayersPoints",$Ans_Player,IniRead($Save_Directory,"PlayersPoints",$Ans_Player,0) + $Read_Question[1])
				
				If $Time_To_Press / 1000 <= IniRead($Save_Directory,"SaveSettings","fastestanswerTime",999999999) Then
					IniWrite($Save_Directory,"SaveSettings","fastestanswerTime",$Time_To_Press / 1000)
					IniWrite($Save_Directory,"SaveSettings","fastestanswerName",$Ans_Player)
				EndIf
				
			    Return 1
			Else
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Incorrect!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				$Total_Answers = ""
			
				If $Answer_1_Read[1] = "1" Then $Total_Answers = "A"

				If $Answer_2_Read[1] = "1" Then 
			    	If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", B"
					Else
				    	$Total_Answers = "B"
					EndIf
				EndIf
			
				If $Answer_3_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", C"
					Else
				    	$Total_Answers = "C"
					EndIf
				EndIf
			
				If $Answer_4_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", D"
					Else
						$Total_Answers = "D"
					EndIf
				EndIf
			
				If $Total_Answers <> "" Then
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "The Correct Answer(s) was " & $Total_Answers)
				Else
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "There is no Correct Answer!")
				EndIf
				
				Sleep(4000)
			    GUIDelete($Show_Quest_Win)
				Return 0
			EndIf
		EndIf
		
		If _IsPressed(42,$dll) Or _IsPressed(32,$dll) Or _IsPressed(62,$dll) Then
			$Time_To_Press = Round(TimerDiff($Press_Timer),-1)
			
			If $Team_Names[0] > 1 Then
			    $Ans_Player = ListBoxDialog("Teams","Select what player answered then click Done.",$Team_Names_String,200,200)
			Else
				$Ans_Player = $Team_Names[1]
			EndIf
			
			GUICtrlSetData($Answer_Label,"")
			If $Answer_2_Read[1] = "1" Then
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Correct!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & $Ans_Player & " got the correct answer in " & $Time_To_Press / 1000 & " seconds. $" & $Read_Question[1] & " earned. Press Enter to continue.")
				
				Do 
					
				Until _IsPressed("0D",$dll)
		
			    GUIDelete($Show_Quest_Win)
				IniWrite($Save_Directory,"PlayersPoints",$Ans_Player,IniRead($Save_Directory,"PlayersPoints",$Ans_Player,0) + $Read_Question[1])
				
				If $Time_To_Press / 100 <= IniRead($Save_Directory,"SaveSettings","fastestanswerTime",999999999) Then
					IniWrite($Save_Directory,"SaveSettings","fastestanswerTime",$Time_To_Press / 1000)
					IniWrite($Save_Directory,"SaveSettings","fastestanswerName",$Ans_Player)
				EndIf
				
			    Return 1
			Else
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Incorrect!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				$Total_Answers = ""
			
				If $Answer_1_Read[1] = "1" Then $Total_Answers = "A"

				If $Answer_2_Read[1] = "1" Then 
			    	If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", B"
					Else
				    	$Total_Answers = "B"
					EndIf
				EndIf
			
				If $Answer_3_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", C"
					Else
				    	$Total_Answers = "C"
					EndIf
				EndIf
			
				If $Answer_4_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", D"
					Else
						$Total_Answers = "D"
					EndIf
				EndIf
			
				If $Total_Answers <> "" Then
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "The Correct Answer(s) was " & $Total_Answers)
				Else
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "There is no Correct Answer!")
				EndIf
				
				Sleep(4000)
			    GUIDelete($Show_Quest_Win)
				Return 0
			EndIf
		EndIf
		
		If _IsPressed(43,$dll) Or _IsPressed(33,$dll) Or _IsPressed(63,$dll) Then
			$Time_To_Press = Round(TimerDiff($Press_Timer),-1)
			
			If $Team_Names[0] > 1 Then
			    $Ans_Player = ListBoxDialog("Teams","Select what player answered then click Done.",$Team_Names_String,200,200)
			Else
				$Ans_Player = $Team_Names[1]
			EndIf
			
			GUICtrlSetData($Answer_Label,"")
			If $Answer_3_Read[1] = "1" Then
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Correct!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & $Ans_Player & " got the correct answer in " & $Time_To_Press / 1000 & " seconds. $" & $Read_Question[1] & " earned. Press Enter to continue.")
				
				Do 
					
				Until _IsPressed("0D",$dll)
				
			    GUIDelete($Show_Quest_Win)
				IniWrite($Save_Directory,"PlayersPoints",$Ans_Player,IniRead($Save_Directory,"PlayersPoints",$Ans_Player,0) + $Read_Question[1])
				
				If $Time_To_Press / 1000 <= IniRead($Save_Directory,"SaveSettings","fastestanswerTime",999999999) Then
					IniWrite($Save_Directory,"SaveSettings","fastestanswerTime",$Time_To_Press / 1000)
					IniWrite($Save_Directory,"SaveSettings","fastestanswerName",$Ans_Player)
				EndIf
				
			    Return 1
			Else
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Incorrect!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				$Total_Answers = ""
			
				If $Answer_1_Read[1] = "1" Then $Total_Answers = "A"

				If $Answer_2_Read[1] = "1" Then 
			    	If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", B"
					Else
				    	$Total_Answers = "B"
					EndIf
				EndIf
			
				If $Answer_3_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", C"
					Else
				    	$Total_Answers = "C"
					EndIf
				EndIf
			
				If $Answer_4_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", D"
					Else
						$Total_Answers = "D"
					EndIf
				EndIf
			
				If $Total_Answers <> "" Then
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "The Correct Answer(s) was " & $Total_Answers)
				Else
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "There is no Correct Answer!")
				EndIf
				
				Sleep(4000)
			    GUIDelete($Show_Quest_Win)
				Return 0
			EndIf
		EndIf
		
		If _IsPressed(44,$dll) Or _IsPressed(34,$dll) Or _IsPressed(64,$dll) Then
			$Time_To_Press = Round(TimerDiff($Press_Timer),-1)
			
			If $Team_Names[0] > 1 Then
			    $Ans_Player = ListBoxDialog("Teams","Select what player answered then click Done.",$Team_Names_String,200,200)
			Else
				$Ans_Player = $Team_Names[1]
			EndIf
			
			GUICtrlSetData($Answer_Label,"")
			If $Answer_4_Read[1] = "1" Then
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Correct!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & $Ans_Player & " got the correct answer in " & $Time_To_Press / 1000 & " seconds. $" & $Read_Question[1] & " earned. Press Enter to continue.")
				
				Do 
					
				Until _IsPressed("0D",$dll)
				
			    GUIDelete($Show_Quest_Win)
				IniWrite($Save_Directory,"PlayersPoints",$Ans_Player,IniRead($Save_Directory,"PlayersPoints",$Ans_Player,0) + $Read_Question[1])
				
				If $Time_To_Press / 1000 <= IniRead($Save_Directory,"SaveSettings","fastestanswerTime",999999999) Then
					IniWrite($Save_Directory,"SaveSettings","fastestanswerTime",$Time_To_Press / 1000)
					IniWrite($Save_Directory,"SaveSettings","fastestanswerName",$Ans_Player)
				EndIf
				
			    Return 1
			Else
				GUICtrlSetFont ($Question_Label,35)
			    GUICtrlSetData($Question_Label,"Incorrect!")
			    GUICtrlSetColor($Question_Label,0xff0000)
				
				Sleep(1000)
				
				$Total_Answers = ""
			
				If $Answer_1_Read[1] = "1" Then $Total_Answers = "A"

				If $Answer_2_Read[1] = "1" Then 
			    	If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", B"
					Else
				    	$Total_Answers = "B"
					EndIf
				EndIf
			
				If $Answer_3_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", C"
					Else
				    	$Total_Answers = "C"
					EndIf
				EndIf
			
				If $Answer_4_Read[1] = "1" Then 
					If $Total_Answers <> "" Then 
						$Total_Answers = $Total_Answers & ", D"
					Else
						$Total_Answers = "D"
					EndIf
				EndIf
			
				If $Total_Answers <> "" Then
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "The Correct Answer(s) was " & $Total_Answers)
				Else
					GUICtrlSetData($Answer_Label,@CRLF & @CRLF & @CRLF & "There is no Correct Answer!")
				EndIf
				
				Sleep(4000)
			    GUIDelete($Show_Quest_Win)
				Return 0
			EndIf
		EndIf
		
		If TimerDiff($Countdown_Timer) >= 1000 Then
			$Current_Countdown = $Current_Countdown - 1
			GUICtrlSetData($Timer_Label,$Current_Countdown)
			
			If $Current_Countdown < 6 Then GUICtrlSetColor($Timer_Label,0xff0000)
			
		    $Countdown_Timer = TimerInit()
		EndIf
		
	WEnd
	
	DllClose($dll)

    Return 1
	
EndFunc

Func ListBoxDialog($lb_title = "",$lb_text = "",$lb_Items = "",$lb_Xsize = 300,$lb_Ysize = 300)
	$list_box_win = GUICreate($lb_title,$lb_Xsize,$lb_Ysize,-1,-1,$WS_CAPTION)
	GUISetState(@Sw_Show,$list_box_win)
	
	GUICtrlCreateLabel($lb_text,10,10,$lb_Xsize - 20,40)
	
	$lb_list = GUICtrlCreateList("",10,60,$lb_Xsize - 20,$lb_Ysize - 100)
	GUICtrlSetData(-1,$lb_Items)
	
	$lb_Done_Button = GuiCtrlCreateButton("Done",($lb_Xsize / 2) - 50,$lb_Ysize - 30,100,20)
	
	While 1
	    $lb_msg = GUIGetMsg()
		
		If $lb_msg = $lb_Done_Button Then
			$lb_read_list = GUICtrlRead($lb_list)
			
			If $lb_read_list <> "" Then
				GUIDelete($list_box_win)
				Return $lb_read_list
			Else
				If $lb_Items <> "" Then
					MsgBox(0,"error","You must select a item first.")
				Else
				    GUIDelete($list_box_win)
				    Return 0
				EndIf
			EndIf
		EndIf
		
	WEnd
EndFunc

Func WinRandomAnimation($wa_win,$wa_in_out = 1,$wa_time = 1000)
	Dim $wa_in_animations[11]
	$wa_in_animations[1] = $AW_FADE_IN
	$wa_in_animations[2] = $AW_SLIDE_IN_LEFT
	$wa_in_animations[3] = $AW_SLIDE_IN_RIGHT
	$wa_in_animations[4] = $AW_SLIDE_IN_TOP
	$wa_in_animations[5] = $AW_SLIDE_IN_BOTTOM
	$wa_in_animations[6] = $AW_DIAG_SLIDE_IN_TOPLEFT
	$wa_in_animations[7] = $AW_DIAG_SLIDE_IN_TOPRIGHT
	$wa_in_animations[8] = $AW_DIAG_SLIDE_IN_BOTTOMLEFT
	$wa_in_animations[9] = $AW_DIAG_SLIDE_IN_BOTTOMRIGHT
	$wa_in_animations[10] = $AW_EXPLODE
	
	Dim $wa_out_animations[11]
	$wa_out_animations[1] = $AW_FADE_OUT
	$wa_out_animations[2] = $AW_SLIDE_OUT_LEFT
	$wa_out_animations[3] = $AW_SLIDE_OUT_RIGHT
	$wa_out_animations[4] = $AW_SLIDE_OUT_TOP
	$wa_out_animations[5] = $AW_SLIDE_OUT_BOTTOM
	$wa_out_animations[6] = $AW_DIAG_SLIDE_OUT_TOPLEFT
	$wa_out_animations[7] = $AW_DIAG_SLIDE_OUT_TOPRIGHT
	$wa_out_animations[8] = $AW_DIAG_SLIDE_OUT_BOTTOMLEFT
	$wa_out_animations[9] = $AW_DIAG_SLIDE_OUT_BOTTOMRIGHT
	$wa_out_animations[10] = $AW_IMPLODE
	
	If $wa_in_out = 1 Then
		_WinAnimate($wa_win, $wa_in_animations[Random(1,10,1)], $wa_time)
	Else
		_WinAnimate($wa_win, $wa_out_animations[Random(1,10,1)], $wa_time)
	EndIf
	
EndFunc

Func ShowScores()
	
	$ScoreGUI = GUICreate("Current Scores",700,700,-1,-1,$WS_SYSMENU + $WS_CAPTION)
	GUISetState()
	
	$ScoreBox = GUICtrlCreateEdit("",10,10,680,680,$ES_READONLY + $ES_WANTRETURN + $WS_VSCROLL + $ES_AUTOVSCROLL)
	GUICtrlSetFont (-1,25)
	
	$Highest_Score_Name = ""
	
	$Highest_Score_Num = -500
	
    $Is_Tie_Game = 0

	For $i = 1 To $Team_Names[0] Step 1
		$Read_Player_Points = IniRead($Save_Directory,"PlayersPoints",$Team_Names[$i],"0")
		If $Read_Player_Points > $Highest_Score_Num Then 
			$Highest_Score_Name = $Team_Names[$i] & " ($" & $Read_Player_Points & ")"
			$Highest_Score_Num = $Read_Player_Points
			$Is_Tie_Game = 0
		Else
			If $Read_Player_Points == $Highest_Score_Num Then 
			    $Highest_Score_Name = $Highest_Score_Name & ", " & $Team_Names[$i] & " ($" & $Read_Player_Points & ")"
				$Is_Tie_Game = 1
		    EndIf
		EndIf
			
		
	Next
	If $Is_Tie_Game = 0 Then
		GUICtrlSetData($ScoreBox,"The Current Leader Is: " & $Highest_Score_Name & @CRLF & @CRLF)
	Else
		GUICtrlSetData($ScoreBox,"We have a Tie between: " & $Highest_Score_Name & @CRLF & @CRLF)
	EndIf
	
	For $i = 1 To $Team_Names[0] Step 1
		$Read_Player_Points = IniRead($Save_Directory,"PlayersPoints",$Team_Names[$i],"0")
		
		GUICtrlSetData($ScoreBox,$Team_Names[$i] & " = $" & $Read_Player_Points & @CRLF,"defualt")
	Next
	
	If IniRead($Save_Directory,"SaveSettings","fastestanswerName","(NoName)") <> "(NoName)" Then GUICtrlSetData($ScoreBox,@CRLF & "The fastest answer time was done by " & IniRead($Save_Directory,"SaveSettings","fastestanswerName","(NoName)") & " at " & IniRead($Save_Directory,"SaveSettings","fastestanswerTime","(ErrorReading)") & " seconds.","defualt")
	

	While 1
		
		If GUIGetMsg() = $GUI_EVENT_CLOSE Then 
			GUIDelete($ScoreGUI)
			Return 1
		EndIf
			
	WEnd
EndFunc

Func ShowFinalScores()
	
	$ScoreGUI = GUICreate("Current Scores",700,700,-1,-1,$WS_SYSMENU + $WS_CAPTION)
	GUISetState()
	
	$ScoreBox = GUICtrlCreateEdit("",10,10,680,680,$ES_READONLY + $ES_WANTRETURN + $WS_VSCROLL + $ES_AUTOVSCROLL)
	GUICtrlSetFont (-1,25)
	
	$Highest_Score_Name = ""
	
	$Highest_Score_Num = -500
	
    $Is_Tie_Game = 0

	For $i = 1 To $Team_Names[0] Step 1
		$Read_Player_Points = IniRead($Save_Directory,"PlayersPoints",$Team_Names[$i],"0")
		If $Read_Player_Points > $Highest_Score_Num Then 
			$Highest_Score_Name = $Team_Names[$i] & " ($" & $Read_Player_Points & ")"
			$Highest_Score_Num = $Read_Player_Points
			$Is_Tie_Game = 0
		Else
			If $Read_Player_Points == $Highest_Score_Num Then 
			    $Highest_Score_Name = $Highest_Score_Name & ", " & $Team_Names[$i] & " ($" & $Read_Player_Points & ")"
				$Is_Tie_Game = 1
		    EndIf
		EndIf
			
		
	Next
	If $Is_Tie_Game = 0 Then
		GUICtrlSetData($ScoreBox,"The Winner Is: " & $Highest_Score_Name & @CRLF & @CRLF)
	Else
		GUICtrlSetData($ScoreBox,"The Winners Are: " & $Highest_Score_Name & @CRLF & @CRLF)
	EndIf
	
	For $i = 1 To $Team_Names[0] Step 1
		$Read_Player_Points = IniRead($Save_Directory,"PlayersPoints",$Team_Names[$i],"0")
		
		GUICtrlSetData($ScoreBox,$Team_Names[$i] & " = $" & $Read_Player_Points & @CRLF,"defualt")
	Next
	
	GUICtrlSetData($ScoreBox,@CRLF & "The fastest answer time was done by " & IniRead($Save_Directory,"SaveSettings","fastestanswerName","(NoName)") & " at " & IniRead($Save_Directory,"SaveSettings","fastestanswerTime","(ErrorReading)") & " seconds.","defualt")
	
	While 1
		
		If GUIGetMsg() = $GUI_EVENT_CLOSE Then 
			GUIDelete($ScoreGUI)
			Return 1
		EndIf
			
	WEnd
EndFunc