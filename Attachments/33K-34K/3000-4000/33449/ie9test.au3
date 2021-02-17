#AutoIt3Wrapper_run_debug_mode=Y
#include <IE.au3>

$oIE = _IECreate ("about:blank")

_IENavigate($oIE, "                                                 ")

$oForm = _IEFormGetCollection ( $oIe, 0 )

$iError = _IEFormImageClick ( $oForm, "images/wd_submit.gif")
