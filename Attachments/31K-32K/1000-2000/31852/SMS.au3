#include-once

#include <INet.au3>

Global $oMyRet[2]
Global $oMyError

Global Const $ALIANT_CANADA = "@wirefree.informe.ca"
Global Const $ALLTEL = "@message.alltel.com"
Global Const $AMERITECH = "@paging.acswireless.com"
Global Const $ANDHRA_PRADESH_AIRTEL_INDIA = "91@airtelap.com"
Global Const $ANDHRA_PRADESH_IDEA_CELLULAR_INDIA = "9848@ideacellular.net"
Global Const $ATT_WIRELESS = "@txt.att.net"
Global Const $AU_BY_KDDI_JAPAN = "@ezweb.ne.jp"
Global Const $BELL_MOBILITY_CANADA = "@txt.bellmobility.ca"
Global Const $BELLSOUTH = "@bellsouth.cl"
Global Const $BOOST = "@myboostmobile.com"
Global Const $BOUYGES_TELECOM = "@mms.bouyguestelecom.fr"
Global Const $CELLULARONE = "@mobile.celloneusa.com"
Global Const $CELLULARONE_MMS = "@mms.uscc.net"
Global Const $CHENNAI_RPG_CELLULAR_INDIA = "9841@rpgmail.net"
Global Const $CHENNAI_SKYCELL_AIRTEL_INDIA = "919840@airtelchennai.com"
Global Const $CINGULAR = "1@mobile.mycingular.com"
Global Const $DELHI_AIRTEL_INDIA = "919810@airtelmail.com"
Global Const $DELHI_HUTCH_INDIA = "9811@delhi.hutch.co.in"
Global Const $EDGE_WIRELESS = "@sms.edgewireless.com"
Global Const $E_PLUS_GERMANY = "0@smsmail.eplus.de"
Global Const $FIDO_CANADA = "@fido.ca"
Global Const $GLOBUL_BULGARIA = "@sms.globul.bg"
Global Const $GOA_AIRTEL_INDIA = "919890@airtelmail.com"
Global Const $GOA_BPL_MOBILE_INDIA = "9823@bplmobile.com"
Global Const $GOA_IDEA_CELLULAR_INDIA = "9822@ideacellular.net"
Global Const $GUJARAT_AIRTEL_INDIA = "919898@airtelmail.com"
Global Const $GUJARAT_CELFORCE_FASCEL_INDIA = "9825@celforce.com"
Global Const $GUJARAT_IDEA_CELLULAR_INDIA = "9824@ideacellular.net"
Global Const $HARYANA_AIRTEL_INDIA = "919896@airtelmail.com"
Global Const $HARYANA_ESCOTEL_INDIA = "9812@escotelmobile.com"
Global Const $HIMACHAL_PRADESH_AIRTEL_INDIA = "919816@airtelmail.com"
Global Const $KARNATAKA_AIRTEL_INDIA = "919845@airtelkk.com"
Global Const $KERALA_AIRTEL_INDIA = "919895@airtelkerala.com"
Global Const $KERALA_BPL_MOBILE_INDIA = "9846@bplmobile.com"
Global Const $KERALA_ESCOTEL_INDIA = "9847@escotelmobile.com"
Global Const $M1_SINGAPORE = "@m1.com.sg"
Global Const $MADHYA_PRADESH_AIRTEL_INDIA = "919893@airtelmail.com"
Global Const $MAHARASHTRA_AIRTEL_INDIA = "919890@airtelmail.com"
Global Const $MAHARASHTRA_BPL_MOBILE_INDIA = "9823@bplmobile.com"
Global Const $MAHARASHTRA_IDEA_CELLULAR_INDIA = "9822@ideacellular.net"
Global Const $METEOR_IRELAND = "@sms.mymeteor.ie"
Global Const $METEOR_MMS_IRELAND = "@mms.mymeteor.ie"
Global Const $METRO_PCS = "@mymetropcs.com"
Global Const $MTEL_BULGARIA = "@sms.mtel.net"
Global Const $MTS_MOBILITY_CANADA = "@text.mtsmobility.com"
Global Const $MUMBAI_AIRTEL_INDIA = "919892@airtelmail.com"
Global Const $MUMBAI_BPL_MOBILE_INDIA = "9821@bplmobile.com"
Global Const $NEXTEL = "@messaging.nextel.com"
Global Const $NTT_DOCOMO_JAPAN = "@docomo.ne.jp"
Global Const $O2 = "@mobile.celloneusa.com"
Global Const $O2_UK = "44@mobile.celloneusa.com"
Global Const $O2_UK2 = "44@mmail.co.uk"
Global Const $O2_GERMANY = "0@o2online.de"
Global Const $OGVODAFONE_ICELAND = "@sms.is"
Global Const $OR_KOLKATA_AIRTEL_INDIA = "919831@airtelkol.com"
Global Const $ORANGE = "@mobile.celloneusa.com"
Global Const $ORANGE_NETHERLANDS = "0@sms.orange.nl"
Global Const $ORANGE_UK = "0@orange.net"
Global Const $PONDICHERRY_BPL_MOBILE_INDIA = "9843@bplmobile.com"
Global Const $PRESIDENTS_CHOICE_CANADA = "@mobiletxt.ca"
Global Const $PUNJAB_AIRTEL_INDIA = "919815@airtelmail.com"
Global Const $QWEST = "@qwestmp.com"
Global Const $ROGERS_WIRELESS = "@pcs.rogers.com"
Global Const $ROGERS_WIRELESS_CANADA = "@pcs.rogers.com"
Global Const $SASKTEL_MOBILITY_CANADA = "@pcs.sasktelmobility.com"
Global Const $SFR_FRANCE = "@sfr.fr"
Global Const $SIMINN_ICELAND = "@box.is"
Global Const $SPRINT_PCS = "@messaging.sprintpcs.com"
Global Const $TAMIL_NADU_AIRCEL_INDIA = "9842@airsms.com"
Global Const $TAMIL_NADU_AIRTEL_INDIA = "919894@airtelmail.com"
Global Const $TAMIL_NADU_BPL_MOBILE_INDIA = "919843@bplmobile.com"
Global Const $TELE2_SWEDEN = "0@sms.tele2.se"
Global Const $TELE2_LATVIA = "@sms.tele2.lv"
Global Const $TELEFLIP = "@teleflip.com"
Global Const $TELEFONICA_MOVISTAR_SPAIN = "0@movistar.net"
Global Const $TELUS_CANADA = "@msg.telus.com"
Global Const $TELUS_MOBILITY = "@msg.telus.com"
Global Const $TIM_ITALY = "0@timnet.com"
Global Const $T_MOBILE = "@tmomail.net"
Global Const $T_MOBILE_OPTUS_ZOO_AUSTRALIA = "0@optusmobile.com.au"
Global Const $T_MOBILE_AUSTRIA = "43676@sms.t-mobile.at"
Global Const $T_MOBILE_GERMANY = "0@t-d1-sms.de"
Global Const $T_MOBILE_NETHERLANDS = "31@gin.nl"
Global Const $T_MOBILE_UK = "0@t-mobile.uk.net"
Global Const $US_CELLULAR = "@email.uscc.net"
Global Const $UTTAR_PRADESH_WEST_ESCOTEL_INDIA = "9837@escotelmobile.com"
Global Const $VERIZON = "@vtext.com"
Global Const $VIRGIN_MOBILE = "@vmobl.com"
Global Const $VIRGIN_MOBILE_CANADA = "@vmobile.ca"
Global Const $VIRGIN_MOBILE_UK = "0@vxtras.com"
Global Const $VODACOM_SINGAPORE = "@voda.co.za"
Global Const $VODAFONE_CHUUGOKU_WESTERN_JAPAN = "@n.vodafone.ne.jp"
Global Const $VODAFONE_GERMANY = "0@vodafone-sms.de"
Global Const $VODAFONE_HOKKAIDO_JAPAN = "@d.vodafone.ne.jp"
Global Const $VODAFONE_HOKURIKO_CENTRAL_NORTH_JAPAN = "@r.vodafone.ne.jp"
Global Const $VODAFONE_ITALY = "3**@sms.vodafone.it"
Global Const $VODAFONE_KANSAI_WEST = "@k.vodafone.ne.jp"
Global Const $VODAFONE_KANTO_KOUSHIN_EAST = "@t.vodafone.ne.jp"
Global Const $VODAFONE_KYUUSHU_OKINAWA_JAPAN = "@q.vodafone.ne.jp"
Global Const $VODAFONE_SHIKOKU_JAPAN = "@s.vodafone.ne.jp"
Global Const $VODAFONE_SPAIN = "0@vodafone.es"
Global Const $VODAFONE_TOUHOKU_NIIGATA_NORTH_JAPAN = "@h.vodafone.ne.jp"
Global Const $VODAFONE_TOUKAI_CENTRAL_JAPAN = "@c.vodafone.ne.jp"
Global Const $VODAFONE_UK = "0@vodafone.net"
Global Const $WILLCOM_DI_JAPAN = "@di.pdx.ne.jp"
Global Const $WILLCOM_DJ_JAPAN = "@dj.pdx.ne.jp"
Global Const $WILLCOM_DK_JAPAN = "@dk.pdx.ne.jp"
Global Const $WILLCOM_JAPAN = "@pdx.ne.jp"

Func _StartSMS($SMTP_SERVER,$EMAIL_ADDRESS,$USERNAME,$PASSWORD,$PORT = 25,$SSL = 0)
	Local $SMS[6]
	$SMS[0] = $SMTP_SERVER
	$SMS[1] = $EMAIL_ADDRESS
	$SMS[2] = $USERNAME
	$SMS[3] = $PASSWORD
	$SMS[4] = $PORT
	$SMS[5] = $SSL
	Return $SMS
EndFunc

Func _SendSMS($SMS,$NUMBER,$SERVICE,$MESSAGE,$FROMNAME = "")
	$oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
	$rc = _INetSmtpMailCom($SMS[0], $FROMNAME, $SMS[1], _GetAddress($NUMBER,$SERVICE), $MESSAGE, $SMS[2], $SMS[3], $SMS[4], $SMS[5])
	If @error Then
		MsgBox(0, "Error sending message", "Error code:" & @error & "  Description:" & $rc)
	EndIf
EndFunc

Func _GetAddress($NUMBER,$SERVICE)
	Local $split
	$split = StringSplit($SERVICE,"@")
	If $split[1] <> "" Then
		Return $split[1] & $NUMBER & "@" & $split[2]
	Else
		Return $NUMBER & $SERVICE
	EndIf
EndFunc

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 0)
	Local $objEmail = ObjCreate("CDO.Message")
    $objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
    $objEmail.To = $s_ToAddress
    Local $i_Error = 0
    Local $i_Error_desciption = ""
    $objEmail.Subject = $s_Subject
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
    If Number($IPPort) = 0 then $IPPort = 25
    $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
    ;Authenticated SMTP
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
    ;Update settings
    $objEmail.Configuration.Fields.Update
    ; Set Email Importance
	$objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"

    $objEmail.Fields.Update
    ; Sent the Message
    $objEmail.Send
    If @error Then
        SetError(2)
        Return $oMyRet[1]
    EndIf
    $objEmail=""
EndFunc   ;==>_INetSmtpMailCom
;
;
; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc
