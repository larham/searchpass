# searchpass
## Determine if a password is found within the "haveibeenpwned" database, safely.

Do you need to change your password? Certainly you do if criminals already have this password among the lists used to "brute force" a login. These lists of passwords are captured from hacked servers, and shared widely.

How can you check whether a password is among these known passwords, without compromising the password?

[Kind individuals](https://haveibeenpwned.com/) have made a database of known passwords downloadable, with 500 million passwords as of March 2018. That database of passwords can be downloaded and checked locally. Better yet, the kind folks added a clever online search technique that involves hashing a password first, and sending up only the first 5 characters of the hash to check. The server sends back a list of all the hash-matches so you can easily see if there's an exact match, all by exposing a tiny, inconsequential amount of information.

Here's how to check a password online, safely, in about a minute:

Either download and run [searchpass.sh](./searchpass.sh) \[[md5](./searchpass.sh.md5)\]

OR

below is a line-by-line explanation of the same code that you can copy/paste into a terminal window, to know how it works and be sure that it is working in your favor only.

Prerequisite: If necessary, [install `curl`](http://macappstore.org/curl/) on macOS or use, on Linux, `apt-get` or `yum` to install `curl`.

For ease in auditing, the dozen lines of scripting below remain in Bash. There's only one call to the internet, and that the single call uses only the first 5 characters of `shasum` (SHA-1 hashing).

* First, bring up a new terminal window (on macOS, Applications -> Utilities -> Terminal). You will close this terminal as the last step below.

* Next, enter your password into the prompt "Password to Attempt to Find:". The following commands will show a password prompt and record your password without echoing on the screen:

```bash
read -s -p "Password to Attempt to Find: " PASSWORD && echo ""
```

* Let's confirm that the password was correctly typed:

```bash
read -s -p "Password Again (to confirm): " pass_confirm && echo ""
```

* Execute the following commands in the terminal. This can be copied entirely and pasted into the terminal window.

```bash
if [ "$PASSWORD" != "$pass_confirm" ]; then
   echo "Password confirmation didn't match; start again." && exit -1
fi

sha=$(echo -n "$PASSWORD" | shasum | tr [a-z] [A-Z] | awk '{ print $1 }')
result=$(curl -s https://api.pwnedpasswords.com/range/${sha:0:5} | grep ${sha:5})

if [ "$result" == "" ]; then
   echo "---Not Found in Online List of Known Passwords, happiness :)"
else
   echo '---That password IS known; time to change it!'
fi
```

* Read the output: it should be either "happiness", or "time to change".

* Close the terminal window to clear the local password variables that were created above.
