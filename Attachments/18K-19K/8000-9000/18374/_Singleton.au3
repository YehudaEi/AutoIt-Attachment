#include <Misc.au3>

_Singleton( "OneAndOnlyOne" )
AutoItSetOption( "TrayIconDebug", 1 )

MsgBox( 262144, "", "hello" )
