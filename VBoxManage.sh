#!/bin/bash

tmpdir=$(wslpath `cmd.exe /c echo %TEMP%`)
is_next_path=0
args=()
for argument; do
  if [ "$argument" = '--medium' ]; then
    is_next_path=1
  elif [ $is_next_path = 1 ]; then
    if [[ $argument == /tmp/* ]]; then
      folder="$(dirname "$argument")"
      cp -rf "$folder" "$tmpdir"
      argument="$tmpdir/${argument:5}"
    fi
    argument=$(wslpath -w "$argument")
    is_next_path=0
  fi
  args+=("\"$argument\"")
done

echo "${args[@]}" | xargs /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe | sed -r '/[A-Za-z]:\\.*$/{h; s/(.*)([A-Za-z]:\\.*)$/\2/; s/(.+)/wslpath "\1"/e; H; x; s/(([A-Za-z]:\\.*)\n(.+))/\3/ }'
