#!/bin/bash
sudo -u ec2-user -i <<'EOF'

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install 16

EOF
