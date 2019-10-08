/*
* Kai Franz
* September 5, 2018
*
* This module asks the user for a non-negative integer n, calculates the first n fibonacci numbers, and prints them out.
*/

/*
* Calculates and returns a list of the first n Fibonacci numbers.
*
* Precondition: n is a non-negative integer
*/
(deffunction fibonacci (?n)

   (bind ?nums (create$))                                                        ; start with an empty list and
   (bind ?prevOne 1)                                                             ; define the -1st and 0th Fibonacci numbers
   (bind ?prevTwo 0)                                                             ; to be 0 and 1

   (for (bind ?i 1) (<= ?i (+ 0 ?n)) (++ ?i)                                     ; add to the list starting at the first empty index
      (if (> ?i 2) then
         (bind ?prevOne (nth$ (- ?i 1) ?nums))                                   ; get the Fibonacci #n-1
         (bind ?prevTwo (nth$ (- ?i 2) ?nums))                                   ; and #n-2
      )

      (bind ?nums (insert$ ?nums (+ (length$ ?nums) 1) (+ ?prevOne ?prevTwo)))   ; add the previous two Fibonacci numbers to get
   )                                                                             ; Fibonacci #n and append it to the list
   (return ?nums)
) ; deffunction fibonacci (?n)

/*
* Prompts the user for input and returns the first token entered.
*/
    (deffunction ask (?prompt)
       (printout t ?prompt "? ")
       (bind ?response (read))
       (return ?response)
    )

/*
* Checks to see if the user input expression is valid.
* Returns TRUE if the input is a non-negative integer; otherwise, FALSE.
*/
(deffunction validate (?expr)
   (return (and (integerp ?expr) (>= ?input 0)))
)

(bind ?input (ask "How many Fibonacci numbers would you like to see"))           ; prompt the user how many numbers to calculate
(bind ?validInput (validate ?input))                                             ; check if the user input is valid

(while (= (validate ?input) FALSE)
   (printout t "Please enter a non-negative integer." crlf)                      ; if the input is invalid, remind the user
   (bind ?input (ask "How many Fibonacci numbers would you like to see"))        ; and re-prompt until valid input is entered
)
                                                                                 ; finally, calculate and print out the list
(printout t (fibonacci ?input) crlf)                                             ; of Fibonacci numbers
