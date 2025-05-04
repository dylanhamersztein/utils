#!/bin/bash

PROJECTS_DIR="projects"
mkdir -p "$HOME/$PROJECTS_DIR"

apt-get update
apt-get upgrade -y

# tools
apt-get install \
	build-essential \
	zip \
	unzip \
	git \
	shellcheck \
	jq \
	-y

# configure git
git config --global user.name "Dylan Hamersztein"
git config --global user.email "dylanhamersztein@gmail.com"

# github cli
apt-get install gh -y
gh auth login --web
gh auth setup-git

# clone utils repo first because it's needed early
gh repo clone dylanhamersztein/utils "$HOME/$PROJECTS_DIR"

# install zsh
apt-get install zsh -y

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# set default shell to zsh
chsh -s "$(which zsh)"

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k

# install brew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add brew to path
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install some brew packages for astrovim
brew install neovim ripgrep lazygit tree-sitter eza bat fzf

# install my AstroNvim config
gh repo clone dylanhamersztein/nvim-configuration ~/.config/nvim

# setup neovim headlessly
nvim --headless +q

# clone some of my repos
gh repo clone dylanhamersztein/diente-de-leon-website "$HOME/$PROJECTS_DIR"
gh repo clone dylanhamersztein/flag-guessing-game "$HOME/$PROJECTS_DIR"
gh repo clone dylanhamersztein/klox "$HOME/$PROJECTS_DIR"

# install tmux
gh repo clone tmux-plugins/tpm ~/.tmux/plugins/tpm

# link tmux configuration file to the one in this repo, removing the existing file if it exists
ln -sf ~/$PROJECTS_DIR/utils/.tmux.conf ~/.tmux.conf

# install fnm and node
curl -o- https://raw.githubusercontent.com/Schniz/fnm/master/.ci/install.sh | bash

PATH="/home/dylan/.local/share/fnm:$PATH"
eval "$(fnm env)"

fnm install v20.12.2
npm i -g pnpm yarn
pnpm setup
pnpm i -g prettier tree-sitter-cli

# install sdkman and java 21
curl -s "https://get.sdkman.io" | bash
. "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 21.0.1-amzn

# link .zshrc in root to the file in this project, removing the existing .zshrc if it exists
ln -sf ~/PROJECTS_DIR/utils/.zshrc ~/.zshrc

# link .aliases in root directory to the file in this repo, removing the existing file if it exists
ln -sf ~/PROJECTS_DIR/utils/.aliases ~/.aliases

zsh
