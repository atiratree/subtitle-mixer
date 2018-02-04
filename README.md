# Subtitle Mixer

## Installation:
Install [ruby](https://www.ruby-lang.org/en/documentation/installation/) and [rubygems](https://rubygems.org/pages/download)
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

```
usage: subtitle-mixer.rb [options]
    -p FILENAME,[PRIORITY],          Subtitles are picked based on weight = (1 / PRIORITY).
        --psubtitle                  	FILENAME file with subtitles in "srt" or "ass" format
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
