GUICreate("Multiple Radio buttons", 500, 350)
GUISetState()

GUICtrlCreateRadio("This is radio A", 10 , 10, 100)
GUICtrlCreateRadio("This is radio B", 10 , 35, 100)

GUICtrlCreateLabel("A and B should be in a control", 10, 60)

GUICtrlCreateRadio("This is radio 1", 10 , 80, 100)
GUICtrlCreateRadio("This is radio 2", 10 , 115, 100)

GUICtrlCreateLabel("1 and 2 should be in a control", 10, 135)

GUICtrlCreateLabel("But now A, B, 1 and 2 are all mixed. How can you separate them?", 10, 150)

While 1
WEnd