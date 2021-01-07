;Chain Structure Include
;Author: Guido Arbia
;Requirement: Mx63.dll Pluged in.

func ChainElementCreate()
	$ea = BufferAllocate(16)
	BufferWriteInt($ea, 0)
	BufferWriteInt($ea+4, 0)
	BufferWriteInt($ea+8, 0)
	BufferWriteInt($ea+12, 0)
	
	return $ea
EndFunc

func ChainElementDelete($Address)
	BufferFree($Address, 16)
EndFunc

func ChainElementAttachAfter($Element, $NextElement)
	ChainElementSetNext($Element, $NextElement)
	ChainElementSetPrevious($NextElement, $Element)
EndFunc

func ChainElementDettachPrevious($Element)
	ChainElementSetNext(ChainElementGetPrevious($Element), 0)
	ChainElementSetPrevious($Element, 0)
EndFunc

func ChainElementGetValue($Address)
	return BufferReadInt($Address)
EndFunc

func ChainElementSetValue($Address, $Value)
	BufferWriteInt($Address, $Value)
EndFunc

func ChainElementGetNext($Address)
	return BufferReadInt($Address+4)
EndFunc

func ChainElementSetNext($Address, $Value)
	BufferWriteInt($Address+4, $Value)
EndFunc

func ChainElementGetPrevious($Address)
	return BufferReadInt($Address+8)
EndFunc

func ChainElementSetPrevious($Address, $Value)
	BufferWriteInt($Address+8, $Value)
EndFunc

func ChainElementSetFlag($Address, $FlagIndex, $Flag)
	BufferSetCharAsc($Address+12+$FlagIndex, $Flag)
EndFunc

func ChainElementGetFlag($Address, $FlagIndex)
	return BufferGetCharAsc($Address+12+$FlagIndex)
EndFunc