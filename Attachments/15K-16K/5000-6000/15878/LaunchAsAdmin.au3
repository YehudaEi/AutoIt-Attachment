#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=PointingUser.ICO
#AutoIt3Wrapper_Res_Comment=                                   
#AutoIt3Wrapper_Res_Description=LaunchAsAdmin
#AutoIt3Wrapper_Res_Fileversion=0.1.4.1
#AutoIt3Wrapper_Res_LegalCopyright=©2007 Michael Michta
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Opt("RunErrorsFatal", 0)
Run(@ComSpec & ' /c Start "" "' & $CmdLine[1] & '"',@SystemDir,@SW_HIDE)