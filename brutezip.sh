#!/bin/bash
# twitter: @linux_choice
default_wordlist="password.lst"
default_threads="10"
read -p "File to crack: " file
read -p "Wordlist (default: $default_wordlist): " wordlist
wordlist="${wordlist:-${default_wordlist}}"
read -p "Threads (default: 10): " threads
threads="${threads:-${default_threads}}"

if [[ $file == *.zip ]]; then
hash unzip 2>/dev/null || { echo >&2 "I require unzip but it's not installed. Aborting"; exit 1; }
cat $wordlist | xargs -I % -P $threads sh -c 'echo trying % ;unzip -o -P "%" '$file' > /dev/null 2>&1 && kill -1 $$  | echo "\e[1;92mPassword found: %\e[0m"'

elif [[ $file == *.rar ]]; then
hash unrar 2>/dev/null || { echo >&2 "I require unrar but it's not installed. Aborting"; exit 1; }
cat $wordlist | xargs -I % -P $threads sh -c 'echo trying % ;unrar -p"%" -or x '$file' > /dev/null 2>&1 && kill -1 $$  | echo "\e[1;92mPassword found: %\e[0m"'  

elif [[ $file == *.7z ]]; then
hash 7z 2>/dev/null || { echo >&2 "I require p7zip but it's not installed. Aborting"; exit 1; }
cat $wordlist | xargs -I % -P $threads sh -c 'echo trying % ;7z x -aou -p"%" '$file' > /dev/null 2>&1 && kill -1 $$  | echo "\e[1;92mPassword found: %\e[0m"'

else
echo "Invalid format, try: .zip, .rar or .7z"
exit 1;
fi

