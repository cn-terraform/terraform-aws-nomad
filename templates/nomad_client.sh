#!/bin/sh
sudo yum update -y
sudo yum install -y docker
sudo groupadd docker
sudo usermod -aG docker ec2-user

curl -O https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip
unzip nomad_${nomad_version}_linux_amd64.zip   
rm -f nomad_${nomad_version}_linux_amd64.zip
sudo mv nomad /usr/local/bin
sudo mkdir /etc/nomad.d
mkdir /tmp/nomad
sudo cat <<EOF > /etc/nomad.d/client.hcl
datacenter = "${region}"
log_level = "DEBUG"
data_dir = "/tmp/nomad"

consul {
    # The address to the Consul agent.
    address = "${consul_address}"

    # The service name to register the server and client with Consul.
    server_service_name = "nomad"
    client_service_name = "nomad-client"

    # Enables automatically registering the services.
    auto_advertise = true

    # Enabling the server and client to bootstrap using Consul.
    server_auto_join = true
    client_auto_join = true
}
telemetry {
    publish_allocation_metrics = true
    publish_node_metrics       = true
}
client {
  enabled = true
}
server {
  enabled = false
}
EOF

echo "/usr/local/bin/nomad agent -config=/etc/nomad.d/client.hcl &" >> /etc/rc.local
/usr/local/bin/nomad agent -config=/etc/nomad.d/client.hcl &
