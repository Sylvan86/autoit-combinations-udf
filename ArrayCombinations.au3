#include-once
#include <Array.au3>

; License .......: This work is free.
;                  You can redistribute it and/or modify it under the terms of the Do What The Fuck You Want To Public License, Version 2,
;                  as published by Sam Hocevar.
;                  See http://www.wtfpl.net/ for more details.

#Region Examples
If @ScriptName = "ArrayCombinations.au3" Then ; main function (doesn't run if file is only included)

; Das Elemente-Array:
	Global $aA[] = ["A", "B", "C", "D", "E", "F"]
; Größe der zu ziehenden Stichprobe:
	Global $k = 3

; Permutation (=Variation aller Elemente)
	$aPermutations = _comb_Permute($aA)
	_ArrayDisplay($aPermutations, "Alle Permutationen", "", 64)

; Kombinationen von k Elementen ohne Zurücklegen
	$aCombs = _comb_Combinations($aA, $k)
	_ArrayDisplay($aCombs, $k & "er-Kombinationen ohne Zurücklegen", "", 64)

; Kombinationen von k Elementen mit Zurücklegen
	$aCombsRep = _comb_Combinations_Repetition($aA, $k)
	_ArrayDisplay($aCombsRep, $k & "er-Kombinationen mit Zurücklegen", "", 64)

; Alle Kombinationen mit Stichprobengröße 1 bis k
	$aCombsRepAll = _comb_Combinations_Repetition_All($aA, $k)
	$aCombsRepAll2D = _comb_ArrayInArrayTo2D($aCombsRepAll)
	_ArrayDisplay($aCombsRepAll2D, "Alle Kombinationen bis " & $k & " Elemente", "", 64 )

; Variationen mit Zurücklegen
	$aVariations = _comb_Variations($aA, $k)
	_ArrayDisplay($aVariations, $k & "er Variationen ohne Zurücklegen", "", 64)

; Variationen ohne Zurücklegen
	$aVariationsRep = _comb_Variations_Repetition($aA, $k)
	_ArrayDisplay($aVariationsRep, $k & "er Variationen mit Zurücklegen", "", 64)

EndIf
#EndRegion Examples

; all combinations of the elements of $aArray with $iK elements without repetition
Func _comb_Combinations(ByRef $aArray, Const $iK, Const $iStart = 0)
	Local $iN = UBound($aArray), _
          $iTotal = __comb_binomialcoefficient($iN, $iK), _
		  $iC, _ ; current index
          $iR = 1, _ ; current row of output
          $aRet[$iTotal][$iK], _  ; return array
		  $aInd[$iK] ; array holding the current indices

	; fill index array and write out first combination
	For $i = 0 To $iK - 1
		$aInd[$i] = $i
		$aRet[0][$i] = $aArray[$i]
	Next

	While $aInd[0] < $iN - $iK
		; loop backwards until item is less than it's max permitted value:
		For $i = $iK -1 To 0 Step -1
			If $aInd[$i] < $iN - $iK + $i Then
				$aInd[$i] += 1
				$iC = $i
				ExitLoop
			EndIf
		Next

		; put ascending numbers in the rest of the array
		For $i= $iC + 1 To $iK - 1
			$aInd[$i] = $aInd[$i - 1] + 1
		Next

		; write out current combination
		for $i = 0 To $iK - 1
			$aRet[$iR][$i] = $aArray[$aInd[$i]]
		Next
		$iR += 1
	WEnd

	Return $aRet
EndFunc   ;==>_comb_Combinations


; all combinations with repetition with all group sizes from 1 to $ik
; return array of arrays where elements = groups
Func _comb_Combinations_Repetition_All(ByRef $aArray, Const $iK)
	Local $iN = UBound($aArray), $iNResults = 0, $aTmp

	For $i = 1 To $iK
		$iNResults += __comb_binomialcoefficient($iN + $i - 1, $i)
	Next

	Local $aRet[$iNResults], $iR = 0

	For $i = 1 To $iK
		$aTmp = _comb_Combinations_Repetition($aArray, $i)
		Local $aGroup[$i]
		For $j = 0 To UBound($aTmp) - 1
			For $k = 0 To $i - 1
				$aGroup[$k] = $aTmp[$j][$k]
			Next
			$aRet[$iR] = $aGroup
			$iR += 1
		Next
	Next

	Return $aRet
EndFunc   ;==>_comb_Combinations_Repetition_All

; #FUNCTION# ======================================================================================
; Name ..........: _comb_Combinations_Repetition
; Description ...: all combinations of the elements of $aArray with $iK elements each with repetition of elements (unlike _ArrayCombinations)
;                  That means:
;                    - create groups of $iK elements (combination/variation - not! "permutation" )
;                    - the order of the elements is unimportant ("combination" - not! "variation")
;                    - inside the group an element can appear more than once ("repetition")
; Syntax ........: _comb_Combinations_Repetition(ByRef $aArray, Const $iK)
; Parameters ....: $aArray   - 0-based 1D-Array with elements to combine
;                  $iK       - group size for results
; Return values .: Success - Return 2D-Array[...][$iK] where row = combination and columns = group elements
;                  Failure - Return Null and set @error
; stolen from ...: https://rosettacode.org/wiki/Combinations_with_repetitions#C.2B.2B
; Author ........: AspirinJunkie
; Last changed ..: 2021-07-26
; =================================================================================================
Func _comb_Combinations_Repetition(ByRef $aArray, Const $iK)
	If UBound($aArray, 0) <> 1 Then Return SetError(1, UBound($aArray, 0), Null)
	If $iK < 1 Then Return SetError(2, $iK, Null)

	Local $iN = UBound($aArray) - 1
	Local $iNResults = __comb_binomialcoefficient($iN + $ik, $iK)
	Local $aRet[$iNResults][$iK]
	Local $aInd[$iK + 1]
	Local $cR = 0

	Do
		; determine indices for next combination set:
		For $i = 0 To $iK - 1
			If $aInd[$i] > $iN Then
				$aInd[$i + 1] += 1
				For $x = $i To 0 Step -1
					$aInd[$x] = $aInd[$i + 1]
				Next
			EndIf
		Next

		If $aInd[$iK] > 0 Then ExitLoop

		; write current combination:
		For $i = 0 To $iK - 1
			$aRet[$cR][$i] = $aArray[$aInd[$i]]
		Next
		$cR += 1

		$aInd[0] += 1
	Until False

	Return SetExtended($cR, $aRet)
EndFunc   ;==>_comb_Combinations_Repetition

; calculates the binomial coefficient (n over k)
; note: might reach limit even if result might not
; so for large results use other approach
Func __comb_binomialcoefficient($n, $k)
	Local $iR = 1

	If $k > ($n - $k) Then $k = $n - $k

	For $i = 0 To $k - 1
		$iR *= $n - $i
		$iR /= $i + 1
	Next

	Return $iR
EndFunc   ;==>__comb_binomialcoefficient


; Heaps algorithm:
Func _comb_Permute(ByRef $aArray, Const $iK = UBound($aArray), $bFirst = True)
	Local Static $iN, $iC, $iTotal, $aRet[0][0]
	Local $vTmp

	If $bFirst Then
		$iN = UBound($aArray)
		$iC = 0
		$iTotal = __comb_factorial($iN)
		Redim $aRet[$iTotal][$iN]
	EndIf

	If $iK = 1 Then    ; write out current:
		For $i = 0 To $iN - 1
			$aRet[$iC][$i] = $aArray[$i]
		Next
		$iC += 1
	Else
		For $i = 0 To $iK - 1
			_comb_Permute($aArray, $iK - 1, False)

			If Mod($iK, 2) = 0 Then
				$vTmp = $aArray[$i]
				$aArray[$i] = $aArray[$iK - 1]
				$aArray[$iK - 1] = $vTmp
			Else
				$vTmp = $aArray[0]
				$aArray[0] = $aArray[$iK - 1]
				$aArray[$iK - 1] = $vTmp
			EndIf
		Next
	EndIf

	If $bFirst Then Return $aRet
EndFunc   ;==>_comb_Permute

; permute elements but for each element is defined on which positions it is allowed to appear
; $aArray = [$aPosElement1[...], $aPosElement2[...], ..., $aPosElementN[...]]
; return: Array[$N] with element indices
Func _comb_Permute_restricted(ByRef $aArray, Const $iC = 0)
	Local Static $iRet, $aRet[0][0], $aSample[0], $N

	If $iC = 0 Then ; initialisiere in äußerer Rekursion
		$iRet = 0
		$N = UBound($aArray)
		Redim $aSample[$N]
		Redim $aRet[(__comb_factorial($N) > 16777216 ? 16777216 : __comb_factorial($N))]
		For $i = 0 To UBound($aSample) - 1
			$aSample[$i] = -1
		Next
	EndIf

	For $iPos In $aArray[$iC]
		If $aSample[$iPos] <> -1 Then ContinueLoop
		$aSample[$iPos] = $iC

		If $iC = $N -1 Then ; last element reached
			$aRet[$iRet] = $aSample
			$iRet += 1

			$aSample[$iPos] = -1
			Return
		EndIf

		_comb_Permute_restricted($aArray, $iC + 1)
		$aSample[$iPos] = -1
	Next

	If $iC = 0 Then
		Redim $aRet[$iRet]
		Return SetExtended($iRet, $aRet)
	EndIf
EndFunc

; variations aka. k-permutations of n aka. partial permutations aka. sequences without repetition aka. arrangements
Func _comb_Variations(ByRef $aArray, Const $iK, Const $iIt = 0)
	Local Static $iN, $iTotal, $iInd, $aRet[0][0]
	Local $vTmp

	If $iIt = 0 Then
		$iN = UBound($aArray)
		$iTotal = __comb_factorial($iN) / __comb_factorial($iN - $iK)
		$iInd = 0
		Redim $aRet[$iTotal][$iK]
	EndIf

	; write out current:
	If $iIt = $iK Then
		For $i = 0 To $iK - 1
			$aRet[$iInd][$i] = $aArray[$i]
		Next
		$iInd += 1
	EndIf

	For $i = $iIt To $iN - 1
		; _ArraySwap($aArray, $iI, $i):
		$vTmp = $aArray[$i]
		$aArray[$i] = $aArray[$iIt]
		$aArray[$iIt] = $vTmp

		_comb_Variations($aArray, $iK, $iIt + 1)

		; _ArraySwap($aArray, $iI, $i) - ($vTmp reused):
		$aArray[$iIt] = $aArray[$i]
		$aArray[$i] = $vTmp
	Next

	If $iIt = 0 Then Return SetExtended($iInd - 1, $aRet)
EndFunc   ;==>_comb_Variations


; variations with repetition aka. permutations with repetition aka. n-tuples
Func _comb_Variations_Repetition(ByRef $aArray, Const $iK)
	If UBound($aArray, 0) <> 1 Then Return SetError(1, UBound($aArray, 0), Null)
	If $iK < 1 Then Return SetError(2, $iK, Null)

	Local $iN = UBound($aArray) - 1
	Local $iM = $iK - 1 ; max index
	Local $aInd[$iK] ; indices array
	Local $iT = $iM ; current index

	Local $iC = 0
	Local $iR = ($iN + 1) ^ $iK ; number of result groups

	Local $aRet[$iR][$iK]

	$aInd[$iT] = -1
	Do
		If $aInd[$iT] = $iN Then
			$iT -= 1
			If $iT = -1 Then ExitLoop
		Else
			$aInd[$iT] += 1
			While $iT < $iM
				$iT += 1
				$aInd[$iT] = 0
			WEnd

			For $i = 0 To $iM
				$aRet[$iC][$i] = $aArray[$aInd[$i]]
			Next
			$iC += 1

		EndIf
	Until False

	Return $aRet
EndFunc   ;==>_comb_Variations_Repetition

Func __comb_factorial(Const $x)
	If $x < 0 Or (Not IsInt($x)) Then Return SetError(1, $x, Null)
	Local $f = 1

	For $i = 1 To $x
		$f *= $i
	Next

	Return $f
EndFunc   ;==>__comb_factorial



; #FUNCTION# ======================================================================================
; Name ..........: _comb_ArrayInArrayTo2D()
; Description ...: Convert a Arrays in Array into a 2D array
; Syntax ........: _comb_ArrayInArrayTo2D(ByRef $A)
; Parameters ....: $A             - the arrays in array which should be converted
; Return values .: Success: a 2D Array build from the input array
;                  Failure: False
;                     @error = 1: $A is'nt an 1D array
;                            = 2: $A is empty
;                            = 3: first element isn't a array
; Author ........: AspirinJunkie
; =================================================================================================
Func _comb_ArrayInArrayTo2D(ByRef $A)
	If UBound($A, 0) <> 1 Then Return SetError(1, UBound($A, 0), False)
	Local $N = UBound($A)
	If $N < 1 Then Return SetError(2, $N, False)
	Local $u = UBound($A[0])
	If $u < 1 Then Return SetError(3, $u, False)

	Local $a_Ret[$N][$u]

	For $i = 0 To $N - 1
		Local $t = $A[$i]
		If UBound($t) > $u Then ReDim $a_Ret[$N][UBound($t)]
		For $j = 0 To UBound($t) - 1
			$a_Ret[$i][$j] = $t[$j]
		Next
	Next
	Return $a_Ret
EndFunc   ;==>_comb_ArrayInArrayTo2D