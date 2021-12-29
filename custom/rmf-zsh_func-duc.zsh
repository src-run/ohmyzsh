

return

zmodload -F zsh/stat b:zstat

function duc() {
  emulate zsh
  setopt no_nomatch interactivecomments # no_nomatch is necessary, to prevent error in "do .* *" if there are no dotfiles

  local    c=0
  local    a
  local    i

  local -a cmd_call_provided_args=("${@}")
  local -a cmd_call_provided_opts=()
  local -a cmd_call_provided_objs=()

  local -A obj_exts_color_mapping=()
  local    obj_item_color_esc_seq
  local    def_list_color_esc_var='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.webp=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36'
  local    use_list_color_esc_seq="${LS_COLORS:-${$(2> /dev/null (
    dircolors -b \
      | head -n1 \
      | sed -E "s/LS_COLORS='([^']+):?';/\0/"
  )):-${def_list_color_esc_var}}}"

  local    exe_call_file_path_cmd="$(command -v command || printf -- '%s' 'command')"
  local    exe_call_file_path_nct="$("${exe_call_file_path_cmd}" -v nocorrect)"
  local    exe_call_file_path_clr="$("${exe_call_file_path_cmd}" -v colored)"
  local    exe_call_file_path_man="$(
    printf -- '%s "%s" "%s" "man"' \
      "${exe_call_file_path_nct:-NULL-NCT-EXEC}" \
      "${exe_call_file_path_clr:-NULL-CLR-EXEC}" \
      "${exe_call_file_path_cmd:-NULL-CMD-EXEC}" \
        | sed -E 's/\s?"NULL-(NCT|CLR|CMD)-EXEC"\s//g'
  )"
  local    exe_call_file_path_gdu="$("${exe_call_file_path_cmd}" -v gdu || "${exe_call_file_path_cmd}" -v du)"
  local    cmd_call_file_name_gdu="$(basename "${exe_call_file_path_gdu}")"

  for a in "${(v)cmd_call_provided_args}"; do
    printf 'ARG[%s]\n' "${a}"
  done

  for a in ${(v)cmd_call_provided_args}; do
    if [[ ${c} -gt 0 ]]; then
      ((c--))
      continue
    fi

    case "${a}" in
      --help)
        if ! ${exe_call_file_path_man} "${cmd_call_file_name_gdu}" 2> /dev/null; then
          ${exe_call_file_path_gdu} --help
        fi

        return ${?}
      ;;
      --version)
      -d depth) # Display an entry for all files and directories depth directories deep.)
      -I mask) # Ignore files and directories matching the specified mask.)
      -c) # grand total on last line as "<int> total" [use "head -n-1" to remove and "tail -n1" to get value])
      -k) # Display block counts in 1024-byte (1-Kbyte) blocks.)
      -m) # Display block counts in 1048576-byte (1-Mbyte) blocks.)
      -g) # Display block counts in 1073741824-byte (1-Gbyte) blocks.)
      -h) # "Human-readable" output.  Use unit suffixes: Byte, Kilobyte, Megabyte, Gigabyte, Terabyte and Petabyte.)

      -P) # No symbolic links are followed. This is the default.
      -L) # Symbolic links on the command line and in file hierarchies are followed.)

      -a) # Display an entry for each file in a file hierarchy)
      -s) # Display an entry for each specified file. Equivalent to "-d 0")
      -x) # File system mount points are not traversed.)
        ;;
    esac
  done

  return

  for i (${(s.:.)use_list_color_esc_seq}) { # split $use_list_color_esc_seq (containing $LS_COLORS formatted string) at ":"

    local -a ls_colors_elm_set=(
      ${(s:=:)i}
    ) # split every entry at "="

    obj_exts_color_mapping+=(
      ${${ls_colors_elm_set[1]}/*.}
      ${ls_colors_elm_set[2]}
    ) # load every entry into the associative array $obj_exts_color_mapping

  }

  for v in obj_item_color_esc_seq obj_exts_color_mapping use_list_color_esc_seq; do
    printf 'VARIABLE[%s](%s)="%s"\n' "${v}" "${(t)${(P)v}}" "${(P)v}"
  done

  duout=$(du -sh .* * 2> /dev/null | grep -v '^0' | sort -hr)
  for i (${(f)duout}) {                           # split output of "du" at newlines
    printf -- ''
    local -a ls_colors_elm_set=(${(ps:\t:)i})                          # split every entry at \t
    zstat -s +mode -A atype ${ls_colors_elm_set[2]}           # determine mode (e.g. "drwx------") of file ${ls_colors_elm_set[2]}
    case ${${atype[1]}[1]} in                     # ${${atype[1]}[1]} is the first character of the file mode
      b)   obj_item_color_esc_seq=$obj_exts_color_mapping[bd] ;;
      c|C) obj_item_color_esc_seq=$obj_exts_color_mapping[cd] ;;
      d)   obj_item_color_esc_seq=$obj_exts_color_mapping[di] ;;
      l)   obj_item_color_esc_seq=$obj_exts_color_mapping[ln] ;;
      p)   obj_item_color_esc_seq=$obj_exts_color_mapping[pi] ;;
      s)   obj_item_color_esc_seq=$obj_exts_color_mapping[so] ;;
      -)   obj_item_color_esc_seq=${obj_exts_color_mapping[${${ls_colors_elm_set[2]}:e}]};      # ${${ls_colors_elm_set[2]}:e} is the current file extention
           [[ -z $obj_item_color_esc_seq ]] && obj_item_color_esc_seq=$obj_exts_color_mapping[fi]   # unrecognized extention
           [[ -z $obj_item_color_esc_seq ]] && obj_item_color_esc_seq=00            # sometimes "fi" isn't set in $LS_COLORS, so fall back to normal color
           ;;
      *)   obj_item_color_esc_seq=00 ;;
    esac
    print -n -- "${ls_colors_elm_set[1]}\t"        # print size (taken from du output)
    print -n "\\e[4${obj_item_color_esc_seq}m"         # activate color
    print -n ${ls_colors_elm_set[2]}               # print file name
    print "\\e[0m"                     # deactivate color
  }
}
