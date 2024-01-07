#!/bin/bash
set -e
echo "#!/bin/bash" > install_extensions.sh
code --list-extensions | while read line; do echo "code --install-extension $line"; done >> install_extensions.sh