/*
* Kai Franz
* September 13, 2018
*
* This module asks the user for a 4-letter word and prints out
* all the anagrams of that word.
*/

(clear)
(reset)

(deftemplate Letter (slot pos (type INTEGER)) (slot let))

/*
* Prompts the user for input and returns the first token entered.
*/
(deffunction ask (?prompt)
   (printout t ?prompt "? ")
   (bind ?response (read))
   (return ?response)
)

/*
* Validates a string to be of the given length.
* Precondition: str is a string and len is an integer
*/
(deffunction valLength (?str ?len)
   (return (= (str-length ?str) ?len))
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
* Asserts all of the letters in the given list using assertLetter.
*/
(deffunction assertLetters (?letters)
   (for (bind ?i 1) (<= ?i (length$ ?letters)) (++ ?i)
      (assertLetter ?i (nth$ ?i ?letters))
   )
)

/*
* Prints out all possible anagrams that use four letters.
*/
(defrule findAnagrams "prints anagrams"
   (Letter (pos ?p1) (let ?c1))
   (Letter (pos ?p2 &~?p1) (let ?c2))
   (Letter (pos ?p3 &~?p2 &~?p1) (let ?c3))
   (Letter (pos ?p4 &~?p3 &~?p2 &~?p1) (let ?c4))
   =>
   (printout t ?c1 ?c2 ?c3 ?c4 crlf)
)

/*
* Asks the user for a string, validates that the string is 4 characters,
* slices the string into a list, and runs the inference engine.
*
* Note: Does not use any of the arguments. This is for my reference so I can
*       remember how accept an arbitrary number of arguments.
*/
(deffunction main ($?args)
   (bind ?inputStr (ask "Enter a 4-letter word"))
   (while (= (valLength ?inputStr 4) FALSE)
      (bind ?inputStr (ask "Your input was not 4 characters. Enter a 4-letter word"))
   )

   (bind ?inputList (slice$ ?inputStr))
   (assertAll ?inputList)
   (return (run))
)

(return (main))
