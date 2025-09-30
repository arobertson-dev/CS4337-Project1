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

