#!/bin/bash
# Check whether a password is found in a list of known passwords found at https://haveibeenpwned.com/

# Copyright 2018 Lawrence Hamel
# Freely licensed Open Source via MIT License:
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

set +x  # turn off echoing each command, helpful to clarify the result as found or not
read -s -p "Password to search for in known-passwords list: " PASSWORD && echo ""
read -s -p "Re-enter the password, to confirm: " pass_confirm && echo ""

if [ "$PASSWORD" != "$pass_confirm" ]; then
   echo "Password confirmation didn't match; start again." && exit -1
fi

sha=$(echo -n "$PASSWORD" | shasum | tr [a-z] [A-Z] | awk '{ print $1 }')
result=$(curl -s https://api.pwnedpasswords.com/range/${sha:0:5} | grep ${sha:5})

if [ "$result" == "" ]; then
   echo "---Not Found in List of Known Passwords, happiness :)"
else
   echo '---That password IS known; time to change it!'
fi
