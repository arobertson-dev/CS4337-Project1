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


09/30/2025 (Tuesday)

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






