#include "ArrayCombinations.au3"

; the source elements:
    Global $aA[] = ["A", "B", "C", "D", "E", "F"]
; Size of the sample to be drawn:
    Global $k = 3

; Permutation (=variation of all elements):
    $aPermutations = _comb_Permute($aA)
    _ArrayDisplay($aPermutations, "all permutations", "", 64)

; Combinations of k elements without putting back
    $aCombs = _comb_Combinations($aA, $k)
    _ArrayDisplay($aCombs, $k & " combinations without putting back", "", 64)

; Combinations of k elements with putting back
    $aCombsRep = _comb_Combinations_Repetition($aA, $k)
    _ArrayDisplay($aCombsRep, $k & " combinations with putting back", "", 64)

; All combinations with sample size 1 to k
    $aCombsRepAll = _comb_Combinations_Repetition_All($aA, $k)
    $aCombsRepAll2D = _comb_ArrayInArrayTo2D($aCombsRepAll)
    _ArrayDisplay($aCombsRepAll2D, "All combinations till " & $k & " elements", "", 64 )

; Variations without putting back
    $aVariations = _comb_Variations($aA, $k)
    _ArrayDisplay($aVariations, $k & " variations without putting back", "", 64)

; Variations with putting back
    $aVariationsRep = _comb_Variations_Repetition($aA, $k)
    _ArrayDisplay($aVariationsRep, $k & " variations with putting back", "", 64)