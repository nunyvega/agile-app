# How to generate questions file


We download the questions from a public database of trivia questions which has thousands of high quality trivia questions.
the process involves the following stages:

1- Download the data from the database API   
2- Transform the data in a format we use in our app and storing it as JSON  
3- Sanitize the JSON since as downloaded from the public database contains characters that our app doesn't support, thus they must be converted to equivalent supported characters

## 1 & 2: Data download and formatting
1- Create a python environment with python version 3.9 and install modules specified in requirements.txt  
2- Using the environment created in step 1 and with an iPython kernel associated to it run all cells in the jupyter notebook "generate_questions.ipynb"  
3- An output file should have been created called: "generated_questions.json"

## 3: Data sanitization
