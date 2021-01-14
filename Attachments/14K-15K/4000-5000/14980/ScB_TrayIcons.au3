#include-once
#include <Math.au3>
#include <A3LMenu.au3>
#include <A3LToolbar.au3>
#include <A3LWinAPI.au3>

; #FUNCTION# ====================================================================================================================
; Description ...: Finds a TaskBar icon and "clicks" popup menu/submenu item
; Parameters ....: $sIconTitle   - Text to use to find the taskbar icon (using substring search)
;                  $sMenuItem    - Text or 0-based item number of item in main popup menu
;                  $sSubMenuItem - Text or 0-based item number of Item in submenu (if any) [default = "" - no submenu]
;                  $sMouseButton - Mouse button used to show the main popup menu [default = "secondary"]
;                  $iPause       - Milliseconds to pause between "clicking" menu and scanning for new popups [default = 600]
;                  $iTrace       - Writes info to Console for finding problems - pass in the @Error code [default=0]
; Return values .: True          - Found and clicked the menu item(s)
;                  False         - Unable to find the icon (@error 1) / Menu item (@error 2) / SubMenu item (@error 3)
;                                - Or if menu items are disabled/greyed, Menu item (@error -2) / Submenu item (@error -3)
; Author ........: Steve Bateman (MisterBates)
; Remarks .......: Uses UDFs from Auto3Lib. Uses Blockinput() while working with the popups.
;                  BEWARE: Some menu items have '&' in the text. Some menu items are "ownerdraw" and have no text.
;                          Some menus do not flag items as greyed/disabled.
;                          Try using menu/submenu text to find items, if you get @Error, pass @Error as $iTrace value.
; Related .......: 
; ===============================================================================================================================
Func ClickTaskbarMenuItem($sIconTitle, $sMenuItem, $sSubMenuItem="", $sMouseButton="secondary", $iPause=600, $iTrace=0)

  Enum $eFindIcon=1, $eFindMenu, $eFindSubMenu, $eSuccess
  
	$iTrace = abs($iTrace)
  ; Validate the menu names, if passed as numbers
  $iResult = $eFindIcon ; try to find icon
  if IsNumber($sMenuItem) Then
    if $sMenuItem < 0 Then $iResult = $eFindMenu
    if $iTrace = $eFindMenu Then ConsoleWrite('ERROR: MenuItem number is ' & $sMenuItem & @CRLF)
  EndIf
  if IsNumber($sSubMenuItem) Then
    if $sSubMenuItem < 0 Then $iResult = $eFindSubMenu
    if $iTrace = $eFindSubMenu Then ConsoleWrite('ERROR: SubMenuItem number is ' & $sMenuItem & @CRLF)
  EndIf

  if $iResult = $eFindIcon Then
    $hWnd   = ControlGetHandle("classname=Shell_TrayWnd", "", "Notification Area")
    $iCount = _Toolbar_ButtonCount($hWnd)

    for $iIconNo = 1 to $iCount
      $iCommand = _Toolbar_IndexToCommand($hWnd, $iIconNo)
      $sText    = _Toolbar_GetButtonText ($hWnd, $iCommand)

      if $iTrace = $eFindIcon then ; >>>>>>>> Caller asked for trace output
        if $sText <> "" then ConsoleWrite('====== Icon "' & $sText & '"' & @crlf)
      EndIf ; >>>>>>>> Caller asked for trace output
      
      if not StringInStr($sText, $sIconTitle) then ContinueLoop
      $iResult = _Max($iResult, $eFindMenu) ; try to find the popup menu text/item
     
      if $iTrace then ConsoleWrite('====== Icon "' & $sText & '"' & @crlf) ; >>>>>>>> Caller asked for trace output
      
      BlockInput(1) ; Prevent user interacting with mouse/keyboard
      $iMousePos = MouseGetPos() ; Save the mouse
      $hHasFocus = _API_GetFocus()
      WinActivate($hWnd) ; Show the taskbar (if it's on auto-hide)

      _Toolbar_ClickButton($hWnd, $iCommand, $sMouseButton, True, 1, 0, False) ; show the popup menu
      if $iPause > 0 then Sleep($iPause) ; popup menus can take a little time to be shown
      _Lib_PopupScan() ; Auto3Lib internal routine to find popup menus
			$iPopupCount = _Lib_PopupCount()
      for $iPopupNo = 1 to $iPopupCount
        $hPopupMenu = _Lib_PopupGetHwnd($iPopupNo)
        $iPopupItemCount = _Menu_GetItemCount($hPopupMenu)
        if $iPopupItemCount <= 0 Then ContinueLoop ; Ignore popups with no menu items
        if not IsNumber($sMenuItem) Then $sMenuItem = _Menu_FindItem($hPopupMenu, $sMenuItem, True)
          
        if $iTrace = $eFindMenu Then ; >>>>>>>> Caller asked for trace output
          if $sMenuItem >= 0 and $sMenuItem < $iPopupItemCount Then
            ConsoleWrite('Menu item number ' & $sMenuItem & @CRLF)
          ElseIf $sMenuItem < 0 Then
            for $iI = 0 to $iPopupItemCount - 1
              ConsoleWrite('SubMenu item ' & $iI & ' (type')
              $iMenuType = _Menu_GetItemType($hPopupMenu, $iI)
              if $iMenuType = 0 then ConsoleWrite(' NONE')
              if $iMenuType <> 0 then ConsoleWrite(' ' & $iMenuType & ' =')
              if bitAND($iMenuType, $MFT_BITMAP) then ConsoleWrite(' bitmap')
              if bitAND($iMenuType, $MFT_MENUBARBREAK) then ConsoleWrite(' menubarbreak')
              if bitAND($iMenuType, $MFT_MENUBREAK) then ConsoleWrite(' menubreak')
              if bitAND($iMenuType, $MFT_OWNERDRAW) then ConsoleWrite(' owner-draw')
              if bitAND($iMenuType, $MFT_RADIOCHECK) then ConsoleWrite(' radio-check')
              if bitAND($iMenuType, $MFT_RIGHTJUSTIFY) then ConsoleWrite(' right-justify')
              if bitAND($iMenuType, $MFT_RIGHTORDER) then ConsoleWrite(' right-order')
              if bitAND($iMenuType, $MFT_SEPARATOR) then ConsoleWrite(' separator')
              ConsoleWrite(')')
              if _Menu_GetItemText($hPopupMenu, $iI) <> "" then ConsoleWrite(' = ' & _Menu_GetItemText($hPopupMenu, $iI))
              ConsoleWrite(@CRLF)
            next ; $iI
          Else
            ConsoleWrite('Menu item number ' & $sMenuItem & ' >= Menu item count ' & $iPopupItemCount & @CRLF)
          EndIf
        EndIf ; >>>>>>>> Caller asked for trace output
    
        if $sMenuItem >= 0 and $sMenuItem < $iPopupItemCount Then
					if _Menu_GetItemDisabled($sMenuItem, $iPopupNo) Or _Menu_GetItemGrayed($sMenuItem, $iPopupNo) Then
						$iResult = -$iResult
						ExitLoop
					EndIf
					
          $iResult = _max($iResult, $eFindSubMenu) ; we're trying to find the popup submenu text/item
          _Menu_ClickPopup($sMenuItem, $iPopupNo)
          
          if $sSubMenuItem = "" Then ; no submenu, indicate success
            $iResult = 4
            ExitLoop ; $iPopupNo
          Else ; deal with submenu
            if $iPause > 0 then Sleep($iPause)
            _Lib_PopupScan() ; Auto3Lib internal routine to find popup menus
						$iSubCount = _Lib_PopupCount()
						
						if $iSubCount <= $iPopupCount Then ; no submenu popped up ...
							$iResult = -($iResult - 1) ; indicate problem with menu item
							ExitLoop
						EndIf
						
            for $iSubNo = 1 to $iSubCount
              $hSubMenu = _Lib_PopupGetHwnd($iSubNo)
              if $hSubMenu = $hPopupMenu Then ContinueLoop ; Don't mistake the main popup for a submenu
              $iSubItemCount = _Menu_GetItemCount($hSubMenu)
              if $iSubItemCount <= 0 Then ContinueLoop ; Ignore popups with no menu items
              if not IsNumber($sSubMenuItem) Then $sSubMenuItem = _Menu_FindItem($hSubMenu, $sSubMenuItem, True)

              if $iTrace = $eFindSubMenu Then ; >>>>>>>> Caller asked for trace output
                if $sSubMenuItem >= 0 and $sSubMenuItem < $iSubItemCount Then
                  ConsoleWrite('SubMenu item number ' & $sSubMenuItem & @CRLF)
                ElseIf $sSubMenuItem < 0 Then
                  for $iI = 0 to $iSubItemCount - 1
                    ConsoleWrite('SubMenu item ' & $iI & ' (type')
                    $iMenuType = _Menu_GetItemType($hSubMenu, $iI)
                    if $iMenuType = 0 then ConsoleWrite(' NONE')
                    if $iMenuType <> 0 then ConsoleWrite(' ' & $iMenuType & ' =')
                    if bitAND($iMenuType, $MFT_BITMAP) then ConsoleWrite(' bitmap')
                    if bitAND($iMenuType, $MFT_MENUBARBREAK) then ConsoleWrite(' menubarbreak')
                    if bitAND($iMenuType, $MFT_MENUBREAK) then ConsoleWrite(' menubreak')
                    if bitAND($iMenuType, $MFT_OWNERDRAW) then ConsoleWrite(' owner-draw')
                    if bitAND($iMenuType, $MFT_RADIOCHECK) then ConsoleWrite(' radio-check')
                    if bitAND($iMenuType, $MFT_RIGHTJUSTIFY) then ConsoleWrite(' right-justify')
                    if bitAND($iMenuType, $MFT_RIGHTORDER) then ConsoleWrite(' right-order')
                    if bitAND($iMenuType, $MFT_SEPARATOR) then ConsoleWrite(' separator')
                    ConsoleWrite(')')
                    if _Menu_GetItemText($hSubMenu, $iI) <> "" then ConsoleWrite(' = ' & _Menu_GetItemText($hSubMenu, $iI))
                    ConsoleWrite(@CRLF)
                  next ; $iI
                Else
                  ConsoleWrite('SubMenu item number ' & $sSubMenuItem & ' >= SubMenu item count ' & $iSubItemCount & @CRLF)
                EndIf
              EndIf ; >>>>>>>> Caller asked for trace output

              if $sSubMenuItem >= 0 and $sSubMenuItem < $iSubItemCount Then
								if _Menu_GetItemDisabled($sSubMenuItem, $iSubNo) Or _Menu_GetItemGrayed($sSubMenuItem, $iSubNo) Then
									$iResult = -$iResult
									ExitLoop
								EndIf
               
                $iResult = _max($iResult, $eSuccess) ; found the submenu - click it
								_Menu_ClickPopup($sSubMenuItem, $iSubNo)

								ExitLoop ; $iSubNo
              EndIf
            Next ; $iSubNo
          EndIf ; Submenu code
					
					if $iResult <> $eSuccess Then send("{ESC}")

          if Abs($iResult) > $eFindMenu then ExitLoop ; $iPopupNo
        EndIf
      Next ; $iPopupNo

			if $iResult <> $eSuccess Then send("{ESC}")

      MouseMove($iMousePos[0], $iMousePos[1], 0) ; put mouse back where it was
      _API_SetFocus($hHasFocus) ; and return focus to the previously active window
			WinActivate($hHasFocus)
      BlockInput(0) ; Re-enable user input
      
      if Abs($iResult) > $eFindIcon Then ExitLoop ; $iIconNo
    next
  EndIf
    
  if $iResult = $eSuccess Then
    Return True
  Else
    SetError($iResult)
    Return False
  EndIf

EndFunc