#include-once

AutoItSetOption("MustDeclareVars", 1) ; 0=no, 1=variables must be declared on forehand.
;  NEDERLANDS:  						0=nee, 1=variabelen moeten van tevoren gedeclareerd worden.

;  Press the key F5 on the "..\AC_Framework\AC_Compilation.au3"  file,
;  				that uses  "..\AC_Framework\AC_Vars_Includes.au3",
;  				to find the compilation-errors in any of the "..\AC_Framework\A_*.au3" scripts.
;  NEDERLANDS:  Gebruik de F5 functietoets op  "..\AC_Framework\AC_Compilation.au3",
; 		       	welke gebruik maakt van de "..\AC_Framework\AC_Vars_Includes.au3",
;  		      	om de compilatie fouten te vinden in  alle "..\AC_Framework\A_*.au3"

;  With <Alt>l (lower case L) you can show a listbox in the SciTe Version 1.79 editor, for all declared functions in this script.
;  NEDERLANDS:  Met de sneltoets <Alt>l (kleine letter L) verschijnt in de SciTe editor een lijst van alle functies in het script.


; #FUNCTION# ====================================================================================================================
; Name...........: TuXmlParse
; Description ...:  splits the XML around a search rag
;
;				   	NEDERLANDS:
;					Splitst de XML rond de zoek tag
; Syntax.........: ..
; Parameters ....:
;					$sContent			: The XML to split
;					$sZoek				: The search string (without < and > ) of the tag
;					ByRef $aLevelInt	: Array of resulting levels. Aray element 0 contains the number of results.
;					ByRef $aSpaces[]	: Array of resulting indenting spaces for leveld.  Aray element 0 contains the number of results.
;					ByRef $aNode[]		: Array of resulting nodes. Aray element 0 contains the number of results.
;					ByRef $aResult[]	: Array of resulting values. Aray element 0 contains the number of results.
;					$showResults[]		: Indication to show all results. Aray element 0 contains the number of results.
;					$1eKeer = True		: Boolean for adding up results of subsequent calls, or resetting the results as in
;										  starting for the first time.
; Return values .: $aResult[], the XML sting is split in aprts around the search-tag.
; Author ........: Martin van Leeuwen
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: no
; ===============================================================================================================================
Func TuXmlParse( $sContent, $sZoek, ByRef $aLevelInt, ByRef $aSpaces, ByRef $aNode, ByRef $aResult, $showResults, $1eKeer = True )
	Const $zoek = '<' & $sZoek & '>', $start = $sZoek & '>', $startLen = StringLen($start), $blok = $sZoek & '/>', $stop = '/'& $sZoek & '>', $stopLen = $startLen + 1
	Const $caseSense = 2 ; preferably 2   not case sensitive, using a basic/faster comparison ;0 = not case sensitive, using the user's locale (default) ;1 = case sensitive
	Local $aLevel1[1], $aSpaces1[1], $aNode1[1], $aResult1[1]
	Local $aNode_allLevels[1]

	Const $arrShowMax = 40
	Local $arrShow[$arrShowMax][5], $startTime, $diffTime
	Local $MaxLevel = 0

	Local $aSplit, $iLoop, $iLevel, $isStart, $str, $arrTag
	Local $nrOfLoops, $nrOfHits, $waarde, $nrSubLoops

	Local $splitTime, $aX, $nrOccurences

	If $showResults Then $startTime = _Timer_Init()

	; Initieer
	If $1eKeer Then
		$aLevelInt = $aLevel1
		$aSpaces = $aSpaces1
		$aNode = $aNode1
		$aResult = $aResult1
		$aLevelInt[0] = 0
		$aSpaces[0] = 0
		$aNode[0] = 0
		$aResult[0] = 0
	EndIf

	$aX = StringSplit($sContent, $zoek, 1) ; 1 = Split on the whole $zoek string.
	$nrOccurences = $aX[0] - 1 ; Onthoud deze warde, om zo snel mogelijk uit de while loop te kunnen springen.
	$aSplit = StringSplit($sContent, '<', 1)

	$aNode_allLevels[0] = 1 ; Level 0 wijst nu naar $aSplit[1]
	$aSplit[1] = '<>' ;       Maak van de Level 0 waarde een lege tag,
	$iLoop = 2 ;              en loop vanaf 2.
	$nrOfHits = 0
	$iLevel = 0
	; _ArrayDisplay($aSplit, '$aSplit[0] ' & $aSplit[0] & ', $nrOccurences: '& $nrOccurences)
	While $iLoop <= $aSplit[0] ; Loop over all pieces

		If StringLeft($aSplit[$iLoop], 1) == '/' Then ; This one first, use the fastest comparison that is case sensitive ==
			$iLevel = $iLevel - 1

		Else

			$isStart = StringLeft($aSplit[$iLoop], $startLen) == $start
			If $isStart Or (StringLeft($aSplit[$iLoop], $startLen + 1) == $blok) Then ; blok ends on /> that immediately ends the tag
				$waarde = ''
				If $isStart Then
					$waarde = StringMid($aSplit[$iLoop], $startLen + 1)
					$iLoop = $iLoop + 1
					$nrSubLoops = 0
					While $iLoop <= $aSplit[0] ; Loop over all pieces
						If StringLeft($aSplit[$iLoop], $startLen + 1) == $stop Then
							If $nrSubLoops = 0 Then ExitLoop
							$nrSubLoops = $nrSubLoops - 1
						ElseIf StringLeft($aSplit[$iLoop], $startLen) == $start Then
							$nrSubLoops = $nrSubLoops + 1
						EndIf
						$waarde = $waarde & '<' & $aSplit[$iLoop]
						$iLoop = $iLoop + 1
					Wend
				EndIf
				_ArrayAdd($aLevelInt, $iLevel)
				$str = ''
				For $j = 1 to $iLevel
					$str = $str & '.'
				Next
				$str = $str & 'x'
				_ArrayAdd($aSpaces, $str )
				If $iLevel < 0 then
					_ArrayAdd($aNode, '<>')
				Else
					$arrTag = StringSplit($aSplit[$aNode_allLevels[$iLevel]], '>', 1)
				Endif
				_ArrayAdd($aNode, '<' & $arrTag[1] & '>')
				_ArrayAdd($aResult, $waarde)

				$nrOfHits = $nrOfHits + 1
				If $nrOfHits = $nrOccurences Then ExitLoop


			Else ; '<'
				If Not StringInStr($aSplit[$iLoop], '/>') Then ;  /> immediately ends the tag
					$iLevel = $iLevel + 1
					If $iLevel > $MaxLevel Then
						$MaxLevel = $iLevel
						_ArrayAdd($aNode_allLevels, $iLoop)
					Else
						$aNode_allLevels[$iLevel] = $iLoop
					EndIf
				EndIf
			EndIf

		EndIf
		$iLoop = $iLoop + 1
	Wend

	$aLevelInt[0] = $aLevelInt[0] + $nrOfHits
	$aSpaces[0] = $aSpaces[0] + $nrOfHits
	$aNode[0] = $aNode[0] +  $nrOfHits
	$aResult[0] = $aResult[0] +  $nrOfHits


	If $showResults And ($C_ActionflowMode <> 9 ) then ; $C_ActionflowMode wordt initieel op 0 gezet in 00_Vars.au3  0 = Interactief, 9 = In Batch (unattended). Vergelijk het gebruik hiervan in Func iii()
		$diffTime = _Timer_Diff($startTime) ; 6 msec onder Windows 7 voor 2 hits op BSN (vooraan in de .xml) en 8 msec op Windows 7 voor 5 hits op voornamen.
		$arrShow[0][0] = ''
		$arrShow[0][1] = $nrOfHits & ' levels'
		$arrShow[0][2] = $nrOfHits & ' inspringingen'
		$arrShow[0][3] = $nrOfHits & ' nodes'
		$arrShow[0][4] = $nrOfHits & ' results voor ' & $zoek
		$nrOfLoops = $nrOfHits
		If $nrOfHits <= $arrShowMax - 1 Then
			$nrOfLoops = $nrOfHits
		Else
			$nrOfLoops = $arrShowMax - 1
		EndIf
		For $i = 1 to $nrOfLoops
			$arrShow[$i ][0] = ''
			$arrShow[$i ][1] = $aLevelInt[$i ]
			$arrShow[$i ][2] = $aSpaces[$i ]
			$arrShow[$i ][3] = $aNode[$i ]
			$arrShow[$i ][4] = $aResult[$i ]
		Next
		If $nrOfLoops <> $nrOfHits Then
			iii( 'Er worden maar ' & $nrOfLoops  & ' van de ' &  $nrOfHits & ' rijen getoond.')
		EndIf
		_ArrayDisplay($arrShow, 'Verwerkingstijd in msec: ' &  $diffTime)
		If $MaxLevel > 40 Then _ArrayDisplay($aNode_allLevels, 'Waarschuwing: Aantal levels is meer dan 40: ' & $MaxLevel)
	Endif

EndFunc   ;==>TuXmlParse




Func TuXMLShowMemory($in_markering)
	Local $mem = MemGetStats() ; All memory sizes are in kilobytes.

	; iii(	'$mem[0] = Memory Load (Percentage of memory in use) in kilobytes:' & $mem[0] & @CRLF & _
	;		'$mem[1] = Total physical RAM in kilobytes:' & $mem[1] & @CRLF & _
	;		'$mem[2] = Available physical RAM in kilobytes:' & $mem[2] & @CRLF & _
	;		'$mem[3] = Total Pagefile in kilobytes:' & $mem[3] & @CRLF & _
	;		'$mem[4] = Available Pagefile in kilobytes:' & $mem[4] & @CRLF & _
	;		'$mem[5] = Total virtual in kilobytes:' & $mem[5]  & @CRLF & _
	;		'$mem[6] = Available virtual in kilobytes:' & $mem[6] & @CRLF _
	;		)
	iii('$mem[6] = Available virtual in kilobytes, op plaats ' & $in_markering & ', ' & $mem[6])

EndFunc   ;==>TuXMLShowMemory




