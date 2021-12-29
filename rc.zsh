
##
## ZSHRC
##

#
# environment debugger
#

ENV_TERM_TYPE="$(basename "${SHELL:-zsh}")"
ENV_DATE_TIME="$(
  printf '%s-%010d.%09d' $(
    r="${RANDOM}${RANDOM: -3}${RANDOM:2}${RANDOM: -4:2}${RANDOM:1:4}"
    /usr/local/bin/gdate '+date %s %N' \
      || date '+date %s' \
      || printf 'rand %03d%02d%02d%03d %02d%03d%02d%02d' \
        "${r:0:3}"   "${r:3:2}" "${r: -2}" "${r: -7:-4}" \
        "${r: -5:2}" "${r:6:3}" "${r: -2}" "${r: -3:-1}"
  ) 2> /dev/null
)"

ENV_HIST_ROOT="${HOME}/"
ENV_HIST_FILE="${ENV_HIST_ROOT}.zsh-env-log-files.list"

ENV_LOGS_ROOT="${TMPDIR:-${HOME}/.tmp/}"
ENV_LOGS_FILE="$(
  printf -- \
    '%s%s-shell_zshrc-env_%s.log' \
    "${ENV_LOGS_ROOT}" \
    "${ENV_TERM_TYPE}" \
    "${ENV_DATE_TIME}" \
    2> /dev/null
)"

#for v in ENV_TERM_TYPE ENV_DATE_TIME ENV_HIST_ROOT ENV_HIST_FILE ENV_LOGS_ROOT ENV_LOGS_FILE; do
#	printf '- [%s] => "%s"\n' "${v}" "${(P)v}"
#done

printf 'FILE: "%s"\n' "${ENV_LOGS_FILE}" \
  &> "${ENV_HIST_FILE}" \

printf '\n\n## [%s:ENV-VARIABLES]\n\n' "${ENV_DATE_TIME}" \
  &> "${ENV_LOGS_FILE}"

env &> "${ENV_LOGS_FILE}"

printf '\n\n## [%s:ALL-FUNCTIONS]\n\n' "${ENV_DATE_TIME}" \
  &> "${ENV_LOGS_FILE}"

print -l ${(ok)functions} \
  &> "${ENV_LOGS_FILE}"

printf '\n\n## [%s:ALL-VARIABLES]\n\n' "${ENV_DATE_TIME}" \
  &> "${ENV_LOGS_FILE}"

set \
  | sort -h \
  | sed -E 's/^([^=]+)=(.*)$/- "\1" => [\2]/' \
  | sed -E 's/^([^-=]+)$/- "\1" => NULL/' \
  | sed -E 's/^-/VAR:/' \
    &> "${ENV_LOGS_FILE}"

#
# configure oh-my-zsh
#

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE="awesome-patched"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="false"

# Uncomment the following line to automatically update without prompting.
DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=7

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="false"

# Uncomment the following line to disable colors in ls.
DISABLE_LS_COLORS="false"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="false"

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-dd-mm"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(alias-finder aliases ansible autojump battery bgnotify brew colored-man-pages colorize command-not-found composer cp extract emoji emoji-clock git git-auto-fetch git-extras git-lfs git-prompt gitignore gnu-utils gpg-agent history osx pip pipenv pylint python ruby sudo sublime sublime-merge xcode zsh-lint zsh-autosuggestions zsh-syntax-highlighting)

#
# source oh-my-zsh
#

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

ZSH_HIGHLIGHT_PATTERNS+=('rm -rf *' 'fg=white,bold,bg=red')
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor)

