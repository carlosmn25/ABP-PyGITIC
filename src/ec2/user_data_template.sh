#!/bin/bash
sudo yum update && sudo yum install git python-pip -y && sudo -u ec2-user -i <<'EOF'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 16

mkdir ~/.aws
echo "

" > ~/.aws/credentials

mkdir abp
cd abp
git clone https://github.com/carlosmn25/ABP-PyGITIC.git && cd ABP-PyGITIC/ && git switch -c origin/jesus && git switch jesus &&
cd src/otros/importador-estaciones-carga/ && pip install numpy pandas boto3 && python3 data-importer.py && cd ../../ec2/statistics-webpage && npm i && npm -g install pm2
pm2 start index.js 
pm2 startup 
sudo env PATH=$PATH:/home/ec2-user/.nvm/versions/node/v16.20.0/bin /home/ec2-user/.nvm/versions/node/v16.20.0/lib/node_modules/pm2/bin/pm2 startup systemd -u ec2-user --hp /home/ec2-user 
pm2 save
EOF
