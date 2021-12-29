
####
##
## ZSHRC
##
## @author  : Rob Frawley 2nd <rmf@src.run>
## @license : MIT License <rmf.mit-license.org>
##
## There are a number of environment variables that can be used to change the behavior of this custom configurtion
## script, such as the following enumeration of variables:
##   - OUTPUT_VERBOSE (type=bool,def=true) : cfg script for debug out when "true"; none when "false" (excluding errors)
##   - COLORS_LISTING (type=bool,def=true) : cfg "ls" exec to output using color and set "ls" to use "auto" color mode
##   - EDITOR_GUI_BIN (type=exec,def=subl) : the editor exec to use for GUI environments
##   - EDITOR_SSH_BIN (type=exec,def=nano) : the editor exec to use for remote (ssh) connections
##   - EDITOR_DEF_BIN (type=exec,def=nano) : the editor exec to use as the default fallback (for when above are unset)
##
####



##
## HELPER FUNCTION DEFINITIONS
##


#
#
#

function __get_unix() {
  local    format="${1:-+%s.%N}"
  local -a cliset=( "gdate \"${format}\"" "date \"${format}\"" "perl -MTime::HiRes=time -e 'printf \"%.9f\n\", time'" "ruby -e 'puts \"%.9f\" % Time.now'" "gdate \"$(sed -E 's/%N/0/g' <<< "${format}")\"" "date \"$(sed -E 's/%N/0/g' <<< "${format}")\"" )
  local    unix_t

  for call in "${cliset[@]}"; do unix_t="$(eval "${call}" 2> /dev/null | grep -oE '[0-9]+\.[0-9]+')" && break; done

  printf -- '%.9f' "${unix_t:-0.0}"
}



##
## USER CONFIGURATION SETTINGS
##


#
# define the unix-time (with nanoseconds) for when script began
#

declare -r LOG_STARTUP_TIME_NS="$(
  __get_unix
)"


#
# define the normal startup (initialization) text message
#

declare -r OUT_NORMAL_INIT_TXT='Loading environment'


#
# define the normal startup/ending separator text
#

declare -r OUT_NORMAL_SEPS_TXT=' ... '


#
# define the normal ending (deinitialization) text message for success
#

declare -r OUT_NORMAL_DONE_TXT='success'


#
# define the normal ending (deinitialization) text message for success
#

declare -r OUT_NORMAL_FAIL_TXT='failure'


#
# define the normal description text message format
#

declare -r OUT_NORMAL_DESC_TXT='elapsed startup time: %s seconds'


#
# configure general environment setup variables
#

declare -A ENV_DEFAULT_CONFIGS=(
  ['OUTPUT_VERBOSE']='false'
  ['LOCALE_ENABLED']='en_US.UTF-8'
  ['COLORS_LISTING']='true'
  ['EDITOR_GUI_BIN']='subl'
  ['EDITOR_SSH_BIN']='nano'
  ['EDITOR_DEF_BIN']='nano'
  ['USERS_NVM_HOME']='${HOME}/.nvm'
)


#
# configure general environment setup variables
#

declare -A ENV_GENERAL_CONFIGS=(
  ['OUTPUT_VERBOSE']="${CFG_OP_VERBOSE:=${ENV_DEFAULT_CONFIGS[OUTPUT_VERBOSE]}}"
  ['LOCALE_ENABLED']="${LOCALE_ENABLED:=${ENV_DEFAULT_CONFIGS[LOCALE_ENABLED]}}"
  ['COLORS_LISTING']="${COLORS_LISTING:=${ENV_DEFAULT_CONFIGS[COLORS_LISTING]}}"
  ['EDITOR_GUI_BIN']="${EDITOR_GUI_BIN:=${ENV_DEFAULT_CONFIGS[EDITOR_GUI_BIN]:=${ENV_DEFAULT_CONFIGS[EDITOR_DEF_BIN]}}}"
  ['EDITOR_SSH_BIN']="${EDITOR_SSH_BIN:=${ENV_DEFAULT_CONFIGS[EDITOR_SSH_BIN]:=${ENV_DEFAULT_CONFIGS[EDITOR_DEF_BIN]}}}"
  ['USERS_NVM_HOME']="${USERS_NVM_HOME:=${ENV_DEFAULT_CONFIGS[USERS_NVM_HOME]}}"
)


#
# configure general setup commands to run
#

declare -A RUN_COMMAND_SETUPS=(
  ['setup-nvm-path']="mkdir -p \"${ENV_GENERAL_CONFIGS[USERS_NVM_HOME]}\""
)


#
# configure manpaths
#

declare -a ENV_MANPATH_CONFIG=(
  '/usr/share/man'
  '$(brew --prefix)/man'
  '$(brew --prefix)/share/man'
)


#
# configure build and compilation environment variables (ARCHFLAGS)
#

declare -A BUILD_ARCHIT_FLAGS=(
  ['x86_64']='-arch'
)


#
# configure build and compilation environment variables (CPPFLAGS)
#

declare -A BUILD_LINKER_FLAGS=(
  ['$(brew --prefix)/opt/php@7.4/lib']='-L'
  ['$(brew --prefix)/opt/php/lib']='-L'
)


#
# configure build and compilation environment variables (LDFLAGS)
#

declare -A BUILD_CMPLER_FLAGS=(
  ['$(brew --prefix)/opt/php@7.4/include']='-I'
  ['$(brew --prefix)/opt/php/include']='-I'
)


#
# configure path environment variable (prefix)
#

declare -a ENV_PATHS_PREF_ADDS=(
  '/Applications/Araxis Merge.app/Contents/Utilities'
  '$(brew --prefix)/go/bin'
  '$(brew --prefix)/opt/coreutils/libexec/gnubin'
  '$(brew --prefix)/opt/gnu-sed/libexec/gnubin'
  '$(brew --prefix)/sbin'
  '${HOME}/.toolbox'
  '${HOME}/Projects/.bin'
  '${HOME}/Projects/bin'
  '${HOME}/Scripts/.bin'
  '${HOME}/Scripts/bin'
  '${HOME}/.bin'
  '${HOME}/bin'
)


#
# configure path environment variable (postfix)
#

declare -a ENV_PATHS_POST_ADDS=()


#
# configure alias definitions variable
#

declare -A ENV_GENERAL_ALIASES=(
  ['php-cs-fixer-v2']='$(brew --prefix)/opt/php-cs-fixer@2/bin/php-cs-fixer'
  ['php-cs-fixer-v3']='$(brew --prefix)/opt/php-cs-fixer/bin/php-cs-fixer'
  ['glances']='sudo $(brew --prefix)/bin/glances -1 2> /dev/null'
  ['zshconfig']='${EDITOR} ~/.zshrc'
  ['ohmyzsh']='${EDITOR} ~/.oh-my-zsh'
  ['cia']='composer info -a'
  ['ssh-src.run']='ssh rmf@src.run'
  ['ssh-src.llc']='ssh rmf@src.llc'
  ['ssh-robfrawley.com']='ssh rmf@robfrawley.com'
  ['ssh-silverpapillon.com']='ssh rmf@silverpapillon.com'
  ['ssh-symba.systems']='ssh rmf@symba.systems'
  ['ssh-twoface.systems']='ssh -p 22100 rmf@twoface.systems'
  ['ssh-enforcer.systems']='ssh -p 22086 pi@enforcer.systems'
  ['ssh-bane.systems']='ssh -p 22160 pi@bane.systems'
)


#
# configure general environment settings
#

declare -A ENV_GENERAL_EXPORTS=(
  ['LANG']="${ENV_GENERAL_CONFIGS[LOCALE_ENABLED]}"
  ['NVM_DIR']="${ENV_GENERAL_CONFIGS[USERS_NVM_HOME]}"
  ['EDITOR']="$(
    [[ -n ${SSH_CONNECTION} ]] \
      && echo -n "${ENV_GENERAL_CONFIGS[EDITOR_SSH_BIN]}" \
      || echo -n "${ENV_GENERAL_CONFIGS[EDITOR_GUI_BIN]}"
  )"
)


#
# configure files to source
#

declare -A ENV_GENERAL_SOURCES=(
  ['.p10k.zsh']='${HOME}'
  ['git-extras-completion.zsh']='$(brew --prefix)/opt/git-extras/share/git-extras'
  ['nvm.sh']='$(brew --prefix)/opt/nvm'
  ['nvm']='$(brew --prefix)/opt/nvm/etc/bash_completion.d'
)


#
# ansi style codes
#

declare -A ANSI_STYLE_CODES_ON=(
  ['rst']='0'
  ['reset']='0'
  ['bold']='1'
  ['dim']='2'
  ['underlined']='4'
  ['blink']='5'
  ['reverse']='7'
  ['hidde']='8'
)


#
# ansi style codes (reset)
#

declare -A ANSI_STYLE_CODES_RS=(
  ['rst']='0'
  ['reset']='0'
  ['bold']='21'
  ['dim']='22'
  ['underlined']='24'
  ['blink']='25'
  ['reverse']='27'
  ['hidden']='28'
)


#
# ansi color codes (fg)
#

declare -A ANSI_COLOR_CODES_FG=(
  ['def']='39'
  ['default']='39'
  ['black']='30'
  ['red']='31'
  ['green']='32'
  ['yellow']='33'
  ['blue']='34'
  ['magenta']='35'
  ['cyan']='36'
  ['light-gray']='37'
  ['dark-gray']='90'
  ['light-red']='91'
  ['light-green']='92'
  ['light-yellow']='93'
  ['light-blue']='94'
  ['light-magenta']='95'
  ['light-cyan']='96'
  ['white']='97'
)


#
# ansi color codes (bg)
#

declare -A ANSI_COLOR_CODES_BG=(
  ['def']='49'
  ['default']='49'
  ['black']='40'
  ['red']='41'
  ['green']='42'
  ['yellow']='43'
  ['blue']='44'
  ['magenta']='45'
  ['cyan']='46'
  ['light-gray']='47'
  ['dark-gray']='100'
  ['light-red']='101'
  ['light-green']='102'
  ['light-yellow']='103'
  ['light-blue']='104'
  ['light-magenta']='105'
  ['light-cyan']='106'
  ['white']='107'
)


#
# utf8 icon and character codes
#

declare -A ICON_CHAR_CODES_UTF=(
  # font awesome 4 (https://fontawesome.com/v4.7/cheatsheet/)
  ['500px']='f26e'
  ['address-book']='f2b9'
  ['address-book-o']='f2ba'
  ['address-card']='f2bb'
  ['address-card-o']='f2bc'
  ['adjust']='f042'
  ['adn']='f170'
  ['align-center']='f037'
  ['align-justify']='f039'
  ['align-left']='f036'
  ['align-right']='f038'
  ['amazon']='f270'
  ['ambulance']='f0f9'
  ['american-sign-interpreting']='f2a3'
  ['anchor']='f13d'
  ['android']='f17b'
  ['angellist']='f209'
  ['angle-double-down']='f103'
  ['angle-double-left']='f100'
  ['angle-double-right']='f101'
  ['angle-double-up']='f102'
  ['angle-down']='f107'
  ['angle-left']='f104'
  ['angle-right']='f105'
  ['angle-up']='f106'
  ['apple']='f179'
  ['archive']='f187'
  ['area-chart']='f1fe'
  ['arrow-circle-down']='f0ab'
  ['arrow-circle-left']='f0a8'
  ['arrow-circle-o-down']='f01a'
  ['arrow-circle-o-left']='f190'
  ['arrow-circle-o-right']='f18e'
  ['arrow-circle-o-up']='f01b'
  ['arrow-circle-right']='f0a9'
  ['arrow-circle-up']='f0aa'
  ['arrow-down']='f063'
  ['arrow-left']='f060'
  ['arrow-right']='f061'
  ['arrow-up']='f062'
  ['arrows']='f047'
  ['arrows-alt']='f0b2'
  ['arrows-h']='f07e'
  ['arrows-v']='f07d'
  ['asl-interpreting']='f2a3'
  ['assistive-listening-systems']='f2a2'
  ['asterisk']='f069'
  ['at']='f1fa'
  ['audio-description']='f29e'
  ['automobile']='f1b9'
  ['backward']='f04a'
  ['balance-scale']='f24e'
  ['ban']='f05e'
  ['bandcamp']='f2d5'
  ['bank']='f19c'
  ['bar-chart']='f080'
  ['bar-chart-o']='f080'
  ['barcode']='f02a'
  ['bars']='f0c9'
  ['bath']='f2cd'
  ['bathtub']='f2cd'
  ['battery']='f240'
  ['battery-0']='f244'
  ['battery-1']='f243'
  ['battery-2']='f242'
  ['battery-3']='f241'
  ['battery-4']='f240'
  ['battery-empty']='f244'
  ['battery-full']='f240'
  ['battery-half']='f242'
  ['battery-quarter']='f243'
  ['battery-three-quarters']='f241'
  ['bed']='f236'
  ['beer']='f0fc'
  ['behance']='f1b4'
  ['behance-square']='f1b5'
  ['bell']='f0f3'
  ['bell-o']='f0a2'
  ['bell-slash']='f1f6'
  ['bell-slash-o']='f1f7'
  ['bicycle']='f206'
  ['binoculars']='f1e5'
  ['birthday-cake']='f1fd'
  ['bitbucket']='f171'
  ['bitbucket-square']='f172'
  ['bitcoin']='f15a'
  ['black-tie']='f27e'
  ['blind']='f29d'
  ['bluetooth']='f293'
  ['bluetooth-b']='f294'
  ['bold']='f032'
  ['bolt']='f0e7'
  ['bomb']='f1e2'
  ['book']='f02d'
  ['bookmark']='f02e'
  ['bookmark-o']='f097'
  ['braille']='f2a1'
  ['briefcase']='f0b1'
  ['btc']='f15a'
  ['bug']='f188'
  ['building']='f1ad'
  ['building-o']='f0f7'
  ['bullhorn']='f0a1'
  ['bullseye']='f140'
  ['bus']='f207'
  ['buysellads']='f20d'
  ['cab']='f1ba'
  ['calculator']='f1ec'
  ['calendar']='f073'
  ['calendar-check-o']='f274'
  ['calendar-minus-o']='f272'
  ['calendar-o']='f133'
  ['calendar-plus-o']='f271'
  ['calendar-times-o']='f273'
  ['camera']='f030'
  ['camera-retro']='f083'
  ['car']='f1b9'
  ['caret-down']='f0d7'
  ['caret-left']='f0d9'
  ['caret-right']='f0da'
  ['caret-square-o-down']='f150'
  ['caret-square-o-left']='f191'
  ['caret-square-o-right']='f152'
  ['caret-square-o-up']='f151'
  ['caret-up']='f0d8'
  ['cart-arrow-down']='f218'
  ['cart-plus']='f217'
  ['cc']='f20a'
  ['cc-amex']='f1f3'
  ['cc-diners-club']='f24c'
  ['cc-discover']='f1f2'
  ['cc-jcb']='f24b'
  ['cc-mastercard']='f1f1'
  ['cc-paypal']='f1f4'
  ['cc-stripe']='f1f5'
  ['cc-visa']='f1f0'
  ['certificate']='f0a3'
  ['chain']='f0c1'
  ['chain-broken']='f127'
  ['check']='f00c'
  ['check-circle']='f058'
  ['check-circle-o']='f05d'
  ['check-square']='f14a'
  ['check-square-o']='f046'
  ['chevron-circle-down']='f13a'
  ['chevron-circle-left']='f137'
  ['chevron-circle-right']='f138'
  ['chevron-circle-up']='f139'
  ['chevron-down']='f078'
  ['chevron-left']='f053'
  ['chevron-right']='f054'
  ['chevron-up']='f077'
  ['child']='f1ae'
  ['chrome']='f268'
  ['circle']='f111'
  ['circle-o']='f10c'
  ['circle-o-notch']='f1ce'
  ['circle-thin']='f1db'
  ['clipboard']='f0ea'
  ['clock-o']='f017'
  ['clone']='f24d'
  ['close']='f00d'
  ['cloud']='f0c2'
  ['cloud-download']='f0ed'
  ['cloud-upload']='f0ee'
  ['cny']='f157'
  ['code']='f121'
  ['code-fork']='f126'
  ['codepen']='f1cb'
  ['codiepie']='f284'
  ['coffee']='f0f4'
  ['cog']='f013'
  ['cogs']='f085'
  ['columns']='f0db'
  ['comment']='f075'
  ['comment-o']='f0e5'
  ['commenting']='f27a'
  ['commenting-o']='f27b'
  ['comments']='f086'
  ['comments-o']='f0e6'
  ['compass']='f14e'
  ['compress']='f066'
  ['connectdevelop']='f20e'
  ['contao']='f26d'
  ['copy']='f0c5'
  ['copyright']='f1f9'
  ['creative-commons']='f25e'
  ['credit-card']='f09d'
  ['credit-card-alt']='f283'
  ['crop']='f125'
  ['crosshairs']='f05b'
  ['css3']='f13c'
  ['cube']='f1b2'
  ['cubes']='f1b3'
  ['cut']='f0c4'
  ['cutlery']='f0f5'
  ['dashboard']='f0e4'
  ['dashcube']='f210'
  ['database']='f1c0'
  ['deaf']='f2a4'
  ['deafness']='f2a4'
  ['dedent']='f03b'
  ['delicious']='f1a5'
  ['desktop']='f108'
  ['deviantart']='f1bd'
  ['diamond']='f219'
  ['digg']='f1a6'
  ['dollar']='f155'
  ['dot-circle-o']='f192'
  ['download']='f019'
  ['dribbble']='f17d'
  ['drivers-license']='f2c2'
  ['drivers-license-o']='f2c3'
  ['dropbox']='f16b'
  ['drupal']='f1a9'
  ['edge']='f282'
  ['edit']='f044'
  ['eercast']='f2da'
  ['eject']='f052'
  ['ellipsis-h']='f141'
  ['ellipsis-v']='f142'
  ['empire']='f1d1'
  ['envelope']='f0e0'
  ['envelope-o']='f003'
  ['envelope-open']='f2b6'
  ['envelope-open-o']='f2b7'
  ['envelope-square']='f199'
  ['envira']='f299'
  ['eraser']='f12d'
  ['etsy']='f2d7'
  ['eur']='f153'
  ['euro']='f153'
  ['exchange']='f0ec'
  ['exclamation']='f12a'
  ['exclamation-circle']='f06a'
  ['exclamation-triangle']='f071'
  ['expand']='f065'
  ['expeditedssl']='f23e'
  ['external-link']='f08e'
  ['external-link-square']='f14c'
  ['eye']='f06e'
  ['eye-slash']='f070'
  ['eyedropper']='f1fb'
  ['fa']='f2b4'
  ['facebook']='f09a'
  ['facebook-f']='f09a'
  ['facebook-official']='f230'
  ['facebook-square']='f082'
  ['fast-backward']='f049'
  ['fast-forward']='f050'
  ['fax']='f1ac'
  ['feed']='f09e'
  ['female']='f182'
  ['fighter-jet']='f0fb'
  ['file']='f15b'
  ['file-archive-o']='f1c6'
  ['file-audio-o']='f1c7'
  ['file-code-o']='f1c9'
  ['file-excel-o']='f1c3'
  ['file-image-o']='f1c5'
  ['file-movie-o']='f1c8'
  ['file-o']='f016'
  ['file-pdf-o']='f1c1'
  ['file-photo-o']='f1c5'
  ['file-picture-o']='f1c5'
  ['file-powerpoint-o']='f1c4'
  ['file-sound-o']='f1c7'
  ['file-text']='f15c'
  ['file-text-o']='f0f6'
  ['file-video-o']='f1c8'
  ['file-word-o']='f1c2'
  ['file-zip-o']='f1c6'
  ['files-o']='f0c5'
  ['film']='f008'
  ['filter']='f0b0'
  ['fire']='f06d'
  ['fire-extinguisher']='f134'
  ['firefox']='f269'
  ['first-order']='f2b0'
  ['flag']='f024'
  ['flag-checkered']='f11e'
  ['flag-o']='f11d'
  ['flash']='f0e7'
  ['flask']='f0c3'
  ['flickr']='f16e'
  ['floppy-o']='f0c7'
  ['folder']='f07b'
  ['folder-o']='f114'
  ['folder-open']='f07c'
  ['folder-open-o']='f115'
  ['font']='f031'
  ['font-awesome']='f2b4'
  ['fonticons']='f280'
  ['fort-awesome']='f286'
  ['forumbee']='f211'
  ['forward']='f04e'
  ['foursquare']='f180'
  ['free-code-camp']='f2c5'
  ['frown-o']='f119'
  ['futbol-o']='f1e3'
  ['gamepad']='f11b'
  ['gavel']='f0e3'
  ['gbp']='f154'
  ['ge']='f1d1'
  ['gear']='f013'
  ['gears']='f085'
  ['genderless']='f22d'
  ['get-pocket']='f265'
  ['gg']='f260'
  ['gg-circle']='f261'
  ['gift']='f06b'
  ['git']='f1d3'
  ['git-square']='f1d2'
  ['github']='f09b'
  ['github-alt']='f113'
  ['github-square']='f092'
  ['gitlab']='f296'
  ['gittip']='f184'
  ['glass']='f000'
  ['glide']='f2a5'
  ['glide-g']='f2a6'
  ['globe']='f0ac'
  ['google']='f1a0'
  ['google-plus']='f0d5'
  ['google-plus-circle']='f2b3'
  ['google-plus-official']='f2b3'
  ['google-plus-square']='f0d4'
  ['google-wallet']='f1ee'
  ['graduation-cap']='f19d'
  ['gratipay']='f184'
  ['grav']='f2d6'
  ['group']='f0c0'
  ['h-square']='f0fd'
  ['hacker-news']='f1d4'
  ['hand-grab-o']='f255'
  ['hand-lizard-o']='f258'
  ['hand-o-down']='f0a7'
  ['hand-o-left']='f0a5'
  ['hand-o-right']='f0a4'
  ['hand-o-up']='f0a6'
  ['hand-paper-o']='f256'
  ['hand-peace-o']='f25b'
  ['hand-pointer-o']='f25a'
  ['hand-rock-o']='f255'
  ['hand-scissors-o']='f257'
  ['hand-spock-o']='f259'
  ['hand-stop-o']='f256'
  ['handshake-o']='f2b5'
  ['hard-of-hearing']='f2a4'
  ['hashtag']='f292'
  ['hdd-o']='f0a0'
  ['header']='f1dc'
  ['headphones']='f025'
  ['heart']='f004'
  ['heart-o']='f08a'
  ['heartbeat']='f21e'
  ['history']='f1da'
  ['home']='f015'
  ['hospital-o']='f0f8'
  ['hotel']='f236'
  ['hourglass']='f254'
  ['hourglass-1']='f251'
  ['hourglass-2']='f252'
  ['hourglass-3']='f253'
  ['hourglass-end']='f253'
  ['hourglass-half']='f252'
  ['hourglass-o']='f250'
  ['hourglass-start']='f251'
  ['houzz']='f27c'
  ['html5']='f13b'
  ['i-cursor']='f246'
  ['id-badge']='f2c1'
  ['id-card']='f2c2'
  ['id-card-o']='f2c3'
  ['ils']='f20b'
  ['image']='f03e'
  ['imdb']='f2d8'
  ['inbox']='f01c'
  ['indent']='f03c'
  ['industry']='f275'
  ['info']='f129'
  ['info-circle']='f05a'
  ['inr']='f156'
  ['instagram']='f16d'
  ['institution']='f19c'
  ['internet-explorer']='f26b'
  ['intersex']='f224'
  ['ioxhost']='f208'
  ['italic']='f033'
  ['joomla']='f1aa'
  ['jpy']='f157'
  ['jsfiddle']='f1cc'
  ['key']='f084'
  ['keyboard-o']='f11c'
  ['krw']='f159'
  ['language']='f1ab'
  ['laptop']='f109'
  ['lastfm']='f202'
  ['lastfm-square']='f203'
  ['leaf']='f06c'
  ['leanpub']='f212'
  ['legal']='f0e3'
  ['lemon-o']='f094'
  ['level-down']='f149'
  ['level-up']='f148'
  ['life-bouy']='f1cd'
  ['life-buoy']='f1cd'
  ['life-ring']='f1cd'
  ['life-saver']='f1cd'
  ['lightbulb-o']='f0eb'
  ['line-chart']='f201'
  ['link']='f0c1'
  ['linkedin']='f0e1'
  ['linkedin-square']='f08c'
  ['linode']='f2b8'
  ['linux']='f17c'
  ['list']='f03a'
  ['list-alt']='f022'
  ['list-ol']='f0cb'
  ['list-ul']='f0ca'
  ['location-arrow']='f124'
  ['lock']='f023'
  ['long-arrow-down']='f175'
  ['long-arrow-left']='f177'
  ['long-arrow-right']='f178'
  ['long-arrow-up']='f176'
  ['low-vision']='f2a8'
  ['magic']='f0d0'
  ['magnet']='f076'
  ['mail-forward']='f064'
  ['mail-reply']='f112'
  ['mail-reply-all']='f122'
  ['male']='f183'
  ['map']='f279'
  ['map-marker']='f041'
  ['map-o']='f278'
  ['map-pin']='f276'
  ['map-signs']='f277'
  ['mars']='f222'
  ['mars-double']='f227'
  ['mars-stroke']='f229'
  ['mars-stroke-h']='f22b'
  ['mars-stroke-v']='f22a'
  ['maxcdn']='f136'
  ['meanpath']='f20c'
  ['medium']='f23a'
  ['medkit']='f0fa'
  ['meetup']='f2e0'
  ['meh-o']='f11a'
  ['mercury']='f223'
  ['microchip']='f2db'
  ['microphone']='f130'
  ['microphone-slash']='f131'
  ['minus']='f068'
  ['minus-circle']='f056'
  ['minus-square']='f146'
  ['minus-square-o']='f147'
  ['mixcloud']='f289'
  ['mobile']='f10b'
  ['mobile-phone']='f10b'
  ['modx']='f285'
  ['money']='f0d6'
  ['moon-o']='f186'
  ['mortar-board']='f19d'
  ['motorcycle']='f21c'
  ['mouse-pointer']='f245'
  ['music']='f001'
  ['navicon']='f0c9'
  ['neuter']='f22c'
  ['newspaper-o']='f1ea'
  ['object-group']='f247'
  ['object-ungroup']='f248'
  ['odnoklassniki']='f263'
  ['odnoklassniki-square']='f264'
  ['opencart']='f23d'
  ['openid']='f19b'
  ['opera']='f26a'
  ['optin-monster']='f23c'
  ['outdent']='f03b'
  ['pagelines']='f18c'
  ['paint-brush']='f1fc'
  ['paper-plane']='f1d8'
  ['paper-plane-o']='f1d9'
  ['paperclip']='f0c6'
  ['paragraph']='f1dd'
  ['paste']='f0ea'
  ['pause']='f04c'
  ['pause-circle']='f28b'
  ['pause-circle-o']='f28c'
  ['paw']='f1b0'
  ['paypal']='f1ed'
  ['pencil']='f040'
  ['pencil-square']='f14b'
  ['pencil-square-o']='f044'
  ['percent']='f295'
  ['phone']='f095'
  ['phone-square']='f098'
  ['photo']='f03e'
  ['picture-o']='f03e'
  ['pie-chart']='f200'
  ['pied-piper']='f2ae'
  ['pied-piper-alt']='f1a8'
  ['pied-piper-pp']='f1a7'
  ['pinterest']='f0d2'
  ['pinterest-p']='f231'
  ['pinterest-square']='f0d3'
  ['plane']='f072'
  ['play']='f04b'
  ['play-circle']='f144'
  ['play-circle-o']='f01d'
  ['plug']='f1e6'
  ['plus']='f067'
  ['plus-circle']='f055'
  ['plus-square']='f0fe'
  ['plus-square-o']='f196'
  ['podcast']='f2ce'
  ['power-off']='f011'
  ['print']='f02f'
  ['product-hunt']='f288'
  ['puzzle-piece']='f12e'
  ['qq']='f1d6'
  ['qrcode']='f029'
  ['question']='f128'
  ['question-circle']='f059'
  ['question-circle-o']='f29c'
  ['quora']='f2c4'
  ['quote-left']='f10d'
  ['quote-right']='f10e'
  ['ra']='f1d0'
  ['random']='f074'
  ['ravelry']='f2d9'
  ['rebel']='f1d0'
  ['recycle']='f1b8'
  ['reddit']='f1a1'
  ['reddit-alien']='f281'
  ['reddit-square']='f1a2'
  ['refresh']='f021'
  ['registered']='f25d'
  ['remove']='f00d'
  ['renren']='f18b'
  ['reorder']='f0c9'
  ['repeat']='f01e'
  ['reply']='f112'
  ['reply-all']='f122'
  ['resistance']='f1d0'
  ['retweet']='f079'
  ['rmb']='f157'
  ['road']='f018'
  ['rocket']='f135'
  ['rotate-left']='f0e2'
  ['rotate-right']='f01e'
  ['rouble']='f158'
  ['rss']='f09e'
  ['rss-square']='f143'
  ['rub']='f158'
  ['ruble']='f158'
  ['rupee']='f156'
  ['s15']='f2cd'
  ['safari']='f267'
  ['save']='f0c7'
  ['scissors']='f0c4'
  ['scribd']='f28a'
  ['search']='f002'
  ['search-minus']='f010'
  ['search-plus']='f00e'
  ['sellsy']='f213'
  ['send']='f1d8'
  ['send-o']='f1d9'
  ['server']='f233'
  ['share']='f064'
  ['share-alt']='f1e0'
  ['share-alt-square']='f1e1'
  ['share-square']='f14d'
  ['share-square-o']='f045'
  ['shekel']='f20b'
  ['sheqel']='f20b'
  ['shield']='f132'
  ['ship']='f21a'
  ['shirtsinbulk']='f214'
  ['shopping-bag']='f290'
  ['shopping-basket']='f291'
  ['shopping-cart']='f07a'
  ['shower']='f2cc'
  ['sign-in']='f090'
  ['sign-language']='f2a7'
  ['sign-out']='f08b'
  ['signal']='f012'
  ['signing']='f2a7'
  ['simplybuilt']='f215'
  ['sitemap']='f0e8'
  ['skyatlas']='f216'
  ['skype']='f17e'
  ['slack']='f198'
  ['sliders']='f1de'
  ['slideshare']='f1e7'
  ['smile-o']='f118'
  ['snapchat']='f2ab'
  ['snapchat-ghost']='f2ac'
  ['snapchat-square']='f2ad'
  ['snowflake-o']='f2dc'
  ['soccer-ball-o']='f1e3'
  ['sort']='f0dc'
  ['sort-alpha-asc']='f15d'
  ['sort-alpha-desc']='f15e'
  ['sort-amount-asc']='f160'
  ['sort-amount-desc']='f161'
  ['sort-asc']='f0de'
  ['sort-desc']='f0dd'
  ['sort-down']='f0dd'
  ['sort-numeric-asc']='f162'
  ['sort-numeric-desc']='f163'
  ['sort-up']='f0de'
  ['soundcloud']='f1be'
  ['space-shuttle']='f197'
  ['spinner']='f110'
  ['spoon']='f1b1'
  ['spotify']='f1bc'
  ['square']='f0c8'
  ['square-o']='f096'
  ['stack-exchange']='f18d'
  ['stack-overflow']='f16c'
  ['star']='f005'
  ['star-half']='f089'
  ['star-half-empty']='f123'
  ['star-half-full']='f123'
  ['star-half-o']='f123'
  ['star-o']='f006'
  ['steam']='f1b6'
  ['steam-square']='f1b7'
  ['step-backward']='f048'
  ['step-forward']='f051'
  ['stethoscope']='f0f1'
  ['sticky-note']='f249'
  ['sticky-note-o']='f24a'
  ['stop']='f04d'
  ['stop-circle']='f28d'
  ['stop-circle-o']='f28e'
  ['street-view']='f21d'
  ['strikethrough']='f0cc'
  ['stumbleupon']='f1a4'
  ['stumbleupon-circle']='f1a3'
  ['subscript']='f12c'
  ['subway']='f239'
  ['suitcase']='f0f2'
  ['sun-o']='f185'
  ['superpowers']='f2dd'
  ['superscript']='f12b'
  ['support']='f1cd'
  ['table']='f0ce'
  ['tablet']='f10a'
  ['tachometer']='f0e4'
  ['tag']='f02b'
  ['tags']='f02c'
  ['tasks']='f0ae'
  ['taxi']='f1ba'
  ['telegram']='f2c6'
  ['television']='f26c'
  ['tencent-weibo']='f1d5'
  ['terminal']='f120'
  ['text-height']='f034'
  ['text-width']='f035'
  ['th']='f00a'
  ['th-large']='f009'
  ['th-list']='f00b'
  ['themeisle']='f2b2'
  ['thermometer']='f2c7'
  ['thermometer-0']='f2cb'
  ['thermometer-1']='f2ca'
  ['thermometer-2']='f2c9'
  ['thermometer-3']='f2c8'
  ['thermometer-4']='f2c7'
  ['thermometer-empty']='f2cb'
  ['thermometer-full']='f2c7'
  ['thermometer-half']='f2c9'
  ['thermometer-quarter']='f2ca'
  ['thermometer-three-quarters']='f2c8'
  ['thumb-tack']='f08d'
  ['thumbs-down']='f165'
  ['thumbs-o-down']='f088'
  ['thumbs-o-up']='f087'
  ['thumbs-up']='f164'
  ['ticket']='f145'
  ['times']='f00d'
  ['times-circle']='f057'
  ['times-circle-o']='f05c'
  ['times-rectangle']='f2d3'
  ['times-rectangle-o']='f2d4'
  ['tint']='f043'
  ['toggle-down']='f150'
  ['toggle-left']='f191'
  ['toggle-off']='f204'
  ['toggle-on']='f205'
  ['toggle-right']='f152'
  ['toggle-up']='f151'
  ['trademark']='f25c'
  ['train']='f238'
  ['transgender']='f224'
  ['transgender-alt']='f225'
  ['trash']='f1f8'
  ['trash-o']='f014'
  ['tree']='f1bb'
  ['trello']='f181'
  ['tripadvisor']='f262'
  ['trophy']='f091'
  ['truck']='f0d1'
  ['try']='f195'
  ['tty']='f1e4'
  ['tumblr']='f173'
  ['tumblr-square']='f174'
  ['turkish-lira']='f195'
  ['tv']='f26c'
  ['twitch']='f1e8'
  ['twitter']='f099'
  ['twitter-square']='f081'
  ['umbrella']='f0e9'
  ['underline']='f0cd'
  ['undo']='f0e2'
  ['universal-access']='f29a'
  ['university']='f19c'
  ['unlink']='f127'
  ['unlock']='f09c'
  ['unlock-alt']='f13e'
  ['unsorted']='f0dc'
  ['upload']='f093'
  ['usb']='f287'
  ['usd']='f155'
  ['user']='f007'
  ['user-circle']='f2bd'
  ['user-circle-o']='f2be'
  ['user-md']='f0f0'
  ['user-o']='f2c0'
  ['user-plus']='f234'
  ['user-secret']='f21b'
  ['user-times']='f235'
  ['users']='f0c0'
  ['vcard']='f2bb'
  ['vcard-o']='f2bc'
  ['venus']='f221'
  ['venus-double']='f226'
  ['venus-mars']='f228'
  ['viacoin']='f237'
  ['viadeo']='f2a9'
  ['viadeo-square']='f2aa'
  ['video-camera']='f03d'
  ['vimeo']='f27d'
  ['vimeo-square']='f194'
  ['vine']='f1ca'
  ['vk']='f189'
  ['volume-control-phone']='f2a0'
  ['volume-down']='f027'
  ['volume-off']='f026'
  ['volume-up']='f028'
  ['warning']='f071'
  ['wechat']='f1d7'
  ['weibo']='f18a'
  ['weixin']='f1d7'
  ['whatsapp']='f232'
  ['wheelchair']='f193'
  ['wheelchair-alt']='f29b'
  ['wifi']='f1eb'
  ['wikipedia-w']='f266'
  ['window-close']='f2d3'
  ['window-close-o']='f2d4'
  ['window-maximize']='f2d0'
  ['window-minimize']='f2d1'
  ['window-restore']='f2d2'
  ['windows']='f17a'
  ['won']='f159'
  ['wordpress']='f19a'
  ['wpbeginner']='f297'
  ['wpexplorer']='f2de'
  ['wpforms']='f298'
  ['wrench']='f0ad'
  ['xing']='f168'
  ['xing-square']='f169'
  ['y-combinator']='f23b'
  ['y-combinator-square']='f1d4'
  ['yahoo']='f19e'
  ['yc']='f23b'
  ['yc-square']='f1d4'
  ['yelp']='f1e9'
  ['yen']='f157'
  ['yoast']='f2b1'
  ['youtube']='f167'
  ['youtube-play']='f16a'
  ['youtube-square']='f166'
  # utf8 characters
  ['exclamation-question-mark']='2049'
  ['question-mark-2x']='2047'
  ['question-exclamation-mark']='2048'
  ['asterisk-2-v']='2051'
  ['asterisk-3-v']='2042'
  ['bullet']='2022'
  ['bullet-triangle']='2023'
  ['bullet-open-ctr']='0d82'
  ['hyphen']='2010'
  ['hyphen-sm']='2027'
  ['hyphen-lg']='2043'
  ['hyphen-2x-norm']='2e40'
  ['hyphen-2x-diag']='2e17'
  ['arrow-up-dn']='2195'
  ['arrow-2x-head-rt']='21a0'
  ['arrow-2x-head-lf']='219e'
  ['arrow-2x-head-up']='219f'
  ['arrow-2x-head-dn']='21a1'
  ['arrow-north-west']='2196'
  ['arrow-north-east']='2197'
  ['arrow-south-east']='2198'
  ['arrow-south-west']='2199'
  ['sign-registered']='00ae'
  ['sign-trademark']='2122'
  ['sign-copyright']='00a9'
  ['sign-copyright-recording']='2117'
  ['sign-degree']='00b0'
  ['sign-degree-c']='2103'
  ['sign-degree-f']='2109'
  ['line-low']='005f'
  ['dash-fg']='2012'
  ['dash-en']='2013'
  ['dash-em']='2014'
  ['dash-em-2x']='2e3a'
  ['dash-em-3x']='2e3b'
  ['angled-quote-mark-rt']='203a'
  ['angled-quote-mark-2x-rt']='00bb'
  ['angled-quote-mark-lf']='2039'
  ['angled-quote-mark-2x-lf']='00ab'
  ['angled-brack-math-2x-rt']='27eb'
  ['angled-brack-math-2x-lf']='27ea'
  ['angled-brack-math-rt']='27e9'
  ['angled-brack-math-lf']='27e8'
  ['binded-brack-znot-rt']='298a'
  ['binded-brack-znot-lf']='2989'
  ['square-brack-quil-rt']='2046'
  ['square-brack-quil-lf']='2045'
  ['square-brack-lf']='005b'
  ['square-brack-rt']='005d'
  ['bar-h']='2015'
  ['bar-v-broken']='00a6'
  ['dot-triangle-up']='2e2a'
  ['dot-triangle-dn']='2e2b'
  ['dot-squared']='2e2c'
  ['dot-diamond']='2e2d'
  ['dot-midl-2x']='205a'
  ['dot-midl-3x']='2056'
  ['dot-midl-4x']='2058'
  ['dot-midl-5x']='2059'
  ['dot-mark-1x']='2024'
  ['dot-mark-2x']='2025'
  ['dot-mark-3x']='2026'
  ['ellipsis']='2026'
  ['mongolian-fullstop']='1803'
  ['mongolian-comman']='1802'
  ['mongolian-ellipsis']='1801'
)


#
## FUNCTION DEFINITIONS
#


#
# output icon control sequences
#

function __get_icon() {
  local index="${1}"

  local coded="${ICON_CHAR_CODES_UTF[${index}]}"

  if [[ -n ${coded} ]]; then
    __out_text "$(__out_text '%s' "\u${coded}")"
  fi
}


#
# output styled icon control sequences
#

function __sty_icon() {
  __get_ansi "i:${1}" "${@:2}"
}


#
# sanitize input value as 256 ansi color code
#

function __sanitize_ansi_256_color() {
  local deft=7
  local code="${1:-${deft}}"

  if [[ ${code} -gt 255 ]]; then
    code=255
  fi

  if [[ ${code} -lt 0 ]]; then
    code=0
  fi

  printf '%d' "${code}"
}


#
# output color control sequences
#

function __get_ansi() {
  local -a codes=("${@}")
  local    inner=''
  local    write=''
  local    new_l=0

  for c in "${(@v)codes}"; do
    local type="${c:0:1}"
    local name="${c:2}"

    case "${type}" in
      t)   write+="${name}"                                                       ;;
      i)   write+="$(__get_icon "${name}")"                                       ;;
      I)   write+=" $(__get_icon "${name}") "                                     ;;
      f)   inner+="${ANSI_COLOR_CODES_FG[${name}]:-${ANSI_COLOR_CODES_FG[def]}};" ;;
      b)   inner+="${ANSI_COLOR_CODES_BG[${name}]:-${ANSI_COLOR_CODES_BG[def]}};" ;;
      F)   inner+="$(printf '38;5;%s;' "$(__sanitize_ansi_256_color "${name}")")" ;;
      B)   inner+="$(printf '48;5;%s;' "$(__sanitize_ansi_256_color "${name}")")" ;;
      s)   inner+="${ANSI_STYLE_CODES_ON[${name}]:-${ANSI_STYLE_CODES_ON[rst]}};" ;;
      r|*) inner+="${ANSI_STYLE_CODES_RS[${name}]:-${ANSI_STYLE_CODES_RS[rst]}};" ;;
    esac
  done

  if [[ ${#inner} -gt 0 ]]; then
    inner="${inner:0:-1}"
  fi

  if [[ ${write:(-2)} == '\n' ]]; then
    write="${write:0:-2}"
    new_l=1
  fi

  __out_text '\e[%sm%s' "${inner}" "${write}"

  if [[ ${new_l} -eq 1 ]]; then
    __out_text '\e[%sm\n' "${ANSI_STYLE_CODES_RS[rst]}"
  fi
}

#
# checks if command is found in path
#

function __is_command_real() {
  command -v "$(__expand_value "${1}")" &> /dev/null
}


#
# checks if passed value is equivalent to a boolean true ("1", "true", etc)
#

function __is_boolean_true() {
  case "${(L)1}" in
    1|t|true|e|enabled|y|yes) return 0 ;;
    0|f|false|d|disabled|n|no|*) return 1 ;;
  esac
}


#
# alias for __is_bool_t
#

function __is_bool_t() {
  __is_boolean_true "${1}"
}


#
# checks if passed value is equivalent to a boolean true ("0", "false", etc)
#

function __is_bool_f() {
  ! __is_boolean_true "${1}"
}


#
# checks if values are equal
#

function __is_same() {
  local    failures=0
  local -a fixtures=("${@}")
  local    position

  for ((position = 1; position < ${#fixtures}; position += 1)); do
    [[ "${fixtures[${position}]:-}" == "${fixtures[$((position+1))]:-}" ]] || (( failures+=1 ))
  done

  return "${failures}"
}


#
# checks if values are equal
#

function __is_same_sets() {
  local    failures=0
  local -a fixtures=("${@}")
  local    position

  for ((position = 1; position <= ${#fixtures}; position += 2)); do
    __is_same "${fixtures[${position}]:-}" "${fixtures[$((position+1))]}" || (( failures+=1 ))
  done

  return "${failures}"
}


#
# checks if passed return status codes matches the expected one
#

function __is_status_code() {
  __is_same "${@}"
}


#
# checks if passed return status codes indicate success or failure
#

function __is_status_okay() {
  __is_status_code 0 "${@}"
}


#
# check if debug mode is enabled
#

function __is_debug() {
  __is_bool_t "${ENV_GENERAL_CONFIGS[OUTPUT_VERBOSE]}"
}

#
# define function to check if cli flag and value already exists in vgariable
#

function __is_flag_opts_found() {
  local flag="${1}"
  local optn="${2}"
  local envv="${3}"

  grep -E -- "${flag}\s?${optn}($|\s)" <<< "${envv:- }" &> /dev/null
}


#
# collection of simple output helper functions
#

function __out_text() { printf -- "${@}" } #| gsed 's/\x1b\[[0-9;]*m//g';
function __out_line() { __out_text "${1}\n" "${@:2}"; }
function __out_newl() { for i in $(seq 1 "${1:-1}" 2> /dev/null); do __out_line; done; }
function __out_date() { __out_text '%.06f' "$(__get_unix)"; }
function __out_rept() { for i in $(seq 1 ${2:-1}); do __out_text "${1}"; done }


#
# output the various "type"-styled log line uding an open format
#

function __out_debg() { __out_type 'debg' "${@}"; }
function __out_info() { __out_type 'info' "${@}"; }
function __out_warn() { __out_type 'warn' "${@}" 1>&2; }
function __out_fail() { __out_type 'fail' "${@}" 1>&2; }
function __out_crit() { __out_type 'crit' "${@}" 1>&2; }
function __out_type() {
  local    type="${1}"
  local    text="${2}"
  local -a args=("${@:3}")
  local    clrl='\e[38;5;242;48;5;234m'
  local    clrd='\e[38;5;248;48;5;234m'

  if ! __is_debug && [[ ${(L)type} != 'fail' ]] && [[ ${(L)type} != 'crit' ]]; then
    return
  fi

  __out_line "$(
    __out_text ' %s%s %s%s%s %s %s%.03f%s %s%s %s %s' \
      "${clrl}" \
      "$(__get_icon bar-v-broken)" \
      "$(__get_ansi 's:reset')${clrd}" \
      "$(basename "$(realpath "${(%):-%x}")" '.zsh')" \
      "$(__get_ansi 's:reset')${clrl}" \
      "$(__get_icon at)" \
      "$(__get_ansi 's:reset')${clrd}" \
      "$(__out_date)" \
      "$(__get_ansi 's:reset')${clrl}" \
      "$(__get_icon bar-v-broken)" \
      "$(__get_ansi 's:reset')" \
      "$(__get_type_style "${type}")" \
      "$(__get_text_style "${type}" "${text}" "${(@v)args}")"
    )"
}


#
# output the various "type"-styled log line uding a less-standard format (form more complex requirements)
#

function __cpx_debg() { __cpx_type 'debg' "${@}" }
function __cpx_info() { __cpx_type 'info' "${@}" }
function __cpx_warn() { __cpx_type 'warn' "${@}" }
function __cpx_fail() { __cpx_type 'fail' "${@}" }
function __cpx_crit() { __cpx_type 'crit' "${@}" }
function __cpx_type() {
  local    out_type="${1}"
  local    act_info="${2}"
  local    act_item="${3}"
  local    rst_info="${4}"
  local -a rst_args=("${@:5}")

  __out_type "${out_type}" "$(
    __out_text '%s: %s %s %s' "${act_info}" "${act_item}" "$(__get_sepr)$(__get_text_style_init "${out_type}")" "$(
      [[ -n ${rst_info} ]] && __out_text "${rst_info}" "${(@v)rst_args}"
    )"
  )"
}


#
# output the various "type"-styled log line uding a standard format
#

function __std_debg() { __std_type 'debg' "${@}" }
function __std_info() { __std_type 'info' "${@}" }
function __std_warn() { __std_type 'warn' "${@}" }
function __std_fail() { __std_type 'fail' "${@}" }
function __std_crit() { __std_type 'crit' "${@}" }
function __std_type() {
  local    out_type="${1}"
  local    act_info="${2}"
  local    act_item="${3}"
  local    rst_info="${4}"
  local    rst_desc="${5}"
  local -a rst_args=("${@:6}")

  __cpx_type "${out_type}" "${act_info}" "${act_item}" '"%s" (%s)' "${rst_info}" "$(
    __out_text "${rst_desc}" "${(@v)rst_args}"
  )"
  #__out_type "${out_type}" "$(
  #  __out_text '%s: %s %s "%s"%s' "${act_info}" "${act_item}" "$(__get_sepr)" "${rst_info}" "$(
  #    [[ -n ${rst_desc} ]] && __out_text " (${rst_desc})" "${(@v)rst_args}"
  #  )"
  #)"
}


#
# output styled "type"-section of log line
#

function __get_type_style() {
  local    type="${1}"
  local -A colr_main=(
    ['debg']="$(__get_ansi f:white b:blue)"
    ['info']="$(__get_ansi f:black b:light-green)"
    ['warn']="$(__get_ansi f:white b:magenta)"
    ['fail']="$(__get_ansi f:white b:yellow)"
    ['crit']="$(__get_ansi f:white b:red)"
  )
  local -A colr_acct=(
    ['debg']="$(__get_ansi f:blue)"
    ['info']="$(__get_ansi f:green)"
    ['warn']="$(__get_ansi f:magenta)"
    ['fail']="$(__get_ansi f:yellow)"
    ['crit']="$(__get_ansi f:red)"
  )
  local   used_main="${colr_main[${(L)type}]:-39}"
  local   used_acct="${colr_acct[${(L)type}]:-39}"
  local   colr_rest="$(__get_ansi 's:reset')"

  __out_text '%s%s%s ' \
    "${used_acct}" \
    "$(__get_icon caret-left)" \
    "${colr_rest}"
  __out_text '%s %s %s %s%s%s' \
    "${used_main}" \
    "${(L)type}" \
    "${colr_rest}" \
    "${used_acct}" \
    "$(__get_icon caret-right)" \
    "${colr_rest}"
}


#
# output styled "text"-section of log line
#

function __get_text_style_init() {
  local    type="${1}"
  local    text="${2}"
  local -a args=("${@:3}")
  local -A colr=(['debg']='90'   ['info']='39' ['warn']='39'   ['fail']='39;1' ['crit']='91;1')
  local -A char=(['debg']='39;2' ['info']='39' ['warn']='39;1' ['fail']='39;1' ['crit']='39;1')

  __out_text '\e[%sm%s' \
    "${colr[${(L)type}]:-39}" \
    "$(__out_text "${text}" "${(@v)args}")"
}


#
# output styled "text"-section of log line
#

function __get_text_style() {
  local    type="${1}"
  local    text="$(__get_text_style_init "${@}")"
  local    tend="${text[-1]}"
  local -A ends=(['fail']="$(__get_ansi 'i:exclamation-mark-2x' 'f:bright-red' 's:bold')" ['crit']="$(__get_ansi 'i:exclamation-mark-2x' 'f:bright-red' 's:bold')" )

  if [[ ${tend} != '.' ]] && [[ ${tend} != '!' ]] && [[ ${tend} != '?' ]] && [[ ${tend} != ':' ]] && [[ ${tend} != ' ' ]] && [[ ${tend} != "'" ]]; then
    text+=" ${ends[${(L)type}]:-\u$(__get_ansi 'i:dot-mark-3x' 's:dim')} "
  fi
  __out_text '%s\e[0m' "${text}"
}


#
# assert that a proper number of arguments are passed to __concst_flags_to_env_var function
#

function __assert_args_for_func_concat_flags_to_env_var() {
  [[ ${#} -le 1 ]] && return 0

  if [[ $(( ${#} % 2 )) -ne 0 ]]; then
      __out_fail 'Invalid funcargs in "%s" function detected; expected the env flags var name followed by an even number of args (as pairs of flags and opts)' "${funcstack[1]}"
      __out_fail 'Prematurely exiting "%s" function invoked with the following arguments:' "${funcstack[1]}"
      for a in "${@}"; do __out_fail '  - "%s"' "${a}"; done

      return 1
  fi
}


#
# concat flags and their respective values to environment variables and return new value
#

function __concat_flags_to_env_var() {
  local    flags_name="${1}"; shift
  local    exist_text="${(P)flags_name}"
  local -a flags_list=()
  local -a optns_list=()
  local    prior_opts
  local    addon_opts
  local    final_opts

  __assert_args_for_func_concat_flags_to_env_var "${@}" || return $?

  while [[ ${#} -gt 1 ]]; do
    optns_list+=("$(__expand_value "${1}")"); shift; flags_list+=("$(__expand_value "${1}")"); shift
  done

  for ((i = 1; i <= ${#flags_list}; i++)); do
    if ! __is_flag_opts_found "${flags_list[${i}]}" "${optns_list[${i}]}" "${exist_text}"; then
      addon_opts+="${flags_list[${i}]}${optns_list[${i}]} "
    fi
  done

  final_opts="$(
    sed -E 's/(^ | $)//g' <<< "${exist_text} ${addon_opts}" 2> /dev/null
  )"

  __export_var "${flags_name}" "${final_opts}"
}


#
# aliases to __is_path_existing
#

function __is_path() { __is_path_existing "${1}"; }
function __is_path_real() { __is_path_existing "${1}"; }


#
# checks if file exists
#

function __is_path_existing() {
  [[ -d ${1} ]]
}


#
# checks if file exists, and is readable
#

function __is_path_readable() {
  __is_path_existing "${1}" && [[ -r ${1} ]]
}


#
# checks if path exists, is readable, and is writable
#

function __is_path_writable() {
  __is_path_readable "${1}" && [[ -w ${1} ]]
}


#
# alias to __is_file_existing
#

function __is_file() {
  __is_file_existing "${1}"
}


#
# checks if file exists
#

function __is_file_existing() {
  [[ -f ${1} ]]
}


#
# checks if file exists, and is readable
#

function __is_file_readable() {
  __is_file_existing "${1}" && [[ -r ${1} ]]
}


#
# checks if file exists, is readable, and is writable
#

function __is_file_writable() {
  __is_file_readable "${1}" && [[ -w ${1} ]]
}


#
# alias to __is_link_existing
#

function __is_link() {
  __is_link_existing "${1}"
}


#
# checks if link exists
#

function __is_link_existing() {
  [[ -h ${1} ]]
}


#
# checks if link exists, and is readable
#

function __is_link_readable() {
  __is_link_existing "${1}" && [[ -r ${1} ]]
}


#
# checks if link exists, is readable, and is writable
#

function __is_link_writable() {
  __is_link_readable "${1}" && [[ -w ${1} ]]
}


#
# checks if path already exists in PATH environment variable
#

function __has_var_cont() {
  grep -E "$(__expand_value "${2}")" <<< "${(P)1}" &> /dev/null
}


#
# checks if path already exists in PATH environment variable
#

function __has_env_path() {
  __has_var_cont PATH "(^|:)$(__expand_value "${1}")($|:)"
#  grep -E "(^|:)$(__expand_value "${1}")($|:)" <<< "${PATH}" &> /dev/null
}


#
# checks if path already exists in MANPATH environment variable
#

function __has_man_path() {
  __has_var_cont MANPATH "(^|:)$(__expand_value "${1}")($|:)"
}


#
# expand variable values
#

function __expand_value() {
  local -a values=("${@}")

  for v in "${(@v)values}"; do
    __out_line '%s' "${(e)v}"
  done
}


#
# get separator icon
#

function __get_sepr() {
  __get_ansi 'i:long-arrow-right' 's:dim'
  __get_ansi 's:reset'
}


#
# debug icon output list
# @TODO: remove
#

function __debug_out_icon_color_table() {
  local run2x='false'
  clear

  local break="\n  $(
    for i in $(seq 1 $((($(tput cols) / 2) - 1))); do
      printf -- '\e[37;2m\u2022\e[0m '
    done
  )\n\n"

  printf -- "${break}"

  for colr_name colr_code in "${(@kv)ANSI_COLOR_CODES_FG}"; do
    bg=49

    if ! __is_bool_t "${run2x}"; then
      printf -- '\t\t'

      echo -en "$(
        printf -- '\e[34m%29s\e[0m \e[37;2m \e[0m \e[94;1m%6s\e[0m \e[37;2m \e[0m ' "" ""
      )"
    fi

    if __is_bool_t "${run2x}"; then
      printf -- "$(
        printf -- '\e[37;2m|\e[0m'
#        printf -- ' \e[37;2m|\e[0m '
      )"
    fi

    if [[ ${colr_name} =~ black ]] || [[ ${colr_name} =~ dark-gray ]]; then
      bg=107
    fi

    printf -- "$(
      printf -- '\e[%s;%sm(%03d)\e[0m' \
        "${bg}" \
        "${colr_code}"  \
        "${colr_code}"
    )"

    run2x='true'
  done

  for colr_name colr_code in "${(@kv)ANSI_COLOR_CODES_BG}"; do
    fg=30

    if __is_bool_t "${run2x}"; then
      printf -- "$(
        printf -- '\e[37;2m|\e[0m'
#        printf -- ' \e[37;2m|\e[0m '
      )"
    fi

    if [[ ${colr_name} =~ black ]] || [[ ${colr_name} =~ dark-gray ]] || [[ ${colr_name} =~ default ]]; then
      fg=97
    fi

    printf -- "$(
      printf -- '\e[%s;%sm(%03d)\e[0m' \
        "${fg}" \
        "${colr_code}"  \
        "${colr_code}"
    )"

    run2x='true'
  done

  printf -- '\n'
  run2x='false'

  for colr_name colr_code in "${(@kv)ANSI_COLOR_CODES_FG}" "${(@kv)ANSI_COLOR_CODES_BG}"; do
    if ! __is_bool_t "${run2x}"; then
      printf -- '\t\t'

      echo -en "$(
        printf -- '\e[34m%29s\e[0m \e[37;2m \e[0m \e[94;1m%6s\e[0m \e[37;2m \e[0m ' "" ""
      )"
    fi

    if __is_bool_t "${run2x}"; then
      printf -- "$(
        printf -- '\e[37;2m|\e[0m'
#        printf -- ' \e[37;2m|\e[0m '
      )"
    fi

    printf -- "$(
      printf -- '\e[37;2m-----\e[0m'
    )"

    run2x='true'
  done

  printf -- '\n'

  for font_desc font_code in "${(@kv)ICON_CHAR_CODES_UTF}"; do
    run2x='false'

    printf -- '\t\t'

    echo -en "$(
      printf -- '\e[34m%29s\e[0m \e[37;2m%s\e[0m \e[94;1m\\\\u%4s\e[0m \e[37;2m\uf105\e[0m ' \
        "${font_desc}" \
        "$(__get_icon adn)" \
        "${font_code}"
    )"

    for colr_name colr_code in "${(@kv)ANSI_COLOR_CODES_FG}"; do
      bg=49

      if __is_bool_t "${run2x}"; then
        printf -- "$(
        printf -- '\e[37;2m|\e[0m'
#        printf -- ' \e[37;2m|\e[0m '
        )"
      fi

      if [[ ${colr_name} =~ black ]] || [[ ${colr_name} =~ dark-gray ]]; then
        bg=107
      fi

      printf -- "$(
        printf -- '\e[%s;%sm( %s )\e[0m' \
          "${bg}" \
          "${colr_code}"  \
          "\u${font_code}"
      )"

      run2x='true'
    done

    for colr_name colr_code in "${(@kv)ANSI_COLOR_CODES_BG}"; do
      fg=30

      if __is_bool_t "${run2x}"; then
        echo -en "$(
        printf -- '\e[37;2m|\e[0m'
#        printf -- ' \e[37;2m|\e[0m '
        )"
      fi

      if [[ ${colr_name} =~ black ]] || [[ ${colr_name} =~ dark-gray ]] || [[ ${colr_name} =~ default ]]; then
        fg=97
      fi

      printf -- "$(
        printf -- '\e[%s;%sm( %s )\e[0m' \
          "${fg}" \
          "${colr_code}"  \
          "\u${font_code}"
      )"

      run2x='true'
    done

    printf -- '\n'
  done

  printf -- "${break}"

  return
}


#
# alias command
#

function __alias_cmd() {
  local exp_name="$(__expand_value "${1}")"
  local exp_call="$(__expand_value "${2}")"

  if alias "${exp_name}"="${exp_call}" &> /dev/null; then
    __out_info 'Success aliasing command: %s %s "%s"' "${exp_name}" "$(__get_sepr)" "${exp_call}"
  else
    __out_warn 'Failure aliasing command: %s %s "%s"' "${exp_name}" "$(__get_sepr)" "${exp_call}"
  fi
}


#
# export variable
#

function __export_var() {
  local var_name="$(__expand_value "${1}")"
  local var_cont="$(__expand_value "${2:-}")"
  local var_conc="${var_cont}"
  local var_desc='assigned %d character string'
  local out_verb="${3:-true}"
  local var_srch="${4:-var_cont}"
  local var_size="${#var_cont}"
  local max_char=190

  if [[ ${#var_conc} -gt ${max_char} ]]; then
    var_conc="${var_cont:0:${max_char}} [$(__get_icon dot-mark-3x)]"
    grep "${var_cont}" <<< "${var_conc}" &> /dev/null \
      && var_conc="[$(__get_icon dot-mark-3x)] ${var_cont:(-${max_char})}"
  fi

  if __has_var_cont "${var_name}" "(^|\s|:)${var_srch}($|\s|:)"; then
    __is_bool_t "${out_verb}" \
      && __std_debg 'Skipped defining env var' "${var_name}" "${var_conc}" 'already exists with matching contents'
    return 2
  fi

  if [[ -n ${var_cont} ]] && eval "$(__out_text 'export %s="%s"' "${var_name}" "${var_cont}")" &> /dev/null; then
    __is_bool_t "${out_verb}" \
      && __std_info 'Success defining env var' "${var_name}" "${var_conc}" 'assigned %d character string' "${var_size}"
    return 0
  fi

  if [[ -z ${var_cont} ]] && eval "$(__out_text 'export %s' "${var_name}")" &> /dev/null; then
    __is_bool_t "${out_verb}" \
      && __std_info 'Success defining env var' "${var_name}" '<null>' "${var_desc}" "${var_size}"
    return 0
  fi

  __is_bool_t "${out_verb}" \
    && __std_fail 'Failure defining env var' "${var_name}" "${var_conc:-<null>}" "${var_desc}" "${var_size}"
  return 1
}


#
# perform environment PATH variable configuration
#

function __run_maiden_calls_step() {
  for d c in "${(@kv)RUN_COMMAND_SETUPS}"; do
    local exp_desc="$(__expand_value "${d}")"
    local exp_call="$(__expand_value "${c}")"

    if eval "${exp_call}" &> /dev/null; then
      __out_info 'Success invoking cfg cmd: %s %s "%s"' "${exp_desc}" "$(__get_sepr)" "${exp_call}"
    else
      __out_fail 'Failure invoking cfg cmd: %s %s "%s"' "${exp_desc}" "$(__get_sepr)" "${exp_call}"
    fi
  done
}


#
# perform inclusion of all sourced files
#

function __run_source_files_step() {
  for name root in "${(@kv)ENV_GENERAL_SOURCES}"; do
    local exp_path="$(__expand_value "${root}/${name}")"

    if [[ ! -s "${exp_path}" ]]; then
      __std_warn 'Failure sourcing scripts' "${name}" "${exp_path}" 'file does not exist on disk'
      return 1
    fi

    if ! . "${exp_path}" &> /dev/null; then
      __std_fail 'Failure sourcing scripts' "${name}" "${exp_path}" 'returned non-zero status code'
      return 2
    fi

    __std_info 'Success sourcing scripts' "${name}" "${exp_path}" 'invoked %d line script' "$(
      wc -l "${exp_path}" | awk '{print $1}'
    )"
  done
}

function __cleans_path_variable() {
  sed -E 's/(^:|:$)//g' <<< "${1}"
}

function __export_path_variable() {
  local priority="${2:-true}"
  local exp_path="$(__expand_value "${1}")"
  local var_path="${PATH}"
  local returned

  if ! __is_path_real "${exp_path}"; then
    __std_debg 'Skipped defining env var' 'PATH' "${exp_path}" 'directory does not exist on disk'
    return
  fi

#  if __has_env_path "${exp_path}"; then
#    __std_debg 'Skipped defining env var' 'PATH' "${exp_path}" 'directory already registered'
#    return
#  fi

  __is_bool_t "${priority}" \
    && var_path="$(__cleans_path_variable "${exp_path}:${var_path}")" \
    || var_path="$(__cleans_path_variable "${var_path}:${exp_path}")"

  __export_var PATH "${var_path}" false "${exp_path}"; returned=$?

  if __is_status_okay ${returned}; then
    __std_info 'Success defining env var' 'PATH' "${exp_path}" '%sfixed to existing contents' "$(
      __is_bool_t "${priority}" && __out_text 'pre' || __out_text 'post'
    )"
    return
  fi

  if __is_status_code ${returned} 2; then
    __std_debg 'Skipped defining env var' 'PATH' "${exp_path}" 'directory already registered'
    return
  fi

  __std_warn 'Failure defining env var' 'PATH' "${exp_path}" 'unable to %sfix to existing contents' "$(
    __is_bool_t "${priority}" && __out_text 'pre' || __out_text 'post'
  )"
}


#
# perform environment PATH variable configuration
#

function __run_export_paths_step() {
  for p in ${(v)ENV_PATHS_PREF_ADDS}; do
    __export_path_variable "${p}" true
  done

  for p in ${(v)ENV_PATHS_POST_ADDS}; do
    __export_path_variable "${p}" false
  done
}


#
# handle setting up general purpose environment variables
#

function __run_export_manpg_step() {
  for p in "${(@v)ENV_MANPATH_CONFIG}"; do
    local exp_path="$(__expand_value "${p}")"

    if __has_man_path "${exp_path}"; then
      __std_debg 'Skipped defining env var' 'MANPATH' "${exp_path}" 'man path already registered'
    else
      __export_var MANPATH "$(sed -E 's/(^:|:$)//g' <<< "${exp_path}:${MANPATH}")"
    fi
  done
}


#
# handle setting up and exporting build-related environment variables
#

function __run_export_build_step() {
  __concat_flags_to_env_var ARCHFLAGS "${(@kv)BUILD_ARCHIT_FLAGS}"
  __concat_flags_to_env_var   LDFLAGS "${(@kv)BUILD_LINKER_FLAGS}"
  __concat_flags_to_env_var  CPPFLAGS "${(@kv)BUILD_CMPLER_FLAGS}"
}


#
# handle setting up general purpose environment variables
#

function __run_export_genrl_step() {
  for n c in "${(@kv)ENV_GENERAL_EXPORTS}"; do
    __export_var "${n}" "${c}"
  done
}


#
# handle assigning aliases
#

function __run_aliase_cmnds_step() {
  for n c in "${(@kv)ENV_GENERAL_ALIASES}"; do
    __alias_cmd "${n}" "${c}"
  done
}


#
# output non-debug script beginning information
#

function __run_output_begin_info() {
  __is_debug && \
    return

  __out_line
  __out_text '%s' "$(
    __get_ansi "t:$(
      __out_text '%s%s' "${OUT_NORMAL_INIT_TXT}" "${OUT_NORMAL_SEPS_TXT}"
    )" 's:rst' 'F:246' 'b:def'
  )"
}


#
# output non-debug script completed information
#

function __run_output_close_info() {
  local clr_def='s:rst F:234 b:def'

  __is_debug && \
    return

  local run_exit_ret="${1:-0}"
  local len_init_msg="$((${#OUT_NORMAL_INIT_TXT} + ${#OUT_NORMAL_SEPS_TXT}))"
  local out_done_msg="$(
    __out_text '%s%s%s' \
      "$(
        __get_ansi ${clr_def} 't: '
      )" \
      "$(
        [[ ${run_exit_ret} -ne 0 ]] \
          && __get_ansi "t: ${OUT_NORMAL_FAIL_TXT} " 'B:52' 'F:9' 's:bold' \
          || __get_ansi "t: ${OUT_NORMAL_DONE_TXT} " 'B:22' 'F:10' 's:bold'
      )" \
      "$(
        __get_ansi ${clr_def} 't: '
      )"
  )"
  local raw_done_msg="$(sed 's/\x1b\[[0-9;]*m//g' <<< "${out_done_msg}")"
  local len_done_msg="${#raw_done_msg}"
  local out_time_sec="$(
    __out_text '%.03f' "$(
      bc <<< "$(__get_unix) - ${LOG_STARTUP_TIME_NS}"
    )"
  )"
  local len_time_sec="${#out_time_sec}"
  local out_desc_msg="${OUT_NORMAL_DESC_TXT}"
  local len_desc_msg="$((${#out_desc_msg} - 2))"
  #echo "[[${COLUMNS:-$(tput cols)} - 2 - $len_init_msg - $len_done_msg - $len_desc_msg - $len_time_sec]]"
  local len_empt_msg="$((${COLUMNS:-$(tput cols)} - 3 - len_init_msg - len_done_msg - len_desc_msg - len_time_sec))"

  if [[ ${len_empt_msg} -gt 0 ]]; then
    __out_line '%s%s%s%s%s' \
      "${out_done_msg}" \
      "$(__out_rept ' ' "${len_empt_msg}")" \
      "$(__get_ansi 't:(' 's:rst' 'F:232' 'b:def')" \
      "$(__get_ansi "t:$(__out_text "${out_desc_msg}" "${out_time_sec}")" 's:rst' 'F:234' 'b:def')" \
      "$(__get_ansi 't:)' 's:rst' 'F:232' 'b:def')"
  else
    __out_line '%s\n%s' \
      "${out_done_msg}" \
      "$(__get_ansi "t:$(__out_text "${${out_desc_msg:0:1}:u}${out_desc_msg:1}" "${out_time_sec}")" 's:rst' 'F:234' 'b:def')"
  fi

  __out_line
}

#
# define main function that handles setting up all custom configurations from this file
#

function __main() {
  reset
  __run_output_begin_info \
    && __run_maiden_calls_step \
    && __run_export_paths_step \
    && __run_export_manpg_step \
    && __run_export_build_step \
    && __run_export_genrl_step \
    && __run_aliase_cmnds_step \
    && __run_source_files_step
  __run_output_close_info "${?}"
}


#
## RUNNER CODE
#

__main


#exit
#for flag optn in ${(vk)BUILD_ARCHIT_FLAGS}; do
#  if ! is_cmd_opt_matched "${flag}" "${optn}" "${ARCHFLAGS}"; then
#    ARCHFLAGS+=" ${flag}${optn}";
#  fi
#done
#
#for flag optn in ${(vk)BUILD_LINKER_FLAGS}; do
#  if ! grep -E -- "${flag}${optn}($|\s)" <<< "${LDFLAGS:- }" &> /dev/null && [[ -d ${optn} ]]; then
#    LDFLAGS+=" ${flag}${optn}";
#  fi
#done
#
#for flag optn in ${(vk)BUILD_CMPLER_FLAGS}; do
#  if ! grep -E -- "${flag}${optn}($|\s)" <<< "${CPPFLAGS:- }" &> /dev/null && [[ -d ${optn} ]]; then
#    CPPFLAGS+=" ${flag}${optn}"
#  fi
#done
#
#export ARCHFLAGS="$(sed -E 's/(^ | $)//g' <<< "${ARCHFLAGS}")"
#export CPPFLAGS="$(sed -E 's/(^ | $)//g' <<< "${CPPFLAGS}")"
#export LDFLAGS="$(sed -E 's/(^ | $)//g' <<< "${LDFLAGS}")"
#
## setup aliases
#alias php-cs-fixer-v2="$(brew --prefix)/opt/php-cs-fixer@2/bin/php-cs-fixer"
#alias php-cs-fixer-v3="$(brew --prefix)/opt/php-cs-fixer/bin/php-cs-fixer"
#alias glances="sudo glances -1 2> /dev/null"
#alias zshconfig="${EDITOR} ~/.zshrc"
#alias ohmyzsh="${EDITOR} ~/.oh-my-zsh"
#alias ssh-twoface.systems="ssh -p 22100 rmf@twoface.systems"
#alias ssh-symba.systems="ssh rmf@symba.systems"
#alias ssh-src.run-"ssh rmf@src.run"
#
## source external resources
#for s in "${HOME}/.p10k.zsh" '$(brew --prefix)/opt/git-extras/share/git-extras/git-extras-completion.zsh'; do
#  [[ -f ${s} ]] && source "${s}"
#done
#
#
#  mkdir ~/.nvm
#  export NVM_DIR="$HOME/.nvm"
#  [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
#  [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
#  $NVM_DIR=${HOME}/.local/opt/nvm
