# How to generate questions file


We download the questions from a public database of trivia questions which has thousands of high quality trivia questions.
the process involves the following stages:

1- Download the data from the database API   
2- Transform the data in a format we use in our app and storing it as JSON  
3- Validate the JSON since as downloaded from the public database contains characters that our app doesn't support, thus they must be converted to equivalent supported characters

## 1 & 2: Data download and formatting
1- Create a python environment with python version 3.9 and install modules specified in requirements.txt  
2- Using the environment created in step 1 and with an iPython kernel associated to it run all cells in the jupyter notebook "generate_questions.ipynb"  
3- An output file should have been created called: "generated_questions.json"

## 3: Data validation
To reestablish the data overall health, it's required to replace the different HTML entities ( read https://developer.mozilla.org/en-US/docs/Glossary/Entity ) for their corresponding character entities or words referring to the intended value. 

The challenge faced here is that the questions from the database API were originally intended to be read by the users, but BTrivia needs to read the question. Since the signification of a symbol can depend on the context, it is necessary to check the context of the entities to define how to revert it to a symbol.

The basic steps to do this are:
1- Look for the HTML entities in the file. It can be matched using Regular Expressions ( `&.*;` )
2- Based on the context, either replace it for the character entity, or for a word. 
