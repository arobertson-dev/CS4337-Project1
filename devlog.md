# Dev log for CS4337 Project1

## 09/28/2025 (Sunday)

This is my inital creation of the Dev Log that will be used and updated through the creation and building of Project1 Assignment for CS4337 Programming Language Paradigms course. Everytime I work on this project, I will write inside this devlog.md file when my coding sessions begins and i will recap what was worked on and coded when i am done coding for the current session, for now this comment is just the inital creation of this devlog file for the project1 assignment. 

## 09/29/2025 (Monday)

Goal:
In this session, plan on trying to create the different mode detection rather thats interactive or bash mode and after that will create the function that reads in user input and make sure its 
a validated token, and produce an error message if it is not a valid token. 

Worked on:
Created interactive function that acts as a flag, based on current-command-line args, too check if the arg will be -b or --batch for batch mode, if not, it will run in default mode (interactive)

Tokenize function that produces value tokens for the assignment '+', '-', '*', '-', '-5', '1' '$5'
Also has error output for if the token is not a digit(number), otherwords unknown chars for the calculator.


## 09/30/2025 (Tuesday)

Correction: I commented out my previous two functions that were implemeneted as i am stuck and not sure where exactly to go next, orginally i was thinking i would tokenize the input then evaluate the function and print the results, but i realised i never actually took care of running the program in the correct mode, even though a function mode detection can detect what mode to run in.

Goal: Because it is a prefix calculator, Recursion will help with the design scheme of this project by evaluating expressions step by step. Each operator will consume one or more sub expressions, and those sub expressions can be themselves be full expressions. The idea is to tokenize the input ( which i did orginally ) and pass along the other tokens ( i didnt do this because i didnt have recursion in my mind until reading more on prefix notation calculator ) Since i have to deal with nested expressions, the recursion allows to give an efficent way to evaluate the expressions without managing different list or stacks, as im not too experienced with Racket.

Design Process:

My first function created had the right idea, i knew checking the mode that the program would be ran in would be the first thing to do, as thats the first thing that happens when the program is executed. Next will be having to deal with the user input, via tokenizer function which i also think i had the right idea on, where the input is validated before passing to the logic of the calculator. NExt use recursion to evaluate the expressions ( learned when reading up on prefix calculator), The evaluator will consume tokens recursively, next after the expression is evaluated, if successfully gives a valid result, deal with the history ($n), (orginally i thought i would try to deal with this history before even evaluating the expression or i would have a function tied to each operator, but i realise this is a lot more work then is probably needed to exectute the calclator, so after evaluating expressions, deal with the historyId of the assignment instructions, then lastly is the output of the calculator, following the instructions and standared requirements of how the output should be printed (correct formatting). 

Function design process: 


Function: (Detection mode)
User will execute the program ( detect function where it figures out if the program should be ran in interactive mode or batch mode. 
Interactive mode will be default mode if not ran with -b or --batch, which tells the program that it needs to be ran in batch mode. 
So checks command line args, if -b or --batch is present in input when executing program, return #f, otherwise return #t, regardless program will just be taking input after this function, so functionality of program is the same, this just detects the mode that it should be ran in. 

Interactive (prompt everytime)
Bash (no prompt, just expression and Result)


Function: Tokenizer 
Mistake: Orginally i was thinking i would just read user input and then verify after the input is read if it is valid or not, but i realise that i need to already verify what tokens are accepted or not, and produce error messages for tokens that are not accepted by the program instructions

-- This function will convert strings of input into tokens that are valid or not valid via the program instructions,
must handle whitespace in the input, will split each token by the whitespace, and handle the valid tokens being the 
binary operators ( +, *, /)
unary negation (-)
digits (123, -123)
History $n ($1, $2) which is a history of each result from the evaluated expression
Return error if the token read is outside the range of these accepeted tokens

Use some helper functions to make the process easier,
skip whitespace
Read digits consecutively
extra tokens in the input one after the other

Important: Prefix evaluation works token by token, without this function, it will be hard to evaluate the expressions and print out the correct result

Function: Evaluate a single Token (different from tokenizer)
--This function will convert single tokens into a numeric value, need a function to turn tokens into numbers, which include the $n history id's. 

If the token is a history reference ($n), search for the value in the history list
If the token is a number string (12532), convert to a number
If the token is invalid, like tokenizer function return an error ( outside scope of the program instructions for the calculator) 

Function: expression evaluater ( core logic of the calculator where it can handle nested expressions with recursion) and evalute the expressions, after turning input into tokens with the 2 previous functions.

- Take the first token
- Determine which kind of token it is (valid only)
- Use recurison to evaluate sub expressions for operands
- if a sub expressions return an error, propogate it upward.
- Check for leftover tokens after evaluation, if so it is invalid.


Function: Evaluation function that deals with history list

Since we're advised to create muitple functions to do the problem instead of trying to put this function inside the expression evaluator, will make another function that will tokenize the input, return error if tokenize fails and not update history list.
If the tokenize is successful, evalute the expression and return the result and also update the history list with the new result for that ($n)id.

This is the function that handles the history list or ($n) functionality that the program must be able to do, and this allows to soely focus on the history list and not accidently add an error to the history list just because its counted as a result. 

Function: Print function of the result

Here this function will print back on the screen the evaluation result that is typed in by the user, using the format of the assignment instructions

- If result is a string --> return an error back to the user
- If result is numeric --> print out the <historyID> (of that current result): result in float format using the function given by the assignment real->double->flonum

  This also will not entangle I/O with the logic functions, which breaks down the problem into more functions instead of trying to do muitple functions inside one function.


Function: interactive mode 

This function will be the basis that the program will run on after it detects what mode it should be ran in, by the name of the function this is for the interactive mode (default)

Using a REPL (read evaluate print loop)
1. Prompt user for input
2. Read input line
3. if input = quit, terminate the program
4. otherwise, evaluation function
5. print function, recursively call loop and history is updated.

Function: Batch mode

This will be the same as the interactive mode, only difference is now its for batch mode

- No prompts are printed, (Enter Expression to be evaluated:) doesnt print
- Only results and Error messages are printed after an input line is tokenized and evaluated


Function: Main (here is where we will call the correct mode to use using the mode detection via the command line args)

Launch the program using the correct mode (interactive/batch)
Will call the corresponding loop from one the two previous functions right above,

Important: Regardless of what mode the program is in, the core functionality and logic will execute the exact same, so results and history list in each mode should be the same and expression evaluation will be mode-agnostic. 


Summary of the program design scheme:

1. User runs program, detection mode function detects what mode the program should be ran in.
2. Input is read (interactive or batch)
3. Input string is tokenized into valid tokens.
4. Tokens are evaluated recurively
   - Numbers and $n references are handled
   - Unary (negation -) will negate one number
   - binary operators (+, *, /) will combine two sub results
5. Errors recursively return up the recursion tree
6. Result is added to history if evaluation is successful
7. Result or error is printed with print function
8. Loop will continue until the word 'quit' is read from the input


## 10/01/2025 (Wednesday)

Yesterday I focused on trying to get a design scheme of the project instead of orginally just jumping into writing racket syntax for functions that i had in mine. I went into a clear overview of each function and its purpose towards the project, along with a quick summary of how the project works from the moment the user runs the program to when the user types quit to terminate the program.

Today I will start at the top of my list and try to implement functions through the next couple of days to complete the project, Orginally i did have a mode detection function that i used to detect what mode the function is going to be ran in, and i also started on a function that would tokenize to the list of inputs typed in from the user, as this was important to actually being able to use future functions to use the logic to produce results. 

So in this session i will be going over my 2 functions and its purpose, details and why it matters to the program, almost like a repeat of the design scheme in a way from yesterday.

-- Working on Detection mode function

Problems encountered: Although i had the right idea in mind about first having to detect what mode the project would be ran in, what i didnt full understand was how the project would be ran via batch mode. I wasn't thinking about running this program via a terminal because im doing all the racket coding in the DrRacket(IDE) and i'm able to just press the green button to run the program, but i didn't actually handle a way to be able to run the program in batch mode, as that is only done via running the program via terminal, for Ex.
./Project1.rkt -b
./Project1.rkt --batch

I wasn't thinking about this orginally, for some reason i just assumed i would be able to run the program via the terminal in DrRacket in batch mode, much like when you call a specific function in a program (via class lecture ) the instructor would type out the function name in parenthesis followed by a list(arguments)

Fix: To solve this i needed to add a args-list for the command-line to read input via the command line(terminal) where the function would be able to take this input and validate if it was to be ran in standard mode or batch mode. 
The rest of my function for the most part was correct in the logic, so really in this session the args-list is the new implementation onto my previous detection mode function.

Breakdown:

So the (define args-list) and (define interactive?) both are used as my detection mode functions for this program, 
All args-list does is convert the arguments to a list to be read for racket, and if theres no arguments meaning (standard mode) then just default to use a empty list.
The interactive? function is what i orignally tried creating on Monday, and most of the logic has stayed the same, it will scan the input, if no arguments (empty list) then that means interactive mode which is set as #t, if there is a argument in this case -b or --batch, then this is telling us to be ran in batch mode and we define that as the opposite #f. 

This detection mode is very important to the assignments instructions, personally if i was just creating a prefix calc on my own time i wouldnt even think to add a batch mode functionality, but the instructions for this project require both interactive and batch modes, This functional logic allows the program to work the same rather its ran via DrRacket (interactive) or when ran via the terminal for batch mode. 


-- Working on the tokenize function

Problems encountered: This function also for the most part had the correct design idea, it would convert raw input strings from the user into validated tokens for the calculator, in this case (numbers, operators and $n history references). Something i wasn't thinking about was handling whitespace, so i needed to fix that to correctly read input. I had the correct solution of validating the acceptable tokens for the calcualator ( all the ones listed in the assigment instructions). Something i kinda glossed over was the unary negation token, i didnt check to see if the (-) sign would be followed by digits, meaning it would refer to a negative number, so that had to be fixed. The hardest part of this function for me was trying to understand how i would handle the $n id's for history reference, i spent most of the time today on this function dealing exactly with this.

Fix: To solve the $n history reference problem, the tokenize function logic scans the input, if it sees a $, then it automatically knows its dealing with a history reference. The logic takes the number right after the $ token, its read as a string and convereted to a integer, for ex $34 woudld take "34"(string) and turn it into 34(integer). This was pretty straight forward, orginally though i didnt add logic to a problem, what if the histroy index is larger then the number of evaluated expressions that the user has typed in. i needed a way to produce an error message to let the user know there is no history reference for that $n ID. After validating the index, the logic grabs the nth command from the history list (if real), then recursively call the tokenize function again to replace the $n typed by the user with the value stored from grabbing it just right before.
Ex. supposed the 2nd evaluated expression history was (+ 7 3) reffering to $2, then the user inputs something like * 2 $2, the recursive call of the tokenize function allows to replace the $2 with "+". "7". "3", so then the whole list that the tokenize string reads from * $2 is ('*", "2", "+", "7", "3"). 

Breakdown of function:

Overall the tokenize function has helper functions to strip whitespace from the input, combine a sequence of digits into a string of numbers instead, then the function handles negative numbers with unary negation, by checking if the (-) is followed by digitis. Supports the $n history references described above and also produces an error message if the token is not recognized, (outside the scope of the allowed tokens for this project). 

The calculator can't process text directly, instead it has to process a list of tokens, this tokenizer function will act as a translator for the later core logic functions that will actually do the calculator expression evaluating. without this tokenizer function, the calculator woulnd't even be able to read what the user was typing in and correctly process it, so its right up there in importance alongside the calcualator core logic.

Important note:

This tokenizer function doesn't evalute single tokens into numeric values, all it does is create tokens, i will be creating a function that uses the list of helpful functions given by the project1 instructions to convert the tokens into numbers or looking up the actual history references of $n, so although i gave an example of the logic above for how the history reference works, so a function will be needed to bridge the tokenizer tokens to real values in this case for the calculator to correctly evaluate the expressions. 


## 10/03/2025 (Friday)

Recap:

So far, the implemented functions is the detection-mode ( decides between interactive vs batch) and tokenize (splits input into usable tokens) , Next we'll work on a functions that uses the tokens produced by the tokenize function to do the actual calculations or the logic of the prefix calculator for this assignment which means the operator comes before the operands, which is not really the standard way of reading math expression when learning them through grade school, but i understand why it works this way for a functional programming language. 

Next will need to implement the actual function that take the tokens and perform the evaluation and math of the prefix calculator, so this is the basis and core logic of the program and what really makes it work as a calculator.   

The idea is to have three different functions that work as a pipeline for the core logic using recursion, to evalute the prefix notation and structure of these expressions.

1st:  eval-token (does the math)

Purpose: 

This function will take the list of tokens produced by the tokenize function, recurisvely evaluate them according to the prefix notation rules and turn the symboles and numbers into actual computed results for the expressions to evaluate. 

How it works:

Read first token:
-- if its a number --> return the number (base case)
-- if its an operator --> recursively call eval-token again to fetch enough operands to apply the operator too, 

The purpose of recursion in this function is to handle the subexpressions in nested structure,

Ex. ("+", "5", "*", "2", "3")
So eval token will read "+" then call eval-token again (recursion) to find operaands to use on the operator, it sees 5 (base case) returns 5, then it sees another operator (*), so then it will search again for base cases to apply to this operator. so for now when just reading ("+), "5", "*"), --> (5 + (*)) then when it calls eval token again it reads the next two numbers (base cases) and evaluates (2 * 3) = 6, then returns it to the previous expression getting (5 + (2*3)=6) --> (5 + 6), so this is how the recursion is needed and used in this function to evaluate the nested structure of expressions. 


This function is part of the math logic that allows for the project to take the tokens and produce results ( read them as expressions) 

2nd: eval-expr (ensures full correctness of input)

Purpose:

This function will wrap around eval-token to make sure the entire input expression is consumed correctly, it will ensure that the program doesnt just evaluate a piece of the tokens and leave leftovers or leave tokens stranded, which ties back to the assignment instructions. 

how it works:
This function will again call eval-token with the token list produced by the (tokenize function), after getting a result by the eval-token function it will check if all the tokens in the list were consumed, if not it will throw an error, if everything matches up though and no tokens are left over it will just return the computed result, so this is just a function that helps the program make sure no tokens are left behind. 

Why it matters:
This function acts as quality control, it helps eval token by checking and making sure it didnt stop early or ignore/leave leftover tokens. Gurantees that what the user input as an expression is indeed one valid expression, 

This again breaks the problems down into smaller problems and uses more than one function to solve the problems at hand, intead of trying to fit all of this logic into the eval-token. 


3rd: safe-eval (makes it safe to run the program) 

Purpose: 
This is the top level safety wrapper, this will call the eval-expr function which then in return will call the eval-token function, so as said before these three functions work as a pipeline, to form the core logic of the program ( the calculator part) 

If the evaluation fails, this function will return an error message.

How it works:

Input( tokens from the tokenize function)
tries to call eval-expr, if it succeeds then the pipline continues down to eval token and recursively calls back up to return a result of the expression
If it fails though,
errors like unvalidated token, not enough operands for the operator, or dividing by zero. it will return an error saying "Error: Invalid expression" 

Importance:
This is another safety net that will allow the program to keep running even if input from the user is invalid, instead of crashing the program the function will act as a safety wrapper for the program. with this safety wrapper the calculator will just throw an error and continue to run instead. 


Ex. 

Input: (" + 5 * 2 3 ") --> (tokenize) ("+", "5", "*", "2", "3")
safe-eval -->  (starts the evaluation safely) calls eval-expr
eval-expr --> validates the full expression use, calls eval token to actually do the computation
eval token --> uses recursion, walks through the tokens, applies the operators, handles the numbers (base case) and checks for errors, the produces a result and returns that result, it goes back up through the tree and safe-eval either returns a number (valid) or an error (invalid) 

Instead of crammining everything into one giant function, ( use project tips of splitting problems into more functions), this design splits the responsibilities across three smaller ones, this makes the code cleaner, easier to test and easier to maintain

-- eval-token: compute numbers/operators
-- eval-expr: checks for leftovers
-- safe-eval: catch errors, keep program safe and continue to run even when invalid input. 



## 10/04/2025 (Saturday)


Recap: So what has been implemented so far is a detection-mode function, a tokenize function ( that turns input into tokens) then most recently the core basis of the calculator that handles the expressions and does most of the work that the prefix calculator is actually supposed to do, the eval-token, eval-expr and safe-eval function that all work together to compute the expressions and evalute them to return a result without crashing the program when the input is incorrect or invalid. 


What needs to be done:

So now the program needs a way of printing out the result that is returned from the evalutation of the expressions, and it needs to be handled via the assignments format and instructions of how to print out the results.

Solution:
print-result function, this function will take the result and print it out in the correct format. 

How it works:

If an error occured it will just print the error message "Error: Invalid expression", Otherwise it will print the result along with the history ID number, showing which expression or input this was typed from the user. 

1st: Check if the result is a string, because in the program the errors are represented as strings, so if the result is a string then it prints the error message. 

2nd: Otherwise, its going to be a valid result, so it needs to print out the numeric output with the correct HistoryID, so it checks how many expressions have been successfully evaluated so far, because if it was a unsuccessful evaluated then the history log wont be updated, this was taken care of in a previous function. 
It will print the histroy ID followed by the ":" to seperate the HistoryID from the result. Using the real->double_flonum result given by the instructions, it ensures the number is printed as a floating point number for the correct format according to the assignments instructions. 

3rd: Lastly pass new-history log, this is because each time an expressions is evaluated correctly, the updated history list grows, (1 at a time), Using the length of the histroy log, ensures the printed ID always matches the current history index. 

Importance of the print function:

Without this function, there wouldnt be a standarized format for printing, to stay consistent throughout the program, Also the user wouldn't be seeing the historyID with each new result printed, which is a requirement in the assignment instructions, and without this function, there would be a need for printing of results in many places throughout the code, which just requires more coding then needed. 












































