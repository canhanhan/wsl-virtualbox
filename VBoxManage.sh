#!/bin/bash

wslroot=$(wslpath $(reg.exe query "HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss" /s /v BasePath | awk 'BEGIN { FS = "[ \t]+" } ; /BasePath/{print $4}' | tr -d "[:cntrl:]"))
is_next_path=0
args=()
for argument; do
  if [ "$argument" = '--medium' ]; then
    is_next_path=1
  elif [ $is_next_path = 1 ]; then
    if [[ $argument == /tmp/* ]]; then
      argument="$wslroot/rootfs$argument"
    fi
    argument=$(wslpath -w "$argument")
    is_next_path=0
  fi
  args+=("\"$argument\"")
done

echo "${args[@]}" | xargs /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe | sed -r '/[A-Za-z]:\\.*$/{h; s/(.*)([A-Za-z]:\\.*)$/\2/; s/(.+)/wslpath "\1"/e; H; x; s/(([A-Za-z]:\\.*)\n(.+))/\3/ }'
