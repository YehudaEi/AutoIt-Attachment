Func Speak($Text="Hi", $Rate=1, $Vol=100)
    $voice.Rate = $Rate
    $voice.Volume = $Vol
    $voice.Speak ($Text)
EndFunc;==>Speak