#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include <array.au3>
; trying to use windows api for making a shadowcopy set of drive C
;
Const $VSS_OBJECT_UNKNOWN       = 0
Const $VSS_OBJECT_NONE          = 1
Const $VSS_OBJECT_SNAPSHOT_SET  = 2
Const $VSS_OBJECT_SNAPSHOT      = 3
Const $VSS_OBJECT_PROVIDER      = 4
Const $VSS_OBJECT_TYPE_COUNT    = 5


Const	$VSS_E_BAD_STATE					= 0x80042301
Const	$VSS_E_PROVIDER_ALREADY_REGISTERED	= 0x80042303
Const	$VSS_E_PROVIDER_NOT_REGISTERED		= 0x80042304
Const	$VSS_E_PROVIDER_VETO				= 0x80042306
Const	$VSS_E_PROVIDER_IN_USE				= 0x80042307
Const	$VSS_E_OBJECT_NOT_FOUND				= 0x80042308
Const	$VSS_E_VOLUME_NOT_SUPPORTED			= 0x8004230c
Const	$VSS_E_VOLUME_NOT_SUPPORTED_BY_PROVIDER	= 0x8004230e
Const	$VSS_E_OBJECT_ALREADY_EXISTS				= 0x8004230d
Const	$VSS_E_UNEXPECTED_PROVIDER_ERROR			= 0x8004230f
Const	$VSS_E_CORRUPT_XML_DOCUMENT				= 0x80042310
Const	$VSS_E_INVALID_XML_DOCUMENT				= 0x80042311
Const	$VSS_E_MAXIMUM_NUMBER_OF_VOLUMES_REACHED	= 0x80042312
Const	$VSS_E_FLUSH_WRITES_TIMEOUT				= 0x80042313
Const	$VSS_E_HOLD_WRITES_TIMEOUT				= 0x80042314
Const	$VSS_E_UNEXPECTED_WRITER_ERROR			= 0x80042315
Const	$VSS_E_SNAPSHOT_SET_IN_PROGRESS			= 0x80042316
Const	$VSS_E_MAXIMUM_NUMBER_OF_SNAPSHOTS_REACHED	= 0x80042317
Const	$VSS_E_WRITER_INFRASTRUCTURE					= 0x80042318
Const	$VSS_E_WRITER_NOT_RESPONDING					= 0x80042319
Const	$VSS_E_WRITER_ALREADY_SUBSCRIBED				= 0x8004231a
Const	$VSS_E_UNSUPPORTED_CONTEXT					= 0x8004231b
Const	$VSS_E_VOLUME_IN_USE							= 0x8004231d
Const	$VSS_E_MAXIMUM_DIFFAREA_ASSOCIATIONS_REACHED	= 0x8004231e
Const	$VSS_E_INSUFFICIENT_STORAGE					= 0x8004231f
Const	$VSS_E_NO_SNAPSHOTS_IMPORTED					= 0x80042320
Const	$VSS_S_SOME_SNAPSHOTS_NOT_IMPORTED			= 0x42321
Const	$VSS_E_MAXIMUM_NUMBER_OF_REMOTE_MACHINES_REACHED	= 0x80042322
Const	$VSS_E_REMOTE_SERVER_UNAVAILABLE					= 0x80042323
Const	$VSS_E_REMOTE_SERVER_UNSUPPORTED					= 0x80042324
Const	$VSS_E_REVERT_IN_PROGRESS						= 0x80042325
Const	$VSS_E_REVERT_VOLUME_LOST						= 0x80042326
Const	$VSS_E_REBOOT_REQUIRED							= 0x80042327


Const $VSS_S_ASYNC_PENDING		= 0x00042309
Const $VSS_S_ASYNC_FINISHED		= 0x0004230a
Const $VSS_S_ASYNC_CANCELLED	= 0x0004230b


#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>


Local $iEventError = 0 ; to be checked to know if com error occurs. Must be reset after handling.
$oMyError = ObjEvent("AutoIt.Error", "ErrFunc") ; Install a custom error handler

Local $hVSS = DllOpen("c:\windows\system32\vssapi.dll")
Local $aResult

$aResult = DllCall($hVSS, "handle", "CreateVssBackupComponentsInternal", "ptr*", 0)
ConsoleWrite("CreateVssBackupComponentsInternal: " & @error & "   " & $aResult[0] & "  " & $aResult[1] & @CRLF)

Local $pIVssBackupComponents = $aResult[1]

Local $VolumeD = DllStructCreate("wchar[250]")
DllStructSetData($VolumeD, 1, "d:\")
Local $pVolumeD = DllStructGetPtr($VolumeD)

Local $GUID_NULL = DllStructCreate("byte[16]")
DllStructSetData($GUID_NULL, 1, _WinAPI_GUIDFromString("00000000-0000-0000-0000-000000000000"))

Local $pAsync  ; pointer to Async interface
Local $HResult = DllStructCreate("int64")
Local $pHResult = DllStructGetPtr($HResult)

Local $SetIdentifier = DllStructCreate($tagGUID)
Local $pSI = DllStructGetPtr($SetIdentifier)
Local $ID_D = DllStructCreate($tagGUID)
Local $pID_D = DllStructGetPtr($ID_D)
Local $ID_J = DllStructCreate($tagGUID)
Local Const $sIID_IVssBackupComponents = "{665C1D5F-C218-414D-A05D-7FEF5F9D5C86}"
Local Const $dtag_IVssBackupComponents = _
  "GetWriterComponentsCount hresult();" & _  ; <-- Add parameters for all methods
  "GetWriterComponents hresult();" & _
  "InitializeForBackup hresult(ptr);" & _   ; <-- InitializeForBackup
  "SetBackupState hresult(boolean; boolean; int; boolean);" & _
  "InitializeForRestore hresult();" & _
  "SetRestoreState hresult();" & _
  "GatherWriterMetadata hresult(ptr*);" & _
  "GetWriterMetadataCount hresult();" & _
  "GetWriterMetadata hresult();" & _
  "FreeWriterMetadata hresult();" & _
  "AddComponent hresult();" & _
  "PrepareForBackup hresult(ptr*);" & _
  "AbortBackup hresult();" & _
  "GatherWriterStatus hresult(ptr*);" & _
  "GetWriterStatusCount hresult();" & _
  "FreeWriterStatus hresult();" & _
  "GetWriterStatus hresult();" & _
  "SetBackupSucceeded hresult();" & _
  "SetBackupOptions hresult();" & _
  "SetSelectedForRestore hresult();" & _
  "SetRestoreOptions hresult();" & _
  "SetAdditionalRestores hresult();" & _
  "SetPreviousBackupStamp hresult();" & _
  "SaveAsXML hresult();" & _
  "BackupComplete hresult();" & _
  "AddAlternativeLocationMapping hresult();" & _
  "AddRestoreSubcomponent hresult();" & _
  "SetFileRestoreStatus hresult();" & _
  "AddNewTarget hresult();" & _
  "SetRangesFilePath hresult();" & _
  "PreRestore hresult();" & _
  "PostRestore hresult();" & _
  "SetContext hresult(long);" & _
  "StartSnapshotSet hresult(ptr);" & _
  "AddToSnapshotSet hresult(wstr; uint64;uint64; ptr);" & _
  "DoSnapshotSet hresult(ptr*);" & _
  "DeleteSnapshots hresult();" & _
  "ImportSnapshots hresult();" & _
  "BreakSnapshotSet hresult();" & _
  "GetSnapshotProperties hresult();" & _
  "Query hresult();" & _
  "IsVolumeSupported hresult();" & _
  "DisableWriterClasses hresult();" & _
  "EnableWriterClasses hresult();" & _
  "DisableWriterInstances hresult();" & _
  "ExposeSnapshot hresult();" & _
  "RevertToSnapshot hresult();" & _
  "QueryRevertStatus hresult();"


$oIVssBackupComponents = ObjCreateInterface( $pIVssBackupComponents, $sIID_IVssBackupComponents, $dtag_IVssBackupComponents )
If IsObj( $oIVssBackupComponents ) Then
	  ConsoleWrite( "$oIVssBackupComponents OK" & @CRLF )
	  $iResult = $oIVssBackupComponents.InitializeForBackup(0)
		If $iResult Then
		  ConsoleWrite("error Initializing (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("Initializing done." & @CRLF)
		EndIf

	  $iResult = $oIVssBackupComponents.SetBackupState(0, 0, 1, 0)
		If $iResult Then
		  ConsoleWrite("error setting backup state (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("setting backup state done." & @CRLF)
		EndIf

	  $iResult = $oIVssBackupComponents.GatherWriterMetadata($pAsync)
		If $iResult Then
		  ConsoleWrite("error calling GatherWriterMetadata (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("calling GatherWriterMetadata done. $pAsync: " & Ptr($pAsync) & @CRLF)
		EndIf


	; creating Async interface
	;~ Local Const $sIID_IVssAsync = "{C7B98A22-222D-4e62-B875-1A44980634AF}"   ; Windows XP/2003!
	Local Const $sIID_IVssAsync = "{507C37B4-CF5B-4e95-B0AF-14EB9767467E}"
	Local Const $dtag_IVssAsync = _
		"Cancel hresult();" & _
		"Wait hresult(dword);" & _   		    ; Read the docu about parameters
		"QueryStatus hresult(hresult*; int*);"	; Read the docu about parameters

	Local $oIVssAsync = ObjCreateInterface( $pAsync, $sIID_IVSSAsync, $dtag_IVssAsync )
		If IsObj( $oIVssAsync ) Then
		  ConsoleWrite( "$oIVssAsync OK" & @CRLF )
		Else
		  ConsoleWrite( "$oIVssAsync ERR" & @CRLF )
		EndIf

	; waiting for the asynchronous operation to finish
	Local $pDummy
	ConsoleWrite("waiting for asynchronous operation to finish ")
	Do
		ConsoleWrite(".")
		$oIVssAsync.QueryStatus($pDummy, 0)
		Sleep(10)
	Until "0x" & Hex($pDummy) <> $VSS_S_ASYNC_PENDING
	ConsoleWrite(@CRLF & "Status:" & "0x" & Hex($pDummy) & @CRLF)

	  $iResult = $oIVssBackupComponents.SetContext(BitOR(1,8,10))
		If $iResult Then
		  ConsoleWrite("error setting context (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("setting context done." & @CRLF)
		EndIf

	  $iResult = $oIVssBackupComponents.StartSnapshotSet($pSI)
		If $iResult > 0 Then
		  ConsoleWrite("error starting snapshot set (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
	  Else
;~ 			ConsoleWrite("SI pointer: " & Ptr($pSI) & @CRLF)
			ConsoleWrite("starting snapshot set done. ( " & _WinAPI_StringFromGUID(DllStructGetPtr($SetIdentifier,1)) & " )" & @CRLF)
		EndIf

	Local $tElem = DllStructCreate("uint64[2];", DllStructGetPtr($GUID_NULL))
	  $iResult = $oIVssBackupComponents.AddToSnapshotSet("c:\", DllStructGetData($tElem, 1, 1), DllStructGetData($tElem, 1, 2), $pID_D)
		If $iResult Then
		  ConsoleWrite("error adding " & "c:\" & " to snapshot set (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("adding " & "c:\" & " to snapshot set done." & " (" & _WinAPI_StringFromGUID(DllStructGetPtr($ID_D,1)) & ")" & @CRLF)
		EndIf
	  $iResult = $oIVssBackupComponents.AddToSnapshotSet("d:\", DllStructGetData($tElem, 1, 1), DllStructGetData($tElem, 1, 2), $pID_D)
		If $iResult Then
		  ConsoleWrite("error adding " & "d:\" & " to snapshot set (" & Hex($iResult) & ")" & @CRLF)
		  Exit(1)
		Else
			ConsoleWrite("adding " & "d:\" & " to snapshot set done." & " (" & _WinAPI_StringFromGUID(DllStructGetPtr($ID_D,1)) & ")" & @CRLF)
		EndIf

	; Call

	$iResult = $oIVssBackupComponents.PrepareForBackup( $pAsync )
		ConsoleWrite("PrepareForBackup return: " & Hex($iResult) & @CRLF)
		ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		If $pAsync Then
		  ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		Else
		  ConsoleWrite( "$pAsync ERR" & @CRLF )
		  Exit
		EndIf


	$oIVssAsync = ObjCreateInterface( $pAsync, $sIID_IVSSAsync, $dtag_IVssAsync )
		If IsObj( $oIVssAsync ) Then
		  ConsoleWrite( "$oIVssAsync OK" & @CRLF )
		Else
		  ConsoleWrite( "$oIVssAsync ERR" & @CRLF )
		EndIf

	ConsoleWrite("waiting for asynchronous operation to finish ")
	Do
		ConsoleWrite(".")
		$oIVssAsync.QueryStatus($pDummy, 0)
		Sleep(10)
	Until "0x" & Hex($pDummy) <> $VSS_S_ASYNC_PENDING
	ConsoleWrite(@CRLF & "Status:" & "0x" & Hex($pDummy) & @CRLF)


		$iResult = $oIVssBackupComponents.GatherWriterStatus( $pAsync )
	ConsoleWrite("GatherWriterStatus return: " & Hex($iResult) & @CRLF)
	ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		If $pAsync Then
		  ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		Else
		  ConsoleWrite( "$pAsync ERR" & @CRLF )
		  Exit
		EndIf


	$oIVssAsync = ObjCreateInterface( $pAsync, $sIID_IVSSAsync, $dtag_IVssAsync )
		If IsObj( $oIVssAsync ) Then
		  ConsoleWrite( "$oIVssAsync OK" & @CRLF )
		Else
		  ConsoleWrite( "$oIVssAsync ERR" & @CRLF )
		EndIf

	ConsoleWrite("waiting for asynchronous operation to finish ")
	Do
		ConsoleWrite(".")
		$oIVssAsync.QueryStatus($pDummy, 0)
		Sleep(10)
	Until "0x" & Hex($pDummy) <> $VSS_S_ASYNC_PENDING
	ConsoleWrite(@CRLF & "Status:" & "0x" & Hex($pDummy) & @CRLF)



	$iResult = $oIVssBackupComponents.DoSnapshotSet( $pAsync )
	ConsoleWrite("DoSnapshotSet return: " & Hex($iResult) & @CRLF)
	ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		If $pAsync Then
		  ConsoleWrite( "$pAsync = " & Ptr( $pAsync ) & @CRLF )
		Else
		  ConsoleWrite( "$pAsync ERR" & @CRLF )
		  Exit
		EndIf


	$oIVssAsync = ObjCreateInterface( $pAsync, $sIID_IVSSAsync, $dtag_IVssAsync )
		If IsObj( $oIVssAsync ) Then
		  ConsoleWrite( "$oIVssAsync OK" & @CRLF )
		Else
		  ConsoleWrite( "$oIVssAsync ERR" & @CRLF )
		EndIf

	ConsoleWrite("waiting for asynchronous operation to finish ")
	Do
		ConsoleWrite(".")
		$oIVssAsync.QueryStatus($pDummy, 0)
		Sleep(10)
	Until "0x" & Hex($pDummy) <> $VSS_S_ASYNC_PENDING
	ConsoleWrite(@CRLF & "Status:" & "0x" & Hex($pDummy) & @CRLF)

Else
  ConsoleWrite( "$oIVssBackupComponents ERR" & @CRLF )
EndIf






; This is a custom error handler
Func ErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    MsgBox(0, "", "We intercepted a COM Error !" & @CRLF & _
            "Number is: " & $HexNumber & @CRLF & _
            "WinDescription is: " & $oMyError.windescription)
    $iEventError = 1 ; Use to check when a COM Error occurs
EndFunc   ;==>ErrFunc
