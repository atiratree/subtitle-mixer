#!/bin/bash

run_test() {
    if ! eval $1 --fail-hard  &> /dev/null; then
        printf 'F\n'
        echo -e "CMD=\"$1\""
        eval $1 --fail-hard -d -v
        exit -1
    fi
    printf '.'
}

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

cd "$SCRIPTS_DIR/test_files"

A="$SCRIPTS_DIR/.."


run_test "$A/subtitle-mixer.rb -u -p "movie.en.srt",35 -p "movie.de.srt",65 -o "combined" -f srt"
run_test "$A/subtitle-mixer.rb -u -r "movie.en.ass",3 -r "movie.de.srt",4 -o "combined" -f ass -s 50"
run_test "$A/subtitle-mixer.rb -p "movie.en.ass",100 -w "movie.de.ass","my-dict.txt",60,true -o "combined" -s 50"
run_test "$A/subtitle-mixer.rb --max-drift 0.5 -r "movie.en.srt" -r "movie.de.srt" -o "combined" -f srt "


printf " SUCCESS\n"

#
#subtitle-mixer -u -r "movie.en.ass",3 -r "movie.de.srt",4 -o "combined" -f ass -s 50
#
#subtitle-mixer -p "movie.en.ass",100 -w "movie.de.ass","my-dict.txt",60,true -o "combined" -s 50 || echo ""