#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=google-chrome.ico
#AutoIt3Wrapper_Res_Comment=copyright obscurant1st.biz
#AutoIt3Wrapper_Res_Description=Google Chrome Theme Maker
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <String.au3>
MsgBox(0,"Important!","Make Sure You have installed Chrome and have Closed all instances of it.")
Func ColorPic()
	$org = _ChooseColor(2, 0x0080ff, 2)
	$color = String($org)
	$color = StringTrimLeft($color,2)
	$color = _StringInsert ($color,"-",2)
	$color = _StringInsert ($color,"-",5)

	$StrArr = StringSplit($color,"-")

	$R = dec($StrArr[1])
	$G = Dec($StrArr[2])
	$B = Dec($StrArr[3])
	$RGB = $R & "," & $G & "," & $B
	Return $RGB
EndFunc

Func themeMaker()

	Global $themeDir = $destDir & "\" & GUICtrlRead($themename)
	DirCreate($themeDir)
	DirCreate($themeDir & "\img")
	$imgsPath = $themeDir & "\img\"
	FileCopy($bkgrndPath, $imgsPath & "1.jpg" , 1+9)
	FileCopy($frameimgpath, $imgsPath & "2.jpg" , 1+9)
	FileCopy($tabimgpath , $imgsPath & "3.jpg" , 1+9)
	FileCopy($toolbarimgpath , $imgsPath & "4.jpg" , 1+9)
	$manifest = fileopen($themeDir & "\manifest.json",1)
	FileWrite($manifest ,'{"version":"1.0","name":"')
	FileWrite( $manifest , GUICtrlRead($themename))
	FileWrite($manifest , '","theme":{"images":{"theme_frame":"img/2.jpg","theme_toolbar":"img/4.jpg","theme_tab_background":"img/3.jpg","theme_ntp_background":"img/1.jpg"},')
	FileWrite($manifest , '"colors":{"frame":[' & $RGBfrm[1] & ',' & $RGBfrm[2] & ',' & $RGBfrm[3] & '],"ntp_link":[' & $RGBntpl[1] & ',' & $RGBntpl[2] & ',' & $RGBntpl[3] & '],"toolbar":[' & $RGBtb[1] & ',' & $RGBtb[2] & ',' & $RGBtb[3] & '],"ntp_section":[' & $RGBntps[1] & ',' & $RGBntps[2] & ',' & $RGBntps[3] & '],"tab_text":[' & $RGBtabtxt[1] & ',' & $RGBtabtxt[2] & ',' & $RGBtabtxt[3] & '],"ntp_text":[' & $RGBntptxt[1] & ',' & $RGBntptxt[2] & ',' & $RGBntptxt[3] & '],"button_background":[' & $RGBbtbkgrnd[1] & ',' & $RGBbtbkgrnd[2] & ',' & $RGBbtbkgrnd[3] & '],"ntp_section_link":[' & $RGBntpsl[1] & ',' & $RGBntpsl[2] & ',' & $RGBntpsl[3] & ']},"properties":{"ntp_background_alignment":"topleft","ntp_background_repeat":"repeat","ntp_logo_alternate":1},"tints":{"buttons":[1,1,1]}}}')
	FileClose($manifest)
	If(@OSVersion = "WIN_VISTA") Then
		$chromedir = @AppDataDir
		$chromedir = StringTrimRight($chromedir,7)
		$chromedir = $chromedir & "Local\Google\Chrome\Application\"
		ShellExecute($chromedir & 'chrome.exe' , '--pack-extension="' & $themeDir & '"' )
		MsgBox(0,"done!!!","Theme Created")
	ElseIf(@OSVersion = "WIN_XP") Then
		$chromedir = @AppDataDir
		$chromedir = StringTrimRight($chromedir,16)
		$chromedir = $chromedir & "Local Settings\Application Data\Google\Chrome\Application\"
		ShellExecute($chromedir & 'chrome.exe' , '--pack-extension="' & $themeDir & '"' )
		MsgBox(0,"done!!!","Theme Created")
	Else
		Msgbox(0,"Ooops!!!","Sorry, This OS version is Not Supported.")
	EndIf
EndFunc


#Region ### START Koda GUI section ### Form=C:\Documents and Settings\Plato\Desktop\koda_1.7.2.0\Forms\Odx Chrome Theme Maker.kxf
	Dim $RGBfrm[4],$RGBntptxt[4],$RGBntpl[4],$RGBntps[4],$RGBntpsl[4],$RGBbtbkgrnd[4],$RGBtb[4],$RGBtabtxt[4]
	$RGBfrm[1] = "91"
	$RGBntptxt[1] = "255"
	$RGBntptxt[2] = "255"
	$RGBntptxt[3] = "255"
	$RGBntpl[1] = "255"
	$RGBfrm[2] = "149"
	$RGBntpl[2] = "255"
	$RGBntpl[3] = "255"
	$RGBntps[1] = "92"
	$RGBntps[2] = "149"
	$RGBntps[3] = "8"
	$RGBntpsl[1] = "255"
	$RGBntpsl[2] = "255"
	$RGBntpsl[3] = "255"
	$RGBbtbkgrnd[1] = "255"
	$RGBbtbkgrnd[2] = "255"
	$RGBfrm[3] = "8"
	$RGBbtbkgrnd[3] = "255"
	$RGBtb[1] = "92"
	$RGBtb[2] = "149"
	$RGBtb[3] = "8"
	$RGBtabtxt[1] ="255"
	$RGBtabtxt[2] = "255"
	$RGBtabtxt[3] = "255"

$Form1 = GUICreate("oDx Chrome theme Maker v1.0.0.1", 686, 507, 191, 115)
GUISetBkColor(0xA6CAF0)
GUICtrlCreateLabel("Please Visit oDx HomePage:", 300, 28, 140, 17)
$link = GUICtrlCreateLabel("obscurant1st.biz/blog", 440 , 27 , 200)
GUICtrlSetColor($link,0xFA05E1)
GUICtrlSetFont($link,9,400,2+4)
$theme = Random(1,9999999,1)
$Label1 = GUICtrlCreateLabel("Theme Name:", 32, 28, 71, 17)
$themename = GUICtrlCreateInput("oDx_GC_theme_" & $theme , 112, 24, 153, 21)
$Label2 = GUICtrlCreateLabel("Insert Path to BackGround Image:(400x800px):", 32, 68, 226, 17)
$bkgrnd = GUICtrlCreateInput("Background  Image For the Browser", 264, 64, 185, 21)
$Label3 = GUICtrlCreateLabel("Insert Path to Frame:(550x250px):", 32, 108, 163, 17)
$frameimg = GUICtrlCreateInput("Background Image For Frame", 264, 104, 185, 21)
$Label4 = GUICtrlCreateLabel("Insert Path to Tab BackGround:(32x32px):", 32, 148, 204, 17)
$tabimg = GUICtrlCreateInput("Backgorund image for Tab", 264, 144, 185, 21)
$Label5 = GUICtrlCreateLabel("Insert Path to Toolbar BackGround:(32x32px):", 32, 188, 221, 17)
$toolbarimg = GUICtrlCreateInput("Backgorund image for Toolbar", 264, 184, 185, 21)
$bkgrndimg = GUICtrlCreateButton("Browse", 472, 67, 73, 17, $WS_GROUP)
$framebkgrnd = GUICtrlCreateButton("Browse", 472, 107, 75, 17, $WS_GROUP)
$toolbarbkgrnd = GUICtrlCreateButton("Browse", 472, 187, 75, 17, $WS_GROUP)
$tabbkdrnd = GUICtrlCreateButton("Browse", 472, 147, 75, 17, $WS_GROUP)
$Label6 = GUICtrlCreateLabel("Frame:", 32, 244, 36, 17)
$Input1 = GUICtrlCreateInput("91", 120, 240, 25, 21)
$Input2 = GUICtrlCreateInput("149", 152, 240, 25, 21)
$Input3 = GUICtrlCreateInput("8", 184, 240, 25, 21)
$Label7 = GUICtrlCreateLabel("Toolbar:", 248, 244, 43, 17)
$Input4 = GUICtrlCreateInput("92", 336, 240, 25, 21)
$Input5 = GUICtrlCreateInput("149", 368, 240, 25, 21)
$Input6 = GUICtrlCreateInput("8", 400, 240, 25, 21)
$Label8 = GUICtrlCreateLabel("Tab Text:", 464, 244, 50, 17)
$Input7 = GUICtrlCreateInput("255", 552, 240, 25, 21)
$Input8 = GUICtrlCreateInput("255", 584, 240, 25, 21)
$Input9 = GUICtrlCreateInput("255", 616, 240, 25, 21)
$Label11 = GUICtrlCreateLabel("NTP* Text:", 464, 276, 57, 17)
$Input16 = GUICtrlCreateInput("255", 552, 272, 25, 21)
$Input17 = GUICtrlCreateInput("255", 584, 272, 25, 21)
$Input18 = GUICtrlCreateInput("255", 616, 272, 25, 21)
$Label12 = GUICtrlCreateLabel("NTP Link", 32, 276, 49, 17)
$Input19 = GUICtrlCreateInput("255", 120, 272, 25, 21)
$Input20 = GUICtrlCreateInput("255", 152, 272, 25, 21)
$Input21 = GUICtrlCreateInput("255", 184, 272, 25, 21)
$Label13 = GUICtrlCreateLabel("NTP Section:", 248, 276, 68, 17)
$Input22 = GUICtrlCreateInput("92", 336, 272, 25, 21)
$Input23 = GUICtrlCreateInput("149", 368, 272, 25, 21)
$Input24 = GUICtrlCreateInput("8", 400, 272, 25, 21)
$Label14 = GUICtrlCreateLabel("NTP Section Link", 248, 308, 88, 17)
$Input25 = GUICtrlCreateInput("255", 336, 304, 25, 21)
$Input26 = GUICtrlCreateInput("255", 368, 304, 25, 21)
$Input27 = GUICtrlCreateInput("255", 400, 304, 25, 21)
$Label15 = GUICtrlCreateLabel("Button BkGrnd:", 32, 308, 77, 17)
$Input28 = GUICtrlCreateInput("255", 120, 304, 25, 21)
$Input29 = GUICtrlCreateInput("255", 152, 304, 25, 21)
$Input30 = GUICtrlCreateInput("255", 184, 304, 25, 21)
$Label17 = GUICtrlCreateLabel("Colors:", 16, 216, 61, 23)
GUICtrlSetFont(-1, 12, 800, 0, "DejaVu Serif Condensed")
$Label18 = GUICtrlCreateLabel("NTP* - New Tab Page", 16, 336, 140, 20)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Button1 = GUICtrlCreateButton("Create Theme", 200, 432, 273, 49, $WS_GROUP)
GUICtrlSetFont(-1, 12, 800, 0, "Lucida Sans")
$Label9 = GUICtrlCreateLabel("Enter Destination Directory:", 24, 372, 133, 17)
$Input10 = GUICtrlCreateInput("Destination Directory for theme", 160, 368, 185, 21)
$Button2 = GUICtrlCreateButton("Browse", 360, 371, 75, 17, $WS_GROUP)
$Button3 = GUICtrlCreateButton("Pick", 214, 242, 30, 17, $WS_GROUP)
$Button4 = GUICtrlCreateButton("Pick", 214, 274, 30, 17, $WS_GROUP)
$Button5 = GUICtrlCreateButton("Pick", 430, 242, 30, 17, $WS_GROUP)
$Button6 = GUICtrlCreateButton("Pick", 430, 274, 30, 17, $WS_GROUP)
$Button7 = GUICtrlCreateButton("Pick", 646, 242, 30, 17, $WS_GROUP)
$Button8 = GUICtrlCreateButton("Pick", 646, 274, 30, 17, $WS_GROUP)
$Button9 = GUICtrlCreateButton("Pick", 214, 306, 30, 17, $WS_GROUP)
$Button10 = GUICtrlCreateButton("Pick", 430, 306, 30, 17, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
$nMsg = GUIGetMsg()
Switch $nMsg
	; Get image Files
	Case $bkgrndimg
		$bkgrndPath = FileOpenDialog("select image for BackGround",@DesktopDir,"Images (*.jpg;*.bmp;*.jpeg;*.png)")
		GUICtrlSetData($bkgrnd,$bkgrndPath)

	Case $framebkgrnd
		$frameimgpath = FileOpenDialog("select image for Frame BackGround",@DesktopDir,"Images (*.jpg;*.bmp;*.jpeg;*.png)")
		GUICtrlSetData($frameimg,$frameimgpath)

	Case $tabbkdrnd
		$tabimgpath = FileOpenDialog("select image for Tab BackGround",@DesktopDir,"Images (*.jpg;*.bmp;*.jpeg;*.png)")
		GUICtrlSetData($tabimg,$tabimgpath)

	Case $toolbarbkgrnd
		$toolbarimgpath = FileOpenDialog("select image for Toolbar BackGround",@DesktopDir,"Images (*.jpg;*.bmp;*.jpeg;*.png)")
		GUICtrlSetData($toolbarimg,$toolbarimgpath)


	; Get colors in RBG
Case $Button3
		$frmColor = ColorPic()
		$RGBfrm = StringSplit($frmColor,",")
		GUICtrlSetData($Input1,$RGBfrm[1])
		GUICtrlSetData($Input2,$RGBfrm[2])
		GUICtrlSetData($Input3,$RGBfrm[3])

Case $Button4
		$ntplColor = ColorPic()
		$RGBntpl = StringSplit($ntplColor,",")
		GUICtrlSetData($Input19,$RGBntpl[1])
		GUICtrlSetData($Input20,$RGBntpl[2])
		GUICtrlSetData($Input21,$RGBntpl[3])

Case $Button5
		$tbColor = ColorPic()
		$RGBtb = StringSplit($tbColor,",")
		GUICtrlSetData($Input4,$RGBtb[1])
		GUICtrlSetData($Input5,$RGBtb[2])
		GUICtrlSetData($Input6,$RGBtb[3])

Case $Button6
		$ntpsColor = ColorPic()
		$RGBntps = StringSplit($ntpsColor,",")
		GUICtrlSetData($Input22,$RGBntps[1])
		GUICtrlSetData($Input23,$RGBntps[2])
		GUICtrlSetData($Input24,$RGBntps[3])

Case $Button7
		$tabtxtColor = ColorPic()
		$RGBtabtxt = StringSplit($tabtxtColor,",")
		GUICtrlSetData($Input7,$RGBtabtxt[1])
		GUICtrlSetData($Input8,$RGBtabtxt[2])
		GUICtrlSetData($Input9,$RGBtabtxt[3])

Case $Button8
		$ntptxtColor = ColorPic()
		$RGBntptxt = StringSplit($ntptxtColor,",")
		GUICtrlSetData($Input16,$RGBntptxt[1])
		GUICtrlSetData($Input17,$RGBntptxt[2])
		GUICtrlSetData($Input18,$RGBntptxt[3])

Case $Button9
		$btbkgrndColor = ColorPic()
		$RGBbtbkgrnd = StringSplit($btbkgrndColor,",")
		GUICtrlSetData($Input28,$RGBbtbkgrnd[1])
		GUICtrlSetData($Input29,$RGBbtbkgrnd[2])
		GUICtrlSetData($Input30,$RGBbtbkgrnd[3])

Case $Button10
		$ntpslcolor = ColorPic()
		$RGBntpsl = StringSplit($ntpslcolor,",")
		GUICtrlSetData($Input25,$RGBntpsl[1])
		GUICtrlSetData($Input26,$RGBntpsl[2])
		GUICtrlSetData($Input27,$RGBntpsl[3])


Case $Button2
		$destDir = FileSelectFolder("Select the Destination Directory:","")
		GUICtrlSetData($Input10,$destDir)

Case $Button1
		themeMaker()
		$yesorno = MsgBox(4,"Clean Up","Delete File Which are not required?")
		If($yesorno = 6) Then
			FileDelete($themedir & "\*.*")
			DirRemove($themedir & "\img" , 1)
			FileCopy($destDir & "\*.crx",$themedir & "\")
			FileCopy($destDir & "\*.pem",$themedir & "\")
		EndIf
Case $link
            _IECreate("                            ")

Case $GUI_EVENT_CLOSE
		Exit

EndSwitch

WEnd
