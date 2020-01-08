#!/bin/bash
sudo yum install wget -y
cd /usr/local/src
sudo wget "https://github.com/coreos/etcd/releases/download/v3.4.0/etcd-v3.4.0-linux-amd64.tar.gz"
sudo tar -xvf etcd-v3.4.0-linux-amd64.tar.gz

sudo mv etcd-v3.4.0-linux-amd64/etcd* /usr/local/bin/
sudo mkdir -p /etc/etcd /var/lib/etcd



export INTERNAL_IP=$(curl -s -H 'Metadata-Flavor: Google' http://metadata.google.internal/computeMetadata/v1/instance/network-interfaces/0/ip)
export ETCD_NAME=$(hostname -s)



sudo -E bash -c 'cat << EOF > /etc/systemd/system/etcd.service
[Unit]
Description=etcd
Documentation=https://github.com/coreos

[Service]
Type=notify
ExecStart=/usr/local/bin/etcd \\
  --name $ETCD_NAME \\
  --initial-advertise-peer-urls http://$INTERNAL_IP:2380 \\
  --listen-peer-urls http://$INTERNAL_IP:2380 \\
  --listen-client-urls http://$INTERNAL_IP:2379,http://127.0.0.1:2379 \\
  --advertise-client-urls http://$INTERNAL_IP:2379 \\
  --discovery ${discoveryURL} \\
  --data-dir=/var/lib/etcd
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd.service