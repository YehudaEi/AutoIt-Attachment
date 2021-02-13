Global $hClusterDLL
Global $hCluster
Global $bIsValidClusterHandle

Global $CANNOT_CONNECT_CLUSTER = -1
Global $CANNOT_OPEN_NODE = -2
Global $CANNOT_GET_NODE_STATE = -3
Global $CANNOT_OPEN_DLL = -4
Global $MUST_CONNECT_CLUSTER = -5
Global $CANNOT_OPEN_RESOURCE = -6
Global $CANNOT_GET_RESOURCE_STATE = -7
Global $CANNOT_OFFLINE_RES = -8
Global $CANNOT_ONLINE_RES = -9
Global $CANNOT_OPEN_GROUP = -10
Global $CANNOT_MOVE_GROUP = -11
Global $CANNOT_OFFLINE_GROUP = -12
Global $CANNOT_ONLINE_GROUP = -13
Global $CANNOT_GET_GROUP_STATE = -14

Func ClusterAPI_Start()
	$hClusterDLL = DllOpen("clusapi.dll")

	If $hClusterDLL == -1 Then
		SetError($CANNOT_OPEN_DLL)
	EndIf
EndFunc

Func ClusterAPI_Connect($ClusterName)
	$hCluster = DllCall($hClusterDLL,"HANDLE","OpenCluster","wstr",$ClusterName)
	__VerifyClusterHandle()

	If @error <> 0 or $bIsValidClusterHandle == 0 Then
		SetError($CANNOT_CONNECT_CLUSTER)
	EndIf
EndFunc

;~ CLUSTER NODE STATES
;~ -------------------------
;~ ClusterNodeUp
;~ 0 The node is physically plugged in, turned on, booted, and capable of executing programs.
;~
;~ ClusterNodeDown
;~ 1 The node is turned off or not operational.
;~
;~ ClusterNodeJoining
;~ 3 The node is in the process of joining a cluster.
;~
;~ ClusterNodePaused
;~ 2 The node is running but not participating in cluster operations.
;~
;~ ClusterNodeStateUnknown
;~ -1 The operation was not successful. For more information about the error, call the function GetLastError.
Func ClusterAPI_GetNodeState($NodeName)
	If $bIsValidClusterHandle == 1 Then

		$hNode = DllCall($hClusterDLL,"HANDLE","OpenClusterNode","HANDLE",$hCluster[0], "wstr",$NodeName)

		If $hNode[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_NODE)
		Else
			$iNodeState = DllCall($hClusterDLL,"int","GetClusterNodeState","HANDLE",$hNode[0])

			If $iNodeState[0] == "" Then
				SetError($CANNOT_GET_NODE_STATE)
			Else
				return $iNodeState[0]
			EndIf
		EndIf

	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc

;~ CLUSTER RESOURCE STATES
;~ -----------------------------
;~ ClusterResourceInitializing
;~ 1 The resource is performing initialization.
;~
;~ ClusterResourceOnline
;~ 2 The resource is operational and functioning normally.
;~
;~ ClusterResourceOffline
;~ 3 The resource is not operational. This value will be returned if the resource reported a state of ClusterResourceOffline (3) or ClusterResourceCannotComeOnlineOnThisNode (127).
;~
;~ ClusterResourceFailed
;~ 4 The resource has failed. This value will be returned if the resource reported a state of ClusterResourceFailed (4) or ClusterResourceCannotComeOnlineOnAnyNode (126).
;~
;~ ClusterResourcePending
;~ 128 The resource is in the process of coming online or going offline.
;~
;~ ClusterResourceOnlinePending
;~ 129 The resource is in the process of coming online.
;~
;~ ClusterResourceOfflinePending
;~ 130 The resource is in the process of going offline.
;~
;~ ClusterResourceStateUnknown
;~ -1 The operation was not successful. For more information about the error, call the function GetLastError.
Func ClusterAPI_GetResourceState($ResourceName)
	If $bIsValidClusterHandle == 1 Then

		$hResource = DllCall($hClusterDLL,"HANDLE","OpenClusterResource","HANDLE",$hCluster[0],"wstr",$ResourceName)
		If $hResource[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_RESOURCE)
		Else
			$iResourceState = DllCall($hClusterDLL,"int","GetClusterResourceState","HANDLE",$hResource[0], "ptr","", "ptr","", "ptr","", "ptr","")

			If $iResourceState[0] == "" Then
				SetError($CANNOT_GET_RESOURCE_STATE)
			Else
				return $iResourceState[0]
			EndIf
		EndIf
	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc


Func ClusterAPI_SetResourceOffline($ResourceName)
	If $bIsValidClusterHandle == 1 Then

		$hResource = DllCall($hClusterDLL,"HANDLE","OpenClusterResource","HANDLE",$hCluster[0],"wstr",$ResourceName)
		If $hResource[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_RESOURCE)
		Else
			$iResult = DllCall($hClusterDLL,"int","OfflineClusterResource","HANDLE",$hResource[0])
			If $iResult[0] <> 0 and $iResult[0] <> 997 Then ;ERROR_SUCCESS and ERROR_IO_PENDING
				SetError($CANNOT_OFFLINE_RES)
			Else
				Return True
			EndIf
		EndIf
	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc


Func ClusterAPI_SetResourceOnline($ResourceName)
	If $bIsValidClusterHandle == 1 Then

		$hResource = DllCall($hClusterDLL,"HANDLE","OpenClusterResource","HANDLE",$hCluster[0],"wstr",$ResourceName)
		If $hResource[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_RESOURCE)
		Else
			$iResult = DllCall($hClusterDLL,"int","OnlineClusterResource","HANDLE",$hResource[0])
			If $iResult[0] <> 0 and $iResult[0] <> 997 Then ;ERROR_SUCCESS and ERROR_IO_PENDING
				SetError($CANNOT_ONLINE_RES,$iResult[0])
			Else
				Return True
			EndIf
		EndIf
	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc


Func ClusterAPI_MoveClusterGroup($GroupName)
	If $bIsValidClusterHandle == 1 Then

		$hGroup = DllCall($hClusterDLL,"HANDLE","OpenClusterGroup","HANDLE",$hCluster[0],"wstr",$GroupName)
		If $hGroup[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_GROUP)
		Else
			$iResult = DllCall($hClusterDLL,"int","MoveClusterGroup","HANDLE",$hGroup[0], "ptr", "")
			If $iResult[0] <> 0 and $iResult[0] <> 997 Then ;ERROR_SUCCESS and ERROR_IO_PENDING
				SetError($CANNOT_MOVE_GROUP,$iResult[0])
			Else
				Return True
			EndIf
		EndIf
	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc

;~ CLUSTER GROUP STATES
;~ -------------------------
;~ ClusterGroupStateUnknown
;~ -1 The operation was not successful. For more information about the error, call the function GetLastError.
;~
;~ ClusterGroupOnline
;~ 0 All of the resources in the group are online.
;~
;~ ClusterGroupOffline
;~ 1 All of the resources in the group are offline or there are no resources in the group.
;~
;~ ClusterGroupFailed
;~ 2 At least one resource in the group has failed (set a state of ClusterResourceFailed from the CLUSTER_RESOURCE_STATE enumeration).
;~
;~ ClusterGroupPartialOnline
;~ 3 At least one resource in the group is online. No resources are pending or failed.
;~
;~ ClusterGroupPending
;~ 4 At least one resource in the group is in a pending state. There are no failed resources.
 Func ClusterAPI_GetGroupState($GroupName)
	If $bIsValidClusterHandle == 1 Then

		$hGroup = DllCall($hClusterDLL,"HANDLE","OpenClusterGroup","HANDLE",$hCluster[0],"wstr",$GroupName)
		If $hGroup[0] == "0x00000000" Then
			SetError($CANNOT_OPEN_GROUP)
		Else
			MsgBox("","","t2")
			$iGroupState = DllCall($hClusterDLL,"int","GetClusterGroupState","HANDLE",$hGroup[0], "ptr","", "ptr","")

			If $iGroupState[0] == "" Then
				SetError($CANNOT_GET_GROUP_STATE,$iGroupState[0])
			Else
				return $iGroupState[0]
			EndIf
		EndIf
	Else
		SetError($MUST_CONNECT_CLUSTER)
	EndIf
EndFunc


Func __VerifyClusterHandle()
	If $hCluster[0] == "0x00000000" Then
		$bIsValidClusterHandle = 0
	Else
		$bIsValidClusterHandle = 1
	EndIf
EndFunc
