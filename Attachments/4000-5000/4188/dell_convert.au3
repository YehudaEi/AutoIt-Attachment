; ======================================================================================================
; Script Name:		Convert Dell Service Tag <=> Express Service Code
; Filename:			dell_convert.au3
; Compiled as:		dell_convert.exe
; Author:			Erik Buras <thephantomlinguist@yahoo.com>
; Script Ver.:		1.0
; AutoIT Ver.:		3.1.1
; Date:				17 Sep. 2005
; Description:
; 			A basic utility that converts the Dell Service Tag to its corresponding 
;		Express Service Code and vice versa.
; Notes and Sources:
; 			Dell uses a single serial number to uniquely identify its products. That
;		serial number is represented two different ways: as a base-36 number (the
;		Service Tag) and as a base-10 number (the Express Service Code). Thus, the
; 		conversion between the two is simply a matter of converting between base-10
; 		and base-36.
;			As an exercise in how to build a simple, but fully functional GUI using
;		the AutoITv3 scripting language, as well as hoping to better understand the
;		processes involved in making the conversion, I set out to write this script.
;			There are four routines that will be employed: building the GUI, the
;		input loop, the base conversion routine, and a Service Tag validation routine,
;			Each of these routines are copiously annotated to ensure maximum
;		readability and understandability.
;			The pseudocode that follows was found as I was searching for an
;		understanding of the processes involved in converting between bases. The
;		author's full discussion can be found at <                                   
;		computer/numericbase.html>.
; Pseudocode for the base conversion:
; 		string function Base2Base(InputNumber as string, InputBase as integer, OutputBase as integer)
; 			Dim J, K, DecimalValue, X, MaxBase, InputNumberLength as integer
; 			Dim NumericBaseData, OutputValue as string
; 			NumericBaseData = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
; 			MaxBase = Length(NumericBaseData)
; 			if (InputBase > MaxBase) OR (OutputBase > MaxBase) then
;  				Base2Base = "N/A"
;  				return
; 			end if
; 			*/ Convert InputNumber to Base 10 /*
; 			InputNumberLength = Length(InputNumber)
; 			DecimalValue = 0
; 			for J = 1 to InputNumberLength
;  				for K = 1 to InputBase
;   				if mid(InputNumber, J, 1) == mid(NumericBaseData, K, 1) then
;    					DecimalValue = DecimalValue+int((K-1)*(InputBase^(InputNumberLength-J))+.5)
;   				end if
;  				next K
; 			next J
; 			*/ Convert the Base 10 value (DecimalValue) to the desired output base /*
; 			OutputValue = ""
; 			while DecimalValue > 0
;  				X = int(((DecimalValue/OutputBase)-int(DecimalValue/OutputBase))*OutputBase+1.5)
;  				OutputValue = mid(NumericBaseData, X, 1)+OutputValue
;  				DecimalValue = int(DecimalValue/OutputBase)
; 			loop
; 			Base2Base = OutputValue
; 			return
; 		end
; License:
;		This work is licensed under the Creative Commons Attribution-ShareAlike License. To view a 
;		copy of this license, visit                                                or send a letter 
;		to Creative Commons, 543 Howard Street, 5th Floor, San Francisco, California, 94105, USA.
; ======================================================================================================

; Building the GUI
; -------------------------------------
	; In order to utilize the $GUI_EVENT_CLOSE constant, we must include the following library
	#include <guiconstants.au3>

	; Create the GUI
		; Create a decent sized window, centered on the screen
			guicreate("Service Tag <=> Express Service Code", 370, 130, -1, -1)
		; Create the Instructions label on the GUI, so the User knows what's going on
			$instructions_label = guictrlcreatelabel("Enter either the Service Tag or the Express Service Code and press {TAB}", 10, 10)
		; Create the Service Tag and Express Service Code labels for the input boxes
			$service_tag_label = guictrlcreatelabel("Service Tag:", 10, 40)
			$express_service_code_label = guictrlcreatelabel("Express Service Code:", 10, 70)
		; Create the Service Tag and Express Service Code input boxes
			$service_tag_input = guictrlcreateinput("", 125, 35, 230)
			$express_service_code_input = guictrlcreateinput("", 125, 65, 230)
		; Add an About button, explaining this work and the license it is released under
			$about_button = guictrlcreatebutton("About...", 10, 95, 75)
		; Add a Reset Inputs button, that allows the two input boxes to be cleared
			$reset_button = guictrlcreatebutton("Reset Inputs", 200, 95, 75)
		; Add an Exit button
			$exit_button = guictrlcreatebutton("Exit", 280, 95, 75)
		; When the window is created, it is initially hidden, the following line makes it visible
			guisetstate(@SW_SHOW)

; The Input Loop
; -------------------------------------
	; This while-wend loop takes any inputs and, if they match what we're looking for, calls the appropriate function
	while 1
		$input = guigetmsg()
		select
		case $input = $gui_event_close
			exitloop	; Leave the while-wend and continue executing the script
		case $input = $exit_button
			exitloop	; Same as above
		case $input = $reset_button
			guictrlsetdata($express_service_code_input, "") ; Clears the input box
			guictrlsetdata($service_tag_input, "") ; Clears the input box
			send("{TAB}") 
			send("{TAB}") ; These two tabs move focus back to the Service Tag input box
		case $input = $about_button
			; The following line creates a dialog box that shows the information needed
			msgbox(0, "About...", "Script Name:" & @TAB & "Convert Dell Service Tag <=> Express Service Code" _
						& @CRLF & "Filename:" & @TAB & @TAB & "dell_convert.au3" _
						& @CRLF & "Compiled as:" & @TAB & "dell_convert.exe" _
						& @CRLF & "Author:" & @TAB & @TAB & "Erik Buras <erik@burlesonisd.net>" _
						& @CRLF & "Script Ver.:" & @TAB & "1.0" _
						& @CRLF & "AutoIT Ver.:" & @TAB & "3.1.1" _
						& @CRLF & "Date:" & @TAB & @TAB & "17 Sep. 2005" _
						& @CRLF & "License:" & @TAB & @TAB & "This work is licensed under the Creative Commons" _
								     & @CRLF & @TAB & @TAB & "Attribution-ShareAlike License. To view a copy of" _
									 & @CRLF & @TAB & @TAB & "this license, visit                            " _
									 & @CRLF & @TAB & @TAB & "licenses/by-sa/2.5/ or send a letter to Creative" _
									 & @CRLF & @TAB & @TAB & "Commons, 543 Howard Street, 5th Floor," _
									 & @CRLF & @TAB & @TAB & "San Francisco, California, 94105, USA.")
			send("{TAB}") 
			send("{TAB}") 
			send("{TAB}") ; These three tabs move focus back to the Service Tag input box
		case $input = $service_tag_input
			; Takes the data entered and passes it to the _baseconvert function for processing
			guictrlsetdata($express_service_code_input, _baseconvert(guictrlread($service_tag_input), 36, 10))
			guictrlsetdata($service_tag_input, stringupper(guictrlread($service_tag_input)))
			send("{TAB}") 
			send("{TAB}") 
			send("{TAB}") 
			send("{TAB}") 
			send("{TAB}") ; These five tabs move focus to the Express Service Code input box
		case $input = $express_service_code_input
			; Takes the data entered and passes it to the _baseconvert function for processing
			guictrlsetdata($service_tag_input, _baseconvert(guictrlread($express_service_code_input), 10, 36))
			send("{TAB}") 
			send("{TAB}") 
			send("{TAB}") ; These three tabs move focus back to the Service Tag input box
		endselect
	wend

	; End the program
	exit

; The Base Conversion Routine
; -------------------------------------
; This routine calls the Service Tag Validation Routine. It could be very easily modified to handle a variety of situations.
func _baseconvert($input_number, $input_base, $output_base)
	; Check to see if the Service Tag is valid
	if number($input_base) = 36 then
		if _validservicetag($input_number) = 0 then
			return "ERROR"
		endif
	endif
	
	; Define some important variables
	$numericbasedata = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	$maxbase = stringlen($numericbasedata)

	; Make sure the function call is within specified parameters
	if $input_base > $maxbase or $output_base > $maxbase then
		msgbox(0, "Error", "Input or Output Base exceeds Maximum Base in Function _baseconvert")
		return 0
	endif

	$input_number = stringupper($input_number)
	
	; Convert the input number to base 10
	$input_number_length = stringlen($input_number)
	$decimalvalue = 0
	for $j = 1 to $input_number_length
		for $k = 1 to $input_base
			if stringmid($input_number, $j, 1) == stringmid($numericbasedata, $k, 1) then
				$decimalvalue = $decimalvalue + int(($k - 1) * ($input_base ^ ($input_number_length - $j)) + .5)
			endif
		next
	next
	
	; Convert the base 10 value to the the output base
	$outputvalue = ""
	while $decimalvalue > 0
		$x = int((($decimalvalue / $output_base) - int($decimalvalue / $output_base)) * $output_base + 1.5)
		$outputvalue = stringmid($numericbasedata, $x, 1) & $outputvalue
		$decimalvalue = int($decimalvalue / $output_base)
	wend
	
	; If we're outputting a Service Tag, check to see if it is valid
	if number($input_base) = 10 then
		if _validservicetag($outputvalue) = 0 then
			return "ERROR"
		endif
	endif
	return $outputvalue
endfunc

; Service Tag Validation Routine
; -------------------------------------
func _validservicetag($service_tag)
	; In order for the Service Tag to be valid, it must be between 5 and 7 characters and it must consist of only letters and numbers
	; First, we'll make sure that there are no less than five and no more than seven characters
	if stringlen($service_tag) <= 7 and stringlen($service_tag) >= 5 then
		; Finally, we'll make sure that only alphanumeric characters exist in the string
		if stringisalnum($service_tag) then
				return 1
		endif
	else
		return 0 ; On failure, the function returns 0
	endif
endfunc
