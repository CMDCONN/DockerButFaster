#!/bin/bash


echo "=========================================="
echo "Welcome to the CMDCONN/DockerButFaster"
echo "=========================================="
echo ""

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root!" 1>&2
    echo
    exit 100
fi




# Remove packages that already exist
sudo apt remove $(dpkg --get-selections docker.io docker-compose docker-compose-v2 docker-doc podman-docker containerd runc | cut -f1)

# Add Docker's official GPG key:
sudo apt update
sudo apt install ca-certificates curl -y
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

sudo apt update


sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

if docker --version &> /dev/null; then
    echo "=========================================="
    echo "Docker has been successfully installed!"
    echo "=========================================="
else
    echo "error: Something went wrong..."
    echo "Check the source to see if something is wrong..."
fi


#!/bin/bash

read -p "Do you want to update user privileges? (y/n): " answer

if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "No changes made. Exiting."
    exit 0
fi

echo "Users on this system:"
# List real users (UID >= 1000, typically human accounts, excludes system users)
awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd

read -p "Which user would like to escalate to the docker group? " target_user

# Check the user actually exists
if ! id "$target_user" &>/dev/null; then
    echo "Error: user '$target_user' does not exist."
    exit 1
fi

sudo usermod -aG docker "$target_user"

if [ $? -eq 0 ]; then
    echo "all done: $target_user has been added to the docker group"
else
    echo "error: failed to update group membership for $target_user"
fi

echo
echo
echo
echo


echo "=========================================="
echo "Success! Thank you for using CMDCONN/DockerButFaster"
echo "=========================================="
