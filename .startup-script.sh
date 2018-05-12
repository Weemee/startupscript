#!/bin/bash

termProfiles=("htop" "client" "github" "server")
directory="/var/www/html/woa"
termEnv=("npm start" "htop")

resetVars() {
	defaultStart="false"
	intCheck="^[0-9]+$"
	screenID=0
	workspaceID=0
	amountOfScreens=0
	amountOfTerminals=0
	screenResolution=
	screenX=
	screenY=
	hexVar=
	winColsMax=
	winColsMin=
}

displayUsage() {
	echo "Usage: $0 [argument][options]"
	echo "Arguments:"
	echo "-h | --hilfe		for help."
	echo "-t | --terminals		requires [int] 1-9. Amount of terminals wanted."
	echo "-d | --default		run with default startup, takes no [options]"
	echo "-s | --screen		requires [int], choose screen. Top left screen [int]=1."
	echo "-w | --workspace		requires [int], 1-4. Choose workspace."
}

getScreens() {
	amountOfScreens=$( xrandr -q | grep ' connected' | wc -l )
	echo "Fetched: $amountOfScreens"
}

getResolution() {
	screenResolution=$( xdpyinfo | awk -F'[ x]+ ' '/dimensions:/{print $3, $4}' )

	local a=($(echo "$screenResolution" | tr 'x' ' '))
	screenX="${a[0]}"
	screenY="${a[1]}"
	echo "Screen x: $screenX y: $screenY"
}

setHex() {
	local aVar=$(wmctrl -lp | grep $(xprop -root | grep _NET_ACTIVE_WINDOW | head -1 | \
    awk '{print $5}' | sed 's/,//' | sed 's/^0x/0x0/'))
        local bVar=($(echo "$aVar" | tr '~' ' '))
        hexVar=${bVar[0]}
	echo "Hex: $hexVar"
}

getWinMax() {
	wmctrl -i -r $hexVar -b toggle,fullscreen
	sleep 1
	winColsMax=$(tput cols)
        winLinesMax=$(tput lines)
	echo "Max cols: $winColsMax lines: $winLinesMax"
}

setScreenDist() {
	tempW=$(( $screenX / $amountOfScreens ))
	terminalWidth=$(( $tempW / $amountOfTerminals ))
	terminalHeight=$(( $screenY / 1 ))
	terminalPosX=$(( 1 + 2 ))
	terminalPosY=$(( 3 * 3 ))

	echo "Test temp: $tempW"
	echo "Test width: $terminalWidth"
	echo "Test height: $terminalHeight"
	echo "Test pos X: $terminalPosX"
	echo "Test pos Y: $terminalPosY"
	echo 
	
	# gnome-terminal --window-with-profile="htop" --geometry=105x29+0+0 -e "htop"
	# gnome-terminal --window-with-profile="client" --working-directory="/var/www/html/woa/client" --geometry=105x29+960+0 -e "npm start"
}

penisFunction() {
        subl

        echo "Sleeping 0.5s, then workspace 2, monitor 1."
        sleep 0.5

        wmctrl -o 3840,0

        gnome-terminal --window-with-profile="htop" --geometry=105x29+0+0 -e "htop"
        sleep 0.2
        gnome-terminal --window-with-profile="client" --working-directory="/var/www/html/woa/client" --geometry=105x29+960+0 -e "npm start"
        sleep 0.2
        gnome-terminal --window-with-profile="github" --working-directory="/var/www/html/woa" --geometry=105x29+0+550
        sleep 0.2
        gnome-terminal --window-with-profile="server" --working-directory="/var/www/html/woa/server" --geometry=105x29+960+550 -e "npm start"
        sleep 7.4

        wmctrl -o 0,0
	sleep 0.8
	exit
}


produceTerminals() {

	counter=1

	echo "Getting screens..."
	getScreens
	sleep 0.5
	echo "Getting resolution..."
	getResolution
	sleep 0.5
	echo "Setting hex..."
	setHex
	sleep 1
	echo "Getting win max..."
	getWinMax
	sleep 1
	echo "Done fetching."
	echo

	echo "Calulating terminal distribution..."
	setScreenDist
	sleep 2

	echo "Creating screens in 2 seconds..."
	sleep 2
	
        while [ $counter -le $amountOfTerminals ]
        do
                echo "Terminal: $counter."
                sleep 0.1
                ((counter++))
        done
}

defaultStarted() {
        echo "Started default function."
	echo

	echo "Default values => "
	echo "Screen ID: $screenID."
	echo "Workspace ID: $workspaceID."
	echo "Screens: $amountOfScreens."
	echo "Resolution: $screenResolution."
	getScreens
	echo "Number of screens: $amountOfScreens."
	getResolution
	echo "Your combined resolution is: $screenResolution."
	echo "Screen ID: $screenID and local workspace ID: $workspaceID."
}

run() {
        echo "Running script..."

        if [ "$defaultStart" == "true" ] ; then
		# defaultStarted
		penisFunction
        else
        	if [ "$amountOfTerminals" -ge 1 ] ; then
	                produceTerminals
		else
			echo "Must be >= (more or equal) 1 terminals."
	        fi        
        fi
}

init() {
	echo "<Init> |script|"
	echo

	echo "Resetting vars..."
	sleep 0.5

	resetVars
	
	temp=`getopt -o dhs:t:w: --long default,hilfe,screen:,terminals:,workspace: -n 'startup-script.sh' -- "$@"`
	eval set -- "$temp"

	while true ; do
        case "$1" in
                -h|--hilfe)
                        displayUsage ;
                        exit 0 ;;

                -d|--default)
                        defaultStart="true" ;
			shift ;
			break ;;

                -s|--screen)
                        case "$2" in
                                "")
                                        displayUsage ;
                                        exit 1 ;;
                                *)
                                        if [[ $2 =~ $intCheck ]] ; then
                                                echo "$2 is an integer!"
                                                screenID=$2
                                                shift 2
                                        else
                                                echo "$2 is not an integer!"
                                                displayUsage
                                                exit 1
                                        fi
                                        ;;
                        esac ;;

                -w|--workspace)
                        case "$2" in
                                "")
                                        displayUsage ;
                                        exit 1 ;;
                                *)
                                        if [[ $2 =~ $intCheck ]] ; then
                                                echo "$2 is an integer!"
                                                workspaceID=$2
                                                shift 2
                                        else
                                                echo "$2 is not an integer!"
                                                displayUsage
                                                exit 1
                                        fi
                                        ;;
                        esac ;;

                -t|--terminals)
                        case "$2" in
                                "")
                                        displayUsage ;
                                        exit 1 ;;
                                *)
                                        if [[ $2 =~ $intCheck ]] ; then
                                                echo "$2 is an integer!"
                                                amountOfTerminals=$2
                                                shift 2
                                        else
						echo "$2 is not an integer!"
                                                displayUsage
                                                exit 1
                                        fi
                                        ;;
                        esac ;;

                --)
                        shift ;
                        break ;;

                *)
                        displayUsage ;
                        exit 1 ;;
		esac
	done

	run
}

init "$@"

arrayFunction() {
echo "Array size: ${#winArray[*]}"
echo

echo "Array items: "
for item in ${winArray[*]}
do
	printf " %s\n" $item
done

echo "Array indexes: "
for index in ${!winArray[*]}
do
	printf " %d\n" $index
done
}

openBrowser() {
        nohup chromium-browser github.com/Weemee/woa &

        sleep 2

        wmctrl -l
        wmctrl -r Chromium -T devChr
        sleep 0.2
        wmctrl -l
        wmctrl -r devChr -e 0,1920,0,1920,1080
        sleep 0.2
        wmctrl -l
        sleep 0.2
}
