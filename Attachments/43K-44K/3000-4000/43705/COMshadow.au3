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
; trying to use windows api for making a shadowcopy set of drive D and J
;
Const $VSS_OBJECT_UNKNOWN       = 0
Const $VSS_OBJECT_NONE          = 1
Const $VSS_OBJECT_SNAPSHOT_SET  = 2
Const $VSS_OBJECT_SNAPSHOT      = 3
Const $VSS_OBJECT_PROVIDER      = 4
Const $VSS_OBJECT_TYPE_COUNT    = 5

;~ Local $hVSS = DllOpen(@ScriptDir & "\sources\win7\x86\vssapi.dll")
;~ Local $hVSS = DllOpen("c:\windows\system32\vssapi.dll")
;~ If @error Then
;~ 	ConsoleWrite("error opening dll" & @CRLF)
;~ 	Exit
;~ EndIf

#cs
Local $ppComponent

Local $aResult

$aResult = DllCall($hVSS, "handle", "CreateVssBackupComponentsInternal", "ptr*", $ppComponent)
_ArrayDisplay($aResult)
If IsArray Then
	ConsoleWrite("CreateVssBackupComponentsInternal done!" & @CRLF)
Else
	ConsoleWrite("error " & @error & " when CreateVssBackupComponentsInternal" & @CRLF)
EndIf
#ce
#cs
Local $oResult
Local $iID
Local $pSetID

Local $oShadow = ObjGet("winmgmts:\\.\root\cimv2:Win32_ShadowCopy")
If Not @error Then ConsoleWrite("ShadowCopy COM Object retrieved." & @CRLF)

$oResult = $oShadow.Create("j:\", "ClientAccessible", $iID)

;~ ConsoleWrite("create shadowcopy of J: with result " & $oResult.Properties_[1].Value & @CRLF)
ConsoleWrite($iID & @CRLF)
#ce




#cs
ConsoleWrite(ObjName(DllStructGetData($obj, 1)) & @CRLF)

;~ Local $iResult = $ppComponent.InitializeForBackup()
;~ ConsoleWrite("Initialize: " & $iResult & @CRLF)


;~ Local $oShadow = ObjGet($obj)
If Not @error Then
	ConsoleWrite("ShadowCopy COM Object retrieved." & @CRLF)
Else
	ConsoleWrite(@error & @CRLF)
EndIf
#ce

#cs


S_OK Operation successful 0x00000000



E_ABORT Operation aborted 0x80004004



E_ACCESSDENIED General access denied error 0x80070005



E_FAIL Unspecified failure 0x80004005



E_HANDLE Handle that is not valid 0x80070006



E_INVALIDARG One or more arguments are not valid 0x80070057



E_NOINTERFACE No such interface supported 0x80004002



E_NOTIMPL Not implemented 0x80004001



E_OUTOFMEMORY Failed to allocate necessary memory 0x8007000E



E_POINTER Pointer that is not valid 0x80004003



E_UNEXPECTED Unexpected failure 0x8000FFFF
#ce
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <WinAPI.au3>



Global $iEventError = 0 ; to be checked to know if com error occurs. Must be reset after handling.
$oMyError = ObjEvent("AutoIt.Error", "ErrFunc") ; Install a custom error handler

Local $hVSS = DllOpen("c:\windows\system32\vssapi.dll")
Local $aResult

$aResult = DllCall($hVSS, "handle", "CreateVssBackupComponentsInternal", "ptr*", 0)
ConsoleWrite("CreateVssBackupComponentsInternal: " & @error & "   " & $aResult[0] & "  " & $aResult[1] & @CRLF)

Local $pIVssBackupComponents = $aResult[1]

Global $VolumeD = DllStructCreate("wchar[250]")
DllStructSetData($VolumeD, 1, "d:\")
Global $pVolumeD = DllStructGetPtr($VolumeD)

Global $GUID_NULL = DllStructCreate("byte[16]")
DllStructSetData($GUID_NULL, 1, _WinAPI_GUIDFromString("00000000-0000-0000-0000-000000000000"))
ConsoleWrite(_WinAPI_StringFromGUID(DllStructGetPtr($GUID_NULL)) & @CRLF)
;~ Exit

Global $SetIdentifier = DllStructCreate($tagGUID)
Local $pSI = DllStructGetPtr($SetIdentifier)
Global $ID_D = DllStructCreate("byte[16]")
Global $pID_D = DllStructGetPtr($ID_D)
Global $ID_J = DllStructCreate($tagGUID)
Global $ppAsync = DllStructCreate("ptr*")
Global Const $sIID_IVssBackupComponents = "{665C1D5F-C218-414D-A05D-7FEF5F9D5C86}"
Global Const $dtag_IVssBackupComponents = _
  "GetWriterComponentsCount hresult();" & _  ; <-- Add parameters for all methods
  "GetWriterComponents hresult();" & _
  "InitializeForBackup hresult(ptr);" & _   ; <-- InitializeForBackup
  "SetBackupState hresult(boolean; boolean; int; boolean);" & _
  "InitializeForRestore hresult();" & _
  "SetRestoreState hresult();" & _
  "GatherWriterMetadata hresult();" & _
  "GetWriterMetadataCount hresult();" & _
  "GetWriterMetadata hresult();" & _
  "FreeWriterMetadata hresult();" & _
  "AddComponent hresult();" & _
  "PrepareForBackup hresult();" & _
  "AbortBackup hresult();" & _
  "GatherWriterStatus hresult();" & _
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
  "AddToSnapshotSet hresult(wstr; byte[16]; ptr);" & _
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
		ConsoleWrite("SI pointer: " & Ptr($pSI) & @CRLF)
		ConsoleWrite("starting snapshot set done. ( " & _WinAPI_StringFromGUID(DllStructGetPtr($SetIdentifier,1)) & " )" & @CRLF)
	EndIf

  $iResult = $oIVssBackupComponents.AddToSnapshotSet("D:\\", DllStructGetData($GUID_NULL,1), $pID_D)
	If $iResult Then
	  ConsoleWrite("error adding d:\ to snapshot set (" & Hex($iResult) & ")" & @CRLF)
	  Exit(1)
	Else
		ConsoleWrite("adding d:\ to snapshot set done." & " (" & DllStructGetData($ID_D,1) & ")" & @CRLF)
	EndIf
Exit
;~   $iResult = $oIVssBackupComponents.AddToSnapshotSet("j:\", "{00000000-0000-0000-0000-000000000000}", DllStructGetPtr($ID_J))
;~ 	If $iResult Then
;~ 	  ConsoleWrite("error adding j:\ to snapshot set (" & Hex($iResult) & ")" & @CRLF)
;~ 	  Exit(1)
;~ 	Else
;~ 		ConsoleWrite("adding j:\ to snapshot set done." & " (" & DllStructGetData($ID_J,1) & ")" & @CRLF)
;~ 	EndIf

  $iResult = $oIVssBackupComponents.DoSnapshotSet(DllStructGetPtr($ppAsync))
	If $iResult Then
	  ConsoleWrite("error doing snapshot set (" & Hex($iResult) & ")" & @CRLF)
	  Exit(1)
	Else
		ConsoleWrite("doing snapshot set done." & @CRLF)
	EndIf




;~   $oIVssBackupComponents.StartSnapshotSet( DllStructGetPtr($SetIdentifier,1) )
  ConsoleWrite("SetIdentifier: " & DllStructGetData($SetIdentifier, 1) & @CRLF)

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
