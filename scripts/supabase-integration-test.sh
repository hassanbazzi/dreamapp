#!/bin/bash
set -euo pipefail

APP_SLUG="${1:-test-app}"
REGION="${REGION:-fra1}"
PLAN="${PLAN:-Supabase Free Plan}"

echo ""
echo "[info] Starting Supabase integration dry-run"
echo "       resource : ${APP_SLUG}"
echo "       region   : ${REGION}"
echo "       plan     : ${PLAN}"
echo ""

EXPECT_SCRIPT="$(mktemp)"
trap 'rm -f "$EXPECT_SCRIPT"' EXIT

cat >"$EXPECT_SCRIPT" <<'EXPECTEOF'
#!/usr/bin/expect -f
set timeout 120

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
        sleep 0.3
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

# Run expect script with TTY access (critical for interactive CLI)
if APP_SLUG="$APP_SLUG" REGION="$REGION" PLAN="$PLAN" expect "$EXPECT_SCRIPT" < /dev/tty > /dev/tty 2>&1; then
    echo ""
    echo "[info] Test script finished successfully."
else
    echo ""
    echo "[error] Test script failed."
    exit 1
fi

