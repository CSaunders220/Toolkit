#secure-ssh.sh
#author christopher s
#creates a new ssh user using $1 parameter
#adds a public key from the local repo or curled from the remote repo
#removes root's ability to ssh in

useradd -m -d /home/$1 -s /bin/bash $1
mkdir /home/$1/.ssh
cp /Toolkit/SYS265/linux/public-keys/id_rsa.pub /home/$1/.ssh/authorized_keys
chmod 700 /home/$1/.ssh
chmod 600 /home/$1/.ssh/authorized_keys
chown -R $1:$1 /home/$1/.ssh
