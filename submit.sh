# shell code to automate the submission process
#!/bin/bash  

# pull from remote
git pull origin main

# Read the commit message
echo "Enter the commit message below:"
read msg

git add .
git commit -m "$msg"
git push origin main