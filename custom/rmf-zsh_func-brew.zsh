
return

zmodload -F zsh/stat b:zstat

function brew-resolve-package-file() {
  emulate zsh
  setopt interactivecomments

  local    c=0

  local -a cmd_call_provided_args=("${@}")
  local -a cmd_call_provided_opts=()
  local -a cmd_call_provided_objs=()

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
  local    exe_call_file_path_brw="$("${exe_call_file_path_cmd}" -v brew)"
  local    cmd_call_file_name_brw="$(basename "${exe_call_file_path_brw}")"

  if [[ -z ${exe_call_file_path_brw} ]] || ! "${exe_call_file_path_brw}" --version &> /dev/null; then
    printf -- '%s [error] Could not locate a Homebrew executable in your PATH! See "https://brew.sh/" to install...' \
      "$(date +%s)"
    exit 10
  fi

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
        if ! ${exe_call_file_path_man} "${cmd_call_file_name_brw}" 2> /dev/null; then
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
