#!/bin/bash
figlet -f mini welcome $USER
red='\033[0;31m'
cyan='\033[0;36m'
lightCyan='\033[1;36m'
blue='\033[0;34m'
yellow="\033[0;33m"
NC='\033[0m' # No Color
printf "Welcome ${cyan}$USER${yellow}\n"
currentDate=`date +"%A, %m %d %Y %I:%M:%S %p"`
echo $currentDate
printf "${blue}-------------------------------\n${lightCyan}"
hostname -I
printf "\n${NC}"
curl wttr.in?format=3
printf "\n"