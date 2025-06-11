#!/bin/bash

# Run as root
set -e

USERNAME=${1:-"YOUR_USERNAME"}
USER_HOME=$(eval echo "~$USERNAME")
ZSH_CUSTOM="$USER_HOME/.oh-my-zsh/custom"

echo "📦 Installing Zsh and required packages..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  apt update && apt install -y zsh git curl fzf fonts-powerline
elif [[ "$OSTYPE" == "darwin"* ]]; then
  echo "Please run this on Linux with root privileges."
  exit 1
fi

echo "👤 Setting up Zsh for user: $USERNAME"

# Install Oh My Zsh as the user
sudo -u "$USERNAME" sh -c '
  export RUNZSH=no
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
'

echo "🔌 Installing plugins for $USERNAME..."

# Clone plugins into user's Oh My Zsh custom folder
sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
sudo -u "$USERNAME" git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

ZSHRC="$USER_HOME/.zshrc"

echo "⚙️ Configuring .zshrc for $USERNAME"

# Update zshrc theme and plugins
sudo -u "$USERNAME" sed -i.bak 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"
sudo -u "$USERNAME" sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions fzf)/' "$ZSHRC"

# Add manual sourcing for fzf and highlighting plugins
sudo -u "$USERNAME" bash -c "cat >> '$ZSHRC'" <<EOF

# Load plugins manually
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
EOF

echo "🔁 Changing shell to Zsh for $USERNAME"
chsh -s "$(which zsh)" "$USERNAME"

echo "✅ Done! Zsh is ready for user: $USERNAME. Restart their shell or run: su - $USERNAME"
