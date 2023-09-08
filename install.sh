#!/bin/bash

function p {
    printf "\n\n\e[32m[[ $1 ]]\e[0m\n\n"
}

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
cpdir -r oh-my-zsh ~/.oh-my-zsh
cp zshrc ~/.zshrc
cp zshenv ~/.zshenv

p "Installing Tig"
brew install tig

p "Installing iTerm2"
brew install --cask iterm2

p "Installing Bat"
brew install bat

p "Installing Node"
brew install node
brew install nvm

p "Installing VSCode"
brew install --cask visual-studio-code

p "Install PHPStorm"
brew install --cask phpstorm

p "Installing Docker"
brew install --cask docker
