#include-once

#include "MacroConstants.au3"

; #INDEX# =======================================================================================================================
; Title .........: Macro
; AutoIt Version : 3.3.2.0
; Language ......: English
; Description ...: Functions that assist with managing Macros
; Author(s) .....: Matthew McMullan (NerdFencer)
; Dll(s) ........: 
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $Macro_SysNone = 0 ; Pre-Win2k
Global Const $Macro_Sys2000 = 1 ; Win2k line (Home Editions+server2000)
Global Const $Macro_Sys2003 = 2 ; WinXP line (Home Editions+server2003)
Global Const $Macro_Sys2008 = 3 ; WinVista line (Home Editions+server2008)
Global Const $Macro_Sys2010 = 4 ; Win7 line (Home Editions+server2008R2)
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_Macro_GetLang
;_Macro_GetMonth
;_Macro_GetPlatformCompatabillity
;_Macro_GetWDay
;_Macro_GetMonth
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _Macro_GetMonth
; Description ...: Returns a string for the month
; Syntax.........: _Macro_GetWDay($iMonth = @MON)
; Parameters ....: $iMonth      - The day of the week (defaults to @MON)
; Return values .: Success      - A string for the month
;                  Failure      - Error
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: 
; ===============================================================================================================================
Func _Macro_GetMonth($iMonth = @MON)
	If $iMonth<1 Or $iMonth>12 Then
		Return "Error"
	EndIf
	Return $MACRO_MON[$iMonth]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Macro_GetPlatformCompatabillity
; Description ...: Returns a value describing the OS platform that is being run
; Syntax.........: _Macro_GetPlatformCompatabillity()
; Parameters ....: None.
; Return values .: Success      - $Macro_Sys2010, $Macro_Sys2008, $Macro_Sys2003, $Macro_Sys2000, or $Macro_SysNone
;                  Failure      - Error
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: 
; ===============================================================================================================================
Func _Macro_GetPlatformCompatabillity()
	If @OSVersion==$MACRO_OS_SERVER_2008_R2 Or @OSVersion==$MACRO_OS_7 Then
		Return $Macro_Sys2010
	ElseIf @OSVersion==$MACRO_OS_SERVER_2008 Or @OSVersion==$MACRO_OS_VISTA Then
		Return $Macro_Sys2008
	ElseIf @OSBuild>=$MACRO_OSBUILD_XP And @OSBuild<$MACRO_OSBUILD_VISTA Then
		Return $Macro_Sys2003
	ElseIf @OSBuild>=$MACRO_OSBUILD_2000 Then
		Return $Macro_Sys2000
	EndIf
	Return $Macro_SysNone
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Macro_GetWDay
; Description ...: Returns a string for the day of the week
; Syntax.........: _Macro_GetWDay($iWDay = @WDAY)
; Parameters ....: $iWDay       - The day of the week (defaults to @WDAY)
; Return values .: Success      - A string for the day of the week
;                  Failure      - Error
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: 
; ===============================================================================================================================
Func _Macro_GetWDay($iWDay = @WDAY)
	If $iWDay<1 Or $iWDay>7 Then
		Return "Error"
	EndIf
	Return $MACRO_WDAY[$iWDay]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Macro_GetLang
; Description ...: Retrives a string that tells what language is being used
; Syntax.........: _Macro_GetLang($iLang = @OSLang)
; Parameters ....: $iLang       - The language to use. Defaults to @OSLang.
; Return values .: Success      - A string that tells what language is being used
;                  Failure      - Unknown or Error
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: 
; ===============================================================================================================================
Func _Macro_GetLang($iLang = @OSLang)
	If StringLen($iLang)<4 Then
		Return "Error"
	EndIf
	Switch $iLang
		Case $MACRO_LANG_Afrikaans
			Return "Afrikaans"
		Case $MACRO_LANG_Albanian
			Return "Albanian"
		Case $MACRO_LANG_Arabic_Saudi_Arabia
			Return "Arabic Saudi Arabia"
		Case $MACRO_LANG_Arabic_Iraq
			Return "Arabic Iraq"
		Case $MACRO_LANG_Arabic_Egypt
			Return "Arabic Egypt"
		Case $MACRO_LANG_Arabic_Libya
			Return "Arabic Libya"
		Case $MACRO_LANG_Arabic_Algeria
			Return "Arabic Algeria"
		Case $MACRO_LANG_Arabic_Morocco
			Return "Arabic Morocco"
		Case $MACRO_LANG_Arabic_Tunisia
			Return "Arabic Tunisia"
		Case $MACRO_LANG_Arabic_Oman
			Return "Arabic Oman"
		Case $MACRO_LANG_Arabic_Yemen
			Return "Arabic Yemen"
		Case $MACRO_LANG_Arabic_Syria
			Return "Arabic Syria"
		Case $MACRO_LANG_Arabic_Jordan
			Return "Arabic Jordan"
		Case $MACRO_LANG_Arabic_Lebanon
			Return "Arabic Lebanon"
		Case $MACRO_LANG_Arabic_Kuwait
			Return "Arabic Kuwait"
		Case $MACRO_LANG_Arabic_UAE
			Return "Arabic UAE"
		Case $MACRO_LANG_Arabic_Bahrain
			Return "Arabic Bahrain"
		Case $MACRO_LANG_Arabic_Qatar
			Return "Arabic Qatar"
		Case $MACRO_LANG_Armenian
			Return "Armenian"
		Case $MACRO_LANG_Azeri_Latin
			Return "Azeri Latin"
		Case $MACRO_LANG_Azeri_Cyrillic
			Return "Azeri Cyrillic"
		Case $MACRO_LANG_Basque
			Return "Basque"
		Case $MACRO_LANG_Belarusian
			Return "Belarusian"
		Case $MACRO_LANG_Bengali_India
			Return "Bengali India"
		Case $MACRO_LANG_Bosnian_Latin
			Return "Bosnian Latin"
		Case $MACRO_LANG_Bulgarian
			Return "Bulgarian"
		Case $MACRO_LANG_Catalan
			Return "Catalan"
		Case $MACRO_LANG_Chinese_Taiwan
			Return "Chinese Taiwan"
		Case $MACRO_LANG_Chinese_PRC
			Return "Chinese PRC"
		Case $MACRO_LANG_Chinese_Hong_Kong
			Return "Chinese Hong Kong"
		Case $MACRO_LANG_Chinese_Singapore
			Return "Chinese Singapore"
		Case $MACRO_LANG_Chinese_Macau
			Return "Chinese Macau"
		Case $MACRO_LANG_Croatian
			Return "Croatian"
		Case $MACRO_LANG_Croatian_Bosnia_Herzegovina
			Return "Croatian Bosnia Herzegovina"
		Case $MACRO_LANG_Czech
			Return "Czech"
		Case $MACRO_LANG_Danish
			Return "Danish"
		Case $MACRO_LANG_Divehi
			Return "Divehi"
		Case $MACRO_LANG_Dutch_Standard
			Return "Dutch Standard"
		Case $MACRO_LANG_Dutch_Belgian
			Return "Dutch Belgian"
		Case $MACRO_LANG_English_United_States
			Return "English United States"
		Case $MACRO_LANG_English_United_Kingdom
			Return "English United Kingdom"
		Case $MACRO_LANG_English_Australian
			Return "English Australian"
		Case $MACRO_LANG_English_Canadian
			Return "English Canadian"
		Case $MACRO_LANG_English_New_Zealand
			Return "English New Zealand"
		Case $MACRO_LANG_English_Ireland
			Return "English Ireland"
		Case $MACRO_LANG_English_South_Africa
			Return "English South Africa"
		Case $MACRO_LANG_English_Jamaica
			Return "English Jamaica"
		Case $MACRO_LANG_English_Caribbean
			Return "English Caribbean"
		Case $MACRO_LANG_English_Belize
			Return "English Belize"
		Case $MACRO_LANG_English_Trinidad
			Return "English Trinidad"
		Case $MACRO_LANG_English_Zimbabwe
			Return "English Zimbabwe"
		Case $MACRO_LANG_English_Philippines
			Return "English Philippines"
		Case $MACRO_LANG_Estonian
			Return "Estonian"
		Case $MACRO_LANG_Faeroese
			Return "Faeroese"
		Case $MACRO_LANG_Farsi
			Return "Farsi"
		Case $MACRO_LANG_Finnish
			Return "Finnish"
		Case $MACRO_LANG_French_Standard
			Return "French Standard"
		Case $MACRO_LANG_French_Belgian
			Return "French Belgian"
		Case $MACRO_LANG_French_Canadian
			Return "French Canadian"
		Case $MACRO_LANG_French_Swiss
			Return "French Swiss"
		Case $MACRO_LANG_French_Luxembourg
			Return "French Luxembourg"
		Case $MACRO_LANG_French_Monaco
			Return "French Monaco"
		Case $MACRO_LANG_Georgian
			Return "Georgian"
		Case $MACRO_LANG_Galician
			Return "Galician"
		Case $MACRO_LANG_German_Standard
			Return "German Standard"
		Case $MACRO_LANG_German_Swiss
			Return "German Swiss"
		Case $MACRO_LANG_German_Austrian
			Return "German Austrian"
		Case $MACRO_LANG_German_Luxembourg
			Return "German Luxembourg"
		Case $MACRO_LANG_German_Liechtenstein
			Return "German Liechtenstein"
		Case $MACRO_LANG_Greek
			Return "Greek"
		Case $MACRO_LANG_Gujarati
			Return "Gujarati"
		Case $MACRO_LANG_Hebrew
			Return "Hebrew"
		Case $MACRO_LANG_Hindi
			Return "Hindi"
		Case $MACRO_LANG_Hungarian
			Return "Hungarian"
		Case $MACRO_LANG_Icelandic
			Return "Icelandic"
		Case $MACRO_LANG_Indonesian
			Return "Indonesian"
		Case $MACRO_LANG_Italian_Standard
			Return "Italian Standard"
		Case $MACRO_LANG_Italian_Swiss
			Return "Italian Swiss"
		Case $MACRO_LANG_Japanese
			Return "Japanese"
		Case $MACRO_LANG_Kannada
			Return "Kannada"
		Case $MACRO_LANG_Kazakh
			Return "Kazakh"
		Case $MACRO_LANG_Konkani
			Return "Konkani"
		Case $MACRO_LANG_Korean
			Return "Korean"
		Case $MACRO_LANG_Kyrgyz
			Return "Kyrgyz"
		Case $MACRO_LANG_Latvian
			Return "Latvian"
		Case $MACRO_LANG_Lithuanian
			Return "Lithuanian"
		Case $MACRO_LANG_Macedonian
			Return "Macedonian"
		Case $MACRO_LANG_Malay_Malaysia
			Return "Malay Malaysia"
		Case $MACRO_LANG_Malay_Brunei_Darussalam
			Return "Malay Brunei Darussalam"
		Case $MACRO_LANG_Malayalam
			Return "Malayalam"
		Case $MACRO_LANG_Maltese
			Return "Maltese"
		Case $MACRO_LANG_Maori
			Return "Maori"
		Case $MACRO_LANG_Marathi
			Return "Marathi"
		Case $MACRO_LANG_Mongolian
			Return "Mongolian"
		Case $MACRO_LANG_Norwegian_Bokmal
			Return "Norwegian Bokmal"
		Case $MACRO_LANG_Norwegian_Nynorsk
			Return "Norwegian Nynorsk"
		Case $MACRO_LANG_Polish
			Return "Polish"
		Case $MACRO_LANG_Portuguese_Brazilian
			Return "Portuguese Brazilian"
		Case $MACRO_LANG_Portuguese_Standard
			Return "Portuguese Standard"
		Case $MACRO_LANG_Punjabi
			Return "Punjabi"
		Case $MACRO_LANG_Quechua_Bolivia
			Return "Quechua Bolivia"
		Case $MACRO_LANG_Quechua_Ecuador
			Return "Quechua Ecuador"
		Case $MACRO_LANG_Quechua_Peru
			Return "Quechua Peru"
		Case $MACRO_LANG_Romanian
			Return "Romanian"
		Case $MACRO_LANG_Russian
			Return "Russian"
		Case $MACRO_LANG_Sami_Inari
			Return "Sami Inari"
		Case $MACRO_LANG_Sami_Lule_Norway
			Return "Sami Lule Norway"
		Case $MACRO_LANG_Sami_Lule_Sweden
			Return "Sami Lule Sweden"
		Case $MACRO_LANG_Sami_Northern_Finland
			Return "Sami Northern Finland"
		Case $MACRO_LANG_Sami_Northern_Norway
			Return "Sami Northern Norway"
		Case $MACRO_LANG_Sami_Northern_Sweden
			Return "Sami Northern Sweden"
		Case $MACRO_LANG_Sami_Skolt
			Return "Sami Skolt"
		Case $MACRO_LANG_Sami_Southern_Norway
			Return "Sami Southern Norway"
		Case $MACRO_LANG_Sami_Southern_Sweden
			Return "Sami Southern Sweden"
		Case $MACRO_LANG_Sanskrit
			Return "Sanskrit"
		Case $MACRO_LANG_Serbian_Latin
			Return "Serbian Latin"
		Case $MACRO_LANG_Serbian_Latin_Bosnia_Herzegovina
			Return "Serbian Latin Bosnia Herzegovina"
		Case $MACRO_LANG_Serbian_Cyrillic
			Return "Serbian Cyrillic"
		Case $MACRO_LANG_Serbian_Cyrillic_Bosnia_Herzegovina
			Return "Serbian Cyrillic Bosnia Herzegovina"
		Case $MACRO_LANG_Slovak
			Return "Slovak"
		Case $MACRO_LANG_Slovenian
			Return "Slovenian"
		Case $MACRO_LANG_Spanish_Traditional_Sort
			Return "Spanish Traditional Sort"
		Case $MACRO_LANG_Spanish_Mexican
			Return "Spanish Mexican"
		Case $MACRO_LANG_Spanish_Modern_Sort
			Return "Spanish Modern Sort"
		Case $MACRO_LANG_Spanish_Guatemala
			Return "Spanish Guatemala"
		Case $MACRO_LANG_Spanish_Costa_Rica
			Return "Spanish Costa Rica"
		Case $MACRO_LANG_Spanish_Panama
			Return "Spanish Panama"
		Case $MACRO_LANG_Spanish_Dominican_Republic
			Return "Spanish Dominican Republic"
		Case $MACRO_LANG_Spanish_Venezuela
			Return "Spanish Venezuela"
		Case $MACRO_LANG_Spanish_Colombia
			Return "Spanish Colombia"
		Case $MACRO_LANG_Spanish_Peru
			Return "Spanish Peru"
		Case $MACRO_LANG_Spanish_Argentina
			Return "Spanish Argentina"
		Case $MACRO_LANG_Spanish_Ecuador
			Return "Spanish Ecuador"
		Case $MACRO_LANG_Spanish_Chile
			Return "Spanish Chile"
		Case $MACRO_LANG_Spanish_Uruguay
			Return "Spanish Uruguay"
		Case $MACRO_LANG_Spanish_Paraguay
			Return "Spanish Paraguay"
		Case $MACRO_LANG_Spanish_Bolivia
			Return "Spanish Bolivia"
		Case $MACRO_LANG_Spanish_El_Salvador
			Return "Spanish El Salvador"
		Case $MACRO_LANG_Spanish_Honduras
			Return "Spanish Honduras"
		Case $MACRO_LANG_Spanish_Nicaragua
			Return "Spanish Nicaragua"
		Case $MACRO_LANG_Spanish_Puerto_Rico
			Return "Spanish Puerto Rico"
		Case $MACRO_LANG_Swahili
			Return "Swahili"
		Case $MACRO_LANG_Swedish
			Return "Swedish"
		Case $MACRO_LANG_Swedish_Finland
			Return "Swedish Finland"
		Case $MACRO_LANG_Syriac
			Return "Syriac"
		Case $MACRO_LANG_Tamil
			Return "Tamil"
		Case $MACRO_LANG_Tatar
			Return "Tatar"
		Case $MACRO_LANG_Telugu
			Return "Telugu"
		Case $MACRO_LANG_Thai
			Return "Thai"
		Case $MACRO_LANG_Tswana
			Return "Tswana"
		Case $MACRO_LANG_Ukrainian
			Return "Ukrainian"
		Case $MACRO_LANG_Turkish
			Return "Turkish"
		Case $MACRO_LANG_Ukrainian
			Return "Ukrainian"
		Case $MACRO_LANG_Urdu
			Return "Urdu"
		Case $MACRO_LANG_Uzbek_Latin
			Return "Uzbek Latin"
		Case $MACRO_LANG_Uzbek_Cyrillic
			Return "Uzbek Cyrillic"
		Case $MACRO_LANG_Vietnamese
			Return "Vietnamese"
		Case $MACRO_LANG_Welsh
			Return "Welsh"
		Case $MACRO_LANG_Xhosa
			Return "Xhosa"
		Case $MACRO_LANG_Zulu
			Return "Zulu"
	EndSwitch
	Return "Unknown"
EndFunc
