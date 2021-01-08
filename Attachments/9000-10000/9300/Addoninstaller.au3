; ----------------------------------------------------------------------------
;
; AutoIt : 3.1.0
; Author:         Tal Atlas <Swimming.Bird@gmail.com>
;
; Script Function:
;	Installs World of Warcraft addons from a web site.
;
; ----------------------------------------------------------------------------
#include <Array.au3>
#include <GUIConstants.au3>
FileChangeDir ( @ScriptDir )
$reg = 'HKLM\SOFTWARE\AddonInstaller'
; ----------------------------------------------------------------------------
; See's if the settings exist, and if they dont get values from user
; ----------------------------------------------------------------------------
If RegRead ( $reg , 'Version' ) <> '' Then
	$addondir = RegRead ( $reg , 'Addondir' )
	$class	= RegRead ( $reg , 'Class' )
	$version = RegRead ( $reg , 'Version' )
Else
	$class = 'All'
	$version = 0
	If FileExists ( @ProgramFilesDir & '\World of Warcraft\WoW.exe' ) Then
		$addondir = @ProgramFilesDir & '\World of Warcraft\Interface\AddOns\'
	ElseIf FileExists ( 'WoW.exe' ) Then
		$addondir = @ScriptDir & '\Interface\AddOns\'
	Else
		$wowfile = FileOpenDialog ( 'Find World of Warcraft exe' , 'C:\' , 'WoW (WoW.exe)' , 1 )
		$addondir = StringTrimRight ( $wowfile , 7 ) & 'Interface\Addons\'
	EndIf
	RegWrite ( $reg , 'Addondir' , 'REG_SZ' , $addondir )
	RegWrite ( $reg , 'Class' , 'REG_SZ' , $class )
	RegWrite ( $reg , 'Version' , 'REG_SZ' , $version )
EndIf
If Not FileExists ( '7z.exe' ) Then
	InetGet ( '                                      ' , '7z.exe' )
EndIf
; ----------------------------------------------------------------------------
; Sets what happens when the script is done
; ----------------------------------------------------------------------------
Func _Exit ( $ndir )
	FileDelete ( 'Addon.ini' )
	If MsgBox ( 36 , 'Run WoW?' , 'Do you want to run World of Warcraft right now?' ) = 7 Then Exit
		Run ( StringTrimRight ( $ndir , 17 ) & 'WoW.exe' )
	Exit
EndFunc
Func _newArrayBinarySearch(ByRef $avArray, $sKey, $i_Base = 0)
    Local $iLwrLimit = $i_Base
    Local $iUprLimit
    Local $iMidElement
    
    If (Not IsArray($avArray)) Then
        SetError(1)
        Return ""
    EndIf
    $iUprLimit = UBound($avArray) - 1
    $iMidElement = Int( ($iUprLimit + $iLwrLimit) / 2)
; sKey is smaller than the first entry
    If $avArray[$iLwrLimit] > $sKey Or $avArray[$iUprLimit] < $sKey Then
        SetError(2)
        Return ""
    EndIf
    
    While $iLwrLimit <= $iMidElement And $sKey <> $avArray[$iMidElement]
        If $sKey < $avArray[$iMidElement] Then
            $iUprLimit = $iMidElement - 1
        Else
            $iLwrLimit = $iMidElement + 1
        EndIf
        $iMidElement = Int( ($iUprLimit + $iLwrLimit) / 2)
    WEnd
    If $iLwrLimit > $iUprLimit Then
    ; Entry not found
        SetError(3)
        Return ""
    Else
    ;Entry found , return the index
        SetError(0)
        Return $iMidElement
    EndIf
EndFunc  ;==>_newArrayBinarySearch
; ----------------------------------------------------------------------------
; Downloads the Addon list if you arnt testing it locally
; ----------------------------------------------------------------------------
If Not FileExists ( 'local.lk' ) Then
	InetGet ( '                                         ' , 'Addon.ini' , 1 , 0 )
EndIf
; ----------------------------------------------------------------------------
; Sets constants
; ----------------------------------------------------------------------------
$addons = IniReadSectionNames ( 'Addon.ini' )
$currentaddons = IniReadSectionNames ( $addondir & 'CurrentAddons.ini' )
$7z = '7z.exe x -y -o"' & $addondir & '" '
$web = '                                '
; ----------------------------------------------------------------------------
; Discover if addons are new or not
; ----------------------------------------------------------------------------
_ArrayDelete ( $currentaddons , 0 )
_ArraySort ( $currentaddons )
Dim $color[$addons[0]+1]
$color[0]=$addons[0]
For $n = 1 To $addons[0]
	If Not (_newArrayBinarySearch ( $currentaddons, $addons[$n],0 ) == '') Then
		Local $onlineversion
		Local $localversion
		$onlineversion = IniRead ( 'Addon.ini' , $addons[$n] , 'Version' , 9999 )
		$localversion = IniRead ( $addondir & 'CurrentAddons.ini' , $addons[$n] , 'Version' , 0 )
		If $onlineversion <= $localversion Then
			$color[$n] = 1
		Else
			$color[$n] = 0
		EndIf
	EndIf
Next
_ArrayDisplay ( $color , '' )
; ----------------------------------------------------------------------------
; Creates the GUI
; ----------------------------------------------------------------------------
$width = 300
Dim $addonctrl[$addons[0]+1]
If mod($addons[0], 2) = 0 Then
	$odd = 0
Else
	$odd = 7
EndIf
GUICreate ( 'LI Addon Installer' , $width , 78 + 10*($addons[0]) + $odd )
$classctrl = GUICtrlCreateCombo ( 'All' , 3 , 3 , 70 , 20 , $CBS_DROPDOWNLIST + $CBS_AUTOHSCROLL + $WS_VSCROLL )
GUICtrlSetData ( -1 , 'Priest|Paladin|Mage|Warlock|Hunter|Druid|Rogue|Warrior' )
;~ $revert = GUICtrlCreateButton ( 'Revert' , 76 , 3 , ($width - 80)/2 , 22 )
GUICtrlCreateGroup ( 'Addons' , 3 , 26 , $width - 6 , 20 + 10*$addons[0] + $odd )
For $n = 1 To $addons[0]
	If mod($n, 2) = 0 Then
		$addonctrl[$n]=GUICtrlCreateCheckbox ( $addons[$n] , 10 + ($width - 16)/2 , 40 + 10*($n-2) , ($width - 16)/2 )
	Else
		$addonctrl[$n]=GUICtrlCreateCheckbox ( $addons[$n] , 10 , 40 + 10*($n-1) , ($width - 16)/2 )
	EndIf
	GUICtrlSetTip ( $addonctrl[$n] , IniRead ( 'Addon.ini' , $addons[$n] , 'Description' , '' ) )
	If $class = 'All' Or IniRead ( 'Addon.ini' , $addons[$n] , $class , 1 ) = 1 Or IniRead ( 'Addon.ini' , $addons[$n] , 'All' , 1 ) = 1 Then;$class = 'All' Or $addons[$n][1] = $class Or $addons[$n][1] = 'All' Then
		GUICtrlSetState ( $addonctrl[$n] , $GUI_ENABLE )
	Else
		GUICtrlSetState ( $addonctrl[$n] , $GUI_DISABLE )
	EndIf
	If $color[$n] = 1 Then GUICtrlSetColor ( $addonctrl[$n] , 0xff0000 )
Next
GUICtrlSetData ( $classctrl , $class )
GUICtrlCreateGroup ("",-99,-99,1,1)
$install = GUICtrlCreateButton ( 'Install' , 3 , 50 + 10*($addons[0]) + $odd , $width/2 - 6 )
$cancel = GUICtrlCreateButton ( 'Cancel' , $width/2 , 50 + 10*($addons[0]) + $odd , $width/2 - 6 )
; ----------------------------------------------------------------------------
; Rules for running the GUI
; ----------------------------------------------------------------------------
GUISetState (@SW_SHOW)
While 1
    $msg = GUIGetMsg()
	If $msg = $classctrl Then
		$class = GUICtrlRead ( $classctrl )
		For $n = 1 To $addons[0]
			If $class = 'All' Or IniRead ( 'Addon.ini' , $addons[$n] , $class , 1 ) = 1 Or IniRead ( 'Addon.ini' , $addons[$n] , 'All' , 1 ) = 1 Then;$class = 'All' Or $addons[$n][1] = $class Or $addons[$n][1] = 'All' Then
				GUICtrlSetState ( $addonctrl[$n] , $GUI_ENABLE )
			Else
				GUICtrlSetState ( $addonctrl[$n] , $GUI_DISABLE )
			EndIf
		Next
	ElseIf $msg = $install Then
		ExitLoop
;~ 	ElseIf $msg = $revert Then
;~ 		IniWrite ( 'config.ini' , 'Config' , 'Version' , 0 )
;~ 		MsgBox ( 0 , "Restart Needed" , 'In order to set changes please restart program' , 10000 )
;~ 		Exit
    ElseIf $msg = $GUI_EVENT_CLOSE Or $msg = $cancel Then 
		GUISetState (@SW_HIDE)
		_Exit ( $addondir )
	EndIf
WEnd
GUISetState (@SW_HIDE)
;~ IniWrite ( 'config.ini' , 'Config' , 'Version' , $newversion )
RegWrite ( $reg , 'Class' , 'REG_SZ' , $class )
; ----------------------------------------------------------------------------
; Finds what addons to get
; ----------------------------------------------------------------------------
$i=0
For $n = 1 To $addons[0]
	If GUICtrlRead ( $addonctrl[$n] ) = 1 Then $i = $i + 1
Next
Dim $dl[1]
$dl[0]=$i
For $n = 1 To $addons[0]
	If GUICtrlRead ( $addonctrl[$n] ) = 1 Then _ArrayAdd ( $dl , $addons[$n] )
Next
; ----------------------------------------------------------------------------
; Downloads addons
; ----------------------------------------------------------------------------	
ProgressOn ( 'Downloading Addons' , 'Downloading Addons' )
For $n = 1 To $dl[0]
	Local $size = InetGetSize ( $web & $dl[$n] & '.7z' )
	ProgressSet ( (($n-1)/$dl[0]) * 100 , 'Downloading Addon: ' & $dl[$n] & '(' & $size & ' bytes)' )
	InetGet ( $web & $dl[$n] & '.7z' , @ScriptDir & '\' & $dl[$n] & '.7z' , 1 )
Next
ProgressOff()
; ----------------------------------------------------------------------------
; Installs addons
; ----------------------------------------------------------------------------
ProgressOn ( 'Installing Addons' , 'Installing Addons' )
For $n = 1 To $dl[0]
	ProgressSet ( ($n-1)/$dl[0] * 100 , 'Installing Addon: ' & $dl[$n] )
	RunWait ( $7z & $dl[$n] & '.7z' ) ;, @ScriptDir , @SW_HIDE )
	FileDelete ( $dl[$n] & '.7z' )
	IniWrite ( $addondir & 'CurrentAddons.ini' , $dl[$n] , 'Version' , IniRead ( 'Addon.ini' , $dl[$n] , 'Version' , 0 ) )
Next
ProgressOff()
_Exit ( $addondir )