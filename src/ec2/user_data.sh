#!/bin/bash
sudo -u ec2-user -i <<'EOF'

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 16

mkdir abp
cd abp

git clone https://github.com/carlosmn25/ABP-PyGITIC.git
cd ABP-PyGITIC
git checkout origin/carlos
git switch carlos

cd src/ec2/statistics-webpage 
npm install

node index.js
EOF
