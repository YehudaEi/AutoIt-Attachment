#include <GuiConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <file.au3>

Opt("TrayIconHide", 1)

Dim $Shop, $ShopList, $Big

;use even larger datafiles
$Big = 0

GUICreate("matchmaker, alfa", 925, 600, -1, -1);, $WS_SIZEBOX + $WS_MINIMIZEBOX + $WS_CAPTION + $WS_POPUP + $WS_SYSMENU)
;GuiSetIcon("autoit\market.ico", 0)

;ViewLists
$TowaryShop1Lista=GUICtrlCreateListView ("Towary|Indeks|PLU", 10,10,430,450, $LVS_LIST + $WS_BORDER + $WS_VSCROLL + $LBS_NOTIFY, $LVS_EX_FULLROWSELECT + $LVS_EX_HEADERDRAGDROP + $LVS_EX_GRIDLINES) ;+ $LVS_EX_CHECKBOXES)
$TowaryShop2Lista=GUICtrlCreateListView ("Towary|Indeks|PLU", 525,10,430,450, $LVS_LIST + $WS_BORDER + $WS_VSCROLL + $LBS_NOTIFY, $LVS_EX_FULLROWSELECT + $LVS_EX_HEADERDRAGDROP + $LVS_EX_GRIDLINES) ;+ $LVS_EX_CHECKBOXES) ; + $LBS_DISABLENOSCROLL

_GUICtrlListViewSetColumnWidth ($TowaryShop1Lista, 0, 225)                 ;Set Column with

;Buttons
$add=GUICtrlCreateButton ("Dodaj", 445,30,75,25)
$clear=GUICtrlCreateButton ("Wyczyœæ", 445,70,75,25)
$export=GUICtrlCreateButton ("Eksport", 445,110,75,25)
$close=GUICtrlCreateButton ("Wyjœcie", 445,172,75,25)
GUICtrlSetLimit(-1,200) ; to limit horizontal scrolling

Func _GetSklepy($Shop)

	If $Shop = "Shop1" Then
		$ShopList = $TowaryShop1Lista
	Else
		$ShopList = $TowaryShop2Lista
	EndIf

	if $Big = 1 then
		$file = FileOpen($Shop & "_big.txt", 0)
	else 
 		$file = FileOpen($Shop & ".txt", 0)
 	endif
  ;see if the datafile was there...
  If $file = -1 Then
      MsgBox(0, "Error", "Unable to open file")
      Exit                                        
  EndIf                                           

  $i = 0
	$txt = FileRead($file)
	$txt = StringSplit($txt, @CRLF, 1)
	$i = $txt[0]
	
  FileClose($file)
  ;debug numer of lines in the file
  ;msgbox(0, "Number of lines:", $i)
  $j = Floor($i/100)
  ;debug how many line is 1%
  ;msgbox(0, "1% is ", $i & " lines")
  
  ProgressOn("Creating itemlist for " & $Shop & "...", "Total " & $i & " items" , "0 percent")
  $procent = 1
  ;reading file untill EOF
  For $k = 1 To $txt[0]
      $line = $txt[$k]
      ; removing d  o  u  b  l  e  s  p  a  c  e  s
      $line = StringStripWS ( $line, 4 )

      if Mod($k, $j) = 0 then     	
      	ProgressSet($procent, $procent & " percent", "Total " & $i & " items")
      	$procent = $procent + 1
      endif
      ;adding items to ListView (SLOW)
      ;_GUICtrlListViewInsertItem($ShopList, -1, $line)  	  
      ;adding items to ListView
;~   	  GUICtrlCreateListViewItem($procent & "% "&  $line, $ShopList)
  	  _GUICtrlListViewInsertItem($ShopList, -1, $procent & "% "&  $line)
  Next
  ProgressSet(100 , "Itemlist created successfully", "Done...")

  ProgressOff()
EndFunc

_GetSklepy("Shop1")
;_GetSklepy("Shop2")

GUISetState ()

$msg = 0
While $msg <> $GUI_EVENT_CLOSE
    $msg = GUIGetMsg()
    
    Select
    	Case $msg = $add
    	msgbox(0,"","bah")
        
        Case $msg = $clear
        _GetSklepy("Shop1")
		_GetSklepy("Shop2")       

        Case $msg = $export
        msgbox(0,"","bah")
		
		Case $msg = $close
            Exit
     EndSelect 
Wend
