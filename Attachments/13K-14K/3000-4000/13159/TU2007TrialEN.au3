; This will Run Tune Up Utilities 2007 Trial with 1 Click Maintenance on the Desktop
;  and Updates disabled. to register, enter Name, Company, and Key in lines 52, 54, & 56

Run	("TU2007TrialEN.exe")

;Welcome
WinWaitActive	( "TuneUp Utilities 2007 Setup" , "Welcome to the" )
ControlClick  ( "TuneUp Utilities 2007 Setup" , "" , "Button1" )

;License
WinWaitActive	( "TuneUp Utilities 2007 Setup" , "License Agreement" )  
Send ("{UP}")
ControlClick  ( "TuneUp Utilities 2007 Setup" , "" , "Button4" )

;User Information
WinWaitActive ( "TuneUp Utilities 2007 Setup" , "User Information" )
Send ("{ENTER}")

;Destination Folder
WinWaitActive ( "TuneUp Utilities 2007 Setup" , "Destination Folder" )
Send ("{ENTER}")

;Application Settings
WinWaitActive ( "TuneUp Utilities 2007 Setup" , "Application Settings" )
Send ("{TAB 3}")
Send ("{SPACE}")
Send ("{TAB}")
Send ("{SPACE}")
Send ("{TAB}")
Send ("{SPACE}")
Send ("{TAB 2}")
Send ("{ENTER}")

;TuneUp 2007 Sucessful Install
WinWaitActive ( "TuneUp Utilities 2007 Setup" , "TuneUp Utilities 2007 has been" )
ControlClick  ( "TuneUp Utilities 2007 Setup" , "" , "Button1" )

;Disable the Tuneup Update Wizard
WinWaitActive("Update Check Recommended", "In 2 days")
;ControlClick  ( "Update Check Recommended" , "" , "TRadioButton2" )
;ControlClick  ( "Update Check Recommended" , "" , "TComboBox1" )
Send ("{DOWN 7}")
;Send ("{ENTER}")
ControlClick  ( "Update Check Recommended" , "" , "TButton1" )

;TuneUp 2007 Menu
WinWaitActive("TuneUp Utilities 2007", "Continue Testing")
ControlClick  ( "TuneUp Utilities 2007" , "" , "TButton3" )

;Enter Registration Key
WinWaitActive("Enter Key", "     -     -     -     -     -  ")
Send ("NAME")
Send ("{TAB}")
Send ("COMPANY")
Send ("{TAB}")
Send ("  cd - key -     -     -     -  ")
ControlClick  ( "Enter Key" , "" , "TButton2" )

;Program Unclocked Sucessfully
WinWaitActive("Thank you!", "Thank you for choosing")
ControlClick  ( "Thank you!" , "" , "Button1" )

;Program Restart Required
WinWaitActive("Program restart required", "You must restart")
ControlClick  ( "Program restart required" , "" , "Button1" )


Exit

