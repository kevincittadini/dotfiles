#!/bin/bash

function p {
    printf "\n\n\e[32m[[ $1 ]]\e[0m\n\n"
}

function install_composer() {
    EXPECTED_CHECKSUM="$(php -r 'copy("https://composer.github.io/installer.sig", "php://stdout");')"
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"

    if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]
    then
        >&2 echo 'ERROR: Invalid installer checksum'
        rm composer-setup.php
        exit 1
    fi

    php composer-setup.php --quiet
    rm composer-setup.php
    sudo mv composer.phar /usr/local/bin/composer
}

p "Adding Git Global Configs"
cp global_gitignore ~/.gitignore
cp global_gitconfig ~/.gitconfig
git config --global core.excludesfile ~/.gitignore

p "Installing Xcode Command Line Tools"
xcode-select -p &> /dev/null
if [ $? -ne 0 ]; then
  echo "Command Line Tools for Xcode not found. Installing from softwareupdate…"
  touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
  PROD=$(softwareupdate -l | grep "\*.*Command Line" | tail -n 1 | sed 's/^[^C]* //')
  softwareupdate -i "$PROD" --verbose;
else
  echo "Command Line Tools for Xcode have been installed."
fi

mkdir -p ~/.config

p "Installing Homebrew"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

p "Installing NVIM"
brew install neovim
cpdir -r local-config/nvim ~/.config/nvim

p "Installing ZSH"
brew install zsh

p "Installing OH MY ZSH"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cp zshrc ~/.zshrc
cp zshenv ~/.zshenv

p "Installing Power10k"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

p "Installing Tig"
brew install tig

p "Installing iTerm2"
brew install --cask iterm2

p "Installing Bat"
brew install bat

p "Installing PHP"
brew install php

p "Installing Composer"
install_composer

p "Installing Node"
brew install node
brew install nvm

p "Installing VSCode"
brew install --cask visual-studio-code

p "Install PHPStorm"
brew install --cask phpstorm

p "Installing Docker"
brew install --cask docker

p "Installing TypeScript"
npm install -g typescript typescript-language-server

p "Installing Postman"
brew install --cask postman
