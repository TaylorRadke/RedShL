# IDS Project

## Task Overview

1. ) Create a folder containing text files and sub folders we want to check.

2. ) Create a text file containing details of said files and sub folders. This is the verification file.

INCLUDE:
- Full location path
- File name
- File type
- Access mode (in txt format (e.g. -rwxr-r-)
- Owner and Group ID
- Time of last modification and file status change

3. ) Manually change things in the files (optional).

4. ) Perform a check, comparing the potentially changed files to the verification file.

## Command Line Options
| Options  | Description |
| ------------- | ------------- |
| -c name  | Create verification file titled 'name'  |
| -o name  | Display results of the comparison check  |
