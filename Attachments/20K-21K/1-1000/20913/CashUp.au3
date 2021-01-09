#cs
	Rewritten:	dmob (dalisuit)
	AutoIt Ver:	3.2.12.0
	Credits:		Based on code by d2addict4 
							ptrex for the SQLite UDF
							martin for the PrintMGv2 UDF
							Jos van der Zande for the _ArrayX UDF
							JasonB for the keyboard support
							many others for the lessons, ideas, functions and code from their scripts;
	Requirements:	_ArrayX.au3
	Notes:			I'm loving AutoIt more and more
	
#ce	

#include <Misc.au3>
#Include <Date.au3>
#include <File.au3>
#include <String.au3>
#include <SQLite.au3>
#include <printMGv2.au3>
#include <SQLite.dll.au3>
#include <GUIListView.au3>
#include <TabConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <DateTimeConstants.au3>

#NoTrayIcon

Global $Query, $aRow, $ProdArr[100], $TxNo, $CalcMode, $Prn, $pErr, $DebugIt = 1
Global $dBuf = "", $AnyDate = 1, $AnyItem = 1, $TotItems, $TotQty, $TotAmnt, $TotExp, $TotDisc, $TotDrw

If WinExists("Cash Up!") Then 																						; allow only one instance per station
	WinActivate("Cash Up!")
	Exit
EndIf

#Region Read button assignments from INI file
;~ _FileReadToArray(@ScriptDir & "\PoSConfig.ini", $Array)
;~ If $ProdArr[0] < 35 Then
;~ 	MsgBox(0, "PoS", "PoS Config Error")
;~ 	Exit
;~ EndIf
#EndRegion
#Region SQL Startup

#cs Table structure
_SQLite_Exec(-1 , "CREATE TABLE Products (ItemCode NUMERIC, Description TEXT, Price NUMERIC, Dept TEXT, SDisc NUMERIC, SQty NUMERIC, CDisc NUMERIC, CQty NUMERIC, FDisc NUMERIC, FQty NUMERIC, PDisc NUMERIC, PQty NUMERIC);")
																				SDisc = Student Discount
																				SQty = Min qty to qualify for Discount
																				CDisc = Client Discount
																				CQty = Min qty to qualify for Discount
																				FDisc = Client Discount
																				FQty = Min qty to qualify for Discount
																				PDisc = Public Discount
																				PQty = Min qty to qualify for Discount
_SQLite_Exec(-1 , "CREATE TABLE Daily (TxNo NUMERIC, Date TEXT, Time TEXT, ItemCode NUMERIC, Description TEXT, Qty NUMERIC, Price NUMERIC, Dept TEXT, Disc NUMERIC, DiscRef TEXT);")
_SQLite_Exec(-1 , "CREATE TABLE Dept (Dept TEXT, Code TEXT);")
#ce

_SQLite_Startup()
If @error > 0 Then
	MsgBox(16, "SQLite Error", "SQLite.dll Can't be Loaded!")
	Exit
EndIf

Global $DataBase = _SQLite_Open (@ScriptDir & "\DAILY.xdb") 							; Open database
If Not $DataBase Then 
	MsgBox(16, "_SQLite_Open Error " & @error, "Can't Load Database " & @ScriptDir&"\DAILY.xdb" & @LF & "@extended " & @extended)
	Exit
EndIf
$Dll = DllOpen("User32.dll")

#endregion

#Region Read button assignments from Products database file
_SQlite_Query (-1, "SELECT * FROM Products ORDER BY ItemCode", $Query)
$d = 1																																		; next array location pointer
While _SQLite_FetchData ($Query, $aRow) = $SQLITE_OK 											; Read Out each Row into $ProdArray
	$ProdArr[$d] = $aRow[0] & "|" & $aRow[1] & "|" & $aRow[2] & "|" & $aRow[3] & "|" & $aRow[4] & "|" & _
							 $aRow[5] & "|" & $aRow[6] & "|" & $aRow[7] & "|" & $aRow[8] & "|" & $aRow[9] & "|" & $aRow[10] & "|" & $aRow[11]
	If $DebugIt Then 
		ConsoleWrite(StringFormat(" %-2s  %-2s  %-30s  %-8s  %-10s  %-5s  %-5s  %-5s  %-5s  %-5s", $d, $aRow[0], $aRow[1], _
								$aRow[2], $aRow[3], $aRow[4], $aRow[5], $aRow[6], $aRow[7], $aRow[8], $aRow[9], $aRow[10], $aRow[11]) & @CR)	
	EndIf
	$d += 1		
WEnd	
ReDim $ProdArr[$d]
_SQLite_QueryFinalize($Query)
#EndRegion

#Region Array-to- Buttons assignment
#cs - must try to use 2D array as follows [should make code much shorter]
ItmCode			Desc				Price				Dept
But[1][1]		But[1][2]		But[1][3]		But[1][4]
But[2][1]		But[2][2]		But[2][3]		But[1][4]
But[3][1]		But[3][2]		But[3][3]		But[4][4]
.
..
But[35][1]	But[35][2]	But[35][3]	But[35][4]
#ce
$But1 = StringSplit($ProdArr[1], "|")
$But2 = StringSplit($ProdArr[2], "|")
$But3 = StringSplit($ProdArr[3], "|")
$But4 = StringSplit($ProdArr[4], "|")
$But5 = StringSplit($ProdArr[5], "|")
$But6 = StringSplit($ProdArr[6], "|")
$But7 = StringSplit($ProdArr[7], "|")
$But8 = StringSplit($ProdArr[8], "|")
$But9 = StringSplit($ProdArr[9], "|")
;If StringLen($But9) > 16 Then	$But9 = StringMid($But9, 1, 16) & @LF & StringMid($But9, 17)
$But10 = StringSplit($ProdArr[10], "|")
;If StringLen($But10) > 16 Then	$But10 = StringMid($But10, 1, 16) & @LF & StringMid($But10, 17)
$But11 = StringSplit($ProdArr[11], "|")
$But12 = StringSplit($ProdArr[12], "|")
$But13 = StringSplit($ProdArr[13], "|")
$But14 = StringSplit($ProdArr[14], "|")
$But15 = StringSplit($ProdArr[15], "|")
$But16 = StringSplit($ProdArr[16], "|")
$But17 = StringSplit($ProdArr[17], "|")
$But18 = StringSplit($ProdArr[18], "|")
$But19 = StringSplit($ProdArr[19], "|")
$But20 = StringSplit($ProdArr[20], "|")
$But21 = StringSplit($ProdArr[21], "|")
$But22 = StringSplit($ProdArr[22], "|")
$But23 = StringSplit($ProdArr[23], "|")
$But24 = StringSplit($ProdArr[24], "|")
$But25 = StringSplit($ProdArr[25], "|")
$But26 = StringSplit($ProdArr[26], "|")
$But27 = StringSplit($ProdArr[27], "|")
$But28 = StringSplit($ProdArr[28], "|")
$But29 = StringSplit($ProdArr[29], "|")
$But30 = StringSplit($ProdArr[30], "|")
$But31 = StringSplit($ProdArr[31], "|")
$But32 = StringSplit($ProdArr[32], "|")
$But33 = StringSplit($ProdArr[33], "|")
$But34 = StringSplit($ProdArr[34], "|")
$But35 = StringSplit($ProdArr[35], "|")
#endregion
#Region Main GUI
$MainWin = GUICreate("Cash Up!   v0.3", 900, 625, 50, 0)
$TabSheet = GUICtrlCreateTab(8, 8, 888, 625, $TCS_BUTTONS  )
$Tab1 = GUICtrlCreateTabItem(" Register     ")
GUICtrlSetState(-1, $GUI_SHOW)
$Group1 = GUICtrlCreateGroup("", 8, 32, 884, 585)
GUICtrlSetColor(-1, 0xFFFF00)
$ListView = GUICtrlCreateListView("Code|Item|Qty|Price|Dept", 16, 112, 284, 366)
_GUICtrlListView_SetColumnWidth($ListView, 0, 0)
_GUICtrlListView_SetColumnWidth($ListView, 1, 170)
_GUICtrlListView_SetColumnWidth($ListView, 2, 40)
_GUICtrlListView_SetColumnWidth($ListView, 3, 50)
_GUICtrlListView_SetColumnWidth($ListView, 4, 0)
_GUICtrlListView_SetColumn ($ListView, 2, "Qty", 49, 1)		; right-align qty
_GUICtrlListView_SetColumn ($ListView, 3, "Price", 60, 1)	; right-align price
GUICtrlSetFont(-1, 11, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x00FFFF)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Display = GUICtrlCreateLabel("", 16, 49, 284, 60, BitOR($SS_CENTERIMAGE, $SS_SUNKEN, $WS_BORDER))
GUICtrlSetFont(-1, 16, 800, 0, "Lucida Console")
GUICtrlSetColor(-1, 0xFFFF00)
GUICtrlSetBkColor(-1, 0x008000)
$DispP = GUICtrlCreateLabel("Printer OFF", 20, 52, 90, 10)
GUICtrlSetFont(-1, 9, 800, 0, "Lucida Console")
GUICtrlSetColor($DispP,0xFFFFFF )    	; grey
$DispT = GUICtrlCreateLabel("Till", 254, 52, 50, 10)
GUICtrlSetFont(-1, 9, 800, 0, "Lucida Console")
GUICtrlSetColor($DispT,0xFFFFFF )    	; grey

#EndRegion
#region Product Buttons
Dim $col1 = 0xFDFBD5, $col2 = 0xB9F8AE, $col3 = 0xDDECFE, $col4 = 0x99FFCC
Dim $col5 = 0xFFCCFF, $col6 = 0xFDD3CF, $col7 = 0xEFEFE9, $col8 = 0x00FFFF
#cs
ItmCode	Desc	Price
But[1][1]	But[1][2]	But[1][3]
But[2][1]	But[2][2]	But[2][3]
But[3][1]	But[3][2]	But[3][3]
#ce
;$Button13 = GUICtrlCreateButton($But1[2], 302, 48, 84, 49, BitOR($BS_MULTILINE, $BS_VCENTER))
$ButT1 = GUICtrlCreateButton($But1[2], 302, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col1)
$ButT2 = GUICtrlCreateButton($But2[2], 302, 96, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col1)
$ButT3 = GUICtrlCreateButton($But3[2], 302, 144, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col1)
$ButT4 = GUICtrlCreateButton($But4[2], 302, 192, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col1)
$ButT5 = GUICtrlCreateButton($But5[2], 302, 240, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col1)
$ButT6 = GUICtrlCreateButton($But6[2], 385, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col2)
$ButT7 = GUICtrlCreateButton($But7[2], 385, 96, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col2)
$ButT8 = GUICtrlCreateButton($But8[2], 385, 144, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col2)
$ButT9 = GUICtrlCreateButton($But9[2], 385, 192, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col2)
$ButT10 = GUICtrlCreateButton($But10[2], 385, 240, 84, 49, BitOR($BS_MULTILINE, $BS_CENTER))
;GUICtrlSetBkColor(-1, $col2)
$ButT11 = GUICtrlCreateButton($But11[2], 468, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col3)
$ButT12 = GUICtrlCreateButton($But12[2], 468, 96, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col3)
$ButT13 = GUICtrlCreateButton($But13[2], 468, 144, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col3)
$ButT14 = GUICtrlCreateButton($But14[2], 468, 192, 84, 49, $BS_VCENTER)
;GUICtrlSetBkColor(-1, $col3)
$ButT15 = GUICtrlCreateButton($But15[2], 468, 240, 84, 49, $BS_VCENTER)
;GUICtrlSetBkColor(-1, $col3)
$ButT16 = GUICtrlCreateButton($But16[2], 551, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col4)
$ButT17 = GUICtrlCreateButton($But17[2], 551, 96, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col4)
$ButT18 = GUICtrlCreateButton($But18[2], 551, 144, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col4)
$ButT19 = GUICtrlCreateButton($But19[2], 551, 192, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col8)
$ButT20 = GUICtrlCreateButton($But20[2], 551, 240, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col8)
$ButT21 = GUICtrlCreateButton($But21[2], 635, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col5)
$ButT22 = GUICtrlCreateButton($But22[2], 635, 96, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col5)
$ButT23 = GUICtrlCreateButton($But23[2], 635, 144, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col5)
$ButT24 = GUICtrlCreateButton($But24[2], 635, 192, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col8)
$ButT25 = GUICtrlCreateButton($But25[2], 635, 240, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col8)
$ButT26 = GUICtrlCreateButton($But26[2], 718, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col6)
$ButT27 = GUICtrlCreateButton($But27[2], 718, 96, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col6)
$ButT28 = GUICtrlCreateButton($But28[2], 718, 144, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col6)
$ButT29 = GUICtrlCreateButton($But29[2], 718, 192, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col6)
$ButT30 = GUICtrlCreateButton($But30[2], 718, 240, 84, 49, $BS_MULTILINE)
;GUICtrlSetBkColor(-1, $col6)
$ButT31 = GUICtrlCreateButton($But31[2], 801, 48, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col7)
$ButT32 = GUICtrlCreateButton($But32[2], 801, 96, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col7)
$ButT33 = GUICtrlCreateButton($But33[2], 801, 144, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col7)
$ButT34 = GUICtrlCreateButton($But34[2], 801, 192, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col7)
$ButT35 = GUICtrlCreateButton($But35[2], 801, 240, 84, 49, $BS_VCENTER)
GUICtrlSetBkColor(-1, $col7)
#endregion
#region Number buttons
$ButC1 = GUICtrlCreateButton("1", 302, 432, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC2 = GUICtrlCreateButton("2", 385, 432, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC3 = GUICtrlCreateButton("3", 468, 432, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC4 = GUICtrlCreateButton("4", 302, 384, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC5 = GUICtrlCreateButton("5", 385, 384, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC6 = GUICtrlCreateButton("6", 468, 384, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC7 = GUICtrlCreateButton("7", 302, 336, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC8 = GUICtrlCreateButton("8", 385, 336, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC9 = GUICtrlCreateButton("9", 468, 336, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC10 = GUICtrlCreateButton("0", 302, 480, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
$ButC11 = GUICtrlCreateButton("00", 385, 480, 84, 49, 0)
GUICtrlSetFont(-1, 18, 400, 0, "Lucida Console")
#endregion
#Region Control Buttons
$ButPlus = GUICtrlCreateButton("+", 551, 336, 84, 49, 0)
GUICtrlSetFont(-1, 28, 400, 0, "Lucida Console")
$ButMinus = GUICtrlCreateButton("-", 551, 384, 84, 49, 0)
GUICtrlSetFont(-1, 34, 400, 0, "Lucida Console")
$ButDiv = GUICtrlCreateButton(Chr(247), 551, 432, 84, 49, 0)
GUICtrlSetFont(-1, 26, 400, 0, "Lucida Console")
$ButManual = GUICtrlCreateButton("F4" & @LF & "Manual", 302, 288, 167, 49, $BS_MULTILINE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButBack = GUICtrlCreateButton("Back-" & @LF & "space", 468, 288, 84, 49, $BS_MULTILINE)
GUICtrlSetFont(-1, 14, 400, 0, "Lucida Console")
$ButMult = GUICtrlCreateButton("X", 551, 288, 84, 49, 0)
GUICtrlSetFont(-1, 28, 400, 0, "Lucida Console")
$ButEnter = GUICtrlCreateButton("Enter" , 468, 480, 167, 49, $BS_MULTILINE)
GUICtrlSetFont(-1, 18, 800, 0, "MS Sans Serif")
$ButTotal = GUICtrlCreateButton("F8" & @LF & "TOTAL", 302, 528, 167, 54, $BS_MULTILINE)
GUICtrlSetFont(-1, 17, 800, 0, "MS Sans Serif")
$ButClear = GUICtrlCreateButton("F12" & @LF & "CLEAR/DONE", 156, 528, 145, 54, $BS_MULTILINE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButCash = GUICtrlCreateButton("F9" & @LF & "TENDER CASH", 468, 528, 167, 54, $BS_MULTILINE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButVoid = GUICtrlCreateButton("F6" & @LF & "VOID", 156, 480, 145, 49, $BS_MULTILINE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$PrintToggle = GUICtrlCreateCheckbox("Printer OFF", 16, 480, 140, 49, BitOR($BS_PUSHLIKE, $BS_ICON))
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
;GUICtrlSetImage(-1, "off.ico", -1, 0)
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButNull = GUICtrlCreateButton("", 16, 528, 140, 54, $BS_MULTILINE)
$StatGroup = GUICtrlCreateGroup("", 8, 580, 884, 37)
	$User = GUICtrlCreateLabel("User:  " & @UserName, 15, 594, 100, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

	$User = GUICtrlCreateLabel(@ScriptDir & "\DAILY", 190, 594, 300, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")

#endregion
#Region Transactions Tab
$Tab2 = GUICtrlCreateTabItem("Transactions")
$Group2 = GUICtrlCreateGroup("", 8, 32, 884, 585)
$DateTxt = GUICtrlCreateLabel("Date:", 68, 60, 80,25)
$TxDate = GUICtrlCreateDate(_NowCalcDate(), 100, 56, 85, 21, $DTS_SHORTDATEFORMAT)
$DayTxt = GUICtrlCreateLabel(_DateDayOfWeek(@WDAY), 195, 57, 150,25)
GUICtrlSetFont(-1, 12, 600, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x00A00000)
$TxList = GUICtrlCreateListView("Tx No|Time|Item Code|Description|Qty|Price|Dept|Disc|Ref", 18, 80, 692, 528)
_GUICtrlListView_SetColumnWidth($TxList, 0, 15)														; Tx No
_GUICtrlListView_SetColumnWidth($TxList, 1, 50)														; Time
_GUICtrlListView_SetColumnWidth($TxList, 2, 60)														; Item Code
_GUICtrlListView_SetColumnWidth($TxList, 3, 180)													; Description
_GUICtrlListView_SetColumnWidth($TxList, 4, 40)														; Qty
_GUICtrlListView_SetColumnWidth($TxList, 5, 40)														; Price
_GUICtrlListView_SetColumnWidth($TxList, 6, 75)														; Dept
_GUICtrlListView_SetColumnWidth($TxList, 7, 40)														; Disc
_GUICtrlListView_SetColumnWidth($TxList, 8, 125)													; Ref
_GUICtrlListView_SetColumn ($TxList, 0, "Tx No", 50, 1)										; right-align tx no
_GUICtrlListView_SetColumn ($TxList, 2, "Item Code", 65, 1)								; right-align Item Code
_GUICtrlListView_SetColumn ($TxList, 4, "Qty", 35, 1)											; right-align qty
_GUICtrlListView_SetColumn ($TxList, 5, "Price", 40, 1)										; right-align Price
_GUICtrlListView_SetColumn ($TxList, 7, "Disc", 40, 1)										; right-align Disc
$ButRefresh = GUICtrlCreateButton("Refresh", 722, 115, 125, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButPrint = GUICtrlCreateButton("Print Receipt", 722, 195, 125, 42, $BS_MULTILINE)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)
#EndRegion
#Region Admin Tab
$Tab3 = GUICtrlCreateTabItem(" Admin       ")
$Group3 = GUICtrlCreateGroup("", 8, 32, 884, 585)
$ProdList = GUICtrlCreateListView("Item Code|Description|Price|Dept|SDisc|SQty|CDisc|CQty|FDisc|FQty|PDisc|PQty", 18, 80, 720, 528)
_GUICtrlListView_SetColumnWidth($ProdList, 0, 60)													; Item Code
_GUICtrlListView_SetColumnWidth($ProdList, 1, 165)												; Description
_GUICtrlListView_SetColumnWidth($ProdList, 2, 50)													; Price
_GUICtrlListView_SetColumnWidth($ProdList, 3, 50)													; SDisc
_GUICtrlListView_SetColumnWidth($ProdList, 4, 50)													; SQty
_GUICtrlListView_SetColumnWidth($ProdList, 5, 50)													; CDisc
_GUICtrlListView_SetColumnWidth($ProdList, 6, 50)													; CQty
_GUICtrlListView_SetColumnWidth($ProdList, 7, 50)													; PDisc
_GUICtrlListView_SetColumnWidth($ProdList, 8, 50)													; PQty
_GUICtrlListView_SetColumn ($ProdList, 0, "Item Code", 65, 1)							; right-align Item Code
_GUICtrlListView_SetColumn ($ProdList, 2, "Price", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 3, "Dept", 45, 0)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 4, "SDisc", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 5, "SQty", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 6, "CDisc", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 7, "CQty", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 8, "FDisc", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 9, "FQty", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 10, "PDisc", 45, 1)									; right-align 
_GUICtrlListView_SetColumn ($ProdList, 11, "PQty", 45, 1)									; right-align 
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ButLoad = GUICtrlCreateButton("Load List", 750, 110, 120, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButNew = GUICtrlCreateButton("New Item", 750, 165, 120, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButChange = GUICtrlCreateButton("Change Item", 750, 210, 120, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
$ButDelete = GUICtrlCreateButton("Delete Item", 750, 255, 120, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
#EndRegion
#Region Reports Tab
Local $dQuery, $dRow, $dlist

$Tab4 = GUICtrlCreateTabItem("Reports     ")
$Group4 = GUICtrlCreateGroup("", 8, 32, 884, 585)
; date filter
$DateGroup = GUICtrlCreateGroup("", 8, 32, 197, 96)
$DateSel1 = GUICtrlCreateRadio("Any Date", 36, 47, 70, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$DateSel2 = GUICtrlCreateRadio("Date From:", 36, 65, 70, 25)
$FromDate = GUICtrlCreateDate(_NowCalcDate(), 108, 68, 88, 20, $DTS_SHORTDATEFORMAT)
GUICtrlSetState(-1, $GUI_DISABLE)
$TDateTxt = GUICtrlCreateLabel("Date To:", 61, 96, 75, 25, $GUI_DISABLE)
$ToDate = GUICtrlCreateDate(_NowCalcDate(), 108, 93, 88, 20, $DTS_SHORTDATEFORMAT)
GUICtrlSetState(-1, $GUI_DISABLE)
; Item filter
$ItemGroup = GUICtrlCreateGroup("", 204, 32, 350, 96)
$iItemAll = GUICtrlCreateCheckbox("All Items", 215, 47, 70, 20)
GUICtrlSetState(-1, $GUI_CHECKED)
$iGroupItems = GUICtrlCreateCheckbox("Group Items", 215, 68, 80, 20)

$iItemThis = GUICtrlCreateCheckbox("This Item:", 315, 47, 70, 20)
$iItemList = GUICtrlCreateCombo("", 385, 47, 155, 20)
GUICtrlSetState(-1, $GUI_DISABLE)
$cItemThis = GUICtrlCreateCheckbox("This Code:", 315, 73, 70, 20, $GUI_DISABLE)
$cItemList = GUICtrlCreateCombo("", 385, 73, 155, 15)
GUICtrlSetState(-1, $GUI_DISABLE)
$dItemThis = GUICtrlCreateCheckbox("This Dept:", 315, 99, 70, 20, $GUI_DISABLE)
$dItemList = GUICtrlCreateCombo("", 385, 99, 155, 10)
GUICtrlSetState(-1, $GUI_DISABLE)
If GUICtrlRead($dItemList) = "" Then
	_SQlite_Query ($DataBase, "SELECT * FROM Dept ORDER BY Dept;", $dQuery)
		While _SQLite_FetchData ($dQuery, $dRow) = $SQLITE_OK  
			$dlist = $dlist & $dRow[0] & "|"
			If $DebugIt Then ConsoleWrite(StringFormat(" %-30s  %-10s  ", $dRow[0],  $dRow[1]) & @CR)		
		WEnd
		_SQLite_QueryFinalize($dQuery)
		GUICtrlSetData($dItemList, $dlist)
EndIf
;$CodeGroup = GUICtrlCreateGroup("", 450, 32, 245, 88)
$rTotalItems  = GUICtrlCreateLabel("Items: ", 565, 47, 300, 20)
$rTotalQty  = GUICtrlCreateLabel("Qty: ", 565, 67, 300, 20)
$rTotalDisc  = GUICtrlCreateLabel("Disc: ", 565, 87, 300, 20)
$rTotalExp  = GUICtrlCreateLabel("Exp: ", 565, 107, 300, 20)
$rTotalDrw  = GUICtrlCreateLabel("Drw: ", 685, 107, 300, 20)
;GUICtrlSetFont(-1, 11, 600, 0, "MS Sans Serif")
;$rTotalAmnt = GUICtrlCreateLabel("Amount:", 252, 105, 80, 25)
$rList = GUICtrlCreateListView("Tx No|Date|Time|Description|Qty|Price|Disc|Dept|Exp|Draw|Ref", 18, 128, 710, 480)
_GUICtrlListView_SetColumnWidth($rList, 0, 50)														; Tx No
_GUICtrlListView_SetColumnWidth($rList, 1, 50)														; Date
_GUICtrlListView_SetColumnWidth($rList, 2, 40)														; Time
_GUICtrlListView_SetColumnWidth($rList, 3, 170)														; Description
_GUICtrlListView_SetColumnWidth($rList, 4, 35)														; Qty
_GUICtrlListView_SetColumnWidth($rList, 5, 45)														; Price
_GUICtrlListView_SetColumnWidth($rList, 6, 40)														; Disc
_GUICtrlListView_SetColumnWidth($rList, 7, 70)														; Dept
_GUICtrlListView_SetColumnWidth($rList, 8, 40)														; Expenses
_GUICtrlListView_SetColumnWidth($rList, 9, 40)														; Drawings
_GUICtrlListView_SetColumnWidth($rList, 10, 90)														; Ref
_GUICtrlListView_SetColumn ($rList, 0, "Tx No", 50, 1)										; right-align tx no
_GUICtrlListView_SetColumn ($rList, 4, "Qty", 35, 1)											; right-align qty
_GUICtrlListView_SetColumn ($rList, 5, "Price", 45, 1)										; right-align Price
$ButrRefresh = GUICtrlCreateButton("Refresh", 742, 165, 125, 40, 0)
GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
GUICtrlCreateGroup("", -99, -99, 1, 1)

#EndRegion

GUISetState()
#Region Main loop
While 1
	$ItemTot = _GUICtrlListView_GetItemCount($ListView)	; how many items in list
	$nMsg = GUIGetMsg()
	#Region _IsPressed Keys
	If _IsPressed("73", $Dll) Then AddMan() ;F4 (Manual Enter)
	If _IsPressed("77", $Dll) Then;F8 (Total Key)
		$SubTot = Total()
		GUICtrlSetData($Display, "Total: R" & $SubTot) ; display total on screen
	EndIf
	If _IsPressed("78", $Dll) Then CashUp();F9 (Tender Cash)	
	If _IsPressed("7B", $Dll) Then;F12 (Clear/Done Key)
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView)) ; delete all items from list
		$dBuf = "" ; clear display buffer
		GUICtrlSetData($Display, "")
	EndIf
	If _IsPressed("75", $Dll) Then _GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($ListView)) ; F6 (Void Item)
	If _IsPressed("08", $Dll) Then ; Backspace	
		$dBuf = StringTrimRight($dBuf, 1)
		GUICtrlSetData($Display, $dBuf)
	EndIf
;~ 	If _IsPressed("60", $Dll) Then ShowDisp("0")							; show number on display	
;~ 	If _IsPressed("61", $Dll) Then ShowDisp("1")							; show number on display		
;~ 	If _IsPressed("62", $Dll) Then ShowDisp("2")							; show number on display		
;~ 	If _IsPressed("63", $Dll) Then ShowDisp("3")							; show number on display		
;~ 	If _IsPressed("64", $Dll) Then ShowDisp("4")							; show number on display		
;~ 	If _IsPressed("65", $Dll) Then ShowDisp("5")							; show number on display		
;~ 	If _IsPressed("66", $Dll) Then ShowDisp("6")							; show number on display		
;~ 	If _IsPressed("67", $Dll) Then ShowDisp("7")							; show number on display		
;~ 	If _IsPressed("68", $Dll) Then ShowDisp("8")							; show number on display		
;~ 	If _IsPressed("69", $Dll) Then ShowDisp("9")							; show number on display	
	If _IsPressed("6A", $Dll) Then 														; keypad * multiply
		If $ItemTot	Then																				; till mode
			If Not StringInStr($dBuf, "x") Then $dBuf = "x "
			GUICtrlSetData($Display, $dBuf)
		Else																										; calc mode
			Operator("x")
		EndIf
	EndIf	
	If _IsPressed("6B", $Dll) Then Operator("+")							; keypad + subtract		
	If _IsPressed("6D", $Dll) Then Operator("-")							; keypad - subtract		
	If _IsPressed("6F", $Dll) Then Operator(Chr(247))					; keypad / divide	
	#EndRegion _IsPressed Keys
	
	Switch $nMsg	
		Case $ButT1 To $ButT35 
			GUICtrlSetData ($DispT, "Till")	
			GUICtrlSetState($ButPlus, $GUI_DISABLE) 
			GUICtrlSetState($ButMinus, $GUI_DISABLE) 
			GUICtrlSetState($ButDiv, $GUI_DISABLE) 
;~ 			$ItmNo = $nMsg - 10
;~ 			MsgBox(0, "", "$nMsg " & $nMsg & @LF & "$ItmNo " & $ItmNo) 
	EndSwitch
	Switch $nMsg
		Case $GUI_EVENT_CLOSE		
			_PrintEndPrint($Prn)
			_PrintDllClose($Prn)
			_SQLite_Close()					
			_SQLite_Shutdown()
			DllClose($Dll)
      Exit		
		Case $ButC1	To $ButC11											; calc buttons
			If Not $ItemTot Then
				GUICtrlSetState($ButPlus, $GUI_ENABLE) 
				GUICtrlSetState($ButMinus, $GUI_ENABLE) 
				GUICtrlSetState($ButDiv, $GUI_ENABLE) 
			EndIf
			ShowDisp(GUICtrlRead($nMsg))							; show button text on display		
;~ 		Case $ButT1 To $ButT35
;~ 			While
;~ 				$msg = GUIGetMsg()			 
;~ 				If $msg = $GUI_EVENT_CLOSE ExitLoop
;~ 							 
;~ 				For $i = 0 To 99 Step 1
;~ 						If $msg = $button[$i] _cLabel(GUICtrlRead($button[$i]),$button[$i])
;~ 				Next			
;~
;~ 			WEnd
;~
;~ 			Func _cLabel($name,$btn)
;~ 					If $name = "N" Then GUICtrlSetData ($btn,"Y")
;~ 					If $name = "Y" Then GUICtrlSetData ($btn,"N")
;~ 			EndFunc

		Case $ButT1																	; Till buttons	
			GUICtrlCreateListViewItem($But1[1] & "|" & $But1[2] & "|1|" & StringFormat("%.2f", $But1[3]) & "|" & $But1[4], $ListView)
			ConsoleWrite(@LF & @LF & $But1[1] & "|" & $But1[2] & "|1|" & StringFormat("%.2f", $But1[3]) & "|" & $But1[4] & @LF)
			GUICtrlSetData($Display, $But1[2])
		Case $ButT2
			GUICtrlCreateListViewItem($But2[1] & "|" & $But2[2] & "|1|" & StringFormat("%.2f", $But2[3]) & "|" & $But2[4], $ListView)
			GUICtrlSetData($Display, $But2[2])
		Case $ButT3
			GUICtrlCreateListViewItem($But3[1] & "|" & $But3[2] & "|1|" & StringFormat("%.2f", $But3[3]) & "|" & $But3[4], $ListView)
			GUICtrlSetData($Display, $But3[2])
		Case $ButT4
			GUICtrlCreateListViewItem($But4[1] & "|" & $But4[2] & "|1|" & StringFormat("%.2f", $But4[3]) & "|" & $But4[4], $ListView)
			GUICtrlSetData($Display, $But4[2])
		Case $ButT5
			GUICtrlCreateListViewItem($But5[1] & "|" & $But5[2] & "|1|" & StringFormat("%.2f", $But5[3]) & "|" & $But5[4], $ListView)
			GUICtrlSetData($Display, $But5[2])
		Case $ButT6
			GUICtrlCreateListViewItem($But6[1] & "|" & $But6[2] & "|1|" & StringFormat("%.2f", $But6[3]) & "|" & $But6[4], $ListView)
			GUICtrlSetData($Display, $But6[2])
		Case $ButT7
			GUICtrlCreateListViewItem($But7[1] & "|" & $But7[2] & "|1|" & StringFormat("%.2f", $But7[3]) & "|" & $But7[4], $ListView)
			GUICtrlSetData($Display, $But7[2])
		Case $ButT8
			GUICtrlCreateListViewItem($But8[1] & "|" & $But8[2] & "|1|" & StringFormat("%.2f", $But8[3]) & "|" & $But8[4], $ListView)
			GUICtrlSetData($Display, $But8[2])
		Case $ButT9
			GUICtrlCreateListViewItem($But9[1] & "|" & $But9[2] & "|1|" & StringFormat("%.2f", $But9[3]) & "|" & $But9[4], $ListView)
			GUICtrlSetData($Display, $But9[2])
		Case $ButT10
			GUICtrlCreateListViewItem($But10[1] & "|" & $But10[2] & "|1|" & StringFormat("%.2f", $But10[3]) & "|" & $But10[4], $ListView)
			GUICtrlSetData($Display, $But10[2])
		Case $ButT11
			GUICtrlCreateListViewItem($But11[1] & "|" & $But11[2] & "|1|" & StringFormat("%.2f", $But11[3]) & "|" & $But11[4], $ListView)
			GUICtrlSetData($Display, $But11[2])
		Case $ButT12
			GUICtrlCreateListViewItem($But12[1] & "|" & $But12[2] & "|1|" & StringFormat("%.2f", $But12[3]) & "|" & $But12[4], $ListView)
			GUICtrlSetData($Display, $But12[2])
		Case $ButT13
			GUICtrlCreateListViewItem($But13[1] & "|" & $But13[2] & "|1|" & StringFormat("%.2f", $But13[3]) & "|" & $But13[4], $ListView)
			GUICtrlSetData($Display, $But13[2])
		Case $ButT14
			GUICtrlCreateListViewItem($But14[1] & "|" & $But14[2] & "|1|" & StringFormat("%.2f", $But14[3]) & "|" & $But14[4], $ListView)
			GUICtrlSetData($Display, $But14[2])
		Case $ButT15
			GUICtrlCreateListViewItem($But15[1] & "|" & $But15[2] & "|1|" & StringFormat("%.2f", $But15[3]) & "|" & $But15[4], $ListView)
			GUICtrlSetData($Display, $But15[2])
		Case $ButT16
			GUICtrlCreateListViewItem($But16[1] & "|" & $But16[2] & "|1|" & StringFormat("%.2f", $But16[3]) & "|" & $But16[4], $ListView)
			GUICtrlSetData($Display, $But16[2])		
		Case $ButT17
			GUICtrlCreateListViewItem($But17[1] & "|" & $But17[2] & "|1|" & StringFormat("%.2f", $But17[3]) & "|" & $But17[4], $ListView)
			GUICtrlSetData($Display, $But17[2])	
		Case $ButT18
			GUICtrlCreateListViewItem($But18[1] & "|" & $But18[2] & "|1|" & StringFormat("%.2f", $But18[3]) & "|" & $But18[4], $ListView)
			GUICtrlSetData($Display, $But18[2])	
		Case $ButT19
			GUICtrlCreateListViewItem($But19[1] & "|" & $But19[2] & "|1|" & StringFormat("%.2f", $But19[3]) & "|" & $But19[4], $ListView)
			GUICtrlSetData($Display, $But19[2])	
		Case $ButT20
			GUICtrlCreateListViewItem($But20[1] & "|" & $But20[2] & "|1|" & StringFormat("%.2f", $But20[3]) & "|" & $But20[4], $ListView)
			GUICtrlSetData($Display, $But20[2])
		Case $ButT21
			GUICtrlCreateListViewItem($But21[1] & "|" & $But21[2] & "|1|" & StringFormat("%.2f", $But21[3]) & "|" & $But21[4], $ListView)
			GUICtrlSetData($Display, $But21[2])
		Case $ButT22
			GUICtrlCreateListViewItem($But22[1] & "|" & $But22[2] & "|1|" & StringFormat("%.2f", $But22[3]) & "|" & $But22[4], $ListView)
			GUICtrlSetData($Display, $But22[2])
		Case $ButT23
			GUICtrlCreateListViewItem($But23[1] & "|" & $But23[2] & "|1|" & StringFormat("%.2f", $But23[3]) & "|" & $But23[4], $ListView)
			GUICtrlSetData($Display, $But23[2])
		Case $ButT24
			GUICtrlCreateListViewItem($But24[1] & "|" & $But24[2] & "|1|" & StringFormat("%.2f", $But24[3]) & "|" & $But24[4], $ListView)
			GUICtrlSetData($Display, $But24[2])
		Case $ButT25
			GUICtrlCreateListViewItem($But25[1] & "|" & $But25[2] & "|1|" & StringFormat("%.2f", $But25[3]) & "|" & $But25[4], $ListView)
			GUICtrlSetData($Display, $But25[2])
		Case $ButT26
			GUICtrlCreateListViewItem($But26[1] & "|" & $But26[2] & "|1|" & StringFormat("%.2f", $But26[3]) & "|" & $But26[4], $ListView)
			GUICtrlSetData($Display, $But26[2])
		Case $ButT27
			GUICtrlCreateListViewItem($But27[1] & "|" & $But27[2] & "|1|" & StringFormat("%.2f", $But27[3]) & "|" & $But27[4], $ListView)
			GUICtrlSetData($Display, $But27[2])
		Case $ButT28
			GUICtrlCreateListViewItem($But28[1] & "|" & $But28[2] & "|1|" & StringFormat("%.2f", $But28[3]) & "|" & $But28[4], $ListView)
			GUICtrlSetData($Display, $But28[2])
		Case $ButT29
			GUICtrlCreateListViewItem($But29[1] & "|" & $But29[2] & "|1|" & StringFormat("%.2f", $But29[3]) & "|" & $But29[4], $ListView)
			GUICtrlSetData($Display, $But29[2])			
		Case $ButT30
			GUICtrlCreateListViewItem($But30[1] & "|" & $But30[2] & "|1|" & StringFormat("%.2f", $But30[3]) & "|" & $But30[4], $ListView)
			GUICtrlSetData($Display, $But30[2])
		Case $ButT31
			GUICtrlCreateListViewItem($But31[1] & "|" & $But31[2] & "|1|" & StringFormat("%.2f", $But31[3]) & "|" & $But31[4], $ListView)
			GUICtrlSetData($Display, $But31[2])
		Case $ButT32
			GUICtrlCreateListViewItem($But32[1] & "|" & $But32[2] & "|1|" & StringFormat("%.2f", $But32[3]) & "|" & $But32[4], $ListView)
			GUICtrlSetData($Display, $But32[2])
		Case $ButT33
			GUICtrlCreateListViewItem($But33[1] & "|" & $But33[2] & "|1|" & StringFormat("%.2f", $But33[3]) & "|" & $But33[4], $ListView)
			GUICtrlSetData($Display, $But33[2])
		Case $ButT34
			GUICtrlCreateListViewItem($But34[1] & "|" & $But34[2] & "|1|" & StringFormat("%.2f", $But34[3]) & "|" & $But34[4], $ListView)
			GUICtrlSetData($Display, $But34[2])
		Case $ButT35
			GUICtrlCreateListViewItem($But35[1] & "|" & $But35[2] & "|1|" & StringFormat("%.2f", $But35[3]) & "|" & $But35[4], $ListView)
			GUICtrlSetData($Display, $But35[2])
	EndSwitch
	Switch $nMsg
		Case $ButT1 To $ButT35
			; ensures the last item entered is selected
			_GUICtrlListView_SetItemSelected(GUICtrlGetHandle($ListView), $ItemTot)			
	EndSwitch	
	Switch $nMsg
		Case $ButVoid
			_GUICtrlListView_DeleteItemsSelected(GUICtrlGetHandle($ListView)) ; single item delete				
		Case $ButClear
			_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))			; delete all items from list
			$dBuf = ""																												; clear display buffer
			GUICtrlSetState($ButPlus, $GUI_ENABLE) 
			GUICtrlSetState($ButMinus, $GUI_ENABLE) 
			GUICtrlSetState($ButDiv, $GUI_ENABLE) 
			GUICtrlSetData($Display, "")
		Case $ButPlus
			Operator("+")
		Case $ButMinus
			Operator("-")
		Case $ButDiv
			Operator(Chr(247))
		Case $ButMult
			If $ItemTot	Then																									; till mode
				If Not StringInStr($dBuf, "x") Then 
					$dBuf = "x "
					GUICtrlSetData($Display, $dBuf)
				EndIf
			Else																															; calc mode
				Operator("x")
			EndIf
		Case $ButBack	
			$dBuf = StringTrimRight($dBuf, 1)
			GUICtrlSetData($Display, $dBuf)
		Case $ButEnter
			EnterBut()
		Case $ButTotal																		
			$SubTot = Total()
			GUICtrlSetData($Display, "Total: R" & $SubTot)										; display total on screen
			$dBuf = ""
		Case $ButCash																			
			CashUp()
		Case $ButManual
			AddMan()																														; open manual entry screen
		Case $TxDate
			$dbits = StringSplit(GUICtrlRead($TxDate), "/")											; split date into array
			$dWkday = _DateToDayOfWeek ($dbits[1], $dbits[2], $dbits[3])				; swop day & year around
			$Day = _DateDayOfWeek($dWkday)																			; get day of week
			GUICtrlSetData($DayTxt, $Day)																				; display day of week
		Case $ButRefresh
			PopTxList()																													; populate transaction list
		Case $ButPrint
			$sel = _GUICtrlListView_GetItemText(GUICtrlGetHandle($TxList), _		; check which item selected
						 _GetSelectedItem(GUICtrlGetHandle($TxList)), 0)
			If Not $sel Then
				MsgBox(16, "No selection...", "Please select a transaction to print.")
			Else
				PrintSlip($sel)																										; print selected transaction
			EndIf
		Case $ButLoad
			PopProdList()																												; populate product list
		Case $ButNew
			AddNewItem() 																												; Add a new item
			If Not @error Then PopProdList()																		; Refresh the product list
		Case $ButChange
			EditItem()																													; edit the selected item 																										
			If Not @error Then PopProdList() 																		; Refreshes the list
		Case $ButDelete
			$sel = _GetSelectedItem($ProdList)																	; read selected item
			If _GUICtrlListView_GetItemText($ProdList, $sel, 0) Then						
				$conf = MsgBox(20, "Confirm Delete...", "Are you sure you want to delete '" & _ 
				_GUICtrlListView_GetItemText ($ProdList, $sel, 1) & "'?")
				If $conf = 6 Then
					_SQLite_Exec ($DataBase, "DELETE FROM Products WHERE ItemCode = '"&_GUICtrlListView_GetItemText ($ProdList, $sel, 0)&"';")
					PopProdList()																										; refresh prod list
				EndIf
			EndIf
		Case $DateSel1	
			If BitAND(GUICtrlRead($DateSel1), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyDate = 1
				GUICtrlSetState($FromDate, $GUI_DISABLE)
				GUICtrlSetState($ToDate, $GUI_DISABLE)
				GUICtrlSetState($TDateTxt, $GUI_DISABLE)
			EndIf
		Case $DateSel2	
			If BitAND(GUICtrlRead($DateSel2), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyDate = 0
				GUICtrlSetState($FromDate, $GUI_ENABLE)
				GUICtrlSetState($ToDate, $GUI_ENABLE)
				GUICtrlSetState($TDateTxt, $GUI_ENABLE)
			EndIf
		Case $ToDate
			If GUICtrlRead($ToDate) < GUICtrlRead($FromDate) Then GUICtrlSetData($FromDate, GUICtrlRead($ToDate))
		Case $FromDate
			If GUICtrlRead($ToDate) < GUICtrlRead($FromDate) Then GUICtrlSetData($ToDate, GUICtrlRead($FromDate))	
		Case $iItemAll	
			If BitAND(GUICtrlRead($iItemAll), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyItem = 1
				GUICtrlSetState($iItemList, $GUI_DISABLE)
				GUICtrlSetState($cItemList, $GUI_DISABLE)
				GUICtrlSetState($dItemList, $GUI_DISABLE)
				GUICtrlSetState($iGroupItems, $GUI_ENABLE)
				GUICtrlSetState($iItemThis, $GUI_UNCHECKED)
				GUICtrlSetState($cItemThis, $GUI_UNCHECKED)
				GUICtrlSetState($dItemThis, $GUI_UNCHECKED)
			EndIf
		Case $iItemThis	
			If BitAND(GUICtrlRead($iItemThis), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyItem = 0
				GUICtrlSetState($iItemList, $GUI_ENABLE)
				GUICtrlSetState($cItemList, $GUI_DISABLE)
				GUICtrlSetState($dItemList, $GUI_DISABLE)
				GUICtrlSetState($iGroupItems, $GUI_DISABLE)
				GUICtrlSetState($iItemAll, $GUI_UNCHECKED)
				GUICtrlSetState($cItemThis, $GUI_UNCHECKED)
				GUICtrlSetState($dItemThis, $GUI_UNCHECKED)
			EndIf
		Case $cItemThis	
			If BitAND(GUICtrlRead($cItemThis), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyItem = 0
				GUICtrlSetState($iItemList, $GUI_DISABLE)
				GUICtrlSetState($cItemList, $GUI_ENABLE)
				GUICtrlSetState($dItemList, $GUI_DISABLE)
				GUICtrlSetState($iGroupItems, $GUI_DISABLE)
				GUICtrlSetState($iItemAll, $GUI_UNCHECKED)
				GUICtrlSetState($iItemThis, $GUI_UNCHECKED)
				GUICtrlSetState($dItemThis, $GUI_UNCHECKED)
			EndIf
		Case $dItemThis	
			If BitAND(GUICtrlRead($dItemThis), $GUI_CHECKED) = $GUI_CHECKED Then	; if checked
				$AnyItem = 0
				GUICtrlSetState($iItemList, $GUI_DISABLE)
				GUICtrlSetState($cItemList, $GUI_DISABLE)
				GUICtrlSetState($dItemList, $GUI_ENABLE)
				GUICtrlSetState($iGroupItems, $GUI_DISABLE)
				GUICtrlSetState($iItemAll, $GUI_UNCHECKED)
				GUICtrlSetState($iItemThis, $GUI_UNCHECKED)
				GUICtrlSetState($cItemThis, $GUI_UNCHECKED)
			EndIf
		Case $ButrRefresh
			PopRepList()																				; populate report list
			If Not $AnyItem Then																; if reporting single item
				;GUICtrlSetData($rTotalItems, "Items:  " & $TotItems & "    Qty: " & $TotQty & "     R " & $TotAmnt)
			Else																									
				;GUICtrlSetData($rTotalItems, "Items:  " & $TotItems & "         R " & $TotAmnt)			
			EndIf
		Case $PrintToggle
			If GUICtrlRead($PrintToggle) = 1 Then
				GUICtrlSetData($DispP, "Printer ON")
				GUICtrlSetData($PrintToggle, "Printer ON")
			Else
				GUICtrlSetData($DispP, "Printer OFF")
				GUICtrlSetData($PrintToggle, "Printer OFF")
			EndIf	
		Case $TabSheet
			If GUICtrlRead($TabSheet) = 3 Then
				;If Not GUICtrlRead($ItemList)										; if combo list empty?
					$itmLst = FillCombo(6, 1)												; get sorted list of all items
					GUICtrlSetData($iItemList, $itmLst)	
				;EndIf
				;If Not GUICtrlRead($ItemList)										; if combo list empty?
					$itmLst = FillCombo(6, 0)												; get unsorted list of all items
					GUICtrlSetData($cItemList, $itmLst)	
				;EndIf
				
			EndIf
	EndSwitch
WEnd
#EndRegion

Func Total()
	$SubTot = ""
	;$TotalTax = ""
	For $i = 0 To $ItemTot																							; loop thru each item
		$p = _GUICtrlListView_GetItemText($ListView, $i, 3)								; read item price
		$SubTot = $SubTot + $p																						; add up the prices
	Next
	Return StringFormat("%.2f", Round($SubTot, 2))										; format to 2 digits after comma
	
EndFunc

Func EnterBut()	
	If $ItemTot Then 																									; till mode
		If StringInStr($dBuf, "x") Then
			$opr = StringSplit($dBuf, "x")															
			$sel = _GetSelectedItem(GUICtrlGetHandle($ListView))					; which item selected
			_GUICtrlListView_SetItemSelected(GUICtrlGetHandle($ListView), $sel) ;	show selection
			$itm = _GUICtrlListView_GetItemText($ListView, $sel, 1)				; read item desc	
			$idx = _ArraySearch($ProdArr, $itm, 0, 0, 0, 1)								; find description index in product array
			$ItmBits = StringSplit($ProdArr[$idx], "|")										; split item to elements	
			$iPrice = $ItmBits[3]																					; read item price	
			$TotPrice = StringFormat("%.2f", Round($iPrice * $opr[2], 2))
			;MsgBox(0, "", "Qty = " & $opr[2] & @LF & "$iPrice = " & $iPrice & @LF & "$TotPrice = " & $TotPrice)
			_GUICtrlListView_SetItemText(GUICtrlGetHandle($ListView), $sel, $opr[2], 2)
			_GUICtrlListView_SetItemText(GUICtrlGetHandle($ListView), $sel, $TotPrice, 3)					
			$dBuf = ""
			GUICtrlSetData($Display, $dBuf)
		EndIf					
	Else																															; calculator mode				
		If Not StringInStr($dBuf, "=") Then															; not pressed before
			$Res = Calc($dBuf)																						; do calc
			GUICtrlSetData($Display, $dBuf & " = " & $Res)
			$dBuf = ""
		EndIf
	EndIf
EndFunc	; ==> EnterBut()

Func Cashup()	
	If $ItemTot Then
		$SubTot = Total()
		GUICtrlSetData($Display, "Total: R" & $SubTot)										; display total on screen
		If $DebugIt Then ConsoleWrite("F9 (Tender Cash) pressed. $ItemTot = " & $ItemTot & ";  $SubTot = " & $SubTot & @LF)  
		$Cash = ""	
		$Cash = InputBox("Cash Pay", "Enter Amount Paid", "", "", 5, 5)	
		If Not @error Then
			$ErrCheck1 = 0
			If Not $Cash Then $Cash = $SubTot ; if no cash entered, assume exact cash tendered
			$Chg = StringFormat("%.2f", Round($Cash - $SubTot, 2)) ; calc change
			If $Chg > 0 Then ; some change
				GUICtrlSetData($Display, "Change: R" & $Chg)
			ElseIf $Chg = 0 Then
				GUICtrlSetData($Display, "")
			Else
				MsgBox(4096, "Error", "The Current Customer Still Owes " & StringTrimLeft($Chg, 1), -1, $MainWin)
				$ErrCheck1 = 1
			EndIf
			If $ErrCheck1 = 0 Then
				AddTx() ; add transaction to database
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView)) ; delete all items from list
				$dBuf = "" ; clear display buffer
			EndIf
		EndIf
	EndIf
EndFunc

#cs
$Cash = ""
			$SubTot = 0
			$Cash = InputBox("Cash Pay", "Enter Amount Paid", "", "", 5, 5)
			If Not @error Then
				For $i = 0 To $ItemTot																						; loop thru each item
					$N = _GUICtrlListView_GetItemText($ListView, $i, 2)							; read item price
					$SubTot = $SubTot + $N																					; add up the prices
				Next
				If Not $Cash Then $Cash = $SubTot																	; if no cash entered, assume exact cash tendered
				$Chg = StringFormat("%.2f", Round($Cash - $SubTot, 2))						; calc change
				If $Chg > 0 Then																									; some change
					GUICtrlSetData($Display, "Change: R" & $Chg)
				Else																															; no change
					GUICtrlSetData($Display, "")												
				EndIf	
				AddTx()																														; add transaction to database
				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))			; delete all items from list	
				$dBuf = ""																											; clear display buffer
			EndIf	
#ce

Func ShowDisp($show="")	
	If $dBuf = "" And Not $ItemTot Then GUICtrlSetData ($DispT, "Calc")
	$dBuf &= $show
	GUICtrlSetData($Display, $dBuf)
	;MsgBox(0, "Display output", "Button = " & $ID & @LF & "Buffer = " & $dBuf & @LF & "Display " & $Display )
EndFunc

Func Operator($opr)
	If $dBuf Then																											;	we already got numbers	
		$Res = Calc($dBuf)																							; check if any calc pending
		Switch $opr
			Case "-"
				If @error Then																									; no calculation pending
					If Not StringInStr($dBuf, "-") Then
						$dBuf &= " - "
						GUICtrlSetData($Display, $dBuf)
					EndIf
				Else		
					GUICtrlSetData($Display, $dBuf & " = " & $Res & " - ")				; start new calc
					$dBuf = $Res & " - "																					; continue with result
				EndIf	
			Case "+"
				If @error Then																									; no calculation pending
					If Not StringInStr($dBuf, "+") Then
						$dBuf &= " + "
						GUICtrlSetData($Display, $dBuf)
					EndIf
				Else			
					GUICtrlSetData($Display, $dBuf & " = " & $Res & " + ")				; start new calc
					$dBuf = $Res & " + "																					; continue with result													
				EndIf	
			Case "x"
				If @error Then																									; no calculation pending
					If Not StringInStr($dBuf, "x") Then
						$dBuf &= " x "
						GUICtrlSetData($Display, $dBuf)
					EndIf
				Else			
					GUICtrlSetData($Display, $dBuf & " = " & $Res & " x ")				; start new calc
					$dBuf = $Res & " x "																					; continue with result													
				EndIf	
			Case Chr(247)
				If @error Then																									; no calculation pending
					If Not StringInStr($dBuf, Chr(247)) Then
						$dBuf &= " " & Chr(247) & " "
						GUICtrlSetData($Display, $dBuf)
					EndIf
				Else		
					GUICtrlSetData($Display, $dBuf & " = " & $Res & " " & Chr(247) & " ")																
					$dBuf = $Res & " " & Chr(247) & " "																						
				EndIf	
		EndSwitch
	Else																														; we have a result	
			
	EndIf
EndFunc

Func Calc($expn)
	Select
		Case StringInStr($expn, "x") 
			$exp = StringSplit($expn, "x")
			If $exp[0] = 2 Then																					; we have our numbers
				$Res  = Number($exp[1]) * Number($exp[2])
				Return($Res)
			Else																												
				SetError(1)
			EndIf
		Case StringInStr($expn, "+") 
			$exp = StringSplit($expn, "+")
			If $exp[0] = 2 Then																					; we have our numbers
				$Res = Number($exp[1]) + Number($exp[2])
				Return($Res)
			Else																												; no addition here
				SetError(1)
			EndIf
		Case StringInStr($expn, "-") 
			$exp = StringSplit($expn, "-")
			If $exp[0] = 2 Then																					; we have our numbers
				$Res = Number($exp[1]) - Number($exp[2])
				Return($Res)
			Else																												
				SetError(1)
			EndIf
		Case StringInStr($expn, Chr(247)) 
			$exp = StringSplit($expn, Chr(247))
			If $exp[0] = 2 Then																					; we have our numbers
				$Res = Number($exp[1]) / Number($exp[2])
				Return($Res)
			Else																												
				SetError(1)
			EndIf
		Case Else
			SetError(1)			
	EndSelect
EndFunc		

Func AddTx()
	; add transaction to database
	Dim $skip, $code, $desc, $qty, $price, $dept, $disc, $dref
	
	If Not $TxNo Then $TxNo = GetLastTx()	
	
	$TxNo += 1		
	$tDate = _NowCalcDate()
	$tTime =_NowTime(5)
	$ItemTot = _GUICtrlListView_GetItemCount($ListView)
	For $i = 0 To $ItemTot-1
		$code = _GUICtrlListView_GetItemText($ListView, $i, 0)	; item code
		$desc = _GUICtrlListView_GetItemText($ListView, $i, 1)	; item description
		$qty = _GUICtrlListView_GetItemText($ListView, $i, 2)		; qty
		$price = _GUICtrlListView_GetItemText($ListView, $i, 3)	; item price
		$dept = _GUICtrlListView_GetItemText($ListView, $i, 4)	; dept
		If $price = 0 Then ContinueLoop													; skip empty items
		$Res = _SQLite_Exec(-1 , "INSERT INTO DAILY (TxNo, Date, Time, ItemCode, Description, Qty, Price, Dept, Disc, DiscRef) " & _
					"VALUES ('" & $TxNo & "', '" & $tDate&  "', '"& $tTime& "', '"& $code & "', '" & $desc & "', '" & $qty & "', '" & _
									$price & "', '" & $dept & "', '" & $disc & "', '"&$dref & "' );")
		If $DebugIt Then 
			ConsoleWrite("VALUES ('" & $TxNo & "', '" & $tDate&  "', '"& $tTime& "', '"& $code & "', '" & $code & "', '" & $qty & "', '" & _
									$price & "', '" & $dept & "', '" & $disc & "', '"&$dref & "' );" & @LF)						
			If $Res = $SQLITE_OK Then
				ConsoleWrite("INSERT success" & @LF & @LF)
			Else
				ConsoleWrite("SQLite Error: " & _SQLite_ErrMsg())
			EndIf
		EndIf
	Next
	If GUICtrlRead($PrintToggle) = 1 Then PrintSlip($TxNo)
	
EndFunc

Func GetLastTx()
	; this function returns the last transaction no

	Local $TxQry, $LastTx
	
	_SQlite_Query($DataBase, "SELECT * FROM Daily ORDER BY TxNo DESC LIMIT 1;", $TxQry)
	_SQLite_FetchData($TxQry, $LastTx)
	_SQLite_QueryFinalize($TxQry)
	Return $LastTx[0]		
	
EndFunc

Func _GetSelectedItem($List)
	$itemRs = _GUICtrlListView_GetSelectedIndices($List, True)
	If Not $itemRs[0] = 0 Then
		Return $itemRs[1]
	Else
		Return 0
	EndIf
EndFunc

Func PopProdList()
	; populates the product list on admin tab
	
	Local $pQuery, $aRow, $i = 0
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ProdList))
	_SQlite_Query ($DataBase, "SELECT * FROM Products ORDER BY ItemCode ;", $pQuery)
	_GUICtrlListView_BeginUpdate($ProdList)
	While _SQLite_FetchData ($pQuery, $aRow) = $SQLITE_OK
		GUICtrlCreateListViewItem($aRow[0] & "|" & $aRow[1] & "|" & StringFormat("%.2f", $aRow[2]) & "|" & $aRow[3] & _
															"|" & StringFormat("%.2f", $aRow[4]) & "|" & $aRow[5] & "|" & StringFormat("%.2f", $aRow[6]) & _
															"|" & $aRow[7] & "|" & StringFormat("%.2f", $aRow[8]), $ProdList)
		GUICtrlSetFont(-1, 30, 800, 2, "verdana")
		$i = $i + 1
	WEnd
	_GUICtrlListView_EndUpdate($ProdList)
;~ 	(ItemCode, Description, Price, Dept, SDisc, SQty, CDisc, CQty, PDisc, PQty)
	If $DebugIt Then 
		ConsoleWrite("Item Code|Description|Price|Dept|SDisc|SQty|CDisc|CQty|PDisc|PQty" & @LF)													
		ConsoleWrite($aRow[0] & "|"&$aRow[1] & "|"& StringFormat($aRow[2], "%.2f") & "|" & $aRow[3] & _
														"|" & $aRow[4] & "|" & StringFormat("%.2f", $aRow[5])&"|"&$aRow[6]& _
														"|"&StringFormat("%.2f", $aRow[7])&"|"&$aRow[8] & @LF)	
	EndIf
	_SQLite_QueryFinalize($Query)	
EndFunc

Func PopTxList()
	; populates the transaction list
	
	Local $TxQuery, $TxRow, $i = 0
	
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($TxList))
	_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Date = '" & GUICtrlRead($TxDate) & "' ORDER BY TxNo ;", $TxQuery)
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($TxList))
	While _SQLite_FetchData ($TxQuery, $TxRow) = $SQLITE_OK
		Sleep(20)
		GUICtrlCreateListViewItem($TxRow[0] & "|" & $TxRow[2] & "|" & $TxRow[3] & "|" & $TxRow[4] & "|" & _ 
															$TxRow[5] & "|" & StringFormat("%.2f", $TxRow[6]) & "|" & $TxRow[7], $TxList)
		GUICtrlSetFont(-1, 30, 800, 2, "verdana")
		$i = $i + 1
	WEnd	
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($TxList))	
	_SQLite_QueryFinalize($TxQuery)
EndFunc

Func PopRepList()
	; populates the report list	
	$i = 0
	Local $Query, $aRow
	_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($rList))
	Select	
		Case $AnyDate And $AnyItem																; any date, any item
			If GUICtrlRead($iGroupItems) = 1	Then									; grouping required
				_SQlite_Query ($DataBase, "SELECT * FROM Daily ORDER BY Description ;", $Query)
			Else																										; no grouping, so sort by tx no
				_SQlite_Query ($DataBase, "SELECT * FROM Daily ORDER BY TxNo ;", $Query)
			EndIf
		Case $AnyDate And Not $AnyItem														; any date, single item selected
			Select						
				Case GUICtrlRead($iItemThis) = 1
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Description = '" & GUICtrlRead($iItemList) & _
																	"' ORDER BY TxNo ;", $Query)		
				Case GUICtrlRead($cItemThis) = 1
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE ItemCode = '" & Number(StringLeft(GUICtrlRead($cItemList), 3)) & _
																	"' ORDER BY TxNo ;", $Query)
				Case GUICtrlRead($dItemThis) = 1
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Dept = '" & GUICtrlRead($dItemList) & _
																	"' ORDER BY TxNo ;", $Query)
			EndSelect
		Case Not $AnyDate And $AnyItem														; date selected, no item selected
			If GUICtrlRead($iGroupItems) = 1	Then									; grouping required
				_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Date BETWEEN '" & GUICtrlRead($FromDate) & "' AND '" & _
																	GUICtrlRead($ToDate) & "' ORDER BY Description ;", $Query)
			Else																										; no grouping, so sort by tx no
				_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Date BETWEEN '" & GUICtrlRead($FromDate) & "' AND '" & _
																	GUICtrlRead($ToDate) & "' ORDER BY TxNo ;", $Query)
			EndIf
		Case Not $AnyDate And Not $AnyItem											; date selected, single item	selected
			Select						
				Case GUICtrlRead($iItemThis) = 1										
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Description = '" & GUICtrlRead($iItemList) & _
																	"' AND Date BETWEEN '" & GUICtrlRead($FromDate) & "' AND '" & GUICtrlRead($ToDate) & _
																	"' ORDER BY TxNo ;", $Query)		
				Case GUICtrlRead($cItemThis) = 1
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE ItemCode = '" & Number(StringLeft(GUICtrlRead($cItemList), 3)) & _
																	"' AND Date BETWEEN '" & GUICtrlRead($FromDate) & "' AND '" & GUICtrlRead($ToDate) & _
																	"' ORDER BY TxNo ;", $Query)
				Case GUICtrlRead($dItemThis) = 1
					_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE Dept = '" & GUICtrlRead($dItemList) & _
																	"' AND Date BETWEEN '" & GUICtrlRead($FromDate) & "' AND '" & GUICtrlRead($ToDate) & _
																	"' ORDER BY TxNo ;", $Query)
			EndSelect							
	EndSelect
	;Local $TotQty, $TotAmnt, $TotItems, $TotDisc, $TotExp, $TotDrw
	Local $dPrice, $dDisc, $dExp, $dDrw	
	$TotItems = 0
	$TotAmnt = 0
	$TotQty = 0
	$TotDrw = 0
	$TotDisc = 0
	$TotExp = 0
	_GUICtrlListView_BeginUpdate(GUICtrlGetHandle($rList))	
	While _SQLite_FetchData ($Query, $aRow) = $SQLITE_OK
		$dbits = StringSplit($aRow[1], "/")
		$TotItems += 1
		$TotQty += $aRow[5]
		If $aRow[6] < 0	Then															; expense or disc start from 800
			If $aRow[3] < 800 Then													; expense				
				$TotExp += $aRow[6]*-1												; add up expenses & convert to +ve number
				$dPrice = ""
				$dDisc = ""
				$dExp = StringFormat("%.2f", $aRow[6]*-1)
				$dDisc = ""
				$dDrw = ""
			ElseIf $aRow[3] >= 800 And $aRow[3] < 900	Then	; drawings
				$TotDrw += $aRow[6]*-1												; add up drawings			
				$dPrice = ""
				$dDisc = ""
				$dExp = ""
				$dDisc = ""
				$dDrw = StringFormat("%.2f", $aRow[6]*-1)
			ElseIf $aRow[3] >= 900	Then										; discounts
				$TotDisc += $aRow[6]*-1												; add up discounts		
				$dPrice = ""
				$dDisc = ""
				$dExp = ""
				$dDisc = StringFormat("%.2f", $aRow[6]*-1)
				$dDrw = ""
			EndIf
		Else																							; income
			$TotAmnt += $aRow[6]		
			$dPrice = StringFormat("%.2f", $aRow[6])
			$dDisc = ""
			$dExp = ""
			$dDisc = ""
			$dDrw = ""
		EndIf
		; Table = (TxNo.0, Date.1, Time.2, ItemCode.3, Description.4, Qty.5, Price.6, Dept.7, Disc.8, DiscRef.9)
		; ListV = (Tx No|Date|Time|Description|Qty|Price|Disc|Dept|Exp|Draw|Ref)
		GUICtrlCreateListViewItem($aRow[0] & "|" & $dbits[3] & "/" & $dbits[2] & "/" & $dbits[1] & "|" & $aRow[2] & "|" & $aRow[4] & "|" & _ 
															$aRow[5] & "|" & $dPrice & "|" & $dDisc & "|" & $aRow[7] & "|" & $dExp & "|" & _
															$dDrw & "|" & $aRow[9], $rList)
		GUICtrlSetFont(-1, 30, 800, 2, "verdana")
	WEnd
	_GUICtrlListView_EndUpdate(GUICtrlGetHandle($rList))	
	; update display totals
	$TotAmnt = StringFormat("%.2f", $TotAmnt)
	GUICtrlSetData($rTotalItems, "Tot Items: " & $TotItems & "     R " & $TotAmnt) 
	If $AnyItem Then
		GUICtrlSetData($rTotalQty, "") 
	Else
		GUICtrlSetData($rTotalQty, "Tot Qty: " & $TotQty) 
	EndIf	
	
	$TotDisc = StringFormat("%.2f", $TotDisc)
	GUICtrlSetData($rTotalDisc, "Tot Disc: " & $TotDisc) 
	
	$TotExp = StringFormat("%.2f", $TotExp)
	GUICtrlSetData($rTotalExp, "Tot Exp: " & $TotExp) 
	
	$TotDrw = StringFormat("%.2f", $TotDrw)
	GUICtrlSetData($rTotalDrw, "Tot Draw: " & $TotDrw) 
EndFunc

Func AddNewItem()
	; add new product item
	;Products (ItemCode, Description, Price, Dept, SDisc, SQty, CDisc, CQty, FDisc, FQty, PDisc, PQty)
	Local $dQuery, $dRow, $dDept
	
	$FormAddItm = GUICreate("Add New Item...", 362, 291, 285, 179)
	$Label1 = GUICtrlCreateLabel("Item Code:", 16, 27, 55, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmCode = GUICtrlCreateInput("", 76, 24, 61, 21, $ES_NUMBER)
	$dptLabel = GUICtrlCreateLabel("Dept:", 165, 27, 55, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$Dept = GUICtrlCreateCombo("", 200, 24, 80, 20)
	$Label2 = GUICtrlCreateLabel("Description:", 16, 59, 60, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmDesc = GUICtrlCreateInput("", 76, 56, 271, 21)
	$Label3 = GUICtrlCreateLabel("Item Price:", 20, 91, 54, 17)
	$ItmPrice = GUICtrlCreateInput("", 76, 88, 61, 21, $ES_NUMBER)
	$Group1 = GUICtrlCreateGroup("Discounts", 12, 120, 333, 113)
		$Label4 = GUICtrlCreateLabel("Full-time" & @LF & "Students", 80, 133, 80, 37)
		$Label5 = GUICtrlCreateLabel("Clients", 152, 146, 35, 17)
		$Label6 = GUICtrlCreateLabel("Frequent" & @LF & "Customers", 211, 133, 80, 35)
		$Label7 = GUICtrlCreateLabel("Public", 285, 146, 33, 17)
		$Label8 = GUICtrlCreateLabel("Amount:", 25, 168, 43, 17)
		$Label9 = GUICtrlCreateLabel("Quantity:", 25, 196, 46, 17)
		$SDisc = GUICtrlCreateInput("", 76, 164, 53, 21)
		$SQty = GUICtrlCreateInput("", 76, 192, 53, 21, $ES_NUMBER)
		$updn1 = GUICtrlCreateUpdown($SQty)
		$CDisc = GUICtrlCreateInput("", 142, 164, 53, 21)
		$CQty = GUICtrlCreateInput("", 142, 192, 53, 21, $ES_NUMBER)
		$updn2 = GUICtrlCreateUpdown($CQty)
		$FDisc = GUICtrlCreateInput("", 208, 164, 53, 21)
		$FQty = GUICtrlCreateInput("", 208, 192, 53, 21, $ES_NUMBER)
		$updn3 = GUICtrlCreateUpdown($FQty)
		$PDisc = GUICtrlCreateInput("", 275, 164, 53, 21)
		$PQty = GUICtrlCreateInput("", 275, 192, 53, 21, $ES_NUMBER)
		$updn3 = GUICtrlCreateUpdown($PQty)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ButApply = GUICtrlCreateButton("Ok", 128, 244, 103, 33, $BS_DEFPUSHBUTTON)
	$ButCancel = GUICtrlCreateButton("Cancel", 241, 244, 103, 33, 0)

	; load dept combo
	_SQlite_Query ($DataBase, "SELECT * FROM Dept ORDER BY Dept;", $dQuery)
	While _SQLite_FetchData ($dQuery, $dRow) = $SQLITE_OK  
		$dDept = $dDept & $dRow[0] & "|"
		;ConsoleWrite(StringFormat(" %-30s  %-10s  ", $dRow[0],  $dRow[1]) & @CR)		
	WEnd
	_SQLite_QueryFinalize($dQuery)
	GUICtrlSetData($Dept, $dDept)

	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $ButCancel
				GUIDelete($FormAddItm)
				SetError(1)
				Return			
			Case $ButApply
				If Not GUICtrlRead($ItmCode) Then
					GUICtrlSetBkColor($ItmCode, 0xffcece)
					GUICtrlSetTip ($ItmCode, "Item Code is missing", "Error" , 2, 2 )
					MsgBox(0,"Error","The Item Code is required!")
				ElseIf Not GUICtrlRead($ItmDesc) Then
					If GUICtrlRead($ItmPrice) <> 0 Then
						GUICtrlSetBkColor($ItmDesc, 0xffcece)
						GUICtrlSetTip ($ItmDesc, "Item Description is missing", "Error" , 2, 2 )
						MsgBox(0,"Error","The Item Description is required!")
					EndIf	
				ElseIf Not GUICtrlRead($ItmPrice) Then
					If GUICtrlRead($ItmDesc) <> "" And $ItmCode < 500 Then
						GUICtrlSetBkColor($ItmPrice, 0xffcece)
						GUICtrlSetTip ($ItmDesc, "Item Price is missing", "Error" , 2, 2 )
						MsgBox(0,"Error","The Item Price is required!")
					EndIf	
				Else										
					$Res = _SQLite_Exec(-1 , "INSERT INTO Products (ItemCode, Description, Price, Dept, SDisc, SQty, CDisc, CQty, FDisc, FQty, PDisc, PQty) " _
					& "VALUES ('"&GUICtrlRead($ItmCode)&"', '"&GUICtrlRead($ItmDesc)&"', '"&GUICtrlRead($ItmPrice)&"', '"&GUICtrlRead($Dept)& _
										"', '"&GUICtrlRead($SDisc)&"', '"&GUICtrlRead($SQty)&"', '"&GUICtrlRead($CDisc)&"', '"&GUICtrlRead($CQty)& _
										"', '"&GUICtrlRead($FDisc)&"', '"&GUICtrlRead($FQty)&"', '"&GUICtrlRead($PDisc)&"', '"&GUICtrlRead($PQty)&"' );")
	;~ 					If $Res = $SQLITE_OK Then
	;~ 					Else
	;~ 						MsgBox(16, "SQLite Error: ", _SQLite_ErrMsg ())
	;~ 					EndIf
					GUIDelete($FormAddItm)
					Return
				EndIf
		EndSwitch		
	WEnd
EndFunc

Func EditItem()
	;Products (ItemCode, Description, Price, Dept, SDisc, SQty, CDisc, CQty, FDisc, FQty, PDisc, PQty)
	Local $hQuery_Edit, $aRow_Edit, $dQuery, $dRow, $dDept, $iCode
	
	If Not _GUICtrlListView_GetItemText (GUICtrlGetHandle($ProdList), _GetSelectedItem(GUICtrlGetHandle($ProdList)), 1) Then Return	
	$SelItem = _GUICtrlListView_GetItemText(GUICtrlGetHandle($ProdList), _GetSelectedItem(GUICtrlGetHandle($ProdList)), 0)
	_SQlite_Query ($DataBase, "SELECT * FROM Products WHERE ItemCode = '" & $SelItem & "' ;", $hQuery_Edit) ; the query
	If _SQLite_FetchData ($hQuery_Edit, $aRow_Edit) = $SQLITE_OK Then
		$iCode = $aRow_Edit[0]
	EndIf
	$FormEditItm = GUICreate("Item Details...", 362, 291, 285, 179)
	$Label1 = GUICtrlCreateLabel("Item Code:", 16, 27, 55, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmCode = GUICtrlCreateInput($aRow_Edit[0], 76, 24, 61, 21, $ES_NUMBER)
	$dptLabel = GUICtrlCreateLabel("Dept:", 165, 27, 55, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$Dept = GUICtrlCreateCombo($aRow_Edit[3], 200, 24, 80, 20)
	$Label2 = GUICtrlCreateLabel("Description:", 16, 59, 60, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmDesc = GUICtrlCreateInput($aRow_Edit[1], 76, 56, 271, 21)
	$Label3 = GUICtrlCreateLabel("Item Price:", 20, 91, 54, 17)
	$ItmPrice = GUICtrlCreateInput($aRow_Edit[2], 76, 88, 61, 21, $ES_NUMBER)
	$Group1 = GUICtrlCreateGroup("Discounts", 12, 120, 333, 113)
		$Label4 = GUICtrlCreateLabel("Full-time" & @LF & "Students", 80, 133, 80, 37)
		$Label5 = GUICtrlCreateLabel("Clients", 152, 146, 35, 17)
		$Label6 = GUICtrlCreateLabel("Frequent" & @LF & "Customers", 211, 133, 80, 35)
		$Label7 = GUICtrlCreateLabel("Public", 285, 146, 33, 17)
		$Label8 = GUICtrlCreateLabel("Amount:", 25, 168, 43, 17)
		$Label9 = GUICtrlCreateLabel("Quantity:", 25, 196, 46, 17)
		$SDisc = GUICtrlCreateInput($aRow_Edit[4], 76, 164, 53, 21)
		$SQty = GUICtrlCreateInput($aRow_Edit[5], 76, 192, 53, 21, $ES_NUMBER)
		$updn1 = GUICtrlCreateUpdown($SQty)
		$CDisc = GUICtrlCreateInput($aRow_Edit[6], 142, 164, 53, 21)
		$CQty = GUICtrlCreateInput($aRow_Edit[7], 142, 192, 53, 21, $ES_NUMBER)
		$updn2 = GUICtrlCreateUpdown($CQty)
		$FDisc = GUICtrlCreateInput($aRow_Edit[8], 208, 164, 53, 21)
		$FQty = GUICtrlCreateInput($aRow_Edit[9], 208, 192, 53, 21, $ES_NUMBER)
		$updn3 = GUICtrlCreateUpdown($FQty)
		$PDisc = GUICtrlCreateInput($aRow_Edit[10], 275, 164, 53, 21)
		$PQty = GUICtrlCreateInput($aRow_Edit[11], 275, 192, 53, 21, $ES_NUMBER)
		$updn3 = GUICtrlCreateUpdown($PQty)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$ButApply = GUICtrlCreateButton("Ok", 128, 244, 103, 33, $BS_DEFPUSHBUTTON)
	$ButCancel = GUICtrlCreateButton("Cancel", 241, 244, 103, 33, 0)
	
	; load dept combo
	_SQlite_Query ($DataBase, "SELECT * FROM Dept ORDER BY Dept;", $dQuery)
	While _SQLite_FetchData ($dQuery, $dRow) = $SQLITE_OK  
		$dDept = $dDept & $dRow[0] & "|"
		If $DebugIt Then ConsoleWrite(StringFormat(" %-30s  %-10s  ", $dRow[0],  $dRow[1]) & @CR)		
	WEnd
	_SQLite_QueryFinalize($dQuery)
	GUICtrlSetData($Dept, $dDept)

	GUISetState(@SW_SHOW)	
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $ButCancel
				GUIDelete($FormEditItm)
				SetError(1)
				Return			
			Case $ButApply
				If Not GUICtrlRead($ItmCode) Then
					GUICtrlSetBkColor($ItmCode, 0xffcece)
					GUICtrlSetTip ($ItmCode, "Item Code is missing", "Error" , 2, 2 )
					MsgBox(0,"Error","The Item Code is required!")
				ElseIf Not GUICtrlRead($ItmDesc) Then
					GUICtrlSetBkColor($ItmDesc, 0xffcece)
					GUICtrlSetTip ($ItmDesc, "Item Description is missing", "Error" , 2, 2 )
					MsgBox(0,"Error","The Item Description is required!")
				ElseIf Not GUICtrlRead($ItmPrice) Then
					GUICtrlSetBkColor($ItmPrice, 0xffcece)
					GUICtrlSetTip ($ItmDesc, "Item Price is missing", "Error" , 2, 2 )
					MsgBox(0,"Error","The Item Price is required!")
				Else	
					;Products (ItemCode, Description, Price, Dept, SDisc, SQty, CDisc, CQty, FDisc, FQty, PDisc, PQty)					
					$Res = _SQLite_Exec(-1 , "UPDATE Products SET ItemCode = '" & GUICtrlRead($ItmCode) & "', Description = '" & _
															GUICtrlRead($ItmDesc) & "', Price = '" & GUICtrlRead($ItmPrice) & "', Dept = '" & GUICtrlRead($Dept) & _
															"', SDisc = '" & GUICtrlRead($SDisc) & "', SQty = '" & GUICtrlRead($SQty) & "', CDisc = '" &  _
															GUICtrlRead($CDisc) & "', CQty = '" &GUICtrlRead($CQty) & "', FDisc = '" & GUICtrlRead($FDisc) & _
															"', FQty = '" & GUICtrlRead($FQty) & "', PDisc = '" & GUICtrlRead($PDisc) & "', PQty = '" & _
															GUICtrlRead($PQty) & "' WHERE ItemCode = '" & _GUICtrlListView_GetItemText ($ProdList, _GetSelectedItem($ProdList), 0) & "';") ; the query
					If $Res <> $SQLITE_OK Then MsgBox(0, "Error", "Could not save Item.")
					_SQLite_QueryFinalize($hQuery_Edit)
					GUIDelete($FormEditItm)
					Return
				EndIf
		EndSwitch
	WEnd
EndFunc

Func AddMan()
	; add manual till item or expense or discount
	Local $ItemLst, $Code, $Qty, $price, $dPrice, $dItem, $dQty, $disc
	#Region GUI
	$FormAddMan = GUICreate("Capture Manual Item...", 332, 220, 210, 179)	
	$TypeGroup = GUICtrlCreateGroup("Input Type", 16, 15, 300, 50)
		$TypeIn = GUICtrlCreateRadio("Income", 28, 35, 60, 20)
		GUICtrlSetState(-1, $GUI_CHECKED)
		$TypeEx = GUICtrlCreateRadio("Expense", 100, 35, 60, 20)
		$TypeDis = GUICtrlCreateRadio("Discount", 180, 35, 60, 20)
		$TypeDrw = GUICtrlCreateRadio("Draw", 262, 35, 50, 20)
	$Label2 = GUICtrlCreateLabel("Description:", 16, 80, 60, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmMan = GUICtrlCreateCombo("", 76, 78, 220, 20)	
		$ItemLst = FillCombo(2, 1) 																						; load non-till items in drop list
		GUICtrlSetData($ItmMan, $ItemLst)		
	$PriceTxt = GUICtrlCreateLabel("Item Price:", 16, 108, 54, 17)
	$ItmPrice = GUICtrlCreateInput("", 76, 106, 61, 20, $ES_NUMBER)
	$QtyTxt = GUICtrlCreateLabel("Quantity:", 16, 134, 55, 17)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	$ItmQty = GUICtrlCreateInput("1", 76, 132, 61, 20, $ES_NUMBER)
	$updown = GUICtrlCreateUpdown($ItmQty)
	GUICtrlCreateGroup("", -99, -99, 1, 1)	
	$ButApply = GUICtrlCreateButton("Ok", 85, 170, 103, 33, $BS_DEFPUSHBUTTON)
	$ButCancel = GUICtrlCreateButton("Cancel", 193, 170, 103, 33, 0)
	#EndRegion
	
	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE, $ButCancel
				GUIDelete($FormAddMan)
				SetError(1)
				Return						
			Case $TypeIn
				If BitAND(GUICtrlRead($TypeIn), $GUI_CHECKED) = $GUI_CHECKED Then	
					GUICtrlSetState($ItmPrice, $GUI_ENABLE)
					GUICtrlSetState($ItmQty, $GUI_ENABLE)
					GUICtrlSetData($QtyTxt, "Quantity:")
					GUICtrlSetData($PriceTxt, "Item Price:")
					$ItemLst = FillCombo(2, 1) 
					GUICtrlSetData($ItmMan, "|" & $ItemLst)
				EndIf		
			Case $TypeEx
				If BitAND(GUICtrlRead($TypeEx), $GUI_CHECKED) = $GUI_CHECKED Then 	
					GUICtrlSetState($ItmPrice, $GUI_ENABLE)
					GUICtrlSetState($ItmQty, $GUI_ENABLE)
					GUICtrlSetData($PriceTxt, "Amount:")
					$ItemLst = FillCombo(3, 1) 
					GUICtrlSetData($ItmMan, "|" & $ItemLst)
				EndIf					
			Case $TypeDis
				If BitAND(GUICtrlRead($TypeDis), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($ItmPrice, $GUI_DISABLE)
					GUICtrlSetState($ItmQty, $GUI_DISABLE)
					GUICtrlSetData($QtyTxt, "Min Qty:")
					GUICtrlSetData($PriceTxt, "Amount:")
					$ItemLst = FillCombo(5, 1) 
					GUICtrlSetData($ItmMan, "|" & $ItemLst)
				EndIf							
			Case $TypeDrw
				If BitAND(GUICtrlRead($TypeDrw), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetState($ItmPrice, $GUI_ENABLE)
					GUICtrlSetState($ItmQty, $GUI_DISABLE)
					GUICtrlSetData($QtyTxt, "Quantity:")
					GUICtrlSetData($PriceTxt, "Amount:")
					$ItemLst = FillCombo(4, 1) 
					GUICtrlSetData($ItmMan, "|" & $ItemLst)
				EndIf							
			Case $ItmMan	
				$idx = _ArraySearch($ProdArr, GUICtrlRead($ItmMan), 0, 0, 0, 1)			; find description index in product array
				$ItmBits = StringSplit($ProdArr[$idx], "|")													; split item to elements	
				If BitAND(GUICtrlRead($TypeDis), $GUI_CHECKED) = $GUI_CHECKED	Then	; discount
					$dItem = GetDiscount($ItmBits[1])																	; check disc by code for selected item 
					If Not @error Then
						$dItem2 = StringSplit($dItem, "|")
						$dQty = $ditem2[1]
						$dPrice = StringFormat("%.2f", $ditem2[2])
						GUICtrlSetData($ItmQty, $dQty)
						GUICtrlSetData($ItmPrice, $dPrice)
					EndIf
				Else						
					$Price = StringFormat("%.2f", $ItmBits[3])
					GUICtrlSetData($ItmPrice, $Price)
				EndIf	
			Case $ItmQty				
				If GUICtrlRead($ItmQty) < 1 Then GUICtrlSetData($ItmQty, "1")
				;GUICtrlSetData($ItmPrice, GUICtrlRead($ItmQty) * StringFormat("%.2f", $ItmBits[3]))
			Case $ButApply
				If Not GUICtrlRead($ItmMan) Then
					GUICtrlSetBkColor($ItmMan, 0xffcece)
					GUICtrlSetTip ($ItmMan, "Item Description is missing", "Error" , 2, 2 )
					MsgBox(0,"Error","The Item Description is required!")
				ElseIf Not GUICtrlRead($ItmPrice) Then
					If GUICtrlRead($ItmMan) <> "" Then
						GUICtrlSetBkColor($ItmPrice, 0xffcece)
						GUICtrlSetTip ($ItmPrice, "Item Price is missing", "Error" , 2, 2 )
						MsgBox(0,"Error","The Item Price is required!")
					EndIf	
				Else			
 					If BitAND(GUICtrlRead($TypeDis), $GUI_CHECKED) = $GUI_CHECKED	Then			; discount
						$ItmTxt = $ItmBits[1] & "|-" & GUICtrlRead($ItmMan) & " @" & $ditem2[2] &  "|" & GUICtrlRead($ItmQty) & _
											"|" & $ditem2[3] & "|Discount"
						;_GUICtrlListView_InsertItem($ListView, "Discount", $sel+1)
						GUICtrlCreateListViewItem($ItmTxt, $ListView)							
					Else
						$Price = StringFormat("%.2f", GUICtrlRead($ItmPrice) * GUICtrlRead($ItmQty))
						; does 'If a = 1 Or b = 1 Or c = 1 Then...' not work in AutoIt?
						If BitAND(GUICtrlRead($TypeEx), $GUI_CHECKED) = $GUI_CHECKED Then
							$Price *= -1
						ElseIf BitAND(GUICtrlRead($TypeDrw), $GUI_CHECKED) = $GUI_CHECKED Then
							$Price *= -1
						EndIf
						GUICtrlCreateListViewItem($ItmBits[1] & "|" & GUICtrlRead($ItmMan) & "|" & GUICtrlRead($ItmQty)  & "|" &$Price & "|" & $ItmBits[4], $ListView)	
						GUICtrlSetData($Display, GUICtrlRead($ItmMan))			
					EndIf
					GUIDelete($FormAddMan)
					Return
				EndIf
		EndSwitch		
	WEnd
EndFunc

Func GetDiscount($iDsc)
	; checks discount qty and amount for passed item description
	
	Local $iNdx, $str, $strb, $iqty, $itm, $disc, $dqty, $damt, $ret
	
	$ItemTot = _GUICtrlListView_GetItemCount($ListView)										; how many items in list	
	If Not $ItemTot Then
		SetError(1)
		Return
	EndIf
	
	; get selected item in list
	$sel = _GetSelectedItem(GUICtrlGetHandle($ListView))							; which item selected
	$itm = _GUICtrlListView_GetItemText($ListView, $sel, 1)						; read item desc	
	$iqty = _GUICtrlListView_GetItemText($ListView, $sel, 2)					; read item qty	
	$indx = _ArraySearch($ProdArr, $itm, 0, 0, 0, 1)									; find prod item in array
	$str = $ProdArr[$indx]																						; read product info
	;------------------------------------------------------------------------------
	If $DebugIt Then 
		ConsoleWrite("Item Detail: " & $itm & " - " & $str & @LF) 
		ConsoleWrite("Item Qty: " & $iqty & @LF) 
	EndIf
	;------------------------------------------------------------------------------
	$strb = StringSplit($str, "|")																		; split prod info to array								
	Switch $iDsc 																											; disc code passed
		Case 901																												; student 
			$disc = $strb[5]
			$dqty = $strb[6]
		Case 902																												; client 
			$disc = $strb[7]
			$dqty = $strb[8]
		Case 903																												; freq. cust 
			$disc = $strb[9]
			$dqty = $strb[10]
		Case 904																												; public 
			$disc = $strb[11]
			$dqty = $strb[12]
	EndSwitch	
	;---------------------------------------------------------------------------------------------------
	If $DebugIt Then ConsoleWrite("Item: " & $iDsc & " - $dqty: " & $dqty &  " - $disc: " & $disc & @LF) 
	;---------------------------------------------------------------------------------------------------
	
	If $disc = 0 Then
		MsgBox(0, "No discount...", "No Discount available for " & $strb[2] & "!")
		SetError(2)
		Return
	EndIf
	If Number($iqty) < Number($dqty) Then
		MsgBox(0, "No discount...", "Quantity (" & $iqty & ") does not qualify for Discount!" & @LF & @LF & "Minimum quantity required to qualify is " & $dqty)
		SetError(3)
		Return
	EndIf
	$ret = $dqty & "|" & StringFormat("%.2f", $disc) & "|" & StringFormat("%.2f", $iqty * $disc * -1)
	Return $ret
	
EndFunc

Func FillCombo($cType, $sort=0) 	
	#cs	returns a sorted, '|' delimited string of items from 	
		Products table to load into Combo box
		if $cStart = 1, returns items 1 to 35 (till buttons)
		if $cStart = 2, returns from Item 36 to 299 - additional income items
		if $cStart = 3, returns from Item 300 to 900 - expenditure items
		if $cStart = 4, returns Items 900 in Products table
		if $cStart = 5, returns all items in Products table
	#ce
	Local $Item, $Itm, $sortArr
	
	For $ItmNo = 1 To UBound($ProdArr) - 1												; loop thru each item string in prod. array
		$Item = _StringSplit($ProdArr[$ItmNo], "|")									; read string to array
		If $Item[1] = " " Then ContinueLoop													; skip empty items
		Switch $cType
			Case 1
				If $Item[0] <= 35 Then $Itm = $Itm	&	$Item[1] & "|"		; till product buttons	
			Case 2 	
				If $Item[0] > 35 And $Item[0] < 300 Then 								; add. income products
					$Itm = $Itm	&	$Item[1] & "|"
				EndIf
			Case 3 	
				If $Item[0] >= 300 And $Item[0] < 800 Then 							; expense items
					$Itm = $Itm	&	$Item[1] & "|"	
				EndIf		
			Case 4 	
				If $Item[0] >= 800 And $Item[0] < 900 Then 							; drawing
					$Itm = $Itm	&	$Item[1] & "|"	
				EndIf		
			Case 5
				If $Item[0] >= 900 Then $Itm = $Itm	&	$Item[1] & "|"		; discount items 		
			Case 6
				If $sort Then
					If $Item[1] Then $Itm = $Itm	&	$Item[1] & "|"				; all items
				Else																										; unsorted list required
					If $Item[1] Then 
						$clen = StringLen($Item[0])	
						$cd = _StringRepeat(" ", 3-$clen) & $Item[0] & "  " ; pad item code with spaces
						$Itm = $Itm	&	$cd & $Item[1] & "|"									; all items
					EndIf
				EndIf
			Case 7																										; dept list
				
		EndSwitch				
	Next
	If $sort Then																									; sort return string
		$sortArr = _StringSplit($Itm, "|")													; split string to array
		_ArraySort($sortArr, 0, 0, 0, 0)														; sort array
		$Itm = _ArrayToString($sortArr, "|")												; reconstr string from array
	EndIf	
	Return $Itm
EndFunc

Func PrintSlip($pTxNo)	
	; DAILY (No, Date, Time, ItemCode, Description, Qty, Price, Disc, DiscQty, DiscRef)
	Dim $Query, $TxItem, $Item, $iDesc, $iQty, $iPrice=0, $iDisc, $iDiscRef, $SubTot, $Header, $pPos = 700 
	_SQlite_Query ($DataBase, "SELECT * FROM Daily WHERE TxNo = '" & $pTxNo & "' ORDER BY TxNo ;", $Query)
	While _SQLite_FetchData ($Query, $TxItem) = $SQLITE_OK
		If Not $Header Then
			$tDate = $TxItem[1]
			$tTime = $TxItem[2]
			SlipHead($pTxNo, $tDate, $tTime)
			If $DebugIt Then SlipHead2($pTxNo, $tDate, $tTime)											
			$Header = 1
		EndIf
		$iDesc = $TxItem[4]	
		$dlen = StringLen($iDesc)	
		$dstr = StringLeft($iDesc & _StringRepeat(" ", 26-$dlen), 26)	
		$iQty = $TxItem[5]
		$qlen = StringLen($iQty)	
		$qstr = _StringRepeat(" ", 3-$qlen+1) & $iQty
		$iPrice = StringFormat("%.2f", $TxItem[6])
		$plen = StringLen($iPrice)		
		$pstr = _StringRepeat(" ", 6-$plen+1) & $iPrice
		$SubTot += $iPrice
		$Item = $dstr & " " & $qstr & " " & $pstr
		_PrintText($Prn, $Item, 20, $pPos)
		If $DebugIt Then ConsoleWrite($Item & " " & @LF)
		$pPos += 40
	WEnd		
	_SQLite_QueryFinalize($Query)		
	$SubTot = "R " & StringFormat("%.2f", $SubTot)
	$slen = StringLen($SubTot)		
	$sstr = _StringRepeat(" ", 8-$slen+1) & $SubTot	
	If $DebugIt Then 
		ConsoleWrite(_StringRepeat(" ",32) & "-------" & @LF)
		ConsoleWrite("                     TOTAL    " & @LF)
		ConsoleWrite(_StringRepeat(" ",32) & "-------" & @LF)
		ConsoleWrite("              ***********              " & @LF)		
		ConsoleWrite(" *** Thank you for your patronage ***  " & @LF)
		For $i = 1 To 5		
			ConsoleWrite(@LF)
		Next	
	EndIf
	_PrintText($Prn, _StringRepeat(" ",32) & "-------", 20, $pPos)
	_PrintText($Prn, "                     TOTAL    " & $sstr, 20, $pPos+40)	
	_PrintText($Prn, _StringRepeat(" ",32) & "-------", 20, $pPos+80)
	_PrintText($Prn, "              ***********      ", 20, $pPos+120)		
	_PrintEndPrint($Prn)	
EndFunc

Func SlipHead($pTxNo, $tDate, $tTime)
	If Not $Prn Then
		$Prn = _PrintDllStart($pErr)
		If $pErr Then
			
		EndIf
		_PrintSelectPrinter($Prn,"Generic / Text Only")
	EndIf
	_PrintStartPrint($Prn)
	If @error	Then MsgBox(0, "_PrintStartPrint Result", "_PrintStartPrint failed!") 
	;_PrintSetFont($Prn,$FontName,$FontSize,$FontCol=0,$Fontstyle = '')
	;To check that the text will fit a space use _PrintGEtTextHeight and _PrintGetTextWidth
	;_PrintText($hDll,$sText,$ix=-1,$iy=-1,$iAngle=0)
	
	_PrintText($Prn, " "                                      , 20, 80)
	_PrintText($Prn, "***************************************", 20, 100)
	_PrintText($Prn, "*                                     *", 20, 140)
	_PrintText($Prn, "*          DALISU iT Centre           *", 20, 180)
	_PrintText($Prn, "*         Shop 36, 1st Floor          *", 20, 220)
	_PrintText($Prn, "*       Umlazi Industrial Park        *", 20, 260)
	_PrintText($Prn, "*      V1332 Umlazi next to KFC       *", 20, 300)
	_PrintText($Prn, "*         Tel: 031 907 0944           *", 20, 340)
	_PrintText($Prn, "*     email: dalisuit@gmail.com       *", 20, 380)
	_PrintText($Prn, "*                                     *", 20, 420)
	_PrintText($Prn, "***************************************", 20, 460)
	_PrintText($Prn, "                                       ", 20, 500)
	_PrintText($Prn, "Tx No: " & $pTxNo & "  " &$tDate & "  " & $tTime , 20, 540)
	_PrintText($Prn, "---------------------------------------", 20, 580)
	_PrintText($Prn, " Item                       Qty   Price", 20, 620)
	_PrintText($Prn, "---------------------------------------", 20, 660)
EndFunc

Func SlipHead2($pTxNo, $tDate, $tTime)	
	$Bits = StringSplit($tDate, "/")
	$tDate = $Bits[3] & "/" & $Bits[2] & "/" & $Bits[1]						; swop date to dd/mm/yyy
	ConsoleWrite("***************************************" & @LF)
	ConsoleWrite("*                                     *" & @LF)
	ConsoleWrite("*          DALISU iT Centre           *" & @LF)
	ConsoleWrite("*         Shop 36, 1st Floor          *" & @LF)
	ConsoleWrite("*       Umlazi Industrial Park        *" & @LF)
	ConsoleWrite("*      V1332 Umlazi next to KFC       *" & @LF)
	ConsoleWrite("*         Tel: 031 907 0944           *" & @LF)
	ConsoleWrite("*     email: dalisuit@gmail.com       *" & @LF)
	ConsoleWrite("*                                     *" & @LF)
	ConsoleWrite("***************************************" & @LF)
	ConsoleWrite("                                       " & @LF)
	ConsoleWrite("Tx No: " & $pTxNo & "  " &$tDate & "  " & $tTime & @LF)
	ConsoleWrite("---------------------------------------" & @LF)
	ConsoleWrite(" Item                       Qty   Price" & @LF)
	ConsoleWrite("---------------------------------------" & @LF)
EndFunc

Func OnExit()			; unused for now
	_PrintEndPrint($Prn)
	_PrintDllClose($Prn)	
	_SQLite_Close()					
	_SQLite_Shutdown()
	Exit		
EndFunc
	