#Include <IE.au3>
$OIE = _IECreate("http://www.irs.gov/pub/irs-pdf/fw4.pdf",0,1,0)

winsetstate("","",@SW_MAXIMIZE)

Sleep(5000)

PixelSearch(53,95,55,97,"0xA6D1F6")
If @error = 0 then
        msgbox(0,"","Found")
else
        msgbox(0,"","Not Found")
endif