#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=myspace.ico
#AutoIt3Wrapper_outfile=MyspaceProfileEditor.exe
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIConstants.au3>

#Include <Misc.au3>

Opt("TrayIconHide", 1)

dim $bT_BG
dim $bT_T1
dim $bT_T2
dim $text_color1
dim $text_color2
dim $background_color
dim $Gt_Bg_Color
dim $gt_T1_Color
dim $gt_T2_Color
dim $sample_bg
Dim $sample_T1
Dim $sample_T2

GUICreate("MySpace Layout Editor", 480, 640, 50, 50)
$background_setup_url = GUICtrlCreateInput("Background image URL", 10, 10, 455, 20)
$contact_box_url = GUICtrlCreateInput("Contact Box image URL", 10, 40, 455, 20)
$extended_url = GUICtrlCreateInput("Extended Network image URL", 10, 70, 455, 20)

$bT_T1 = GUICtrlCreateButton("Select Text 1 color", 10, 130, 455, 20)
$bT_T2 = GUICtrlCreateButton("Select Text 2 color", 10, 160, 455, 20)
$bT_BG = GUICtrlCreateButton("Select Background color", 10, 190, 455, 20)

$Colors = GUICtrlCreateLabel("Colors Preview", 10, 220, 455, 20)
$scrollbars = GUICtrlCreateCheckbox("Use defined colors for scrollbars", 10, 310)
$hidefriends = GUICtrlCreateCheckbox("Hide friends", 10, 340)
$hidecomments = GUICtrlCreateCheckbox("Hide comments", 10, 370)
$centerprofile = GUICtrlCreateCheckbox("Center Profile", 10, 400)
$addinstructions = GUICtrlCreateCheckbox("Add instructions to the final layout textfile", 10, 430)

$bT_Output = GUICtrlCreateButton("Output Profile Code as textfile", 10, 460, 455, 20)

GUISetState()

Func Color_T1()
		$gt_T1_Color = _ChooseColor (2,0,2)
		$sample_T1=0
EndFunc
Func Color_T2()
		$gt_T2_Color = _ChooseColor (2,0,2)
		$sample_T2=0
EndFunc
Func Color_BG()
		$Gt_Bg_Color = _ChooseColor (2,0,2)
		$sample_bg=0
EndFunc

Func SaveLayout()
	$filename = FileSaveDialog("Choose a name for your layout:", @WorkingDir, "Textfile layout code (*.txt)", 2)
	If @error Then
		MsgBox(0, "", "Save cancelled. Please set your selections again.")
	Else
		If StringRight ($filename, 4) <> ".txt" Then
            $filename &= ".txt"
        EndIf
		$file = FileOpen($filename, 1)
		
		;Set Colors for html use, trims out 0x
		$Gt_Bg_Color = StringRight($Gt_Bg_Color,6)
		$gt_T1_Color = StringRight($gt_T1_Color,6)
		$gt_T2_Color = StringRight($gt_T2_Color,6)
		
		;Get Images URLs
		$gt_bg_url = GUICtrlRead($background_setup_url)
		$gt_cb_url = GUICtrlRead($contact_box_url)
		$gt_extended = GUICtrlRead($extended_url)
		
		;Get other options
		$gt_scrollbars = GUICtrlRead($scrollbars)
		$gt_hidefriends = GUICtrlRead($hidefriends)
		$gt_hidecomments = GUICtrlRead($hidecomments)
		$gt_centerprofile = GUICtrlRead($centerprofile)
		$gt_addinstructions = GUICtrlRead($addinstructions)
		
		$addinstructions_setup = "<!-- Please follow the instructions for your profile layout installation. 1. Delete all previously installed codes in your profile 2. Paste the following code as it appears 3. Save the profile layout 4. View your profile and refresh by hitting CTRL+F5-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & @CRLF

		$contact_box = "<!--Place the code after this in the About Me section-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<!--Contact Box Code-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & "> .contactTable { width:300px !important; height:150px !important; background-image:url(" & Chr(34) & $gt_cb_url & Chr(34) & "); background-repeat:no-repeat; background-color:transparent; background-attachment:scroll; background-position:center center; padding:0px !important;} .contactTable table, table.contactTable td { background-color:transparent; background-image:none; padding:0px !important;} .contactTable a img {visibility:hidden; border:0px !important;} .contactTable .text {font-size:1px !important;} </style>" & @CRLF & @CRLF
		$extended_setup = "<!--Extended Network Image-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "table table table td {vertical-align:top ! important;}" & @CRLF & "span.blacktext12 {" & @CRLF & "visibility:visible !important;" & @CRLF & "background-color:transparent;" & @CRLF &"background-image:url(" & Chr(34) & $gt_extended & Chr(34) & ");" & @CRLF & "background-repeat:no-repeat;" & @CRLF & "background-position:center center;" & @CRLF & "width:435px; height:75px; display:block !important;" & @CRLF & "font-size:0.0em; letter-spacing:-5px;}" & @CRLF & "span.blacktext12 span," & @CRLF & "span.blacktext12 img {display:none;}" & @CRLF & "</style>" & @CRLF
		
		$background_setup = "<!--Background Image-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<STYLE type=text/css>table, td {background-color:transparent;border:solid;border-width:0}</STYLE>" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "body{background-color:" & $Gt_Bg_Color & ";" & @CRLF & "background-image:url(" & $gt_bg_url & ") !important;" & @CRLF & "background-attachment:fixed;" & @CRLF & "background-repeat: no-repeat;" & @CRLF & "background-position: bottom center;}" & @CRLF & "</style>" & @CRLF & @CRLF
		
		$text_setup = "<!--Colors codes-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<STYLE type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "table, td {background-color:transparent;" & @CRLF & "border:none;border-width:5;}" & @CRLF & "</STYLE>" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "td, table {color: " & $gt_T1_Color & "}" & @CRLF & ".whitetext12 {display:none}" & @CRLF & ".lightbluetext8 {display:none}" & @CRLF & ".blacktext12 {display:none}" & @CRLF & ".btext {display:none}" & @CRLF & ".blacktext10 {display:none}" & @CRLF & ".text {color: " & $gt_T2_Color & "}" & @CRLF & ".orangetext15 {display:none}" & @CRLF & ".nametext {color: " & $gt_T2_Color & "}" & @CRLF & ".redbtext{display:none}" & @CRLF & "A:link, A:visited, A:active, A:hover, a.navbar, a.navbar:link, a.navbar:active, a.navbar:visited, a.navbar:hover, a.redlink:link, a.redlink:active, a.redlink:visited, a.redlink:hover, a.searchlinksmall, a.searchlinksmall:link, a.searchlinksmall:active, " & @CRLF & "a.searchlinksmall:visited, " & @CRLF & "a.searchlinksmall:hover{color:" & $gt_T1_Color & "}" & @CRLF & ".navigationbar{display:none}" & @CRLF & "</style>" & @CRLF & @CRLF
		
		$scrollbars_setup = "<!--Scrollbar codes-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "body {	" & @CRLF & "scrollbar-face-color:" & $gt_T2_Color & ";" & @CRLF & "scrollbar-highlight-color:" & $gt_T1_Color & ";" & @CRLF & "scrollbar-3dlight-color:" & $gt_T2_Color & ";" & @CRLF & "scrollbar-shadow-color:" & $Gt_Bg_Color & ";" & @CRLF & "scrollbar-darkshadow-color:" & $gt_T2_Color & ";" & @CRLF & "scrollbar-arrow-color:" & $gt_T1_Color & ";" & @CRLF & "scrollbar-track-color:" & $gt_T1_Color & ";	 " & @CRLF & "}" & @CRLF & "</style>" & @CRLF
		
		$hidefriends_setup = "<!--Hide Friends-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "td.text td.text table table table, td.text td.text table br, td.text td.text table .orangetext15, td.text td.text .redlink, td.text td.text span.btext {display:none;}" & @CRLF & "td.text td.text table {background-color:transparent;}" & @CRLF & "td.text td.text table td, td.text td.text table {height:0;padding:0;border:0;}" & @CRLF & "td.text td.text table table td {padding:3;}" & @CRLF & "td.text td.text table table br {display:inline;}" & @CRLF & "</style>" & @CRLF
		$centerprofile_setup = "<!--Center Profile-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<style type=" & Chr(34) & "text/css" & Chr(34) & ">" & @CRLF & "table table table table table {direction:rtl;}" & @CRLF & "table table table table table td {direction:ltr;}" & @CRLF & "</style>" & @CRLF
		$hidecomments_setup = "<!--Place this in the Id Like to meet section-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<!--Hide Comments-DO NOT ADD THIS LINE IN YOUR PROFILE-->" & @CRLF & "<div style=" & Chr(34) & "position:relative; height:400px; overflow:hidden; border:0px;" & Chr(34) & "><table><tr><td><table><tr><td>" 

		If $gt_addinstructions = "1"  Then
			FileWriteLine($file, $addinstructions_setup)
		EndIf
		
		If $gt_cb_url<> "Contact Box image URL" Then
			FileWriteLine($file, $contact_box)
		EndIf
		
		If $gt_bg_url<> "Background image URL" Then
			FileWriteLine($file, $background_setup)
		EndIf
		
		If $gt_extended<> "Extended Network image URL" Then
			FileWriteLine($file, $extended_setup)
		EndIf
		
		If $sample_bg=1 and $sample_T1=1 and $sample_T2=1 Then
			FileWriteLine($file, $text_setup)
		EndIf
		
		;Checks for additional options
		If $gt_hidefriends = "1"  Then
			FileWriteLine($file, $hidefriends_setup)
		EndIf
		
		If $gt_centerprofile = "1"  Then
			FileWriteLine($file, $centerprofile_setup)
		EndIf
		
		If $gt_scrollbars = "1" Then
			FileWriteLine($file, $scrollbars_setup)
		EndIf
		
		If $gt_hidecomments = "1"  Then
			FileWriteLine($file, $hidecomments_setup)
		EndIf
		
		FileClose($file)
		
		ShellExecute($filename)
	EndIf
EndFunc   ;==>SaveLayout

While 1
	If $Gt_Bg_Color<>0 And $sample_bg<>1 Then	
		$background_color_sample = GUICtrlCreateGraphic(10, 250, 40, 40)
			GUICtrlSetBkColor($background_color_sample, $Gt_Bg_Color)
			GUICtrlCreateLabel("Background", 60, 270, 60, 20)
			GUICtrlSetColor(-1, $Gt_Bg_Color)
			$sample_bg=1
	EndIf
	
	If $gt_T1_Color<>0 And $sample_T1<>1 Then	
		$text1_color_sample = GUICtrlCreateGraphic(130, 250, 40, 40)
			GUICtrlSetBkColor($text1_color_sample, $gt_T1_Color)
			GUICtrlCreateLabel("Text 1", 180, 270, 60, 20)
			GUICtrlSetColor(-1, $gt_T1_Color)
		$sample_T1=1
	EndIf
	
	If $gt_T2_Color<>0 And $sample_T2<>1 Then	
		$text2_color_sample = GUICtrlCreateGraphic(250, 250, 40, 40)
			GUICtrlSetBkColor($text2_color_sample, $gt_T2_Color)
			GUICtrlCreateLabel("Text 2", 300, 270, 60, 20)
			GUICtrlSetColor(-1, $gt_T2_Color)
		$sample_T2=1
	EndIf
	
	$msg = GUIGetMsg()
	Select
		Case $msg = $bT_T1
			Call("Color_T1")
		Case $msg = $bT_T2
			Call("Color_T2")
		Case $msg = $bT_BG
			Call("Color_BG")
		Case $msg = $bT_Output
			Call("SaveLayout")
		Case $msg = $GUI_EVENT_CLOSE
			Exit
	EndSelect
WEnd