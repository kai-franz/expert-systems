/*
* Kai Franz
* September 5, 2018
*
* This module asks the user for a number and calculates its factorial.
*/

/*
* Calculates the factorial of a number recursively.
*/
(deffunction factorial (?n)
   (if (<= ?n 1) then
      (return 1)
   else
      (return (* ?n (factorial (- ?n 1))))
   )
)

/*
* Prompts the user for input and returns the first token entered.
*/
(deffunction ask (?prompt)
   (printout t ?prompt "? ")
   (bind ?response (read))
   (return ?response)
)

(factorial (integer (ask "Enter a number")))