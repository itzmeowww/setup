set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Log
info() { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${GREEN}[DONE]${NC} $1"; }

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
  OS="mac"
  FONT_DIR="$HOME/Library/Fonts"
else
  OS="ubuntu"
  FONT_DIR="$HOME/.local/share/fonts"
fi

info "Detected OS: $OS"

# ohmyzsh
RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# powerlevel10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
  ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

cp ~/.zshrc ~/.zshrc.bak
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
sed -i 's/plugins=(git)/plugins=(\n  git\n  z\n  colored-man-pages\n  zsh-autosuggestions\n  zsh-syntax-highlighting\n)/' ~/.zshrc

curl -fsSL https://raw.githubusercontent.com/romkatv/powerlevel10k/master/config/p10k-classic.zsh \
  >~/.p10k.zsh

echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >>~/.zshrc

mkdir -p "$FONT_DIR"
BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
for f in "MesloLGS NF Regular.ttf" "MesloLGS NF Bold.ttf" \
  "MesloLGS NF Italic.ttf" "MesloLGS NF Bold Italic.ttf"; do
  curl -fsSLo "$FONT_DIR/$f" "$BASE/${f// /%20}"
done

if [[ "$OS" == "ubuntu" ]]; then
  fc-cache -fv &>/dev/null
fi
success "MesloLGS NF font installed"
