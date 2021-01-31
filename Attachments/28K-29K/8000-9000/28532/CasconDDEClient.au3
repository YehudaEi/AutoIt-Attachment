#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.0.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>
#include "DDEML.au3"
#include "DDEMLClient.au3"


Global $hConvSrv = 0

			$res = _DDEMLClient_Execute('CASCON','SYSTEM', 'SELECT_UUT 4801A-001_2', $CF_TEXT)



			$res = _DDEMLClient_RequestString('CASCON','SYSTEM', 'STATE', $CF_TEXT)
			MsgBox(0, "state",$res)

            $res = _DDEMLClient_RequestString('CASCON','UUT', 'UUT_NAME', $CF_TEXT)
			MsgBox(0, "UUT_NAME",$res)
