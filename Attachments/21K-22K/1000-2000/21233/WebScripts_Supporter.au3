;||----------------------------------------------------------||
;||----------------------------------------------------------||
;||WebScripts Supporter ver1.1.0
;||Requirement(s): <_SaveAs.au3><_Open.au3>
;||Author : d4rk < Le Khuong Duy >               
;||----------------------------------------------------------||
;||----------------------------------------------------------||

#include <IE.au3>
#include <Misc.au3>
#include <Array.au3>
#include <File.au3>
#include <FTP.au3>
#include <GUIConstants.au3>
#include "_SaveAs().au3"
#include "_Open().au3"


Global $OverWriteConfirm,$NoExtensionOverWriteConfirm,$Path,$RawPath,$RawHTML,$Open,$SavePath,$OpenFile,$CurrentPath,$Status

#Region ### START Koda GUI section ### Form=E:\AutoIt Project\HTML Helper.kxf
$GUI = GUICreate("WebScripts Supporter ver1.0.0", 720, 450, 211, 104)

$RawHTML= GUICtrlCreateEdit("", 3, 5, 273, 385)

$MenuFile = GUICtrlCreateMenu("&File")
$MenuFile_Open = GUICtrlCreateMenuItem("&Open ...", $MenuFile)

GUICtrlCreateMenuItem("", $MenuFile, 2)
$MenuFile_Save = GUICtrlCreateMenuItem("&Save", $MenuFile)
$MenuFile_SaveAs = GUICtrlCreateMenuItem("Save &As ...", $MenuFile)
GUICtrlCreateMenuItem("", $MenuFile, 4)
$MenuFile_RealWindow = GUICtrlCreateMenuItem("Vie&w On Real Window", $MenuFile)

GUICtrlCreateMenuItem("", $MenuFile,8)

$MenuFile_Exit = GUICtrlCreateMenuItem("E&xit ...", $MenuFile)
;-------------------

$MenuDownload = GUICtrlCreateMenu("&Download Source")
$MenuDownload_New = GUICtrlCreateMenuItem("&Click here to select the page's source ...", $MenuDownload)
$MenuDownload_Reset = GUICtrlCreateMenuItem("&Reset ...", $MenuDownload)

;--------------------------
$MenuUpload = GUICtrlCreateMenu("&Upload Source")
$MenuUpload_New = GUICtrlCreateMenuItem("U&pload Source As HTML Page ...", $MenuUpload)

;-----------------
$MenuValidate = GUICtrlCreateMenu("&Validate Source")
$MenuValidate_New = GUICtrlCreateMenuItem("Valida&te Now ...", $MenuValidate)


;------------------
$Run = GUICtrlCreateButton("Run", 4, 401, 81, 25, 0)
$Save = GUICtrlCreateButton("Save As ...", 99, 401, 81, 25, 0)
$Clear = GUICtrlCreateButton("Clear", 196, 401, 81, 25, 0)


GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


$oIE = _IECreateEmbedded ()
$GUIActiveX = GUICtrlCreateObj($oIE, 290, 5, 420, 385)
_IENavigate ($oIE, "about:blank")

$SavePath=""

While 1
	
if _IsPressed("74") Then
		_IEDocWriteHTML ($oIE,GUICtrlRead($RawHTML))
EndIf

	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		
		
		Case $GUI_EVENT_CLOSE
		
		$SavePath=$OpenFile
	If $SavePath="" and GUICtrlRead($RawHTML)<>"" Then
		$ask=MsgBox(52,"","Exit and save ?" & @CRLF & "Do you want to save now ?")
	If $ask=6 Then
			_SaveAs()
	EndIf
	Else
	if FileRead($OpenFile)<>GUICtrlRead($RawHTML) and $SavePath<>"" Then
		$ask=MsgBox(52,"","Look like you've made some changes, want to save ?")
	if $ask=6 Then
		_SaveAs()
	EndIf
	EndIf
	EndIf
		Exit

		
		Case $Run
			_IEDocWriteHTML ($oIE,GUICtrlRead($RawHTML))
		Case $Clear
		if GUICtrlRead($RawHTML)<>"" Then
			$Confirm=MsgBox(52,"Caution !","This will clear all of your source, are you sure want to process ?")
		if $Confirm=6 Then
			GUICtrlSetData($RawHTML,"")
		EndIf
		EndIf
			
		Case $Save
			_SaveAs()
		
;--------------------------------
		
	Case $MenuFile_Open
		_Open()
		
	Case $MenuFile_SaveAs
		_SaveAs()
	
	Case $MenuFile_Save
		$SavePath=$OpenFile
		if $SavePath="" Then
			_SaveAs()
		Else
			$OP=FileOpen($SavePath,2)
			FileWrite($OP,GUICtrlRead($RawHTML))
			FileClose($OP)
		EndIf
	
	
	Case $MenuFile_RealWindow 
		$RealWindow=_IECreate("about:blank")
		_IEBodyWriteHTML($RealWindow,GUICTrlRead($RawHTML))
	
	
	
	
	
	
	
	Case $MenuFile_Exit
		Exit
	
	Case $MenuDownload_New 
		$URL=InputBox("Online page's source","Enter the URL or website address :","http://","",250,100)
		If $URL<>"http://" Then
			GUICtrlSetState($MenuDownload_New, $GUI_DISABLE)
			GUICtrlSetData($MenuDownload_New,"Connecting ...")
			_IENavigate ($oIE,$URL)
			GUICtrlSetData($RawHTML,_IEBodyReadHTML($oIE))
		EndIf
		
		if GUICtrlRead($RawHTML)<>"" Then
			GUICtrlSetState($MenuDownload_New, $GUI_ENABLE)
			GUICtrlSetData($MenuDownload_New,"&Click here to select the page's source ...")
		EndIf
			
			opt("WinTitleMatchMode",2)
			WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0 [" & $URL & "]")
		;EndIf

	Case $MenuDownload_Reset 
		_IENavigate ($oIE, "about:blank")
		GUICtrlSetData($RawHTML,"")
		WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0")
		
	Case $MenuUpload_New
		
		$UploadFile=FileOpenDialog("Upload Source ...","","Text files (*.txt)")
		if $UploadFile="" Then
			Sleep(100)
		Else
		opt("WinTitleMatchMode",2)
		WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0 [Upload " & $UploadFile & "]")
		
		
		$SerVer   =InputBox("Upload Source ...","Your Ftp Server Address :","ftp.host.com","",100,100)
		$UserName =InputBox("Upload Source ...","Your Ftp User :","","",100,100)
		$PassWord =InputBox("Upload Source ...","Your Ftp Password :","","|",100,100)
		$UploadTo =InputBox("Upload Source ...","File will be uploaded to :" & @CRLF & "Example : /MyFiles/MySource.html" & @CRLF & "You can change extension to .txt, .doc, as long as it can be read","/","",300,150)
			
		
		
		
		$Dll=DllOpen('wininet.dll') 
		$Open = _FTPOpen('MyFTP Control')
		$Conn = _FTPConnect($Open, $SerVer, $UserName, $PassWord)
		$Ftpp = _FtpPutFile($Conn, $UploadFile , $UploadTo)
		$Ftpc = _FTPClose($Open)
		DllClose($Dll)
		
		$Result=MsgBox(68,"Upload Informations","Here is the link to your uploaded source : " & @CRLF & $Server & $UploadTo & @CRLF & "Want to browse it ?")
		if $Result=6 Then
			_IENavigate ($oIE,$Server & $UploadTo)
			GUICtrlSetData($RawHTML,_IEBodyReadHTML($oIE))
			opt("WinTitleMatchMode",2)
			WinSetTitle("WebScripts Supporter ver1.0.0","","WebScripts Supporter ver1.0.0 [" & $SerVer & $UploadTo & "]")

		EndIf
		EndIf
			
		
		
	Case $MenuValidate_New 
		_IENavigate ($oIE,"http://validator.w3.org/#validate_by_input")
		MsgBox(64,"Codes Validator","This is validator from w3.org" & @CRLF & "Simply paste your HTML codes to the box near by and Check it !")
		
		
	
EndSwitch
		

		
WEnd


