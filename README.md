In the AutoIt-included Array.au3 there are 2 combinatorics functions - _ArrayCombinations() and _ArrayPermute().
Why only these two were picked out is not completely clear to me and seems somewhat arbitrary.
And the fact that their results are only returned as a string doesn't really make this more understandable.

So it was time for a comprehensive combinatorics UDF.

the function list:
| function | description |
| --- | --- |
| _comb_Combinations                | determines k combinations out of n elements without returning |
| _comb_Combinations_Repetition     | determines k combinations of n elements with repetition |
| _comb_Combinations_Repetition_All | get 1..k combinations of n elements with reset |
| _comb_Permute                     | retrieve all permutations from n elements without return |
| _comb_Variations                  | retrieve k variations from n elements without repetition |
| _comb_Variations_Repetition       | get k variations from n elements with repetition |
| _comb_ArrayInArrayTo2D            | helper function to convert array-in-array constructs to a 2D array |
| _comb_Permute_restricted          | Special case of permutation where for each element is specified where it may stand |
| __comb_binomialcoefficient        | calculates the binomial coefficient "n over k |
| __comb_factorial                  | calculates the factorial "x!" |

The best way to see it, of course, is with a concrete example:

<details>
<summary>example for ArrayCombinations</summary>

```AutoIt
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
```

</details>
