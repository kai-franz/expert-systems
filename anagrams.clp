/*
* Kai Franz
* September 13, 2018
*
* This module asks the user for a word and prints out
* all the anagrams of that word.
*/

(clear)
(reset)

(deftemplate Letter (slot pos (type INTEGER)) (slot let))

/*
* Prompts the user for input and returns the first token entered.
*/
(deffunction prompt (?text)
   (printout t ?text " ")
   (bind ?response (read))
   (return ?response)
)

/*
* Converts the given string to a list.
*/
(deffunction slice$ (?str)
   (bind ?asList (create$))
   (for (bind ?i 1) (<= ?i (str-length ?str)) (++ ?i)
      (bind ?asList (insert$ ?asList ?i (sub-string ?i ?i ?str)))
   )
   (return ?asList)
)

/*
* Asserts a letter with the given position and character value.
*/
(deffunction assertLetter (?pos ?char)
   (assert (Letter (pos ?pos) (let ?char)))
)

/*
* Asserts each letter in the given list, with assertLetter,
* using its position in the list.
*/
(deffunction assertLetters (?letters)
   (for (bind ?i 1) (<= ?i (length$ ?letters)) (++ ?i)
      (assertLetter ?i (nth$ ?i ?letters))
   )
)

/*
* Builds a rule that will find the anagrams of a given length.
*/
(deffunction buildAnagrams (?len)

   (bind ?line "
")

   (bind ?rule (str-cat "(defrule findAnagrams" ?line "   "))
   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (bind ?rule (str-cat ?rule "(Letter (pos ?p" ?i))
      (for (bind ?j (- ?i 1)) (>= ?j 1) (-- ?j)
         (bind ?rule (str-cat ?rule " &~?p" ?j))
      )
      (bind ?rule (str-cat ?rule ") (let ?c" ?i "))" ?line "   "))
   )

   (bind ?rule (str-cat ?rule "=>" ?line "   (printout t"))

   (for (bind ?i 1) (<= ?i ?len) (++ ?i)
      (bind ?rule (str-cat ?rule " ?c" ?i))
   )
   (bind ?rule (str-cat ?rule " crlf)" ?line ")"))

   (printout t ?rule crlf)
   (build ?rule)
)

/*
* Asks the user for a string, validates that the string is not longer than 11 characters,
* slices the string into a list, and runs the inference engine.
*
* Note: Does not use any of the arguments in $?args, I only put this here as an example
*       to remember how accept an arbitrary number of arguments.
*/
(deffunction main ($?args)
   (bind ?inputStr (prompt "Enter a word"))
   (bind ?inputList (slice$ ?inputStr))

   (assertLetters ?inputList)
   (buildAnagrams (length$ ?inputList))

   (return (run))
)

(return (main))
