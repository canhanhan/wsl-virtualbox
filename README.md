# wsl-virtualbox
VBoxManage wrapper to use Virtualbox from WSL for Packer. This is very experimental and may cause issues. Use it in your own risk.

## Installation
```
sudo su
mkdir -p /usr/local/bin
wget -O /usr/local/bin/VBoxManage.sh https://raw.githubusercontent.com/finarfin/wsl-virtualbox/master/VBoxManage.sh
chmod +x /usr/local/bin/VBoxManage.sh
ln -s /usr/local/bin/VBoxManage.sh /usr/bin/VBoxManage
exit
```

## Validate
```VBoxManage --version```

## Usage
No additional changes are required. You can use Packer's Virtualbox builders as usual.
