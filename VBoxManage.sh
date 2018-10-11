#!/bin/bash

# Get path for WSL storage
wslroot=$(wslpath $(reg.exe query "HKCU\Software\Microsoft\Windows\CurrentVersion\Lxss" /s /v BasePath | awk 'BEGIN { FS = "[ \t]+" } ; /BasePath/{print $4}' | tr -d "[:cntrl:]"))

# Initialize defaults
is_next_path=0
args=()

for argument; do
  # If the current argument is --medium expect path of the medium in next argument
  if [ "$argument" = '--medium' ]; then
    is_next_path=1
  elif [ $is_next_path = 1 ]; then
    # Packer tries to create floppy in the linux /tmp folder which is not representable in Windows. Replace it with direct storage path
    if [[ $argument == /tmp/* ]]; then
      argument="$wslroot/rootfs$argument"
    fi
    # Convert WSL paths to Windows path
    argument=$(wslpath -w "$argument")
    is_next_path=0
  fi

  args+=("\"$argument\"")
done

# Redirect to Windows VBoxManage and convert Windows paths back to WSL paths
echo "${args[@]}" | xargs /mnt/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe | sed -r '/[A-Za-z]:\\.*$/{h; s/(.*)([A-Za-z]:\\.*)$/\2/; s/(.+)/wslpath "\1"/e; H; x; s/(([A-Za-z]:\\.*)\n(.+))/\3/ }'

# /[A-Za-z]:\\.*$/ # Find lines that end with Windows paths
#  { # For each line
#    h; # Copy to hold storage
#    s/(.*)([A-Za-z]:\\.*)$/\2/; #Remove everything except the path
#    s/(.+)/wslpath "\1"/e; #Convert the path to WSL path
#    H; # Append to the hold storage
#    x; # Swap pattern storage with hold storage
#       # Pattern storage have 2 lines now:
#       #   SAMPLE C:\Windows\Temp
        #   /mnt/c/Windows/Temp
#    s/(([A-Za-z]:\\.*)\n(.+))/\3/ # Replace Windows path in the first line with the WSL path in the second line
#  }
