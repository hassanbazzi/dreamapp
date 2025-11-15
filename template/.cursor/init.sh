#!/bin/bash

# Wait for Cursor to fully load and WELCOME.md to open
sleep 3

# Run Cursor commands using AppleScript
osascript <<EOF
tell application "System Events"
    # Wait for Cursor to be ready
    delay 2
    
    # Open markdown preview (Cmd+Shift+P)
    keystroke "p" using {command down, shift down}
    delay 0.5
    keystroke "markdown show preview"
    delay 0.5
    keystroke return
    delay 1
    
    # Open browser tab (Cmd+Shift+P)
    keystroke "p" using {command down, shift down}
    delay 0.5
    keystroke "open browser tab"
    delay 0.5
    keystroke return
    delay 2
    
    # Open Composer (Cmd+L)
    keystroke "l" using {command down}
    delay 1
    
    # Type the initial message
    keystroke "Let's get started! Show me my app in the browser."
end tell
EOF

