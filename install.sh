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
echo "  Takes about 5 minutes, then you can start building!"
echo ""
echo -e "${VIBE_YELLOW}From getdreamapp.com with ❤️${NC}"
echo ""
read -p "Ready? Press Enter to start..." < /dev/tty

# ============================================
# 0. REQUEST ADMIN ACCESS UPFRONT
# ============================================
echo ""
print_step "Requesting admin access..."
echo -e "${VIBE_YELLOW}  This will ask for your Mac password once${NC}"
echo ""

# Request sudo access upfront and keep it alive
if sudo -v; then
    print_success "Admin access granted"
    
    # Keep sudo alive in background (updates timestamp every 60 seconds)
    # This prevents password re-prompts during the installation
    (while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null) &
    SUDO_KEEPER_PID=$!
    
    # Cleanup function to kill the sudo keeper when script exits
    trap "kill $SUDO_KEEPER_PID 2>/dev/null || true" EXIT
else
    print_error "Admin access required to install tools"
    echo ""
    echo -e "${VIBE_CYAN}This installer needs admin access to:${NC}"
    echo "  • Install Homebrew (package manager)"
    echo "  • Install development tools"
    echo "  • Configure Cursor"
    echo ""
    exit 1
fi

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
    
    # Run Homebrew installer (sudo already authorized at script start)
    # Use NONINTERACTIVE=1 to skip prompts since we have sudo
    if NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        print_step "Adding Homebrew to PATH..."
        
        # Determine Homebrew path based on architecture
        if [[ $(uname -m) == 'arm64' ]]; then
            BREW_PATH="/opt/homebrew"
        else
            BREW_PATH="/usr/local"
        fi
        
        # Add to shell profile files (both zsh and bash)
        BREW_INIT='eval "$('$BREW_PATH'/bin/brew shellenv)"'
        
        # Add to .zprofile if not already there
        if ! grep -q "brew shellenv" ~/.zprofile 2>/dev/null; then
            echo "$BREW_INIT" >> ~/.zprofile
        fi
        
        # Add to .zshrc if not already there (for interactive shells)
        if ! grep -q "brew shellenv" ~/.zshrc 2>/dev/null; then
            echo "$BREW_INIT" >> ~/.zshrc
        fi
        
        # Load into current shell session immediately
        eval "$($BREW_PATH/bin/brew shellenv)"
        export PATH="$BREW_PATH/bin:$PATH"
        
        # Verify brew is now available
        if command -v brew &>/dev/null; then
            print_success "Homebrew installed and added to PATH"
        else
            print_error "Homebrew installation completed but command not found"
            echo ""
            echo -e "${VIBE_YELLOW}Please restart your terminal and run this script again.${NC}"
            exit 1
        fi
    else
        echo ""
        print_error "Homebrew installation failed"
        echo ""
        echo -e "${VIBE_CYAN}Common causes:${NC}"
        echo "  • Your user account needs Administrator access"
        echo "  • Ask the Mac owner to grant you admin rights"
        echo ""
        echo -e "${VIBE_CYAN}To check if you're an admin:${NC}"
        echo "  1. Open System Settings"
        echo "  2. Go to Users & Groups"
        echo "  3. Make sure '$(whoami)' shows 'Admin' below the name"
        echo ""
        echo "After getting admin access, run this installer again."
        echo ""
        exit 1
    fi
else
    print_success "Homebrew already installed"
fi

# ============================================
# 4. INSTALL CORE TOOLS
# ============================================
print_header "Installing Development Tools"

print_step "Installing git, node, pnpm, and GitHub CLI..."
echo -e "${VIBE_YELLOW}  (This might take a few minutes - sit tight!)${NC}"

# Install tools via Homebrew (suppress output to keep it clean)
brew install git node pnpm gh >/dev/null 2>&1 || {
    # If install fails, show output for debugging
    echo ""
    print_warning "Some tools may already be installed, continuing..."
    brew install git node pnpm gh 2>&1 | grep -E "(Error|Warning)" || true
}

# Ensure newly installed tools are in PATH
hash -r 2>/dev/null || true

# Verify critical tools are available
if ! command -v pnpm &>/dev/null; then
    print_error "pnpm installation failed"
    echo ""
    echo -e "${VIBE_CYAN}Trying to fix...${NC}"
    brew link pnpm 2>&1
    hash -r 2>/dev/null || true
    
    if ! command -v pnpm &>/dev/null; then
        print_error "Cannot find pnpm. Please restart terminal and run script again."
        exit 1
    fi
fi

print_success "Core tools installed"

print_step "Configuring pnpm..."
# Setup pnpm global bin directory
if pnpm setup >/dev/null 2>&1; then
    # Source the updated PATH from pnpm setup
    if [[ -f "$HOME/.zshrc" ]]; then
        # Extract and evaluate the PNPM_HOME setup from .zshrc
        if grep -q "PNPM_HOME" "$HOME/.zshrc" 2>/dev/null; then
            export PNPM_HOME="$HOME/Library/pnpm"
            export PATH="$PNPM_HOME:$PATH"
        fi
    fi
    print_success "pnpm configured"
else
    print_warning "pnpm setup had issues, setting up manually..."
    # Manually configure PNPM_HOME
    export PNPM_HOME="$HOME/Library/pnpm"
    mkdir -p "$PNPM_HOME"
    export PATH="$PNPM_HOME:$PATH"
    
    # Add to shell profiles if not already there
    if ! grep -q "PNPM_HOME" ~/.zshrc 2>/dev/null; then
        echo 'export PNPM_HOME="$HOME/Library/pnpm"' >> ~/.zshrc
        echo 'export PATH="$PNPM_HOME:$PATH"' >> ~/.zshrc
    fi
    print_success "pnpm configured manually"
fi

print_step "Installing Vercel CLI..."
if pnpm install -g vercel >/dev/null 2>&1; then
    print_success "Vercel CLI installed"
else
    print_warning "Vercel CLI installation had issues, retrying with verbose output..."
    if pnpm install -g vercel; then
        print_success "Vercel CLI installed"
    else
        print_error "Vercel CLI installation failed"
        echo ""
        echo -e "${VIBE_CYAN}You can install it later with: pnpm install -g vercel${NC}"
        echo ""
    fi
fi

print_success "All development tools ready!"

# Reload shell environment to pick up all new PATH changes
print_step "Refreshing shell environment..."
# Source all the config files we've been updating
if [ -f "$HOME/.zshrc" ]; then
    source "$HOME/.zshrc" 2>/dev/null || true
fi
if [ -f "$HOME/.zprofile" ]; then
    source "$HOME/.zprofile" 2>/dev/null || true
fi
# Ensure PATH updates are applied
hash -r 2>/dev/null || true
print_success "Environment refreshed"

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
# 6. CREATE PROJECT DIRECTORY
# ============================================
print_header "Creating Your Project"

echo ""
echo "  Time to name your app!"
echo "  Give it any name you want - you can always change it later."
echo ""
echo -e "  ${VIBE_YELLOW}Examples: My Cool App, Todo List, Recipe Book${NC}"
echo ""

# Keep asking until we get a valid unique name
while true; do
    read -p "  What's your app called? " APP_TITLE < /dev/tty
    
    # Remove leading/trailing whitespace
    APP_TITLE=$(echo "$APP_TITLE" | xargs)
    
    if [ -z "$APP_TITLE" ]; then
        echo -e "${VIBE_RED}✗ Please enter a name for your app${NC}"
        echo ""
        continue
    fi
    
    # Create slug from title (lowercase, spaces to dashes, remove special chars)
    APP_SLUG=$(echo "$APP_TITLE" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | sed 's/[^a-z0-9-]//g')
    
    # Check if directory already exists
    if [ -d "$APP_SLUG" ]; then
        echo -e "${VIBE_RED}✗ A folder named '$APP_SLUG' already exists${NC}"
        echo -e "${VIBE_CYAN}  Please choose a different name${NC}"
        echo ""
        continue
    fi
    
    # Valid and unique name!
    break
done

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

# Clean up temp directory
rm -rf /tmp/dreamapp-temp

# CD into project directory - all subsequent steps happen here
cd "$APP_SLUG"

print_success "Project directory created: $APP_SLUG"

# Replace placeholder title in template files
print_step "Personalizing your app..."
# Update package.json name
sed -i '' "s/\"name\": \"dreamapp\"/\"name\": \"$APP_SLUG\"/" package.json 2>/dev/null || true
# Update page title
find . -name "*.tsx" -o -name "*.ts" -type f -exec sed -i '' "s/Dream App/$APP_TITLE/g" {} + 2>/dev/null || true

print_success "Template ready and personalized"

# Initialize git repository
print_step "Initializing git repository..."
git init >/dev/null 2>&1
git add . >/dev/null 2>&1
git commit -m "Initial commit: $APP_TITLE" >/dev/null 2>&1
print_success "Git repository initialized"

# ============================================
# 7. CONNECT GITHUB ACCOUNT
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
    echo ""
    if gh auth login -s admin:public_key; then
        print_success "Signed in to GitHub"
    else
        print_error "Failed to sign in to GitHub"
        echo ""
        echo -e "${VIBE_CYAN}You can complete this later by running: gh auth login${NC}"
        exit 1
    fi
else
    print_success "Already signed in to GitHub"
    
    # Ensure we have the necessary scope for SSH key management
    print_step "Verifying GitHub permissions..."
    set +e
    gh auth refresh -h github.com -s admin:public_key >/dev/null 2>&1
    REFRESH_EXIT=$?
    set -e
    
    if [ $REFRESH_EXIT -eq 0 ]; then
        print_success "GitHub permissions updated"
    else
        print_warning "Could not update GitHub permissions automatically"
        echo -e "${VIBE_CYAN}A browser window will open to grant additional permissions${NC}"
        echo ""
        read -p "Press Enter to continue..." < /dev/tty
        gh auth refresh -h github.com -s admin:public_key
    fi
fi

# Setup SSH if not properly configured
print_step "Checking SSH connection to GitHub..."

# Add GitHub to known_hosts if not already there (avoids interactive prompt)
if ! grep -q "github.com" "$HOME/.ssh/known_hosts" 2>/dev/null; then
    mkdir -p "$HOME/.ssh"
    ssh-keyscan -t ed25519 github.com >> "$HOME/.ssh/known_hosts" 2>/dev/null
fi

# Test if SSH to GitHub works
if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
    print_success "SSH connection verified"
else
    print_step "Setting up SSH key for GitHub..."
    
    # Get user's email (try from git config first)
    USER_EMAIL=$(git config --global user.email 2>/dev/null || echo "")
    
    if [ -z "$USER_EMAIL" ]; then
        echo ""
        echo -e "${VIBE_CYAN}We need your email to set up GitHub${NC}"
        read -p "Enter your email: " USER_EMAIL < /dev/tty
        echo ""
        
        # Set git config for future use
        if [ -n "$USER_EMAIL" ]; then
            print_step "Configuring git..."
            git config --global user.email "$USER_EMAIL" 2>/dev/null || true
            # Also set a default name if not set
            if [ -z "$(git config --global user.name 2>/dev/null || echo "")" ]; then
                git config --global user.name "$(whoami)" 2>/dev/null || true
            fi
            print_success "Git configured"
        else
            print_warning "No email provided, using default"
            USER_EMAIL="user@example.com"
        fi
    else
        print_success "Using email from git config: $USER_EMAIL"
    fi
    
    # Generate SSH key if it doesn't exist
    print_step "Generating SSH key..."
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
        mkdir -p "$HOME/.ssh"
        if ssh-keygen -t ed25519 -C "$USER_EMAIL" -f "$HOME/.ssh/id_ed25519" -N "" >/dev/null 2>&1; then
            print_success "SSH key generated"
        else
            print_error "Failed to generate SSH key"
            exit 1
        fi
    else
        print_success "SSH key already exists"
    fi
    
    # Start ssh-agent and add key
    print_step "Adding key to SSH agent..."
    eval "$(ssh-agent -s)" >/dev/null 2>&1
    if ssh-add "$HOME/.ssh/id_ed25519" >/dev/null 2>&1; then
        print_success "Key added to SSH agent"
    else
        print_warning "Could not add key to SSH agent, continuing..."
    fi
    
    # Add key to GitHub
    print_step "Adding SSH key to GitHub..."
    
    # Temporarily disable exit-on-error for this command
    set +e
    ADD_KEY_OUTPUT=$(gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "Dream App Key" 2>&1)
    ADD_KEY_EXIT=$?
    set -e
    
    # If we got a permission error, try refreshing the token
    if [ $ADD_KEY_EXIT -ne 0 ] && echo "$ADD_KEY_OUTPUT" | grep -qi "admin:public_key"; then
        print_step "Requesting additional GitHub permissions..."
        echo -e "${VIBE_CYAN}A browser window will open to grant SSH key permissions${NC}"
        echo ""
        
        set +e
        gh auth refresh -h github.com -s admin:public_key
        REFRESH_EXIT=$?
        set -e
        
        if [ $REFRESH_EXIT -eq 0 ]; then
            print_success "Permissions granted, retrying..."
            # Try adding the key again
            set +e
            ADD_KEY_OUTPUT=$(gh ssh-key add "$HOME/.ssh/id_ed25519.pub" -t "Dream App Key" 2>&1)
            ADD_KEY_EXIT=$?
            set -e
        fi
    fi
    
    if [ $ADD_KEY_EXIT -eq 0 ]; then
        print_success "SSH key added to GitHub"
        
        # Verify it works now
        sleep 2  # Give GitHub a moment to register the key
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            print_success "SSH connection verified"
        else
            print_warning "SSH key added but connection test failed"
            echo -e "${VIBE_CYAN}This might work anyway, continuing...${NC}"
        fi
    elif echo "$ADD_KEY_OUTPUT" | grep -qi "already exists\|already been taken\|key is already in use"; then
        # Key already exists in GitHub - that's fine!
        print_success "SSH key already in GitHub"
        
        # Verify it works
        if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
            print_success "SSH connection verified"
        else
            print_warning "SSH key exists but connection test failed"
            echo -e "${VIBE_CYAN}Trying to continue anyway...${NC}"
        fi
    else
        print_warning "Could not add SSH key automatically"
        echo ""
        echo -e "${VIBE_YELLOW}Error: $ADD_KEY_OUTPUT${NC}"
        echo ""
        echo -e "${VIBE_CYAN}You can add it manually at: https://github.com/settings/keys${NC}"
        echo -e "${VIBE_CYAN}Your public key is at: $HOME/.ssh/id_ed25519.pub${NC}"
        echo ""
        read -p "Press Enter once you've added the key..." < /dev/tty
    fi
fi

print_success "GitHub ready!"

# Push project to GitHub
print_step "Saving to GitHub..."

# Temporarily disable exit-on-error
set +e
REPO_OUTPUT=$(gh repo create "$APP_SLUG" --private --source=. --remote=origin --push 2>&1)
REPO_EXIT=$?
set -e

if [ $REPO_EXIT -eq 0 ]; then
    print_success "Saved to GitHub!"
else
    print_warning "GitHub push had issues"
    echo ""
    echo -e "${VIBE_YELLOW}Error: $REPO_OUTPUT${NC}"
    echo ""
    echo -e "${VIBE_CYAN}Your project is created locally, you can push it later with:${NC}"
    echo -e "${VIBE_CYAN}  cd $APP_SLUG && git push -u origin main${NC}"
    echo ""
fi

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

