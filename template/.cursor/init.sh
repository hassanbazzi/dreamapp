#!/bin/bash

# Wait for Cursor to fully load
sleep 3

# Open browser using AppleScript to trigger Cmd+Shift+P and run command
osascript <<EOF
tell application "System Events"
    # Wait a moment for Cursor to be ready
    delay 2
    
    # Open command palette (Cmd+Shift+P)
    keystroke "p" using {command down, shift down}
    delay 0.5
    
    # Type "Open Browser" command
    keystroke "Cursor: Open Browser"
    delay 0.3
    keystroke return
    delay 1
    
    # Open Composer (Cmd+L)
    keystroke "l" using {command down}
    delay 1
    
    # Type the initial message
    keystroke "Let's get started! Show me my app in the browser."
end tell
EOF

