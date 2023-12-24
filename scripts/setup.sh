#!/bin/sh

add_to_zsh_rc() {
	(
		echo
		echo "$1"
		echo
	) >>~/.zshrc
}

PROJECTS_DIR="projects"
mkdir -p "$HOME/$PROJECTS_DIR"

apt update
apt upgrade -y

# tools
apt install build-essential zip unzip git curl exa shellcheck jq -y

# install zsh
apt install zsh -y

# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# set default shell to zsh
chsh -s "$(which zsh)"

# export projects directory in .zshrc
add_to_zsh_rc "export PROJECTS_DIR=$PROJECTS_DIR"

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$HOME"/.oh-my-zsh/custom/themes/powerlevel10k
sed -i 's#robbyrussell#powerlevel10k/powerlevel10k#' ~/.zshrc

# install git if needed and configure
git config --global user.name "Dylan Hamersztein"
git config --global user.email "dylanhamersztein@gmail.com"

# github cli
apt install gh -y
gh auth login

# install brew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add brew to path
add_to_zsh_rc 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"'
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install some brew packages for astrovim
brew install neovim ripgrep lazygit tree-sitter

# install AstroNvim
gh repo clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim -- --depth 1

# install my AstroNvim config
gh repo clone dylanhamersztein/astrovim-configuration ~/.config/nvim/lua/user

# setup neovim headlessly
nvim --headless +q

# clone some of my repos
gh repo clone dylanhamersztein/utils "$HOME/$PROJECTS_DIR"
gh repo clone dylanhamersztein/diente-de-leon-website "$HOME/$PROJECTS_DIR"
gh repo clone dylanhamersztein/flag-guessing-game "$HOME/$PROJECTS_DIR"

# install nvm and node
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo 'export NVM_DIR="$HOME/.nvm"' >>~/.zshrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm' >>~/.zshrc
echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion' >>~/.zshrc

/bin/zsh -c 'nvm install node'
/bin/zsh -c 'npm i -g pnpm'
/bin/zsh -c 'pnpm i -g prettier tree-sitter-cli'

# set up aliases
add_to_zsh_rc "source ~/$PROJECTS_DIR/utils/.aliases"

# install sdkman and java 21
curl -s "https://get.sdkman.io" | bash
. "$HOME/.sdkman/bin/sdkman-init.sh"

sdk install java 21.0.1-amzn

zsh
