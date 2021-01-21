
;--------------------------------------------------------------------------

global $parg

func param()
   if $CmdLine[0] >= 1 then
      $parg = $CmdLine[1]
   endif
endfunc


param()

;msgBox( 0, "ScriptDummy", $parg )

beep( 440, 250 )
