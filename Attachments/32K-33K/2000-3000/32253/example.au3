#include <ClusterAPI.au3>

ClusterAPI_Start()

ClusterAPI_Connect("fsw.lab.local.com")

If @error <> 0 Then
	MsgBox("","","Cannot connect to cluster :" & @error)
Else
	ConsoleWrite("Connected to cluster!")
EndIf

$nodestate = ClusterAPI_GetNodeState("MCSC-VM1")

If @error <> 0 Then
	MsgBox("","","Cannot get node state:" & @error)
Else
	ConsoleWrite("Node state:" & $nodestate)
EndIf

$resourcestate = ClusterAPI_GetResourceState("SQL Server")

If @error <> 0 Then
	MsgBox("","","Cannot get resource state :" & @error)
Else
	ConsoleWrite("Resource state:" & $resourcestate)
EndIf

ClusterAPI_SetResourceOffline("SQL Server")
If @error <> 0 Then
	MsgBox("","","Cannot set resource offline :" & @error)
EndIf

Sleep(2000)

ClusterAPI_SetResourceOnline("SQL Server")
If @error <> 0 Then
	MsgBox("","","Cannot set resource online :" & @error)
EndIf

ClusterAPI_MoveClusterGroup("Cluster Group")
If @error <> 0 Then
	MsgBox("","","Cannot move group:" & @error)
EndIf

ClusterAPI_GetGroupState("Cluster Group")
If @error <> 0 Then
	MsgBox("","","Cannot get group state :" & @error)
EndIf
