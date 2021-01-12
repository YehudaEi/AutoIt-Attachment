;;
;; Ask_TargetDisk.au3
;;
;; Asks the user to select a physical harddisk. This is used by the Image Coordinator
;; to identify the disk that is to be formatted and then imaged.
;;

#include-once
;#include "IC_Globals.au3"

#include <GUIConstants.au3>
#include <Constants.au3>
#include <Misc.au3>

#include "diskpart.au3"

MsgBox( 0, "", Ask_TargetDisk() )

;;
;; Function     : Ask_TargetDisk
;; Description  : Displays a selection GUI containing the current disks available in
;;                the system and asks the user to choose one.
;; Parameters   : None
;; Returns      : Success   : diskpart disk number of the selected disk
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 0  = Script error
;;                            1  = User aborted operation
;;                            2  = Diskpart failed in some way, unable to obtain necessary disk information
;;                            3  = Diskpart did not report any disks!
;;
Func Ask_TargetDisk()

    Local $GUI = GUICreate("Select Target Disk", 690, 320, -1, -1, BitOR($WS_CAPTION,$WS_BORDER,$WS_CLIPSIBLINGS))
    
    Local $cboTargetDisk = GUICtrlCreateCombo("", 8, 8, 673, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
    GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")
    GUICtrlSetData(-1, "")
    
    Local $txtDiskDetails = GUICtrlCreateEdit("", 8, 32, 673, 236, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
    GUICtrlSetFont(-1, 10, 400, 0, "Courier New")
    
    Local $btnAbort = GUICtrlCreateButton("Abort", 8, 272, 75, 40 )
    Local $btnContinue = GUICtrlCreateButton("Continue", 608, 272, 75, 40 )
    
    Local $diskList, $diskDetails, $diskListArray, $diskWithFocus = 1
    If Not Ask_TargetDisk_GetSystemDiskConfiguration( $diskList, $diskDetails ) > 0 Then
        GUIDelete( $GUI )
        Return _Iif( @error, SetError( 1, 2, -1 ), SetError( 1, 3, -1 ))
    EndIf
    
    $diskListArray = StringSplit( $diskList, "|" )
    If $diskListArray[0] > 0 Then
        GUICtrlSetData( $cboTargetDisk, $diskList, $diskListArray[$diskWithFocus] )
        GUICtrlSetData( $txtDiskDetails, $diskDetails[$diskWithFocus - 1] )
        GUICtrlSetState( $cboTargetDisk, $GUI_FOCUS )
    Else
        GUIDelete( $GUI )
        Return SetError( 1, 3, -1 )  ; returns an invalid disk number on error
    EndIf
    
    ;_ShowModalGui( $GUI )
    GUISetState( @SW_SHOW )

    Local $rc = 0, $ec = 0, $xc = 0
    While 1
        
        Local $msg = GUIGetMsg()
        Switch $msg
            Case $btnAbort, $GUI_EVENT_CLOSE
                $rc = -1
                $ec = 1
                $xc = 1
                ExitLoop
        
            Case $btnContinue
                Local $m = StringRegExp( GUICtrlRead( $cboTargetDisk ), "(?i)^[ ]*Disk (\d+)", 1 )
                If @error Then
                    $rc = -1
                    $ec = 1
                    $xc = 0
                    ExitLoop
                Else
                    $rc = Int($m[0])
                    $ec = 0
                    $xc = 0
                    ExitLoop
                EndIf
                
            Case $cboTargetDisk
                Local $cboText = GUICtrlRead( $cboTargetDisk )
                For $i = 1 To $diskListArray[0]
                    If StringLeft( $cboText, 10 ) = StringLeft( $diskListArray[$i], 10 ) Then
                        If $diskWithFocus = $i Then 
                            ExitLoop
                        Else
                            $diskWithFocus = $i
                            GUICtrlSetData( $txtDiskDetails, $diskDetails[$diskWithFocus - 1] )
                        EndIf
                    EndIf
                Next
        
        EndSwitch
    WEnd
    
    ;_HideModalGui()
    GUISetState( @SW_HIDE )
    GUIDelete( $GUI )
    Return SetError( $ec, $xc, $rc )
EndFunc

;;
;; Function     : Ask_TargetDisk_GetSystemDiskConfiguration
;; Description  : Uses the Diskpart Automation API to retrieve a list of physcial disks
;;                currently installed in the system for use by the Ask_TargetDisk gui.
;; Parameters   : $cboDisks   - List of disks formated for use in a combo box
;;                $cboDetails - Array of configuration details for each system disk
;; Returns      : Success   : number of entries in $cboDisks and $cboDetails
;;                @ERROR    : 0  = Success
;;                          : 1  = Failure
;;                @EXTENDED : 0  = Script error
;;                            2  = Diskpart failed in some way, unable to obtain necessary disk information
;;
Func Ask_TargetDisk_GetSystemDiskConfiguration( ByRef $cboDisks, ByRef $cboDetails )
    
    Local $myDisks, $diskCount, $diskDetails
    Local $myVolumes, $volumeCount
    Local $myPartitions, $partitionCount
    Local $pid, $version
    
    Local $tmpList = "", $tmpDetails[63] = [""], $emptyDetailArray[1] = [""]
    
    $cboDisks = ""
    $cboDetails = $emptyDetailArray
    
    ProgressOn( "Reading Disk Configuration", "Please wait...", "", -1, -1 )
    ProgressSet( 0, "Starting diskpart utility..." )
    _DiskpartStartConsole( $pid, $version )
    If @error Then
        ProgressOff()
        Return SetError( 1, 2, 0 )
    EndIf

    ProgressSet( 10, "Getting list of disks in system...", "Diskpart v" & $version )
    $diskCount = _DiskpartListDisks( $pid, $myDisks )
    If @error Then 
        ProgressOff()
        _DiskpartCloseConsole( $pid )
        Return SetError( 1, 2, 0 )
    EndIf
    
    For $d = 0 To $diskCount - 1

        ProgressSet( 20 + $d, "Reading disk " & $myDisks[$d][0] & " configuration..." )

        _DiskpartSelectDisk( $pid, $myDisks[$d][0] )
        If @error Then 
            ProgressOff()
            _DiskpartCloseConsole( $pid )
            Return SetError( 1, 2, 0 )
        EndIf
        
        $volumeCount = _DiskpartDetailDisk( $pid, $diskDetails, $myVolumes )
        If @error Then 
            ProgressOff()
            _DiskpartCloseConsole( $pid )
            Return SetError( 1, 2, 0 )
        EndIf

        $tmpList &= _Iif( $d > 0, "|", "" )
        $tmpList &= "Disk " & $myDisks[$d][0] & " (ID: " & $diskDetails[1] & ", Type: " & $diskDetails[2] & ", " & $diskDetails[0] & ")"
        $tmpDetails[$d] = "Details for disk " & $myDisks[$d][0] & " (ID: " & $diskDetails[1] & ", Type: " & $diskDetails[2] & ", " & $diskDetails[0] & ")" & @CRLF

        If $volumeCount > 0 Then
            
            For $v = 0 To $volumeCount - 1
                
                ProgressSet( 20 + $d + $v, "Reading disk " & $myDisks[$d][0] & ", volume " & $myVolumes[$v][0] & " configuration..." )

                $tmpDetails[$d] &= @CRLF & StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s", "Volume ###", "Ltr", "Label", "Fs", "Type", "Size", "Status", "Info" ) & @CRLF
                $tmpDetails[$d] &=  "  ----------  ---  -----------  -----  ----------  -------  ---------  --------" & @CRLF 
                $tmpDetails[$d] &= StringFormat( "  %-10s  %-3s  %-11s  %-5s  %-10s  %7s  %-9s  %-8s",  _
                                                 "Volume " & $myVolumes[$v][0], $myVolumes[$v][1], $myVolumes[$v][2], _
                                                 $myVolumes[$v][3], $myVolumes[$v][4], $myVolumes[$v][5], _
                                                 $myVolumes[$v][6], $myVolumes[$v][7] ) & @CRLF

                $partitionCount = _DiskpartListPartitionsByVolume( $pid, $myVolumes[$v][0], $myPartitions )
                If @error Then 
                    ProgressOff()
                    _DiskpartCloseConsole( $pid )
                    Return SetError( 1, 2, 0 )
                EndIf
                
                If $partitionCount > 0 Then 
                    $tmpDetails[$d] &= StringFormat( @CRLF & @TAB & "  %-13s  %-16s  %7s  %7s", "Partition ###", "Type", "Size", "Offset" ) & @CRLF
                    $tmpDetails[$d] &= @TAB & "  -------------  ----------------  -------  -------" & @CRLF
                    
                    For $p = 0 To $partitionCount - 1
                        $tmpDetails[$d] &= StringFormat( @TAB & "  %-13s  %-16s  %7s  %7s", _
                                                         "Partition " & $myPartitions[$p][0], $myPartitions[$p][1], _
                                                         $myPartitions[$p][2], $myPartitions[$p][3] ) & @CRLF
                    Next
                Else
                    $tmpDetails[$d] &= @CRLF & @TAB & "No partitions are associated with this volume" & @CRLF
                EndIf
            Next
        Else
            $tmpDetails[$d] &= @TAB & "This disk does not contain any recognized volumes or partitions"
        EndIf
    Next

    ProgressSet( 100, "Closing diskpart console...." )
    _DiskpartCloseConsole( $pid )
    ProgressOff()
    
    If $diskCount > 0 Then 
        ReDim $tmpDetails[ $diskCount ]
        $cboDetails = $tmpDetails
        $cboDisks = $tmpList
    EndIf

    Return SetError( 0, 0, $diskCount )
EndFunc
