set -e
set -x

# NPM commands
ALEX=$(which alex || true)
# Delete 'alex' if it is not in a node_modules directory,
# which means it is ghc-alex.
if [[ -n "$ALEX" && "${ALEX/node_modules/}" == "${ALEX}" ]]; then
  echo "Removing $ALEX"
  sudo rm -rf $ALEX
fi
npm install
npm list --depth=0

# GO commands
go get -u github.com/golang/lint/golint
go get -u golang.org/x/tools/cmd/goimports
go get -u sourcegraph.com/sqs/goreturns
go get -u golang.org/x/tools/cmd/gotype
go get -u github.com/kisielk/errcheck
go get -u github.com/BurntSushi/toml/cmd/tomlv

# Ruby commands
bundle install --path=vendor/bundle --binstubs=vendor/bin --jobs=8 --retry=3

# Dart Lint commands
if ! dartanalyzer -v &> /dev/null; then
  wget -nc -O ~/dart-sdk.zip https://storage.googleapis.com/dart-archive/channels/stable/release/1.14.2/sdk/dartsdk-linux-x64-release.zip
  unzip -n ~/dart-sdk.zip -d ~/
fi

# VHDL Bakalint Installation
if [ ! -e ~/bakalint-0.4.0/bakalint.pl ]; then
  wget "http://downloads.sourceforge.net/project/fpgalibre/bakalint/0.4.0/bakalint-0.4.0.tar.gz?r=https%3A%2F%2Fsourceforge.net%2Fprojects%2Ffpgalibre%2Ffiles%2Fbakalint%2F0.4.0%2F&ts=1461844926&use_mirror=netcologne" -O ~/bl.tar.gz
  tar xf ~/bl.tar.gz -C ~/
fi

# elm-format Installation
if [ ! -e ~/elm-format-0.18/elm-format ]; then
  mkdir -p ~/elm-format-0.18
  curl -fsSL -o elm-format.tgz https://github.com/avh4/elm-format/releases/download/0.5.2-alpha/elm-format-0.17-0.5.2-alpha-linux-x64.tgz
  tar -xvzf elm-format.tgz -C ~/elm-format-0.18
fi

# Julia commands
julia -e "Pkg.add(\"Lint\")"

# Lua commands
luarocks install --local --deps-mode=none luacheck

# PHPMD installation
if [ ! -e ~/.local/bin/phpmd ]; then
  PHPMD='http://static.phpmd.org/php/latest/phpmd.phar'
  mkdir -p ~/.local/bin
  curl -fsSL -o  ~/.local/bin/phpmd "$PHPMD"
  chmod +x ~/.local/bin/phpmd
fi

# Change environment for flawfinder from python to python2
if [ ! -e ~/.local/bin/flawfinder ]; then
  cp /usr/bin/flawfinder ~/.local/bin/flawfinder
  sed -i '1s/.*/#!\/usr\/bin\/env python2/' ~/.local/bin/flawfinder
  chmod +x ~/.local/bin/flawfinder
fi
