#cs
; Gestion de l'extraction d'un ensemble de param�tres en ligne de commande
; $CmdLine[0] = nombre de param�tres
; $CmdLine[1] = param�tre 1

MsgBox(262144, $Param & " <-- Param�tre", "Cliquez sur OK pour fermer")
MsgBox(262144, $Param & " <-- New Param�tre", "Cliquez sur OK pour fermer")

R�cup�ration des strings : 
	1. retrait du backslash
	2. Mise en majuscule
	3. Test des caract�res possible : rechercher + et moins en seconde position (/Y+3 , W-5, ...)
	4. si pas + ou moins, test des mots possibles avec constante tableau Params[1] = "Day", Params[2] ="DateTime", ...
	genre :
	$aiNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$aiNumDays = StringSplit($aiNumDays, ",")

#ce


Dim $ListParam, $Param, $AnalyseParam, $ParamLetter,$ParamWord, $FinalParams
Dim $ParamError[$CmdLine[0]]
; 

$ParamWord ="DATE,DAY,DATETIME,TIME"
$ParamWord = StringSplit($ParamWord,",")
$ParamLetter ="Y,M,D,H,N,S,W"
StringSplit($ParamLetter,",")

IF $CmdLine[0] = 0 Then
	MsgBox(262144, "Fin du Programme  - Pas de param�tres !", "Cliquez sur OK pour fermer")
	exit(255)
Else
	
	for $i = 1 to $CmdLine[0]
		$Param = $CmdLine[$i]
		if StringLeft($Param,1) ="/" Then $Param = StringMid($Param,2) ; retrait de /
		$ListParam = $ListParam & StringUpper($Param) & ","
		
		if StringMid($Param,2,1) = "+" or StringMid($Param,2,1) = "1" Then
				for $j = 1 to $ParamLetter[0]
					if StringLeft($Param,1) = $ParamLetter[$j] then 
						$ParamError[$i] = "Good"
					Else
						$ParamError[$i] ="Bad"
					EndIf
				Next
		Else			
		$AnalyseParam = $AnalyseParam & " Param�tre " & $i & " : " & $Param & @CRLF
		EndIf
	
	Next
	; r�cup�re les param�tres dans $ListParam, en majuscules et transforme en tableau --> $ListParam[0] = nombre de param�tres
	$ListParam = StringLeft($ListParam,(stringlen($ListParam)-1))  ;00A1
	$ListParam = StringSplit($ListParam,",")
EndIf

#cs 00A1
A ce niveau, $ListParam contient la ligne de param�tres avec Virgules genre Y+10,W-5
Un test de conformit� peut �tre r�alis� : boucle -> $GoodParams ="Y,M,D,H,N,S,W,DATE,DAY,DATETIME,TIME" --> stringsplit

	for $i = 1 to $ListParam[0]
		for $j = 1 to $GoodParams[0]
		if $ListParam[$i] = $GoodParams[$j] then $ParamGood = $ParamGood + 1
		next
	next

#ce


SplashTextOn("Nombre de Param�tres : "& $CmdLine[0], @CRLF & $AnalyseParam, 1020,430 , -1, -1, 20, "",12,400)	
MsgBox(262144, "Fin du Programme", "Cliquez sur OK pour fermer")
for $i = 1 to $ListParam[0]
	MsgBox(262144, "Nbr Params = " & $ListParam[0] & " Param " & $i, " --> " & $ListParam[$i])
Next
MsgBox(262144, "Fin du Programme", $CmdLineRaw)
exit  