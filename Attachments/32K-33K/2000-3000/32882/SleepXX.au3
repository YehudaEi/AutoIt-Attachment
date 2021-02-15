#Region Description
;===============================================================================
; Description:      Expands on the default sleep function by sleeping specific units of time
;					Based on and inspired by Kalin ( http://www.autoitscript.com/forum/topic/124141-sleepx/ )
;
; Parameter(s):     $iTime - specified time (number Of intervals)
;					$sUnit - String unit of measure that can be any of the below:
;
;					microsecond - 1/100 of a second
;					second - one second (this is the default)
;					minute - 60 seconds
;					hour - 60 minutes
;					day - 24 hours
;					week - 7 days
;					fortnight - 2 weeks
;					year - 365 days
;					swatch - swatch beat - 1 minute and 26.4 seconds (http://en.wikipedia.org/wiki/Swatch_Internet_Time)
;					lunarday - Average Lunar day - 29 days, 12 hours, 44 minutes and 3 seconds (http://en.wikipedia.org/wiki/Lunar_day)
;					gaussianyear - 365.2568983 days (http://en.wikipedia.org/wiki/Gaussian_year)
;					galacticyear  - Galactic year - 225 million years - http://en.wikipedia.org/wiki/Galactic_year
;					helek - hewbrew helek - 3 and one thrird seconds (http://en.wikipedia.org/wiki/Helek)
;					samay - hindu samay - quarter of a second (http://en.wikipedia.org/wiki/Samay)
;					Atom - from philosophical writing. 15/94 of a second (http://en.wikipedia.org/wiki/Atom_%28time%29)
;					jiffy - Linux Jiffy - 4 ms (http://en.wikipedia.org/wiki/Jiffy_%28time%29)
;					microfortnight - 1.2096 seconds (http://en.wikipedia.org/wiki/List_of_unusual_units_of_measurement#Time)
;					blinkofaneye - A Blink Of An Eye - 25 milliseconds
;					twoshakesofalambstail - Two shakes of a lambs tail - two fiths of a second. My mother told me so and she knows everything.
;					integermax - Maximum possible sleep time as per 64 bit signed interger limit. 292 277 266 years. Specifying more than one will produce an overflow error
;added in version 0.2
;					medievalostent - medieval ostent - 1/10 hour ( http://www.encyclo.co.uk/define/Ostent )
;                   medievalmoment - medieval moment - 1/40 of an hour ( http://en.wikipedia.org/wiki/Moment_%28time%29 )
;					inyourowntime- in your own time - random sleep anywhere between 1 second and an hour (and multiples there of)
;					fiveninesdowntime - five nines down time - Downtime per year when uptime is the "five nines" (99.999%) - 5 minutes and 15.36 seconds
;					HummingbirdWingbeat - Wingbeat of a small Humming bird - somewhere between 12 and 26 milliseconds. Can be used to approximate the velocity of an unladened swallow ( http://hypertextbook.com/facts/2000/MarkLevin.shtml )
;
; Requirement(s):   None
;
; Author(s):        Kalin  &  Carl Montgomery
;
; Note(s):			if unit is not specified or incorrectly spelled then seconds is used as default
;
; Version History	0.1 - 12 jan 2011 - initial version
; 					0.2 - 13 jan 2011 - added extra units of time and fixed the odd embarresing tyro
;					0.3 - 13 jan 2011 - fixed a bug where sleeps over 24 days did not work. thanks to Malkey for pointing this out.
;===============================================================================
#EndRegion Description

Func SleepXX($iTime, $sUnit)

	Select
		Case $sUnit = "microsecond"
			$iMultiplyer = 10

		Case $sUnit = "second"
			$iMultiplyer = 1000

		Case $sUnit = "minute"
			$iMultiplyer = 60000

		Case $sUnit = "hour"
			$iMultiplyer = 3600000

		Case $sUnit = "day"
			$iMultiplyer = 86400000

		Case $sUnit = "day"
			$iMultiplyer = 86400000

		Case $sUnit = "week"
			$iMultiplyer = 604800000

		Case $sUnit = "fortnight"
			$iMultiplyer = 1209600000

		Case $sUnit = "year"
			$iMultiplyer = 31536000000

		Case $sUnit = "swatch"
			$iMultiplyer = 86400

		Case $sUnit = "lunarday"
			$iMultiplyer = 2551443000

		Case $sUnit = "gaussianyear"
			$iMultiplyer = 31558196000

		Case $sUnit = "galacticyear"
			$iMultiplyer = 7095600000000000000

		Case $sUnit = "helek"
			$iMultiplyer = 3333.3333333333333

		Case $sUnit = "samay"
			$iMultiplyer = 250

		Case $sUnit = "Atom"
			$iMultiplyer = 159.57446808510638297872340425532

		Case $sUnit = "jiffy"
			$iMultiplyer = 4

		Case $sUnit = "microfortnight"
			$iMultiplyer = 1209.6

		Case $sUnit = "blinkofaneye"
			$iMultiplyer = 25

		Case $sUnit = "twoshakesofalambstail"
			$iMultiplyer = 400

		Case $sUnit = "integermax"
			$iMultiplyer = 9223372036854775807


			;added in version 0.2

		Case $sUnit = "medievalostent"
			$iMultiplyer = 360000

		Case $sUnit = "medievalmoment"
			$iMultiplyer = 90000

		Case $sUnit = "inyourowntime"
			$iMultiplyer = Random(1000, 3600000)

		Case $sUnit = "fiveninesdowntime"
			$iMultiplyer = 315360

		Case $sUnit = "HummingbirdWingbeat"
			$iMultiplyer = Random(12, 26)


		Case Else
			$iMultiplyer = 1000
	EndSelect

	$arithmetic = $iTime * $iMultiplyer
	;check to see if the sleep goes over Autoit's 24 day limit
	If $arithmetic > 2147483647 Then

		;calulate a sleep loop
		$iSleepLoop = Floor($arithmetic / 2147483647)

		;calculate the ramainder
		$iSleepRemainder = $arithmetic - ($iSleepLoop * 2147483647)

		;start the 24 day sleep loop

		For $loop = 1 To $iSleepLoop

			Sleep(2147483647)

		Next

		;now sleep for the remainder

		Sleep($iSleepRemainder)

	Else ; just run the sleep as is

		Sleep($arithmetic)

	EndIf
EndFunc   ;==>SleepXX
