- Windows-style new-line characters conflict with Unix environments. Run the following command to make "run.sh" properly executable in bash: sed -i 's/\r$//' run.sh

- To run the script, use "sh run.sh".