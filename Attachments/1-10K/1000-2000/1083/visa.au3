#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    VISA (GPIB & TCP) library for AutoIt
;                 Functions that allow controlling instruments (e.g. oscilloscopes,
;                 signal generators, spectrum analyzers, power supplies, etc)
;                 that have a GPIB or Ethernet port through the VISA interface
;                 (GPIB, TCP or Serial Interface)
; Limitations:    The VISA queries only return the 1st line of the device answer
;                 This is not a problem in most cases, as most devices will always
;                 answer with a single line
; Notes:
;                 If you are interested in this library you probably already know 
;                 what is VISA and GPIB, but here there is a short description 
;                 for those that don't know about it:
;
;                 Basically GPIB allows you to control instruments like Power 
;                 Supplies, Signal Generators, Oscilloscopes, Signal Generators, etc.
;                 You need to install or connect a GPIB interface card (PCI, PCMCIA
;                 or USB) to your PC and install the corresponding GPIB driver.
;
;                 VISA is a standard API that sits on top of the GPIB driver and
;                 it allows you to use the same programs to control your 
;                 instruments regardless of the type of GPIB card that you have 
;                 installed in your PC (most cards are made either by National 
;                 Instruments(R) or by Agilent/Hewlett-Packard(R)).
;
;                 This library is that it opens AutoIt to a different kind of 
;                 automation (instrument automation). Normally you would need to
;                 use some expensive "instrumentation" environment like 
;                 Labwindows/CVI (TM), LabView (TM) or Matlab (TM) to automate 
;                 instruments but now you can do so with AutoIt.
;                 The only requirement is that you need a VISA compatible GPIB 
;                 card (all cards that I know are) and the corresponding VISA 
;                 driver must be installed (look for visa32.dll in the 
;                 windows\system32 folder).
;
;                 Basically you have 4 main functions:
;                 _viExecCommand - Executes commands and queries through GPIB
;                 _viOpen, _viClose - Open/Close a connection to a GPIB instrument.
;                 _viFindGPIB - Find all the instruments in the GPIB bus
;
;                 There are other less important functions, like:
;                 _viGTL - Go to local mode (exeit the "remote control mode")
;                 _viGpibBusReset - Reset the GPIB bus if it is in a bad state
;                 _viSetTimeout - Sets the GPIB Query timeout
;                 _viSetAttribute - Set any VISA attribute
;
;                 There is only one known limitation, which is that the GPIB 
;                 queries only return the 1st line of the device answer (see above)
;
;                 I recommend that you try first to execute the _viFindGPIB 
;                 function (as shown in the example at the bottom of this file)
;                 and see if you can find any instruments. You can also have a 
;                 look at the examples in the _viExecCommand function description.
;
; ==============================================================================
; VERSION       DATE       DESCRIPTION
; -------    ----------    -----------------------------------------------------
; v1.0.00    02/01/2005    Initial release
; ------------------------------------------------------------------------------


; ==============================================================================
;- VISA Definitions ------------------------------------------------------------
; The VISA library requires some GLOBAL CONSTANTS and VARIABLES that are defined
; here:

;- VISA CONSTANTS -------------------------------------------------------------

Global Const $VI_SUCCESS = 0 ; (0L)
Global Const $VI_NULL = 0

Global Const $VI_TRUE = 1
Global Const $VI_FALSE = 0

;- VISA GPIB BUS control macros (for _viGpibControlREN, see below) -------------
Global Const $VI_GPIB_REN_DEASSERT = 0
Global Const $VI_GPIB_REN_ASSERT = 1
Global Const $VI_GPIB_REN_DEASSERT_GTL = 2
Global Const $VI_GPIB_REN_ASSERT_ADDRESS = 3
Global Const $VI_GPIB_REN_ASSERT_LLO = 4
Global Const $VI_GPIB_REN_ASSERT_ADDRESS_LLO = 5
Global Const $VI_GPIB_REN_ADDRESS_GTL = 6


;- VISA interface ATTRIBUTE NAMES ----------------------------------------------
Global Const $VI_ATTR_TMO_VALUE = 0x3FFF001A
; Note: There are more attribute types. Please refer to the VISA Programmer's Guide

;- VISA interface ATTRIBUTE VALUES ---------------------------------------------
;* TIMEOUT VALUES:
Global Const $VI_TMO_IMMEDIATE = 0
Global Const $VI_TMO_INFINITE = 0xFFFFFFF
; Note: There are more attribute values. Please refer to the VISA Programmer's Guide


;- VISA Global variable(s) -----------------------------------------------------
; The VISA Resource Manager is used by the _viOpen functions (see below)
Global $DEFAULT_RM = -1



; ==============================================================================
;- Main VISA/GPIB functions ----------------------------------------------------
; These include _viExecCommand, _viOpen, _viClose and _viFindGPIB

;===============================================================================
;
; Description:      MAIN FUNCTION - Send a Command/Query to an Instrument/Device
; Syntax:           _viExecCommand($h_session, $s_command, $n_timeout_ms = -1)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session handle (INTEGER)
;                              * STRING -> A VISA DESCRIPTOR is a string which
;                                specifies the resource with which to establish a
;                                communication session. An example descriptor is
;                                "GPIB::20::0". This function supports all valid
;                                VISA descriptors, including GPIB, TCP, VXI and
;                                Serial Interface instruments. A detailed explanation
;                                of VISA descriptors is shown in the Notes section
;                                of this function.
;                                As a SHORTCUT you can use a STRING containing
;                                the address number (e.g. "20") of a GPIB instrument
;                                instead of typing the full descriptor ("e.g."
;                              * INTEGER -> A VISA session handle is an integer
;                                value returned by _viOpen (see below).
;                                It is recommended that instead you use _viOpen
;                                and VISA session handles instead of descriptors
;                                if you plan to communicate repeteadly with an
;                                Instrument or Device, as otherwise each time that
;                                you contact the instrument you would incur the
;                                overhead of opening and closing the communication
;                                link.
;                                Once you are done using the instrument you must
;                                remember to close the link with _viClose (see below)
;                   $s_command - Command/Query to execute.
;                                A query MUST contain a QUESTION MARK (?)
;                                When the command is a QUERY the function will
;                                automatically wait for the instrument's answer
;                                (or until the operation times out)
;                   $n_timeout_ms - The operation timeout in MILISECONDS
;                                This is mostly important for QUERIES only
;                                This is an OPTIONAL PARAMETER.
;                                If it is not specified the last set timeout will
;                                be used. If it was never set before the default
;                                timeout (which depends on the VISA implementation)
;                                will be used. Timeouts can also be set separatelly
;                                with the _viSetTiemout function (see below)
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  The return value depends on whether the command is a QUERY
;                   or not and in whether the operation was successful or not.
;
;                   * Command, NON QUERY:
;                     On Success - Returns ZERO
;                     On Failure - Returns -1 if the VISA DLL could not be open
;                                  or a NON ZERO value representing the VISA
;                                  error code (see the VISA programmer's guide)
;                   * QUERY:
;                     On Success - Returns the answer of the instrument to the QUERY
;                     On Failure - Returns an EMPTY String ("")
;
;                   This function always sets @error to 1 in case of error
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Example(s):
;                 - Simple communication examples:
;                   Get instrument ID:
;                     $s_idn = _viExecCommand("GPIB::20::0","*IDN?")
;                   This is the same as:
;                     $s_idn = _viExecCommand("20","*IDN?") -> Note that "20" is a STRING
;
;                 - More efficient way to communicate many times
;                   You must use _viOpen and _viClose
;                   In this example we measure a POWER 100 times:
;                     $h_session = _viOpen("GPIB::1::0") ; or $h_session = _viOpen("1")
;                     For $n = 0 To 99
;                       $power_array[$n] = _viExecCommand($h_session,"POWER?")
;                     Next
;                     _viClose($h_session)
;
;                   A more complex example, using 2 instruments, a signal generator
;                   and a spectrum analyzer, to measure the average power error of
;                   the generator:
;
;                     $h_spec_analyzer = _viOpen("GPIB::1::0") ; or $h_session = _viOpen("1")
;                     $h_signal_gen = _viOpen("GPIB::12::0") ; or $h_session = _viOpen("1")
;                     $average_power_error = 0
;                     For $ideal_power = -100 To -10 ; dBM
;                       _viExecCommand($h_signal_gen,"SOURCE:POWER " & $ideal_power & "dBm")
;                       $current_power_error = Abs($ideal_power - _viExecCommand($h_spec_analyzer,"POWER?"))
;                       $average_power_error = $average_power_error + $current_power_error
;                     Next
;                     $average_power_error = $average_power_error / 91
;                     _viClose($h_spec_analyzer)
;                     _viClose($h_signal_gen)
;
; Note(s):
;                 The following is a description of the MOST COMMON VISA DESCRIPTORS
;                 Note that there are some more types. For more info please
;                 refer to a VISA programmer's guide (available at www.ni.com)
;                 Optional segments are shown in square brackets ([]).
;                 Required segments that must be filled in are denoted by angle
;                 brackets (<>).
;
;                 Interface   Syntax
;                 ------------------------------------------------------------
;                 GPIB INSTR      GPIB[board]::primary address
;                                 [::secondary address] [::INSTR]
;                 GPIB INTFC      GPIB[board]::INTFC
;                 TCPIP SOCKET    TCPIP[board]::host address::port::SOCKET
;                 Serial INSTR    ASRL[board][::INSTR]
;                 PXI INSTR       PXI[board]::device[::function][::INSTR]
;                 VXI INSTR       VXI[board]::VXI logical address[::INSTR]
;                 GPIB-VXI INSTR  GPIB-VXI[board]::VXI logical address[::INSTR]
;                 TCPIP INSTR     TCPIP[board]::host address[::LAN device name]
;                                 [::INSTR]
;
;                 The GPIB keyword is used for GPIB instruments.
;                 The TCPIP keyword is used for TCP/IP communication.
;                 The ASRL keyword is used for serial instruments.
;                 The PXI keyword is used for PXI instruments.
;                 The VXI keyword is used for VXI instruments via either embedded
;                 or MXIbus controllers.
;                 The GPIB-VXI keyword is used for VXI instruments via a GPIB-VXI
;                 controller.
;
;                 The default values for optional parameters are shown below.
;
;                 Optional Segment          Default Value
;                 ---------------------------------------
;                 board                     0
;                 secondary address         none
;                 LAN device name           inst0
;
;
;                 Example Resource Strings:
;                 --------------------------------------------------------------
;                 GPIB::1::0::INSTR     A GPIB device at primary address 1 and
;                                       secondary address 0 in GPIB interface 0.
;
;                 GPIB2::INTFC          Interface or raw resource for GPIB
;                                       interface 2.
;
;                 TCPIP0::1.2.3.4::999::SOCKET    Raw TCP/IP access to port 999
;                                                 at the specified IP address.
;
;                 ASRL1::INSTR          A serial device attached to interface
;                                       ASRL1.  VXI::MEMACC Board-level register
;                                       access to the VXI interface.
;
;                 PXI::15::INSTR        PXI device number 15 on bus 0.
;
;                 VXI0::1::INSTR        A VXI device at logical address 1 in VXI
;                                       interface VXI0.
;
;                 GPIB-VXI::9::INSTR    A VXI device at logical address 9 in a
;                                       GPIB-VXI controlled system.
;
;===============================================================================

Func _viExecCommand($h_session, $s_command, $n_timeout_ms = -1)
  If StringInStr($s_command,"?") == 0 Then
    ; The Command is NOT a QUERY
    Return _viPrintf($h_session, $s_command, $n_timeout_ms)
  Else
    ; The Command is a QUERY
    Return _viQueryf($h_session, $s_command, $n_timeout_ms)
  EndIf
EndFunc


;===============================================================================
;
; Description:      Opens a VISA connection to an Instrument/Device
; Syntax:           _viOpen($s_visa_address, $s_visa_secondary_address = 0)
; Parameter(s):     $s_visa_address - A VISA resource descriptor (see the NOTES
;                   of _viExecCommand above for more info)
;                   $s_visa_secondary_address - Some GPIB instruments have
;                   secondary addresses. This parameter is ZERO by default, which
;                   means NO SECONDARY ADDRESS
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns a (POSITIVE) VISA Instrument Handle
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          For simple usage there is no need to use this function, as
;                   _viExecCommand automatically opens/closes a VISA connection
;                   if you pass it a VISA resource descriptor (see the NOTES of
;                   _viExecCommand above for more info)
;
;                   However, if you want to repeteadly send commands/queries to
;                   a device, you should call this function followed by using the
;                   returned instrument handle instead of the VISA descriptor
;
;                   Do not forget to use _viClose when you are done, though
;
;===============================================================================

Func _viOpen($s_visa_address, $s_visa_secondary_address = 0)
  If IsNumber($s_visa_address) Or StringInStr($s_visa_address,"::") == 0 Then
    ; We passed a number => Create the VISA string:
    $s_visa_address = "GPIB0::" & $s_visa_address & "::" & $s_visa_secondary_address
  EndIf

  ;- Do not open an instrument connection twice
  ;- TODO

  ;- Make sure that there is a Resource Manager open (Note: this will NOT open it twice!)
  _viOpenDefaultRM()

  ;- Open the INSTRUMENT CONNECTION
  ; errStatus = viOpen (DEFAULT_RM, "GPIB0::20::0", VI_NULL, VI_NULL, &h_session);
  ; signed int viOpen(unsigned long, char*, unsigned long, unsigned long, *unsigned long)
  Local $v_results
  $v_results = DllCall("visa32.dll", "long","viOpen", "long", $DEFAULT_RM, "str",$s_visa_address, "long",$VI_NULL, "long",$VI_NULL,"long_ptr",-1)
  If @error <> 0 Then
    MsgBox(16,"_viOpen - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not open VISA instrument/resource: " & $s_visa_address)
    Return -1
  EndIf
  ; Make sure that the DllCall returned enough values
  If UBound($v_results) < 6 Then
    SetError(1)
    MsgBox(16,"VISA error","Call to viOpen did not return the right number of values")
    Return -1
  EndIf

  $h_session = $v_results[5]
  Return $h_session
EndFunc


;===============================================================================
;
; Description:      Closes a VISA connection to an Instrument/Device
; Syntax:           _viClose($h_session)
; Parameter(s):     $h_session - A VISA session handle (as returned by _viOpen)
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns a (POSITIVE) VISA Instrument Handle
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          For simple usage there is no need to use this function, as
;                   _viExecCommand automatically opens/closes a VISA connection
;                   if you pass it a VISA resource descriptor (see the NOTES of
;                   _viExecCommand above for more info)
;
;                   However, if you want to repeteadly send commands/queries to
;                   a device, you should use _viOpen followed by using the
;                   returned instrument handle instead of the VISA descriptor
;                   and then calling this function
;
;===============================================================================

Func _viClose($h_session)
  ;- Close INSTRUMENT Connection
  ; viClose(h_session);
  Local $v_results
  $v_results = DllCall("visa32.dll", "int","viClose", "int",$h_session)
  If @error <> 0 Then
    MsgBox(16,"_viClose - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not close VISA instrument/resource: " & $h_session)
    Return $errStatus
  EndIf
  Return 0
EndFunc


;===============================================================================
;
; Description:      Find all the DEVICES found in the GPIB bus
; Syntax:           _viFindGPIB(ByRef $v_descriptor_list, ByRef $v_idn_list, $b_show_search_results = 0)
; Parameter(s):     $v_descriptor_list - An array of the VISA resource descriptors
;                   (see the NOTES of _viExecCommand above for more info) of the
;                   instruments that were found in the GPIB bus
;                   $v_idn_list - An array of the IDNs (i.e names) of the
;                   instruments that were found in the GPIB bus
;                   $b_show_search_results - If 1 a message box showing the
;                   results of the search will be shown
;                   The default is 0, which means that the results are not shown
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - The number of instruments found (0 or more)
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          For simple usage there is no need to use this function, as
;                   _viExecCommand automatically opens/closes a VISA connection
;                   if you pass it a VISA resource descriptor (see the NOTES of
;                   _viExecCommand above for more info)
;
;                   However, if you want to repeteadly send commands/queries to
;                   a device, you should call this function followed by using the
;                   returned instrument handle instead of the VISA descriptor
;
;                   Do not forget to use _viClose when you are done, though
;
;===============================================================================

Func _viFindGPIB(ByRef $v_descriptor_list, ByRef $v_idn_list, $b_show_search_results = 0)
  ;- Make sure that there is a Resource Manager open (Note: this will NOT open it twice!)
  _viOpenDefaultRM()

  ; Create the GPIB instrument list and return the 1st instrument descriptor
  ; viStatus viFindRsrc (viSession, char*, *ViFindList, *ViUInt32, char*);
  ; errStatus = viFindRsrc (DEFAULT_RM, "GPIB?*INSTR", &h_current_instr, &num_matches, s_found_instr_descriptor);
  $v_results = DllCall("visa32.dll", "long","viFindRsrc", _
    "long", $DEFAULT_RM, "str","GPIB?*INSTR", "long_ptr",-1, _
    "int_ptr",-1, "str","")
  If @error <> 0 Then
    MsgBox(16,"_viFindGPIB - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not perform GPIB FIND operation")
    Return -1
  EndIf
  ; Make sure that the DllCall returned enough values
  If UBound($v_results) < 5 Then
    SetError(1)
    MsgBox(16,"VISA error","Call to viFindRsrc did not return the right number of values")
    Return -1
  EndIf

  ; Assign the outputs of the DllCall
  Local $h_list_pointer = $v_results[3] ; The pointer to the list of found instruments
  Local $num_instr = $v_results[4] ; The number of instruments that were found
  Local $s_first_descriptor = $v_results[5] ; The descriptor of the first instrument found
  If $num_instr < 1 Then ; No insturments were found
    If $b_show_search_results == 1 Then
      MsgBox(64,"GPIB search results","NO INSTRUMENTS FOUND in the GPIB bus")
    EndIf

    Return $num_instr
  EndIf

  ; At least 1 instrument was found
  ReDim $v_descriptor_list[$num_instr], $v_idn_list[$num_instr]
  $v_descriptor_list[0] = $s_first_descriptor
  ; Get the IDN of the 1st instrument
  $v_idn_list[0] = _viExecCommand($s_first_descriptor,"*IDN?")

  ; Get the IDN of all the remaining instruments
  For $n=1 To $num_instr-1
    ; If more than 1 instrument was found, get the handle of the next instrument
    ; and get its IDN

    ;- Get the handle and descriptor of the next instrument in the GPIB bus
    ; We do this by calling "viFindNext"
    ; viFindNext (*ViFindList, char*);
    ; viFindNext (h_current_instr,s_found_instr_descriptor);
    $v_results = DllCall("visa32.dll", "long","viFindNext", "long",$h_list_pointer, "str","")
    If @error <> 0 Then
      MsgBox(16,"_viFindGPIB - DllCall error","Could not open VISA (visa32.dll)")
      Return -1
    EndIf
    Local $errStatus = $v_results[0]
    If $errStatus <> 0 Then
      SetError(1)
      MsgBox(16,"VISA error","Could not perform GPIB FIND NEXT operation")
      Return -1
    EndIf
    ; Make sure that the DllCall returned enough values
    If UBound($v_results) < 3 Then
      SetError(1)
      MsgBox(16,"VISA error","Call to viFindNext did not return the right number of values")
      Return -1
    EndIf
    $v_descriptor_list[$n] = $v_results[2]
    $v_idn_list[$n] = _viExecCommand($v_descriptor_list[$n],"*IDN?")
  Next

  If $b_show_search_results == 1 Then
    $s_search_results = ""
    For $n=0 To $num_instr-1
      $s_search_results = $s_search_results & $v_descriptor_list[$n] & " - " & $v_idn_list[$n] & @CR
    Next
    MsgBox(64,"GPIB search results",$s_search_results)
  EndIf

  Return $num_instr

EndFunc


;===============================================================================
;- Internal VISA functions, used by _viExecCommand, _viOpen and/or _viClose ----
; The functions in this section are not meant to be called outside this library
; under normal use

;===============================================================================
;
; Description:      Open the VISA Resource Manager
; Syntax:           _viOpenDefaultRM()
; Parameter(s):     None
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - The Default Resource Manager Handle (also stored
;                   in the $DEFAULT_RM global)
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          You should not need to directly call this function under
;                   normal use as _viOpen calls it when necessary
;
;===============================================================================
Func _viOpenDefaultRM()
  If $DEFAULT_RM == -1 Then
    ; Only open the Resource Manager once (i.e. when $DEFAULT_RM is still -1)
    $h_visa_rm = $DEFAULT_RM ; Initialize the output result with the default value (-1)

    ; errStatus = viOpenDefaultRM (&DEFAULT_RM);
    ; signed int viOpenDefaultRM(*unsigned long)
    Local $v_results
    $v_results = DllCall("visa32.dll", "int","viOpenDefaultRM", "int_ptr",$DEFAULT_RM)
    If @error <> 0 Then
      MsgBox(16,"_viOpenDefaultRM - DllCall error","Could not open VISA (visa32.dll)")
      Return $h_visa_rm
    EndIf
    Local $errStatus = $v_results[0]
    If $errStatus <> 0 Then
      SetError(1)
      MsgBox(16,"VISA error","Could not create VISA Resource Manager")
      Return $h_visa_rm
    EndIf
    ; Everything went fine => Set the Resource Manager global
    $DEFAULT_RM = $v_results[1]
    If $DEFAULT_RM <= 0 Then
      ; There was an error, reset the $DEFAULT_RM
      SetError(1)
      Return $h_visa_rm
    EndIf
  EndIf
  $h_visa_rm = $DEFAULT_RM
  Return $h_visa_rm
EndFunc


;===============================================================================
;
; Description:      Send a COMMAND (NOT a QUERY) to an Instrument/Device
; Syntax:           _viPrintf($h_session, $s_command, $n_timeout_ms = -1)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session handle (INTEGER)
;                                Look at the _viExecCommand function for more
;                                details
;                   $s_command - Command/Query to execute.
;                                A query MUST contain a QUESTION MARK (?)
;                                When the command is a QUERY the function will
;                                automatically wait for the instrument's answer
;                                (or until the operation times out)
;                   $n_timeout_ms - The operation timeout in MILISECONDS
;                                This is mostly important for QUERIES only
;                                This is an OPTIONAL PARAMETER.
;                                If it is not specified the last set timeout will
;                                be used. If it was never set before the default
;                                timeout (which depends on the VISA implementation)
;                                will be used. Timeouts can also be set separatelly
;                                with the _viSetTiemout function (see below)
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns ZERO
;                   On Failure - Returns -1 if the VISA DLL could not be open
;                                or a NON ZERO value representing the VISA
;                                error code (see the VISA programmer's guide)
;                   This function always sets @error to 1 in case of error
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):
;                   Normally you do not need to use this function, 
;                   as _viExecCommand automatically choses between _viPrintf and
;                   _viQueryf depending on the command type.
;
;                   If you need to use it anyway, it is recommended that you do 
;                   not use this command for sending QUERIES, only for GPIB 
;                   commands that DO NOT RETURN AN ANSWER
;
;                   Also, this is not really a "PRINTF-like" function, as it 
;                   does not allow you to pass multiple parameters. This is only
;                   called _viPrintf because it uses the VISA function viPrintf
;
;                   See _viExecCommand for more details
;
;===============================================================================

Func _viPrintf($h_session, $s_command, $n_timeout_ms = -1)
  If IsString($h_session) Then
    ; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
    ; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
    ; session for the user.
    ; This is of course slower if you need to do more than one GPIB call but much
    ; more convenient for short tests
    $b_close_session_before_return = 1
    $h_session = _viOpen($h_session)
  Else
    $b_close_session_before_return = 0
  EndIf

  ;- Set the VISA timeout if necessary
  If $n_timeout_ms >= 0 Then
    _viSetTimeout($h_session, $n_timeout_ms)
  EndIf

  ;- Send Command to instrument
  ; errStatus = viPrintf (h_session, "%s", "*RST");
  ; signed int viPrintf (unsigned long, char*, char*);
  Local $v_results
  $v_results = DllCall("visa32.dll", "int","viPrintf", "int",$h_session, "str","%s", "str",$s_command)
  If @error <> 0 Then
    MsgBox(16,"_viPrintf - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not send command to VISA instrument/resource: " & $h_session)
    Return $errStatus
  EndIf

  If $b_close_session_before_return == 1 Then
    _viClose($h_session)
  EndIf
EndFunc


;===============================================================================
;
; Description:      Send a QUERY (a Command that returns an answer) to an Instrument/Device
; Syntax:           _viQueryf($h_session, $s_query, $n_timeout_ms = -1)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session handle (INTEGER)
;                                Look at the _viExecCommand function for more
;                                details
;                   $s_command - The query to execute (e.g. "*IDN?").
;                                A query MUST contain a QUESTION MARK (?)
;                                The function willautomatically wait for the 
;                                instrument's answer (or until the operation 
;                                times out)
;                   $n_timeout_ms - The operation timeout in MILISECONDS
;                                This is mostly important for QUERIES only
;                                This is an OPTIONAL PARAMETER.
;                                If it is not specified the last set timeout will
;                                be used. If it was never set before the default
;                                timeout (which depends on the VISA implementation)
;                                will be used. Timeouts can also be set separatelly
;                                with the _viSetTiemout function (see below)
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns the answer of the instrument to the QUERY
;                   On Failure - Returns an EMPTY String ("")
;                   This function always sets @error to 1 in case of error
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):
;                   Normally you do not need to use this function, 
;                   as _viExecCommand automatically choses between _viPrintf and
;                   _viQueryf depending on the command type.
;
;                   If you need to use it anyway, make sure that you use it for 
;                   a command that RETURNS an ANSWER or you will be stuck until 
;                   the Timeout expires, which could never happen if the Timeout
;                   is infinite ("INF")!
;
;                   Also, this is not really a "SCANF-like" function, as it 
;                   does not allow you to specify the format of the output
;
;                   See _viExecCommand for more details
;
;===============================================================================
Func _viQueryf($h_session, $s_query, $n_timeout_ms = -1)
  If IsString($h_session) Then
    ; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
    ; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
    ; session for the user.
    ; This is of course slower if you need to do more than one GPIB call but much
    ; more convenient for short tests
    $b_close_session_before_return = 1
    $h_session = _viOpen($h_session)
  Else
    $b_close_session_before_return = 0
  EndIf

  ;- Set the VISA timeout if necessary
  If $n_timeout_ms >= 0 Then
    _viSetTimeout($h_session, $n_timeout_ms)
  EndIf

  ;- Send QUERY to instrument and get ANSWER
  ; errStatus = viQueryf (h_session, "*IDN?\n", "%s", s_answer);
  ; signed int viQueryf (unsigned long, char*, char*, char*);
  ;errStatus = viQueryf (h_instr, s_command, "%s", string);
  Local $v_results, $s_answer = ""
  $v_results = DllCall("visa32.dll", "int","viQueryf", "int",$h_session, "str","*IDN?", "str","%s", "str", $s_answer)
  If @error <> 0 Then
    MsgBox(16,"_viQueryf - DllCall error","Could not open VISA (visa32.dll)")
    Return ""
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not query VISA instrument/resource: " & $h_session)
    Return ""
  EndIf
  ; Make sure that the DllCall returned enough values
  If UBound($v_results) < 5 Then
    SetError(1)
    MsgBox(16,"VISA error","Call to viQuery did not return the right number of values")
    Return ""
  EndIf
  $s_answer = $v_results[4]

  If $b_close_session_before_return == 1 Then
    _viClose($h_session)
  EndIf

  Return $s_answer
EndFunc


;- Misc VISA interface functions -----------------------------------------------

;===============================================================================
;
; Description:      Sets the VISA timeout in MILISECONDS (uses _viSetAttribute)
; Syntax:           _viSetTimeout($h_session, $n_timeout_ms)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session
;                   handle (INTEGER). Look the explanation in _viExecCommand
;                   (you can find it above)
;                   $n_timeout_ms - The timeout IN MILISECONDS for VISA operations
;                   (mainly for GPIB queries)
;                   If you set it to 0 the tiemouts are DISABLED
;                   If you set it to "Inf" the VISA operations will NEVER timeout.
;                   Be careful with this as it could easly hung your program if
;                   your instrument does not respond to one of your queries
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          You can avoid directly calling this function most of the time,
;                   as _viExecCommand accepts a timeout (in ms) as its 3rd argument.
;                   If you do not pass this 3rd argument then the previous timeout
;                   will be used (or the default timeout, which depends on the
;                   VISA driver, if it was never set before)
;
;===============================================================================
Func _viSetTimeout($h_session, $n_timeout_ms)
  If StringUpper(String($n_timeout_ms)) == "Inf" Then
    $n_timeout_ms = $VI_TMO_INFINITE
  EndIf
  Return _viSetAttribute($h_session, $VI_ATTR_TMO_VALUE, $n_timeout_ms)
EndFunc


;===============================================================================
;
; Description:      VISA attribute set (GENERIC)
;                   Called by _viSetTimeout, this function can be used to set
;                   many other VISA specific attributes. Look the VISA
;                   documentation for more information
; Syntax:           _viSetAttribute($h_session, $i_attribute, $i_value)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session
;                   handle (INTEGER). Look the explanation in _viExecCommand
;                   (you can find it above)
;                   $i_attribute - The index of the attribute that must be changed
;                   Attributes are defined in the VISA library. This AutoIt
;                   implementation only defines a CONSTANT for the TIMEOUT
;                   attribute ($VI_ATTR_TMO_VALUE) but you can pass any other
;                   index if you want to.
;                   $i_value - The value of the attribute. It must be an integer
;                   and the possible values depend on the attribute type
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          None
;
;===============================================================================
Func _viSetAttribute($h_session, $i_attribute, $i_value)
  ; errStatus = _viSetAttribute ($h_session, $VI_ATTR_TMO_VALUE, $timeout_value);
  ; signed int viGpibControlREN (unsigned long, int, int);
  Local $v_results
  $v_results = DllCall("visa32.dll", "int","viSetAttribute", "int",$h_session, "int", $i_attribute, "int",$i_value)
  If @error <> 0 Then
    MsgBox(16,"_viSetAttribute - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not set attribute of VISA instrument/resource: " & $h_session)
    Return $errStatus
  EndIf
  Return 0
EndFunc


;===============================================================================
;
; Description:      Go To Local mode (uses _viGpibControlREN)
;                   Instruments that accept this command will exit the "Remote
;                   Control mode" and go to "Local mode"
;                   If the instrument is already in "Local mode" this is simply
;                   ignored.
;                   Normally, if an instrument does not support this command it
;                   will simply stay in the "Remote Control mode"
; Syntax:           _viGTL($h_session)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session
;                   handle (INTEGER). Look the explanation in _viExecCommand
;                   (you can find it above)
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          None
;
;===============================================================================
Func _viGTL($h_session)
  Return _viGpibControlREN($h_session, $VI_GPIB_REN_ADDRESS_GTL)
EndFunc


;===============================================================================
;
; Description:      GPIB BUS "reset" (uses _viGpibControlREN)
;                   Use this function when the GPIB BUS gets stuck for some reason.
;                   You might be lucky and resolve the problem by calling this
;                   function
; Syntax:           _viGpibBusReset()
; Parameter(s):     None
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          None
;
;===============================================================================
Func _viGpibBusReset()
  If $DEFAULT_RM > 0 Then
    Return _viGpibControlREN($DEFAULT_RM, $VI_GPIB_REN_DEASSERT)
  Else
    Return 0
  EndIf
EndFunc


;===============================================================================
;
; Description:      Control the VISA REN bus line
; Syntax:           _viGpibControlREN ($h_session, $i_mode)
; Parameter(s):     $h_session - A VISA descriptor (STRING) OR a VISA session
;                   handle (INTEGER). Look the explanation in _viExecCommand
;                   (you can find it above)
;                   $i_mode - The mode into which the REN line of the GPIB bus
;                   will be set.
;                   Modes are defined in the VISA library. Look at the top of
;                   this file for valid modes
; Requirement(s):   The VISA libraries must be installed (you can check whether
;                   visa32.dll is in {WINDOWS}\system32)
;                   For GPIB communication a GPIB card (such as a National Instruments
;                   NI PCI-GPIB card or an Agilent 82350B PCI High-Performance GPIB card
; Return Value(s):  On Success - Returns 0
;                   On Failure - Returns -1 and SETS @error to 1
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          This function is used by _viGTL and _viGpibBusReset
;
;===============================================================================
Func _viGpibControlREN ($h_session, $i_mode)
  If IsString($h_session) Then
    ; When we pass a string, i.e. a VISA ID (like GPIB::20::0, for instance) instead
    ; of a VISA session handler, we will automatically OPEN and CLOSE the instrument
    ; session for the user.
    ; This is of course slower if you need to do more than one GPIB call but much
    ; more convenient for short tests
    $b_close_session_before_return = 1
    $h_session = _viOpen($h_session)
  Else
    $b_close_session_before_return = 0
  EndIf

  ; errStatus = viGpibControlREN ($h_session, VI_GPIB_REN_ASSERT);
  ; signed int viGpibControlREN (unsigned long, int);
  Local $v_results
  $v_results = DllCall("visa32.dll", "int","viGpibControlREN", "int",$h_session, "int", $i_mode)
  If @error <> 0 Then
    MsgBox(16,"_viGpibControlREN - DllCall error","Could not open VISA (visa32.dll)")
    Return -1
  EndIf
  Local $errStatus = $v_results[0]
  If $errStatus <> 0 Then
    SetError(1)
    MsgBox(16,"VISA error","Could not send to Local VISA instrument/resource: " & $h_session)
    Return $errStatus
  EndIf

  If $b_close_session_before_return == 1 Then
    _viClose($h_session)
  EndIf

  Return 0
EndFunc


;- Helper functions (debug, etc) -----------------------------------------------

;===============================================================================
;
; Description:      Display a debug message box
; Syntax:           _viDebugMsg($s_msg)
; Parameter(s):     $s_message - The STRING that will be shown
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Angel Ezquerra <ezquerra@gmail.com>
; Note(s):          This function is normally disabled and does nothing.
;                   It should only be enabled to debug the VISA library functions
;
;===============================================================================
Func _viDebugMsg($s_msg)
  MsgBox(0,"Debug",$s_msg)
EndFunc


;- Some example code that you can copy to test this library --------------------
; This is here only to let users easily test the GPIB capabilites of this library
; However it should be removed from here and put in the help file
#cs
  ; Example 1
  Dim $v_descriptor_list[1], $v_idn_list[1]
  _viFindGPIB($v_descriptor_list, $v_idn_list, 1)

  ; Example 2 - This assumes that you have instrument set to GPIB address 1
  Dim $h_session = 0
  ; Query the ID of the instrument in GPIB address 3
  MsgBox(0,"Step 1","Simple GPIB query using a VISA Descriptor")
  Dim $s_answer = _viExecCommand("GPIB::1::0","*IDN?",10)
  MsgBox(0,"GPIB QUERY result",$s_answer) ; Show the answer
  MsgBox(0,"Step 2","Go to LOCAL using VISA Descriptor")
  _viGTL("GPIB::1::0") ; Go to local (exit remote control mode)
  MsgBox(0,"Step 3","Simple GPIB query using a VISA address shortcut")
  $s_answer = _viExecCommand("1","*IDN?") ; The address MUST BE A STRING
  MsgBox(0,"GPIB QUERY result",$s_answer) ; Show the answer
  MsgBox(0,"Info","Now let's use _viOpen and _viClose")
  MsgBox(0,"Step 4","Open the instrument connection with _viOpen")
  Dim $h_instr = _viOpen(1)
  MsgBox(0,"Instrument Handle obtained", "$h_instr = " & $h_instr) ; Show the Session Handle
  ; Query the instrument
  MsgBox(0,"Step 5","Query the instrument using the VISA instrument handle")
  $s_answer = _viExecCommand($h_instr,"*IDN?") ; $h_instr is NOT A STRING now!
  MsgBox(0,"GPIB QUERY result",$s_answer) ; Show the answer
  ; Query again. There is no need to OPEN the link again
  MsgBox(0,"Step 6","Query again. There is no need to OPEN the link again")
  $s_answer = _viExecCommand($h_instr,"*IDN?")
  MsgBox(0,"GPIB QUERY result",$s_answer) ; Show the answer
  MsgBox(0,"Step 7","Go to LOCAL using VISA instrument handle")
  _viGTL($h_instr); Go to local (this is optional)
  MsgBox(0,"Step 8","Close the Instrument connection")
  _viClose($h_instr) ; Close the instrument connection
#ce


;- This is the actual C code for the VISA interface, from which the DllCall
; syntax was infered
; This is only here as a reference during debug and should be removed in the
; final version
#cs
  // First some typedefs and #defines required to understand the function prototypes
  typedef unsigned long       ViUInt32;
  typedef ViUInt32            ViObject;
  typedef ViObject            ViSession;
  typedef ViObject            ViFindList;
  typedef ViUInt32            ViAccessMode;
  typedef signed long         ViInt32;
  typedef ViInt32             ViStatus;

  #define VI_NULL             (0)

  // Then the function prototypes themselves

  viStatus viOpenDefaultRM (*viSession); // => signed int viOpenDefaultRM(*unsigned long)
  viStatus viOpen (viSession, char*, viAccessMode, ViUInt32, *viSession); // => signed int viOpen(unsigned long, char*, unsigned long, unsigned long, *unsigned long)
  viStatus viQueryf (viSession, char*, char*, ...); // => like fprintf(fid, command, format_string, params...)
  viStatus viClose(viSession);
  viStatus viFindRsrc (viSession, char*, *ViFindList, *ViUInt32, char*);
  errStatus = viFindRsrc (DEFAULT_RM, "GPIB?*INSTR", &h_current_instr, &num_matches, s_found_instr_descriptor);
  viFindNext (*ViFindList, char*);
  viFindNext (h_current_instr,s_found_instr_descriptor);

  // And the example code
  int h_session;
  char s_answer[255], s_first_descriptor[255];
  errStatus = viOpenDefaultRM (&DEFAULT_RM);
  errStatus = viOpen (DEFAULT_RM, "GPIB0::1::0", VI_NULL, VI_NULL, &h_session);
  errStatus = viQueryf (int_ret, "*IDN?\n", "%s", s_answer);
  viClose(int_ret);
#ce
