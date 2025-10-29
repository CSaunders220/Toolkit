#Script created by GMCyber, all creation credits go to the owner of GMCyber
#Original script found here: https://github.com/gmcyber/480share/blob/master/hyperv-ubuntu-sealer.sh
#!/bin/sh
#script to prepare ubuntu desktop vm for cloning
apt-get dist-upgrade

#open ssh
apt-get install -y linux-tools-virtual linux-cloud-tools-virtual
cat /dev/null > /var/log/wtmp 
cat /dev/null > /var/log/lastlog 
rm -rf /tmp/*
rm -rf /var/tmp/*
rm -f /etc/ssh/ssh_host*
rm -f /etc/udev/rules.d/70-persistent-net.rules
cat <<EOL | sudo tee /etc/rc.local
#!/bin/sh -e
test -f /etc/ssh/ssh_host_dsa_key || dpkg-reconfigure openssh-server
exit 0
EOL
echo ubuntu > /etc/hostname
apt-get clean
history -c
history -w
chmod +x /etc/rc.local
systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
sudo apt autoremove -y
#truncate the machine id to avoid duplicate dhcp
echo > /etc/machine-id

echo "remove git repo and then issue a shutdown - h now"
