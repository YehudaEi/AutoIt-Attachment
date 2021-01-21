;''''''''''''''''''''''''''
; Monitor EDID Information'
;''''''''''''''''''''''''''
;*****************************************************************************************
;17 June 2004
;coded by Michael Baird
;
;11 November 2005
;ported to AutoIT 3.1.1.87 by Trystian Sky
;
;and released under the terms of GNU open source license agreement
;(that is of course if you CAN release code that uses WMI under GNU)
;
;Please give me credit if you use my code

;this code is based on the EEDID spec found at http://www.vesa.org
;and by my hacking around in the windows registry
;the code was tested on WINXP,WIN2K and WIN2K3
;it should work on WINME and WIN98SE
;It should work with multiple monitors, but that hasn't been tested either.
;*****************************************************************************************
;
;*****************************************************************************************
;It should be noted that this is not 100% reliable
;I have witnessed occasions where for one reason or another windows
;can't or doesn't read the EDID info at boot (example would be someone
;booting with the monitor turned off) and so windows changes the active
;monitor to "Default_Monitor"
;Another reason for reliability problems is that there is no
;requirement in the EDID spec that a manufacture include the
;serial number in the EDID data AND only EDIDv1.2 and beyond
;have a requirement that the EDID contain a descriptive
;model name
;That being said, here goes....
;*****************************************************************************************
;
;*****************************************************************************************
;Monitors are stored in HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\
;
;Unfortunately, not only monitors are stored here Video Chipsets and maybe some other stuff
;is also here.
;
;Monitors in "HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\" are organized like this:
; HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\<VESA_Monitor_ID>\<PNP_ID>\
;Since not only monitors will be found under DISPLAY sub key you need to find out which
;devices are monitors.
;This can be deterimined by looking at the value "HardwareID" located
;at HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\<VESA_Monitor_ID\<PNP_ID>\
;if the device is a monitor then the "HardwareID" value will contain the data "Monitor\<VESA_Monitor_ID>"
;
;The next difficulty is that all monitors are stored here not just the one curently plugged in.
;So, if you ever switched monitors the old one(s) will still be in the registry.
;You can tell which monitor(s) are active because they will have a sub-key named "Control"
;*****************************************************************************************
;
$strComputer="."
dim $strarrRawEDID,$arBaseKey,$arBaseKey2,$arBaseKey3,$arSubKeys,$arSubKeys2,$arSubKeys3,$sKey,$sKey2,$sKey3,$strSerFind,$arrintEDID,$sValue
$intMonitorCount=0
Const $HKLM = 0x80000002 ;HKEY_LOCAL_MACHINE
;get a handle to the WMI registry object
$oRegistry = ObjGet("winmgmts:{impersonationLevel=impersonate}!\\" & $strComputer & "/root/default:StdRegProv")
$sBaseKey = "SYSTEM\CurrentControlSet\Enum\DISPLAY\"
;enumerate all the keys HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\
$iRC = $oRegistry.EnumKey($HKLM, $sBaseKey, $arSubKeys)
For $sKey In $arSubKeys
	;we are now in the registry at the level of:
	;HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\<VESA_Monitor_ID\
	;we need to dive in one more level and check the data of the "HardwareID" value
	$sBaseKey2 = $sBaseKey & $sKey & "\"
	$iRC2 = $oRegistry.EnumKey($HKLM, $sBaseKey2, $arSubKeys2)
	For $sKey2 In $arSubKeys2
		;now we are at the level of:
		;HKLM\SYSTEM\CurrentControlSet\Enum\DISPLAY\<VESA_Monitor_ID\<PNP_ID>\
		;so we can check the "HardwareID" value

			$oRegistry.GetMultiStringValue($HKLM, $sBaseKey2 & $sKey2 & "\", "HardwareID", $sValue) ; (*** TRYSTIANSKY: Not sure how AUTOIT can pass the variable from GetMultiStringValue METHOD to $sValue ***)

			for $tmpctr=0 to ubound($sValue)
				if StringLower(StringLeft($svalue[$tmpctr],8))="monitor\" then
					;if it is a monitor we will check for the existance of a control subkey
					;that way we know it is an active monitor
					$sBaseKey3 = $sBaseKey2 & $sKey2 & "\"
					$iRC3 = $oRegistry.EnumKey($HKLM, $sBaseKey3, $arSubKeys3)
					For $sKey3 In $arSubKeys3
						if $skey3="Control" then
							;if the Control sub-key exists then we should read the edid info
							$oRegistry.GetBinaryValue($HKLM, $sbasekey3 & "Device Parameters\", "EDID", $arrintEDID)
							if IsArray($arrintedid) = 0 then ;and if we don't find it... (*** TRYSTIANSKY: converted from VB: vartype(arrintedid) <> 8204. Not sure how AUTOIT can find an 'Array of Variants (vartype: 8204)' ***)
								$strRawEDID="EDID Not Available" ;store an "unavailable message
							else
								for $bytevalue in $arrintedid ;otherwise conver the byte array from the registry into a string (for easier processing later)
									$strRawEDID=$strRawEDID & chr($bytevalue)
								next
							endif
							;now take the string and store it in an array, that way we can support multiple monitors
							redim $strarrRawEDID[$intMonitorCount]
							$strarrRawEDID($intMonitorCount)=$strRawEDID
							$intMonitorCount=$intMonitorCount+1
						endif
					next
				endif
		next
		
	Next
Next
;*****************************************************************************************
;now the EDID info for each active monitor is stored in an array of strings called strarrRawEDID
;so we can process it to get the good stuff out of it which we will store in a 5 dimensional array
;called arrMonitorInfo, the dimensions are as follows:
;0=VESA Mfg ID, 1=VESA Device ID, 2=MFG Date (M/YYYY),3=Serial Num (If available),4=Model Descriptor
;5=EDID Version
;*****************************************************************************************
dim $arrMonitorInfo
redim $arrMonitorInfo[$intMonitorCount-1][5]
dim $location[3]
for $tmpctr=0 to $intMonitorCount-1
	if $strarrRawEDID[$tmpctr] <> "EDID Not Available" then
		;*********************************************************************
		;first get the model and serial numbers from the vesa descriptor
		;blocks in the edid. the model number is required to be present
		;according to the spec. (v1.2 and beyond)but serial number is not
		;required. There are 4 descriptor blocks in edid at offset locations
		;0x36 0x48 0x5a and 0x6c each block is 18 bytes long
		;*********************************************************************
		$location[0]=StringMid($strarrRawEDID[$tmpctr],0x36+1,18)
		$location[1]=StringMid($strarrRawEDID[$tmpctr],0x48+1,18)
		$location[2]=StringMid($strarrRawEDID[$tmpctr],0x5a+1,18)
		$location[3]=StringMid($strarrRawEDID[$tmpctr],0x6c+1,18)
			
		;you can tell if the location contains a serial number if it starts with 0x00 00 00 ff
		$strSerFind=chr(0x00) & chr(0x00) & chr(0x00) & chr(0xff)
		;or a model description if it starts with 0x00 00 00 fc
		$strMdlFind=chr(0x00) & chr(0x00) & chr(0x00) & chr(0xfc)
			
		$intSerFoundAt=-1
		$intMdlFoundAt=-1
		for $findit = 0 to 3
			if StringInStr($location[$findit],$strSerFind)>0 then
				$intSerFoundAt=$findit
			endif
			if StringinStr($location[$findit],$strMdlFind)>0 then
				$intMdlFoundAt=$findit
			endif
		next
		
		;if a location containing a serial number block was found then store it
		if $intSerFoundAt<>-1 then
			$tmp=StringRight($location[$intSerFoundAt],14)
		endif
		if StringInStr($tmp,chr(0x0a))>0 then
			$tmpser=StringStripWS(StringLeft($tmp,StringinStr($tmp,chr(0x0a))-1),3)
		else
			$tmpser=StringStripWS($tmp,3)
		endif
		;although it is not part of the edid spec it seems as though the
		;serial number will frequently be preceeded by 0x00, this
		;compensates for that
		if StringLeft($tmpser,1)=chr(0) then
			$tmpser=StringRight($tmpser,StringLen($tmpser)-1)
		else
			$tmpser="Serial Number Not Found in EDID data"
		endif
		
		;if a location containing a model number block was found then store it
		if $intMdlFoundAt<>-1 then
			$tmp=StringRight($location[$intMdlFoundAt],14)
		endif
		if StringInStr($tmp,chr(0x0a))>0 then
			$tmpmdl=StringStripWS(StringLeft($tmp,StringInStr($tmp,chr(0x0a))-1),3)
		else
			$tmpmdl=StringStripWS($tmp,3)
		endif
		;although it is not part of the edid spec it seems as though the
		;serial number will frequently be preceeded by 0x00, this
		;compensates for that
		if StringLeft($tmpmdl,1)=chr(0) then
			$tmpmdl=StringRight($tmpmdl,StringLen($tmpmdl)-1)
		else
			$tmpmdl="Model Descriptor Not Found in EDID data"
		endif
		
		;**************************************************************
		;next get the mfg date
		;**************************************************************
		;the week of manufacture is stored at EDID offset 0x10
		$tmpmfgweek=asc(StringMid($strarrRawEDID[$tmpctr],0x10+1,1))
		
		;the year of manufacture is stored at EDID offset 0x11
		;and is the current year -1990
		$tmpmfgyear=(asc(StringMid($strarrRawEDID[$tmpctr],0x11+1,1)))+1990
		
		;store it in month/year format
		$tmpmdt="Week " & $tmpmfgweek & " / " & $tmpmfgyear
		
		;**************************************************************
		;next get the edid version
		;**************************************************************
		;the version is at EDID offset 0x12
		$tmpEDIDMajorVer=asc(StringMid($strarrRawEDID[$tmpctr],0x12+1,1))
		
		;the revision level is at EDID offset 0x13
		$tmpEDIDRev=asc(StringMid($strarrRawEDID[$tmpctr],0x13+1,1))
		
		;store it in month/year format
		$tmpver=chr(48+$tmpEDIDMajorVer) & "." & chr(48+$tmpEDIDRev)
		
		;**************************************************************
		;next get the mfg id
		;**************************************************************
		;the mfg id is 2 bytes starting at EDID offset 0x08
		;the id is three characters long. using 5 bits to represent
		;each character. the bits are used so that 1=A 2=B etc..
		;
		;get the data
		$tmpEDIDMfg=StringMid($strarrRawEDID[$tmpctr],0x08+1,2)
		$Char1=0
		$Char2=0
		$Char3=0
		$Byte1=asc(Stringleft($tmpEDIDMfg,1)) ;get the first half of the string
		$Byte2=asc(Stringright($tmpEDIDMfg,1)) ;get the first half of the string
		;now shift the bits
		;shift the 64 bit to the 16 bit
		if BitAND($Byte1, 64) > 0 then
			$Char1=$Char1+16
		endif
		;shift the 32 bit to the 8 bit
		if BitAnd($Byte1, 32) > 0 then
			$Char1=$Char1+8
		endif
		;etc....
		if BitAnd($Byte1, 16) > 0 then
			$Char1=$Char1+4
		endif
		if BitAnd($Byte1, 8) > 0 then
			$Char1=$Char1+2
		endif
		if BitAnd($Byte1, 4) > 0 then
			$Char1=$Char1+1
		endif
		
		;the 2nd character uses the 2 bit and the 1 bit of the 1st byte
		if BitAnd($Byte1, 2) > 0 then
			$Char2=$Char2+16
		endif
		if BitAnd($Byte1, 1) > 0 then
			$Char2=$Char2+8
		endif
		;and the 128,64 and 32 bits of the 2nd byte
		if BitAnd($Byte2, 128) > 0 then
			$Char2=$Char2+4
		endif
		if BitAnd($Byte2, 64) > 0 then
			$Char2=$Char2+2
		endif
		if BitAnd($Byte2, 32) > 0 then
			$Char2=$Char2+1
		endif
		
		;the bits for the 3rd character don't need shifting
		;we can use them as they are
		$Char3=$Char3+BitAnd($Byte2, 16)
		$Char3=$Char3+BitAnd($Byte2, 8)
		$Char3=$Char3+BitAnd($Byte2, 4)
		$Char3=$Char3+BitAnd($Byte2, 2)
		$Char3=$Char3+BitAnd($Byte2, 1)
		$tmpmfg=chr($Char1+64) & chr($Char2+64) & chr($Char3+64)
		
		;**************************************************************
		;next get the device id
		;**************************************************************
		;the device id is 2bytes starting at EDID offset 0x0a
		;the bytes are in reverse order.
		;this code is not text. it is just a 2 byte code assigned
		;by the manufacturer. they should be unique to a model
		$tmpEDIDDev1=hex(asc(Stringmid($strarrRawEDID[$tmpctr],0x0a+1,1)))
		$tmpEDIDDev2=hex(asc(Stringmid($strarrRawEDID[$tmpctr],0x0b+1,1)))
		if Stringlen($tmpEDIDDev1)=1 then
			$tmpEDIDDev1="0" & $tmpEDIDDev1
		endif
		if Stringlen($tmpEDIDDev2)=1 then
			$tmpEDIDDev2="0" & $tmpEDIDDev2
		endif
		$tmpdev=$tmpEDIDDev2 & $tmpEDIDDev1
		
		;**************************************************************
		;finally store all the values into the array
		;**************************************************************
		$arrMonitorInfo($tmpctr,0)=$tmpmfg
		$arrMonitorInfo($tmpctr,1)=$tmpdev
		$arrMonitorInfo($tmpctr,2)=$tmpmdt
		$arrMonitorInfo($tmpctr,3)=$tmpser
		$arrMonitorInfo($tmpctr,4)=$tmpmdl
		$arrMonitorInfo($tmpctr,5)=$tmpver
	endif
next
;For now just a simple screen print will suffice for output.
;But you could take this output and write it to a database or a file
;and in that way use it for asset management.
for $tmpctr=0 to $intMonitorCount-1
	ConsoleWrite("Monitor " & chr($tmpctr+65) & ")" & @CRLF)
	ConsoleWrite(".........." & "VESA Manufacturer ID= " & $arrMonitorInfo($tmpctr,0) & @CRLF)
	ConsoleWrite(".........." & "Device ID= " & $arrMonitorInfo($tmpctr,1) & @CRLF)
	ConsoleWrite(".........." & "Manufacture Date= " & $arrMonitorInfo($tmpctr,2) & @CRLF)
	ConsoleWrite(".........." & "Serial Number= " & $arrMonitorInfo($tmpctr,3) & @CRLF)
	ConsoleWrite(".........." & "Model Name= " & $arrMonitorInfo($tmpctr,4) & @CRLF)
	ConsoleWrite(".........." & "EDID Version= " & $arrMonitorInfo($tmpctr,5) & @CRLF)
next
