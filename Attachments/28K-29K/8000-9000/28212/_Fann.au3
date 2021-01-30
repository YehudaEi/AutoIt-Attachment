#include <string.au3>
Global Enum $FANN_LINEAR, $FANN_THRESHOLD, $FANN_THRESHOLD_SYMMETRIC, $FANN_SIGMOID, $FANN_SIGMOID_STEPWISE, $FANN_SIGMOID_SYMMETRIC, _
		$FANN_SIGMOID_SYMMETRIC_STEPWISE, $FANN_GAUSSIAN, $FANN_GAUSSIAN_SYMMETRIC, _; not implemented yet
		$FANN_GAUSSIAN_STEPWISE, $FANN_ELLIOT, $FANN_ELLIOT_SYMMETRIC, $FANN_LINEAR_PIECE, $FANN_LINEAR_PIECE_SYMMETRIC, _
		$FANN_SIN_SYMMETRIC, $FANN_COS_SYMMETRIC, $FANN_SIN, $FANN_COS

Global $hFannDll

Func _InitializeANN()
	$hFannDll = DllOpen(@ScriptDir & "/fannfloat.dll")
EndFunc   ;==>_InitializeANN

Func _ShutDownANN()
	DllClose($hFannDll)
	Return 1
EndFunc   ;==>_ShutDownANN

Func _CloseANN()
	DllClose($hFannDll)
	Return 1
EndFunc   ;==>_CloseANN

Func _CreateAnn($iLayers, $vLayersArray, $iOption = 1, $fConnection = 1)
	Local $ArrayStruct
	If IsArray($vLayersArray) <> 1 Then
		$vLayersArray = StringRegExpReplace($vLayersArray, "\h", "")
		$vLayersArray = _StringExplode($vLayersArray, ",")
	EndIf
	If IsArray($vLayersArray) = 1 Then
		$ArrayStruct = DllStructCreate("uint[" & $iLayers & "]")
		For $i = 1 To $iLayers Step 1
			DllStructSetData($ArrayStruct, 1, $vLayersArray[$i - 1], $i)
		Next
	Else
		ConsoleWrite("Layers variable is not valid." & @CRLF)
		Return "Layers variable is not valid."
	EndIf

	Select
		Case $iOption = 1
			$hAnn = DllCall($hFannDll, "ptr", "_fann_create_standard_array@8", "uint", $iLayers, "ptr", DllStructGetPtr($ArrayStruct))
		Case $iOption = 2
			$hAnn = DllCall($hFannDll, "ptr", "_fann_create_sparse_array@12", "float", $fConnection, "uint", $iLayers, "ptr", DllStructGetPtr($ArrayStruct))
		Case $iOption = 3
			$hAnn = DllCall($hFannDll, "ptr", "_fann_create_shortcut_array@8", "uint", $iLayers, "ptr", DllStructGetPtr($ArrayStruct))
	EndSelect

	Return $hAnn[0]
EndFunc   ;==>_CreateAnn

Func _DestroyANN($hAnn)
	DllCall($hFannDll, "none", "_fann_destroy@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_DestroyANN

Func _ANNCopy($hAnn)
	$AnnCopy = DllCall($hFannDll, "hwnd:cdecl", "_fann_copy@4", "ptr", $hAnn)
	Return $AnnCopy[0]
EndFunc   ;==>_ANNCopy

Func _ANNRun($hAnn, ByRef $arrayOfInput)
	$numInputs = UBound($arrayOfInput)
	$inputStruct = DllStructCreate("float[" & $numInputs & "]")
	For $i = 1 To UBound($arrayOfInput) Step 1
		DllStructSetData($inputStruct, 1, $arrayOfInput[$i - 1], $i)
	Next

	$ANNRun = DllCall($hFannDll, "ptr", "_fann_run@8", "ptr", $hAnn, "ptr", DllStructGetPtr($inputStruct))

	$numOutput = DllCall($hFannDll, "int", "_fann_get_num_output@4", "ptr", $hAnn)
	$outputArrayStruct = DllStructCreate("float[" & $numOutput[0] & "]", $ANNRun[0])

	Local $outputArray[$numOutput[0]]

	For $i = 1 To $numOutput[0] Step 1
		$outputArray[$i - 1] = DllStructGetData($outputArrayStruct, 1, $i)
	Next
	Return $outputArray
EndFunc   ;==>_ANNRun

Func _ANNRandomizeWeights($hAnn, $iMinWeight, $iMaxWeight)
	DllCall($hFannDll, "none", "_fann_randomize_weights@12", _
			"ptr", $hAnn, _
			"dword", $iMinWeight, _
			"dword", $iMaxWeight)
	Return 1
EndFunc   ;==>_ANNRandomizeWeights

Func _ANNInitWeights($hAnn, $ANNTrainData)
	$ANNInit = DllCall($hFannDll, "none", "_fann_init_weights@8", _
			"ptr", $hAnn, _
			"dword", $ANNTrainData)
	Return 1
EndFunc   ;==>_ANNInitWeights

Func _ANNPrintConnections($hAnn)
	DllCall($hFannDll, "none", "_fann_print_connections@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNPrintConnections

Func _ANNPrintParameters($hAnn)
	DllCall($hFannDll, "none", "_fann_print_parameters@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNPrintParameters

Func _ANNGetNumInput($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_num_input@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetNumInput

Func _ANNGetNumOutput($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_num_output@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetNumOutput


Func _ANNGetTotalNeurons($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_total_neurons@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetTotalNeurons

Func _ANNGetTotalConnections($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_total_connections@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetTotalConnections

Func _ANNGetNetworkType($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_network_type@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetNetworkType

Func _ANNGetConnectionRate($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_connection_rate@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetConnectionRate

Func _ANNGetNumLayers($hAnn)
	$DLLCall = DllCall($hFannDll, "int", "_fann_get_num_layers@4", "ptr", $hAnn)
	Return $DLLCall[0]
EndFunc   ;==>_ANNGetNumLayers

Func _ANNGetLayerArray($hAnn)
	$numLayers = _ANNGetNumLayers($hAnn)
	$layersArrayStruct = DllStructCreate("int[" & $numLayers & "]")
	DllCall($hFannDll, "none", "_fann_get_layer_array@8", "ptr", $hAnn, "uint", DllStructGetPtr($layersArrayStruct))
	Local $LayersArray[$numLayers]
	For $i = 1 To $numLayers Step 1
		$LayersArray[$i - 1] = DllStructGetData($layersArrayStruct, 1, $i)
	Next
	Return $LayersArray
EndFunc   ;==>_ANNGetLayerArray

Func _ANNGetBiasArray($hAnn)
	$numLayers = _ANNGetNumLayers($hAnn)

	$BiasArrayStruct = DllStructCreate("int[" & $numLayers & "]")

	DllCall($hFannDll, "none", "_fann_get_bias_array@8", "ptr", $hAnn, "uint", DllStructGetPtr($BiasArrayStruct))
	Local $BiasArray[$numLayers]
	For $i = 1 To $numLayers Step 1
		$BiasArray[$i - 1] = DllStructGetData($BiasArrayStruct, 1, $i)
	Next
	Return $BiasArray
EndFunc   ;==>_ANNGetBiasArray

Func _ANNGetConnectionArray($hAnn)
	$numConnections = _ANNGetTotalConnections($hAnn)
	$ConnectionArrayStruct = DllStructCreate("int[" & $numConnections & "];" & "int[" & $numConnections & "];" & "float[" & $numConnections & "]")
	DllCall($hFannDll, "none", "_fann_get_connection_array@8", "ptr", $hAnn, "ptr", DllStructGetPtr($ConnectionArrayStruct))
	Local $ConnectionArray[$numConnections][3]
	For $i = 1 To $numConnections Step 1
		$ConnectionArray[$i - 1][0] = DllStructGetData($ConnectionArrayStruct, 1, $i)
		$ConnectionArray[$i - 1][1] = DllStructGetData($ConnectionArrayStruct, 2, $i)
		$ConnectionArray[$i - 1][2] = DllStructGetData($ConnectionArrayStruct, 3, $i)
	Next
	Return $ConnectionArray
EndFunc   ;==>_ANNGetConnectionArray

Func _ANNSetWeightArray($hAnn, $WeightArray)
	$numConnections = _ANNGetTotalConnections($hAnn)
	$WeightArrayStruct = DllStructCreate("int[" & $numConnections & "];" & "int[" & $numConnections & "];" & "float[" & $numConnections & "]")
	For $i = 1 To $numConnections Step 1
		DllStructSetData($WeightArrayStruct, 1, $WeightArray[$i - 1][0])
		DllStructSetData($WeightArrayStruct, 2, $WeightArray[$i - 1][1])
		DllStructSetData($WeightArrayStruct, 3, $WeightArray[$i - 1][2])
	Next
	DllCall($hFannDll, "none", "_fann_set_weight_array@12", "ptr", $hAnn, _
			"ptr", DllStructGetPtr($WeightArrayStruct), _
			"int", $numConnections)
	Return 1
EndFunc   ;==>_ANNSetWeightArray

Func _ANNSetWeight($hAnn, $iFromNeuron, $iToNeuron, $fWeight)
	DllCall($hFannDll, "none", "_fann_set_weight@12", "ptr", $hAnn, "int", $iFromNeuron, "int", $iToNeuron, "float", $fWeight)
	Return 1
EndFunc   ;==>_ANNSetWeight

Func _ANNTrain($hAnn, $aInput, $aOutput)
	$numInput = _ANNGetNumInput($hAnn)
	$numOutput = _ANNGetNumOutput($hAnn)

	$InputsArrayStruct = DllStructCreate("float[" & $numInput & "]")
	$OutputsArrayStruct = DllStructCreate("float[" & $numOutput & "]")

	For $i = 1 To $numInput Step 1
		DllStructSetData($InputsArrayStruct, 1, $aInput[$i - 1])
	Next

	For $i = 1 To $numOutput Step 1
		DllStructSetData($OutputsArrayStruct, 1, $aOutput[$i - 1])
	Next


	DllCall($hFannDll, "none", "_fann_train@12", "ptr", $hAnn, _
			"ptr", DllStructGetPtr($InputsArrayStruct), _
			"ptr", DllStructGetPtr($OutputsArrayStruct))
	Return 1
EndFunc   ;==>_ANNTrain

Func _ANNTest($hAnn, $aInput, $aOutput)
	$numInput = _ANNGetNumInput($hAnn)
	$numOutput = _ANNGetNumOutput($hAnn)
	$InputsArrayStruct = DllStructCreate("float[" & $numInput & "]")
	$OutputsArrayStruct = DllStructCreate("float[" & $numOutput & "]")

	For $i = 1 To $numInput Step 1
		DllStructSetData($InputsArrayStruct, 1, $aInput[$i - 1])
	Next

	For $i = 1 To $numOutput Step 1
		DllStructSetData($OutputsArrayStruct, 1, $aOutput[$i - 1])
	Next

	$AnnCall = DllCall($hFannDll, "float", "_fann_test@12", "ptr", $hAnn, _
			"ptr", DllStructGetPtr($InputsArrayStruct), _
			"ptr", DllStructGetPtr($OutputsArrayStruct))
	Return $AnnCall[0]
EndFunc   ;==>_ANNTest

Func _ANNGetMSE($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_mse@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetMSE

Func _ANNGetBitFail($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_bit_fail@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetBitFail

Func _ANNResetMSE($hAnn)
	DllCall($hFannDll, "none", "_fann_reset_MSE@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNResetMSE

Func _ANNTrainOnData($hAnn, $aInputs, $aOutputs, $iMaxEpochs, $iEpochsBetweenReports, $fDesiredError)
	$numSets = UBound($aInputs, 1)
	$numInputs = UBound($aInputs, 2)
	$numOutputs = UBound($aOutputs, 2)
	Local $inputArrayStructData[$numSets], $outputArrayStructData[$numSets], $DataStruct[2]

	;Initialize and fill the input and output DATA struct array/s
	For $i = 1 To $numSets Step 1
		$inputArrayStructData[$i - 1] = DllStructCreate("float[" & $numInputs & "]")
		For $j = 1 To $numInputs Step 1
			DllStructSetData($inputArrayStructData[$i - 1], 1, $aInputs[$i - 1][$j - 1], $j)
		Next

		$outputArrayStructData[$i - 1] = DllStructCreate("float[" & $numOutputs & "]")
		For $k = 1 To $numOutputs Step 1
			DllStructSetData($outputArrayStructData[$i - 1], 1, $aOutputs[$i - 1][$k - 1], $k)
		Next
	Next

	;inputs
	$DataStruct[0] = DllStructCreate("ptr[" & $numSets & "]")
	;outputs
	$DataStruct[1] = DllStructCreate("ptr[" & $numSets & "]")
	;Fill in the Datastruct pointers
	For $i = 1 To $numSets Step 1
		DllStructSetData($DataStruct[0], 1, DllStructGetPtr($inputArrayStructData[$i - 1]), $i)
		DllStructSetData($DataStruct[1], 1, DllStructGetPtr($outputArrayStructData[$i - 1]), $i)
	Next

	;initialize train_data struct

	$trainDataStruct = DllStructCreate("int;ptr;ptr;uint numdata;uint numinput;uint numoutput;ptr inputs;ptr outputs")

	;Fill in train_data struct
	DllStructSetData($trainDataStruct, "numdata", $numSets)
	DllStructSetData($trainDataStruct, "numinput", $numInputs)
	DllStructSetData($trainDataStruct, "numoutput", $numOutputs)

	DllStructSetData($trainDataStruct, "inputs", DllStructGetPtr($DataStruct[0]))

	DllStructSetData($trainDataStruct, "outputs", DllStructGetPtr($DataStruct[1]))

	DllCall($hFannDll, "none", "_fann_train_on_data@20", "ptr", $hAnn, _
			"ptr", DllStructGetPtr($trainDataStruct), _
			"dword", $iMaxEpochs, _
			"dword", $iEpochsBetweenReports, _
			"float", $fDesiredError)
	Return 1

EndFunc   ;==>_ANNTrainOnData


Func _ANNTrainOnFile($hAnn, $sFileName, $iMaxEpochs, $iEpochsBetweenReports, $fDesiredError)

	DllCall($hFannDll, "none", "_fann_train_on_file@20", "ptr", $hAnn, _
			"str", $sFileName, _
			"int", $iMaxEpochs, _
			"int", $iEpochsBetweenReports, _
			"float", $fDesiredError)

	Return 1
EndFunc   ;==>_ANNTrainOnFile

Func _ANNTrainEpoch($hAnn, $aInputs, $aOutputs)
	$numSets = UBound($aInputs, 1)
	$numInputs = UBound($aInputs, 2)
	$numOutputs = UBound($aOutputs, 2)

	Local $inputArrayStructData[$numSets], $outputArrayStructData[$numSets], $DataStruct[2]

	;Initialize and fill the input and output DATA struct array/s

	For $i = 1 To $numSets Step 1
		$inputArrayStructData[$i - 1] = DllStructCreate("float[" & $numInputs & "]")
		For $j = 1 To $numInputs Step 1
			DllStructSetData($inputArrayStructData[$i - 1], 1, $aInputs[$i - 1][$j - 1], $j)
		Next

		$outputArrayStructData[$i - 1] = DllStructCreate("float[" & $numOutputs & "]")
		For $k = 1 To $numOutputs Step 1
			DllStructSetData($outputArrayStructData[$i - 1], 1, $aOutputs[$i - 1][$k - 1], $k)
		Next
	Next

	;Initialize the DLLCall DataStruct pointers

	;inputs
	$DataStruct[0] = DllStructCreate("ptr[" & $numSets & "]")
	;outputs
	$DataStruct[1] = DllStructCreate("ptr[" & $numSets & "]")

	;Fill in the Datastruct pointers
	For $i = 1 To $numSets Step 1
		DllStructSetData($DataStruct[0], 1, DllStructGetPtr($inputArrayStructData[$i - 1]), $i)
		DllStructSetData($DataStruct[1], 1, DllStructGetPtr($outputArrayStructData[$i - 1]), $i)
	Next

	;initialize train_data struct

	$trainDataStruct = DllStructCreate("int;ptr;ptr;uint numdata;uint numinput;uint numoutput;ptr inputs;ptr outputs")

	;Fill in train_data struct
	DllStructSetData($trainDataStruct, "numdata", $numSets)
	DllStructSetData($trainDataStruct, "numinput", $numInputs)
	DllStructSetData($trainDataStruct, "numoutput", $numOutputs)

	DllStructSetData($trainDataStruct, "inputs", DllStructGetPtr($DataStruct[0]))

	DllStructSetData($trainDataStruct, "outputs", DllStructGetPtr($DataStruct[1]))

	DllCall($hFannDll, "none", "_fann_train_epoch@8", "ptr", $hAnn, _
			"ptr", DllStructGetPtr($trainDataStruct))
	Return 1

EndFunc   ;==>_ANNTrainEpoch

Func _ANNTestData($hAnn, $hData)
	$AnnCall = DllCall($hFannDll, "float", "_fann_test_data@8", "ptr", $hAnn, "ptr", $hData)
	Return $AnnCall[0]
EndFunc   ;==>_ANNTestData

Func _ANNReadTrainFromFile($sFileName)
	$AnnTrain = DllCall($hFannDll, "ptr", "_fann_read_train_from_file@4", "str", $sFileName)
	Return $AnnTrain[0]
EndFunc   ;==>_ANNReadTrainFromFile

Func _ANNDestroyTrain($hTrainData)
	DllCall($hFannDll, "none", "_fann_destroy_train@4", "ptr", $hTrainData)
	Return 1
EndFunc   ;==>_ANNDestroyTrain

Func _ANNShuffleTrainData($hTrainData)
	DllCall($hFannDll, "none", "_fann_shuffle_train_data@4", "ptr", $hTrainData)
	Return 1
EndFunc   ;==>_ANNShuffleTrainData

Func _ANNSetInputScalingParams($hAnn, $hTrainData, $fNewInputMin, $fNewInputMax)
	DllCall($hFannDll, "none", "_fann_set_input_scaling_params@16", "ptr", $hAnn, "ptr", $hTrainData, _
			"float", $fNewInputMin, _
			"float", $fNewInputMax)
	Return 1
EndFunc   ;==>_ANNSetInputScalingParams

Func _ANNSetOutputScalingParams($hAnn, $hTrainData, $fNewOutputMin, $fNewOutputMax)
	DllCall($hFannDll, "none", "_fann_set_output_scaling_params@16", "ptr", $hAnn, "ptr", $hTrainData, _
			"float", $fNewOutputMin, _
			"float", $fNewOutputMax)
	Return 1
EndFunc   ;==>_ANNSetOutputScalingParams

Func _ANNSetScalingParams($hAnn, $hTrainData, $fNewInputMin, $fNewInputMax, $fNewOutputMin, $fNewOutputMax)
	DllCall($hFannDll, "none", "_fann_set_scaling_params@24", "ptr", $hAnn, "ptr", $hTrainData, _
			"float", $fNewInputMin, _
			"float", $fNewInputMax, _
			"float", $fNewOutputMin, _
			"float", $fNewOutputMax)
	Return 1
EndFunc   ;==>_ANNSetScalingParams

Func _ANNClearScalingParams($hAnn)
	DllCall($hFannDll, "none", "_fann_clear_scaling_params@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNClearScalingParams

Func _AnnScaleInputTrainData($hTrainData, $fMin, $fMax)
	DllCall($hFannDll, "none", "_fann_scale_input_train_data@12", "ptr", $hTrainData, _
			"float", $fMin, _
			"float", $fMax)
	Return 1
EndFunc   ;==>_AnnScaleInputTrainData

Func _AnnScaleOutputTrainData($hTrainData, $fMin, $fMax)
	DllCall($hFannDll, "none", "_fann_scale_output_train_data@12", "ptr", $hTrainData, _
			"float", $fMin, _
			"float", $fMax)
	Return 1
EndFunc   ;==>_AnnScaleOutputTrainData

Func _AnnScaleTrainData($hTrainData, $fMin, $fMax)
	DllCall($hFannDll, "none", "_fann_scale_train_data@12", "ptr", $hTrainData, _
			"float", $fMin, _
			"float", $fMax)
	Return 1
EndFunc   ;==>_AnnScaleTrainData

Func _ANNGetLengthTrainData($hTrainData)
	$TrainDataLength = DllCall($hFannDll, "int", "_fann_length_train_data@4", "ptr", $hTrainData)
	Return $TrainDataLength[0]
EndFunc   ;==>_ANNGetLengthTrainData

Func _ANNGetNumInputTrainData($hTrainData)
	$TrainDataNumInputs = DllCall($hFannDll, "int", "_fann_num_input_train_data@4", "ptr", $hTrainData)
	Return $TrainDataNumInputs[0]
EndFunc   ;==>_ANNGetNumInputTrainData

Func _ANNGetNumOutputTrainData($hTrainData)
	$TrainDataNumOutputs = DllCall($hFannDll, "int", "_fann_num_output_train_data@4", "ptr", $hTrainData)
	Return $TrainDataNumOutputs[0]
EndFunc   ;==>_ANNGetNumOutputTrainData

Func _ANNGetTrainingAlgorithm($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_training_algorithm@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetTrainingAlgorithm

Func _ANNSetTrainingAlgorithm($hAnn, $iAlgorithmEnum)
	DllCall($hFannDll, "none", "_fann_set_training_algorithm@8", "ptr", $hAnn, "int", $iAlgorithmEnum)
	Return 1
EndFunc   ;==>_ANNSetTrainingAlgorithm

Func _ANNGetLearningRate($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_learning_rate@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetLearningRate

Func _ANNSetLearningRate($hAnn, $fLearningRate)
	DllCall($hFannDll, "none", "_fann_set_learning_rate@8", "ptr", $hAnn, "float", $fLearningRate)
	Return 1
EndFunc   ;==>_ANNSetLearningRate

Func _ANNGetLearningMomentum($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_learning_momentum@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetLearningMomentum

Func _ANNSetLearningMomentum($hAnn, $fLearningMomentum)
	DllCall($hFannDll, "none", "_fann_set_learning_momentum@8", "ptr", $hAnn, "float", $fLearningMomentum)
	Return 1
EndFunc   ;==>_ANNSetLearningMomentum

Func _ANNGetActivationFunction($hAnn, $iLayer, $iNeuron)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_activation_function@12", "ptr", $hAnn, _
			"int", $iLayer, _
			"int", $iNeuron)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetActivationFunction

Func _ANNSetActivationFunction($hAnn, $iEnumActivation, $iLayer, $iNeuron)
	DllCall($hFannDll, "none", "_fann_set_activation_function@16", "ptr", $hAnn, _
			"int", $iEnumActivation, _
			"int", $iLayer, _
			"int", $iNeuron)
	Return 1
EndFunc   ;==>_ANNSetActivationFunction

Func _ANNSetActivationFunctionLayer($hAnn, $iEnumActivation, $iLayer)
	DllCall($hFannDll, "none", "_fann_set_activation_function_layer@12", "ptr", $hAnn, _
			"int", $iEnumActivation, _
			"int", $iLayer)
	Return 1
EndFunc   ;==>_ANNSetActivationFunctionLayer

Func _ANNSetActivationFunctionHidden($hAnn, $iEnumActivation)
	DllCall($hFannDll, "none", "_fann_set_activation_function_hidden@8", "ptr", $hAnn, "int", $iEnumActivation)
	Return 1
EndFunc   ;==>_ANNSetActivationFunctionHidden

Func _ANNSetActivationFunctionOutput($hAnn, $iEnumActivation)
	DllCall($hFannDll, "none", "_fann_set_activation_function_output@8", "ptr", $hAnn, "int", $iEnumActivation)
	Return 1
EndFunc   ;==>_ANNSetActivationFunctionOutput

Func _ANNGetActivationSteepness($hAnn, $iLayer, $iNeuron)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_activation_steepness@12", "ptr", $hAnn, _
			"int", $iLayer, _
			"int", $iNeuron)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetActivationSteepness

Func _ANNSetActivationSteepness($hAnn, $fActivationSteepness, $iLayer, $iNeuron)
	DllCall($hFannDll, "none", "_fann_set_activation_steepness@16", "ptr", $hAnn, _
			"float", $fActivationSteepness, _
			"int", $iLayer, _
			"int", $iNeuron)
	Return 1
EndFunc   ;==>_ANNSetActivationSteepness

Func _ANNSetActivationSteepnessLayer($hAnn, $fSteepness, $iLayer)
	DllCall($hFannDll, "none", "_fann_set_activation_steepness_layer@12", "ptr", $hAnn, _
			"float", $fSteepness, _
			"int", $iLayer)
	Return 1
EndFunc   ;==>_ANNSetActivationSteepnessLayer

Func _ANNSetActivationSteepnessHidden($hAnn, $fSteepness)
	DllCall($hFannDll, "none", "_fann_set_activation_steepness_hidden@8", "ptr", $hAnn, _
			"float", $fSteepness)
	Return 1
EndFunc   ;==>_ANNSetActivationSteepnessHidden

Func _ANNSetActivationSteepnessOutput($hAnn, $fSteepness)
	DllCall($hFannDll, "none", "_fann_set_activation_steepness_output@8", "ptr", $hAnn, _
			"float", $fSteepness)
	Return 1
EndFunc   ;==>_ANNSetActivationSteepnessOutput

Func _ANNGetTrainErrorFunction($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_train_error_function@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetTrainErrorFunction

Func _ANNSetTrainErrorFunction($hAnn, $iEnumErrorFunction)
	DllCall($hFannDll, "none", "_fann_set_train_error_function@8", "ptr", $hAnn, "int", $iEnumErrorFunction)
	Return 1
EndFunc   ;==>_ANNSetTrainErrorFunction

Func _ANNGetTrainStopFunction($hAnn)
	$AnnCall = DllCall($hFannDll, "int", "_fann_get_train_stop_function@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetTrainStopFunction

Func _ANNSetTrainStopFunction($hAnn, $iEnumStopFunction)
	DllCall($hFannDll, "none", "_fann_set_train_stop_function@8", "ptr", $hAnn, "int", $iEnumStopFunction)
	Return 1
EndFunc   ;==>_ANNSetTrainStopFunction

Func _ANNGetBitFailLimit($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_bit_fail_limit@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetBitFailLimit

Func _ANNSetBitFailLimit($hAnn, $fBitFailLimit)
	DllCall($hFannDll, "none", "_fann_set_bit_fail_limit@8", "ptr", $hAnn, "float", $fBitFailLimit)
	Return 1
EndFunc   ;==>_ANNSetBitFailLimit

Func _ANNGetQuickPropDecay($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_quick_prop_decay@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetQuickPropDecay

Func _ANNSetQuickPropDecay($hAnn, $fQuickPropDecay)
	DllCall($hFannDll, "none", "_fann_set_quick_prop_decay@8", "ptr", $hAnn, "float", $fQuickPropDecay)
	Return 1
EndFunc   ;==>_ANNSetQuickPropDecay

Func _ANNGetQuickPropMu($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_quick_prop_mu@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetQuickPropMu

Func _ANNSetQuickPropMu($hAnn, $fQuickPropMu)
	DllCall($hFannDll, "none", "_fann_set_quick_prop_mu@8", "ptr", $hAnn, "float", $fQuickPropMu)
	Return 1
EndFunc   ;==>_ANNSetQuickPropMu

Func _ANNGetRpropIncreaseFactor($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_rprop_increase_factor@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetRpropIncreaseFactor

Func _ANNSetRpropIncreaseFactor($hAnn, $fIncreaseFactor)
	DllCall($hFannDll, "none", "_fann_set_rprop_increase_factor@8", "ptr", $hAnn, "float", $fIncreaseFactor)
	Return 1
EndFunc   ;==>_ANNSetRpropIncreaseFactor

Func _ANNGetRpropDecreaseFactor($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_rprop_decrease_factor@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetRpropDecreaseFactor

Func _ANNSetRpropDecreaseFactor($hAnn, $fDecreaseFactor)
	DllCall($hFannDll, "none", "_fann_set_rprop_decrease_factor@8", "ptr", $hAnn, "float", $fDecreaseFactor)
	Return 1
EndFunc   ;==>_ANNSetRpropDecreaseFactor

Func _ANNGetRpropDeltaMin($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_rprop_delta_min@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetRpropDeltaMin

Func _ANNSetRpropDeltaMin($hAnn, $fDeltaMin)
	DllCall($hFannDll, "none", "_fann_set_rprop_delta_min@8", "ptr", $hAnn, "float", $fDeltaMin)
	Return 1
EndFunc   ;==>_ANNSetRpropDeltaMin

Func _ANNGetRpropDeltaMax($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_rprop_delta_max@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetRpropDeltaMax

Func _ANNSetRpropDeltaMax($hAnn, $fDeltaMax)
	DllCall($hFannDll, "none", "_fann_set_rprop_delta_max@8", "ptr", $hAnn, "float", $fDeltaMax)
	Return 1
EndFunc   ;==>_ANNSetRpropDeltaMax

Func _ANNGetRpropDeltaZero($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_rprop_delta_zero@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetRpropDeltaZero

Func _ANNSetRpropDeltaZero($hAnn, $fDeltaZero)
	DllCall($hFannDll, "none", "_fann_set_rprop_delta_zero@8", "ptr", $hAnn, "float", $fDeltaZero)
	Return 1
EndFunc   ;==>_ANNSetRpropDeltaZero

Func _ANNGetSarpropWeightDecayShift($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_sarprop_weight_decay_shift@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetSarpropWeightDecayShift

Func _ANNSetSarpropWeightDecayShift($hAnn, $fWeightDecayShift)
	DllCall($hFannDll, "none", "_fann_set_sarprop_weight_decay_shift@8", "ptr", $hAnn, "float", $fWeightDecayShift)
	Return 1
EndFunc   ;==>_ANNSetSarpropWeightDecayShift

Func _ANNGetSarpropStepErrorThresholdFactor($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_sarprop_step_error_threshold_factor@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetSarpropStepErrorThresholdFactor

Func _ANNSetSarpropStepErrorThresholdFactor($hAnn, $fErrorThresholdFactor)
	DllCall($hFannDll, "none", "_fann_set_sarprop_step_error_threshold_factor@8", "ptr", $hAnn, "float", $fErrorThresholdFactor)
	Return 1
EndFunc   ;==>_ANNSetSarpropStepErrorThresholdFactor

Func _ANNGetSarpropStepErrorShift($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_sarprop_step_error_shift@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetSarpropStepErrorShift

Func _ANNSetSarpropStepErrorShift($hAnn, $fErrorShift)
	DllCall($hFannDll, "none", "_fann_set_sarprop_step_error_shift@8", "ptr", $hAnn, "float", $fErrorShift)
	Return 1
EndFunc   ;==>_ANNSetSarpropStepErrorShift

Func _ANNGetSarpropTemp($hAnn)
	$AnnCall = DllCall($hFannDll, "float", "_fann_get_sarprop_temperature@4", "ptr", $hAnn)
	Return $AnnCall[0]
EndFunc   ;==>_ANNGetSarpropTemp

Func _ANNSetSarpropTemp($hAnn, $fTemp)
	DllCall($hFannDll, "none", "_fann_set_sarprop_temperature@8", "ptr", $hAnn, "float", $fTemp)
	Return 1
EndFunc   ;==>_ANNSetSarpropTemp

Func _ANNCreateFromFile($sFileName)
	$AnnCall = DllCall($hFannDll, "ptr", "_fann_create_from_file@4", "str", $sFileName)
	Return $AnnCall[0]
EndFunc   ;==>_ANNCreateFromFile

Func _ANNSaveToFile($hAnn, $sFileName)
	DllCall($hFannDll, "none", "_fann_save@8", "ptr", $hAnn, "str", $sFileName)
	Return 1
EndFunc   ;==>_ANNSaveToFile


Func _ANNDuplicateTrainData($hTrainData)
	$TrainData = DllCall($hFannDll, "ptr", "_fann_duplicate_train_data@4", "ptr", $hTrainData)
	Return $TrainData[0]
EndFunc   ;==>_ANNDuplicateTrainData

Func _ANNGetErrorNumber($hAnn)
	$errorNumber = DllCall($hFannDll, "int", "_fann_get_errno@4", "ptr", $hAnn)
	Return $errorNumber[0]
EndFunc   ;==>_ANNGetErrorNumber


Func _ANNGetErrorString($hAnn)
	$errorString = DllCall($hFannDll, "str", "_fann_get_errstr@4", "ptr", $hAnn)
	Return $errorString[0]
EndFunc   ;==>_ANNGetErrorString

Func _ANNGetUserData($hAnn)
	$UserDataPtr = DllCall($hFannDll, "ptr", "_fann_get_errstr@4", "ptr", $hAnn)
	Return $UserDataPtr[0]
EndFunc   ;==>_ANNGetUserData

Func _ANNPrintError($hAnn)
	DllCall($hFannDll, "none", "_fann_print_error@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNPrintError

Func _ANNResetErrorNumber($hAnn)
	DllCall($hFannDll, "none", "_fann_reset_errno@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNResetErrorNumber

Func _ANNResetErrorString($hAnn)
	DllCall($hFannDll, "none", "_fann_reset_errstr@4", "ptr", $hAnn)
	Return 1
EndFunc   ;==>_ANNResetErrorString

Func _AnnGetNeuron($hAnn, $iLayer, $iNeuron)
	$Neuron = DllCall($hFannDll, "float", "_fann_get_neuron@12", "ptr", $hAnn, _
			"int", $iLayer, _
			"int", $iNeuron)
	Return $Neuron[0]
EndFunc   ;==>_AnnGetNeuron
