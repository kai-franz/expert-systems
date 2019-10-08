/*
* Advises the user where to invest their money between cash, stocks, and bonds.
*
* Kai Franz
* Dec 1, 2018
*/
(clear)
(reset)
(deftemplate expense (slot name) (slot amount) (slot time))

(deftemplate investment (slot name) (slot return) (slot volatility) (slot minYears))

/*
* Global variables to keep track of the user's money and how much is being invested in each asset
*/
(defglobal ?*money* = 0)
(defglobal ?*stockInvestments* = 0)
(defglobal ?*bondInvestments* = 0)
(defglobal ?*cashInvestments* = 0)

(defglobal ?*PERCENT* = 100)
(defglobal ?*MONTHS_PER_YEAR* = 12)

/*
* Global variables to track statistics about stock, bond, and cash investment performance over the last 10 years
*/

(defglobal ?*STOCK_RETURN* = 12.97)   ; based on VFINX in the last 10 years
(defglobal ?*STOCK_VOLATILITY* = 13.61)
(defglobal ?*STOCK_TIME* = 12.97)

(defglobal ?*BOND_RETURN* = 3.7)      ; based on VBMFX in the last 10 years
(defglobal ?*BOND_VOLATILITY* = 2.9)
(defglobal ?*BOND_TIME* = 5)

(defglobal ?*CASH_RETURN* = 2)      ; based on an average money market account
(defglobal ?*CASH_VOLATILITY* = 0)
(defglobal ?*CASH_TIME* = 0)

(defglobal ?*STD_DEV* = 2)       ; Assume that any investment will not return less than 2 standard deviations
                           ; below the mean, which gives investments about 97% certainty of meeting
                           ; their goal, assuming that its returns follow a normal distribution.





/*
* Asks the user a yes or no question and returns either "y" or "n"
* Keeps prompting until the user answers with something that starts with either y or n, case insensitive
*/
(deffunction askYN (?prompt)

   (bind ?answer "")
   (bind ?shortAns "")

   (while (and (<> (str-compare ?answer "y") 0) (<> (str-compare ?answer "n") 0))
      (printout t ?prompt " (y/n)? ")
      (bind ?answer (lowcase (sub-string 1 1 (read))))
   )

   (if (= (str-compare ?answer "y") 0) then
      (bind ?shortAns y)
   else
      (bind ?shortAns n)
   )

   (return ?shortAns)
) ; (deffunction askYN (?prompt)


/*
* Asks the user a question and returns the answer
* Keeps prompting until the user answers with an integer.
*/
(deffunction askInt (?prompt)

   (bind ?answer "")

   (while (not (integerp ?answer))
      (printout t ?prompt "? ")
      (bind ?answer (read))
   )
   (return ?answer)
)


/*
* Prompts the user for input and returns the first token entered.
*/
(deffunction ask (?prompt)
   (printout t ?prompt "? ")
   (bind ?response (read))
   (return ?response)
)

/*
* Checks if the user can afford an expense given their current amount of money.
*/
(deffunction checkExpense (?cost ?time)
   (bind ?result FALSE)
   (if (<= ?cost (* ?*money* (- (** (+ 1 (/ ?*STOCK_RETURN* ?*PERCENT*)) (* ?time ?*MONTHS_PER_YEAR*)) (* (/ ?*STOCK_VOLATILITY* ?*PERCENT*) ?*STD_DEV*)))) then
      (bind ?result TRUE)
   )
   (if (<= ?cost (* ?*money* (- (** (+ 1 (/ ?*BOND_RETURN* ?*PERCENT*)) (* ?time ?*MONTHS_PER_YEAR*)) (* (/ ?*BOND_VOLATILITY* ?*PERCENT*) ?*STD_DEV*)))) then
      (bind ?result TRUE)
   )
   (if (<= ?cost (* ?*money* (** (+ 1 (/ ?*CASH_RETURN* ?*PERCENT*)) (* ?time ?*MONTHS_PER_YEAR*)))) then
      (bind ?result TRUE)
   )
   (return ?result)
)

/*
* Asserts facts representing the return, volatility, and minimum time horizon of the three investment mediums
*/
(defrule startup
   (declare (salience -100))
   =>
   (assert (investment (name stocks) (return ?*STOCK_RETURN*) (volatility ?*STOCK_VOLATILITY*) (minYears ?*STOCK_TIME*)))
   (assert (investment (name bonds) (return ?*BOND_RETURN*) (volatility ?*BOND_VOLATILITY*) (minYears ?*BOND_TIME*)))
   (assert (investment (name cash) (return ?*CASH_RETURN*) (volatility ?*CASH_VOLATILITY*) (minYears ?*CASH_TIME*)))
)


/*
* The following rules ask the user basic questions about their financial situation.
*/

(defrule askAvailableCash
   =>
   (assert (availableCash (askInt "How much money do you currently have available for investing, in dollars")))
)

(defrule askPortfolioRisk
   =>
   (assert (riskOkay (askYN "Are you okay with your investments temporarily losing a significant amount of value")))
)

(defrule askMaxRisk
   (riskOkay n)
   =>
   (assert (maxRisk (askInt "What is the maximum percent of your investments you're willing to lose temporarily")))
)

(defrule askLivingExpenses
   =>
   (assert (livingExpenses (askInt "What are your monthly living expenses in dollars")))
)


/*
* Sets the maximum risk to 100%, if the user has no personal preference
*/
(defrule setMaxRisk
   (riskOkay y)
   =>
   (assert (maxRisk ?*PERCENT*))
)

/*
* Invests 6 months of living expenses in cash.
*/
(defrule cashReserves
   (livingExpenses ?expenses)
   =>
   (assert (cashReserves (* ?expenses 6.0))) ; set aside 6 months of living expenses
)


/*
* Adds 6 months of cash expenses to the total cash investments, if enough money is available.
*/
(defrule investInitialCash
   (availableCash ?cash)
   (cashReserves ?reserves&:(<= ?reserves ?cash))
   =>
   (bind ?*money* (- ?*money* ?reserves))
   (bind ?*cashInvestments* (+ ?*cashInvestments* ?reserves))
)


/*
* Invests all money in cash if the user cannot afford 6 months of living expenses.
*/
(defrule investCashNoMoney
   (availableCash ?cash)
   (cashReserves ?reserves&:(> ?reserves ?cash))
   =>
   (bind ?*cashInvestments* (+ ?*cashInvestments* ?cash))
)

/*
* Starts asking the user about their future expenses.
*/
(defrule startAskingExpenses
   (maxRisk ?max)
   (availableCash ?cash)
   ?fact <- (cashReserves ?reserves)
   =>
   (bind ?*money* (- ?cash ?reserves))
   (printout t "Enter any large expenses you are saving up for in the future." crlf)
   (assert (getExpenseAfter first))
)

/*
* Asks the user if they want to add an expense.
*/
(defrule askForExpense
   (getExpenseAfter ?lastExpense)
   =>
   (assert (enterExpenseAfter ?lastExpense (askYN "Would you like to add an expense")))
)

/*
* Allows the user to enter an expense.
*/
(defrule enterExpense
   (enterExpenseAfter ?lastExpense y)
   =>
   (assert (expense (name (ask "What are you saving for")) (amount (askInt "How much will it cost")) (time (askInt "How many months from now is it"))))
)

/*
* Alerts the user if they cannot afford the expense they entered.
*/
(defrule cantAffordExpense
   ?fact <- (expense (name ?expenseName) (amount ?expenseCost) (time ?expenseTime&:(not (checkExpense ?expenseCost ?expenseTime))))
   =>
   (printout t "Sorry, you can't afford that." crlf)
   (retract ?fact)
   (assert (getExpenseAfter ?expenseName))
)


/*
* Adds the expense if the user can afford it.
*/
(defrule canAffordExpense
   ?fact <- (expense (name ?expenseName) (amount ?expenseCost) (time ?expenseTime&:(checkExpense ?expenseCost ?expenseTime)))
   =>
   (printout t "Expense added." crlf)
   (assert (invest y))
)

/*
* The following three rules look at a future expense and decide whether to invest in stocks, bonds, or cash
* to save up for the expense.
*/

(defrule investStocks
   (maxRisk ?risk)
   (expense (name ?expenseName) (amount ?expenseCost) (time ?expenseTime))
   (investment (name stocks) (return ?investmentReturn) (volatility ?investmentVolatility&:(< ?investmentVolatility ?risk))
      (minYears ?years&:(>= (/ ?expenseTime ?*MONTHS_PER_YEAR*) ?years)))
   ?fact <- (invest y)
   =>
   (bind ?amountInvested (/ ?expenseCost (- (** (+ 1 (/ ?investmentReturn ?*PERCENT*))
      (/ ?expenseTime ?*MONTHS_PER_YEAR*)) (* (/ ?investmentVolatility ?*PERCENT*) ?*STD_DEV*))))
   (bind ?*stockInvestments* (+ ?*stockInvestments* ?amountInvested))
   (bind ?*money* (- ?*money* ?amountInvested))
   (retract ?fact)
   (assert (getExpenseAfter ?expenseName))
)

(defrule investBonds
   (maxRisk ?risk)
   (expense (name ?expenseName) (amount ?expenseCost) (time ?expenseTime&))
   (investment (name bonds) (return ?investmentReturn) (volatility ?investmentVolatility&:(< ?investmentVolatility ?risk))
      (minYears ?years&:(>= (/ ?expenseTime ?*MONTHS_PER_YEAR*) ?years)))
   ?fact <- (invest y)
   =>
   (printout t ?risk crlf)
   (bind ?amountInvested (/ ?expenseCost (- (** (+ 1 (/ ?investmentReturn ?*PERCENT*))
      (/ ?expenseTime ?*MONTHS_PER_YEAR*)) (* (/ ?investmentVolatility ?*PERCENT*) ?*STD_DEV*))))
   (bind ?*bondInvestments* (+ ?*bondInvestments* ?amountInvested))
   (bind ?*money* (- ?*money* ?amountInvested))
   (retract ?fact)
   (assert (getExpenseAfter ?expenseName))
)

(defrule investCash
   (maxRisk ?risk)
   (expense (name ?expenseName) (amount ?expenseCost) (time ?expenseTime))
   (investment (name cash) (return ?investmentReturn) (volatility ?investmentVolatility)
      (minYears ?years&:(or (< (/ ?expenseTime ?*MONTHS_PER_YEAR*) ?*BOND_TIME*) (< ?risk ?*BOND_VOLATILITY*))))
   ?fact <- (invest y)
   =>
   (bind ?amountInvested (/ ?expenseCost (** (+ 1 (/ ?investmentReturn ?*PERCENT*)) (/ ?expenseTime ?*MONTHS_PER_YEAR*))))
   (bind ?*cashInvestments* (+ ?*cashInvestments* ?amountInvested))
   (bind ?*money* (- ?*money* ?amountInvested))
   (retract ?fact)
   (assert (getExpenseAfter ?expenseName))
)

/*
* Gives the results to the user.
* Reccomends to them how much to invest in each asset.
*/
(defrule giveResults
   (declare (salience -100))
   (availableCash ?cash)
   =>
   (bind ?*stockInvestments* (- ?cash (integer ?*bondInvestments*) (integer ?*cashInvestments*))) ; invest the remaining money in stocks
   (printout t crlf)
   (assert (done y))
)

(defrule giveCashResults
   (done y&:(not (= (integer ?*cashInvestments*) 0)))
   =>
   (printout t "You should keep $" (integer ?*cashInvestments*)
      " in a money market account. This will be a short term investment (0-5 years), with a risk-free annual return of about 2%." crlf crlf)
)
(defrule giveBondResults
   (done y&:(not (= (integer ?*bondInvestments*) 0)))
   =>
   (printout t "You should invest $" (integer ?*bondInvestments*)
      " in bonds, which will be a medium term investment (5-10 years), with an annual return of about 3.7% with a volatility of 2.9%." crlf crlf)
)

(defrule giveStockResults
   (done y&:(not (= (integer ?*stockInvestments*) 0)))
   =>
   (printout t "You should invest $" (integer ?*stockInvestments*)
      " in stocks, which will be a long term investment (10+ years), with an annual return of about 12.97% with a volatility of 13.61%." crlf crlf)
)

(run)
