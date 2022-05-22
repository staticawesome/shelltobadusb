# shelltobadusb

Crappy script that makes reverse shell payloads for Rubber Ducky/Flipper Zero.

For education and only with permission, etc. I'm not responsible for what you do.

uses data from https://github.com/0dayCTF/reverse-shell-generator/

Requires jq , sudo apt install jq , most distros have it in repo

This script sucks. It has zero input validation, zero sanity checking, and is missing features. Steal if you wish to improve :)

Put .sh and .json in the same directory, and run. It'll output a document called "revshell.txt" for the payload. 

It's set to open "mouspad" on linux, and "notepad" on windows. You'll need to edit the script to weaponize it. :)
