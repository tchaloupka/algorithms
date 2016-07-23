# Randomized selection algorithm described in [this](https://www.coursera.org/learn/algorithm-design-analysis/home) course (week 3).

## Problem description
This is a problem of computing order statistics of an array.
With computing the median of an array being a special case.
The problem is to select n-th smallest value from given unordered list.

Simple solution would be to sort the list and then return value at the requested index - `O(n.log n)`

Described randomized algorithm is on average for all cases just `O(n)` - using modified quicksort algorithm.

## Test cases
For testing it is possible to use data from quicksort algorithm (unordered lists of numbers in range 1..n).
The implementation expects requested index to be counted from 1, so for the smallest number in the list it is required to provde 1 as an input.
With this requirement and test files from quicksort test cases, this algorithm should allways return the number which is equal to the requested index.
