#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <ListviewConstants.au3>
#Include <GuiStatusBar.au3>
#include <StaticConstants.au3>
#include <GUICtrlHyperLink.au3>

Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1+2)
TrayCreateItem("About")
TrayItemSetOnEvent(-1,"AboutFunction") ;function name
TrayCreateItem('')
TrayCreateItem('Exit')
TrayItemSetOnEvent(-1,"ExitFunction") ;function name
TraySetState()
DirCreate ("Bibles")
#region ;Create
$MainGUI = GUICreate("Bible Search", 700, 455,-1,-1,$WS_MAXIMIZEBOX+$WS_SIZEBOX)
$StatusBar = _GUICtrlStatusBar_Create ($MainGUI,'','',$SBARS_SIZEGRIP)
GUIRegisterMsg($WM_SIZE, "MY_WM_SIZE")

GUICtrlCreateGroup("Search ?", 5, 5, 590, 45)
GUICtrlSetResizing (-1,1)
$Input = GUICtrlCreateInput("", 10, 20, 200, 20)
GUICtrlSetResizing (-1,1)
$Bible = GUICtrlCreateCombo ("",210,20,100)
GUICtrlSetResizing (-1,1)
If FileExists ("Bibles\English.txt") = 1 And FileExists ("Bibles\Russian.txt") = 1 Then
	GUICtrlSetData (-1,"English|Russian|","Russian")
ElseIf FileExists ("Bibles\English.txt") = 1 And FileExists ("Bibles\Russian.txt") = 0 Then
	GUICtrlSetData (-1,"English|","English")
ElseIf FileExists ("Bibles\English.txt") = 0 And FileExists ("Bibles\Russian.txt") = 1 Then
	GUICtrlSetData (-1,"Russian|","Russian")
ElseIf FileExists ("Bibles\English.txt") = 0 And FileExists ("Bibles\Russian.txt") = 0 Then
	GUICtrlSetData (-1,"No Bibles Found","No Bibles Found")
EndIf
GUICtrlCreateGroup("Results.", 5, 50, 390, 325)
$ListView = GUICtrlCreateListView("Versus|Chapter|Book|Testament|", 10, 65, 380, 300,'',$LVS_EX_GRIDLINES)
$SearchButton = GUICtrlCreateButton("Go !", 520, 15, 70, 30)
GUICtrlCreateGroup ("Preview",400,50,295,360)
$Preview = GUICtrlCreateLabel ("",405,65,280,340)
ResizeCollumns()
GUICtrlSetResizing (-1,1)

$CopyContext = GUICtrlCreateContextMenu($ListView)
$Copy = GUICtrlCreateMenuItem("Copy This Text", $CopyContext)
$ShowButton = GUICtrlCreateButton("Show Selected.", 5, 380, 390, 30)
GUICtrlSetResizing (-1,1)
#endregion
;$source = FileRead(GUICtrlRead ($Bible) & ".txt")  ; read the whole text at once
GUISetState(@SW_SHOW, $MainGUI)
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
	If $msg = $SearchButton Then
		$source = FileRead(GUICtrlRead ($Bible) & ".txt")  ; read the whole text at once
		If GUICtrlRead ($Bible) = "No Bibles Found" Then
			$AskToGoToDownloadPage = MsgBox(32,"Bible Error","No bibles found. Would you like to download one right now ?",'',$MainGUI)
			If $AskToGoToDownloadPage = 1 Then
				MsgBox (48,"Information","Downloaded file will come in ZIP format." & @CRLF & "Extract its content into Bibles folder and restart this application." & @CRLF & "Press OK when ready to go to download Page.",'',$MainGUI)
				ShellExecute ("http://www.mediafire.com/?ehv2lrbe896l4wj")
			EndIf
		EndIf
		$Found = 0
		GUICtrlSetData ($SearchButton,"Stop !")
		$SearchInput = GUICtrlRead($Input)
		_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($ListView))
		_GUICtrlStatusBar_SetText ($StatusBar,"Searching")
		$SearchFor = StringRegExpReplace($SearchInput, "([\\\.\*\+\(\)\?\^\$\|\{\}\[\]])", "\\$1")
		$res = StringRegExp($source, "(?im)^.*" & $SearchFor & ".*$", 3)
		If Not @error Then
			For $line In $res
				$Loopmsg = GUIGetMsg()
				If $Loopmsg = $SearchButton Then
					GUICtrlSetData ($SearchButton,"Go !")
					ExitLoop
				EndIf
				$NewLine = StringTrimLeft ($line,StringInStr($line,"*"))

				$Chapter = StringLeft ($line,StringInStr($line,",","",3))
				$TrimmedChapter = StringTrimLeft ($Chapter,StringInStr ($Chapter,"=",'',3))
				$FixedChapter = StringTrimRight ($TrimmedChapter,1)

				$Book = StringLeft ($line,StringInStr($line,",","",2))
				$TrimmedBook = StringTrimLeft ($Book,StringInStr ($Book,"=",'',2))
				$FixedBook = StringTrimRight ($TrimmedBook,1)

				$Testament = StringLeft ($line,StringInStr($line,",","",1))
				$TrimmedTestament = StringTrimLeft ($Testament,StringInStr ($Testament,"="))
				$FixedTestament = StringTrimRight ($TrimmedTestament,1)
				GUICtrlCreateListViewItem($NewLine & "|" & $FixedChapter & "|" & $FixedBook & "|" & $FixedTestament & "|", $ListView)
				Assign ("Found",$Found+1)
			Next
			ResizeCollumns()
		EndIf
		GUICtrlSetData ($SearchButton,"Go !")
		_GUICtrlStatusBar_SetText ($StatusBar,"Found " & $Found & " instances")

	EndIf
	If $msg = $ShowButton Then
		Local $TextData,$Text,$TBC,$T,$TCorrected,$B,$BTrimmed,$BCorrected,$C,$CCorrected
		$TextData = GUICtrlRead(GUICtrlRead($listview))
		$Text = StringLeft ($TextData,StringInStr($TextData,"|","",1)-1)
		$TBC = StringTrimLeft ($TextData,StringInStr($TextData,"|","",1))
		$T = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,2))
		$TCorrected = StringTrimRight ($T,1)
		$B = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,1))
		$BTrimmed = StringTrimLeft ($B,StringInStr ($B,"|",-1,1,-1))
		$BCorrected = StringLeft ($BTrimmed,StringInStr ($B,"|")-1)
		$C = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,4))
		$CCorrected = StringLeft ($C,StringInStr ($C,"|")-1)
		MsgBox(64, '', "Testament=" & $TCorrected & @CRLF & "Book=" & $BCorrected & @CRLF & "Chapter=" & $CCorrected & @CRLF & $Text ,'',$MainGUI)
	EndIf
	$GetClickedItem = GUICtrlRead($listview)
	If $msg = $GetClickedItem Then
		If $GetClickedItem = 0 Then
		ElseIf $GetClickedItem = "" Then
		ElseIf $GetClickedItem > "" Then
			Local $TextData,$Text,$TBC,$T,$TCorrected,$B,$BTrimmed,$BCorrected,$C,$CCorrected
			$TextData = GUICtrlRead(GUICtrlRead($listview))
			$Text = StringLeft ($TextData,StringInStr($TextData,"|","",1)-1)
			$TBC = StringTrimLeft ($TextData,StringInStr($TextData,"|","",1))
			$T = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,2))
			$TCorrected = StringTrimRight ($T,1)
			$B = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,1))
			$BTrimmed = StringTrimLeft ($B,StringInStr ($B,"|",-1,1,-1))
			$BCorrected = StringLeft ($BTrimmed,StringInStr ($B,"|")-1)
			$C = StringTrimLeft ($TBC,StringInStr($TBC,"|",-1,4))
			$CCorrected = StringLeft ($C,StringInStr ($C,"|")-1)
			GUICtrlSetData ($Preview,"Testament=" & $TCorrected & @CRLF & "Book=" & $BCorrected & @CRLF & "Chapter=" & $CCorrected & @CRLF & $Text)
		EndIf
	EndIf
	If $msg = $Copy Then ClipPut (StringTrimRight(GUICtrlRead(GUICtrlRead($listview)),1))
WEnd
Func MY_WM_SIZE($hWnd, $iMsg, $iwParam, $ilParam) ;this function is for resizing status bar with the window
    _GUICtrlStatusBar_Resize($StatusBar)
    Return $GUI_RUNDEFMSG
EndFunc   ;==>MY_WM_SIZE
Func AboutFunction()
	GUISetState (@SW_DISABLE,$MainGUI)
	$AboutGUI = GUICreate ("Information",400,200,-1,-1,-1,-1,$MainGUI)
	GUICtrlCreateLabel ("Bible Search" & @CRLF & "Coded using AUTOIT V3",10,10,380,30,$SS_CENTER)
	GUICtrlCreateLabel ("Bible Search is a free application comes at no charge for anyone to use and improve their knowledge of the God's Word.",10,50,380,30,$SS_CENTER)
	GUICtrlCreateLabel ("Special thanks to: jchd from AUTOIT FORUM for faster search function." & @CRLF & 'Coded by Anatoliy Filippov' ,10,80,380,200,$SS_CENTER)
	GUICtrlCreateGroup ("Download Bible file",5,110,390,45)
	_GUICtrlHyperLink_Create("English Bible", 10, 130, -1, -1, 0x0000FF, 0x551A8B, -1, "http://www.mediafire.com/?ehv2lrbe896l4wj", 'Download English bible file.', $AboutGUI)
	_GUICtrlHyperLink_Create("Russian Bible", 170, 130, -1, -1, 0x0000FF, 0x551A8B, -1, "http://www.mediafire.com/?ehv2lrbe896l4wj", 'Download Russian bible file.', $AboutGUI)
	_GUICtrlHyperLink_Create("Ukranian Bible", 320, 130, 70, -1, 0x0000FF, 0x551A8B, -1, "http://www.mediafire.com/?ehv2lrbe896l4wj", 'Download Ukranian bible file.', $AboutGUI)

	GUISetState (@SW_SHOW,$AboutGUI)
	;MsgBox(32,"Information",'Special thanks to: jchd from AUTOIT FORUM for faster search function.' & @CRLF & 'Coded by Anatoliy Filippov' & @CRLF & 'If you have any questions, email me at tonycst@hotmail.com','',$MainGUI)
	While 1
		$msg1 = GUIGetMsg()
		If $msg1 = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
	GUIDelete ($AboutGUI)
	GUISetState (@SW_ENABLE,$MainGUI)
EndFunc
Func ResizeCollumns()
	_GUICtrlListView_SetColumnWidth($ListView, 0, 380)
	_GUICtrlListView_SetColumnWidth($ListView, 1, 55)
	_GUICtrlListView_SetColumnWidth($ListView, 2, 40)
	_GUICtrlListView_SetColumnWidth($ListView, 3, 70)
Endfunc
Func ExitFunction()
	Exit
EndFunc
