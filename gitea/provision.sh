sudo -i
# Update packages
apt-get update
apt-get upgrade -y
apt update -y

# Install necessary tools
apt-get install -y git wget unzip

#Download sqlite 
sudo apt-get install sqlite3 --fix-missing

# Download Gitea
wget -O /usr/local/bin/gitea https://dl.gitea.io/gitea/1.21.0/gitea-1.21.0-linux-amd64
chmod +x /usr/local/bin/gitea

# Create Gitea user and directories
adduser --system --shell /bin/bash --gecos 'Gitea user' --group --disabled-password --home /home/git git
mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/

mkdir -p /etc/gitea
cat <<EOF > /etc/gitea/app.ini
[database]
DB_TYPE = sqlite3
PATH = data/gitea.db

[actions]
ENABLED = true

[repository]
DEFAULT_REPO_UNITS = repo.code,repo.issues,repo.pulls,repo.releases,repo.wiki,repo.actions,repo.projects,repo.packages
EOF

# Set permissions for app.ini
chown -R git:git /etc/gitea
chmod -R 750 /etc/gitea

# Create Gitea service
cat <<EOF > /etc/systemd/system/gitea.service
[Unit]
Description=Gitea
After=syslog.target
After=network.target
Requires=network.target

[Service]
RestartSec=2s
Type=simple
User=git
Group=git
WorkingDirectory=/var/lib/gitea/
ExecStart=/usr/local/bin/gitea web --config /etc/gitea/app.ini
Restart=always
Environment=USER=git HOME=/home/git GITEA_WORK_DIR=/var/lib/gitea

[Install]
WantedBy=multi-user.target
EOF

# Start Gitea service
systemctl daemon-reload
systemctl enable gitea
systemctl start gitea

# setting up docker for runner
curl -fsSL https://get.docker.com | bash
sudo apt install docker-compose

# docker run --entrypoint="" --rm -it docker.io/gitea/act_runner:latest act_runner generate-config > config.yaml

# docker run -v $PWD/config.yaml:/config.yaml -e CONFIG_FILE=/config.yaml -e GITEA_INSTANCE_URL="http://192.168.33.102:3000" -e GITEA_RUNNER_REGISTRATION_TOKEN="dED48rqW4wqD9BAilKp5D5FZd0lQGj1l2925zygv" -e GITEA_RUNNER_NAME="runner" -v /var/run/docker.sock:/var/run/docker.sock --name runner -d gitea/act_runner:nightly
