#include <GUIConstants.au3>

;Constants used in the Dll call

Dim Const $SPI_SETDESKWALLPAPER = 20;
Dim Const $SPIF_UPDATEINIFILE = 0x01;
Dim Const $SPIF_SENDWININICHANGE = 0x02;
Dim Const $REGISTRY_PATH = "HKEY_CURRENT_USER\Control Panel\Desktop"

;create the gui
$wall_change = GUICreate( "Don's Wallpaper Changer",300, 300 )

;create a simple about message for the script
GUICtrlCreateGroup( "What this does...", 15, 15, 270, 55 )
GUICtrlCreateLabel( "This program allows you to easily change the picture and style of your wallpaper.", 20, 30, 260, 30 )
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

; now that the GUI is created, show the gui and await user interaction
GUISetState(@SW_SHOW)

GUICtrlCreateGroup( "Image name( must be *.bmp ): ", 15, 75, 270, 50 )
$file_name = GUICtrlCreateInput( "", 20, 95, 260, 20 )
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

GUICtrlCreateGroup( "Wallpaper Options: ", 15, 135, 270, 110 )
$tile = GUICtrlCreateRadio( "Tile", 30, 155, 240, 20 )
$center = GUICtrlCreateRadio( "Center", 30, 185, 240, 20 )
$stretch = GUICtrlCreateRadio( "Stretch", 30, 215, 240, 20 )
GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group

$change = GUICtrlCreateButton( "Change Wallpaper", 100, 255, 100, 30 )

;set the default to center
GUICtrlSetState ($center, $GUI_CHECKED)

While 1
    $msg = GuiGetMsg()
    
    Select
    
    Case $msg = $GUI_EVENT_CLOSE
        ExitLoop
        
    Case $msg = $change
        ;check to make sure that a file name was supplied
        $file_path = GUICtrlRead( $file_name )
        
        If $file_path = "" Then
            MsgBox( 4096, "Error!!!", "Please enter a valid file name!" )
        EndIf
        
        ;now make sure the .bmp extension is on the image name, if not, add it
        If StringRight( $file_path, 4 ) <> ".bmp" Then
            $file_path &= ".bmp"
        EndIf
        
        If Not StringInStr( $file_path, @WorkingDir ) Then
			$file_path = @WorkingDir & "\" & $file_path
			GUICtrlSetData( $file_name, $file_path )
		EndIf
        
        ;now that the file name is valid, try to locate the file in the script directory
        If FileExists( $file_path ) Then
                ;now that we knwo the file exists, start making changes
                ;first update the wallpaper style in the registry
                
                ;used to check for DllCall and RegWrite errors
                Local $err
                
                ;Set tiled
                If BitAND(GUICtrlRead($tile), $GUI_CHECKED) = $GUI_CHECKED Then
                    $err = RegWrite( $REGISTRY_PATH, "WallpaperStyle", "REG_SZ", "1" )
                    $err += RegWrite( $REGISTRY_PATH, "TileWallpaper", "REG_SZ", "1" )
                ;Set centered
                ElseIf BitAND(GUICtrlRead($center), $GUI_CHECKED) = $GUI_CHECKED Then
                    $err = RegWrite( $REGISTRY_PATH, "WallpaperStyle", "REG_SZ", "1" )
                    $err += RegWrite( $REGISTRY_PATH, "TileWallpaper", "REG_SZ", "0" )                    
                ;Set stretched
                Else
                    $err = RegWrite( $REGISTRY_PATH, "WallpaperStyle", "REG_SZ", "2" )
                    $err += RegWrite( $REGISTRY_PATH, "TileWallpaper", "REG_SZ", "0" )                
                EndIf
            
                ;Now that the registry edits were attempted, check for any errors
                If $err <> 2 Then
                    MsgBox( 4096, "Registery Error!!!", "There was an error writing to the registry." )
                Else
                    ;No error writing to the registry, make the Dll call to change the image!
                    $err = DllCall( "User32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, _
                                    "int", 0, "string", $file_path, "int", $SPIF_UPDATEINIFILE )
                    If @error <> 0 Then
                        MsgBox( 4096, "Dll Error!!!", "There was an error making the Dll call." & @CR & "Error Code: " & @error )
                    EndIf 
                    $err = DllCall( "User32.dll", "int", "SystemParametersInfo", "int", $SPI_SETDESKWALLPAPER, _
                                    "int", 0, "string", $file_path, "int", $SPIF_SENDWININICHANGE )
                    If @error <> 0 Then
                        MsgBox( 4096, "Dll Error!!!", "There was an error making the Dll call." & @CR & "Error Code: " & @error )
                    EndIf                      
                EndIf
        Else
            MsgBox( 4096, "Error!!!", "The file was not found in the current directory." & _
                          @CR & "Please put file in same directory as script!" )
        EndIf
        
    Case Else
        ;Do nothing here
    EndSelect
WEnd
