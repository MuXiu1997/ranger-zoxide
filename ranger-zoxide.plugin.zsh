# Add a `r` function to zsh that opens ranger either at the given directory or
# at the one zoxide suggests

# https://github.com/ranger/ranger/wiki/Integration-with-other-programs#changing-directories
ranger_cd() {
  temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
  ranger --choosedir="$temp_file" -- "${@:-$PWD}"
  if chosen_dir="$(cat -- "$temp_file")" && [ -n "$chosen_dir" ] && [ "$chosen_dir" != "$PWD" ]; then
    cd -- "$chosen_dir"
  fi
    rm -f -- "$temp_file"
}

r() {
  if [ "$1" != "" ]; then
    if [ -d "$1" ]; then
      ranger_cd "$1"
    else
      ranger_cd "$(zoxide query $1)"
    fi
  else
    ranger_cd
  fi
	return $?
}
