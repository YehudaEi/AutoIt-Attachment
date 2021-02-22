#include <GUIConstantsEx.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <IE.au3>
#include <Misc.au3>
#include <IE.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <DateTimeConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiStatusBar.au3>
#include <ProgressConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <IE.au3>
#include <Misc.au3>


Opt('MustDeclareVars', 1)
Example()

Func Example()
	Local $menu1, $msg , $n1, $n2, $n3 , $form , $msg, $menustate, $menutext , $name, $pwd, $read_btn , $msg, $menustate, $menutext, $ie, $input_email, $input_password, $form, $hwnd, $array, $element , $ie , $Form1 , $MenuItem2 , $MenuItem3 , $MenuItem1 , $MenuItem7 , $MenuItem8 , $MenuItem4 , $MenuItem5 , $MenuItem6 , $Button1 , $Combo1 , $Progress1 , $MonthCal1 , $StatusBar1 , $input_email , $input_password , $Edit1 , $Button2 , $Button3 , $Input3 , $Password , $Label1 , $Combo2 , $Label2 , $Button5 , $Button6 , $Label3 , $Button7 , $Input4 , $Input5 , $Input14 , $Combo3 , $Button8 , $Input6  , $Input7 , $Label5 , $Combo4 , $Button9 , $Label6 , $Combo5 , $Button10 , $Label7 , $Label8 , $Label9 , $Input10 , $iaas , $Send



	GUICreate("My GUICtrlRead") ; will create a dialog box that when displayed is centered

	$menu1 = GUICtrlCreateMenu("File")

	$n3 = GUICtrlCreateInput("email",150 , 80, 121, 21)
	$Input5 = GUICtrlCreateInput("password", 150, 105, 121, 21)

	$n2 = GUICtrlCreateButton("Read", 150, 135, 50)
	GUICtrlSetState(-1, $GUI_FOCUS) ; the focus is on this button

	GUISetState() ; will display an empty dialog box
	; Run the GUI until the dialog is closedku

	Do

        $msg = GUIGetMsg()
        If $msg = $n2 Then
            MsgBox(0, "Selected listbox entry", GUICtrlRead($Input5)) ; display the selected listbox entry
			$ie = _IeCreate ("www.fb.com")
			$input_email = _IEGetObjByid ( $ie , "email")
			_IEFormElementSetValue($input_email, GUICtrlRead($n3))
			$input_password = _IEGetObjByid ( $ie , "pass")
			_IEFormElementSetValue($input_password, GUICtrlRead($Input5))
			$form = _IEGetObjByName ($ie, "u789210_3")
			$array = _IETagNameGetCollection($ie, "input")
			for $element in $array
				if stringinstr($element.value, "Log in") Then
					msgbox(0,"", "Zosta³es Zalogowany")
					ExitLoop
				EndIf
			Next
			_IEAction ($element, "focus")
			msgbox(0,"Logout", "")
			ControlSend($hwnd, "", "[CLASS:Internet Explorer_Server; INSTANCE:1]", "{Enter}")
			stringinstr($element.value, "Account")
			stringinstr($element.value, "Log Out")
			$form= _IEFormGetObjByName($ie, "logout_form")
			$form= _IEGetObjByid($ie, "logout_form")
			_IEFormSubmit($form)
        EndIf
    Until $msg = $GUI_EVENT_CLOSE
EndFunc   ;==>Example