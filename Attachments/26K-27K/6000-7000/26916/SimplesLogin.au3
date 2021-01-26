
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>;
#include <EditConstants.au3>


ProgressOn("Load Program", "Open Program", "0%") ; Just to let more beautiful
For $i = 10 To 100 Step 10
	Sleep(1000)
	ProgressSet($i, $i & "%")
Next
ProgressSet(100, "Full Load", "Complete")
Sleep(500)
ProgressOff()

$Form1 = GUICreate("Login", 400, 250, -1, -1) ; begining of Login
$PASSWORD = GUICtrlCreateInput("", 65, 167, 220, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))
$ButtonOk = GUICtrlCreateButton("&OK", 200, 220, 75, 25, 0)
$ButtonCancel = GUICtrlCreateButton("&Cancel", 280, 220, 75, 25, 0)
$passwordlabel = GUICtrlCreateLabel("Password:", 8, 172, 50, 17)
$usernamelabel = GUICtrlCreateLabel("Username:", 8, 143, 52, 17)
$USERNAME = GUICtrlCreateInput("", 65, 144, 220, 21)
GUICtrlCreateGroup('',10,2,380,100)
        GUICtrlCreateLabel('Terms of use of this Software',30,10,340,18)
		GUICtrlSetColor(-1, 0x0012FF)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('To use this software to be Registered in Forum',30,28,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('',30,46,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('To open the program',30,64,340,18)
        GUICtrlSetFont(-1,12,400)
        GUICtrlCreateLabel('Team gOHc Thank you for your choice',30,82,340,18)
        GUICtrlSetFont(-1,12,400)
    GUICtrlCreateGroup('',-99,-99,1,1)
    GUICtrlSetBkColor(-1,0x000000)
GUISetState(@SW_SHOW)



While 1
    $MSG = GUIGetMsg()
    Switch $MSG
    Case $ButtonOk
        If VerifyLogin(GUICtrlRead($USERNAME),GUICtrlRead($PASSWORD)) = 1 Then
            GUIDelete($Form1)
            MsgBox(-1,"Logado com Sucesso","Login Succ..")
			RunP()


		Else
            MsgBox(-1,"Error"," Username ou Senha está incorreto, Tente denovo")
        EndIf
    Case -3
        Exit
	Case $ButtonCancel
		Exit
    EndSwitch
WEnd

Func VerifyLogin($USERNAME,$PASSWORD)
    If $USERNAME = "your pass here" And $PASSWORD = "your pass here" Then
        Return 1
    Else
        Return 0
    EndIf
EndFunc ; End login



Func Runp()

	;Your Code begining here
EndFunc

Func onautoitexit()
   Exit
EndFunc  ;==>onautoitexit
