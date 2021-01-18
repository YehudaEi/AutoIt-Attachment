#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=MealPlannerIcon.ico
#AutoIt3Wrapper_outfile=MealPlanner.exe
#AutoIt3Wrapper_PassPhrase=mg3724
#AutoIt3Wrapper_Res_Description=A tool for planning meals and making shopping lists
#AutoIt3Wrapper_Res_Fileversion=1.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=Copyright 2007 by Michael Garrison
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs 				about Meal Planner v1.0
Version:			1.0.0.1
Script Author:		james3mg
AutoIt Version:		3.2.6.0 and above (possibly below as well, not tested)
Tested Platforms:	Windows Vista, Windows XP SP2

Description:		This script helps you plan your meals, whether it be for a week or a day.  Its primary function is to give you a nice concise shopping list,
					organized by store then aisle, to make for efficient shopping trips.  The legal stuff exists primarily to say "Don't blame me"! - the spirit
					of AutoIt (since I'm posting it in the forums) is kind of that the source be plaintext.  As such, please forgive the coding and lack of comment
					lines...I'm just happy it works :-)  Use or read the code at your own peril ;-)
					
Changes:			v1.0.0.1 includes primarily a number of bug fixes:
					-corrupting a meal's ingredient list if you edited or added a side from within the Edit Main Course dialog. (problem was poor coding, referring to $ListViewItems[$n][0] rather than GUICtrlRead($ListViewItems[$n][0])  )
					-if you added or removed an ingredient, all the ingredient counts were reset to where they were when the dialog was entered.
					-Stupid bug where Side's "  *Show All..." wouldn't work sometimes (because I'd set it to "  *Show All.." instead).
					New features:
					-Ingredients now added with a default quantity of 1
					-default buttons were specified for each GUI for ease of use.
					-some windows and controls are now wider for legibility.
#ce

#cs
NICEITIES TO ADD AT SOME POINT (v1.1?)
- 'Servings' field per-dish, then a dropdown in the Main GUI that offers to multiply it by 2, 3 or 4 (ie. if it serves 2 usually, then the dropdown would offer 2,4,6 or 8 servings), multiplying the quantities of ingredients needed by the chosen factor.
- import/export functions for ingredients (a store might publish these - everything they've got, what aisle it's on and how much it costs...an updateable file like an rss feed would be ideal)
- import/export functions for recipes (would check if ingredients exist already, and if not, add just the name leaving store and units blank).
- price field per ingredient, enabling the shopping list to give you a rough total of the cost of your trip.

POSSIBILITIES OF ADDITIONAL FEATURES
- ability to 'open' a different database file...? (not likely to be added) (useful for those with a vacation home in another city that has different stores). If you want this functionality, just have two copies of the program in two folders, each with their own databases.
#ce

#include <GUIConstants.au3>
#include <Date.au3>
#include <GUICombo.au3>
#include <GUIEdit.au3>
#include <GUIListView.au3>
#include <GUIList.au3>

#region Database prep
#include <SQLite.au3>
#include <SQLite.dll.au3>
_SQLite_Startup()
Global $aResult,$iRows,$iColumns;reusable SQL data containers
Global $FirstTime=0
If NOT FileExists(@ScriptDir&"\Menus.db") Then CreateDB()
Global $MenuDB=_SQLite_Open(@ScriptDir&"\Menus.db")
If @error OR _SQLite_Exec($MenuDB,"Select rowid From MainCourse") <> $SQLITE_OK OR _SQLite_Exec($MenuDB,"Select rowid From Sides") <> $SQLITE_OK OR _SQLite_Exec($MenuDB,"Select rowid From Veggies") <> $SQLITE_OK OR _SQLite_Exec($MenuDB,"Select rowid From Ingredients") <> $SQLITE_OK Then
	If MsgBox(33,"Database invalid","Menus.db seems to be an invalid database for this program.  This program will now send the invalid database to the recycle bin and start over with a blank database.") = 1 AND NOT @error Then
		_SQLite_Close($MenuDB)
		If FileRecycle(@ScriptDir&"\Menus.db")=0 Then
			MsgBox(16,"Error","Bad Menus.db file cannot be recycled. This program will now exit."&@CRLF&@CRLF&"Make sure the database is not open in another program or read-only, then try again. Data may be recoverable.")
			Exit
		EndIf
		CreateDB()
		Global $MenuDB=_SQLite_Open(@ScriptDir&"\Menus.db")
		If @error Then
			MsgBox(16,"Error","There contine to be problems, even with the new database.  This program will now exit.")
			Exit
		EndIf
	Else
		Exit
	EndIf
EndIf
#endregion

StartOver()

If $FirstTime=1 Then;a loop for guiding first-timers...ideally it would be less annoying.  Also contained in the top of the main program 'while' loop and set in the CreateDB function.
	$WinData=WinGetPos($MainGUI)
	ToolTip("You'll want to start by creating meals here",200+$WinData[0],220+$WinData[1],"First time!",1,1)
	Global $TipTimer=TimerInit()
	$FirstTime=2
EndIf



While "I love my wife!";the main program loop
	If $FirstTime=2 AND TimerDiff($TipTimer) > 5000 Then
		ToolTip("")
		$FirstTime=0
	EndIf
	$msg=GUIGetMsg()
	If $msg <> 0 Then;only checks stuff if something was actually done...saves CPU
		Switch $msg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $AboutMenu
				About()
			Case $HelpMenu
				Help()
			Case $MainCourseNewButton
				$EditCompName=InputBox("New main course name:","Please enter the name of the new main course:",""," M",200,-1)
				If NOT @error AND $EditCompName <> "" Then
					_SQLite_Exec($MenuDB,"insert into MainCourse(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
					EditMainCourse($EditCompName)
					GUISwitch($MainGUI)
					UpdateMenuPlan()
				EndIf
				If _GUICtrlComboFindString($MainCourseDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($MainCourseDropdown,$EditCompName)
				SetMainGUISideDropdownContents()
				SetMainGUIVeggieDropdownContents()
			Case $MainCourseEditButton
				If GUICtrlRead($MainCourseDropdown) <> "" Then
					$EditCompName=GUICtrlRead($MainCourseDropdown)
					EditMainCourse(GUICtrlRead($MainCourseDropdown))
					GUISwitch($MainGUI)
					UpdateMenuPlan()
					If _GUICtrlComboFindString($MainCourseDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($MainCourseDropdown,$EditCompName)
					SetMainGUISideDropdownContents()
					SetMainGUIVeggieDropdownContents()
				Else
					MsgBox(16,"Error","You must select a main course to edit!")
				EndIf
			Case $SideNewButton
				$EditCompName=InputBox("New side dish name:","Please enter the name of the new side dish:",""," M",200,-1)
				If NOT @error AND $EditCompName <> "" Then
					_SQLite_Exec($MenuDB,"insert into Sides(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
					EditSide("Side",$EditCompName,$MainGUI)
					GUISwitch($MainGUI)
					UpdateMenuPlan()
				EndIf
				If _GUICtrlComboFindString($SideDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($SideDropdown,$EditCompName)
			Case $SideEditButton
				If GUICtrlRead($SideDropdown) <> "" Then
					$EditCompName=GUICtrlRead($SideDropdown)
					EditSide("Side",GUICtrlRead($SideDropdown),$MainGUI)
					GUISwitch($MainGUI)
					UpdateMenuPlan()
					If _GUICtrlComboFindString($SideDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($SideDropdown,$EditCompName)
				Else
					MsgBox(16,"Error","You must select a side dish to edit!")
				EndIf
			Case $VeggieNewButton
				$EditCompName=InputBox("New veggie name:","Please enter the name of the new veggie:",""," M",200,-1)
				If NOT @error AND $EditCompName <> "" Then
					_SQLite_Exec($MenuDB,"insert into Veggies(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
					EditSide("Veggie",$EditCompName,$MainGUI)
					GUISwitch($MainGUI)
					UpdateMenuPlan()
				EndIf
				If _GUICtrlComboFindString($VeggieDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($VeggieDropdown,$EditCompName)
			Case $VeggieEditButton
				If GUICtrlRead($VeggieDropdown) <> "" Then
					$EditCompName = GUICtrlRead($VeggieDropdown)
					EditSide("Veggie",GUICtrlRead($VeggieDropdown),$MainGUI)
					GUISwitch($MainGUI)
					UpdateMenuPlan()
					If _GUICtrlComboFindString($VeggieDropdown,$EditCompName,1) <> $CB_ERR Then GUICtrlSetData($VeggieDropdown,$EditCompName)
				Else
					MsgBox(16,"Error","You must select a veggie to edit!")
				EndIf
			Case $DeleteItemButton
				If GUICtrlRead($ShoppingListView) <> "" Then
					For $n=1 To $ListMods[0][0]
						If StringLeft(GUICtrlRead(GUICtrlRead($ShoppingListView)),StringInStr(GUICtrlRead(GUICtrlRead($ShoppingListView)),"|")-1) = $ListMods[$n][0] AND $ListMods[$n][1] = "Add" Then
							_ArrayDelete4d($ListMods,$n)
							$ListMods[0][0]-=1
							UpdateMenuPlan()
							ContinueLoop 2
						EndIf
					Next
					$ListMods[0][0]+=1
					ReDim $ListMods[$ListMods[0][0]+1][3]
					$ListMods[$ListMods[0][0]][0]=StringLeft(GUICtrlRead(GUICtrlRead($ShoppingListView)),StringInStr(GUICtrlRead(GUICtrlRead($ShoppingListView)),"|")-1)
					$ListMods[$ListMods[0][0]][1]="Sub"
					UpdateMenuPlan()
				EndIf
			Case $AddItemButton
				AddToShoppingList()
				UpdateMenuPlan()
			Case $PrintrecipesButton
				Printrecipes()
			Case $PrintShoppingButton
				If $ShoppingListArray[0][0]=0 Then ContinueLoop
				Local $PrintListArray[1][4]=[["0"]]
				For $n=1 To $ShoppingListArray[0][0]
					Local $SplitArray=StringSplit(GUICtrlRead($ShoppingListArray[$n][0]),"|")
					If IsArray($SplitArray) AND NOT @error Then
						$PrintListArray[0][0]+=1
						ReDim $PrintListArray[$PrintListArray[0][0]+1][4]
						$PrintListArray[$PrintListArray[0][0]][0]=$SplitArray[1]
						$PrintListArray[$PrintListArray[0][0]][1]=$SplitArray[2]
						$PrintListArray[$PrintListArray[0][0]][2]=$SplitArray[3]
						$PrintListArray[$PrintListArray[0][0]][3]=$SplitArray[4]
					EndIf
				Next
				_ArraySort($PrintListArray,1,1,0,4,3)
				_ArraySort($PrintListArray,1,1,0,4,2)
				Local $PrintStr="<HTML><HEAD><TITLE>Shopping list printed from Meal Planner 1.0 on "&_Now()&"</TITLE></HEAD><BODY><TABLE width='100%' border='1' cellspacing='0'><TR><TD colspan='4'><h2>"&$PrintListArray[1][2]&"</h2></TD></TR><TR><TD>&nbsp;</TD><TD><B>Item:</B></TD><TD><B>Number:</B></TD><TD><B>Aisle:</B></TD></TR><TR><TD>&nbsp;</TD><TD>"&$PrintListArray[1][0]&"</TD><TD>"&$PrintListArray[1][1]&"</TD><TD>"&$PrintListArray[1][3]&"</TD></TR>"
				For $n=2 To $PrintListArray[0][0]
					If $PrintListArray[$n][2] <> $PrintListArray[$n-1][2] Then $PrintStr&="</TABLE><p><TABLE width='100%' border='1' cellspacing='0'><TR><TD colspan='4'><h2>"&$PrintListArray[$n][2]&"</h2></TD></TR><TR><TD>&nbsp;</TD><TD><B>Item:</B></TD><TD><B>Number:</B></TD><TD><B>Aisle:</B></TD></TR>"
					$PrintStr&="<TR><TD>&nbsp;</TD><TD>"&$PrintListArray[$n][0]&"</TD><TD>"&$PrintListArray[$n][1]&"</TD><TD>"&$PrintListArray[$n][3]&"</TD></TR>"
				Next
				$PrintStr&="</TABLE></BODY></HTML>"
				FileWrite(@TempDir&"\MealPlannerPrintOutput.html",$PrintStr)
				_PrintHTML(@TempDir&"\MealPlannerPrintOutput.html")
				FileDelete(@TempDir&"\MealPlannerPrintOutput.html")
			Case $ClearButton
				GUIDelete($MainGUI)
				StartOver()
			Case $MainCourseNoneRadio
				GUICtrlSetState($MainCourseDropdown,$GUI_DISABLE)
				GUICtrlSetState($MainCourseEditButton,$GUI_DISABLE)
				GUICtrlSetState($MainCourseCommentInput,$GUI_DISABLE)
			Case $MainCourseDropdownRadio
				GUICtrlSetState($MainCourseDropdown,$GUI_ENABLE+$GUI_FOCUS)
				GUICtrlSetState($MainCourseEditButton,$GUI_ENABLE)
				GUICtrlSetState($MainCourseCommentInput,$GUI_DISABLE)
			Case $MainCourseCommentRadio
				GUICtrlSetState($MainCourseDropdown,$GUI_DISABLE)
				GUICtrlSetState($MainCourseEditButton,$GUI_DISABLE)
				GUICtrlSetState($MainCourseCommentInput,$GUI_ENABLE+$GUI_FOCUS)
			Case $SideNoneRadio
				GUICtrlSetState($SideDropdown,$GUI_DISABLE)
				GUICtrlSetState($SideEditButton,$GUI_DISABLE)
			Case $SideDropdownRadio
				GUICtrlSetState($SideDropdown,$GUI_ENABLE+$GUI_FOCUS)
				GUICtrlSetState($SideEditButton,$GUI_ENABLE)
			Case $VeggieNoneRadio
				GUICtrlSetState($VeggieDropdown,$GUI_DISABLE)
				GUICtrlSetState($VeggieEditButton,$GUI_DISABLE)
			Case $VeggieDropdownRadio
				GUICtrlSetState($VeggieDropdown,$GUI_ENABLE+$GUI_FOCUS)
				GUICtrlSetState($VeggieEditButton,$GUI_ENABLE)
			Case $PrintCalendarButton
				Local $PrintStr="<HTML><HEAD><TITLE>Meal schedule printed from Meal Planner 1.0 on "&_Now()&"</TITLE></HEAD><BODY><TABLE width='100%' border='1' cellspacing='0'><TR>"
				For $n=0 To UBound($DayButtonHeaders)-1
					$PrintStr&="<TD><b>"&$DayButtonHeaders[$n]&"</b></TD>"
				Next
				$PrintStr&="</TR><TR>"
				For $n=0 To UBound($DayButtons)-1
					$PrintStr&="<TD>"&StringReplace(StringTrimLeft(GUICtrlRead($DayButtons[$n]),StringInStr(GUICtrlRead($DayButtons[$n]),@CRLF)),@CR,"<BR>")&"</TD>"
				Next
				$PrintStr&="</TR></TABLE></BODY></HTML>"
				FileWrite(@TempDir&"\MealPlannerPrintOutput.html",$PrintStr)
				_PrintHTML(@TempDir&"\MealPlannerPrintOutput.html")
				FileDelete(@TempDir&"\MealPlannerPrintOutput.html")
			Case Else
				For $i=0 To UBound($DayButtons)-1
					If $msg=$DayButtons[$i] AND $msg <> $DayButtons[$CurrDayButton] Then
						GUICtrlSetBkColor($DayButtons[$i],0xCCCCFF)
						If $MenuArray[$CurrDayButton][0] <> "" Then;day's main dish is planned - uncolor button
							GUICtrlSetBkColor($DayButtons[$CurrDayButton],-1)
						Else;day's main dish isn't planned - color the day pink
							GUICtrlSetBkColor($DayButtons[$CurrDayButton],0xFFCCCC)
						EndIf
						$CurrDayButton=$i
						GUICtrlSetData($MainCourseDropdown,"")
						GUICtrlSetData($MainCourseCommentInput,"")
						GUICtrlSetData($SideDropdown,"")
						GUICtrlSetData($VeggieDropdown,"")
						
						If $MenuArray[$CurrDayButton][0] = "" Then;no main dish has been chosen
							GUICtrlSetState($MainCourseNoneRadio,$GUI_CHECKED)
							GUICtrlSetState($MainCourseDropdownRadio,$GUI_UNCHECKED)
							GUICtrlSetState($MainCourseCommentRadio,$GUI_UNCHECKED)
							GUICtrlSetState($MainCourseDropdown,$GUI_DISABLE)
							GUICtrlSetState($MainCourseEditButton,$GUI_DISABLE)
							GUICtrlSetState($MainCourseCommentInput,$GUI_DISABLE)
							_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
							Local $DropdownValue=""
							For $n=1 To $iRows
								$DropdownValue&="|"&$aResult[$n][0]
							Next
							GUICtrlSetData($MainCourseDropdown,$DropdownValue)
						Else
							If StringLeft($MenuArray[$CurrDayButton][0],1) = "1" Then;main dish has been chosen - value goes in dropdown
								GUICtrlSetState($MainCourseNoneRadio,$GUI_UNCHECKED)
								GUICtrlSetState($MainCourseDropdownRadio,$GUI_CHECKED)
								GUICtrlSetState($MainCourseCommentRadio,$GUI_UNCHECKED)
								GUICtrlSetState($MainCourseDropdown,$GUI_ENABLE+$GUI_FOCUS)
								GUICtrlSetState($MainCourseEditButton,$GUI_ENABLE)
								GUICtrlSetState($MainCourseCommentInput,$GUI_DISABLE)
								_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
								Local $DropdownValue=""
								For $n=1 To $iRows
									$DropdownValue&="|"&$aResult[$n][0]
								Next
								GUICtrlSetData($MainCourseDropdown,$DropdownValue)
								GUICtrlSetData($MainCourseDropdown,StringTrimLeft($MenuArray[$CurrDayButton][0],1),StringTrimLeft($MenuArray[$CurrDayButton][0],1));doubled because of "value,default" action of combox
								GUICtrlSetData($MainCourseCommentInput,"")
							Else;main dish has been chosen - value goes in comments box
								GUICtrlSetState($MainCourseNoneRadio,$GUI_UNCHECKED)
								GUICtrlSetState($MainCourseDropdownRadio,$GUI_UNCHECKED)
								GUICtrlSetState($MainCourseCommentRadio,$GUI_CHECKED)
								GUICtrlSetState($MainCourseDropdown,$GUI_DISABLE)
								GUICtrlSetState($MainCourseEditButton,$GUI_DISABLE)
								GUICtrlSetState($MainCourseCommentInput,$GUI_ENABLE+$GUI_FOCUS)
								_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
								Local $DropdownValue=""
								For $n=1 To $iRows
									$DropdownValue&="|"&$aResult[$n][0]
								Next
								GUICtrlSetData($MainCourseDropdown,$DropdownValue)
								GUICtrlSetData($MainCourseCommentInput,StringTrimLeft($MenuArray[$CurrDayButton][0],1))
							EndIf
						EndIf
						
						If $MenuArray[$CurrDayButton][1] = "" Then;no side has been chosen
							GUICtrlSetState($SideNoneRadio,$GUI_CHECKED)
							GUICtrlSetState($SideDropdownRadio,$GUI_UNCHECKED)
							GUICtrlSetState($SideDropdown,$GUI_DISABLE)
							GUICtrlSetState($SideEditButton,$GUI_DISABLE)
							SetMainGUISideDropdownContents()
						Else;side has been chosen
							GUICtrlSetState($SideNoneRadio,$GUI_UNCHECKED)
							GUICtrlSetState($SideDropdownRadio,$GUI_CHECKED)
							GUICtrlSetState($SideDropdown,$GUI_ENABLE)
							GUICtrlSetState($SideEditButton,$GUI_ENABLE)
							SetMainGUISideDropdownContents()
							GUICtrlSetData($SideDropdown,$MenuArray[$CurrDayButton][1],$MenuArray[$CurrDayButton][1]);doubled because of "value,default" action of combox
						EndIf
						
						If $MenuArray[$CurrDayButton][2] = "" Then;no veggie is chosen
							GUICtrlSetState($VeggieNoneRadio,$GUI_CHECKED)
							GUICtrlSetState($VeggieDropdownRadio,$GUI_UNCHECKED)
							GUICtrlSetState($VeggieDropdown,$GUI_DISABLE)
							GUICtrlSetState($VeggieEditButton,$GUI_DISABLE)
							SetMainGUIVeggieDropdownContents()
						Else;veggie has been chosen
							GUICtrlSetState($VeggieNoneRadio,$GUI_UNCHECKED)
							GUICtrlSetState($VeggieDropdownRadio,$GUI_CHECKED)
							GUICtrlSetState($VeggieDropdown,$GUI_ENABLE)
							GUICtrlSetState($VeggieEditButton,$GUI_ENABLE)
							SetMainGUIVeggieDropdownContents()
							GUICtrlSetData($VeggieDropdown,$MenuArray[$CurrDayButton][2],$MenuArray[$CurrDayButton][2]);doubled because of "value,default" action of combox
						EndIf
					EndIf
				Next
				
				If BitAND(GUICtrlRead($MainCourseNoneRadio),$GUI_CHECKED) AND $MenuArray[$CurrDayButton][0] <> "" Then
					$MenuArray[$CurrDayButton][0] = ""
					GUICtrlSetState($SideNoneRadio,$GUI_CHECKED)
					GUICtrlSetState($SideDropdownRadio,$GUI_UNCHECKED)
					GUICtrlSetState($SideDropdown,$GUI_DISABLE)
					GUICtrlSetState($SideEditButton,$GUI_DISABLE)
					GUICtrlSetState($VeggieNoneRadio,$GUI_CHECKED)
					GUICtrlSetState($VeggieDropdownRadio,$GUI_UNCHECKED)
					GUICtrlSetState($VeggieDropdown,$GUI_DISABLE)
					GUICtrlSetState($VeggieEditButton,$GUI_DISABLE)
					GUICtrlSetData($SideDropdown,"|  *Show All...")
					GUICtrlSetData($VeggieDropdown,"|  *Show All...")
					UpdateMenuPlan()
				EndIf
				If BitAND(GUICtrlRead($MainCourseDropdownRadio),$GUI_CHECKED) AND StringTrimLeft($MenuArray[$CurrDayButton][0],1) <> GUICtrlRead($MainCourseDropdown) AND _GUICtrlComboGetDroppedState($MainCourseDropdown) = False Then
					$MenuArray[$CurrDayButton][0] = "1"&GUICtrlRead($MainCourseDropdown)
					SetMainGUISideDropdownContents()
					SetMainGUIVeggieDropdownContents()
					UpdateMenuPlan()
				EndIf
				If BitAND(GUICtrlRead($MainCourseCommentRadio),$GUI_CHECKED) AND StringTrimLeft($MenuArray[$CurrDayButton][0],1) <> GUICtrlRead($MainCourseCommentInput) Then
					$MenuArray[$CurrDayButton][0] = "2"&GUICtrlRead($MainCourseCommentInput)
					UpdateMenuPlan()
				EndIf
				If BitAND(GUICtrlRead($SideNoneRadio),$GUI_CHECKED) AND $MenuArray[$CurrDayButton][1] <> "" Then
					$MenuArray[$CurrDayButton][1] = ""
					UpdateMenuPlan()
				EndIf
				If BitAND(GUICtrlRead($SideDropdownRadio),$GUI_CHECKED) AND $MenuArray[$CurrDayButton][1] <> GUICtrlRead($SideDropdown) AND _GUICtrlComboGetDroppedState($SideDropdown) = False Then
					If GUICtrlRead($SideDropdown) = "  *Show All..." Then
						_SQLite_GetTable2d($MenuDB,"Select Name From Sides;",$aResult,$iRows,$iColumns)
						Local $DropdownValue=""
						For $i=1 To $iRows
							$DropdownValue&="|"&$aResult[$i][0]
						Next
						GUICtrlSetData($SideDropdown,$DropdownValue)
					Else
						$MenuArray[$CurrDayButton][1] = GUICtrlRead($SideDropdown)
						UpdateMenuPlan()
					EndIf
				EndIf
				If BitAND(GUICtrlRead($VeggieNoneRadio),$GUI_CHECKED) AND $MenuArray[$CurrDayButton][2] <> "" Then
					$MenuArray[$CurrDayButton][2] = ""
					UpdateMenuPlan()
				EndIf
				If BitAND(GUICtrlRead($VeggieDropdownRadio),$GUI_CHECKED) AND $MenuArray[$CurrDayButton][2] <> GUICtrlRead($VeggieDropdown) AND _GUICtrlComboGetDroppedState($VeggieDropdown) = False Then
					If GUICtrlRead($VeggieDropdown) = "  *Show All..." Then
						_SQLite_GetTable2d($MenuDB,"Select Name From Veggies;",$aResult,$iRows,$iColumns)
						Local $DropdownValue=""
						For $i=1 To $iRows
							$DropdownValue&="|"&$aResult[$i][0]
						Next
						GUICtrlSetData($VeggieDropdown,$DropdownValue)
					Else
						$MenuArray[$CurrDayButton][2] = GUICtrlRead($VeggieDropdown)
						UpdateMenuPlan()
					EndIf
				EndIf
		EndSwitch
	EndIf
	Sleep(15);take less CPU
WEnd

Func CreateDB();runs if the menu database doesn't exist
	$FirstTime=1;maybe I can make this less annoying?
	$DBToCreate=_SQLite_Open(@ScriptDir&"\Menus.db")
	
	_SQLite_Exec($DBToCreate,"Create Table MainCourse (Name UNIQUE,CompSides,CompVeggies,Ingredients,Recipe);")
	_SQLite_Exec($DBToCreate,"Create Table Sides (Name UNIQUE,Ingredients,Recipe);")
	_SQLite_Exec($DBToCreate,"Create Table Veggies (Name UNIQUE,Ingredients,Recipe);")
	_SQLite_Exec($DBToCreate,"Create Table Ingredients (Name UNIQUE,Store,Aisle,Units);")
	
	If MsgBox(36,"Jump-start?","A blank menu database has been created - do you want some bogus information put in so you can see how this program works?"&@CRLF&@CRLF&"(If you click yes, then later decide you want to start over with a blank database, simply delete 'Menus.db' in the same directory as this program, then click 'no' when this prompt pops up again).") = 6 Then
		_SQLite_Exec($DBToCreate,"insert into MainCourse(Name,CompSides,CompVeggies,Ingredients) values('Bratwurst','|Wild Rice|White Rice','|Salad|Asparigus','|Frozen Bratwurst~1');")
		_SQLite_Exec($DBToCreate,"insert into MainCourse(Name,CompSides,CompVeggies,Ingredients,Recipe) values('Hamburgers','|Baked Beans','|Salad|Brocolli','|Ground Beef~1|Ketchup~0','Press the beef into patties"&@CRLF&@CRLF&"Grill to an internal temp. of 350 degrees for 7 minutes and eat.');")
		_SQLite_Exec($DBToCreate,"insert into Sides(Name,Ingredients) values('White Rice','|Minute Rice~1');")
		_SQLite_Exec($DBToCreate,"insert into Sides(Name) values('Wild Rice');")
		_SQLite_Exec($DBToCreate,"insert into Sides(Name) values('Applesauce');")
		_SQLite_Exec($DBToCreate,"insert into Sides(Name) values('Baked Beans');")
		_SQLite_Exec($DBToCreate,"insert into Veggies(Name,Ingredients,Recipe) values('Salad','|Lettuce~2','Put the lettuce in a bowl and cover in dressing');")
		_SQLite_Exec($DBToCreate,"insert into Veggies(Name) values('Asparigus');")
		_SQLite_Exec($DBToCreate,"insert into Veggies(Name) values('Brocolli');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Ground Beef','Safeway','Butcher','lbs');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Minute Rice','Safeway','8','boxes');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Frozen Bratwurst','Fry''s Marketplace','8','boxes of 6');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Milk','Sam''s Club','35','boxes');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Lettuce','Safeway','Produce','heads');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Toothpaste','Safeway','12','tubes');")
		_SQLite_Exec($DBToCreate,"insert into Ingredients(Name,Store,Aisle,Units) values('Ketchup','Safeway','7','bottles');")
		$FirstTime=0
	EndIf
	
	_SQLite_Close($DBToCreate)
EndFunc

Func StartOver();creates the GUI and walks through picking the dates
	Global $ListMods[1][3]=[["0"]];the array storing a user's custom changes to the shopping list.  Structure: [x][0]=item, [x][1] = add/sub, [x][2] = quantity if add.  Used in UpdateMenuPlan() and set with add/remove buttons in $MainGUI.
	Global $ShoppingListArray[1][3]=[["0"]]
	Global $DayNames[8]=["","Sun","Mon","Tues","Wed","Thurs","Fri","Sat"]
	Global $MainGUI=GUICreate("Meal Planner by Michael Garrison",640,540)
	Global $MainGUIMenu=GUICtrlCreateMenu("&Help")
	Global $AboutMenu=GUICtrlCreateMenuItem("About Meal Planner 1.0",$MainGUIMenu)
	GUICtrlCreateMenuItem("",$MainGUIMenu)
	Global $HelpMenu=GUICtrlCreateMenuItem("Help",$MainGUIMenu)
	
	GUICtrlCreateLabel("Starting date:",10,5,150,15)
	Global $StartDateInput=GUICtrlCreateDate("",10,30,150,20,$DTS_SHORTDATEFORMAT)
	GUICtrlCreateLabel("Ending date:",380,5,150,15)
	Global $EndDateInput=GUICtrlCreateDate("",380,30,150,20,$DTS_SHORTDATEFORMAT)
	Global $SetDatesButton=GUICtrlCreateButton("Set dates",555,30,75,20,$BS_DEFPUSHBUTTON)
	
	GUICtrlCreateLabel("",30,65,580,1)
	GUICtrlSetBkColor(-1,0x999999)
	
	Global $ButtonBG=GUICtrlCreateLabel("",10,80,620,68)
	GUICtrlSetBkColor(-1,0xFFCCCC)
	
	GUISetState(@SW_SHOW,$MainGUI)
	
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $AboutMenu
				About()
			Case $HelpMenu
				Help()
			Case $SetDatesButton
				$StartDateParts=StringSplit(GUICtrlRead($StartDateInput),"/")
				$EndDateParts=StringSplit(GUICtrlRead($EndDateInput),"/")
				If _DateToDayValue($StartDateParts[3],$StartDateParts[1],$StartDateParts[2]) > _DateToDayValue($EndDateParts[3],$EndDateParts[1],$EndDateParts[2]) Then
					MsgBox(16,"Error","Ending date cannot be before starting date!")
					ContinueLoop
				EndIf
				Global $DayButtons[_DateDiff("D",$StartDateParts[3]&"/"&$StartDateParts[1]&"/"&$StartDateParts[2],$EndDateParts[3]&"/"&$EndDateParts[1]&"/"&$EndDateParts[2])+1]
				Global $MenuArray[UBound($DayButtons)][3]
				Global $DayButtonHeaders[UBound($DayButtons)]
				If UBound($DayButtons) > 10 Then
					If MsgBox(36,"Too many days","It is not recommended to plan more than 10 days with this tool - continue anyway?")=7 Then ContinueLoop
				EndIf
				ExitLoop
		EndSwitch
		Sleep(15);take less CPU
	WEnd
	
	GUICtrlSetState($StartDateInput,$GUI_DISABLE)
	GUICtrlSetState($EndDateInput,$GUI_DISABLE)
	GUICtrlSetState($SetDatesButton,$GUI_DISABLE)
	GUICtrlDelete($ButtonBG)
	
	For $i=0 To UBound($DayButtons)-1
		$DayButtons[$i]=GUICtrlCreateButton("",10+($i*(620/(UBound($DayButtons)))),80,Ceiling(620/(UBound($DayButtons))),68,$BS_TOP+$BS_MULTILINE+$WS_TABSTOP+$BS_NOTIFY+$BS_FLAT)
		If $i=0 Then
			GUICtrlSetBkColor(-1,0xCCCCFF)
			Global $CurrDayButton=$i
		Else
			GUICtrlSetBkColor(-1,0xFFCCCC)
		EndIf
		$ButtonDate=_DateAdd("D",$i,$StartDateParts[3]&"/"&$StartDateParts[1]&"/"&$StartDateParts[2])
		$ButtonDate=StringSplit($ButtonDate,"/")
		$ButtonDateText=$DayNames[_DateToDayOfWeek($ButtonDate[1],$ButtonDate[2],$ButtonDate[3])]
		$ButtonDateText&="-"&$ButtonDate[2]&"/"&$ButtonDate[3]
		$DayButtonHeaders[$i]=$ButtonDateText
		GUICtrlSetData($DayButtons[$i],$DayButtonHeaders[$i])
	Next
	Global $PrintCalendarButton=GUICtrlCreateButton("Print Schedule",530,148,100,20)
	
	GUICtrlCreateGroup("Main Course:",10,155,250,165)
	Global $MainCourseNewButton=GUICtrlCreateButton("New...",160,170,75,20)
	Global $MainCourseNoneRadio=GUICtrlCreateRadio("None",15,190,235,20)
	GUICtrlSetState(-1,$GUI_CHECKED)
	Global $MainCourseDropdownRadio=GUICtrlCreateRadio("",15,215,20,20)
	Global $MainCourseDropdown=GUICtrlCreateCombo("",40,215,180,20,$CBS_DROPDOWNLIST+$CBS_SORT)
	GUICtrlSetState(-1,$GUI_DISABLE)
	
	_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
	Local $DropdownValue=""
	For $i=1 To $iRows
		$DropdownValue&="|"&$aResult[$i][0]
	Next
	GUICtrlSetData($MainCourseDropdown,$DropdownValue)
	
	Global $MainCourseEditButton=GUICtrlCreateButton("...",230,215,20,20)
	GUICtrlSetState(-1,$GUI_DISABLE)
	Global $MainCourseCommentRadio=GUICtrlCreateRadio("",15,245,20,20)
	Global $MainCourseCommentInput=GUICtrlCreateEdit("",40,245,210,70)
	GUICtrlSetState(-1,$GUI_DISABLE)
	
	GUICtrlCreateGroup("Side Dish:",10,325,250,95)
	Global $SideNewButton=GUICtrlCreateButton("New...",160,340,75,20)
	Global $SideNoneRadio=GUICtrlCreateRadio("None",15,360,235,20)
	GUICtrlSetState(-1,$GUI_CHECKED)
	Global $SideDropdownRadio=GUICtrlCreateRadio("",15,385,20,20)
	Global $SideDropdown=GUICtrlCreateCombo("",40,385,180,20,$CBS_DROPDOWNLIST+$CBS_SORT)
	GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetData(-1,"  *Show All...")
	Global $SideEditButton=GUICtrlCreateButton("...",230,385,20,20)
	GUICtrlSetState(-1,$GUI_DISABLE)
	
	GUICtrlCreateGroup("Veggie:",10,425,250,95)
	Global $VeggieNewButton=GUICtrlCreateButton("New...",160,440,75,20)
	Global $VeggieNoneRadio=GUICtrlCreateRadio("None",15,460,235,20)
	GUICtrlSetState(-1,$GUI_CHECKED)
	Global $VeggieDropdownRadio=GUICtrlCreateRadio("",15,485,20,20)
	Global $VeggieDropdown=GUICtrlCreateCombo("",40,485,180,20,$CBS_DROPDOWNLIST+$CBS_SORT)
	GUICtrlSetState(-1,$GUI_DISABLE)
	GUICtrlSetData(-1,"  *Show All...")
	Global $VeggieEditButton=GUICtrlCreateButton("...",230,485,20,20)
	GUICtrlSetState(-1,$GUI_DISABLE)
	
	GUICtrlCreateLabel("",270,165,1,335)
	GUICtrlSetBkColor(-1,0x999999)
	
	GUICtrlCreateLabel("Shopping list:",290,165,130,20)
	Global $ShoppingListView=GUICtrlCreateListView("Item:                     |Quantity:|Store:             |Aisle:",290,185,340,265)
	Global $AddItemButton=GUICtrlCreateButton("Add item to shopping list",290,450,160,20)
	Global $DeleteItemButton=GUICtrlCreateButton("Remove item from shopping list",470,450,160,20)
	Global $ClearButton=GUICtrlCreateButton("Clear all",290,485,75,20)
	Global $PrintrecipesButton=GUICtrlCreateButton("View/print recipes",400,485,100,20)
	Global $PrintShoppingButton=GUICtrlCreateButton("Print shopping list",530,485,100,20)
EndFunc

Func UpdateMenuPlan();sets 'day button' text and shopping list
	GUICtrlSetData($DayButtons[$CurrDayButton],$DayButtonHeaders[$CurrDayButton]&@CRLF&StringTrimLeft($MenuArray[$CurrDayButton][0],1)&@CRLF&$MenuArray[$CurrDayButton][1]&@CRLF&$MenuArray[$CurrDayButton][2])
	
	For $n=1 To $ShoppingListArray[0][0];defined globally in StartOver()
		GUICtrlDelete($ShoppingListArray[$n][0])
	Next
	ReDim $ShoppingListArray[1][3];GUI id | Item | Quantity
	$ShoppingListArray[0][0]=0
	
	For $n=0 To UBound($MenuArray)-1;main course section of the shopping list
		If StringLeft($MenuArray[$n][0],1) = 1 Then
			_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From MainCourse Where Name='"&StringReplace(StringTrimLeft($MenuArray[$n][0],1),"'","''")&"'",$aResult,$iRows,$iColumns)
			If $iColumns > 0 AND $aResult[1][1] <> "" Then
				Local $IngredArray = StringSplit(StringTrimLeft($aResult[1][1],1),"|")
				For $x=1 To $IngredArray[0]
					For $y=1 To $ShoppingListArray[0][0]
						If StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1) = $ShoppingListArray[$y][1] Then
							$ShoppingListArray[$y][2]+=StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
							ContinueLoop 2
						EndIf
					Next
					;if you get here, the ingredient wasn't already on the list
					$ShoppingListArray[0][0]+=1
					ReDim $ShoppingListArray[$ShoppingListArray[0][0]+1][3]
					$ShoppingListArray[$ShoppingListArray[0][0]][1] = StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1)
					$ShoppingListArray[$ShoppingListArray[0][0]][2] = StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
				Next
			EndIf
		EndIf
	Next
	For $n=0 To UBound($MenuArray)-1;Side dish section of the shopping list
		If $MenuArray[$n][1] <> "" Then
			_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From Sides Where Name='"&StringReplace($MenuArray[$n][1],"'","''")&"'",$aResult,$iRows,$iColumns)
			If $iColumns > 0 AND $aResult[1][1] <> "" Then
				Local $IngredArray = StringSplit(StringTrimLeft($aResult[1][1],1),"|")
				For $x=1 To $IngredArray[0]
					For $y=1 To $ShoppingListArray[0][0]
						If StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1) = $ShoppingListArray[$y][1] Then
							$ShoppingListArray[$y][2]+=StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
							ContinueLoop 2
						EndIf
					Next
					;if you get here, the ingredient wasn't already on the list
					$ShoppingListArray[0][0]+=1
					ReDim $ShoppingListArray[$ShoppingListArray[0][0]+1][3]
					$ShoppingListArray[$ShoppingListArray[0][0]][1] = StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1)
					$ShoppingListArray[$ShoppingListArray[0][0]][2] = StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
				Next
			EndIf
		EndIf
	Next
	For $n=0 To UBound($MenuArray)-1;Veggie section of the shopping list
		If $MenuArray[$n][2] <> "" Then
			_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From Veggies Where Name='"&StringReplace($MenuArray[$n][2],"'","''")&"'",$aResult,$iRows,$iColumns)
			If $iColumns > 0 AND $aResult[1][1] <> "" Then
				Local $IngredArray = StringSplit(StringTrimLeft($aResult[1][1],1),"|")
				For $x=1 To $IngredArray[0]
					For $y=1 To $ShoppingListArray[0][0]
						If StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1) = $ShoppingListArray[$y][1] Then
							$ShoppingListArray[$y][2]+=StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
							ContinueLoop 2
						EndIf
					Next
					;if you get here, the ingredient wasn't already on the list
					$ShoppingListArray[0][0]+=1
					ReDim $ShoppingListArray[$ShoppingListArray[0][0]+1][3]
					$ShoppingListArray[$ShoppingListArray[0][0]][1] = StringLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1)-1)
					$ShoppingListArray[$ShoppingListArray[0][0]][2] = StringTrimLeft($IngredArray[$x],StringInStr($IngredArray[$x],"~",0,-1))
				Next
			EndIf
		EndIf
	Next
	
	For $n=1 To $ListMods[0][0]
		If $ListMods[$n][1] = "Add" Then
			For $x=1 To $ShoppingListArray[0][0]
				If $ListMods[$n][0] = $ShoppingListArray[$x][1] Then
					$ShoppingListArray[$x][2]+=$ListMods[$n][2]
					ContinueLoop 2
				EndIf
			Next
			;if you get here, the ingredient wasn't already on the list
			$ShoppingListArray[0][0]+=1
			ReDim $ShoppingListArray[$ShoppingListArray[0][0]+1][3]
			$ShoppingListArray[$ShoppingListArray[0][0]][1]=$ListMods[$n][0]
			$ShoppingListArray[$ShoppingListArray[0][0]][2]=$ListMods[$n][2]
		ElseIf $ListMods[$n][1] = "Sub" Then
			For $x=1 To $ShoppingListArray[0][0]
				If $ListMods[$n][0] = $ShoppingListArray[$x][1] Then
					_ArrayDelete4D($ShoppingListArray,$x)
					$ShoppingListArray[0][0]-=1
					ExitLoop
				EndIf
			Next
		EndIf
	Next
	For $n=1 To $ShoppingListArray[0][0]
		_SQLite_GetTable2d($MenuDB,"Select Name,Store,Aisle,Units From Ingredients Where Name='"&StringReplace($ShoppingListArray[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
		If $iRows > 0 Then
			$ShoppingListArray[$n][0]=GUICtrlCreateListViewItem($ShoppingListArray[$n][1]&"|"&$ShoppingListArray[$n][2] & " " &$aResult[1][3]&"|"&$aResult[1][1]&"|"&$aResult[1][2],$ShoppingListView)
		Else
			$ShoppingListArray[$n][0]=GUICtrlCreateListViewItem($ShoppingListArray[$n][1],$ShoppingListView)
		EndIf
	Next
	Local $B_DESCENDING
	_GUICtrlListViewSort($ShoppingListView,$B_DESCENDING,3)
	_GUICtrlListViewSort($ShoppingListView,$B_DESCENDING,2)
EndFunc

Func SetMainGUISideDropdownContents();resets the value of the side combo in the MainGUI
	Local $SelectedIngred=GUICtrlRead($SideDropdown)
	If _SQLite_GetTable2d($MenuDB,"Select CompSides From MainCourse Where Name='"&StringReplace(GUICtrlRead($MainCourseDropdown),"'","''")&"';",$aResult,$iRows,$iColumns) = $SQLITE_OK AND BitAND(GUICtrlGetState($MainCourseDropdownRadio),$GUI_CHECKED) AND GUICtrlRead($MainCourseDropdown) <> "" AND $iRows > 0 Then
		GUICtrlSetData($SideDropdown,$aResult[1][0]&"|  *Show All...")
	Else
		GUICtrlSetData($SideDropdown,"|  *Show All...")
	EndIf
	If _GUICtrlComboFindString($SideDropdown,$SelectedIngred,1) <> $CB_ERR Then GUICtrlSetData($SideDropdown,$SelectedIngred)
EndFunc

Func SetMainGUIVeggieDropdownContents();resets the value of the veggie combo in the MainGUI
	Local $SelectedIngred=GUICtrlRead($VeggieDropdown)
	If _SQLite_GetTable2d($MenuDB,"Select CompVeggies From MainCourse Where Name='"&StringReplace(GUICtrlRead($MainCourseDropdown),"'","''")&"';",$aResult,$iRows,$iColumns) = $SQLITE_OK AND BitAND(GUICtrlGetState($MainCourseDropdownRadio),$GUI_CHECKED) AND GUICtrlRead($MainCourseDropdown) <> "" AND $iRows > 0 Then
		GUICtrlSetData($VeggieDropdown,$aResult[1][0]&"|  *Show All...")
	Else
		GUICtrlSetData($VeggieDropdown,"|  *Show All...")
	EndIf
	If _GUICtrlComboFindString($VeggieDropdown,$SelectedIngred,1) <> $CB_ERR Then GUICtrlSetData($VeggieDropdown,$SelectedIngred)
EndFunc



Func EditMainCourse($_MCName);the loop for bringing up the 'edit main course' dialog
	Global $EditMainCourseGUI=GUICreate("Edit Main Course:",470,520,-1,-1,-1,-1,$MainGUI)
	GUICtrlCreateLabel("Main Course:",10,5,100,20)
	Global $EditMainCourseName=GUICtrlCreateInput($_MCName,160,5,150,20,$ES_READONLY)
	;Global $EditMainCourseRenameButton=GUICtrlCreateButton("rename",370,5,60,20)
	GUICtrlCreateLabel("Ingredients:",10,35,250,20)
	GUICtrlCreateLabel("Avail. Ingredients:",310,35,250,20)
	Global $EditMainCourseIngredList=GUICtrlCreateListView("Item:                                 |Quant:",10,55,250,80)
	Global $EditMainCourseEditInclButton=GUICtrlCreateButton("Edit...",10,140,50,20)
	Global $EditMainCourseQuantityInput=GUICtrlCreateInput("",135,140,40,20,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
	Global $EditMainCourseQuantityLabel=GUICtrlCreateLabel("",180,143,130,20)
	Global $EditMainCourseIncludeButton=GUICtrlCreateButton("<- add",265,75,40,20)
	Global $EditMainCourseExcludeButton=GUICtrlCreateButton("rem->",265,100,40,20)
	Global $EditMainCourseAvailIngredList=GUICtrlCreateList("",310,55,150,80,$LBS_NOINTEGRALHEIGHT+$GUI_SS_DEFAULT_LIST)
	Global $EditMainCourseEditIngredButton=GUICtrlCreateButton("Edit...",310,140,75,20)
	Global $EditMainCourseNewIngredButton=GUICtrlCreateButton("New...",385,140,75,20)
	GUICtrlCreateLabel("Recipe:",10,170,100,20)
	Global $EditMainCourseRecipeInput=GUICtrlCreateEdit("",10,190,450,140)
	GUICtrlCreateLabel("Favorite Sides:",30,340,150,20)
	Global $EditMainCourseSidesList=GUICtrlCreateTreeView(30,360,183,80,$GUI_SS_DEFAULT_TREEVIEW+$TVS_CHECKBOXES)
	Global $EditMainCourseNewSideButton=GUICtrlCreateButton("New...",30,445,75,20)
	Global $EditMainCourseEditSideButton=GUICtrlCreateButton("Edit...",138,445,75,20)
	GUICtrlCreateLabel("Favorite Veggies:",257,340,150,20)
	Global $EditMainCourseVeggiesList=GUICtrlCreateTreeView(257,360,183,80,$GUI_SS_DEFAULT_TREEVIEW+$TVS_CHECKBOXES)
	Global $EditMainCourseNewVeggieButton=GUICtrlCreateButton("New...",257,445,75,20)
	Global $EditMainCourseEditVeggieButton=GUICtrlCreateButton("Edit...",365,445,75,20)
	Global $EditMainCourseDeleteButton=GUICtrlCreateButton("Delete",100,490,75,20)
	Global $EditMainCourseCancelButton=GUICtrlCreateButton("Cancel",197,490,76,20)
	Global $EditMainCourseSaveButton=GUICtrlCreateButton("Save",295,490,75,20,$BS_DEFPUSHBUTTON)
	
	SetMainCourseIngreds()
	SetMainCourseCompSides()
	SetMainCourseCompVeggies()
	
	_SQLite_GetTable2d($MenuDB,"Select Recipe From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 Then GUICtrlSetData($EditMainCourseRecipeInput,$aResult[1][0])
	
	_SQLite_Exec($MenuDB,"Begin")
	
	GUISetState(@SW_DISABLE,$MainGUI)
	GUISetState(@SW_SHOW,$EditMainCourseGUI)
	While 1
		$msg=GUIGetMsg()
		If $msg <> 0 Then
			Switch $msg
				Case $GUI_EVENT_CLOSE
					_SQLite_Exec($MenuDB,"Rollback")
					ExitLoop
				Case $EditMainCourseCancelButton
					_SQLite_Exec($MenuDB,"Rollback")
					ExitLoop
				Case $EditMainCourseSaveButton
					_SQLite_Exec($MenuDB,"Commit");commits ingredients included/excluded and quantites from the ingreds list
					
					Local $ListContents=""
					For $n=1 To $CompSidesTreeViewItems[0][0]
						If BitAND(GUICtrlRead($CompSidesTreeViewItems[$n][0]),$GUI_CHECKED) Then $ListContents&="|"&$CompSidesTreeViewItems[$n][1]
					Next
					_SQLite_Exec($MenuDB,"update MainCourse set CompSides='"&StringReplace($ListContents,"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
					
					Local $ListContents=""
					For $n=1 To $CompVeggiesTreeViewItems[0][0]
						If BitAND(GUICtrlRead($CompVeggiesTreeViewItems[$n][0]),$GUI_CHECKED) Then $ListContents&="|"&$CompVeggiesTreeViewItems[$n][1]
					Next
					_SQLite_Exec($MenuDB,"update MainCourse set CompVeggies='"&StringReplace($ListContents,"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
					
					ExitLoop
				Case $EditMainCourseDeleteButton
					If MsgBox(20,"Warning!","You are about to delete this main course - are you sure you want to do this?") = 6 Then
						_SQLite_Exec($MenuDB,"Delete From MainCourse where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
						$MenuArray[$CurrDayButton][0]=""
						
						_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
						Local $DropdownValue=""
						For $n=1 To $iRows
							$DropdownValue&="|"&$aResult[$n][0]
						Next
						GUICtrlSetData($MainCourseDropdown,$DropdownValue)
						_SQLite_Exec($MenuDB,"Commit")
						ExitLoop
					EndIf
				Case $EditMainCourseEditInclButton
					If GUICtrlRead($EditMainCourseIngredList) <> "" Then
						EditIngred(StringLeft(GUICtrlRead(GUICtrlRead($EditMainCourseIngredList)),StringInStr(GUICtrlRead(GUICtrlRead($EditMainCourseIngredList)),"|",0,-1)-1),$EditMainCourseGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetMainCourseIngreds()
					Else
						MsgBox(16,"Error","You must select an ingredient to edit!")
					EndIf
				Case $EditMainCourseEditIngredButton
					If GUICtrlRead($EditMainCourseAvailIngredList) <> "" Then
						EditIngred(GUICtrlRead($EditMainCourseAvailIngredList),$EditMainCourseGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetMainCourseIngreds()
					Else
						MsgBox(16,"Error","You must select an ingredient to edit!")
					EndIf
				Case $EditMainCourseNewIngredButton
					$EditCompName=InputBox("New Ingredient name:","Please enter the name of the new ingredient:",""," M",200,-1)
					If NOT @error AND $EditCompName <> "" Then
						If StringRegExp($EditCompName,"[][+|\\*?.\^)(]") = 1 Then
							MsgBox(16,"Error","Sorry, ingredient names cannot contain any of the following characters:"&@CRLF&@CRLF&"[ ] + | \ * ? . ^ ( )")
							ContinueLoop
						EndIf
						_SQLite_Exec($MenuDB,"insert into Ingredients(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
						EditIngred($EditCompName,$EditMainCourseGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetMainCourseIngreds()
					EndIf
				Case $EditMainCourseNewSideButton
					$EditCompName=InputBox("New Side name:","Please enter the name of the new side dish:",""," M",200,-1)
					If NOT @error AND $EditCompName <> "" Then
						_SQLite_Exec($MenuDB,"insert into Sides(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
						EditSide("Side",$EditCompName,$EditMainCourseGUI)
						GUISwitch($EditMainCourseGUI)
						For $n=1 To $CompSidesTreeViewItems[0][0]
							GUICtrlDelete($CompSidesTreeViewItems[$n][0])
						Next
						SetMainCourseCompSides()
					EndIf
				Case $EditMainCourseEditSideButton
					If GUICtrlRead($EditMainCourseSidesList) <> "" Then
						Local $SideToEdit=""
						For $n=1 To $CompSidesTreeViewItems[0][0]
							If $CompSidesTreeViewItems[$n][0] = GUICtrlRead($EditMainCourseSidesList) Then
								$SideToEdit=$CompSidesTreeViewItems[$n][1]
								ExitLoop
							EndIf
						Next
						If $SideToEdit <> "" Then
							EditSide("Side",$SideToEdit,$EditMainCourseGUI)
							GUISwitch($EditMainCourseGUI)
							For $n=1 To $CompSidesTreeViewItems[0][0]
								GUICtrlDelete($CompSidesTreeViewItems[$n][0])
							Next
							SetMainCourseCompSides()
						EndIf
					Else
						MsgBox(16,"Error","You must select an side dish to edit!")
					EndIf
				Case $EditMainCourseNewVeggieButton
					$EditCompName=InputBox("New Veggie name:","Please enter the name of the new veggie:",""," M",200,-1)
					If NOT @error AND $EditCompName <> "" Then
						_SQLite_Exec($MenuDB,"insert into Veggies(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
						EditSide("Veggie",$EditCompName,$EditMainCourseGUI)
						GUISwitch($EditMainCourseGUI)
						For $n=1 To $CompVeggiesTreeViewItems[0][0]
							GUICtrlDelete($CompVeggiesTreeViewItems[$n][0])
						Next
						SetMainCourseCompVeggies()
					EndIf
				Case $EditMainCourseEditVeggieButton
					If GUICtrlRead($EditMainCourseVeggiesList) <> "" Then
						Local $SideToEdit=""
						For $n=1 To $CompVeggiesTreeViewItems[0][0]
							If $CompVeggiesTreeViewItems[$n][0] = GUICtrlRead($EditMainCourseVeggiesList) Then
								$SideToEdit=$CompVeggiesTreeViewItems[$n][1]
								ExitLoop
							EndIf
						Next
						If $SideToEdit <> "" Then
							EditSide("Veggie",$SideToEdit,$EditMainCourseGUI)
							GUISwitch($EditMainCourseGUI)
							For $n=1 To $CompVeggiesTreeViewItems[0][0]
								GUICtrlDelete($CompVeggiesTreeViewItems[$n][0])
							Next
							SetMainCourseCompVeggies()
						EndIf
					Else
						MsgBox(16,"Error","You must select a veggie to edit!")
					EndIf
				Case $EditMainCourseExcludeButton
					If GUICtrlRead($EditMainCourseIngredList) <> "" Then
						_SQLite_GetTable2d($MenuDB,"Select Ingredients From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
						If $aResult[1][0] <> "" AND $iRows > 0 Then
							Local $ValueToDelete=StringLeft(GUICtrlRead(GUICtrlRead($EditMainCourseIngredList)),StringInStr(GUICtrlRead(GUICtrlRead($EditMainCourseIngredList)),"|",0,-1)-1)
							$aResult[1][0]=StringRegExpReplace($aResult[1][0],"(\|"&$ValueToDelete&"~){1}[0-9]*","")
							_SQLite_Exec($MenuDB,"update MainCourse set Ingredients='"&StringReplace($aResult[1][0],"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
							For $n=1 To $IngredListViewItems[0][0]
								GUICtrlDelete($IngredListViewItems[$n][0])
							Next
							SetMainCourseIngreds()
						EndIf
					EndIf
				Case $EditMainCourseIncludeButton
					If GUICtrlRead($EditMainCourseAvailIngredList) <> "" Then
						_SQLite_GetTable2d($MenuDB,"Select Ingredients From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
						If $iRows > 0 Then
							_SQLite_Exec($MenuDB,"update MainCourse set Ingredients='"&StringReplace($aResult[1][0],"'","''")&"|"&StringReplace(GUICtrlRead($EditMainCourseAvailIngredList),"'","''")&"~1' where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
						EndIf
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetMainCourseIngreds()
					EndIf
				Case Else
					For $n=1 To $IngredListViewItems[0][0]
						If $IngredListViewItems[$n][1] = "" Then
							$IngredListViewItems[$n][1]="0"
							GUICtrlSetData($IngredListViewItems[$n][0],GUICtrlRead($IngredListViewItems[$n][0])&"0")
						EndIf
						If $msg=$IngredListViewItems[$n][0] Then
							$SelectedIngred=StringSplit(GUICtrlRead($msg),"|")
							_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace($SelectedIngred[1],"'","''")&"';",$aResult,$iRows,$iColumns)
							GUICtrlSetData($EditMainCourseQuantityInput,$SelectedIngred[2])
							GUICtrlSetData($EditMainCourseQuantityLabel,$aResult[1][0])
							ContinueLoop 2
						EndIf
					Next
			EndSwitch
		EndIf
		If GUICtrlRead($EditMainCourseIngredList) = "" AND (GUICtrlRead($EditMainCourseQuantityInput) <> "" OR GUICtrlRead($EditMainCourseQuantityLabel)) <> "" Then
			GUICtrlSetData($EditMainCourseQuantityInput,"")
			GUICtrlSetData($EditMainCourseQuantityLabel,"")
		EndIf
		If _GUICtrlEditGetModify($EditMainCourseQuantityInput) <> 0 AND GUICtrlRead($EditMainCourseIngredList) <> "" Then
			_GUICtrlEditSetModify($EditMainCourseQuantityInput,False)
			For $n=1 To $IngredListViewItems[0][0]
				If $IngredListViewItems[$n][0] = GUICtrlRead($EditMainCourseIngredList) Then
					$IngredListViewItems[$n][1]=GUICtrlRead($EditMainCourseQuantityInput)
					GUICtrlSetData($IngredListViewItems[$n][0],StringLeft(GUICtrlRead($IngredListViewItems[$n][0]),StringInStr(GUICtrlRead($IngredListViewItems[$n][0]),"|",0,-1)-1) & "|" & $IngredListViewItems[$n][1])
					Local $LastValue=GUICtrlRead($IngredListViewItems[$n][0])
					Local $ListContents=""
					For $n=1 To $IngredListViewItems[0][0]
						$ListContents&="|"&StringReplace(GUICtrlRead($IngredListViewItems[$n][0]),"|","~")
						GUICtrlDelete($IngredListViewItems[$n][0])
					Next
					_SQLite_Exec($MenuDB,"update MainCourse set Ingredients='"&StringReplace($ListContents,"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';")
					SetMainCourseIngreds()
					For $n=1 To $IngredListViewItems[0][0]
						If GUICtrlRead($IngredListViewItems[$n][0]) = $LastValue Then
							GUICtrlSetState($IngredListViewItems[$n][0],$GUI_FOCUS)
							ExitLoop
						EndIf
					Next
					$SelectedIngred=StringSplit($LastValue,"|")
					_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace($SelectedIngred[1],"'","''")&"';",$aResult,$iRows,$iColumns)
					GUICtrlSetData($EditMainCourseQuantityInput,$SelectedIngred[2])
					GUICtrlSetData($EditMainCourseQuantityLabel,$aResult[1][0])
					ExitLoop
				EndIf
			Next
		EndIf
		Sleep(15);take less CPU
	WEnd
	GUISetState(@SW_ENABLE,$MainGUI)
	GUIDelete($EditMainCourseGUI)
	GUISwitch($MainGUI)
	_SQLite_GetTable2d($MenuDB,"Select Name From MainCourse;",$aResult,$iRows,$iColumns)
	Local $DropdownValue=""
	For $n=1 To $iRows
		$DropdownValue&="|"&$aResult[$n][0]
	Next
	GUICtrlSetData($MainCourseDropdown,$DropdownValue)
EndFunc

Func SetMainCourseIngreds();used by EditMainCourse to set the ingredients-related lists
	GUISwitch($EditMainCourseGUI)
	Global $IngredListViewItems[1][2]=[["0"]]
	_SQLite_GetTable2d($MenuDB,"Select Ingredients From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
	Local $ListArray[1]=["0"]
	If $aResult[1][0] <> "" AND $iRows > 0 Then
		$ListArray=StringSplit(StringTrimLeft($aResult[1][0],1),"|")
		If IsArray($ListArray) Then
			For $n=1 To $ListArray[0]
				$IngredListViewItems[0][0]+=1
				ReDim $IngredListViewItems[$IngredListViewItems[0][0]+1][2]
				$IngredListViewItems[$IngredListViewItems[0][0]][0]=GUICtrlCreateListViewItem(StringLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)-1)&"|"&StringTrimLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)),$EditMainCourseIngredList)
				$IngredListViewItems[$IngredListViewItems[0][0]][1]=StringTrimLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1))
			Next
		EndIf
	EndIf
	
	_SQLite_GetTable2d($MenuDB,"Select Name From Ingredients;",$aResult,$iRows,$iColumns)
	Local $ListContents=""
	For $n=1 To $iRows
		$ListContents&="|"&$aResult[$n][0]
	Next
	If $ListArray[0] > 0 Then
		For $n=1 To $ListArray[0]
			$ListContents=StringReplace($ListContents,"|"&StringLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)-1),"")
		Next
	EndIf
	GUICtrlSetData($EditMainCourseAvailIngredList,$ListContents)
	
	GUICtrlSetData($EditMainCourseQuantityInput,"")
	GUICtrlSetData($EditMainCourseQuantityLabel,"")
EndFunc

Func SetMainCourseCompSides();used by EditMainCourse to set the list of complimentary sides
		Global $CompSidesTreeViewItems[1][2]=[["0"]];ctrl id,text
	_SQLite_GetTable2d($MenuDB,"Select Name From Sides",$aResult,$iRows,$iColumns)
	For $n=1 To $iRows
		$CompSidesTreeViewItems[0][0]+=1
		ReDim $CompSidesTreeViewItems[$CompSidesTreeViewItems[0][0]+1][2]
		$CompSidesTreeViewItems[$CompSidesTreeViewItems[0][0]][0]=GUICtrlCreateTreeViewItem($aResult[$n][0],$EditMainCourseSidesList)
		$CompSidesTreeViewItems[$CompSidesTreeViewItems[0][0]][1]=$aResult[$n][0]
	Next
	_SQLite_GetTable2d($MenuDB,"Select CompSides From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 Then
		$ListArray=StringSplit(StringTrimLeft($aResult[1][0],1),"|")
		For $n=1 To $ListArray[0]
			For $x=1 To $CompSidesTreeViewItems[0][0]
				If $CompSidesTreeViewItems[$x][1] = $ListArray[$n] Then
					GUICtrlSetState($CompSidesTreeViewItems[$x][0],$GUI_CHECKED)
					ContinueLoop 2
				EndIf
			Next
		Next
	EndIf
EndFunc

Func SetMainCourseCompVeggies();used by EditMainCourse to set the list of complimentary veggies
	Global $CompVeggiesTreeViewItems[1][2]=[["0"]];ctrl id,text
	_SQLite_GetTable2d($MenuDB,"Select Name From Veggies",$aResult,$iRows,$iColumns)
	For $n=1 To $iRows
		$CompVeggiesTreeViewItems[0][0]+=1
		ReDim $CompVeggiesTreeViewItems[$CompVeggiesTreeViewItems[0][0]+1][2]
		$CompVeggiesTreeViewItems[$CompVeggiesTreeViewItems[0][0]][0]=GUICtrlCreateTreeViewItem($aResult[$n][0],$EditMainCourseVeggiesList)
		$CompVeggiesTreeViewItems[$CompVeggiesTreeViewItems[0][0]][1]=$aResult[$n][0]
	Next
	_SQLite_GetTable2d($MenuDB,"Select CompVeggies From MainCourse Where Name='"&StringReplace(GUICtrlRead($EditMainCourseName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 Then
		$ListArray=StringSplit(StringTrimLeft($aResult[1][0],1),"|")
		For $n=1 To $ListArray[0]
			For $x=1 To $CompVeggiesTreeViewItems[0][0]
				If $CompVeggiesTreeViewItems[$x][1] = $ListArray[$n] Then
					GUICtrlSetState($CompVeggiesTreeViewItems[$x][0],$GUI_CHECKED)
					ContinueLoop 2
				EndIf
			Next
		Next
	EndIf
EndFunc

Func EditSide($_SType,$_SName,$_SParent);the loop for bringing up either the 'edit veggie dish' or 'edit side dish' dialog
	Global $EditSideGUI=GUICreate("Edit "&$_SType&":",470,380,-1,-1,-1,-1,$_SParent)
	GUICtrlCreateLabel($_SType&":",10,5,100,20)
	Global $EditSideName=GUICtrlCreateInput($_SName,160,5,150,20,$ES_READONLY)
	;Global $EditSideRenameButton=GUICtrlCreateButton("rename",270,5,60,20)
	GUICtrlCreateLabel("Ingredients:",10,35,250,20)
	GUICtrlCreateLabel("Avail. Ingredients:",310,35,150,20)
	Global $EditSideIngredList=GUICtrlCreateListView("Item:                                 |Quant:",10,55,250,80)
	Global $EditSideEditInclButton=GUICtrlCreateButton("Edit...",10,140,50,20)
	Global $EditSideQuantityInput=GUICtrlCreateInput("",135,140,30,20,$GUI_SS_DEFAULT_INPUT+$ES_NUMBER)
	Global $EditSideQuantityLabel=GUICtrlCreateLabel("",170,143,130,20)
	Global $EditSideIncludeButton=GUICtrlCreateButton("<- add",265,75,40,20)
	Global $EditSideExcludeButton=GUICtrlCreateButton("rem->",265,100,40,20)
	Global $EditSideAvailIngredList=GUICtrlCreateList("",310,55,150,80)
	Global $EditSideEditIngredButton=GUICtrlCreateButton("Edit...",310,140,75,20)
	Global $EditSideNewIngredButton=GUICtrlCreateButton("New...",385,140,75,20)
	GUICtrlCreateLabel("Recipe:",10,170,200,20)
	Global $EditSideRecipeInput=GUICtrlCreateEdit("",10,190,450,140)
	Global $EditSideDeleteButton=GUICtrlCreateButton("Delete",100,350,75,20)
	Global $EditSideCancelButton=GUICtrlCreateButton("Cancel",197,350,76,20)
	Global $EditSideSaveButton=GUICtrlCreateButton("Save",295,350,75,20,$BS_DEFPUSHBUTTON)
	
	SetSideIngreds($_SType)
	
	_SQLite_GetTable2d($MenuDB,"Select Recipe From "&$_SType&"s Where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 Then GUICtrlSetData($EditSideRecipeInput,$aResult[1][0])
	
	Local $SelfContainedTransactions=0
	If $_SParent = $MainGUI Then
		_SQLite_Exec($MenuDB,"Begin")
		$SelfContainedTransactions=1
	EndIf
	
	GUISetState(@SW_DISABLE,$_SParent)
	GUISetState(@SW_SHOW,$EditSideGUI)
	While 1
		$msg=GUIGetMsg()
		If $msg <> 0 Then
			Switch $msg
				Case $GUI_EVENT_CLOSE
					If $SelfContainedTransactions Then _SQLite_Exec($MenuDB,"Rollback")
					ExitLoop
				Case $EditSideCancelButton
					If $SelfContainedTransactions Then _SQLite_Exec($MenuDB,"Rollback")
					ExitLoop
				Case $EditSideSaveButton
					If $SelfContainedTransactions Then _SQLite_Exec($MenuDB,"Commit");commits ingredients included/excluded and quantites from the ingreds list
					_SQLite_Exec($MenuDB,"update "&$_SType&"s set Recipe='"&StringReplace(GUICtrlRead($EditSideRecipeInput),"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';")
					ExitLoop
				Case $EditSideDeleteButton
					If MsgBox(20,"Warning!","You are about to delete this "&$_SType&" - are you sure you want to do this?") = 6 Then
						_SQLite_Exec($MenuDB,"Delete From "&$_SType&"s where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';")
						If $_SType="Side" Then
							$MenuArray[$CurrDayButton][1]=""
							_SQLite_GetTable2d($MenuDB,"Select Name From Sides;",$aResult,$iRows,$iColumns)
							Local $DropdownValue=""
							For $n=1 To $iRows
								$DropdownValue&="|"&$aResult[$n][0]
							Next
							GUICtrlSetData($SideDropdown,$DropdownValue)
							_SQLite_GetTable2d($MenuDB,"Select Name,CompSides From MainCourse where CompSides Like '%|"&GUICtrlRead($EditSideName)&"%';",$aResult,$iRows,$iColumns)
							If $iRows > 0 Then
								For $n=1 To $iRows
									_SQLite_Exec($MenuDB,"update MainCourse set CompSides='"&StringReplace($aResult[$n][1],"|"&StringReplace(GUICtrlRead($EditSideName),"'","''"),"")&"' where Name='"&StringReplace($aResult[$n][0],"'","''")&"';")
								Next
							EndIf
						ElseIf $_SType="Veggie" Then
							$MenuArray[$CurrDayButton][2]=""
							_SQLite_GetTable2d($MenuDB,"Select Name From Veggies;",$aResult,$iRows,$iColumns)
							Local $DropdownValue=""
							For $n=1 To $iRows
								$DropdownValue&="|"&$aResult[$n][0]
							Next
							GUICtrlSetData($VeggieDropdown,$DropdownValue)
							_SQLite_GetTable2d($MenuDB,"Select Name,CompVeggies From MainCourse where CompVeggies Like '%|"&GUICtrlRead($EditSideName)&"%';",$aResult,$iRows,$iColumns)
							If $iRows > 0 Then
								For $n=1 To $iRows
									_SQLite_Exec($MenuDB,"update MainCourse set CompVeggies='"&StringReplace($aResult[$n][1],"|"&StringReplace(GUICtrlRead($EditSideName),"'","''"),"")&"' where Name='"&StringReplace($aResult[$n][0],"'","''")&"';")
								Next
							EndIf
						EndIf
						_SQLite_Exec($MenuDB,"Commit")
						ExitLoop
					EndIf
				Case $EditSideEditInclButton
					If GUICtrlRead($EditSideIngredList) <> "" Then
						EditIngred(StringLeft(GUICtrlRead(GUICtrlRead($EditSideIngredList)),StringInStr(GUICtrlRead(GUICtrlRead($EditSideIngredList)),"|",0,-1)-1),$EditSideGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetSideIngreds($_SType)
					Else
						MsgBox(16,"Error","You must select an ingredient to edit!")
					EndIf
				Case $EditSideEditIngredButton
					If GUICtrlRead($EditSideAvailIngredList) <> "" Then
						EditIngred(GUICtrlRead($EditSideAvailIngredList),$EditSideGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetSideIngreds($_SType)
					Else
						MsgBox(16,"Error","You must select an ingredient to edit!")
					EndIf
				Case $EditSideNewIngredButton
					$EditCompName=InputBox("New Ingredient name:","Please enter the name of the new ingredient:",""," M",200,-1)
					If NOT @error AND $EditCompName <> "" Then
						If StringRegExp($EditCompName,"[][+|\\*?.\^)(]") = 1 Then
							MsgBox(16,"Error","Sorry, ingredient names cannot contain any of the following characters:"&@CRLF&@CRLF&"[ ] + | \ * ? . ^ ( )")
							ContinueLoop
						EndIf
						_SQLite_Exec($MenuDB,"insert into Ingredients(Name) values('"&StringReplace($EditCompName,"'","''")&"');")
						EditIngred($EditCompName,$EditSideGUI)
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetSideIngreds($_SType)
					EndIf
				Case $EditSideExcludeButton
					If GUICtrlRead($EditSideIngredList) <> "" Then
						_SQLite_GetTable2d($MenuDB,"Select Ingredients From "&$_SType&"s Where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';",$aResult,$iRows,$iColumns)
						If $aResult[1][0] <> "" AND $iRows > 0 Then
							Local $ValueToDelete=StringLeft(GUICtrlRead(GUICtrlRead($EditSideIngredList)),StringInStr(GUICtrlRead(GUICtrlRead($EditSideIngredList)),"|",0,-1)-1)
							$aResult[1][0]=StringRegExpReplace($aResult[1][0],"(\|"&$ValueToDelete&"~){1}[0-9]*","")
							_SQLite_Exec($MenuDB,"update "&$_SType&"s set Ingredients='"&StringReplace($aResult[1][0],"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';")
							For $n=1 To $IngredListViewItems[0][0]
								GUICtrlDelete($IngredListViewItems[$n][0])
							Next
							SetSideIngreds($_SType)
						EndIf
					EndIf
				Case $EditSideIncludeButton
					If GUICtrlRead($EditSideAvailIngredList) <> "" Then
						_SQLite_GetTable2d($MenuDB,"Select Ingredients From "&$_SType&"s Where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';",$aResult,$iRows,$iColumns)
						If $iRows > 0 Then
							_SQLite_Exec($MenuDB,"update "&$_SType&"s set Ingredients='"&StringReplace($aResult[1][0],"'","''")&"|"&StringReplace(GUICtrlRead($EditSideAvailIngredList),"'","''")&"~1' where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';")
						EndIf
						For $n=1 To $IngredListViewItems[0][0]
							GUICtrlDelete($IngredListViewItems[$n][0])
						Next
						SetSideIngreds($_SType)
					EndIf
				Case Else
					For $n=1 To $IngredListViewItems[0][0]
						If $IngredListViewItems[$n][1] = "" Then
							$IngredListViewItems[$n][1]="0"
							GUICtrlSetData($IngredListViewItems[$n][0],GUICtrlRead($IngredListViewItems[$n][0])&"0")
						EndIf
						If $msg=$IngredListViewItems[$n][0] Then
							$SelectedIngred=StringSplit(GUICtrlRead($msg),"|")
							_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace($SelectedIngred[1],"'","''")&"';",$aResult,$iRows,$iColumns)
							GUICtrlSetData($EditSideQuantityInput,$SelectedIngred[2])
							If $aResult[1][0] <> "" Then GUICtrlSetData($EditSideQuantityLabel,$aResult[1][0])
							ContinueLoop 2
						EndIf
					Next
			EndSwitch
		EndIf
		If GUICtrlRead($EditSideIngredList) = "" AND (GUICtrlRead($EditSideQuantityInput) <> "" OR GUICtrlRead($EditSideQuantityLabel)) <> "" Then
			GUICtrlSetData($EditSideQuantityInput,"")
			GUICtrlSetData($EditSideQuantityLabel,"")
		EndIf
		If _GUICtrlEditGetModify($EditSideQuantityInput) <> 0 AND GUICtrlRead($EditSideIngredList) <> "" Then
			_GUICtrlEditSetModify($EditSideQuantityInput,False)
			For $n=1 To $IngredListViewItems[0][0]
				If $IngredListViewItems[$n][0] = GUICtrlRead($EditSideIngredList) Then
					$IngredListViewItems[$n][1]=GUICtrlRead($EditSideQuantityInput)
					GUICtrlSetData($IngredListViewItems[$n][0],StringLeft(GUICtrlRead($IngredListViewItems[$n][0]),StringInStr(GUICtrlRead($IngredListViewItems[$n][0]),"|",0,-1)-1) & "|" & $IngredListViewItems[$n][1])
					Local $LastValue=GUICtrlRead($IngredListViewItems[$n][0])
					Local $ListContents=""
					For $n=1 To $IngredListViewItems[0][0]
						$ListContents&="|"&StringReplace(GUICtrlRead($IngredListViewItems[$n][0]),"|","~")
						GUICtrlDelete($IngredListViewItems[$n][0])
					Next
					_SQLite_Exec($MenuDB,"update "&$_SType&"s set Ingredients='"&StringReplace($ListContents,"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';")
					SetSideIngreds($_SType)
					For $n=1 To $IngredListViewItems[0][0]
						If GUICtrlRead($IngredListViewItems[$n][0]) = $LastValue Then
							GUICtrlSetState($IngredListViewItems[$n][0],$GUI_FOCUS)
							ExitLoop
						EndIf
					Next
					$SelectedIngred=StringSplit($LastValue,"|")
					_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace($SelectedIngred[1],"'","''")&"';",$aResult,$iRows,$iColumns)
					GUICtrlSetData($EditSideQuantityInput,$SelectedIngred[2])
					GUICtrlSetData($EditSideQuantityLabel,$aResult[1][0])
					ExitLoop
				EndIf
			Next
		EndIf
		Sleep(15);take less CPU
	WEnd
	GUISetState(@SW_ENABLE,$_SParent)
	GUIDelete($EditSideGUI)
	If $_SType="Side" Then SetMainGUISideDropdownContents()
	If $_SType="Veggie" Then SetMainGUIVeggieDropdownContents()
EndFunc

Func SetSideIngreds($_SType);used by EditSide to set the ingredients-related lists
	GUISwitch($EditSideGUI)
	Global $IngredListViewItems[1][2]=[["0"]]
	_SQLite_GetTable2d($MenuDB,"Select Ingredients From "&$_SType&"s Where Name='"&StringReplace(GUICtrlRead($EditSideName),"'","''")&"';",$aResult,$iRows,$iColumns)
	Local $ListContents=""
	Local $ListArray[1]=["0"]
	If $aResult[1][0] <> "" AND $iRows > 0 Then
		$ListArray=StringSplit(StringTrimLeft($aResult[1][0],1),"|")
		If IsArray($ListArray) Then
			For $n=1 To $ListArray[0]
				$IngredListViewItems[0][0]+=1
				ReDim $IngredListViewItems[$IngredListViewItems[0][0]+1][2]
				$IngredListViewItems[$IngredListViewItems[0][0]][0]=GUICtrlCreateListViewItem(StringLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)-1)&"|"&StringTrimLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)),$EditSideIngredList)
				$IngredListViewItems[$IngredListViewItems[0][0]][1]=StringTrimLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1))
				$ListContents&="|"&$ListArray[$n]
			Next
		EndIf
	EndIf
	
	_SQLite_GetTable2d($MenuDB,"Select Name From Ingredients;",$aResult,$iRows,$iColumns)
	Local $ListContents=""
	For $n=1 To $iRows
		$ListContents&="|"&$aResult[$n][0]
	Next
	If $ListArray[0] > 0 Then
		For $n=1 To $ListArray[0]
			$ListContents=StringReplace($ListContents,"|"&StringLeft($ListArray[$n],StringInStr($ListArray[$n],"~",0,-1)-1),"")
		Next
	EndIf
	GUICtrlSetData($EditSideAvailIngredList,$ListContents)
	
	GUICtrlSetData($EditSideQuantityInput,"")
	GUICtrlSetData($EditSideQuantityLabel,"")
EndFunc

Func EditIngred($_IName,$_IParent);the loop for bringing up the 'edit ingredients' dialog
	$EditIngredGUI=GUICreate("Edit Ingredient:",420,130,-1,-1,-1,-1,$_IParent)
	GUICtrlCreateLabel("Ingredient:",10,5,80,20)
	$EditIngredName=GUICtrlCreateInput($_IName,140,5,150,20,$ES_READONLY)
	;$EditIngredRenameButton=GUICtrlCreateButton("rename",250,5,60,20)
	GUICtrlCreateLabel("Store:",10,35,160,20)
	$EditIngredStoreCombo=GUICtrlCreateCombo("",10,55,160,20,$GUI_SS_DEFAULT_COMBO+$CBS_SORT)
	GUICtrlCreateLabel("Aisle:",180,35,50,20)
	$EditIngredAisleInput=GUICtrlCreateInput("",180,55,50,20)
	GUICtrlCreateLabel("Purchase units: (lbs, etc)",250,35,160,25)
	$EditIngredUnitsCombo=GUICtrlCreateCombo("",250,55,160,20,$GUI_SS_DEFAULT_COMBO+$CBS_SORT)
	$EditIngredDeleteButton=GUICtrlCreateButton("Delete",75,100,75,20)
	$EditIngredCancelButton=GUICtrlCreateButton("Cancel",172,100,76,20)
	$EditIngredSaveButton=GUICtrlCreateButton("Save",270,100,75,20,$BS_DEFPUSHBUTTON)	
	
	_SQLite_GetTable2d($MenuDB,"Select Store From Ingredients Group By Store",$aResult,$iRows,$iColumns)
	Local $DropdownValue=""
	For $n=1 To $iRows
		$DropdownValue&="|"&$aResult[$n][0]
	Next
	_SQLite_GetTable2d($MenuDB,"Select Store From Ingredients Where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 AND $aResult[1][0] <> "" Then
		GUICtrlSetData($EditIngredStoreCombo,$DropdownValue,$aResult[1][0])
	Else
		GUICtrlSetData($EditIngredStoreCombo,$DropdownValue)
	EndIf
	
	_SQLite_GetTable2d($MenuDB,"Select Aisle From Ingredients Where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 AND $aResult[1][0] <> "" Then
		GUICtrlSetData($EditIngredAisleInput,$aResult[1][0])
	EndIf
	
	_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Group By Units",$aResult,$iRows,$iColumns)
	Local $DropdownValue=""
	For $n=1 To $iRows
		$DropdownValue&="|"&$aResult[$n][0]
	Next
	_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';",$aResult,$iRows,$iColumns)
	If $iRows > 0 AND $aResult[1][0] <> "" Then
		GUICtrlSetData($EditIngredUnitsCombo,$DropdownValue,$aResult[1][0])
	Else
		GUICtrlSetData($EditIngredUnitsCombo,$DropdownValue)
	EndIf

	
	GUISetState(@SW_DISABLE,$_IParent)
	GUISetState(@SW_SHOW,$EditIngredGUI)
	Local $oldStoreString=""
	Local $oldUnitsString=""
	While 1
		$msg=GUIGetMsg()
		If $msg <> 0 Then
			Switch $msg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $EditIngredCancelButton
					ExitLoop
				Case $EditIngredSaveButton
					_SQLite_Exec($MenuDB,"update Ingredients set Store='"&StringReplace(GUICtrlRead($EditIngredStoreCombo),"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';")
					_SQLite_Exec($MenuDB,"update Ingredients set Aisle='"&StringReplace(GUICtrlRead($EditIngredAisleInput),"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';")
					_SQLite_Exec($MenuDB,"update Ingredients set Units='"&StringReplace(GUICtrlRead($EditIngredUnitsCombo),"'","''")&"' where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';")
					ExitLoop
				Case $EditIngredDeleteButton
					If MsgBox(20,"Warning!","You are about to delete this ingredient - are you sure you want to do this?") = 6 Then
						_SQLite_Exec($MenuDB,"Delete From Ingredients where Name='"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"';")
						_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From MainCourse where Ingredients Like '%|"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"%';",$aResult,$iRows,$iColumns)
						If $iRows > 0 Then
							For $n=1 To $iRows
								_SQLite_Exec($MenuDB,"update MainCourse set Ingredients='"&StringReplace(StringRegExpReplace($aResult[$n][1],"(\|"&GUICtrlRead($EditIngredName)&"~){1}[0-9]*",""),"'","''")&"' where Name='"&StringReplace($aResult[$n][0],"'","''")&"';")
							Next
						EndIf
						_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From Sides where Ingredients Like '%|"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"%';",$aResult,$iRows,$iColumns)
						If $iRows > 0 Then
							For $n=1 To $iRows
								_SQLite_Exec($MenuDB,"update Sides set Ingredients='"&StringReplace(StringRegExpReplace($aResult[$n][1],"(\|"&GUICtrlRead($EditIngredName)&"~){1}[0-9]*",""),"'","''")&"' where Name='"&StringReplace($aResult[$n][0],"'","''")&"';")
							Next
						EndIf
						_SQLite_GetTable2d($MenuDB,"Select Name,Ingredients From Veggies where Ingredients Like '%|"&StringReplace(GUICtrlRead($EditIngredName),"'","''")&"%';",$aResult,$iRows,$iColumns)
						If $iRows > 0 Then
							For $n=1 To $iRows
								_SQLite_Exec($MenuDB,"update Veggies set Ingredients='"&StringReplace(StringRegExpReplace($aResult[$n][1],"(\|"&GUICtrlRead($EditIngredName)&"~){1}[0-9]*",""),"'","''")&"' where Name='"&StringReplace($aResult[$n][0],"'","''")&"';")
							Next
						EndIf
						ExitLoop
					EndIf
			EndSwitch
		EndIf
		_AutoComplete($EditIngredStoreCombo,$oldStoreString)
		_AutoComplete($EditIngredUnitsCombo,$oldUnitsString)
		Sleep(15);take less CPU
	WEnd
	GUISetState(@SW_ENABLE,$_IParent)
	GUIDelete($EditIngredGUI)
EndFunc

Func AddToShoppingList();the loop for bringing up the 'add to shopping list' dialog
	Global $AddToListGUI=GUICreate("Add item to shopping list",420,200,-1,-1,-1,-1,$MainGUI)
	GUIStartGroup($AddToListGUI)
	Global $AddToListRestoreRadio=GUICtrlCreateRadio("Restore an item that you've removed from your shopping list:",10,10,180,40,$BS_MULTILINE)
	Global $AddToListRestoreList=GUICtrlCreateList("",10,50,190,130)
	GUICtrlSetState(-1,$GUI_DISABLE)
	Global $AddToListNewRadio=GUICtrlCreateRadio("Add an item that's not from your menu:",210,10,180,40,$BS_MULTILINE)
	GUICtrlSetState(-1,$GUI_CHECKED)
	Global $AddToListNewCombo=GUICtrlCreateCombo("",210,50,180,20)
	GUICtrlSetState(-1,$GUI_FOCUS)
	Global $AddToListNewQuantityLabel=GUICtrlCreateLabel("How many:",210,83,65,20)
	Global $AddToListNewQuantityInput=GUICtrlCreateInput("",280,80,50,20,$ES_NUMBER)
	Global $AddToListNewQuantityLabel=GUICtrlCreateLabel("",335,83,80,20)
	Global $AddToListCancel=GUICtrlCreateButton("Cancel",210,120,75,20)
	Global $AddToListSave=GUICtrlCreateButton("Add",310,120,75,20,$BS_DEFPUSHBUTTON)
	
	_SQLite_GetTable2d($MenuDB,"Select Name From Ingredients",$aResult,$iRows,$iColumns)
	If $iRows > 0 Then
		Local $DropdownValue=""
		For $n=1 To $iRows
			$DropDownValue&="|"&$aResult[$n][0]
		Next
		GUICtrlSetData($AddToListNewCombo,$DropDownValue)
	EndIf
	
	Local $DropdownValue=""
	For $n=1 To $ListMods[0][0]
		If $ListMods[$n][1]="Sub" Then
			$DropDownValue&="|"&$ListMods[$n][0]
		EndIf
	Next
	GUICtrlSetData($AddToListRestoreList,$DropDownValue)
	
	GUISetState(@SW_SHOW,$AddToListGUI)
	GUISetState(@SW_DISABLE,$MainGUI)
	
	Local $LastValue=""
	
	While 1
		If $LastValue <> GUICtrlRead($AddToListNewCombo) Then
			$LastValue = GUICtrlRead($AddToListNewCombo)
			_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace(GUICtrlRead($AddToListNewCombo),"'","''")&"';",$aResult,$iRows,$iColumns)
			If $iRows > 0 Then
				GUICtrlSetData($AddToListNewQuantityLabel,$aResult[1][0])
			Else
				GUICtrlSetData($AddToListNewQuantityLabel,"")
			EndIf
		EndIf
		$msg=GUIGetMsg()
		If $msg <> 0 Then
			Switch $msg
				Case $GUI_EVENT_CLOSE
					ExitLoop
				Case $AddToListCancel
					ExitLoop
				Case $AddToListSave
					If BitAND(GUICtrlRead($AddToListRestoreRadio),$GUI_CHECKED) Then
						For $n=1 To $ListMods[0][0]
							If $ListMods[$n][0] = GUICtrlRead($AddToListRestoreList) AND $ListMods[$n][1]="Sub" Then
								_ArrayDelete4d($ListMods,$n)
								$ListMods[0][0]-=1
								ExitLoop 2
							EndIf
						Next
					Else
						If GUICtrlRead($AddToListNewcombo) <> "" Then
							$ListMods[0][0]+=1
							ReDim $ListMods[$ListMods[0][0]+1][3]
							$ListMods[$ListMods[0][0]][0]=GUICtrlRead($AddToListNewcombo)
							$ListMods[$ListMods[0][0]][1]="Add"
							$ListMods[$ListMods[0][0]][2]=GUICtrlRead($AddToListNewQuantityInput)
						EndIf
					EndIf
					ExitLoop
				Case $AddToListRestoreRadio
					GUICtrlSetState($AddToListNewCombo,$GUI_DISABLE)
					GUICtrlSetState($AddToListNewQuantityInput,$GUI_DISABLE)
					GUICtrlSetState($AddToListRestoreList,$GUI_ENABLE)
				Case $AddToListNewRadio
					GUICtrlSetState($AddToListNewCombo,$GUI_ENABLE)
					GUICtrlSetState($AddToListNewQuantityInput,$GUI_ENABLE)
					GUICtrlSetState($AddToListRestoreList,$GUI_DISABLE)
			EndSwitch
		EndIf
		Sleep(15);take less CPU
	WEnd
	GUISetState(@SW_ENABLE,$MainGUI)
	GUIDelete($AddToListGUI)
	GUISwitch($MainGUI)
EndFunc

Func Printrecipes();the loop for bringing up the 'select recipes to print' dialog
	Global $PrintrecipesGUI=GUICreate("Select recipes to print",320,480,-1,-1,-1,-1,$MainGUI)
	GUIStartGroup($PrintrecipesGUI)
	Global $PrintrecipesAllRadio=GUICtrlCreateRadio("All available recipes",5,5,150,20)
	Global $PrintrecipesCurrentRadio=GUICtrlCreateRadio("Current recipes",165,5,150,20)
	GUICtrlSetState(-1,$GUI_CHECKED)
	Global $PrintrecipesTreeview=GUICtrlCreateTreeview(5,25,310,400,$GUI_SS_DEFAULT_TREEVIEW+$TVS_CHECKBOXES)
	Global $PrintrecipesCancel=GUICtrlCreateButton("Cancel",75,450,75,20)
	Global $PrintrecipesPrint=GUICtrlCreateButton("Print checked",170,450,75,20,$BS_DEFPUSHBUTTON)
	GUISetState(@SW_SHOW,$PrintrecipesGUI)
	GUISetState(@SW_DISABLE,$MainGUI)
	
	Local $recipeTreeviewItems[1][2]=[["0"]];GUI id,text
	For $n=0 To UBound($MenuArray)-1
		_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From MainCourse Where Name='"&StringReplace(StringTrimLeft($MenuArray[$n][0],1),"'","''")&"';",$aResult,$iRows,$iColumns)
		If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
		For $x=1 To $recipeTreeviewItems[0][0]
			If $recipeTreeviewItems[$x][1] = StringTrimLeft($MenuArray[$n][0],1) Then ContinueLoop 2
		Next
		If StringLeft($MenuArray[$n][0],1) = 1 Then
			$recipeTreeviewItems[0][0]+=1
			ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem(StringTrimLeft($MenuArray[$n][0],1),$PrintrecipesTreeview)
			GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=StringTrimLeft($MenuArray[$n][0],1)
		EndIf
	Next
	
	For $n=0 To UBound($MenuArray)-1
		_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From Sides Where Name='"&StringReplace($MenuArray[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
		If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
		For $x=1 To $recipeTreeviewItems[0][0]
			If $recipeTreeviewItems[$x][1] = $MenuArray[$n][1] Then ContinueLoop 2
		Next
		If $MenuArray[$n][1] <> "" Then
			$recipeTreeviewItems[0][0]+=1
			ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem($MenuArray[$n][1],$PrintrecipesTreeview)
			GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=$MenuArray[$n][1]
		EndIf
	Next
	
	For $n=0 To UBound($MenuArray)-1
		_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From Veggies Where Name='"&StringReplace($MenuArray[$n][2],"'","''")&"';",$aResult,$iRows,$iColumns)
		If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
		For $x=1 To $recipeTreeviewItems[0][0]
			If $recipeTreeviewItems[$x][1] = $MenuArray[$n][2] Then ContinueLoop 2
		Next
		If $MenuArray[$n][2] <> "" Then
			$recipeTreeviewItems[0][0]+=1
			ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem($MenuArray[$n][2],$PrintrecipesTreeview)
			GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
			$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=$MenuArray[$n][2]
		EndIf
	Next
	
	While 1
		Local $msg=GUIGetMsg()
		Switch $msg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $PrintrecipesCancel
				ExitLoop
			Case $PrintrecipesPrint
				Local $PrintStr="<HTML><HEAD><TITLE>Recipies printed from MealPlanner 1.0 on "&_Now()&"</TITLE></HEAD><BODY>"
				Local $SomeChecked=0
				For $n=1 To $recipeTreeviewItems[0][0]
					If BitAND(GUICtrlRead($recipeTreeviewItems[$n][0]),$GUI_CHECKED) Then
						$SomeChecked=1
						_SQLite_GetTable2d($MenuDB,"Select Recipe,Ingredients From MainCourse Where Name='"&StringReplace($recipeTreeviewItems[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
						If $iRows < 1 Then
							_SQLite_GetTable2d($MenuDB,"Select Recipe,Ingredients From Sides Where Name='"&StringReplace($recipeTreeviewItems[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
							If $iRows < 1 Then
								_SQLite_GetTable2d($MenuDB,"Select Recipe,Ingredients From Veggies Where Name='"&StringReplace($recipeTreeviewItems[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
								If $iRows < 1 Then ContinueLoop
							EndIf
						EndIf
						$PrintStr&="<TABLE align='left' border='1'><TR><TD><b>Items needed to buy:</b>"
						$SplitArray=StringSplit($aResult[1][1],"|")
						For $x=1 To $SplitArray[0]
							Local $aResult2
							_SQLite_GetTable2d($MenuDB,"Select Units From Ingredients Where Name='"&StringReplace(StringLeft($SplitArray[$x],StringInStr($SplitArray[$x],"~",0,-1)-1),"'","''")&"';",$aResult2,$iRows,$iColumns)
							If $iRows < 1 Then ContinueLoop
							$PrintStr&="<br>"&StringTrimLeft($SplitArray[$x],StringInStr($SplitArray[$x],"~",0,-1))&" "&$aResult2[1][0]&" of "&StringLeft($SplitArray[$x],StringInStr($SplitArray[$x],"~",0,-1)-1)
						Next
						$PrintStr&="</TD></TR></TABLE><h2>"&$recipeTreeviewItems[$n][1]&"</h2><br>"&StringReplace($aResult[1][0],@CR,"<p>")&"<hr>"
					EndIf
				Next
				If NOT $SomeChecked Then ExitLoop
				$PrintStr&="</BODY></HTML>"
				FileWrite(@TempDir&"\MealPlannerPrintOutput.html",$PrintStr)
				_PrintHTML(@TempDir&"\MealPlannerPrintOutput.html")
				FileDelete(@TempDir&"\MealPlannerPrintOutput.html")
				ExitLoop
			Case $PrintrecipesAllRadio
				For $n=1 To $recipeTreeviewItems[0][0]
					GUICtrlDelete($recipeTreeviewItems[$n][0])
				Next
				ReDim $recipeTreeviewItems[1][2]
				$recipeTreeviewItems[0][0]=0
				
				_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From MainCourse UNION Select Name,Recipe From Sides UNION Select Name,Recipe From Veggies",$aResult,$iRows,$iColumns)
				If $iRows > 0 Then
					For $n=1 To $iRows
						If $aResult[$n][1] = "" Then ContinueLoop
						$recipeTreeviewItems[0][0]+=1
						ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem($aResult[$n][0],$PrintrecipesTreeview)
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=$aResult[$n][0]
					Next
				EndIf
			Case $PrintrecipesCurrentRadio
				For $n=1 To $recipeTreeviewItems[0][0]
					GUICtrlDelete($recipeTreeviewItems[$n][0])
				Next
				ReDim $recipeTreeviewItems[1][2]
				$recipeTreeviewItems[0][0]=0
				
				For $n=0 To UBound($MenuArray)-1
					_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From MainCourse Where Name='"&StringReplace(StringTrimLeft($MenuArray[$n][0],1),"'","''")&"';",$aResult,$iRows,$iColumns)
					If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
					For $x=1 To $recipeTreeviewItems[0][0]
						If $recipeTreeviewItems[$x][1] = StringTrimLeft($MenuArray[$n][0],1) Then ContinueLoop 2
					Next
					If StringLeft($MenuArray[$n][0],1) = 1 Then
						$recipeTreeviewItems[0][0]+=1
						ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem(StringTrimLeft($MenuArray[$n][0],1),$PrintrecipesTreeview)
						GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=StringTrimLeft($MenuArray[$n][0],1)
					EndIf
				Next
				
				For $n=0 To UBound($MenuArray)-1
					_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From Sides Where Name='"&StringReplace($MenuArray[$n][1],"'","''")&"';",$aResult,$iRows,$iColumns)
					If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
					For $x=1 To $recipeTreeviewItems[0][0]
						If $recipeTreeviewItems[$x][1] = $MenuArray[$n][1] Then ContinueLoop 2
					Next
					If $MenuArray[$n][1] <> "" Then
						$recipeTreeviewItems[0][0]+=1
						ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem($MenuArray[$n][1],$PrintrecipesTreeview)
						GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=$MenuArray[$n][1]
					EndIf
				Next
				
				For $n=0 To UBound($MenuArray)-1
					_SQLite_GetTable2d($MenuDB,"Select Name,Recipe From Veggies Where Name='"&StringReplace($MenuArray[$n][2],"'","''")&"';",$aResult,$iRows,$iColumns)
					If $iColumns < 2 OR $aResult[1][1] = "" Then ContinueLoop
					For $x=1 To $recipeTreeviewItems[0][0]
						If $recipeTreeviewItems[$x][1] = $MenuArray[$n][2] Then ContinueLoop 2
					Next
					If $MenuArray[$n][2] <> "" Then
						$recipeTreeviewItems[0][0]+=1
						ReDim $recipeTreeviewItems[$recipeTreeviewItems[0][0]+1][2]
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][0]=GUICtrlCreateTreeViewItem($MenuArray[$n][2],$PrintrecipesTreeview)
						GUICtrlSetState($recipeTreeviewItems[$recipeTreeviewItems[0][0]][0],$GUI_CHECKED)
						$recipeTreeviewItems[$recipeTreeviewItems[0][0]][1]=$MenuArray[$n][2]
					EndIf
				Next
		EndSwitch
		Sleep(15);take less CPU
	WEnd
	GUISetState(@SW_ENABLE,$MainGUI)
	GUIDelete($PrintrecipesGUI)
	GUISwitch($MainGUI)
EndFunc


Func _PrintHTML($p_file);my own print function
	If FileExists($p_file) Then RunWait(@COMSPEC&' /c rundll32.exe ' & @SystemDir & '\mshtml.dll,PrintHTML "' & $p_file & '"',@TempDir,@SW_HIDE)
EndFunc
	
Func _AutoComplete($Combo, ByRef $old_string);Thanks GAFrost!
    If _IsPressed('08') Then;backspace pressed
        $old_string = GUICtrlRead($Combo)
    Else
        If $old_string <> GUICtrlRead($Combo) Then
            Local $ret, $s_text, $s_data
            $s_data = GUICtrlRead($Combo)
            $ret = _GUICtrlComboFindString ($Combo, GUICtrlRead($Combo))
            If ($ret <> $CB_ERR) Then
                _GUICtrlComboGetLBText ($Combo, $ret, $s_text)
                GUICtrlSetData($Combo, $s_text)
                _GUICtrlComboSetEditSel ($Combo, StringLen($s_data), StringLen(GUICtrlRead($Combo)))
            EndIf
            $old_string = GUICtrlRead($Combo)
        EndIf
    EndIf
EndFunc

Func _ArrayDelete4D(ByRef $avInput, $iElement);Thanks PsaltyDS!
    If (Not IsArray($avInput)) Or (Not IsInt($iElement)) Then Return SetError(1, 0, 0) ; Wrong type of input(s)
    
    Local $e, $f, $g, $h
    Local $avUbounds[UBound($avInput, 0) + 1] = [UBound($avInput, 0)]
    For $e = 1 to $avUbounds[0]
        $avUbounds[$e] = UBound($avInput, $e)
    Next
    If $avUbounds[0] > 4 Then Return SetError(2, 0, 0) ; Array has more than four subscripts
    If $avUbounds[1] = 1 Then Return SetError(3, 0, 0) ; Array only has one element
    If $iElement > $avUbounds[1] - 1 Or $iElement < 0 Then Return SetError(4, 0, 0) ; $iElement out of range
    If $iElement <> $avUbounds[1] - 1 Then
        For $e = $iElement To $avUbounds[1] - 2
            Switch $avUbounds[0]
                Case 1
                    $avInput[$e] = $avInput[$e + 1]
                Case 2
                    For $f = 0 To $avUbounds[2] - 1
                        $avInput[$e][$f] = $avInput[$e + 1][$f]
                    Next
                Case 3
                    For $f = 0 To $avUbounds[2] - 1
                        For $g = 0 To $avUbounds[3] - 1
                            $avInput[$e][$f][$g] = $avInput[$e + 1][$f][$g]
                        Next
                    Next
                Case 4
                    For $f = 0 To $avUbounds[2] - 1
                        For $g = 0 To $avUbounds[3] - 1
                            For $h = 0 To $avUbounds[4] - 1
                                $avInput[$e][$f][$g][$h] = $avInput[$e + 1][$f][$g][$h]
                            Next
                        Next
                    Next
            EndSwitch
        Next
    EndIf
    Switch $avUbounds[0]
        Case 1
            ReDim $avInput[$avUbounds[1] - 1]
        Case 2
            ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]]
        Case 3
            ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]][$avUbounds[3]]
        Case 4
            ReDim $avInput[$avUbounds[1] - 1][$avUbounds[2]][$avUbounds[3]][$avUbounds[4]]
    EndSwitch
    Return 1
EndFunc

Func About();shows the 'about' dialog
	MsgBox(64,"About Meal Planner","Meal Planner 1.0.0.1 ©2007 by Michael Garrison.  All Rights Reserved.  This script was written in the AutoIt Language, and may not be decompiled, reverse-engineered or resold for any reason."&@CRLF&@CRLF&"No guarentees, explicit or implied, are attached to this script, including being useful and/or fit for a purpose, nor do I accept any responsibility for any unintended damage that may happen as a direct or indirect result of this script. That being said, no damage is intended by this script either, and unless it has been modified by an unauthorized third party, contains no code that could be construed as spyware, adware or any form of virus."&@CRLF&@CRLF&"To uninstall this program, delete this executable file and the Menus.db file in the same directory. No other files or registry keys are attached to this program."&@CRLF&@CRLF&"My grateful thanks goes out to all the developers of the AutoIt Language, and many members of the accompanying forums since 2001, especially ptrex, piccaso and JPM who worked hard to include the SQLite functions used in this program in AutoIt.  To learn more about AutoIt, visit http://www.autoitscript.com.")
EndFunc

Func Help();shows 'help'
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<HTML><HEAD><TITLE>Meal Planner 1.0 Help</TITLE></HEAD><BODY bgcolor='cccccc'><center><h1>Meal Planner 1.0 Help</h1></center>Thanks for using Meal Planner 1.0!<p>When you first launch this program, it will check for an existing Menus.db file, which must be in the same folder as this program.  If it doesn't find it, it will create a blank database to start from, then offer to fill it with 'bogus' data so you can see how the program works.  If the database is corrupt, it will offer to recycle it and create a new blank database.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","The first thing you will need to do once the actual program starts is to choose the days you want to plan out.  Use the calendar controls to set the begining and end date(s) (by default, both are today, meaning you're only planning dinner for tonight).<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","Once you choose the dates you want, you'll see the full GUI.  Use the colored buttons near the top to jump between days.  If your database is blank, you'll need to start by creating meals (see 'Creating or Editing meals section below').  Choosing a meal will populate the sides and veggies lists with recommended dishes, though you can always choose 'Show all...' to select a side or veggie dish that is not associated with the main course you've selected.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","You can create new side and veggie dishes either from the main screen or from within the 'Edit Main Course' screen by clicking the appropriate 'New...' button.  Likewise, you can create an ingredient entry from either the 'Edit Main Course' screen or the 'Edit Side' screen (See the 'Creating or Editing Sides or Veggies' and 'Creating or Editing Ingredients' sections below<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Creating or editing meals</h3>If you're creating a new meal, you'll be prompted for the name of the Main course.  Once you've entered that, you'll see a screen on which you assign ingredients to the meal, and choose which of all of your sides and veggies would commonly be made with this meal.<p>To begin, use the Add and Remove buttons near the top of the window to indicate that a selected ingredient (on the right) should be used in making this dish.  Once it's in the list on the left, click it and change the quantity that you will need to buy.  If the ingredient you need isn't listed, click the 'New...' button to make a new ingredient, or you can click 'Edit...' instead to change an existing ingredient (See Create or Edit an ingredient section below).<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","Now you can enter the recipe for this dish in the box provided - there is no size restriction.  Finally, check any sides or veggies that you want to suggest are made with this dish.  You can also create a new side or veggie by clicking the appropiate 'New...' button, or edit an existing side or veggie by clicking 'Edit...'.<p>The Save button will save all your changes, and the Cancel button will discard all changes made since you left the main window, <b><i>including</i></b> changes to your sides, veggies or ingredients!<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Creating or editing sides and veggies</h3>This section is very similar to creating or editing a Main course, except that you don't need to select accompanying sides and veggies.  You can edit or add new ingredients from this window, but if you click Cancel, your changes will be lost.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Creating or editing ingredients</h3>If you're creating a new ingredient, you'll be prompted for its name.  Once you've entered that, you'll see a screen into which you can enter your preferred store for purchasing this item (you CANNOT enter multiple stores, rather, use different ingredients with names that indicate the locations if you buy an item different places, i.e. 'Costco Milk' and 'Safeway Milk', for instance).  The dropdown offers you stores you've already entered for other ingredients, or simply type a new store name into the box.  Give the aisle or section in which you can find this item, if desired, then type in the units you BUY this item in (not the units you cook with).  The amount actually needed for a particular recipe should be listed by you in the recipe box.  Again, the dropdown box offers you some units you've already used, or type in new units.  The units make the final lists much more legible.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Printing</h3>There are many things you can print from this program - your schedule of meals per day, a shopping list, or recipies.  All of these functions can be accessed from the Main window.  In the case of printing recipies, you can choose between printing from the recipies you're using in your current schedule, or just check off recipies you want to print from your entire list by using the radio buttons at the top of the 'Print Recipies' dialog.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Known Bugs:</h3>If a Main dish has the same name as a side or veggie, you can't print the side or veggie recipe.  To get around this, name them differently.  For instance, 'Dinner salad' and 'Side salad' would be enough to keep them separate.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Possible future improvements:</h3>-A field in the main window that tells you how many servings a meal will make, and allows you to double or triple the recipe for larger events<p>-A per-ingredient field that will store price, allowing you to estimate the cost of your current meal plan<p>-The ability to import and export recipies and ingredients lists available for a store for ease of use.<p>")
	FileWrite(@TempDir&"\MealPlannerPrintOutput.html","<h3>Thanks again for using this software!  Be sure to read the 'About Meal Planner 1.0' section for legal information.</h3></BODY></HTML>")
	RunWait(@ComSpec & ' /c start "" "'&@TempDir&"\MealPlannerPrintOutput.html"&'"',"",@SW_HIDE)
	FileDelete(@TempDir&"\MealPlannerPrintOutput.html")
EndFunc

Func OnAutoItExit();runs when the script is exited, closing the database file(s) and closing out of the SQLite dll.
	_SQLite_Close($MenuDB)
	_SQLite_Shutdown()
	FileDelete(@TempDir&"\MealPlannerPrintOutput.html")
EndFunc