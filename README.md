# Subtitle Mixer

## Installation:
Install [ruby](https://www.ruby-lang.org/en/documentation/installation/), [rubygems](https://rubygems.org/pages/download) and libicu-dev
``` shell
gem install bundler
cd "$INSTALL_DIR"
git clone https://github.com/suomiy/subtitle-mixer.git 
cd "subtitle-mixer"
bundle install
# OPTIONAL: make alias for easier usage
echo "alias subtitle-mixer=""`pwd`""/subtitle-mixer.rb" >> ~/.bashrc
# mix subs!
./subtitle-mixer -p "movie.en.srt" -p "movie.de.ass" -o "combined"
```

## Usage:
#### Example with 2 subtitles
 1. Just use `srt` output format  when both are `srt` + persist formatting. Percentages should be: 35 + 65 = 100
```bash
subtitle-mixer -u -p "movie.en.srt",35 -p "movie.de.srt",65 -o "combined" -f srt
```


2. Only `ass` formatting gets persisted this way. Set font size to have the same sizes for both subs. You can turn off persisted formatting if the styles are too different.
```bash
subtitle-mixer -u -r "movie.en.ass",3 -r "movie.de.srt",4 -o "combined" -f ass -s 50
```
3. Example with dictionary. `movie.en` must have percentage = 100 or priority = 1 to work properly. `movie.de` is always selected when 60% of words are recognized. It is weighed against percentage 100% of `movie.en`, once bellow 60%. 

```bash
subtitle-mixer -p "movie.en.ass",100 -w "movie.de.ass","my-dict.txt",60,true -o "combined" -s 50
```

4. Try to increase drift if you encounter badly timed subs. Use with caution: this can lead to higher number of overlap mistakes. There is a small chance of mistakes even with a default value of drift 0.2. Set to 0 to if you have subs with exactly the same timing.

```bash
subtitle-mixer --max-drift 0.5 -r "movie.en.srt" -r "movie.bad.timing.de.srt" -o "combined" -f srt 
```
### Help
```
Usage: subtitle-mixer.rb [options]
    -p FILENAME,[PERCENTAGE],        Subtitles are picked based on weight = (PERCENTAGE / 100).
        --psubtitle                  There is no check that percentages add to 100. 
                                     So subs can have together 150%. You can use priority in --rsubtitle instead
                                     	FILENAME file with subtitles in "srt" or "ass" format
                                     	PERCENTAGE only accurate when all the subtitles add to 100
                                     	DEFAULT VALUES: PERCENTAGE=100
                                     	* this option can be specified multiple times
                                     
    -r FILENAME,[PRIORITY],          Subtitles are picked based on weight = (1 / PRIORITY).
        --rsubtitle                  	FILENAME file with subtitles in "srt" or "ass" format
                                     	PRIORITY higher PRIORITY number has less chance to be picked;
                                     		 chance difference to be picked between priorities 1:2 is much larger than between 999:1000
                                     	DEFAULT VALUES: PRIORITY=1
                                     	* this option can be specified multiple times
                                     
    -w FILENAME,WORDLIST_FILENAME,[PERCENTAGE_THRESHOLD],[DROP_BELLOW_THRESHOLD],
        --wsubtitle                  Subtitles are picked based upon known words in each sentence from WORDLIST_FILENAME
                                     	FILENAME file with subtitles in "srt" or "ass" format
                                     	WORDLIST_FILENAME file which contains known words
                                     	PERCENTAGE_THRESHOLD how many percent of each sentence should be covered by known words
                                     		for the sentence to be picked
                                     	DROP_BELLOW_THRESHOLD true,false; if true, than each sentence will be weighed by the percentage of
                                     		recognized words until reaching PERCENTAGE_THRESHOLD
                                     	DEFAULT VALUES: PERCENTAGE_THRESHOLD=100, DROP_BELLOW_THRESHOLD=FALSE
                                     	* this option can be specified only once
                                     
    -o, --output FILENAME
    -f, --format FORMAT              Format of output FILENAME. Supported formats: srt, ass
                                     	DEFAULT VALUES: FORMAT=ass
    -u, --persist-formatting         Tries to persist styles for srt/ssa. Can have variable outcomes. 
                                     	Set output format the same as input format for best result
    -s, --font-size FONT_SIZE        Overrides FONT_SIZE for ass format
    -m, --max-drift DRIFT            Maximum time drift (in sec) between input subtitles. 
                                     	The subtitles will be considered to occur at the same time and picked by their weights.
                                     	0 drift means subtitles must start at the exact same time to be considered for picking
                                     	DEFAULT VALUES: DRIFT=0.2
    -d, --debug
    -v, --verbose
    -h, --help                       Prints this help
```
