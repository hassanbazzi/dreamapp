#!/bin/bash

# Wait for dev server to be ready
echo "⏳ Waiting for dev server to start..."
sleep 5

# Get the current Cursor window
osascript <<EOF
tell application "Cursor"
    activate
end tell

tell application "System Events"
    tell process "Cursor"
        # Wait a moment for Cursor to be active
        delay 1
        
        # Open Command Palette (Cmd+Shift+P)
        keystroke "p" using {command down, shift down}
        delay 0.8
        
        # Type and execute simple browser command
        keystroke "Simple Browser: Show"
        delay 0.5
        keystroke return
        delay 1
        
        # Type the localhost URL
        keystroke "http://localhost:3000"
        delay 0.3
        keystroke return
    end tell
end tell
EOF

echo "✅ Workspace initialized!"

