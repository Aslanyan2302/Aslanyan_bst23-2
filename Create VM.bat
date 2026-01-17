@echo off
chcp 65001 > nul
setlocal

set "VBOX=C:\Program Files\Oracle\VirtualBox\VBoxManage.exe"
set "VM=DevOps-Ubuntu-VM"
set "ISO=C:\ISOs\ubuntu-22.04.5-desktop-amd64.iso"

"%VBOX%" controlvm "%VM%" poweroff >nul 2>nul
"%VBOX%" unregistervm "%VM%" --delete --delete-all >nul 2>nul

"%VBOX%" createvm --name "%VM%" --ostype "Ubuntu_64" --register >nul
"%VBOX%" modifyvm "%VM%" --memory 4096 --cpus 2 --vram 128 --ioapic on --graphicscontroller vmsvga >nul
"%VBOX%" createmedium disk --filename "C:\VirtualBoxVMs\%VM%.vdi" --size 20480 --format VDI >nul
"%VBOX%" storagectl "%VM%" --name "SATA" --add sata --controller IntelAhci >nul
"%VBOX%" storageattach "%VM%" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\VirtualBoxVMs\%VM%.vdi" >nul
"%VBOX%" storagectl "%VM%" --name "IDE" --add ide >nul
"%VBOX%" storageattach "%VM%" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "%ISO%" >nul
"%VBOX%" modifyvm "%VM%" --nic1 nat --boot1 dvd --boot2 disk --natpf1 "ssh,tcp,,2222,,22" >nul
"%VBOX%" startvm "%VM%" >nul

exit