#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <IE.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
Opt('MustDeclareVars', 1)

Example()

Func Example()
	Local $menu1 , $n3 , $Input5 , $n2 , $msg , $ie , $input_password , $input_email , $form , $array , $element , $hwnd
	GUICreate("My GUICtrlRead") ; will create a dialog box that when displayed is centered

	$menu1 = GUICtrlCreateMenu("File")

	$n3 = GUICtrlCreateInput("kuletakamil@hotmail.co.uk",150 , 80, 121, 21)
	$Input5 = GUICtrlCreateInput("lolx123", 150, 105, 121, 21)

	$n2 = GUICtrlCreateButton("Read", 150, 135, 50)
	GUICtrlSetState(-1, $GUI_FOCUS) ; the focus is on this button

	GUISetState() ; will display an empty dialog box
	; Run the GUI until the dialog is closed

    Do

        $msg = GUIGetMsg()
        If $msg = $n2 Then
            MsgBox(0, "Selected listbox entry", GUICtrlRead($Input5)) ; display the selected listbox entry
			$ie = _IECreate ("http://fb.com")
			$input_email = _IEGetObjByid ( $ie , "email")
			_IEFormElementSetValue($input_email, GUICtrlRead($n3))
			$input_password = _IEGetObjByid ( $ie , "pass")
			_IEFormElementSetValue($input_password, GUICtrlRead($Input5))
			$form = _IEGetObjByName ($ie, "Email")
			$array = _IETagNameGetCollection($ie, "input")
			for $element in $array
				if stringinstr($element.value, "Log in") Then
					msgbox(0,"", "Zosta³es Zalogowany")
					ExitLoop
				EndIf
			Next
			_IEAction ($element, "focus")
			ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")
			msgbox(0,"Logout", "")
			stringinstr($element.value, "navAccount")
			stringinstr($element.value, "Log Out")
			$form= _IEFormGetObjByName($ie, "logout_form")
			$form= _IEGetObjByid($ie, "logout_form")
			_IEFormSubmit($form)
        EndIf
Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example