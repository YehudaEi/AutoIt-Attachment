#include-once
#include <INet.au3>

Global $o_smsMyRet[2]
Global $o_smsMyError = ObjEvent("AutoIt.Error", "_MyErrFunc")

Global Const $3RIVERWIRELESS 						= "n@sms.3rivers.net"
Global Const $ADVANTAGECOMMUNICATIONS 				= "n@advantagepaging.com"
Global Const $AIRTOUCHPAGERS 						= "n@airtouch.net"
Global Const $AIRTOUCHPAGERS2 						= "n@airtouchpaging.com"
Global Const $AIRTOUCHPAGERS3 						= "n@alphapage.airtouch.com"
Global Const $AIRTOUCHPAGERS4 						= "n@myairmail.com"
Global Const $AIRVOICE 								= "n@mmode.com"
Global Const $ALIANT_CANADA 						= "n@wirefree.informe.ca"
Global Const $ALLTEL 								= "n@message.alltel.com"
Global Const $ALLTEL2 								= "n@alltelmessage.com"
Global Const $ALLTELPCS 							= "n@message.alltel.com"
Global Const $AMERITECH 							= "n@paging.acswireless.com"
Global Const $AMERITECHPAGING 						= "n@pageapi.com"
Global Const $ANDHRA_PRADESH_AIRTEL_INDIA 			= "91n@airtelap.com"
Global Const $ANDHRA_PRADESH_IDEA_CELLULAR_INDIA 	= "9848n@ideacellular.net"
Global Const $ARCHPAGERS 							= "n@archwireless.net"
Global Const $ARCHPAGERS2 							= "n@epage.arch.com"
Global Const $ATT_WIRELESS 							= "n@txt.att.net"
Global Const $AU_BY_KDDI_JAPAN 						= "n@ezweb.ne.jp"
Global Const $BEELINEGSM_RUSSIA 					= "n@sms.beemail.ru"
Global Const $BELL_MOBILITY_CANADA 					= "n@txt.bellmobility.ca"
Global Const $BELL_MOBILITY_CANADA2 				= "n@txt.bell.ca"
Global Const $BELLSOUTH 							= "n@sms.bellsouth.com"
Global Const $BELLSOUTH2 							= "n@wireless.bellsouth.com"
Global Const $BELLSOUTH3 							= "n@blsdcs.net"
Global Const $BELLSOUTH_BLACKBERRY 					= "n@bellsouthtips.com"
Global Const $BELLSOUTH_MOBILITY 					= "n@blsdcs.net"
Global Const $BELLSOUTH_CHILE 						= "n@bellsouth.cl"
Global Const $BLUEGRASSCELLULAR 					= "n@sms.bluecell.com"
Global Const $BLUESKYFROG_AUSTRALIA 				= "n@blueskyfrog.com"
Global Const $BOOSTMOBILE							= "n@myboostmobile.com"
Global Const $BOUYGES_TELECOM 						= "n@mms.bouyguestelecom.fr"
Global Const $BPLMOBILE_INDIA 						= "n@bplmobile.com"
Global Const $CABLEANDWIRELESS_PANAMA 				= "n@cwmovil.com"
Global Const $CALLPLUS 								= "n@mmode.com"
Global Const $CAROLINAMOBILECOMMUNICATIONS 			= "n@cmcpaging.com"
Global Const $CELCOM_MALAYSIA 						= "019n@sms.celcom.com.my"
Global Const $CELLIS_LEBANON 						= "9613n@ens.jinny.com.lb"
Global Const $CELLULAR_ONE 							= "n@mobile.celloneusa.com"
Global Const $CELLULAR_ONE2 						= "n@sbcemail.com"
Global Const $CELLULAR_ONE3 						= "n@message.cellone-sf.com"
Global Const $CELLULAR_ONE_MMS 						= "n@mms.uscc.net"
Global Const $CELLULAR_ONE_PCS 						= "n@paging.cellone-sf.com"
Global Const $CELLULAR_ONE_EASTCOAST 				= "n@phone.cellone.net"
Global Const $CELLULAR_ONE_SOUTHWEST 				= "n@swmsg.com"
Global Const $CELLULAR_ONE_WEST 					= "n@mycellone.com"
Global Const $CELLULARSOUTH 						= "n@csouth1.com"
Global Const $CENTRALVERMONTCOMMUNICATIONS 			= "n@cvcpaging.com"
Global Const $CENTURYTEL 							= "n@messaging.centurytel.net"
Global Const $CHENNAI_RPG_CELLULAR_INDIA 			= "9841n@rpgmail.net"
Global Const $CHENNAI_SKYCELL_AIRTEL_INDIA 			= "919840n@airtelchennai.com"
Global Const $CHENNAIRPGCELLULAR_INDIA 				= "n@rpgmail.net"
Global Const $CHENNAISKYCELL_AIRTEL_INDIA 			= "n@airtelchennai.com"
Global Const $CINGULAR_WIRELESS 					= "n@mobile.mycingular.net"
Global Const $CINGULAR_WIRELESS2	 				= "n@cingularme.com"
Global Const $CINGULAR_WIRELESS_TDMA 				= "n@mmode.com"
Global Const $COMMUNICATIONSPECIALISTS 				= "n@pageme.comspeco.net"
Global Const $COMVIQGSM_SWEDEN 						= "467n@sms.comviq.se"
Global Const $COOKPAGING 							= "n@cookmail.com"
Global Const $CORRWIRELESSCOMMUNICATIONS 			= "n@corrwireless.net"
Global Const $DELHI_AIRTEL_INDIA 					= "919810n@airtelmail.com"
Global Const $DELHI_HUTCH_INDIA 					= "9811n@delhi.hutch.co.in"
Global Const $DELHI_ARITEL_INDIA 					= "n@airtelmail.com"
Global Const $DOBSON_CELLULARONE 					= "n@mobile.cellularone.com"
Global Const $DOBSON_COMMUNICATIONSCORPORATION 		= "n@mobile.dobson.net"
Global Const $DUTCHTONE 							= "n@sms.orange.nl"
Global Const $E_PLUS_GERMANY 						= "0n@smsmail.eplus.de"
Global Const $E_PLUS_GERMANY2 						= "0177n.sms@eplus.de"
Global Const $EDGE_WIRELESS 						= "n@sms.edgewireless.com"
Global Const $EMT_ESTONIA 							= "n@sms.emt.ee"
Global Const $EUROPOLITAN_SWEDEN 					= "4670n@europolitan.se"
Global Const $EUROTEL_CZECH_REPUBLIC 				= "ccaan@sms.eurotel.cz"
Global Const $FIDO_CANADA 							= "n@fido.ca"
Global Const $GALAXYCORPORATION 					= "n@sendabeep.net"
Global Const $GCSPAGING 							= "n@webpager.us"
Global Const $GLOBUL_BULGARIA 						= "n@sms.globul.bg"
Global Const $GOA_AIRTEL_INDIA 						= "919890n@airtelmail.com"
Global Const $GOA_BPL_MOBILE_INDIA 					= "9823n@bplmobile.com"
Global Const $GOA_IDEA_CELLULAR_INDIA 				= "9822n@ideacellular.net"
Global Const $GOLDENTELECOM_UKRAINE 				= "n@sms.goldentele.com"
Global Const $GRAYLINK 								= "n@epage.porta-phone.com"
Global Const $GSM 									= "n@cingularme.com"
Global Const $GTE 									= "n@gte.pagegate.net"
Global Const $GTE2 									= "n@messagealert.com"
Global Const $GUJARAT_AIRTEL_INDIA 					= "919898n@airtelmail.com"
Global Const $GUJARAT_CELFORCE_FASCEL_INDIA 		= "9825n@celforce.com"
Global Const $GUJARAT_IDEA_CELLULAR_INDIA 			= "9824n@ideacellular.net"
Global Const $HARYANA_AIRTEL_INDIA 					= "919896n@airtelmail.com"
Global Const $HARYANA_ESCOTEL_INDIA 				= "9812n@escotelmobile.com"
Global Const $HIMACHAL_PRADESH_AIRTEL_INDIA 		= "919816n@airtelmail.com"
Global Const $HOUSTONCELLULAR 						= "n@text.houstoncellular.net"
Global Const $IDEACELLULAR_INDIA 					= "n@ideacellular.net"
Global Const $INLANDCELLULARTELEPHONE 				= "n@inlandlink.com"
Global Const $JSMTELE_PAGE 							= "n@jsmtel.com"
Global Const $KARNATAKA_AIRTEL_INDIA 				= "919845n@airtelkk.com"
Global Const $KERALA_AIRTEL_INDIA 					= "919895n@airtelkerala.com"
Global Const $KERALA_BPL_MOBILE_INDIA 				= "9846n@bplmobile.com"
Global Const $KERALA_ESCOTEL_INDIA 					= "9847n@escotelmobile.com"
Global Const $KYIVSTAR_LATVIA 						= "n@smsmail.lmt.lv"
Global Const $KYIVSTAR_UKRAINE 						= "n@2sms.kyivstar.net"
Global Const $LAUTTAMUSCOMMUNICATION 				= "n@e-page.net"
Global Const $LMT_LATVIA 							= "9n@smsmail.lmt.lv"
Global Const $M1_SINGAPORE 							= "n@m1.com.sg"
Global Const $MADHYA_PRADESH_AIRTEL_INDIA 			= "919893n@airtelmail.com"
Global Const $MAHARASHTRA_AIRTEL_INDIA 				= "919890n@airtelmail.com"
Global Const $MAHARASHTRA_BPL_MOBILE_INDIA 			= "9823n@bplmobile.com"
Global Const $MAHARASHTRA_IDEA_CELLULAR_INDIA 		= "9822n@ideacellular.net"
Global Const $MANITOBATELECOMSYSTEMS_CANADA 		= "n@text.mtsmobility.com"
Global Const $MANNESMANNMOBILEFUNK_GERMANY 			= "n@d2-message.de"
Global Const $MAXMOBIL_AUSTRIA 						= "xn@max.mail.at"
Global Const $MCI 									= "n@pagemci.com"
Global Const $MCIPHONE 								= "n@mci.com"
Global Const $METEOR_IRELAND 						= "n@sms.mymeteor.ie"
Global Const $METEOR_MMS_IRELAND 					= "n@mms.mymeteor.ie"
Global Const $METRO_PCS 							= "n@mymetropcs.com"
Global Const $METRO_PCS2 								= "n@metropcs.sms.us"
Global Const $METROCALL 							= "n@page.metrocall.com"
Global Const $METROCALL2_WAY 						= "n@my2way.com"
Global Const $MICROCELL_CANADA 						= "n@fido.ca"
Global Const $MIDWESTWIRELESS 						= "n@clearlydigital.com"
Global Const $MIWORLD_SINGAPORE 					= "n@m1.com.sg"
Global Const $MOBILECOMPA 							= "n@page.mobilcom.net"
Global Const $MOBILEONE_SINGAPORE 					= "n@m1.com.sg"
Global Const $MOBILFONE 							= "n@page.mobilfone.com"
Global Const $MOBILITY_BERMUDA 						= "n@ml.bm"
Global Const $MOBISTAR_BELGIUM 						= "n@mobistar.be"
Global Const $MOBITEL_SLOVENIA 						= "n@linux.mobitel.si"
Global Const $MOBITEL_TANZANIA 						= "n@sms.co.tz"
Global Const $MOBTELSRBIJA_SERBIA 					= "n@mobtel.co.yu"
Global Const $MORRISWIRELESS	 					= "n@beepone.net"
Global Const $MOVISTAR_SPAIN 						= "n@correo.movistar.net"
Global Const $MTEL_BULGARIA 						= "n@sms.mtel.net"
Global Const $MTS_MOBILITY_CANADA 					= "n@text.mtsmobility.com"
Global Const $MTS_RUSSIA 							= "7n@sms.mts.ru"
Global Const $MUMBAI_AIRTEL_INDIA 					= "919892n@airtelmail.com"
Global Const $MUMBAI_BPL_MOBILE_INDIA 				= "9821n@bplmobile.com"
Global Const $NBTEL_CANADA 							= "n@wirefree.informe.ca"
Global Const $NETCOM_NORWAY 						= "n@sms.netcom.no"
Global Const $NEXTEL	 							= "n@messaging.nextel.com"
Global Const $NEXTEL_PAGE 							= "n@page.nextel.com"
Global Const $NEXTEL_BRAZIL 						= "n@nextel.com.br"
Global Const $NPIWIRELESS 							= "n@npiwireless.com"
Global Const $NTELOS 								= "n@pcs.ntelos.com"
Global Const $NTT_DOCOMO_JAPAN 						= "n@docomo.ne.jp"
Global Const $O2 									= "n@mobile.celloneusa.com"
Global Const $O2_GERMANY 							= "0n@o2online.de"
Global Const $O2_UK 								= "44n@mobile.celloneusa.com"
Global Const $O2_UK2 								= "44n@mmail.co.uk"
Global Const $OGVODAFONE_ICELAND 					= "n@sms.is"
Global Const $OMNIPOINT 							= "n@omnipoint.com"
Global Const $OMNIPOINT2 							= "n@omnipointpcs.com"
Global Const $ONECONNECT_AUSTRIA 					= "n@onemail.at"
Global Const $ONLINEBEEP 							= "n@onlinebeep.net"
Global Const $OPTIMUS_PORTUGAL 						= "93n@sms.optimus.pt"
Global Const $OPTUSMOBILE_AUSTRALIA 				= "n@optusmobile.com.au"
Global Const $OR_KOLKATA_AIRTEL_INDIA 				= "919831n@airtelkol.com"
Global Const $ORANGE 								= "n@mobile.celloneusa.com"
Global Const $ORANGE_INDIA 							= "n@orangemail.co.in"
Global Const $ORANGE_NETHERLANDS 					= "0n@sms.orange.nl"
Global Const $ORANGE_UK 							= "0n@orange.net"
Global Const $ORANGE_UK2 							= "0973n@omail.net"
Global Const $OSKAR_CZECH_REPUBLIC 					= "n@mujoskar.cz"
Global Const $PACIFICBELL	 						= "n@pacbellpcs.net"
Global Const $PAGEMART 								= "n@pagemart.net"
Global Const $PAGEMART_CANADA 						= "n@pmcl.net"
Global Const $PAGENET_CANADA 						= "n@pagegate.pagenet.ca"
Global Const $PAGEONENORTHWEST 						= "n@page1nw.com"
Global Const $PCSONE 								= "n@pcsone.net"
Global Const $PGSM_HUNGARY 							= "3620n@sms.pgsm.hu"
Global Const $PIONEER_ENIDCELLULAR 					= "n@msg.pioneerenidcellular.com"
Global Const $PLUSGSM_POLAND 						= "4860n@text.plusgsm.pl"
Global Const $PONDICHERRY_BPL_MOBILE_INDIA 			= "9843n@bplmobile.com"
Global Const $PRESIDENTS_CHOICE_CANADA 				= "n@mobiletxt.ca"
Global Const $PRICECOMMUNICATIONS 					= "n@mobilecell1se.com"
Global Const $PRIMTEL_RUSSIA 						= "n@sms.primtel.ru"
Global Const $PROPAGE 								= "n@page.propage.net"
Global Const $PT_LUXEMBOURG 						= "n@sms.luxgsm.lu"
Global Const $PUBLICSERVICECELLULAR 				= "n@sms.pscel.com"
Global Const $PUNJAB_AIRTEL_INDIA 					= "919815n@airtelmail.com"
Global Const $QUALCOMM 								= "name@pager.qualcomm.com"
Global Const $QWEST 								= "n@qwestmp.com"
Global Const $RAMPAGE 								= "n@ram-page.com"
Global Const $ROGERS_WIRELESS 						= "n@pcs.rogers.com"
Global Const $SAFARICOM 							= "n@safaricomsms.com"
Global Const $SASKTEL_MOBILITY_CANADA 				= "n@pcs.sasktelmobility.com"
Global Const $SATELINDO 							= "n@satelindogsm.com"
Global Const $SCS_900_RUSSIA 						= "n@scs-900.ru"
Global Const $SFR_FRANCE 							= "n@sfr.fr"
Global Const $SIMINN_ICELAND 						= "n@box.is"
Global Const $SIMOBIL_SLOVENIA 						= "n@simobil.net"
Global Const $SIMPLEFREEDOM 						= "n@text.simplefreedom.net"
Global Const $SKYTELPAGERS 							= "n@email.skytel.com"
Global Const $SKYTELPAGERS2 						= "n@skytel.com"
Global Const $SMARTTELECOM 							= "n@mysmart.mymobile.ph"
Global Const $SONOFON_DENMARK 						= "n@note.sonofon.dk"
Global Const $SOUTHERNLINC 							= "n@page.southernlinc.com"
Global Const $SOUTHWESTERNBELL 						= "n@email.swbw.com"
Global Const $SPRINT 								= "n@sprintpaging.com"
Global Const $SPRINT_PCS 							= "n@messaging.sprintpcs.com"
Global Const $SPRINTPCS 							= "n@messaging.sprintpcs.com"
Global Const $STPAGING 								= "n@page.stpaging.com"
Global Const $SUNCOM 								= "n@tms.suncom.com"
Global Const $SUNRISEMOBILE_SWITZERLAND 			= "n@freesurf.ch"
Global Const $SUNRISEMOBILE_SWITZERLAND2 			= "n@mysunrise.ch"
Global Const $SUREWESTCOMMUNICATIONS 				= "n@mobile.surewest.com"
Global Const $SWISSCOM_SWITZERLAND 					= "n@bluewin.ch"
Global Const $T_MOBILE 								= "n@tmomail.net"
Global Const $T_MOBILE_AUSTRIA 						= "43676n@sms.t-mobile.at"
Global Const $T_MOBILE_GERMANY 						= "0n@t-d1-sms.de"
Global Const $T_MOBILE_NETHERLANDS 					= "31n@gin.nl"
Global Const $T_MOBILE_OPTUS_ZOO_AUSTRALIA 			= "0n@optusmobile.com.au"
Global Const $T_MOBILE_UK 							= "0n@t-mobile.uk.net"
Global Const $TAMIL_NADU_AIRCEL_INDIA 				= "9842n@airsms.com"
Global Const $TAMIL_NADU_AIRTEL_INDIA 				= "919894n@airtelmail.com"
Global Const $TAMIL_NADU_BPL_MOBILE_INDIA 			= "919843n@bplmobile.com"
Global Const $TELCEL_PORTUGAL						= "91n@sms.telecel.pt"
Global Const $TELE2_LATVIA 							= "n@sms.tele2.lv"
Global Const $TELE2_SWEDEN 							= "0n@sms.tele2.se"
Global Const $TELECOMITALIAMOBILE_ITALY 			= "33n@posta.tim.it"
Global Const $TELEDANMARKMOBIL_DENMARK 				= "n@sms.tdk.dk"
Global Const $TELEFLIP 								= "n@teleflip.com"
Global Const $TELEFONICA_MOVISTAR_SPAIN 			= "0n@movistar.net"
Global Const $TELENOR_NORWAY 						= "n@mobilpost.no"
Global Const $TELETOUCH 							= "n@pageme.teletouch.com"
Global Const $TELIADENMARK_DENMARK 					= "n@gsm1800.telia.dk"
Global Const $TELUS 								= "n@msg.telus.com"
Global Const $TELUS_CANADA 							= "n@msg.telus.com"
Global Const $THEINDIANAPAGINGCO 					= "n@pager.tdspager.com"
Global Const $TIM 									= "n@timnet.com"
Global Const $TIM_ITALY 							= "0n@timnet.com"
Global Const $TMN_PORTUGAL 							= "96n@mail.tmn.pt"
Global Const $TRITON 								= "n@tms.suncom.com"
Global Const $TSRWIRELESS 							= "n@alphame.com"
Global Const $TSRWIRELESS2 							= "n@beep.com"
Global Const $UMC_UKRAINE 							= "n@sms.umc.com.ua"
Global Const $UNICEL 								= "n@utext.com"
Global Const $URALTEL_RUSSIA 						= "n@sms.uraltel.ru"
Global Const $US_CELLULAR							= "n@email.uscc.net"
Global Const $USAMOBILITY 							= "n@mobilecomm.net"
Global Const $USCELLULAR 							= "n@email.uscc.net"
Global Const $UTTAR_PRADESH_WEST_ESCOTEL_INDIA 		= "9837n@escotelmobile.com"
Global Const $VERIZON 								= "n@vtext.com"
Global Const $VERIZONPAGERS 						= "n@myairmail.com"
Global Const $VERIZONPCS 							= "n@myvzw.com"
Global Const $VESSOTEL_RUSSIA 						= "n@pager.irkutsk.ru"
Global Const $VIRGIN_MOBILE 						= "n@vmobl.com"
Global Const $VIRGIN_MOBILE_CANADA 					= "n@vmobile.ca"
Global Const $VIRGIN_MOBILE_UK 						= "0n@vxtras.com"
Global Const $VODACOM_SINGAPORE 					= "n@voda.co.za"
Global Const $VODAFONE_CHUUGOKU_WESTERN_JAPAN 		= "n@n.vodafone.ne.jp"
Global Const $VODAFONE_GERMANY 						= "0n@vodafone-sms.de"
Global Const $VODAFONE_HOKKAIDO_JAPAN 				= "n@d.vodafone.ne.jp"
Global Const $VODAFONE_HOKURIKO_CENTRAL_NORTH_JAPAN = "n@r.vodafone.ne.jp"
Global Const $VODAFONE_ITALY 						= "3n@sms.vodafone.it"
Global Const $VODAFONE_KANSAI_WEST 					= "n@k.vodafone.ne.jp"
Global Const $VODAFONE_KANTO_KOUSHIN_EAST 			= "n@t.vodafone.ne.jp"
Global Const $VODAFONE_KYUUSHU_OKINAWA_JAPAN 		= "n@q.vodafone.ne.jp"
Global Const $VODAFONE_SHIKOKU_JAPAN 				= "n@s.vodafone.ne.jp"
Global Const $VODAFONE_SPAIN 						= "0n@vodafone.es"
Global Const $VODAFONE_TOUHOKU_NIIGATA_NORTH_JAPAN 	= "n@h.vodafone.ne.jp"
Global Const $VODAFONE_TOUKAI_CENTRAL_JAPAN		 	= "n@c.vodafone.ne.jp"
Global Const $VODAFONE_UK 							= "0n@vodafone.net"
Global Const $VODAFONEJAPAN_JAPAN	 				= "n@c.vodafone.ne.jp"
Global Const $VODAFONEJAPAN_JAPAN2 					= "n@h.vodafone.ne.jp"
Global Const $VODAFONEJAPAN_JAPAN3 					= "n@t.vodafone.ne.jp"
Global Const $VODAFONEOMNITEL_ITALY 				= "34n@vizzavi.it"
Global Const $VODAFONEUK_UK 						= "n@vodafone.net"
Global Const $WEBLINKWIRELESS 						= "n@pagemart.net"
Global Const $WESTCENTRALWIRELESS 					= "n@sms.wcc.net"
Global Const $WESTERNWIRELESS 						= "n@cellularonewest.com"
Global Const $WILLCOM_DI_JAPAN 						= "n@di.pdx.ne.jp"
Global Const $WILLCOM_DJ_JAPAN 						= "n@dj.pdx.ne.jp"
Global Const $WILLCOM_DK_JAPAN 						= "n@dk.pdx.ne.jp"
Global Const $WILLCOM_JAPAN 						= "n@pdx.ne.jp"
Global Const $WYNDTELL 								= "n@wyndtell.com"

; #FUNCTION# ;===============================================================================
;
; Name...........: 	_SMS_Start
; Description ...: 	Returns SMS Object (an Array of information about the SMTP Server)
; Syntax.........: 	_SMS_Start($sSMTP,$sEmail,$sUsername,$sPassword,$iPort = 25,$iSSL = 0)
; Parameters ....: 	$sSMTP - Address of SMTP server to be used to send message. ex: smtp.gmail.com
;                  	$sEmail - Email address to send messages from. ex: johnsmith@gmail.com
;                  	$sUsername - Username of email address (often the same as the address itself).
;				   	$sPassword - Password for the email account.
;					$iPort - Port that the SMTP server uses. Default port is 25.
;					$iSSL - Determines if ssl encryption is to be used when connecting to the smtp server. (0 for no, 1 for yes)
; Return values .: 	Success - Returns an Array: Returns an array : $array[0] contains SMTP server address, $array[1] contains email address, $array[2] contains username, $array[3] contains password, $array[4] contains port, $array[5] contains ssl.  This array of info is needed when sending SMS message.
;                  	Failure - Returns Error Description
;                  	|0 - No error.
;                  	|1 - Invalid SMTP Address
;                  	|2 - Invalid Email Address
;                  	|3 - Invalid Port
;					|4 - Invalid SSL flag
; Author ........: Disabled Monkey
; Modified.......:
; Remarks .......:
; Related .......: _SMS_Send
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _SMS_Start($sSMTP,$sEmail,$sUsername,$sPassword,$iPort = 25,$iSSL = 0)
	Local $SMS[6]
	If StringRegExp($sSMTP,"(.*)\.(.*)") Then
		$SMS[0] = $sSMTP
	Else
		SetError(1)
		Return 0
	EndIf
	If StringRegExp($sEmail,"(.*)\@(.*)\.(.*)") Then
		$SMS[1] = $sEmail
	Else
		SetError(2)
		Return 0
	EndIf
	$SMS[2] = $sUsername
	$SMS[3] = $sPassword
	If IsNumber($iPort) Then
		$SMS[4] = $iPort
	Else
		SetError(3)
		Return 0
	EndIf
	If $iSSL = 1 or $iSSL = 0 Then
		$SMS[5] = $iSSL
	Else
		SetError(4)
		Return 0
	EndIf
	Return $SMS
EndFunc ;==>_SMS_Start

; #FUNCTION# ;===============================================================================
;
; Name...........: 	_SMS_Send
; Description ...: 	Sends a SMS message
; Syntax.........: 	_SMS_Send($aSMS,$iNumber,$sService,$sMessage,$sFromName = "")
; Parameters ....: 	$aSMS - SMS Array Returned from _SMS_Start.
;                  	$iNumber - Number of the phone you wish to message.
;                  	$sService - Const of the Service Provider for the phone you are sending a message.
;				    $sMessage - Message you are sending.
;					$sFromName - From name that may or may not show up in the text you are sending (All depends on the service provider).
; Return values .: 	Success - Returns True
;                  	Failure - Returns Error Array and Sets @Error = 1:
;							|$errorArray[0] - Error Number
;							|$errorArray[1] - Error Description
; Author ........: Disabled Monkey
; Modified.......:
; Remarks .......:
; Related .......: _SMS_Start
; Link ..........;
; Example .......; Yes
;
; ;==========================================================================================
Func _SMS_Send($aSMS,$iNumber,$sService,$sMessage,$sFromName = "")
	$rc = _INetSmtpMailCom($aSMS[0], $sFromName, $aSMS[1], _GetAddress($iNumber,$sService), $sMessage, $aSMS[2], $aSMS[3], $aSMS[4], $aSMS[5])
	Return $rc
EndFunc ;==>_SMS_Send

; ;==========================================================================================
; ;=====================================Private Functions====================================
; ;==========================================================================================
Func _GetAddress($NUMBER,$SERVICE)
	Return StringReplace($SERVICE,"n@",$NUMBER & "@")
EndFunc ;==>_GetAddress

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
    If $s_Username <> "" Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
    EndIf
    If $ssl Then
        $objEmail.Configuration.Fields.Item ("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
    EndIf
	$objEmail.Configuration.Fields.Update
	$objEmail.Fields.Item ("urn:schemas:mailheader:Importance") = "Low"
    $objEmail.Fields.Update
    $objEmail.Send
    If @error Then
        SetError(1)
        Return $o_smsMyRet
    EndIf
    $objEmail=""
	Return True
EndFunc ;==>_INetSmtpMailCom

Func _MyErrFunc()
    $HexNumber = Hex($o_smsMyError.number, 8)
    $o_smsMyRet[0] = $HexNumber
    $o_smsMyRet[1] = StringStripWS($o_smsMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $o_smsMyError.scriptline & "   Description:" & $o_smsMyRet[1] & @LF)
    SetError(1)
    Return
EndFunc ;==>MyErrFunc
