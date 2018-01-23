#!/bin/sh

# CONSUL SERVER

curl -O https://releases.hashicorp.com/consul/${consul_version}/consul_${consul_version}_linux_amd64.zip
unzip consul_${consul_version}_linux_amd64.zip   
rm -f consul_${consul_version}_linux_amd64.zip
sudo mv consul /usr/local/bin

echo "/usr/local/bin/consul agent -server -data-dir=/tmp/consul -client=0.0.0.0 -datacenter=${region} -bootstrap-expect=${desired_servers} -domain=${domain} -ui -retry-join "provider=aws tag_key=aws:autoscaling:groupName tag_value=${asg_name}" &" >> /etc/rc.local
/usr/local/bin/consul agent -server -data-dir=/tmp/consul -client=0.0.0.0 -datacenter=${region} -bootstrap-expect=${desired_servers} -domain=${domain} -ui -retry-join "provider=aws tag_key=aws:autoscaling:groupName tag_value=${asg_name}" &

# NOMAD SERVER

curl -O https://releases.hashicorp.com/nomad/${nomad_version}/nomad_${nomad_version}_linux_amd64.zip
unzip nomad_${nomad_version}_linux_amd64.zip   
rm -f nomad_${nomad_version}_linux_amd64.zip
sudo mv nomad /usr/local/bin
sudo mkdir /etc/nomad.d
mkdir /tmp/nomad

sudo cat <<EOF > /etc/nomad.d/server.hcl
datacenter = "${region}"
log_level = "DEBUG"
data_dir = "/tmp/nomad"

consul {
    # The address to the Consul agent.
    address = "127.0.0.1:8500"

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
server {
    enabled            = true
    bootstrap_expect   = ${desired_servers}
    rejoin_after_leave = true
}
client {
    enabled = false
}
EOF

echo "/usr/local/bin/nomad agent -config=/etc/nomad.d/server.hcl &" >> /etc/rc.local
/usr/local/bin/nomad agent -config=/etc/nomad.d/server.hcl &
