#!/bin/bash

set -e  # Exit on any error (except where we explicitly handle them)

# Colors for output
VIBE_GREEN='\033[0;32m'
VIBE_BLUE='\033[0;34m'
VIBE_YELLOW='\033[1;33m'
VIBE_RED='\033[0;31m'
VIBE_CYAN='\033[0;36m'
VIBE_BOLD='\033[1m'
NC='\033[0m' # No Color

TEMPLATE_REPO="hassanbazzi/dreamapp"

# Helper functions
print_header() {
    echo -e "\n${VIBE_BOLD}${VIBE_CYAN}╭─────────────────────────────────────────╮${NC}"
    echo -e "${VIBE_BOLD}${VIBE_CYAN}│${NC}  $1"
    echo -e "${VIBE_BOLD}${VIBE_CYAN}╰─────────────────────────────────────────╯${NC}\n"
}

print_step() {
    echo -e "${VIBE_BLUE}▶${NC} $1"
}

print_success() {
    echo -e "${VIBE_GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${VIBE_RED}✗${NC} $1"
}

print_warning() {
    echo -e "${VIBE_YELLOW}⚠${NC} $1"
}

clear
echo ""
echo -e "${VIBE_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${VIBE_BOLD}       ✨  DREAM APP INSTALLER  ✨${NC}"
echo -e "${VIBE_BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo "  This will set up everything you need to build"
echo "  apps with AI - no coding experience needed!"
echo ""
echo -e "${VIBE_CYAN}What you'll get:${NC}"
echo "  • An AI assistant that writes code for you"
echo "  • Your app published on the internet"
echo "  • User login & sign up built-in"
echo "  • A database to store your data"
echo "  • Everything connected and ready to use"
echo ""
echo "  Takes about 10-15 minutes, then you can start building!"
echo ""
echo -e "${VIBE_YELLOW}From getdreamapp.com with ❤️${NC}"
echo ""
read -p "Ready? Press Enter to start..." < /dev/tty

# ============================================
# 1. CHECK MACOS
# ============================================
print_header "Checking System"

print_step "Detecting operating system..."

if [[ "$OSTYPE" != "darwin"* ]]; then
  print_error "This installer only works on macOS"
  echo "Windows/Linux support coming soon!"
  exit 1
fi

print_success "macOS detected"

# ============================================
# 2. INSTALL XCODE COMMAND LINE TOOLS
# ============================================
print_step "Checking Xcode Command Line Tools..."

if ! xcode-select -p &>/dev/null; then
    print_warning "A popup will appear - click Install"
    xcode-select --install
    echo ""
    print_step "Waiting for Xcode tools to finish installing..."
    read -p "Press Enter once the installation completes..." < /dev/tty
fi

print_success "Xcode Command Line Tools ready"

# ============================================
# 3. INSTALL HOMEBREW
# ============================================
print_header "Installing Package Manager"

print_step "Checking for Homebrew..."

if ! command -v brew &>/dev/null; then
    print_step "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 2>&1 | grep -v "^$" | head -20
    
    # Add to PATH (for Apple Silicon Macs)
    if [[ $(uname -m) == 'arm64' ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/usr/local/bin/brew shellenv)"
    fi
    
    print_success "Homebrew installed"
else
    print_success "Homebrew already installed"
fi

# ============================================
# 4. INSTALL CORE TOOLS
# ============================================
print_header "Installing Development Tools"

print_step "Installing git, node, pnpm, and GitHub CLI..."
echo -e "${VIBE_YELLOW}  (This might take a few minutes - sit tight!)${NC}"

# Install tools via Homebrew (suppress already installed warnings)
brew install git node pnpm gh 2>&1 | grep -v "already installed" | grep -v "To reinstall" | grep -v "brew reinstall" | grep -E "^(Installing|Downloading|==>)" || true

print_success "Core tools installed"

print_step "Installing Vercel CLI..."
pnpm install -g vercel >/dev/null 2>&1

print_success "All development tools ready!"

# ============================================
# 5. INSTALL CURSOR
# ============================================
print_header "Installing Cursor"

echo ""
echo -e "${VIBE_CYAN}What is Cursor?${NC}"
echo "  Cursor is like a text editor, but with an AI assistant built-in."
echo "  You tell it what you want, and it writes the code for you!"
echo ""

print_step "Installing Cursor..."

if [ ! -d "/Applications/Cursor.app" ]; then
    brew install --cask cursor >/dev/null 2>&1
    print_success "Cursor installed"
else
    print_success "Cursor already installed"
fi

# ============================================
# 6. CONNECT GITHUB ACCOUNT
# ============================================
print_header "Connecting to GitHub"

echo ""
echo -e "${VIBE_CYAN}What is GitHub?${NC}"
echo "  GitHub is where the code that runs your app lives."
echo "  Think of it like Google Drive, but for code."
echo "  It keeps your app safe and tracks all your changes."
echo ""

# Check if already authenticated
if ! gh auth status &>/dev/null; then
    print_step "Signing in to GitHub..."
    echo -e "${VIBE_YELLOW}  (A browser window will open)${NC}"
    gh auth login
else
    print_success "Already signed in to GitHub"
fi

# Setup SSH if not exists
if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    echo ""
    read -p "Enter your email: " USER_EMAIL < /dev/tty
    print_step "Setting up secure connection..."
    ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -N "" >/dev/null 2>&1
    eval "$(ssh-agent -s)" >/dev/null 2>&1
    ssh-add "$HOME/.ssh/id_ed25519" 2>/dev/null
    
    # Add to GitHub
    gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "Dream App Key" 2>/dev/null
    print_success "Secure connection set up"
else
    print_success "Already connected securely"
fi

print_success "GitHub ready!"

# ============================================
# 7. CREATE PROJECT
# ============================================
print_header "Creating Your Project"

echo ""
echo "  Time to name your app!"
echo "  Give it any name you want - you can always change it later."
echo ""
echo -e "  ${VIBE_YELLOW}Examples: My Cool App, Todo List, Recipe Book${NC}"
echo ""

# Keep asking until we get a valid non-empty name
while true; do
    read -p "  What's your app called? " APP_TITLE < /dev/tty
    
    # Remove leading/trailing whitespace
    APP_TITLE=$(echo "$APP_TITLE" | xargs)
    
    if [ -n "$APP_TITLE" ]; then
        break
    fi
    
    echo -e "${VIBE_RED}✗ Please enter a name for your app${NC}"
    echo ""
done

# Create slug from title (lowercase, spaces to dashes, remove special chars)
APP_SLUG=$(echo "$APP_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')

echo ""
print_step "Setting up: ${APP_TITLE}"

# Clean up any existing temp directory
rm -rf /tmp/dreamapp-temp 2>/dev/null || true

# Clone the dreamapp repo temporarily
print_step "Downloading starter template..."
git clone --depth 1 --quiet "https://github.com/${TEMPLATE_REPO}.git" /tmp/dreamapp-temp 2>/dev/null

# Create new directory for user's project
mkdir -p "$APP_SLUG"

# Copy template contents to new project
cp -r /tmp/dreamapp-temp/template/. "$APP_SLUG/" 2>/dev/null

# Clean up
rm -rf /tmp/dreamapp-temp

cd "$APP_SLUG"

print_success "Template ready"

# Replace placeholder title in template files
print_step "Personalizing your app..."
# Update package.json name
sed -i '' "s/\"name\": \"dreamapp\"/\"name\": \"$APP_SLUG\"/" package.json 2>/dev/null || true
# Update page title (we'll add this to template later)
find . -name "*.tsx" -o -name "*.ts" -type f -exec sed -i '' "s/Dream App/$APP_TITLE/g" {} + 2>/dev/null || true

print_success "Personalized with your app name"

# Initialize git
print_step "Saving to GitHub..."
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "Initial commit: $APP_TITLE" >/dev/null 2>&1

# Create GitHub repo
gh repo create "$APP_SLUG" --private --source=. --remote=origin --push >/dev/null 2>&1

print_success "Saved to GitHub!"

# ============================================
# 8. INSTALL DEPENDENCIES
# ============================================
print_header "Setting Up Your App"

print_step "Installing required packages..."
echo -e "${VIBE_YELLOW}  (This takes a minute or two)${NC}"

pnpm install 2>&1 | grep -E "^(Progress|Done)" || pnpm install >/dev/null 2>&1

print_success "App is ready to run!"

# ============================================
# 9. CONNECT TO VERCEL
# ============================================
print_header "Connecting to Vercel"

echo ""
echo -e "${VIBE_CYAN}What is Vercel?${NC}"
echo "  Vercel is where your app runs on the internet."
echo "  It's like a computer in the cloud that's always on,"
echo "  so anyone can visit your app from anywhere in the world!"
echo ""

print_step "Connecting to Vercel..."
echo -e "${VIBE_YELLOW}  (A browser window will open)${NC}"

# This will prompt for login if needed and create the project
vercel link --yes 2>&1 | grep -E "Linked to|Success" || true

print_success "Connected to Vercel!"

# ============================================
# 10. SETUP DATABASE & USER ACCOUNTS
# ============================================
print_header "Setting Up Database & User Accounts"

echo ""
echo -e "${VIBE_CYAN}What is Supabase?${NC}"
echo "  Supabase gives your app two superpowers:"
echo "  1. A database - where your app stores all its data"
echo "  2. User accounts - so people can sign up and log in"
echo ""
echo "  Think of it like having a filing cabinet (database) and"
echo "  a guest list (user accounts) for your app!"
echo ""

print_step "Setting up your database and login system..."
echo -e "${VIBE_YELLOW}  (Setting up automatically - this may take a minute)${NC}"

# Install expect if not present (needed for automation)
if ! command -v expect &> /dev/null; then
    brew install expect >/dev/null 2>&1
fi

# Create expect script as a temporary file
EXPECT_SCRIPT=$(mktemp)
cat > "$EXPECT_SCRIPT" << 'EXPECTEOF'
#!/usr/bin/expect -f
set timeout 120

# Connect to actual terminal
set send_human {.1 .3 1 .05 2}

spawn vercel integration add supabase

expect {
    -re {What is the name of the resource} {
        send "$env(APP_SLUG)\r"
        # Wait for region prompt
        expect -re {Choose your region}
        # Wait for menu to fully render
        expect -re {iad1}
        # Type "fra" to filter to Frankfurt
        send "f"
        send "r"
        send "a"
        # Wait for fra1 to be SELECTED
        expect -re {❯.*fra1|fra1.*❯}
        send "\r"
        # Now handle NEXT_PUBLIC prefix prompt
        expect -re {NEXT_PUBLIC}
        send "\r"
        exp_continue
    }
    -re {Choose a billing plan} {
        # Wait for menu to render
        expect -re {Pro Plan}
        # Type "Supabase Free Plan" (case-sensitive)
        send "S"
        send "u"
        send "p"
        send "a"
        send "b"
        send "a"
        send "s"
        send "e"
        send " "
        send "F"
        send "r"
        send "e"
        send "e"
        # Wait for Supabase Free Plan to be selected
        expect -re {❯.*Supabase Free Plan|Supabase Free Plan.*❯}
        send "\r"
        # Handle confirmation prompt
        expect -re {Confirm selection}
        send "y\r"
        # Handle link to project prompt
        expect -re {link this resource}
        send "y\r"
        # Handle environment selection
        expect -re {Select environments}
        send "\r"
        exp_continue
    }
    eof
}
EXPECTEOF

chmod +x "$EXPECT_SCRIPT"

# Run expect script with environment variable and terminal access
if APP_SLUG="$APP_SLUG" expect "$EXPECT_SCRIPT" < /dev/tty > /dev/tty 2>&1; then
    rm -f "$EXPECT_SCRIPT"
    echo ""
    print_success "Database and user accounts ready!"
    echo -e "  ${VIBE_CYAN}Your app can now store data and let users sign in!${NC}"
    
    # Pull environment variables locally
    print_step "Syncing environment variables..."
    if vercel env pull .env.local >/dev/null 2>&1; then
        print_success "Environment variables synced!"
    else
        print_warning "Could not sync environment variables automatically"
        echo -e "  ${VIBE_CYAN}You can sync them later with: vercel env pull${NC}"
    fi
else
    rm -f "$EXPECT_SCRIPT"
    echo ""
    print_warning "Supabase setup encountered an issue"
    echo -e "  ${VIBE_CYAN}You can complete this later in your Vercel dashboard${NC}"
    echo -e "  Or run: ${VIBE_YELLOW}vercel integration add supabase${NC}"
fi

# ============================================
# 11. DEPLOY TO VERCEL
# ============================================
print_header "Publishing Your App"

print_step "Publishing your app to the internet..."
echo -e "${VIBE_YELLOW}  (Building with database connected - this may take a minute)${NC}"

# Deploy with environment variables now available
DEPLOY_URL=$(vercel --prod --yes 2>&1 | grep -o 'https://[^ ]*' | head -1)

print_success "Your app is live on the internet!"
echo -e "   ${VIBE_CYAN}🌐 ${DEPLOY_URL}${NC}"

# ============================================
# 12. CONFIGURE CURSOR EDITOR
# ============================================
if [ -d "/Applications/Cursor.app" ]; then
    print_header "Setting Up Cursor"
    
    print_step "Making Cursor easier to use..."
    
    # Create the symlink if it doesn't exist
    if [ ! -f "/usr/local/bin/cursor" ]; then
        # Make sure /usr/local/bin exists
        sudo mkdir -p /usr/local/bin 2>/dev/null || true
        
        # Create symlink to Cursor CLI
        sudo ln -sf "/Applications/Cursor.app/Contents/Resources/app/bin/cursor" /usr/local/bin/cursor 2>/dev/null
        
        print_success "Cursor is ready to use!"
    else
        print_success "Cursor already configured"
    fi
    
    # Make initialization script executable
    if [ -f ".vscode/init.sh" ]; then
        chmod +x .vscode/init.sh 2>/dev/null || true
    fi
    
    # Request accessibility permissions for automation
    print_step "Requesting accessibility permissions..."
    echo ""
    echo -e "${VIBE_YELLOW}  📋 macOS will ask if Cursor can control your computer${NC}"
    echo -e "${VIBE_YELLOW}  ✅ Please click 'OK' or 'Allow' to enable automation${NC}"
    echo -e "${VIBE_YELLOW}  (This lets Cursor automatically open your app)${NC}"
    echo ""
    
    # Trigger accessibility permission prompt
    osascript -e 'tell application "System Events" to keystroke ""' 2>/dev/null || {
        echo -e "${VIBE_CYAN}  ℹ️  If prompted, go to:${NC}"
        echo -e "${VIBE_CYAN}     System Settings → Privacy & Security → Accessibility${NC}"
        echo -e "${VIBE_CYAN}     And enable 'Cursor' or 'Terminal'${NC}"
    }
    
    sleep 2
    print_success "Accessibility configured"
fi

# ============================================
# 13. DONE! OPEN PROJECT
# ============================================
echo ""
echo -e "${VIBE_BOLD}${VIBE_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${VIBE_BOLD}${VIBE_GREEN}       ✨  ALL DONE! YOUR APP IS LIVE!  ✨${NC}"
echo -e "${VIBE_BOLD}${VIBE_GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Open in Cursor
if command -v cursor &>/dev/null; then
    cursor . >/dev/null 2>&1 &
else
    open -a Cursor .
fi

sleep 1
print_success "Cursor is opening with your project!"

echo ""
echo -e "${VIBE_BOLD}${VIBE_CYAN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${VIBE_BOLD}${VIBE_CYAN}║${NC}          WHERE TO FIND YOUR APP          ${VIBE_BOLD}${VIBE_CYAN}║${NC}"
echo -e "${VIBE_BOLD}${VIBE_CYAN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${VIBE_GREEN}🌐 On the internet:${NC}  ${VIBE_CYAN}${DEPLOY_URL}${NC}"
echo -e "  ${VIBE_GREEN}💻 On your computer:${NC} ${VIBE_CYAN}http://localhost:3000${NC}"
echo ""
echo -e "${VIBE_BOLD}${VIBE_CYAN}╔═══════════════════════════════════════════╗${NC}"
echo -e "${VIBE_BOLD}${VIBE_CYAN}║${NC}          WHAT HAPPENS NEXT              ${VIBE_BOLD}${VIBE_CYAN}║${NC}"
echo -e "${VIBE_BOLD}${VIBE_CYAN}╚═══════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${VIBE_GREEN}✨ Cursor opens automatically${NC}"
echo -e "  ${VIBE_GREEN}✨ Dev server starts${NC}"
echo -e "  ${VIBE_GREEN}✨ Browser opens with your app${NC}"
echo -e "  ${VIBE_GREEN}✨ Welcome page loads at localhost:3000${NC}"
echo -e "  ${VIBE_GREEN}✨ AI assistant ready to help${NC}"
echo ""
echo -e "  ${VIBE_CYAN}Just follow along and start building!${NC}"
echo ""
echo -e "${VIBE_YELLOW}Have fun building ${APP_TITLE}! 🎨✨${NC}"
echo ""

