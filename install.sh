#!/bin/bash

set -e  # Exit on any error (except where we explicitly handle them)

# Colors for output
VIBE_GREEN='\033[0;32m'
VIBE_BLUE='\033[0;34m'
VIBE_YELLOW='\033[1;33m'
VIBE_RED='\033[0;31m'
NC='\033[0m' # No Color

TEMPLATE_REPO="hassanbazzi/dreamapp"

clear
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  ✨ DREAM APP INSTALLER"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This will set up everything you need to build"
echo "production apps with AI assistance."
echo ""
echo "What this installs:"
echo "  • Node.js & pnpm (to run your app)"
echo "  • Git & GitHub CLI (version control)"
echo "  • Cursor (AI code editor)"
echo "  • Vercel CLI (deployment)"
echo ""
echo "Then creates your app, deploys it, and sets up"
echo "Supabase database via Vercel integration!"
echo ""
echo "From getdreamapp.com with ❤️"
echo ""
read -p "Ready? Press Enter to start..."

# ============================================
# 1. CHECK MACOS
# ============================================
echo ""
echo "${VIBE_BLUE}🔍 Checking system...${NC}"

if [[ "$OSTYPE" != "darwin"* ]]; then
  echo "${VIBE_RED}❌ This installer only works on macOS${NC}"
  echo "Windows/Linux support coming soon!"
  exit 1
fi

echo "✅ macOS detected"

# ============================================
# 2. INSTALL XCODE COMMAND LINE TOOLS
# ============================================
echo ""
echo "${VIBE_BLUE}📦 Checking Xcode Command Line Tools...${NC}"

if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    echo "${VIBE_YELLOW}⚠️  A popup will appear - click Install${NC}"
    xcode-select --install
    echo ""
    echo "⏳ Waiting for Xcode tools to finish installing..."
    read -p "Press Enter once the installation completes..."
fi

echo "✅ Xcode tools ready"

# ============================================
# 3. INSTALL HOMEBREW
# ============================================
echo ""
echo "${VIBE_BLUE}🍺 Checking Homebrew...${NC}"

if ! command -v brew &>/dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add to PATH (for Apple Silicon Macs)
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    echo "✅ Homebrew installed"
else
    echo "✅ Homebrew already installed"
fi

# ============================================
# 4. INSTALL CORE TOOLS
# ============================================
echo ""
echo "${VIBE_BLUE}🔧 Installing development tools...${NC}"
echo "(This might take a few minutes)"

# Install tools via Homebrew
brew install git node pnpm gh

# Install Vercel CLI via pnpm
echo "Installing Vercel CLI..."
pnpm install -g vercel

echo "✅ All tools installed"

# ============================================
# 5. INSTALL CURSOR
# ============================================
echo ""
echo "${VIBE_BLUE}💻 Installing Cursor...${NC}"

if [ ! -d "/Applications/Cursor.app" ]; then
    brew install --cask cursor
    echo "✅ Cursor installed"
else
    echo "✅ Cursor already installed"
fi

# ============================================
# 6. SETUP GITHUB
# ============================================
echo ""
echo "${VIBE_BLUE}🐙 Setting up GitHub...${NC}"

# Check if already authenticated
if ! gh auth status &>/dev/null; then
    echo "Let's connect your GitHub account..."
    echo "(A browser window will open for login)"
    gh auth login
else
    echo "✅ Already logged into GitHub"
fi

# Setup SSH if not exists
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo ""
    read -p "Enter your email for SSH key: " USER_EMAIL
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -N ""
    eval "$(ssh-agent -s)"
    ssh-add "$HOME/.ssh/id_ed25519"
    
    # Add to GitHub
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "Dream App Key"
    echo "✅ SSH key added to GitHub"
else
    echo "✅ SSH key already exists"
fi

echo "✅ GitHub connected"

# ============================================
# 7. CREATE PROJECT
# ============================================
echo ""
echo "${VIBE_BLUE}🎨 Creating your project...${NC}"
echo ""
read -p "What do you want to call your app? (e.g., my-cool-app): " APP_NAME

# Sanitize app name
APP_NAME=$(echo "$APP_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')

echo ""
echo "Creating project: ${APP_NAME}"

# Clone the dreamapp repo temporarily
echo "Downloading template..."
git clone --depth 1 "https://github.com/${TEMPLATE_REPO}.git" /tmp/dreamapp-temp

# Create new directory for user's project
mkdir -p "$APP_NAME"

# Copy template contents to new project
cp -r /tmp/dreamapp-temp/template/. "$APP_NAME/"

# Clean up
rm -rf /tmp/dreamapp-temp

cd "$APP_NAME"

# Initialize git
git init
git add .
git commit -m "Initial commit from Dream App"

# Create GitHub repo
echo "Creating GitHub repository..."
gh repo create "$APP_NAME" --private --source=. --remote=origin --push

echo "✅ Project created"

# ============================================
# 8. INSTALL DEPENDENCIES
# ============================================
echo ""
echo "${VIBE_BLUE}📦 Installing project dependencies...${NC}"
echo "(This will take a minute or two)"

pnpm install

echo "✅ Dependencies installed"

# ============================================
# 9. DEPLOY TO VERCEL
# ============================================
echo ""
echo "${VIBE_BLUE}🚀 Deploying to Vercel...${NC}"
echo ""
echo "A browser window will open for Vercel login..."

# This will prompt for login if needed
vercel link --yes

# Deploy
echo ""
echo "Deploying your app..."
DEPLOY_URL=$(vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*' | head -1)

echo "✅ Deployed to Vercel"

# ============================================
# 10. SETUP SUPABASE (VIA VERCEL INTEGRATION)
# ============================================
echo ""
echo "${VIBE_BLUE}🗄️  Setting up Supabase...${NC}"
echo ""
echo "${VIBE_YELLOW}📝 Next steps (will open automatically):${NC}"
echo ""
echo "1. Your Vercel dashboard will open"
echo "2. Go to your project → Settings → Integrations"
echo "3. Search for 'Supabase' and click 'Add Integration'"
echo "4. It will automatically create a Supabase project"
echo "5. All environment variables will be set automatically!"
echo ""
read -p "Press Enter to open Vercel dashboard..."

# Open Vercel project dashboard
open "https://vercel.com/dashboard"

echo ""
echo "${VIBE_GREEN}✅ Once you add the Supabase integration, you're done!${NC}"
echo ""

# ============================================
# 11. INSTALL CURSOR SHELL COMMAND
# ============================================
if [ -d "/Applications/Cursor.app" ]; then
    echo ""
    echo "${VIBE_BLUE}🔧 Setting up Cursor shell command...${NC}"
    echo ""
    echo "${VIBE_YELLOW}⚠️  We need to enable the 'cursor' command${NC}"
    echo ""
    echo "Cursor will open now. Please:"
    echo "  1. Press Cmd+Shift+P"
    echo "  2. Type: shell command"
    echo "  3. Select: 'Shell Command: Install cursor command in PATH'"
    echo "  4. Close Cursor when done"
    echo ""
    read -p "Press Enter to open Cursor..."

    open -a Cursor .

    read -p "Press Enter once you've installed the shell command..."

    echo "✅ Cursor command ready"
fi

# ============================================
# 13. DONE! OPEN PROJECT
# ============================================
echo ""
echo "${VIBE_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo "${VIBE_GREEN}  ✨ ALL DONE! ✨${NC}"
echo "${VIBE_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Open in Cursor
if command -v cursor &>/dev/null; then
    cursor .
else
    open -a Cursor .
fi

echo ""
echo "✨ Cursor is now opening with your project!"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "YOUR APP IS LIVE!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "🌐 Live URL: ${DEPLOY_URL}"
echo "💻 Local: http://localhost:3000"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "NEXT STEPS IN CURSOR:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "1. The dev server will start automatically"
echo "2. Press Cmd+L to open Agent mode"
echo "3. Type: @Browser open http://localhost:3000"
echo "4. Start building!"
echo ""
echo "📖 Read WELCOME.md (already open) for full guide"
echo ""
echo "Happy vibing! 🎨✨"
echo ""

