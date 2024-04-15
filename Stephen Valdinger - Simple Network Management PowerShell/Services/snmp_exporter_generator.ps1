#Gonna need docker
choco install docker-desktop -y

#Grab the repo
git clone https://github.com/prometheus/snmp_exporter.git
cd snmp_exporter
git checkout v0.25.0

#Get all the default MIBs
cd generator
sudo apt update && sudo apt install -y make
make mibs

#PUT TOGETHER A GENERATOR.YML HERE

#Build the docker image and generate an exporter config (drop )
sudo docker build -t snmp-generator .
sudo docker run --rm -ti -v "${PWD}:/opt/" snmp-generator generate
